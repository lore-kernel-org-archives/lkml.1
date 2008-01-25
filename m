Return-Path: <linux-kernel-owner+w=401wt.eu-S1759613AbYAYX1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759613AbYAYX1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 18:27:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbYAYX1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 18:27:13 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:15146 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbYAYX1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 18:27:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kAkJmQ4x+FGq+ilvYMFMatwbCDMAaZsE2PgpRE1wwNd2HzuRe8HCre1cxkcgZUyejAkYkQFEbSF7buLlhG8eydeAkX+vzwD5bC5h5MHlTIhkVxb7Z1RWaJQ/KhPl9l9FGHLzxSq6Wka9tRFGY1SwBHcW0785yKR1ADLhjLvy2o8=
Subject: Re: [PATCH 183/196] driver core: fix build with SYSFS=n
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080125231849.GA12518@elte.hu>
References: <20080125071127.GA4860@kroah.com>
	 <1201246425-5058-104-git-send-email-gregkh@suse.de>
	 <20080125222530.GA23769@elte.hu> <20080125223858.GA15723@suse.de>
	 <20080125225723.GA26475@elte.hu> <20080125231040.GC25074@suse.de>
	 <20080125231849.GA12518@elte.hu>
Content-Type: text/plain
Date: Fri, 25 Jan 2008 15:27:11 -0800
Message-Id: <1201303631.12822.29.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-01-26 at 00:18 +0100, Ingo Molnar wrote:
> * Greg KH <gregkh@suse.de> wrote:
> 
> > > Please! :-)
> > 
> > Yes, I do agree that this is important, I'll work to not let this 
> > happen again.  Especially now that I have your build scripts, I'm 
> > working on setting up something like that myself here.
> 
> btw., Harvey Harrison has cleaned them up some more, and has told me 
> about KCONFIG_ALLCONFIG, which is very useful when you want to tailor 
> randconfig builds to different testsystems (which might have different 
> minimum driver requirements and different distro requirements for kernel 
> features). Harvey, could you send the latest version of those 
> auto-Kconfig cleanups?

Sorry, I've been a bit laid up with illness to pull out any upstreamable
pieces.  Attached is the original version I sent to you that still has
the Ingo-specific need_config file.  Hopefully I'll be back in action
and can finish this soon.

This is functionally equivalent to Ingo's patch at:

http://people.redhat.com/mingo/auto-qa-patches/Kconfig-qa.patch

Instead, create a need_config file and invoke randconfig as:

make randconfig KCONFIG_ALLCONFIG=need_config

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Ingo, your QA patch ends up being much smaller and works exactly the
same as long as you invoke randconfig with the above.  I've included
a need_config file that has all of the options I removed from your patch
suitable for the above KCONFIG_ALLCONFIG use.

Cheers,

Harvey

 arch/x86/Kconfig        |   74 +++++++++++++++++++++++++++++++++++
 arch/x86/Kconfig.needed |   99
+++++++++++++++++++++++++++++++++++++++++++++++
 drivers/atm/Kconfig     |    1 +
 drivers/base/core.c     |    3 +
 init/Kconfig            |   13 ++++++
 init/main.c             |   56 ++++++++++++++++++++++++++
 kernel/time/Kconfig     |   13 ++++++
 lib/Kconfig             |    3 +
 need_config             |   85 ++++++++++++++++++++++++++++++++++++++++
 9 files changed, 347 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 665e4b1..9061f77 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -164,6 +164,12 @@ config X86_TRAMPOLINE
 
 config KTIME_SCALAR
        def_bool X86_32
+
+config BOOTPARAM_SUPPORT
+       bool "bootparam support"
+       help
+         support for boot command-line parameters via .config
+
 source "init/Kconfig"
 
 menu "Processor type and features"
@@ -1204,6 +1210,66 @@ config COMPAT_VDSO
 
          If unsure, say Y.
 
+config BOOTPARAM_NMI_WATCHDOG_BIT_0
+       bool "bootparam: nmi_watchdog=X default value - bit 0"
+       depends on BOOTPARAM_SUPPORT
+       help
+         NMI watchdog default, bit 0. Useful for automated testing.
+
+config BOOTPARAM_NMI_WATCHDOG_BIT_1
+       bool "bootparam: nmi_watchdog=X default value - bit 1"
+       depends on BOOTPARAM_SUPPORT
+       help
+         NMI watchdog default, bit 1. Useful for automated testing.
+
+config BOOTPARAM_NOAPIC
+       bool "bootparam: noapic"
+       depends on BOOTPARAM_SUPPORT
+       help
+         if enabled, it has the effect as "noapic" on the boot line
+
+config BOOTPARAM_NOLAPIC
+       bool "bootparam: nolapic"
+       depends on BOOTPARAM_SUPPORT
+       help
+         if enabled, it has the effect as "nolapic" on the boot line
+
+config BOOTPARAM_LAPIC
+       bool "bootparam: lapic"
+       depends on BOOTPARAM_SUPPORT
+       help
+         if enabled, it has the effect as "lapic" on the boot line
+
+config BOOTPARAM_HPET_DISABLE
+       bool "bootparam: hpet=disable"
+       depends on BOOTPARAM_SUPPORT
+       help
+         if enabled, it has the effect as "hpet=disable" on the boot
line
+
+config BOOTPARAM_IDLE_MWAIT
+       bool "bootparam: idle=mwait"
+       depends on BOOTPARAM_SUPPORT
+       help
+         if enabled, it has the effect as "idle=mwait" on the boot line
+
+config BOOTPARAM_IDLE_POLL
+       bool "bootparam: idle=poll"
+       depends on BOOTPARAM_SUPPORT
+       help
+         if enabled, it has the effect as "idle=poll" on the boot line
+
+config BOOTPARAM_HIGHMEM_512M
+       bool "bootparam: highmem=512m"
+       depends on BOOTPARAM_SUPPORT
+       help
+         highmem=512m boot parameter. Useful for automated testing.
+
+config BOOTPARAM_NOPAT
+       bool "bootparam: nopat"
+       depends on BOOTPARAM_SUPPORT
+       help
+         if enabled, it has the effect as "nopat" on the boot line
+
 endmenu
 
 config ARCH_ENABLE_MEMORY_HOTPLUG
@@ -1612,3 +1678,11 @@ source "security/Kconfig"
 source "crypto/Kconfig"
 
 source "lib/Kconfig"
+
+config X86_32_ALWAYS_ON
+       bool
+       default y
+       depends on X86_32
+       select X86_PC
+       select PCI_GOANY
+
diff --git a/arch/x86/Kconfig.needed b/arch/x86/Kconfig.needed
new file mode 100644
index 0000000..b1f7ff0
--- /dev/null
+++ b/arch/x86/Kconfig.needed
@@ -0,0 +1,99 @@
+config FORCE_MINIMAL_CONFIG
+       bool
+       default y
+
+       select EXPERIMENTAL
+
+       select EXT3_FS
+       select EXT3_FS_XATTR
+       select EXT3_FS_POSIX_ACL
+       select EXT3_FS_SECURITY
+       select BLOCK
+       select HOTPLUG
+#select INOTIFY
+#select INOTIFY_USER
+
+       # so that capset() works (sudo, etc.):
+       select SECURITY
+       select SECURITY_CAPABILITIES
+       select BINFMT_ELF
+
+       select MSDOS_PARTITION
+       select PARTITION_ADVANCED
+       select BSD_DISKLABEL
+
+       select SYSFS
+       select SYSFS_DEPRECATED
+       select PROC_FS
+       select FUTEX
+
+select PACKET
+
+select NETPOLL
+select NETCONSOLE
+select NET_POLL_CONTROLLER
+select INET
+select NET
+select UNIX
+select NETDEVICES
+
+select SERIAL_8250
+select SERIAL_8250_CONSOLE
+select MAGIC_SYSRQ
+
+select INPUT
+select INPUT_MOUSEDEV
+select INPUT_POLLDEV
+select INPUT_KEYBOARD
+select KEYBOARD_ATKBD
+select SERIO
+select SERIO_I8042
+
+select VT
+select VT_CONSOLE
+select HW_CONSOLE
+select VGA_CONSOLE
+select EARLY_PRINTK
+select PRINTK
+select UNIX98_PTYS
+select STANDALONE
+select PREVENT_FIRMWARE_BUILD
+
+config FORCE_MINIMAL_CONFIG_64
+       bool
+       default y
+       depends on X86_64
+       select IA32_EMULATION
+
+config FORCE_MINIMAL_CONFIG_PHYS
+       bool
+       default y
+       depends on X86_64 || X86_32
+
+       select ATA
+       select SATA_AHCI
+       select ATA_PIIX
+       select PATA_AMD
+       select PATA_OLDPIIX
+       select BLK_DEV_SD
+
+       select E100
+       select E1000
+       select NET_ETHERNET
+       select NET_PCI
+       select MII
+       select CRC32
+
+       select 8139TOO
+       select FORCEDETH
+
+       select USB
+       select USB_MOUSE
+       select USB_EHCI_HCD
+       select USB_OHCI_HCD
+       select USB_UHCI_HCD
+       select USB_SUPPORT
+
+       select PCI
+
+
diff --git a/drivers/atm/Kconfig b/drivers/atm/Kconfig
index b554eda..caf4d20 100644
--- a/drivers/atm/Kconfig
+++ b/drivers/atm/Kconfig
@@ -344,6 +344,7 @@ config ATM_FORE200E_MAYBE
 config ATM_FORE200E_PCA
        bool "PCA-200E support"
        depends on ATM_FORE200E_MAYBE && PCI
+       select ATM_FORE200E_PCA_DEFAULT_FW if PREVENT_FIRMWARE_BUILD
        help
          Say Y here if you want your PCA-200E cards to be probed.
 
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 2683eac..84e61f5 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -104,7 +104,10 @@ static void device_release(struct kobject * kobj)
                printk(KERN_ERR "Device '%s' does not have a release()
function, "
                        "it is broken and must be fixed.\n",
                        dev->bus_id);
+#if 0
+               // not a real bug:
                WARN_ON(1);
+#endif
        }
 }
 
diff --git a/init/Kconfig b/init/Kconfig
index b9d11a8..add6333 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -324,6 +324,19 @@ config CPUSETS
 
          Say N if unsure.
 
+config BOOTPARAM_MAXCPUS_1
+       bool "bootparam: maxcpus=1"
+       depends on BOOTPARAM_SUPPORT
+       help
+         if enabled, it has the effect as "maxcpus=1" on the boot line
+
+config BOOTPARAM_NOSMP
+       bool "bootparam: nosmp"
+       depends on BOOTPARAM_SUPPORT
+       help
+         if enabled, it has the effect as "nosmp" on the boot line
+
+
 config FAIR_GROUP_SCHED
        bool "Fair group CPU scheduler"
        default y
diff --git a/init/main.c b/init/main.c
index 7f57f7a..495dd7e 100644
--- a/init/main.c
+++ b/init/main.c
@@ -126,6 +126,58 @@ static char *static_command_line;
 static char *execute_command;
 static char *ramdisk_execute_command;
 
+const char bootparam_command_line [] =
+""
+#ifdef CONFIG_BOOTPARAM_MAXCPUS_1
+" maxcpus=1"
+#endif
+#ifdef CONFIG_BOOTPARAM_NOSMP
+" nosmp"
+#endif
+#ifdef CONFIG_BOOTPARAM_NO_HZ_OFF
+" no_hz=off"
+#endif
+#ifdef CONFIG_BOOTPARAM_HIGHRES_OFF
+" highres=0"
+#endif
+#if defined(CONFIG_BOOTPARAM_NMI_WATCHDOG_BIT_0) && \
+    !defined(CONFIG_BOOTPARAM_NMI_WATCHDOG_BIT_1)
+" nmi_watchdog=0"
+#endif
+#if !defined(CONFIG_BOOTPARAM_NMI_WATCHDOG_BIT_0) && \
+    defined(CONFIG_BOOTPARAM_NMI_WATCHDOG_BIT_1)
+" nmi_watchdog=1"
+#endif
+#if defined(CONFIG_BOOTPARAM_NMI_WATCHDOG_BIT_0) && \
+    defined(CONFIG_BOOTPARAM_NMI_WATCHDOG_BIT_1)
+" nmi_watchdog=2"
+#endif
+#ifdef CONFIG_BOOTPARAM_NOAPIC
+" noapic"
+#endif
+#ifdef CONFIG_BOOTPARAM_NOLAPIC
+" nolapic"
+#endif
+#ifdef CONFIG_BOOTPARAM_LAPIC
+" lapic"
+#endif
+#ifdef CONFIG_BOOTPARAM_HPET_DISABLE
+" hpet=disable"
+#endif
+#ifdef CONFIG_BOOTPARAM_IDLE_MWAIT
+" idle=mwait"
+#endif
+#ifdef CONFIG_BOOTPARAM_IDLE_POLL
+" idle=poll"
+#endif
+#ifdef CONFIG_BOOTPARAM_HIGHMEM_512M
+" highmem=512m"
+#endif
+#ifdef CONFIG_BOOTPARAM_NOPAT
+" nopat"
+#endif
+;
+
 #ifdef CONFIG_SMP
 /* Setup configured maximum number of CPUs to activate */
 unsigned int __initdata setup_max_cpus = NR_CPUS;
@@ -484,6 +536,7 @@ void __init parse_early_param(void)
        /* All fall through to do_early_param. */
        strlcpy(tmp_cmdline, boot_command_line, COMMAND_LINE_SIZE);
        parse_args("early options", tmp_cmdline, NULL, 0,
do_early_param);
+
        done = 1;
 }
 
@@ -511,6 +564,9 @@ asmlinkage void __init start_kernel(void)
 
        smp_setup_processor_id();
 
+       /* Build-time simulated boot parameters: */
+       strncat(boot_command_line, bootparam_command_line,
COMMAND_LINE_SIZE);
+
        /*
         * Need to run as early as possible, to initialize the
         * lockdep hash:
diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index 8d53106..a6b3b23 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -14,6 +14,12 @@ config NO_HZ
          only trigger on an as-needed basis both when the system is
          busy and when the system is idle.
 
+config BOOTPARAM_NO_HZ_OFF
+       bool "bootparam: no_hz"
+       depends on BOOTPARAM_SUPPORT
+       help
+         if enabled, it has the effect as "no_hz=off" on the boot line
+
 config HIGH_RES_TIMERS
        bool "High Resolution Timer Support"
        depends on GENERIC_TIME && GENERIC_CLOCKEVENTS
@@ -28,3 +34,10 @@ config GENERIC_CLOCKEVENTS_BUILD
        default y
        depends on GENERIC_CLOCKEVENTS || GENERIC_CLOCKEVENTS_MIGR
 
+config BOOTPARAM_HIGHRES_OFF
+       bool "bootparam: highres=0"
+       depends on BOOTPARAM_SUPPORT
+       help
+         if enabled, it has the effect as "highres=0" on the boot line
+
+
diff --git a/lib/Kconfig b/lib/Kconfig
index ba3d104..a4537df 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -142,3 +142,6 @@ config CHECK_SIGNATURE
        bool
 
 endmenu
+
+source "arch/x86/Kconfig.needed"
+
diff --git a/need_config b/need_config
new file mode 100644
index 0000000..fb57fec
--- /dev/null
+++ b/need_config
@@ -0,0 +1,85 @@
+# dangerous to boot on non-Elan CPUs
+CONFIG_X86_ELAN=n
+
+# hangs on bootup on non-Voyager platforms
+CONFIG_X86_VOYAGER=n
+
+# hangs on bootup on non-Numaq platforms
+CONFIG_X86_NUMAQ=n
+
+# hangs on bootup on non-VisWS platforms
+CONFIG_X86_VISWS=n
+
+# hangs on bootup on non-VisWS platforms (ES7000)
+CONFIG_X86_ES7000=n
+
+# hangs on bootup on non-PCIE systems
+CONFIG_PCI_GOMMCONFIG=n
+
+# the probe can hang during bootup on non-PARIDE boxes
+CONFIG_PARIDE=n
+
+# my test box expects /dev/sda, not /dev/hda
+CONFIG_IDE=n
+
+# unsafe and hangs on newer boxes
+CONFIG_BLK_DEV_HD_IDE=n
+
+# dangerous to enable - sometimes hangs on probe
+CONFIG_MTD=n
+
+# Can hang
+CONFIG_COPS=n
+
+# this creates a fake /dev/sda which confuses the bzImage bootup
+CONFIG_SCSI_DEBUG=n
+
+# can hang on a box without this hardware
+CONFIG_FB_CIRRUS=n
+CONFIG_FB_ASILIANT=n
+CONFIG_FB_VGA16=n
+CONFIG_FB_VESA=n
+CONFIG_FB_RADEON=n
+CONFIG_FB_CYBLA=n
+CONFIG_FB_VIRTUAL=n
+
+# can hang on a box without this hardware
+CONFIG_MDA_CONSOLE=n
+
+CONFIG_FRAMEBUFFER_CONSOLE=n
+
+# this ISA driver puts itself on IRQ10 - if IRQ10 happens to
+# trigger then that will cause a watchdog-initiated reboot
+CONFIG_EUROTECH_WDT=n
+
+# this ISA driver sits on IRQ11 by default - blocking forcedeth
+CONFIG_WDT=n
+
+# hangs a non-root-NFS box during bootup
+CONFIG_ROOT_NFS=n
+
+# auto-qa needs to see all messages
+CONFIG_LOG_BUF_SHIFT=20
+
+# Slows down bootup unnecessarily and does not catch bugs
+# by itself - so disable this.
+CONFIG_DEBUG_KOBJECT=n
+
+# too slow build in QA
+CONFIG_DEBUG_INFO=n
+
+# slow to build
+CONFIG_WANT_EXTRA_DEBUG_INFORMATION=n
+
+# fails with hard-to-debug "could not find init" boot failure
+CONFIG_SECURITY_ROOTPLUG=n
+
+# old system booted up with this cannot ssh out
+CONFIG_SECURITY_SELINUX_ENABLE_SECMARK_DEFAULT=n
+
+# may hang on non-hardware
+CONFIG_SND_MTPAV=n
+
+# obsolete drivers
+CONFIG_SOUND_OSS=n
+
-- 
1.5.4.rc3.1118.gf6754c






