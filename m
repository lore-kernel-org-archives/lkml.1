Return-Path: <linux-kernel-owner+w=401wt.eu-S1758780AbYBGKRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780AbYBGKRS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 05:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754525AbYBGKRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 05:17:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49768 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754230AbYBGKRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 05:17:08 -0500
Date: Thu, 7 Feb 2008 11:16:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Balaji Rao <balajirrao@gmail.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, jesse.barnes@intel.com,
       ak@suse.de, Harvey Harrison <harvey.harrison@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH][Regression] x86, 32-bit: trim memory not covered by wb
	mtrrs - FIX
Message-ID: <20080207101642.GC7716@elte.hu>
References: <200802071257.51893.balajirrao@gmail.com> <20080207080245.GA28631@elte.hu> <200802071351.02763.balajirrao@gmail.com> <86802c440802070050t2566a261t50cccd649912a4a9@mail.gmail.com> <20080207090452.GB12884@elte.hu> <86802c440802070111o5a4bc700g75a0693f8307d766@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440802070111o5a4bc700g75a0693f8307d766@mail.gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> On Feb 7, 2008 1:04 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> >
> > > minor difference
> > > +               trim_start = highest_pfn << PAGE_SHIFT;
> > > +               trim_size = end_pfn << PAGE_SHIFT;
> > >
> > > could cause some problem with 32 bit kernel when mem > 4g. becase
> > > highest_pfn and end_pfn is unsigned long aka 32 bit ...could overflow.
> > >
> > > so need to assign thtem to tr, 32-bitim_start/trim_end at first
> > > or
> > > +               trim_start = (u64)highest_pfn << PAGE_SHIFT;
> > > +               trim_size = (u64)end_pfn << PAGE_SHIFT;
> >
> > indeed ...
> >
> > i think the 64-bit behavior of gcc is inherently dangerous, we had
> > numerous subtle bugs in that area.
> >
> > i think perhaps Sparse should be extended to warn about this. I think
> > any case where on _32-bit_ we have an 'unsigned long' that is shifted to
> > the left by any significant amount is clearly in danger of overflowing.
> > _Especially_ when the lvalue is 64-bit!
> >
> > or in other words, on any such construct:
> >
> >    64-bit lvalue = ... 32-bit value
> >
> > we should enforce _explicit_ (u64) conversions.
> 
> so you mean gcc will do some optimization to make
> 
> +               trim_start = highest_pfn;
> +               trim_start <<= PAGE_SHIFT;
> 
> to be
> 
> +               trim_start = highest_pfn << PAGE_SHIFT;
> 
> looks scary...

no, that would not be valid.

I mean the simple example you offered:

  +               trim_start = highest_pfn << PAGE_SHIFT;

it _looks_ good but is inherently unsafe if 'highest_pfn' is 32-bit and 
PAGE_SHIFT is 32-bit (which they are).

Or another, user-space example, on a 32-bit box:

 int main (void)
 {
         unsigned long long a;
         unsigned long b = 0x80000000, c = 2;

         a = b << c;

         printf("%Ld\n", a);

         return 0;
 }

gcc will print "0" and emits no warning - so we silently lost 
information and truncated bits. I'm sure this is somewhere specified in 
some language standard, but it's causing bugs left and right when we use 
u64.

So if there's no helpful gcc warning that already exists, i think we 
should extend the Sparse static checker to flag all such instances of:

    u64 = u32 << u32;

arithmetics, because in 100% of the cases i've seen so far they cause 
nasty bugs. We've had such bugs in the scheduler, and we've had them in 
arch/x86 as well. It's a royal PITA.

	Ingo
