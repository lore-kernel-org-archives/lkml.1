Return-Path: <linux-kernel-owner+w=401wt.eu-S1758831AbYA2Aef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758831AbYA2Aef (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 19:34:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758773AbYA2AdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 19:33:23 -0500
Received: from zrnetservice.com ([209.133.52.163]:50316 "EHLO
	www.zrnetservice.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758116AbYA2AdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 19:33:22 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 1 of 4] x86: unify PAE/non-PAE pgd_ctor
X-Mercurial-Node: 3bf362a4b0534ec44feb78a67cf2f846a7070e21
Message-Id: <3bf362a4b0534ec44feb.1201564121@localhost>
In-Reply-To: <patchbomb.1201564120@localhost>
Date: Mon, 28 Jan 2008 15:48:41 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, H Peter Anvin <hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The constructors for PAE and non-PAE pgd_ctors are more or less
identical, and can be made into the same function.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: William Irwin <wli@holomorphy.com>

---
 arch/x86/mm/pgtable_32.c |   58 +++++++++++++++++-----------------------------
 1 file changed, 22 insertions(+), 36 deletions(-)

diff --git a/arch/x86/mm/pgtable_32.c b/arch/x86/mm/pgtable_32.c
--- a/arch/x86/mm/pgtable_32.c
+++ b/arch/x86/mm/pgtable_32.c
@@ -219,50 +219,39 @@ static inline void pgd_list_del(pgd_t *p
 	list_del(&page->lru);
 }
 
+#define UNSHARED_PTRS_PER_PGD				\
+	(SHARED_KERNEL_PMD ? USER_PTRS_PER_PGD : PTRS_PER_PGD)
 
-
-#if (PTRS_PER_PMD == 1)
-/* Non-PAE pgd constructor */
-static void pgd_ctor(void *pgd)
+static void pgd_ctor(void *p)
 {
+	pgd_t *pgd = p;
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
+	/* If the pgd points to a shared pagetable level (either the
+	   ptes in non-PAE, or shared PMD in PAE), then just copy the
+	   references from swapper_pg_dir. */
+	if (PAGETABLE_LEVELS == 2 ||
+	    (PAGETABLE_LEVELS == 3 && SHARED_KERNEL_PMD)) {
+		clone_pgd_range(pgd + USER_PTRS_PER_PGD,
+				swapper_pg_dir + USER_PTRS_PER_PGD,
 				KERNEL_PGD_PTRS);
-	pgd_list_add(pgd);
+		paravirt_alloc_pd_clone(__pa(pgd) >> PAGE_SHIFT,
+					__pa(swapper_pg_dir) >> PAGE_SHIFT,
+					USER_PTRS_PER_PGD,
+					KERNEL_PGD_PTRS);
+	}
+
+	/* list required to sync kernel mapping updates */
+	if (!SHARED_KERNEL_PMD)
+		pgd_list_add(pgd);
+
 	spin_unlock_irqrestore(&pgd_lock, flags);
 }
-#else  /* PTRS_PER_PMD > 1 */
-/* PAE pgd constructor */
-static void pgd_ctor(void *pgd)
-{
-	/* PAE, kernel PMD may be shared */
-
-	if (SHARED_KERNEL_PMD) {
-		clone_pgd_range((pgd_t *)pgd + USER_PTRS_PER_PGD,
-				swapper_pg_dir + USER_PTRS_PER_PGD,
-				KERNEL_PGD_PTRS);
-	} else {
-		unsigned long flags;
-
-		memset(pgd, 0, USER_PTRS_PER_PGD*sizeof(pgd_t));
-		spin_lock_irqsave(&pgd_lock, flags);
-		pgd_list_add(pgd);
-		spin_unlock_irqrestore(&pgd_lock, flags);
-	}
-}
-#endif	/* PTRS_PER_PMD */
 
 static void pgd_dtor(void *pgd)
 {
@@ -275,9 +264,6 @@ static void pgd_dtor(void *pgd)
 	pgd_list_del(pgd);
 	spin_unlock_irqrestore(&pgd_lock, flags);
 }
-
-#define UNSHARED_PTRS_PER_PGD				\
-	(SHARED_KERNEL_PMD ? USER_PTRS_PER_PGD : PTRS_PER_PGD)
 
 #ifdef CONFIG_X86_PAE
 /*


