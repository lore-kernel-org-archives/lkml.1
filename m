Return-Path: <linux-kernel-owner+w=401wt.eu-S1752394AbZL3QDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394AbZL3QDo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 11:03:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbZL3QDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 11:03:43 -0500
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:39607 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752001AbZL3QDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 11:03:43 -0500
X-Trace: 314517026/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.28.176/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.28.176
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-Originating-Country: GB/UNITED KINGDOM
X-MUA: Alpine 2.00 (LSU 1167 2008-08-23)
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnQBAL4IO0tPRRyw/2dsb2JhbAAI1yKEMQQ
X-IronPort-AV: E=Sophos;i="4.47,476,1257120000"; 
   d="scan'208";a="314517026"
Date: Wed, 30 Dec 2009 16:03:37 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Peter Zijlstra <peterz@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Darren Hart <dvhltc@us.ibm.com>,
       Ulrich Drepper <drepper@gmail.com>
Subject: Re: [PATCH] futex: Fix ZERO_PAGE cause infinite loop
In-Reply-To: <20091225083305.AA78.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.LSU.2.00.0912301437420.3369@sister.anvils>
References: <20091224182630.3DCB.A69D9226@jp.fujitsu.com> <1261647565.4937.177.camel@laptop> <20091225083305.AA78.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was a good find, thanks a lot for discovering it.

I'm afraid I'd quite forgotten all the mm-implementation-dependence
that has accumulated (for good performance reasons) in kernel/futex.c.

(Luckily, given that KSM pages are also PageAnon, it will happen to
be working correctly on them: that's not your concern, but something
your report has reminded me to consider.)

On Fri, 25 Dec 2009, KOSAKI Motohiro wrote:
> > > diff --git a/kernel/futex.c b/kernel/futex.c
> > > index 8e3c3ff..79b89cc 100644
> > > --- a/kernel/futex.c
> > > +++ b/kernel/futex.c
> > > @@ -254,6 +254,8 @@ again:
> > >  
> > >  	page = compound_head(page);
> > >  	lock_page(page);
> > > +	if (is_zero_pfn(page_to_pfn(page)))
> > > +		goto anon_key;

If something like this or your replacment does go forward,
then I think that test is better inside the "if (!page->mapping)"
below.  Admittedly that adds even more mm-dependence here (relying
on a zero page to have NULL page->mapping); but isn't page_to_pfn()
one of those functions which is trivial on many configs but expensive
on some?  Better call it only in the rare case that it's needed.

Though wouldn't it be even better not to use is_zero_pfn() at all?
That was convenient in mm/memory.c because it had the pfn or pte right
at hand, but here a traditional (page == ZERO_PAGE(address)) would be
more efficient.

Which would save having to move is_zero_pfn() from mm/memory.c
to include/linux/mm.h - I'd prefer to keep it private if we can.
But for completeness, this would involve resurrecting the 2.6.19
MIPS move_pte(), which makes sure mremap() move doesn't interfere
with our assumptions.  Something like

#define __HAVE_ARCH_MOVE_PTE
pte_t move_pte(pte_t pte, pgprot_t prot, unsigned long old_addr,
                                         unsigned long new_addr)
{
	if (pte_present(pte) && is_zero_pfn(pte_pfn(pte)))
		pte = mk_pte(ZERO_PAGE(new_addr), prot);
	return pte;
}

in arch/mips/include/asm/pgtable.h.

> > >  	if (!page->mapping) {
> > >  		unlock_page(page);
> > >  		put_page(page);
> > > @@ -268,6 +270,7 @@ again:
> > >  	 * the object not the particular process.
> > >  	 */
> > >  	if (PageAnon(page)) {
> > > + anon_key:
> > >  		key->both.offset |= FUT_OFF_MMSHARED; /* ref taken on mm */
> > >  		key->private.mm = mm;
> > >  		key->private.address = address;
> > 
> > Doesn't it make more sense to simply fail the futex op?

If we were to decide to fail the futex op on an unmodified ZERO_PAGE,
couldn't we simply delete the "again" label and just say

	if (!page->mapping) {
		/* Truncated file page, or a ZERO_PAGE */
		unlock_page(page);
		put_page(page);
		return -EFAULT;
	}

I don't know what the retry on that case was expected to achieve.

> > 
> > What I mean is, all (?) futex ops assume userspace actually wrote
> > something to the address in question to begin with, therefore it can
> > never be the zero page.
> > 
> > So it being the zero page means someone goofed up, and we should bail,
> > no?

I share Peter's wish to avoid cluttering this up with more special
case testing, but also your and Ulrich's wish to keep generality.

> 
> Hm. probably we need to discuss more.
> 
> Firstly, if we assume current glibc implimentation, you are right,
> we can assume userland always initialize the page explicitly before using
> futex. then we never seen zero page in futex.
> 
> but, I don't think futex itself assume it now. at least man page
> doesn't describe such limilation. so, if you prefer bail and man fix,
> I'm acceptable maybe.

Here's another worry with the current futex implementation,
which might help me to decide which way to jump on the ZERO_PAGE.

Originally, a futex on a MAP_PRIVATE (!VM_MAYSHARE) area was necessarily
FUT_OFF_MMSHARED.  Nowadays, with the get_user_pages_fast implementation,
we have no idea whether the vma is VM_MAYSHARE or not.  So if a futex is
placed in a private area backed by a file, then it could be regarded as
FUT_OFF_INODE at futex_wait() time, but FUT_OFF_MMSHARED at futex_wake()
time.

Perhaps that's no problem at all, it's a long time since I was involved
with futexes, I think you and Peter will grasp the consequences quicker
than I shall.

But it seems no more improbable than the ZERO_PAGE case: some app
might place its futexes in the .data section of the executable,
which is a private mapping of the executable file.

If this case is also an issue, then perhaps we just need to update
the man page to say that whatever is responsible for initializing a
futex does need to write to it (or the page it's in) before it's used,
otherwise behaviour is undefined.  (But we should then use the -EFAULT
patch above, we'd all prefer an error to busylooping.)

> 
> I don't know any library except glibc use futex directly, or not. 
> but we don't have any reason to assume futex is used only glibc.
> (plus, glibc might change its implementation in future release, perhaps)

I expect there are other implementations; but apparently none
that have yet reported this ZERO_PAGE behaviour as a problem.

...
> 
> man page fix has another difficulty. in past days, zero pages was perfectly
> transparent from userland. then any man page don't describe "what's zero page".
> then some administrator don't know about zero page at all.
> 
> So, if your main disliked point is goto statement, following patch is ok
> to me.

Although I'm as indecisive as Hamlet,
"goto or no goto, that is NOT the question":
I don't care, I think the goto in your original was fine.

> 
> Finally, I agree this is really corner case issue. I can agree man page fix
> too. but I hope to know which point you dislike in my patch.

I just prefer not to have to add extra tests for the ZERO_PAGE
if we can get away without them.

Hugh
