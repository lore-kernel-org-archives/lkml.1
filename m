Return-Path: <linux-kernel-owner+w=401wt.eu-S1753117AbYKNNsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbYKNNsX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 08:48:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbYKNNsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 08:48:15 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44099 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbYKNNsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 08:48:14 -0500
Subject: [PATCH] Revert "x86: blacklist DMAR on Intel G31/G33 chipsets"
From: David Woodhouse <dwmw2@infradead.org>
To: torvalds@linux-foundation.org
Cc: mingo@elte.hu, iommu@lists.linux-foundation.org, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200810111900.m9BJ0eCH008374@hera.kernel.org>
References: <200810111900.m9BJ0eCH008374@hera.kernel.org>
Content-Type: text/plain
Date: Fri, 14 Nov 2008 13:47:31 +0000
Message-Id: <1226670451.3687.273.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit e51af6630848406fc97adbd71443818cdcda297b, which was
wrongly hoovered up and submitted about a month after a better fix had
already been merged.

The better fix is commit cbda1ba898647aeb4ee770b803c922f595e97731
("PCI/iommu: blacklist DMAR on Intel G31/G33 chipsets"), where we do
this blacklisting based on the DMI identification for the offending
motherboard, since sometimes this chipset (or at least a chipset with
the same PCI ID) apparently _does_ actually have an IOMMU.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

diff --git a/arch/x86/include/asm/iommu.h b/arch/x86/include/asm/iommu.h
index e4a552d..0b500c5 100644
--- a/arch/x86/include/asm/iommu.h
+++ b/arch/x86/include/asm/iommu.h
@@ -6,7 +6,6 @@ extern void no_iommu_init(void);
 extern struct dma_mapping_ops nommu_dma_ops;
 extern int force_iommu, no_iommu;
 extern int iommu_detected;
-extern int dmar_disabled;
 
 extern unsigned long iommu_nr_pages(unsigned long addr, unsigned long len);
 
diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 3ce029f..1b894b7 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -188,20 +188,6 @@ static void __init ati_bugs_contd(int num, int slot, int func)
 }
 #endif
 
-#ifdef CONFIG_DMAR
-static void __init intel_g33_dmar(int num, int slot, int func)
-{
-	struct acpi_table_header *dmar_tbl;
-	acpi_status status;
-
-	status = acpi_get_table(ACPI_SIG_DMAR, 0, &dmar_tbl);
-	if (ACPI_SUCCESS(status)) {
-		printk(KERN_INFO "BIOS BUG: DMAR advertised on Intel G31/G33 chipset -- ignoring\n");
-		dmar_disabled = 1;
-	}
-}
-#endif
-
 #define QFLAG_APPLY_ONCE 	0x1
 #define QFLAG_APPLIED		0x2
 #define QFLAG_DONE		(QFLAG_APPLY_ONCE|QFLAG_APPLIED)
@@ -225,10 +211,6 @@ static struct chipset early_qrk[] __initdata = {
 	  PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_bugs },
 	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS,
 	  PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_bugs_contd },
-#ifdef CONFIG_DMAR
-	{ PCI_VENDOR_ID_INTEL, 0x29c0,
-	  PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, intel_g33_dmar },
-#endif
 	{}
 };
 


-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

