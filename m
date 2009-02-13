Return-Path: <linux-kernel-owner+w=401wt.eu-S1759758AbZBMObQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759758AbZBMObQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 09:31:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751546AbZBMObG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 09:31:06 -0500
Received: from smtp111.mail.mud.yahoo.com ([209.191.84.64]:46950 "HELO
	smtp111.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751509AbZBMObF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 09:31:05 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=4Gr7mPA3oFj2feLHLVe16LLtw5MDCbvkIqstwp+V67XU1J7l/iNixNXfNft3Y9TzUELrd8e1CL9q1CWgBfWDgag9Qc0Uvm4ZCKod4AdViy+BtRCvjjkAhyOzcDdercgTmcghsElvrn7mVVseOkKAoe4uMnpi0nn0eFvCsv82Tqs=  ;
X-YMail-OSG: Pb_SmtMVM1kIhfElM6wCZ6cZA4T3I1VHwcb.383xFGCxq6JUuMfZ6c_71PXorOwZ04iB26hS_l0UkjAA6jskuVOxMZ3v.ytpBIs09MbN_xEqTJx3z0tZW29RQyiE0lhRWe6fVmeJvWsLeKhAscyBy_LL1xIFP5xJ35b2mX2KB.oZg4V6RohFi3p5ePFcjA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] mm: disable preemption in apply_to_pte_range
Date: Sat, 14 Feb 2009 01:30:31 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Ingo Molnar <mingo@elte.hu>
References: <4994BCF0.30005@goop.org> <200902140030.59027.nickpiggin@yahoo.com.au> <1234534611.6519.109.camel@twins>
In-Reply-To: <1234534611.6519.109.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902140130.31985.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 February 2009 01:16:51 Peter Zijlstra wrote:
> On Sat, 2009-02-14 at 00:30 +1100, Nick Piggin wrote:
> > On Friday 13 February 2009 22:48:30 Peter Zijlstra wrote:
> > > On Thu, 2009-02-12 at 17:39 -0800, Jeremy Fitzhardinge wrote:
> > > > In general the model for lazy updates is that you're batching the
> > > > updates in some queue somewhere, which is almost certainly a piece of
> > > > percpu state being maintained by someone.  Its therefore broken
> > > > and/or meaningless to have the code making the updates wandering
> > > > between cpus for the duration of the lazy updates.
> > > >
> > > > > If so, should we do the preempt_disable/enable within those
> > > > > functions? Probably not worth the cost, I guess.
> > > >
> > > > The specific rules are that
> > > > arch_enter_lazy_mmu_mode()/arch_leave_lazy_mmu_mode() require you to
> > > > be holding the appropriate pte locks for the ptes you're updating, so
> > > > preemption is naturally disabled in that case.
> > >
> > > Right, except on -rt where the pte lock is a mutex.
> > >
> > > > This all goes a bit strange with init_mm's non-requirement for taking
> > > > pte locks.  The caller has to arrange for some kind of serialization
> > > > on updating the range in question, and that could be a mutex. 
> > > > Explicitly disabling preemption in enter_lazy_mmu_mode would make
> > > > sense for this case, but it would be redundant for the common case of
> > > > batched updates to usermode ptes.
> > >
> > > I really utterly hate how you just plonk preempt_disable() in there
> > > unconditionally and without very clear comments on how and why.
> >
> > And even on mainline kernels, builds without the lazy mmu mode stuff
> > don't need preemption disabled here either, so it is technically a
> > regression in those cases too.
>
> Well, normally we'd be holding the pte lock, which on regular kernels
> already disable preemption, as Jeremy noted. So in that respect it
> doesn't change things too much.

But not (necessarily) in the init_mm case.


> Its just that slapping preempt_disable()s around like there's not
> tomorrow is horridly annoying, its like using the BKL -- there's no data
> affinity what so ever, so trying to unravel the dependencies a year
> later when you notice its a latency concern is a massive pain in the
> backside.

Or like using memory barriers. Any of them are OK if they're properly
commented though, I guess.


> > > I'd rather we'd fix up the init_mm to also have a pte lock.
> >
> > Well that wouldn't fix -rt; there would need to be a preempt_disable
> > within arch_enter_lazy_mmu_mode(), which I think is the cleanest
> > solution.
>
> Hmm, so you're saying we need to be cpu-affine for the lazy mmu stuff?
> Otherwise a -rt would just convert the init_mm pte lock to a mutex along
> with all other pte locks and there'd be no issue.

Well I don't see any other reason why it should have to use preempt_disable.
Not necessarily just cpu-affine, but perhaps it is using per-cpu data in
non-trivial way so cannot get switched out either.

