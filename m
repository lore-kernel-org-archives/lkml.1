Return-Path: <linux-kernel-owner+w=401wt.eu-S1754881AbZBTN5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbZBTN5f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 08:57:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbZBTN50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 08:57:26 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60567 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbZBTN5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 08:57:25 -0500
Date: Fri, 20 Feb 2009 08:57:22 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Huang Ying <ying.huang@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: use the right protections for split-up pagetables
In-Reply-To: <20090220072915.GB28085@elte.hu>
Message-ID: <alpine.DEB.2.00.0902200856330.29217@gandalf.stny.rr.com>
References: <20090220011316.379904625@goodmis.org> <alpine.LFD.2.00.0902191753240.21686@localhost.localdomain> <alpine.DEB.1.10.0902192107230.31658@gandalf.stny.rr.com> <alpine.LFD.2.00.0902191923300.21686@localhost.localdomain>
 <20090220072915.GB28085@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 20 Feb 2009, Ingo Molnar wrote:

> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > So the whole
> > 
> >         ref_prot = pte_pgprot(pte_mkexec(pte_clrhuge(*kpte)));
> >         pgprot_val(ref_prot) |= _PAGE_PRESENT;
> >         __set_pmd_pte(kpte, address, mk_pte(base, ref_prot));
> > 
> > sequence is utter crap, I think. The whole "ref_prot" there 
> > should be just _pgprot(_KERNPG_TABLE), I think. I don't think 
> > there is any other valid value.
> 
> Agreed, split_large_page() was just plain confused here - there 
> was no hidden reason for this logic. It makes no sense to bring 
> any pte level protection information to the PMD level because a 
> pmd entry covers a set of 512 ptes so there's no singular 
> protection attribute that can be carried to it.
> 
> The right solution is what you suggested: to use the most 
> permissive protection bits for the pmd, i.e. _KERNPG_TABLE. 
> Since the protection bits get combined, this makes the pte 
> protections control the final behavior of the mapping - so 
> subsequent code patching and similar activities will work fine.
> 
> The bug was mostly harmless until Steve hacked his kernel to 
> have the right (large) size of readonly, text and data areas. I 
> never hit such an ftrace hang even with allyesconfig bzImage 
> bootups [which has obscenely large text and data sections], so i 
> think something in Steve's tree was also needed to trigger it: 
> an unusually large readonly data section.
> 
> I've queued up the fix below in tip:x86/urgent and will send a 
> pull request later today if it passes testing. Steve, does this 
> solve the bug you've hit?

Yep, I've already tried this fix. It works fine.

-- Steve

> 
> With this fix i dont think the other bits from Steve's series 
> (patch 1-4) are needed at all - those patches expose PMD details 
> in various places that iterate over ptes - that's ugly and 
> unnecessary as well if the PMD's protection is permissive.
> 
> [ Also, since you suggested the fix i've added your Acked-by, 
>   let me know if you dont agree with any aspect of the fix. ]
> 
> 	Ingo
> 
> ---------------->
> >From f07eb4c47d5d4a70dc8eb8e2c158741cd6c69948 Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Fri, 20 Feb 2009 08:04:13 +0100
> Subject: [PATCH] x86: use the right protections for split-up pagetables
> 
> Steven Rostedt found a bug in where in his modified kernel
> ftrace was unable to modify the kernel text, due to the PMD
> itself having been marked read-only as well in
> split_large_page().
> 
> The fix, suggested by Linus, is to not try to 'clone' the
> reference protection of a huge-page, but to use the standard
> (and permissive) page protection bits of KERNPG_TABLE.
> 
> The 'cloning' makes sense for the ptes but it's a confused and
> incorrect concept at the page table level - because the
> pagetable entry is a set of all ptes and hence cannot
> 'clone' any single protection attribute - the ptes can be any
> mixture of protections.
> 
> With the permissive KERNPG_TABLE, even if the pte protections
> get changed after this point (due to ftrace doing code-patching
> or other similar activities like kprobes), the resulting combined
> protections will still be correct and the pte's restrictive
> (or permissive) protections will control it.
> 
> Also update the comment.
> 
> This bug was there for a long time but has not caused visible
> problems before as it needs a rather large read-only area to
> trigger. Steve possibly hacked his kernel with some really
> large arrays or so. Anyway, the bug is definitely worth fixing.
> 
> [ Huang Ying also experienced problems in this area when writing
>   the EFI code, but the real bug in split_large_page() was not
>   realized back then. ]
> 
> Reported-by: Steven Rostedt <rostedt@goodmis.org>
> Reported-by: Huang Ying <ying.huang@intel.com>
> Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/mm/pageattr.c |   15 +++++----------
>  1 files changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
> index 8ca0d85..17d5d1a 100644
> --- a/arch/x86/mm/pageattr.c
> +++ b/arch/x86/mm/pageattr.c
> @@ -508,18 +508,13 @@ static int split_large_page(pte_t *kpte, unsigned long address)
>  #endif
>  
>  	/*
> -	 * Install the new, split up pagetable. Important details here:
> +	 * Install the new, split up pagetable.
>  	 *
> -	 * On Intel the NX bit of all levels must be cleared to make a
> -	 * page executable. See section 4.13.2 of Intel 64 and IA-32
> -	 * Architectures Software Developer's Manual).
> -	 *
> -	 * Mark the entry present. The current mapping might be
> -	 * set to not present, which we preserved above.
> +	 * We use the standard kernel pagetable protections for the new
> +	 * pagetable protections, the actual ptes set above control the
> +	 * primary protection behavior:
>  	 */
> -	ref_prot = pte_pgprot(pte_mkexec(pte_clrhuge(*kpte)));
> -	pgprot_val(ref_prot) |= _PAGE_PRESENT;
> -	__set_pmd_pte(kpte, address, mk_pte(base, ref_prot));
> +	__set_pmd_pte(kpte, address, mk_pte(base, _pgprot(_KERNPG_TABLE)));
>  	base = NULL;
>  
>  out_unlock:
> 
> 
