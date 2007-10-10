Return-Path: <linux-kernel-owner+w=401wt.eu-S1756841AbXJJUjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbXJJUjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 16:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755514AbXJJUjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 16:39:17 -0400
Received: from gw.goop.org ([64.81.55.164]:35441 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752833AbXJJUjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 16:39:16 -0400
Message-ID: <470D3846.1000209@goop.org>
Date: Wed, 10 Oct 2007 13:38:30 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Andi Kleen <ak@suse.de>, William Lee Irwin III <wli@holomorphy.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] i386:  remove dead code in pgtable_cache_init
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The conversion from using a slab cache to quicklist left some residual dead code.

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

