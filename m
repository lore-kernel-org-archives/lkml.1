Return-Path: <linux-kernel-owner+w=401wt.eu-S1758133AbZBTRAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133AbZBTRAl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 12:00:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754369AbZBTRAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 12:00:33 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55352 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753983AbZBTRAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 12:00:32 -0500
Date: Fri, 20 Feb 2009 17:59:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Huang Ying <ying.huang@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: use the right protections for split-up pagetables
Message-ID: <20090220165955.GA8347@elte.hu>
References: <20090220011316.379904625@goodmis.org> <alpine.LFD.2.00.0902191753240.21686@localhost.localdomain> <alpine.DEB.1.10.0902192107230.31658@gandalf.stny.rr.com> <alpine.LFD.2.00.0902191923300.21686@localhost.localdomain> <20090220072915.GB28085@elte.hu> <alpine.LFD.2.00.0902200728520.21686@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902200728520.21686@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, 20 Feb 2009, Ingo Molnar wrote:
> > 
> > Agreed, split_large_page() was just plain confused here - there 
> > was no hidden reason for this logic. It makes no sense to bring 
> > any pte level protection information to the PMD level because a 
> > pmd entry covers a set of 512 ptes so there's no singular 
> > protection attribute that can be carried to it.
> 
> Btw, I think split_large_page() is confused in another way 
> too, although I'm not entirely sure that it matters. I suspect 
> that it doesn't, if I read things correctly.
> 
> The confusion? When it moves the 'ref_prot' bits from the 
> upper level, it doesn't do the right thing for the PAT bit. 
> That bit is special, and moves around depending on level. In 
> the upper levels, it's bit#12, and in the final 4k pte level 
> it's bit#7.
> 
> So _if_ the PAT bit ever matters, it looks like 
> split_large_page() does the wrong thing.
> 
> Now, it looks like we avoid the PAT bit on purpose, and we 
> only ever encode four PAT values (ie we use only the PCD/PWT 
> bits, and leave the PAT bit clear - we don't need any more 
> cases), _but_ we actually do end up looking at the PAT bit 
> anyway in cache_attr(). So it looks like at least some of the 
> code is _trying_ to handle the PAT bit, but I can pretty much 
> guarantee that at least split_large_page() is broken if it is 
> ever set.

Yeah. This our current PAT encodings table:

        /*
         * PTE encoding used in Linux:
         *      PAT
         *      |PCD
         *      ||PWT
         *      |||
         *      000 WB          _PAGE_CACHE_WB
         *      001 WC          _PAGE_CACHE_WC
         *      010 UC-         _PAGE_CACHE_UC_MINUS
         *      011 UC          _PAGE_CACHE_UC
         * PAT bit unused
         */
        pat = PAT(0, WB) | PAT(1, WC) | PAT(2, UC_MINUS) | PAT(3, UC) |
              PAT(4, WB) | PAT(5, WC) | PAT(6, UC_MINUS) | PAT(7, UC);

it's intentionally left compressed and the extended PAT bit is 
never set, we only need 4 caching types.

( Speculation: in theory it would be possible for some CPU's
  TLB-fill fastpath to have some small penalty on having a 
  non-zero extended-PAT bit. So eliminating weird bits and 
  compressing pte bit usage is always a good idea. )

Nevertheless you are right that there's a disconnect here and 
that were it ever set we'd unconditionally lift the 2MB/1GB PAT 
bit [bit 12] over into the 4K level.

If we ever set the PAT bit on a large page then the 
split_large_page() behavior would become rather nasty: we'd 
corrupt pte bit 12, i.e. we'd lose linear mappings, we'd map 
every even page twice (and not map any uneven pages), and we'd 
start corrupting memory and would crash in interesting ways.

There's two solutions:

 - make the ref_prot opt-in and explicitly enumerate all the
   bits we handle correctly today

 - add a debug warning for the bits we know we dont handle

I went for the second as the first one would include basically 
all the meaningful bits we have:

   [_PAGE_BIT_PRESENT]
    _PAGE_BIT_RW
    _PAGE_BIT_USER
    _PAGE_BIT_PWT
    _PAGE_BIT_PCD 
   [_PAGE_BIT_ACCESSED]
   [_PAGE_BIT_DIRTY]
    _PAGE_BIT_GLOBAL 
    _PAGE_BIT_NX

( the ones in brackets are not important because we set/clear 
  them anyway, but they dont hurt either. )

And if we do not include PAT and it gets used in the future the 
function could break too - just in different ways. (by not 
carrying over the PAT bit.)

So i think it's safest to put in a sharp debug check for the 
known-unhandled bit. I've queued up the fix below in tip:x86/mm, 
do you think this approach is the best?
 
	Ingo

-------------------->
>From 7a5714e0186030676d79a7b4b9830c8e45c3b0a1 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 20 Feb 2009 17:44:21 +0100
Subject: [PATCH] x86, pat: add large-PAT check to split_large_page()

Impact: future-proof the split_large_page() function

Linus noticed that split_large_page() is not safe wrt. the
PAT bit: it is bit 12 on the 1GB and 2MB page table level
(_PAGE_BIT_PAT_LARGE), and it is bit 7 on the 4K page
table level (_PAGE_BIT_PAT).

Currently it is not a problem because we never set
_PAGE_BIT_PAT_LARGE on any of the large-page mappings - but
should this happen in the future the split_large_page() would
silently lift bit 12 into the lowlevel 4K pte and would start
corrupting the physical page frame offset. Not fun.

So add a debug warning, to make sure if something ever sets
the PAT bit then this function gets updated too.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/pageattr.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 7be47d1..8253bc9 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -482,6 +482,13 @@ static int split_large_page(pte_t *kpte, unsigned long address)
 	pbase = (pte_t *)page_address(base);
 	paravirt_alloc_pte(&init_mm, page_to_pfn(base));
 	ref_prot = pte_pgprot(pte_clrhuge(*kpte));
+	/*
+	 * If we ever want to utilize the PAT bit, we need to
+	 * update this function to make sure it's converted from
+	 * bit 12 to bit 7 when we cross from the 2MB level to
+	 * the 4K level:
+	 */
+	WARN_ON_ONCE(pgprot_val(ref_prot) & _PAGE_PAT_LARGE);
 
 #ifdef CONFIG_X86_64
 	if (level == PG_LEVEL_1G) {
