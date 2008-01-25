Return-Path: <linux-kernel-owner+w=401wt.eu-S1761111AbYAYVrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761111AbYAYVrn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 16:47:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757509AbYAYVrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 16:47:22 -0500
Received: from 42.sub-75-208-60.myvzw.com ([75.208.60.42]:48626 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756882AbYAYVrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 16:47:21 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 06 of 11] x86: unify PAE/non-PAE pgd_ctor
X-Mercurial-Node: 29b340beedff768ba811c40fd9ef851107522ca5
Message-Id: <29b340beedff768ba811.1201296195@localhost>
In-Reply-To: <patchbomb.1201296189@localhost>
Date: Fri, 25 Jan 2008 13:23:15 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, H Peter Anvin <hpa@zytor.com>,
       William Irwin <wli@holomorphy.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The constructors for PAE and non-PAE pgd_ctors are more or less
identical, and can be made into the same function.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: William Irwin <wli@holomorphy.com>

---
 arch/x86/mm/pgtable_32.c |   43 +++++++++++--------------------------------
 1 file changed, 11 insertions(+), 32 deletions(-)

diff --git a/arch/x86/mm/pgtable_32.c b/arch/x86/mm/pgtable_32.c
--- a/arch/x86/mm/pgtable_32.c
+++ b/arch/x86/mm/pgtable_32.c
@@ -224,50 +224,32 @@ static inline void pgd_list_del(pgd_t *p
 	list_del(&page->lru);
 }
 
+#define UNSHARED_PTRS_PER_PGD				\
+	(SHARED_KERNEL_PMD ? USER_PTRS_PER_PGD : PTRS_PER_PGD)
 
-
-#if (PTRS_PER_PMD == 1)
-/* Non-PAE pgd constructor */
 static void pgd_ctor(void *pgd)
 {
 	unsigned long flags;
 
-	/* !PAE, no pagetable sharing */
+	/* Clear usermode parts of PGD */
 	memset(pgd, 0, USER_PTRS_PER_PGD*sizeof(pgd_t));
 
 	spin_lock_irqsave(&pgd_lock, flags);
 
-	/* must happen under lock */
-	clone_pgd_range((pgd_t *)pgd + USER_PTRS_PER_PGD,
-			swapper_pg_dir + USER_PTRS_PER_PGD,
-			KERNEL_PGD_PTRS);
-	paravirt_alloc_pd_clone(__pa(pgd) >> PAGE_SHIFT,
-				__pa(swapper_pg_dir) >> PAGE_SHIFT,
-				USER_PTRS_PER_PGD,
-				KERNEL_PGD_PTRS);
-	pgd_list_add(pgd);
-	spin_unlock_irqrestore(&pgd_lock, flags);
-}
-#else  /* PTRS_PER_PMD > 1 */
-/* PAE pgd constructor */
-static void pgd_ctor(void *pgd)
-{
-	/* PAE, kernel PMD may be shared */
-
 	if (SHARED_KERNEL_PMD) {
+		/* must happen under lock */
 		clone_pgd_range((pgd_t *)pgd + USER_PTRS_PER_PGD,
 				swapper_pg_dir + USER_PTRS_PER_PGD,
 				KERNEL_PGD_PTRS);
-	} else {
-		unsigned long flags;
+		paravirt_alloc_pd_clone(__pa(pgd) >> PAGE_SHIFT,
+					__pa(swapper_pg_dir) >> PAGE_SHIFT,
+					USER_PTRS_PER_PGD,
+					KERNEL_PGD_PTRS);
+	} else
+		pgd_list_add(pgd);
 
-		memset(pgd, 0, USER_PTRS_PER_PGD*sizeof(pgd_t));
-		spin_lock_irqsave(&pgd_lock, flags);
-		pgd_list_add(pgd);
-		spin_unlock_irqrestore(&pgd_lock, flags);
-	}
+	spin_unlock_irqrestore(&pgd_lock, flags);
 }
-#endif	/* PTRS_PER_PMD */
 
 static void pgd_dtor(void *pgd)
 {
@@ -281,9 +263,6 @@ static void pgd_dtor(void *pgd)
 	pgd_list_del(pgd);
 	spin_unlock_irqrestore(&pgd_lock, flags);
 }
-
-#define UNSHARED_PTRS_PER_PGD				\
-	(SHARED_KERNEL_PMD ? USER_PTRS_PER_PGD : PTRS_PER_PGD)
 
 /* If we allocate a pmd for part of the kernel address space, then
    make sure its initialized with the appropriate kernel mappings.


