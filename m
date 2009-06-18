Return-Path: <linux-kernel-owner+w=401wt.eu-S1757612AbZFRSF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612AbZFRSF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 14:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752883AbZFRSFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 14:05:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:59498 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752857AbZFRSFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 14:05:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,246,1243839600"; 
   d="scan'208";a="423474209"
Date: Thu, 18 Jun 2009 11:05:14 -0700
From: Fenghua Yu <fenghua.yu@intel.com>
To: David Woodhouse <dwmw2@infradead.org>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'Ingo Molnar'" <mingo@elte.hu>,
       "'Christopher Wright'" <chrisw@redhat.com>,
       "'Allen Kay'" <allen.m.kay@intel.com>
Cc: "'lkml'" <linux-kernel@vger.kernel.org>,
       "'iommu'" <iommu@lists.linux-foundation.org>
Subject: [PATCH 1/2] IOMMU Identity Mapping Support: iommu_identity_mapping definition
Message-ID: <20090618180514.GA24082@linux-os.sc.intel.com>
References: <20090327212241.234500000@intel.com> <20090327212321.070229000@intel.com> <20090416001957.GA1527@linux-os.sc.intel.com> <1240135508.3589.75.camel@macbook.infradead.org> <A6AD88C3F2289247BE726C37303E1EB8A4DF7DB1@orsmsx505.amr.corp.intel.com> <20090513231351.GA22386@linux-os.sc.intel.com> <1242314271.3393.11.camel@macbook.infradead.org> <20090514175944.GA5168@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090514175944.GA5168@linux-os.sc.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IOMMU Identity Mapping Support: iommu_identity_mapping definition

Identity mapping for IOMMU defines a single domain to 1:1 map all pci devices
to all usable memory.

This will reduces map/unmap overhead in DMA API's and improve IOMMU performance.
On 10Gb network cards, Netperf shows no performance degradation compared to
non-IOMMU performance.

This method may lose some of DMA remapping benefits like isolation.

The first patch defines iommu_identity_mapping varialbe which controls the
identity mapping code and is 0 by default.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>

---

 Documentation/kernel-parameters.txt |    1 +
 arch/ia64/include/asm/iommu.h       |    2 ++
 arch/ia64/kernel/pci-dma.c          |    1 +
 arch/x86/include/asm/iommu.h        |    1 +
 arch/x86/kernel/pci-dma.c           |    5 +++++
 5 files changed, 10 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 4b78797..6b1d7b4 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -988,6 +988,7 @@ and is between 256 and 4096 characters. It is defined in the file
 		forcesac
 		soft
 		pt	[x86, IA64]
+		identity [x86, IA64]
 
 	io7=		[HW] IO7 for Marvel based alpha systems
 			See comment before marvel_specify_io7 in
diff --git a/arch/ia64/include/asm/iommu.h b/arch/ia64/include/asm/iommu.h
index 745e095..cc6d59f 100644
--- a/arch/ia64/include/asm/iommu.h
+++ b/arch/ia64/include/asm/iommu.h
@@ -11,8 +11,10 @@ extern int force_iommu, no_iommu;
 extern int iommu_detected;
 #ifdef	CONFIG_DMAR
 extern int iommu_pass_through;
+extern int iommu_identity_mapping;
 #else
 #define iommu_pass_through	(0)
+#define iommu_identity_mapping  (0)
 #endif
 extern void iommu_dma_init(void);
 extern void machvec_init(const char *name);
diff --git a/arch/ia64/kernel/pci-dma.c b/arch/ia64/kernel/pci-dma.c
index 0569596..15b8555 100644
--- a/arch/ia64/kernel/pci-dma.c
+++ b/arch/ia64/kernel/pci-dma.c
@@ -33,6 +33,7 @@ int force_iommu __read_mostly;
 #endif
 
 int iommu_pass_through;
+int iommu_identity_mapping;
 
 /* Dummy device used for NULL arguments (normally ISA). Better would
    be probably a smaller DMA mask, but this is bug-to-bug compatible
diff --git a/arch/x86/include/asm/iommu.h b/arch/x86/include/asm/iommu.h
index fd6d21b..d2aee4a 100644
--- a/arch/x86/include/asm/iommu.h
+++ b/arch/x86/include/asm/iommu.h
@@ -7,6 +7,7 @@ extern struct dma_map_ops nommu_dma_ops;
 extern int force_iommu, no_iommu;
 extern int iommu_detected;
 extern int iommu_pass_through;
+extern int iommu_identity_mapping;
 
 /* 10 seconds */
 #define DMAR_OPERATION_TIMEOUT ((cycles_t) tsc_khz*10*1000)
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 049005e..489179a 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -33,6 +33,7 @@ int no_iommu __read_mostly;
 int iommu_detected __read_mostly = 0;
 
 int iommu_pass_through;
+int iommu_identity_mapping;
 
 dma_addr_t bad_dma_address __read_mostly = 0;
 EXPORT_SYMBOL(bad_dma_address);
@@ -208,6 +209,10 @@ static __init int iommu_setup(char *p)
 			forbid_dac = -1;
 			return 1;
 		}
+		if (!strncmp(p, "identity", 8)) {
+			iommu_identity_mapping = 1;
+			return 1;
+		}
 #ifdef CONFIG_SWIOTLB
 		if (!strncmp(p, "soft", 4))
 			swiotlb = 1;
