Return-Path: <linux-kernel-owner+w=401wt.eu-S1751599AbZHCRNF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599AbZHCRNF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 13:13:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbZHCRNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 13:13:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:53051 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbZHCRND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 13:13:03 -0400
Date: Mon, 3 Aug 2009 17:12:38 GMT
From: tip-bot for Paul Mackerras <paulus@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <19062.56420.501516.316181@cargo.ozlabs.ibm.com>
References: <19062.56420.501516.316181@cargo.ozlabs.ibm.com>
Subject: [tip:x86/urgent] x86: Add quirk to make Apple MacBook5,2 use reboot=pci
Message-ID: <tip-1961b971360c685e15dff59929c39ced6c46e171@git.kernel.org>
Git-Commit-ID: 1961b971360c685e15dff59929c39ced6c46e171
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 03 Aug 2009 17:12:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1961b971360c685e15dff59929c39ced6c46e171
Gitweb:     http://git.kernel.org/tip/1961b971360c685e15dff59929c39ced6c46e171
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Mon, 3 Aug 2009 22:47:32 +1000
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 3 Aug 2009 08:07:18 -0700

x86: Add quirk to make Apple MacBook5,2 use reboot=pci

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
LKML-Reference: <19062.56420.501516.316181@cargo.ozlabs.ibm.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>


---
 arch/x86/kernel/reboot.c |   34 +++++++++++++++++++++++++++++++++-
 1 files changed, 33 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 508e982..834c9da 100644
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
@@ -404,6 +404,38 @@ EXPORT_SYMBOL(machine_real_restart);
 
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
