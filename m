Return-Path: <linux-kernel-owner+w=401wt.eu-S1752624AbXLIMFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbXLIMFj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 07:05:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750790AbXLIMFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 07:05:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54202 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbXLIMF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 07:05:29 -0500
Date: Sun, 9 Dec 2007 13:05:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
Message-ID: <20071209120502.GA7012@elte.hu>
References: <200712080340.49546.rjw@sisk.pl> <20071209035415.a3875df8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071209035415.a3875df8.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> Am trying to do a git-disect on it but it seems that someone has been 
> screwing with ata Kconfig and I'm hitting a pile of 
> cant-find-root-disk bisection points and I can't immediately work out 
> why.  I'll try to find time to look at it again next week.

the way i solve such bisection problems is to have the patch like below 
applied by a "git-bisect run" scriptlet (and popped off after the test). 
This way all must-have drivers and kernel features are selected for that 
particular testbox, no matter what Kconfig complication there are. 
(except outright config option renaming but those are rare)

	Ingo

Index: linux/arch/x86/Kconfig.needed
===================================================================
--- /dev/null
+++ linux/arch/x86/Kconfig.needed
@@ -0,0 +1,88 @@
+config FORCE_MINIMAL_CONFIG
+	bool
+	default y
+
+select EXPERIMENTAL
+
+select EXT3_FS
+select EXT3_FS_XATTR
+select EXT3_FS_POSIX_ACL
+select EXT3_FS_SECURITY
+select BLOCK
+select HOTPLUG
+#select INOTIFY
+#select INOTIFY_USER
+
+# so that capset() works (sudo, etc.):
+select SECURITY
+select SECURITY_CAPABILITIES
+
+select BINFMT_ELF
+select MSDOS_PARTITION
+select PARTITION_ADVANCED
+select BSD_DISKLABEL
+
+select SYSFS
+select SYSFS_DEPRECATED
+select PROC_FS
+select FUTEX
+
+select ATA
+select SATA_AHCI
+select ATA_PIIX
+select PATA_AMD
+select PATA_OLDPIIX
+select BLK_DEV_SD
+
+select E100
+select E1000
+select NET_ETHERNET
+select NET_PCI
+select MII
+select CRC32
+
+select 8139TOO
+select FORCEDETH
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
+
+select USB
+select USB_MOUSE
+select USB_EHCI_HCD
+select USB_OHCI_HCD
+select USB_UHCI_HCD
+select USB_SUPPORT
+
+select PCI
+
+select STANDALONE
+select PREVENT_FIRMWARE_BUILD
+
Index: linux/lib/Kconfig
===================================================================
--- linux.orig/lib/Kconfig
+++ linux/lib/Kconfig
@@ -142,3 +142,6 @@ config CHECK_SIGNATURE
 	bool
 
 endmenu
+
+source "arch/x86/Kconfig.needed"
+
Index: linux/lib/Kconfig.debug
