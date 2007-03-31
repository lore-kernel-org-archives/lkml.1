Return-Path: <linux-kernel-owner+w=401wt.eu-S1751564AbXCaUzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564AbXCaUzc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 16:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751608AbXCaUzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 16:55:31 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:39480 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751024AbXCaUza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 16:55:30 -0400
Date: Sat, 31 Mar 2007 22:55:30 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, ak@suse.de
Cc: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: [2.6 patch] remove the config option for the cs5530a_warm_reset() quirk
Message-ID: <20070331205530.GZ14134@stusta.de>
References: <20070330010559.2a232d9a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070330010559.2a232d9a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2007 at 01:05:59AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.21-rc5-mm2:
>...
> +x86_64-mm-clean-up-mach_reboot_fixups.patch
>...
>  A few x86 updates
>...

OMG - I'll never understand how someone could initially start doing this 
hiding of a small fixup behind a config option.

Instead of cleaning up this mess, please replace this patch with the 
patch below.

cu
Adrian


<--  snip  -->


A config option for hiding one small hardware specific fixup is overkill.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 arch/i386/Kconfig                |   18 ----------
 arch/i386/kernel/Makefile        |    1 
 arch/i386/kernel/reboot.c        |   43 +++++++++++++++++++++++-
 arch/i386/kernel/reboot_fixups.c |   55 -------------------------------
 include/linux/reboot_fixups.h    |   10 -----
 5 files changed, 42 insertions(+), 85 deletions(-)

--- linux-2.6.21-rc5-mm3/arch/i386/Kconfig.old	2007-03-31 20:50:28.000000000 +0200
+++ linux-2.6.21-rc5-mm3/arch/i386/Kconfig	2007-03-31 20:50:43.000000000 +0200
@@ -426,24 +426,6 @@
 	  Say Y if you intend to run this kernel on a Dell Inspiron 8000.
 	  Say N otherwise.
 
-config X86_REBOOTFIXUPS
-	bool "Enable X86 board specific fixups for reboot"
-	depends on X86
-	default n
-	---help---
-	  This enables chipset and/or board specific fixups to be done
-	  in order to get reboot to work correctly. This is only needed on
-	  some combinations of hardware and BIOS. The symptom, for which
-	  this config is intended, is when reboot ends with a stalled/hung
-	  system.
-
-	  Currently, the only fixup is for the Geode GX1/CS5530A/TROM2.1.
-	  combination.
-
-	  Say Y if you want to enable the fixup. Currently, it's safe to
-	  enable this option even if you don't need it.
-	  Say N otherwise.
-
 config MICROCODE
 	tristate "/dev/cpu/microcode - Intel IA32 CPU microcode support"
 	select FW_LOADER
--- linux-2.6.21-rc5-mm3/arch/i386/kernel/Makefile.old	2007-03-31 20:51:03.000000000 +0200
+++ linux-2.6.21-rc5-mm3/arch/i386/kernel/Makefile	2007-03-31 20:51:28.000000000 +0200
@@ -23,7 +23,6 @@
 obj-$(CONFIG_X86_MPPARSE)	+= mpparse.o
 obj-$(CONFIG_X86_LOCAL_APIC)	+= apic.o nmi.o
 obj-$(CONFIG_X86_IO_APIC)	+= io_apic.o
-obj-$(CONFIG_X86_REBOOTFIXUPS)	+= reboot_fixups.o
 obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o crash.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump.o
 obj-$(CONFIG_X86_NUMAQ)		+= numaq.o
--- linux-2.6.21-rc5-mm3/arch/i386/kernel/reboot.c.old	2007-03-31 20:52:12.000000000 +0200
+++ linux-2.6.21-rc5-mm3/arch/i386/kernel/reboot.c	2007-03-31 21:20:18.000000000 +0200
@@ -13,11 +13,11 @@
 #include <linux/ctype.h>
 #include <linux/pm.h>
 #include <linux/reboot.h>
+#include <linux/pci.h>
 #include <asm/uaccess.h>
 #include <asm/apic.h>
 #include <asm/desc.h>
 #include "mach_reboot.h"
-#include <linux/reboot_fixups.h>
 
 /*
  * Power off function, if any
@@ -314,6 +314,47 @@
 #endif
 }
 
+static void cs5530a_warm_reset(struct pci_dev *dev)
+{
+	/* writing 1 to the reset control register, 0x44 causes the
+	cs5530a to perform a system warm reset */
+	pci_write_config_byte(dev, 0x44, 0x1);
+	udelay(50); /* shouldn't get here but be safe and spin-a-while */
+	return;
+}
+
+struct device_fixup {
+	unsigned int vendor;
+	unsigned int device;
+	void (*reboot_fixup)(struct pci_dev *);
+};
+
+static struct device_fixup fixups_table[] = {
+{ PCI_VENDOR_ID_CYRIX, PCI_DEVICE_ID_CYRIX_5530_LEGACY, cs5530a_warm_reset },
+};
+
+/*
+ * we see if any fixup is available for our current hardware. if there
+ * is a fixup, we call it and we expect to never return from it. if we
+ * do return, we keep looking and then eventually fall back to the
+ * standard mach_reboot on return.
+ */
+static void mach_reboot_fixups(void)
+{
+	struct device_fixup *cur;
+	struct pci_dev *dev;
+	int i;
+
+	for (i=0; i < ARRAY_SIZE(fixups_table); i++) {
+		cur = &(fixups_table[i]);
+		dev = pci_get_device(cur->vendor, cur->device, NULL);
+		if (!dev)
+			continue;
+
+		cur->reboot_fixup(dev);
+	}
+}
+
 void machine_emergency_restart(void)
 {
 	if (!reboot_thru_bios) {
--- linux-2.6.21-rc5-mm3/include/linux/reboot_fixups.h	2007-03-31 20:45:40.000000000 +0200
+++ /dev/null	2006-09-19 00:45:31.000000000 +0200
@@ -1,10 +0,0 @@
-#ifndef _LINUX_REBOOT_FIXUPS_H
-#define _LINUX_REBOOT_FIXUPS_H
-
-#ifdef CONFIG_X86_REBOOTFIXUPS
-extern void mach_reboot_fixups(void);
-#else
-#define mach_reboot_fixups() ((void)(0))
-#endif
-
-#endif /* _LINUX_REBOOT_FIXUPS_H */
--- linux-2.6.21-rc5-mm3/arch/i386/kernel/reboot_fixups.c	2007-03-31 20:45:40.000000000 +0200
+++ /dev/null	2006-09-19 00:45:31.000000000 +0200
@@ -1,55 +0,0 @@
-/*
- * linux/arch/i386/kernel/reboot_fixups.c
- *
- * This is a good place to put board specific reboot fixups.
- *
- * List of supported fixups:
- * geode-gx1/cs5530a - Jaya Kumar <jayalk@intworks.biz>
- *
- */
-
-#include <asm/delay.h>
-#include <linux/pci.h>
-#include <linux/reboot_fixups.h>
-
-static void cs5530a_warm_reset(struct pci_dev *dev)
-{
-	/* writing 1 to the reset control register, 0x44 causes the
-	cs5530a to perform a system warm reset */
-	pci_write_config_byte(dev, 0x44, 0x1);
-	udelay(50); /* shouldn't get here but be safe and spin-a-while */
-	return;
-}
-
-struct device_fixup {
-	unsigned int vendor;
-	unsigned int device;
-	void (*reboot_fixup)(struct pci_dev *);
-};
-
-static struct device_fixup fixups_table[] = {
-{ PCI_VENDOR_ID_CYRIX, PCI_DEVICE_ID_CYRIX_5530_LEGACY, cs5530a_warm_reset },
-};
-
-/*
- * we see if any fixup is available for our current hardware. if there
- * is a fixup, we call it and we expect to never return from it. if we
- * do return, we keep looking and then eventually fall back to the
- * standard mach_reboot on return.
- */
-void mach_reboot_fixups(void)
-{
-	struct device_fixup *cur;
-	struct pci_dev *dev;
-	int i;
-
-	for (i=0; i < ARRAY_SIZE(fixups_table); i++) {
-		cur = &(fixups_table[i]);
-		dev = pci_get_device(cur->vendor, cur->device, NULL);
-		if (!dev)
-			continue;
-
-		cur->reboot_fixup(dev);
-	}
-}
-

