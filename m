Return-Path: <linux-kernel-owner+w=401wt.eu-S1754072AbYCIT2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbYCIT2S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 15:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbYCIT2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 15:28:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48454 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501AbYCIT2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 15:28:06 -0400
Date: Sun, 9 Mar 2008 20:27:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: quicklists confuse meminfo
Message-ID: <20080309192745.GA16929@elte.hu>
References: <alpine.LFD.1.00.0803090919481.3099@apollo.tec.linutronix.de> <20080309111456.GA21690@elte.hu> <20080309210000.C6DE.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080309120940.GA1695@elte.hu> <20080309123432.GA3267@elte.hu> <20080309121103.3f7019d5@laptopd505.fenrus.org> <20080309192514.GA16759@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080309192514.GA16759@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > careful with this; the quicklists aren't JUST for speed they are 
> > also there to make sure a page we free that is a pagetable, is not 
> > reused until we have finished flushing the tlbs on all the cpus that 
> > saw it. This is a really hard correctness requirement, and while I 
> > can see that quicklists are probably not the best way to achieve 
> > this, we can't just throw away the behavior ;(
> 
> no, that's not true anymore - and the current quicklists code doesnt 
> do anything like that AFAICS. It used to be a lot more complex, but 
> now it's just a thin wrapper around the page allocator.

i.e. the patch below should do the trick.

(it's still work in progress but it seems to boot just fine)

	Ingo

------------>
Subject: x86: patches/remove-quicklists.patch
From: Ingo Molnar <mingo@elte.hu>
Date: Sun Mar 09 20:04:32 CET 2008

---
 arch/x86/mm/pgtable_32.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

Index: linux-x86.q/arch/x86/mm/pgtable_32.c
===================================================================
--- linux-x86.q.orig/arch/x86/mm/pgtable_32.c
+++ linux-x86.q/arch/x86/mm/pgtable_32.c
@@ -10,7 +10,6 @@
 #include <linux/pagemap.h>
 #include <linux/spinlock.h>
 #include <linux/module.h>
-#include <linux/quicklist.h>
 
 #include <asm/system.h>
 #include <asm/pgtable.h>
@@ -338,12 +337,16 @@ static void pgd_mop_up_pmds(struct mm_st
 
 pgd_t *pgd_alloc(struct mm_struct *mm)
 {
-	pgd_t *pgd = quicklist_alloc(0, GFP_KERNEL, pgd_ctor);
+	pgd_t *pgd;
+
+	pgd = (void *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
+	if (pgd)
+		pgd_ctor(pgd);
 
 	mm->pgd = pgd;		/* so that alloc_pd can use it */
 
 	if (pgd && !pgd_prepopulate_pmd(mm, pgd)) {
-		quicklist_free(0, pgd_dtor, pgd);
+		free_page((unsigned long)pgd);
 		pgd = NULL;
 	}
 
@@ -353,12 +356,12 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 {
 	pgd_mop_up_pmds(mm, pgd);
-	quicklist_free(0, pgd_dtor, pgd);
+	pgd_dtor(pgd);
+	free_page((unsigned long)pgd);
 }
 
 void check_pgt_cache(void)
 {
-	quicklist_trim(0, pgd_dtor, 25, 16);
 }
 
 void __pte_free_tlb(struct mmu_gather *tlb, struct page *pte)
