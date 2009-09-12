Return-Path: <linux-kernel-owner+w=401wt.eu-S1754316AbZILHOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316AbZILHOl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 03:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750824AbZILHOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 03:14:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41980 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754AbZILHOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 03:14:39 -0400
Date: Sat, 12 Sep 2009 09:14:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [GIT PULL] x86/xen for v2.6.32
Message-ID: <20090912071428.GC12702@elte.hu>
References: <20090911200135.GA1426@elte.hu> <alpine.LNX.2.00.0909120000010.31018@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.0909120000010.31018@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jesper Juhl <jj@chaosbits.net> wrote:

> On Fri, 11 Sep 2009, Ingo Molnar wrote:
> 
> [...]
> > +static __init void xen_load_gdt_boot(const struct desc_ptr *dtr)
> > +{
> > +	unsigned long va = dtr->address;
> > +	unsigned int size = dtr->size + 1;
> > +	unsigned pages = (size + PAGE_SIZE - 1) / PAGE_SIZE;
> > +	unsigned long frames[pages];
> > +	int f;
> > +
> > +	/*
> > +	 * A GDT can be up to 64k in size, which corresponds to 8192
> > +	 * 8-byte entries, or 16 4k pages..
> > +	 */
> > +
> > +	BUG_ON(size > 65536);
> > +	BUG_ON(va & ~PAGE_MASK);
> > +
> > +	for (f = 0; va < dtr->address + size; va += PAGE_SIZE, f++) {
> > +		pte_t pte;
> > +		unsigned long pfn, mfn;
> > +
> > +		pfn = virt_to_pfn(va);
> > +		mfn = pfn_to_mfn(pfn);
> > +
> > +		pte = pfn_pte(pfn, PAGE_KERNEL_RO);
> > +
> > +		if (HYPERVISOR_update_va_mapping((unsigned long)va, pte, 0))
> > +			BUG();
> [...]
> 
> Why is this cast of 'va' needed?  As far as I can see, 'va' already has 
> the correct type of "unsigned long".
> Pointless casts do more harm than good, let's remove this one :-)
> 
> Sorry that all I could comment on was this trivial thing, but I thought it 
> better to comment than keep silent now that I had read the patch and 
> spotted it...

Yes, that cast could be removed.

Btw., i'd suggest that if you have trivial review feedback please 
comment on the originating patches, in the original, finegrained 
context, not the summary pull request. (Incidentally i did that too 
there and the above patches did result in a few cleanups when they 
were submitted.)

The reason is that the originating threads all have full changelogs 
and have all the right people Cc:-ed in general - and by reviewing 
them you will also influence the patches before they are sent to 
Linus. The pull requests have Linus and the affected maintainers 
Cc:-ed mainly. So for example you did not Cc: Jeremy to the x86/fpu 
pull request comments you did so he had no chance to comment on them 
unless he happened to run across your comments on lkml.

Bug/crash reports and serious gotcha feedback can go to the pull 
requests too just fine - but even then, if you know what the 
originating commit is, try to include the people who originated the 
commit. (And feel free to Cc: Linus to that trivial feedback if you 
think it's important enough.)

Thanks,

	Ingo
