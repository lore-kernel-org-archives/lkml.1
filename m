Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965475Ab0BZRQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 12:16:18 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:3914 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965457Ab0BZRQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 12:16:09 -0500
X-IronPort-AV: E=Sophos;i="4.49,547,1262581200"; 
   d="scan'208";a="85874842"
From: Ian Campbell <ian.campbell@citrix.com>
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <ian.campbell@citrix.com>, Alok Kataria <akataria@vmware.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH 2/3] vmi: disable highmem PTE allocation even when CONFIG_HIGHPTE=y
Date: Fri, 26 Feb 2010 17:16:01 +0000
Message-Id: <1267204562-11844-2-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1267204547.11737.12659.camel@zakaz.uk.xensource.com>
References: <1267204547.11737.12659.camel@zakaz.uk.xensource.com>
X-OriginalArrivalTime: 26 Feb 2010 17:16:08.0548 (UTC) FILETIME=[62E79A40:01CAB707]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preventing HIGHPTE allocations under VMI will allow us to remove the
kmap_atomic_pte paravirt op.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Alok Kataria <akataria@vmware.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
---
 arch/x86/kernel/vmi_32.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/vmi_32.c b/arch/x86/kernel/vmi_32.c
index d430e4c..58aca86 100644
--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -33,6 +33,7 @@
 #include <asm/fixmap.h>
 #include <asm/apicdef.h>
 #include <asm/apic.h>
+#include <asm/pgalloc.h>
 #include <asm/processor.h>
 #include <asm/timer.h>
 #include <asm/vmi_time.h>
@@ -272,19 +273,11 @@ static void *vmi_kmap_atomic_pte(struct page *page, enum km_type type)
 	void *va = kmap_atomic(page, type);
 
 	/*
-	 * Internally, the VMI ROM must map virtual addresses to physical
-	 * addresses for processing MMU updates.  By the time MMU updates
-	 * are issued, this information is typically already lost.
-	 * Fortunately, the VMI provides a cache of mapping slots for active
-	 * page tables.
-	 *
-	 * We use slot zero for the linear mapping of physical memory, and
-	 * in HIGHPTE kernels, slot 1 and 2 for KM_PTE0 and KM_PTE1.
-	 *
-	 *  args:                 SLOT                 VA    COUNT PFN
+	 * We disable highmem allocations for page tables so we should never
+	 * see any calls to kmap_atomic_pte on a highmem page.
 	 */
-	BUG_ON(type != KM_PTE0 && type != KM_PTE1);
-	vmi_ops.set_linear_mapping((type - KM_PTE0)+1, va, 1, page_to_pfn(page));
+
+	BUG_ON(PageHighmem(page));
 
 	return va;
 }
@@ -640,6 +633,12 @@ static inline int __init activate_vmi(void)
 	u64 reloc;
 	const struct vmi_relocation_info *rel = (struct vmi_relocation_info *)&reloc;
 
+	/*
+	 * Prevent page tables from being allocated in highmem, even if
+	 * CONFIG_HIGHPTE is enabled.
+	 */
+	__userpte_alloc_gfp &= ~__GFP_HIGHMEM;
+
 	if (call_vrom_func(vmi_rom, vmi_init) != 0) {
 		printk(KERN_ERR "VMI ROM failed to initialize!");
 		return 0;
-- 
1.5.6.5

