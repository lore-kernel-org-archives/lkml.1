Return-Path: <linux-kernel-owner+w=401wt.eu-S1760044AbYBLApX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760044AbYBLApX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 19:45:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbYBLAov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 19:44:51 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:34545 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbYBLAou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 19:44:50 -0500
Date: Mon, 11 Feb 2008 16:45:38 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 2/4] x86: clear pci_mmcfg_virt when mmcfg get rejected
In-reply-to: <200802111643.17265.yinghai.lu@sun.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200802111645.38984.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200802111643.17265.yinghai.lu@sun.com>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <Yinghai.Lu@Sun.COM>

For x86_64, need to free pci_mmcfg_virt, and iounmap some pointers
when MMCONF is not reserved in E820 or acpi _CRS and get rejected

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Greg KH <greg@kroah.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/pci/mmconfig-shared.c |    1 +
 arch/x86/pci/mmconfig_32.c     |    4 ++++
 arch/x86/pci/mmconfig_64.c     |   22 +++++++++++++++++++++-
 arch/x86/pci/pci.h             |    1 +
 4 files changed, 27 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/pci/mmconfig-shared.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/mmconfig-shared.c
+++ linux-2.6/arch/x86/pci/mmconfig-shared.c
@@ -300,6 +300,7 @@ static void __init pci_mmcfg_reject_brok
 
 reject:
 	printk(KERN_ERR "PCI: Not using MMCONFIG.\n");
+	pci_mmcfg_arch_free();
 	kfree(pci_mmcfg_config);
 	pci_mmcfg_config = NULL;
 	pci_mmcfg_config_num = 0;
Index: linux-2.6/arch/x86/pci/mmconfig_32.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/mmconfig_32.c
+++ linux-2.6/arch/x86/pci/mmconfig_32.c
@@ -136,3 +136,7 @@ int __init pci_mmcfg_arch_init(void)
 	raw_pci_ext_ops = &pci_mmcfg;
 	return 1;
 }
+
+void __init pci_mmcfg_arch_free(void)
+{
+}
Index: linux-2.6/arch/x86/pci/mmconfig_64.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/mmconfig_64.c
+++ linux-2.6/arch/x86/pci/mmconfig_64.c
@@ -127,7 +127,7 @@ static void __iomem * __init mcfg_iorema
 int __init pci_mmcfg_arch_init(void)
 {
 	int i;
-	pci_mmcfg_virt = kmalloc(sizeof(*pci_mmcfg_virt) *
+	pci_mmcfg_virt = kzalloc(sizeof(*pci_mmcfg_virt) *
 				 pci_mmcfg_config_num, GFP_KERNEL);
 	if (pci_mmcfg_virt == NULL) {
 		printk(KERN_ERR "PCI: Can not allocate memory for mmconfig structures\n");
@@ -141,9 +141,29 @@ int __init pci_mmcfg_arch_init(void)
 			printk(KERN_ERR "PCI: Cannot map mmconfig aperture for "
 					"segment %d\n",
 				pci_mmcfg_config[i].pci_segment);
+			pci_mmcfg_arch_free();
 			return 0;
 		}
 	}
 	raw_pci_ext_ops = &pci_mmcfg;
 	return 1;
 }
+
+void __init pci_mmcfg_arch_free(void)
+{
+	int i;
+
+	if (pci_mmcfg_virt == NULL)
+		return;
+
+	for (i = 0; i < pci_mmcfg_config_num; ++i) {
+		if (pci_mmcfg_virt[i].virt) {
+			iounmap(pci_mmcfg_virt[i].virt);
+			pci_mmcfg_virt[i].virt = NULL;
+			pci_mmcfg_virt[i].cfg = NULL;
+		}
+	}
+
+	kfree(pci_mmcfg_virt);
+	pci_mmcfg_virt = NULL;
+}
Index: linux-2.6/arch/x86/pci/pci.h
===================================================================
--- linux-2.6.orig/arch/x86/pci/pci.h
+++ linux-2.6/arch/x86/pci/pci.h
@@ -105,6 +105,7 @@ extern void pcibios_sort(void);
 /* pci-mmconfig.c */
 
 extern int __init pci_mmcfg_arch_init(void);
+extern void __init pci_mmcfg_arch_free(void);
 
 /*
  * AMD Fam10h CPUs are buggy, and cannot access MMIO config space
