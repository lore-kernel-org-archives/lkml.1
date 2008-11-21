Return-Path: <linux-kernel-owner+w=401wt.eu-S1757420AbYKUQ4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420AbYKUQ4T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 11:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753860AbYKUQ4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 11:56:09 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45209 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752999AbYKUQ4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 11:56:08 -0500
Subject: [PATCH 1/2] intel-iommu: trivially inline context entry macros
From: Mark McLoughlin <markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, x86@kernel.org
In-Reply-To: <1227286258.3693.101.camel@blaa>
References: <1227191861.4901.24.camel@macbook.infradead.org>
	 <1227196190-488-1-git-send-email-markmc@redhat.com>
	 <1227196190-488-2-git-send-email-markmc@redhat.com>
	 <1227196190-488-3-git-send-email-markmc@redhat.com>
	 <20081120191135.GB3955@elte.hu>  <1227286258.3693.101.camel@blaa>
Content-Type: text/plain
Date: Fri, 21 Nov 2008 16:54:46 +0000
Message-Id: <1227286486.3693.103.camel@blaa>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some macros were unused, so I just dropped them:

  context_fault_disable
  context_translation_type
  context_address_root
  context_address_width
  context_domain_id

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 drivers/pci/intel-iommu.c |   85
+++++++++++++++++++++++++++++----------------
 1 files changed, 55 insertions(+), 30 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index aec60ad..884291b 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -105,28 +105,53 @@ struct context_entry {
 	u64 lo;
 	u64 hi;
 };
-#define context_present(c) ((c).lo & 1)
-#define context_fault_disable(c) (((c).lo >> 1) & 1)
-#define context_translation_type(c) (((c).lo >> 2) & 3)
-#define context_address_root(c) ((c).lo & VTD_PAGE_MASK)
-#define context_address_width(c) ((c).hi &  7)
-#define context_domain_id(c) (((c).hi >> 8) & ((1 << 16) - 1))
-
-#define context_set_present(c) do {(c).lo |= 1;} while (0)
-#define context_set_fault_enable(c) \
-	do {(c).lo &= (((u64)-1) << 2) | 1;} while (0)
-#define context_set_translation_type(c, val) \
-	do { \
-		(c).lo &= (((u64)-1) << 4) | 3; \
-		(c).lo |= ((val) & 3) << 2; \
-	} while (0)
+
+static inline bool context_present(struct context_entry *context)
+{
+	return (context->lo & 1);
+}
+static inline void context_set_present(struct context_entry *context)
+{
+	context->lo |= 1;
+}
+
+static inline void context_set_fault_enable(struct context_entry
*context)
+{
+	context->lo &= (((u64)-1) << 2) | 1;
+}
+
 #define CONTEXT_TT_MULTI_LEVEL 0
-#define context_set_address_root(c, val) \
-	do {(c).lo |= (val) & VTD_PAGE_MASK; } while (0)
-#define context_set_address_width(c, val) do {(c).hi |= (val) & 7;}
while (0)
-#define context_set_domain_id(c, val) \
-	do {(c).hi |= ((val) & ((1 << 16) - 1)) << 8;} while (0)
-#define context_clear_entry(c) do {(c).lo = 0; (c).hi = 0;} while (0)
+
+static inline void context_set_translation_type(struct context_entry
*context,
+						unsigned long value)
+{
+	context->lo &= (((u64)-1) << 4) | 3;
+	context->lo |= (value & 3) << 2;
+}
+
+static inline void context_set_address_root(struct context_entry
*context,
+					    unsigned long value)
+{
+	context->lo |= value & VTD_PAGE_MASK;
+}
+
+static inline void context_set_address_width(struct context_entry
*context,
+					     unsigned long value)
+{
+	context->hi |= value & 7;
+}
+
+static inline void context_set_domain_id(struct context_entry *context,
+					 unsigned long value)
+{
+	context->hi |= (value & ((1 << 16) - 1)) << 8;
+}
+
+static inline void context_clear_entry(struct context_entry *context)
+{
+	context->lo = 0;
+	context->hi = 0;
+}
 
 /*
  * 0: readable
@@ -349,7 +374,7 @@ static int device_context_mapped(struct intel_iommu
*iommu, u8 bus, u8 devfn)
 		ret = 0;
 		goto out;
 	}
-	ret = context_present(context[devfn]);
+	ret = context_present(&context[devfn]);
 out:
 	spin_unlock_irqrestore(&iommu->lock, flags);
 	return ret;
@@ -365,7 +390,7 @@ static void clear_context_table(struct intel_iommu
*iommu, u8 bus, u8 devfn)
 	root = &iommu->root_entry[bus];
 	context = get_context_addr_from_root(root);
 	if (context) {
-		context_clear_entry(context[devfn]);
+		context_clear_entry(&context[devfn]);
 		__iommu_flush_cache(iommu, &context[devfn], \
 			sizeof(*context));
 	}
@@ -1284,17 +1309,17 @@ static int domain_context_mapping_one(struct
dmar_domain *domain,
 	if (!context)
 		return -ENOMEM;
 	spin_lock_irqsave(&iommu->lock, flags);
-	if (context_present(*context)) {
+	if (context_present(context)) {
 		spin_unlock_irqrestore(&iommu->lock, flags);
 		return 0;
 	}
 
-	context_set_domain_id(*context, domain->id);
-	context_set_address_width(*context, domain->agaw);
-	context_set_address_root(*context, virt_to_phys(domain->pgd));
-	context_set_translation_type(*context, CONTEXT_TT_MULTI_LEVEL);
-	context_set_fault_enable(*context);
-	context_set_present(*context);
+	context_set_domain_id(context, domain->id);
+	context_set_address_width(context, domain->agaw);
+	context_set_address_root(context, virt_to_phys(domain->pgd));
+	context_set_translation_type(context, CONTEXT_TT_MULTI_LEVEL);
+	context_set_fault_enable(context);
+	context_set_present(context);
 	__iommu_flush_cache(iommu, context, sizeof(*context));
 
 	/* it's a non-present to present mapping */
-- 
1.6.0.3

