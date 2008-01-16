Return-Path: <linux-kernel-owner+w=401wt.eu-S1752262AbYAPWGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbYAPWGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 17:06:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbYAPWGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 17:06:13 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:51576 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbYAPWGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 17:06:08 -0500
Date: Wed, 16 Jan 2008 14:08:26 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 1/2] x86: clear pci_mmcfg_virt when mmcfg get rejected
In-reply-to: <200801161405.17889.yinghai.lu@sun.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Jeff Garzik <jeff@garzik.org>,
       Greg KH <greg@kroah.com>, Robert Hancock <hancockr@shaw.ca>,
       Andi Kleen <ak@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-id: <200801161408.27072.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200801161405.17889.yinghai.lu@sun.com>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86: clear pci_mmcfg_virt when mmcfg get rejected

for x86_64, need to free pci_mmcfg_virt, and iounmap some pointers
when MMCONF is not reserved in E820 or acpi _CRS and get rejected

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Index: linux-2.6/arch/x86/pci/mmconfig-shared.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/mmconfig-shared.c
+++ linux-2.6/arch/x86/pci/mmconfig-shared.c
@@ -333,6 +333,7 @@ static void __init pci_mmcfg_reject_brok
 
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
@@ -146,3 +146,7 @@ int __init pci_mmcfg_arch_init(void)
 	raw_pci_ops = &pci_mmcfg;
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
@@ -135,7 +135,7 @@ int __init pci_mmcfg_arch_reachable(unsi
 int __init pci_mmcfg_arch_init(void)
 {
 	int i;
-	pci_mmcfg_virt = kmalloc(sizeof(*pci_mmcfg_virt) *
+	pci_mmcfg_virt = kzalloc(sizeof(*pci_mmcfg_virt) *
 				 pci_mmcfg_config_num, GFP_KERNEL);
 	if (pci_mmcfg_virt == NULL) {
 		printk(KERN_ERR "PCI: Can not allocate memory for mmconfig structures\n");
@@ -149,9 +149,29 @@ int __init pci_mmcfg_arch_init(void)
 			printk(KERN_ERR "PCI: Cannot map mmconfig aperture for "
 					"segment %d\n",
 				pci_mmcfg_config[i].pci_segment);
+			pci_mmcfg_arch_free();
 			return 0;
 		}
 	}
 	raw_pci_ops = &pci_mmcfg;
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
@@ -105,6 +105,7 @@ extern DECLARE_BITMAP(pci_mmcfg_fallback
 extern int __init pci_mmcfg_arch_reachable(unsigned int seg, unsigned int bus,
 					   unsigned int devfn);
 extern int __init pci_mmcfg_arch_init(void);
+extern void __init pci_mmcfg_arch_free(void);
 
 /*
  * AMD Fam10h CPUs are buggy, and cannot access MMIO config space
