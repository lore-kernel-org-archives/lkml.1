Return-Path: <linux-kernel-owner+w=401wt.eu-S1757340AbYHAJwI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340AbYHAJwI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 05:52:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751158AbYHAJvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 05:51:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44155 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934AbYHAJvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 05:51:53 -0400
Date: Fri, 1 Aug 2008 11:51:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Wim Van Sebroeck <wim@iguana.be>,
       =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>,
       Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "drepper@redhat.com" <drepper@redhat.com>,
       "mikpe@it.uu.se" <mikpe@it.uu.se>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/9] x86, xsave: xsave/xrstor support
Message-ID: <20080801095105.GA18055@elte.hu>
References: <20080730100326.GA9683@elte.hu> <20080730182539.GA17140@elte.hu> <20080730234102.GF11223@linux-os.sc.intel.com> <20080731212915.GH2729@elte.hu> <20080731215808.GB8563@linux-os.sc.intel.com> <20080731221435.GS23938@one.firstfloor.org> <20080731221924.GD8563@linux-os.sc.intel.com> <alpine.LFD.1.10.0807311531271.3277@nehalem.linux-foundation.org> <20080731225004.GD22426@elte.hu> <48926FC3.3000706@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48926FC3.3000706@keyaccess.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rene Herman <rene.herman@keyaccess.nl> wrote:

> On 01-08-08 00:50, Ingo Molnar wrote:
>
>> there are a handful of old ISA-ish drivers that can crash randconfig  
>> kernels in various ways. [indefinite lockups, crashes, stomped-over  
>> hardware, non-working keyboard, etc.]
>>
>> I mapped most of them out via many months of trial-and-error - but it  
>> would still be nice to have some separate config option to disable the  
>> known ones. CONFIG_ALLOW_NON_GENERIC or something like that - which i  
>> would unset in the randconfig runs.
>>
>> ( They are not CONFIG_BROKEN per se, because often it's hardware that
>>   cannot be probed in any reliable way - the driver just assumes it's   
>> there. )
>
> If you have a list, I might be able to do something about some of 
> them.

find attached below a newer version of the original list i published 
half a year ago:

   http://people.redhat.com/mingo/auto-qa-patches/Kconfig-qa.patch

these are just pragmatic local hacks to get things going. (There are 
more per machine quirks as well.)

i have not used a BROKEN annotation because CONFIG_BROKEN is 
impractical: it just kills code altogether, indiscriminately. There's no 
way for users to enable CONFIG_BROKEN in the upstream kernel - nothing 
selects it and it's not an interactive option either.

So by all means if we mark a driver or a kernel feature as 
CONFIG_BROKEN, it's killed altogether for all practical purposes.

What we'd need is some more gradual approach: for example a way to mark 
"drivers that are not expected to boot on a whitebox PC", without 
removing them altogether via a CONFIG_BROKEN dependency - often it's 
hardware that cannot be probed safely.

	Ingo

------------------>
Index: linux/security/smack/Kconfig
===================================================================
--- linux.orig/security/smack/Kconfig
+++ linux/security/smack/Kconfig
@@ -1,6 +1,9 @@
 config SECURITY_SMACK
 	bool "Simplified Mandatory Access Control Kernel Support"
 	depends on NETLABEL && SECURITY_NETWORK
+	# breaks networking (TCP connections)
+	depends on BROKEN_BOOT_ALLOWED
+	select BROKEN_BOOT
 	default n
 	help
 	  This selects the Simplified Mandatory Access Control Kernel.
Index: linux/drivers/block/Kconfig
===================================================================
--- linux.orig/drivers/block/Kconfig
+++ linux/drivers/block/Kconfig
@@ -71,6 +71,11 @@ config BLK_DEV_XD
 config PARIDE
 	tristate "Parallel port IDE device support"
 	depends on PARPORT_PC
+
+	# the probe can hang during bootup on non-PARIDE boxes
+	depends on BROKEN_BOOT_ALLOWED
+	select BROKEN_BOOT if PARIDE = y
+
 	---help---
 	  There are many external CD-ROM and disk devices that connect through
 	  your computer's parallel port. Most of them are actually IDE devices
Index: linux/drivers/i2c/busses/Kconfig
===================================================================
--- linux.orig/drivers/i2c/busses/Kconfig
+++ linux/drivers/i2c/busses/Kconfig
@@ -610,6 +610,11 @@ config I2C_ELEKTOR
 config I2C_PCA_ISA
 	tristate "PCA9564 on an ISA bus"
 	depends on ISA
+
+	# takes away IRQ10 on venus and thus breaks e1000
+	depends on BROKEN_BOOT_ALLOWED
+	select BROKEN_BOOT
+
 	select I2C_ALGOPCA
 	default n
 	help
Index: linux/drivers/ide/Kconfig
===================================================================
--- linux.orig/drivers/ide/Kconfig
+++ linux/drivers/ide/Kconfig
@@ -9,6 +9,11 @@ config HAVE_IDE
 menuconfig IDE
 	tristate "ATA/ATAPI/MFM/RLL support"
 	depends on HAVE_IDE
+
+	# my test box expects /dev/sda, not /dev/hda
+	depends on BROKEN_BOOT_ALLOWED
+	select BROKEN_BOOT if IDE = y
+
 	depends on BLOCK
 	---help---
 	  If you say Y here, your kernel will be able to manage low cost mass
Index: linux/drivers/isdn/icn/Kconfig
===================================================================
--- linux.orig/drivers/isdn/icn/Kconfig
+++ linux/drivers/isdn/icn/Kconfig
@@ -4,6 +4,11 @@
 config ISDN_DRV_ICN
 	tristate "ICN 2B and 4B support"
 	depends on ISA
+
+	# crashed on venus, see config-Sun_May_25_11_00_41_CEST_2008.bad
+	depends on BROKEN_BOOT_ALLOWED
+	select BROKEN_BOOT
+
 	help
 	  This enables support for two kinds of ISDN-cards made by a German
 	  company called ICN.  2B is the standard version for a single ISDN
Index: linux/drivers/media/video/Kconfig
===================================================================
--- linux.orig/drivers/media/video/Kconfig
+++ linux/drivers/media/video/Kconfig
@@ -481,6 +481,9 @@ config VIDEO_SAA6588
 config VIDEO_PMS
 	tristate "Mediavision Pro Movie Studio Video For Linux"
 	depends on ISA && VIDEO_V4L1
+	# hung on bootup on mars, see config-Wed_Jun__4_14_33_56_CEST_2008.bad
+	depends on BROKEN_BOOT_ALLOWED
+	select BROKEN_BOOT
 	help
 	  Say Y if you have such a thing.
 
Index: linux/drivers/mtd/Kconfig
===================================================================
--- linux.orig/drivers/mtd/Kconfig
+++ linux/drivers/mtd/Kconfig
@@ -1,6 +1,11 @@
 menuconfig MTD
 	tristate "Memory Technology Device (MTD) support"
 	depends on HAS_IOMEM
+
+	# dangerous to enable - sometimes hangs on probe
+	depends on BROKEN_BOOT_ALLOWED
+	select BROKEN_BOOT if MTD = y
+
 	help
 	  Memory Technology Devices are flash, RAM and similar chips, often
 	  used for solid state file systems on embedded devices. This option
Index: linux/drivers/net/appletalk/Kconfig
===================================================================
--- linux.orig/drivers/net/appletalk/Kconfig
+++ linux/drivers/net/appletalk/Kconfig
@@ -52,6 +52,11 @@ config LTPC
 config COPS
 	tristate "COPS LocalTalk PC support"
 	depends on DEV_APPLETALK && (ISA || EISA)
+	#
+	# Can hang
+	#
+	depends on BROKEN_BOOT_ALLOWED
+	select BROKEN_BOOT if COPS = y
 	help
 	  This allows you to use COPS AppleTalk cards to connect to LocalTalk
 	  networks. You also need version 1.3.3 or later of the netatalk
Index: linux/drivers/scsi/Kconfig
===================================================================
--- linux.orig/drivers/scsi/Kconfig
+++ linux/drivers/scsi/Kconfig
@@ -1520,6 +1520,11 @@ config SCSI_NSP32
 config SCSI_DEBUG
 	tristate "SCSI debugging host simulator"
 	depends on SCSI
+
+	# this creates a fake /dev/sda which confuses the bzImage bootup
+	depends on BROKEN_BOOT_ALLOWED
+	select BROKEN_BOOT if SCSI_DEBUG = y
+
 	help
 	  This is a host adapter simulator that can simulate multiple hosts
 	  each with multiple dummy SCSI devices (disks). It defaults to one
Index: linux/drivers/video/Kconfig
===================================================================
--- linux.orig/drivers/video/Kconfig
+++ linux/drivers/video/Kconfig
@@ -236,6 +236,11 @@ comment "Frame buffer hardware drivers"
 
 config FB_CIRRUS
 	tristate "Cirrus Logic support"
+
+	# can hang on a box without this hardware
+	depends on BROKEN_BOOT_ALLOWED
+	select BROKEN_BOOT if FB_CIRRUS = y
+
 	depends on FB && (ZORRO || PCI)
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
@@ -546,6 +551,11 @@ config FB_CT65550
 
 config FB_ASILIANT
 	bool "Asiliant (Chips) 69000 display support"
+
+	# can hang on a box without this hardware
+	depends on BROKEN_BOOT_ALLOWED
+	select BROKEN_BOOT if FB_ASILIANT = y
+
 	depends on (FB = y) && PCI
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
@@ -564,6 +574,11 @@ config FB_IMSTT
 
 config FB_VGA16
 	tristate "VGA 16-color graphics support"
+
+	# can hang on a box without this hardware
+	depends on BROKEN_BOOT_ALLOWED
+	select BROKEN_BOOT if FB_VGA16 = y
+
 	depends on FB && (X86 || PPC)
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
@@ -674,6 +689,11 @@ config FB_UVESA
 
 config FB_VESA
 	bool "VESA VGA graphics support"
+
+	# can hang on a box without this hardware
+	depends on BROKEN_BOOT_ALLOWED
+	select BROKEN_BOOT if FB_VESA = y
+
 	depends on (FB = y) && X86
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
@@ -1299,6 +1319,11 @@ config FB_MATROX_MULTIHEAD
 
 config FB_RADEON
 	tristate "ATI Radeon display support"
+
+	# can hang on a box without this hardware
+	depends on BROKEN_BOOT_ALLOWED
+	select BROKEN_BOOT if FB_RADEON = y
+
 	depends on FB && PCI
 	select FB_BACKLIGHT if FB_RADEON_BACKLIGHT
 	select FB_MODE_HELPERS
@@ -1581,6 +1606,11 @@ config FB_VT8623
 
 config FB_CYBLA
 	tristate "Cyberblade/i1 support"
+
+	# can hang on a box without this hardware
+	depends on BROKEN_BOOT_ALLOWED
+	select BROKEN_BOOT if FB_CYBLA = y
+
 	depends on FB && PCI && X86_32 && !64BIT
 	select FB_CFB_IMAGEBLIT
 	select VIDEO_SELECT
@@ -2006,6 +2036,11 @@ config FB_SH7760
 
 config FB_VIRTUAL
 	tristate "Virtual Frame Buffer support (ONLY FOR TESTING!)"
+
+	# can hang on a box without this hardware
+	depends on BROKEN_BOOT_ALLOWED
+	select BROKEN_BOOT if FB_VIRTUAL = y
+
 	depends on FB
 	select FB_SYS_FILLRECT
 	select FB_SYS_COPYAREA
Index: linux/drivers/video/console/Kconfig
===================================================================
--- linux.orig/drivers/video/console/Kconfig
+++ linux/drivers/video/console/Kconfig
@@ -61,6 +61,11 @@ config VIDEO_SELECT
 
 config MDA_CONSOLE
 	depends on !M68K && !PARISC && ISA
+
+	# can hang on a box without this hardware
+	depends on BROKEN_BOOT_ALLOWED
+	select BROKEN_BOOT if MDA_CONSOLE = y
+
 	tristate "MDA text console (dual-headed) (EXPERIMENTAL)"
 	---help---
 	  Say Y here if you have an old MDA or monochrome Hercules graphics
@@ -113,6 +118,10 @@ config DUMMY_CONSOLE_ROWS
 
 config FRAMEBUFFER_CONSOLE
 	tristate "Framebuffer Console support"
+
+	depends on BROKEN_BOOT_ALLOWED
+	select BROKEN_BOOT if FRAMEBUFFER_CONSOLE = y
+
 	depends on FB
 	select CRC32
 	help
Index: linux/drivers/watchdog/Kconfig
===================================================================
--- linux.orig/drivers/watchdog/Kconfig
+++ linux/drivers/watchdog/Kconfig
@@ -324,6 +324,12 @@ config SC520_WDT
 config EUROTECH_WDT
 	tristate "Eurotech CPU-1220/1410 Watchdog Timer"
 	depends on X86
+
+	# this ISA driver puts itself on IRQ10 - if IRQ10 happens to
+	# trigger then that will cause a watchdog-initiated reboot
+	depends on BROKEN_BOOT_ALLOWED
+	select BROKEN_BOOT if EUROTECH_WDT = y
+
 	help
 	  Enable support for the watchdog timer on the Eurotech CPU-1220 and
 	  CPU-1410 cards.  These are PC/104 SBCs. Spec sheets and product
@@ -830,6 +836,11 @@ config MIXCOMWD
 config WDT
 	tristate "WDT Watchdog timer"
 	depends on ISA
+
+	# this ISA driver sits on IRQ11 by default - blocking forcedeth
+	depends on BROKEN_BOOT_ALLOWED
+	select BROKEN_BOOT if WDT = y
+
 	---help---
 	  If you have a WDT500P or WDT501P watchdog board, say Y here,
 	  otherwise N. It is not possible to probe for this board, which means
Index: linux/fs/Kconfig
===================================================================
--- linux.orig/fs/Kconfig
+++ linux/fs/Kconfig
@@ -1636,6 +1636,11 @@ config NFS_V4
 config ROOT_NFS
 	bool "Root file system on NFS"
 	depends on NFS_FS=y && IP_PNP
+
+	# hangs a non-root-NFS box during bootup
+	depends on BROKEN_BOOT_ALLOWED
+	select BROKEN_BOOT
+
 	help
 	  If you want your system to mount its root file system via NFS,
 	  choose Y here.  This is common practice for managing systems
Index: linux/security/Kconfig
===================================================================
--- linux.orig/security/Kconfig
+++ linux/security/Kconfig
@@ -85,6 +85,11 @@ config SECURITY_FILE_CAPABILITIES
 config SECURITY_ROOTPLUG
 	bool "Root Plug Support"
 	depends on USB=y && SECURITY
+
+	# fails with hard-to-debug "could not find init" boot failure
+	depends on BROKEN_BOOT_ALLOWED
+	select BROKEN_BOOT
+
 	help
 	  This is a sample LSM module that should only be used as such.
 	  It prevents any programs running with egid == 0 if a specific
Index: linux/security/selinux/Kconfig
===================================================================
--- linux.orig/security/selinux/Kconfig
+++ linux/security/selinux/Kconfig
@@ -100,6 +100,11 @@ config SECURITY_SELINUX_CHECKREQPROT_VAL
 config SECURITY_SELINUX_ENABLE_SECMARK_DEFAULT
 	bool "NSA SELinux enable new secmark network controls by default"
 	depends on SECURITY_SELINUX
+
+	# old system booted up with this cannot ssh out
+	depends on BROKEN_BOOT_ALLOWED
+	select BROKEN_BOOT
+
 	default n
 	help
 	  This option determines whether the new secmark-based network
