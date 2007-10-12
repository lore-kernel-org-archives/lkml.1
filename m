Return-Path: <linux-kernel-owner+w=401wt.eu-S1760959AbXJLVtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760959AbXJLVtW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 17:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758459AbXJLVoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 17:44:46 -0400
Received: from 224.sub-75-208-255.myvzw.com ([75.208.255.224]:42276 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760525AbXJLVon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 17:44:43 -0400
Message-Id: <20071012211147.666677000@goop.org>
References: <20071012211132.198718000@goop.org>
User-Agent: quilt/0.46-1
Date: Fri, 12 Oct 2007 14:11:33 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Keir Fraser <keir@xensource.com>,
       Christoph Lameter <clameter@sgi.com>, Andi Kleen <ak@suse.de>,
       William Lee Irwin III <wli@holomorphy.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 01/10] remove dead code in pgtable_cache_init
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
 arch/i386/mm/init.c |   22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

===================================================================
--- a/arch/i386/mm/init.c
+++ b/arch/i386/mm/init.c
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

