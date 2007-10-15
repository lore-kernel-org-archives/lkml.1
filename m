Return-Path: <linux-kernel-owner+w=401wt.eu-S1760705AbXJOVvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760705AbXJOVvH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 17:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758627AbXJOVtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 17:49:16 -0400
Received: from zrnetservice.com ([209.133.52.163]:33160 "EHLO
	wifi.zrnetservice.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756850AbXJOVtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 17:49:09 -0400
Message-Id: <20071015210114.814491529@goop.org>
References: <20071015204840.074767068@goop.org>
User-Agent: quilt/0.46-1
Date: Mon, 15 Oct 2007 13:48:43 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Keir Fraser <keir@xensource.com>,
       Stable Kernel <stable@kernel.org>, Christoph Lameter <clameter@sgi.com>,
       William Lee Irwin III <wli@holomorphy.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 03/12] remove dead code in pgtable_cache_init
Content-Disposition: inline; filename=x86-mminit-remove-dead-code.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The conversion from using a slab cache to quicklist left some residual
dead code.

I note that in the conversion it now always allocates a whole page for
the pgd, rather than the 32 bytes needed for a PAE pgd.  Was this
intended?

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <ak@suse.de>
Cc: William Lee Irwin III <wli@holomorphy.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/mm/init_32.c |   22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

===================================================================
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -746,24 +746,12 @@ struct kmem_cache *pmd_cache;
 
 void __init pgtable_cache_init(void)
 {
-	size_t pgd_size = PTRS_PER_PGD*sizeof(pgd_t);
-
-	if (PTRS_PER_PMD > 1) {
+	if (PTRS_PER_PMD > 1)
 		pmd_cache = kmem_cache_create("pmd",
-					PTRS_PER_PMD*sizeof(pmd_t),
-					PTRS_PER_PMD*sizeof(pmd_t),
-					SLAB_PANIC,
-					pmd_ctor);
-		if (!SHARED_KERNEL_PMD) {
-			/* If we're in PAE mode and have a non-shared
-			   kernel pmd, then the pgd size must be a
-			   page size.  This is because the pgd_list
-			   links through the page structure, so there
-			   can only be one pgd per page for this to
-			   work. */
-			pgd_size = PAGE_SIZE;
-		}
-	}
+					      PTRS_PER_PMD*sizeof(pmd_t),
+					      PTRS_PER_PMD*sizeof(pmd_t),
+					      SLAB_PANIC,
+					      pmd_ctor);
 }
 
 /*

-- 

