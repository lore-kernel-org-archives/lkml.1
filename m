Return-Path: <linux-kernel-owner+w=401wt.eu-S1756635AbYCZIOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbYCZIOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 04:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752504AbYCZIOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 04:14:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58521 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253AbYCZIOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 04:14:08 -0400
Date: Wed, 26 Mar 2008 09:13:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: quicklists confuse meminfo
Message-ID: <20080326081349.GA8159@elte.hu>
References: <alpine.LFD.1.00.0803090919481.3099@apollo.tec.linutronix.de> <20080309114640.85c9c3eb.akpm@linux-foundation.org> <Pine.LNX.4.64.0803100851560.23575@schroedinger.engr.sgi.com> <200803111507.20870.nickpiggin@yahoo.com.au> <e2e108260803210552i4cdef6a5qf8f5076eaac2cf03@mail.gmail.com> <20080321144517.GA1545@elte.hu> <e2e108260803260045q37792686l80ddb421f2e67c6f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2e108260803260045q37792686l80ddb421f2e67c6f@mail.gmail.com>
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


* Bart Van Assche <bart.vanassche@gmail.com> wrote:

> On Fri, Mar 21, 2008 at 3:45 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> >  * Bart Van Assche <bart.vanassche@gmail.com> wrote:
> >
> >  > Is anyone currently working on this
> >  > (http://bugzilla.kernel.org/show_bug.cgi?id=9991) ? I think this
> >  > should either be fixed or documented as a known issue.
> >
> >  it should be fixed in latest -git (by commit 985a34bd75cc8c9) - can you
> >  still see it?
> 
> This issue is indeed fixed now, thanks (retested with kernel version 
> 2.6.25-rc6-00333-ga4083c9-dirty). Where can I find the patch that 
> fixed this issue ? A Google query for the commit ID returned only one 
> result, and that was an URL that pointed to your e-mail.

thanks a lot Bart for the persistent testing - this was a nasty one to 
track down. Find the standalone fix below.

	Ingo

---------------->
commit 985a34bd75cc8c96e43f00dcdda7c3fdb51a3026
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Sun Mar 9 13:14:37 2008 +0100

    x86: remove quicklists
    
    quicklists cause a serious memory leak on 32-bit x86,
    as documented at:
    
      http://bugzilla.kernel.org/show_bug.cgi?id=9991
    
    the reason is that the quicklist pool is a special-purpose
    cache that grows out of proportion. It is not accounted for
    anywhere and users have no way to even realize that it's
    the quicklists that are causing RAM usage spikes. It was
    supposed to be a relatively small pool, but as demonstrated
    by KOSAKI Motohiro, they can grow as large as:
    
      Quicklists:    1194304 kB
    
    given how much trouble this code has caused historically,
    and given that Andrew objected to its introduction on x86
    (years ago), the best option at this point is to remove them.
    
    [ any performance benefits of caching constructed pgds should
      be implemented in a more generic way (possibly within the page
      allocator), while still allowing constructed pages to be
      allocated by other workloads. ]
    
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f41c953..237fc12 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -66,9 +66,6 @@ config MMU
 config ZONE_DMA
 	def_bool y
 
-config QUICKLIST
-	def_bool X86_32
-
 config SBUS
 	bool
 
diff --git a/arch/x86/mm/pgtable_32.c b/arch/x86/mm/pgtable_32.c
index 73aba71..2f9e9af 100644
--- a/arch/x86/mm/pgtable_32.c
+++ b/arch/x86/mm/pgtable_32.c
@@ -342,12 +342,16 @@ static void pgd_mop_up_pmds(struct mm_struct *mm, pgd_t *pgdp)
 
 pgd_t *pgd_alloc(struct mm_struct *mm)
 {
-	pgd_t *pgd = quicklist_alloc(0, GFP_KERNEL, pgd_ctor);
+	pgd_t *pgd = (pgd_t *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
 
-	mm->pgd = pgd;		/* so that alloc_pd can use it */
+	/* so that alloc_pd can use it */
+	mm->pgd = pgd;
+	if (pgd)
+		pgd_ctor(pgd);
 
 	if (pgd && !pgd_prepopulate_pmd(mm, pgd)) {
-		quicklist_free(0, pgd_dtor, pgd);
+		pgd_dtor(pgd);
+		free_page((unsigned long)pgd);
 		pgd = NULL;
 	}
 
@@ -357,12 +361,8 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 {
 	pgd_mop_up_pmds(mm, pgd);
-	quicklist_free(0, pgd_dtor, pgd);
-}
-
-void check_pgt_cache(void)
-{
-	quicklist_trim(0, pgd_dtor, 25, 16);
+	pgd_dtor(pgd);
+	free_page((unsigned long)pgd);
 }
 
 void __pte_free_tlb(struct mmu_gather *tlb, struct page *pte)
diff --git a/include/asm-x86/pgtable_32.h b/include/asm-x86/pgtable_32.h
index a842c72..4e6a0fc 100644
--- a/include/asm-x86/pgtable_32.h
+++ b/include/asm-x86/pgtable_32.h
@@ -26,10 +26,9 @@ struct mm_struct;
 struct vm_area_struct;
 
 extern pgd_t swapper_pg_dir[1024];
-extern struct kmem_cache *pmd_cache;
-void check_pgt_cache(void);
 
-static inline void pgtable_cache_init(void) {}
+static inline void pgtable_cache_init(void) { }
+static inline void check_pgt_cache(void) { }
 void paging_init(void);
 
 
