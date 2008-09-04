Return-Path: <linux-kernel-owner+w=401wt.eu-S1756491AbYIDIyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491AbYIDIyt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 04:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751895AbYIDIyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 04:54:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:36555 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbYIDIyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 04:54:40 -0400
Subject: [PATCH] Blacklist DMAR on Intel G31/G33 chipsets
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: andi@firstfloor.org, arjan@infradead.org, sfr@canb.auug.org.au
In-Reply-To: <1220439231.2985.103.camel@pmac.infradead.org>
References: <1220439231.2985.103.camel@pmac.infradead.org>
Content-Type: text/plain
Date: Thu, 04 Sep 2008 09:54:37 +0100
Message-Id: <1220518477.2985.163.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some BIOSes (the Intel DG33BU, for example) wrongly claim to have DMAR
when they don't. Avoid the resulting crashes when it doesn't work as
expected.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---

This time, I build-tested it with CONFIG_DMAR actually enabled. Sorry.
I'd still be grateful if someone could test it on a DG33BU with the old
BIOS though, since I've killed mine. I tested the DMI version, but not
this one.

 arch/x86/kernel/early-quirks.c |   18 ++++++++++++++++++
 drivers/pci/intel-iommu.c      |    2 +-
 include/asm-x86/iommu.h        |    1 +
 3 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 4353cf5..24bb5fa 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -95,6 +95,20 @@ static void __init nvidia_bugs(int num, int slot, int func)
 
 }
 
+#ifdef CONFIG_DMAR
+static void __init intel_g33_dmar(int num, int slot, int func)
+{
+	struct acpi_table_header *dmar_tbl;
+	acpi_status status;
+
+	status = acpi_get_table(ACPI_SIG_DMAR, 0, &dmar_tbl);
+	if (ACPI_SUCCESS(status)) {
+		printk(KERN_INFO "BIOS BUG: DMAR advertised on Intel G31/G33 chipset -- ignoring\n");
+		dmar_disabled = 1;
+	}
+}
+#endif
+
 #define QFLAG_APPLY_ONCE 	0x1
 #define QFLAG_APPLIED		0x2
 #define QFLAG_DONE		(QFLAG_APPLY_ONCE|QFLAG_APPLIED)
@@ -114,6 +128,10 @@ static struct chipset early_qrk[] __initdata = {
 	  PCI_CLASS_BRIDGE_PCI, PCI_ANY_ID, QFLAG_APPLY_ONCE, via_bugs },
 	{ PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB,
 	  PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, fix_hypertransport_config },
+#ifdef CONFIG_DMAR
+	{ PCI_VENDOR_ID_INTEL, 0x29c0,
+	  PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, intel_g33_dmar },
+#endif
 	{}
 };
 
diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 8d0e60a..eaba6ec 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -80,7 +80,7 @@ static long list_size;
 
 static void domain_remove_dev_info(struct dmar_domain *domain);
 
-static int dmar_disabled;
+int dmar_disabled;
 static int __initdata dmar_map_gfx = 1;
 static int dmar_forcedac;
 static int intel_iommu_strict;
diff --git a/include/asm-x86/iommu.h b/include/asm-x86/iommu.h
index 5f888cc..621a1af 100644
--- a/include/asm-x86/iommu.h
+++ b/include/asm-x86/iommu.h
@@ -6,6 +6,7 @@ extern void no_iommu_init(void);
 extern struct dma_mapping_ops nommu_dma_ops;
 extern int force_iommu, no_iommu;
 extern int iommu_detected;
+extern int dmar_disabled;
 
 extern unsigned long iommu_num_pages(unsigned long addr, unsigned long len);
 
-- 
1.5.5.1
-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



