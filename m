Return-Path: <linux-kernel-owner+w=401wt.eu-S1755009AbZHCMrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009AbZHCMrl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 08:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754937AbZHCMrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 08:47:40 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:53204 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754742AbZHCMrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 08:47:39 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19062.56420.501516.316181@cargo.ozlabs.ibm.com>
Date: Mon, 3 Aug 2009 22:47:32 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: Add quirk to make Apple MacBook5,2 use reboot=pci
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest Apple MacBook (MacBook5,2) doesn't reboot successfully
under Linux; neither the EFI reboot method nor the default method
using the keyboard controller works (the system just hangs and doesn't
reset).  However, the method using the "PCI reset register" at 0xcf9
does work.

This adds a quirk to detect this machine via DMI and force the
reboot_type to BOOT_CF9.  With this it reboots successfully without
requiring a command-line option.  Note that the EFI code forces
reboot_type to BOOT_EFI when the machine is booted via EFI, but this
overrides that since the core_initcall runs after the EFI
initialization code.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index d2d1ce8..2106985 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -3,6 +3,7 @@
 #include <linux/init.h>
 #include <linux/pm.h>
 #include <linux/efi.h>
+#include <linux/dmi.h>
 #include <acpi/reboot.h>
 #include <asm/io.h>
 #include <asm/apic.h>
@@ -17,7 +18,6 @@
 #include <asm/cpu.h>
 
 #ifdef CONFIG_X86_32
-# include <linux/dmi.h>
 # include <linux/ctype.h>
 # include <linux/mc146818rtc.h>
 #else
@@ -396,6 +396,38 @@ EXPORT_SYMBOL(machine_real_restart);
 
 #endif /* CONFIG_X86_32 */
 
+/*
+ * Apple MacBook5,2 (2009 MacBook) needs reboot=p
+ */
+static int __init set_pci_reboot(const struct dmi_system_id *d)
+{
+	if (reboot_type != BOOT_CF9) {
+		reboot_type = BOOT_CF9;
+		printk(KERN_INFO "%s series board detected. "
+		       "Selecting PCI-method for reboots.\n", d->ident);
+	}
+	return 0;
+}
+
+static struct dmi_system_id __initdata pci_reboot_dmi_table[] = {
+	{	/* Handle problems with rebooting on Apple MacBook5,2 */
+		.callback = set_pci_reboot,
+		.ident = "Apple MacBook",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBook5,2"),
+		},
+	},
+	{ }
+};
+
+static int __init pci_reboot_init(void)
+{
+	dmi_check_system(pci_reboot_dmi_table);
+	return 0;
+}
+core_initcall(pci_reboot_init);
+
 static inline void kb_wait(void)
 {
 	int i;
