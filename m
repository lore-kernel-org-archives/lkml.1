Return-Path: <linux-kernel-owner+w=401wt.eu-S1758636AbYC0I32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758636AbYC0I32 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 04:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755449AbYC0I3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 04:29:19 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:9863 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262AbYC0I3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 04:29:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=reply-to:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=E0aVqq58HjK4jYVhnJmZ5iVicHTWZ1Yoc+VWxuHTw9/SGetnE5m+pLfI9WqKTPF4dJSPlrUUyXVuIU4jBQE9rRNWnKn62o3Hne7zXrAox5PypL9o3xbP7g/fAxCnRAF1kr/I9ECrGmLzL9zuOp9rYdvxUzJZRe8AxGrL4KhZzdI=
Reply-To: yhlu.kernel@gmail.com
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gary Hade <garyhade@us.ibm.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] x86/pci: add pci=skip_isa_align command lines.
Date: Thu, 27 Mar 2008 01:31:18 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: kernel list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803270131.18885.yhlu.kernel@gmail.com>
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86/pci: add pci=skip_isa_align command lines.

so we don't align the io port start address for pci cards.

also move out dmi check out acpi.c, because it has nothing to do with acpi.
it could spare some calling when we have several peer root buses.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 1970479..d25db3b 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1497,6 +1497,8 @@ and is between 256 and 4096 characters. It is defined in the file
 				This is normally done in pci_enable_device(),
 				so this option is a temporary workaround
 				for broken drivers that don't call it.
+		skip_isa_align	[X86] do not align io start addr, so can
+				handle more pci cards
 		firmware	[ARM] Do not re-enumerate the bus but instead
 				just use the configuration from the
 				bootloader. This is currently used on
diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index b0e4369..850d721 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -6,45 +6,6 @@
 #include <asm/numa.h>
 #include "pci.h"
 
-static int __devinit can_skip_ioresource_align(const struct dmi_system_id *d)
-{
-	pci_probe |= PCI_CAN_SKIP_ISA_ALIGN;
-	printk(KERN_INFO "PCI: %s detected, can skip ISA alignment\n", d->ident);
-	return 0;
-}
-
-static struct dmi_system_id acpi_pciprobe_dmi_table[] __devinitdata = {
-/*
- * Systems where PCI IO resource ISA alignment can be skipped
- * when the ISA enable bit in the bridge control is not set
- */
-	{
-		.callback = can_skip_ioresource_align,
-		.ident = "IBM System x3800",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "IBM"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "x3800"),
-		},
-	},
-	{
-		.callback = can_skip_ioresource_align,
-		.ident = "IBM System x3850",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "IBM"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "x3850"),
-		},
-	},
-	{
-		.callback = can_skip_ioresource_align,
-		.ident = "IBM System x3950",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "IBM"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "x3950"),
-		},
-	},
-	{}
-};
-
 struct pci_root_info {
 	char *name;
 	unsigned int res_num;
@@ -196,8 +157,6 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_device *device, int do
 	int pxm;
 #endif
 
-	dmi_check_system(acpi_pciprobe_dmi_table);
-
 	if (domain && !pci_domains_supported) {
 		printk(KERN_WARNING "PCI: Multiple domains not supported "
 		       "(dom %d, bus %d)\n", domain, busnum);
diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index ae1bf52..8045a4a 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -77,6 +77,50 @@ int pcibios_scanned;
  */
 DEFINE_SPINLOCK(pci_config_lock);
 
+static int __devinit can_skip_ioresource_align(const struct dmi_system_id *d)
+{
+	pci_probe |= PCI_CAN_SKIP_ISA_ALIGN;
+	printk(KERN_INFO "PCI: %s detected, can skip ISA alignment\n", d->ident);
+	return 0;
+}
+
+static struct dmi_system_id can_skip_pciprobe_dmi_table[] __devinitdata = {
+/*
+ * Systems where PCI IO resource ISA alignment can be skipped
+ * when the ISA enable bit in the bridge control is not set
+ */
+	{
+		.callback = can_skip_ioresource_align,
+		.ident = "IBM System x3800",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "IBM"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "x3800"),
+		},
+	},
+	{
+		.callback = can_skip_ioresource_align,
+		.ident = "IBM System x3850",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "IBM"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "x3850"),
+		},
+	},
+	{
+		.callback = can_skip_ioresource_align,
+		.ident = "IBM System x3950",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "IBM"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "x3950"),
+		},
+	},
+	{}
+};
+
+void __init dmi_check_skip_isa_align(void)
+{
+	dmi_check_system(can_skip_pciprobe_dmi_table);
+}
+
 /*
  * Several buggy motherboards address only 16 devices and mirror
  * them to next 16 IDs. We try to detect this `feature' on all
@@ -519,6 +563,9 @@ char * __devinit  pcibios_setup(char *str)
 	} else if (!strcmp(str, "routeirq")) {
 		pci_routeirq = 1;
 		return NULL;
+	} else if (!strcmp(str, "skip_isa_align")) {
+		pci_probe |= PCI_CAN_SKIP_ISA_ALIGN;
+		return NULL;
 	}
 	return str;
 }
diff --git a/arch/x86/pci/init.c b/arch/x86/pci/init.c
index 343c363..49bb1cf 100644
--- a/arch/x86/pci/init.c
+++ b/arch/x86/pci/init.c
@@ -29,6 +29,8 @@ static __init int pci_access_init(void)
 		printk(KERN_ERR
 		"PCI: Fatal: No config space access function found\n");
 
+	dmi_check_skip_isa_align();
+
 	return 0;
 }
 arch_initcall(pci_access_init);
diff --git a/arch/x86/pci/pci.h b/arch/x86/pci/pci.h
index c9fb637..d338935 100644
--- a/arch/x86/pci/pci.h
+++ b/arch/x86/pci/pci.h
@@ -39,6 +39,8 @@ enum pci_bf_sort_state {
 	pci_dmi_bf,
 };
 
+extern void __init dmi_check_skip_isa_align(void);
+
 /* pci-i386.c */
 
 extern unsigned int pcibios_max_latency;
