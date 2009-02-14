Return-Path: <linux-kernel-owner+w=401wt.eu-S1751904AbZBNJrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904AbZBNJrT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 04:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750898AbZBNJrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 04:47:03 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57104 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbZBNJrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 04:47:01 -0500
Subject: Re: [PATCH] mm: disable preemption in apply_to_pte_range
From: Peter Zijlstra <peterz@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4995B0E3.3050201@goop.org>
References: <4994BCF0.30005@goop.org>
	 <200902140030.59027.nickpiggin@yahoo.com.au>
	 <1234534611.6519.109.camel@twins>
	 <200902140130.31985.nickpiggin@yahoo.com.au>
	 <1234535938.6519.118.camel@twins>  <4995B0E3.3050201@goop.org>
Content-Type: text/plain
Date: Sat, 14 Feb 2009 10:46:16 +0100
Message-Id: <1234604776.4698.18.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-13 at 09:41 -0800, Jeremy Fitzhardinge wrote:
> Peter Zijlstra wrote:
> > If the lazy mmu code relies on per-cpu data, then it should be the lazy
> > mmu's responsibility to ensure stuff is properly serialized. Eg. it
> > should do get_cpu_var() and put_cpu_var().
> >
> > Those constructs can usually be converted to preemptable variants quite
> > easily, as it clearly shows what data needs to be protected.
> >   
> 
> At the moment the lazy update stuff is inherently cpu-affine.  The basic 
> model is that you can amortize the cost of individual update operations 
> (via hypercall, for example) by batching them up.  That batch is almost 
> certainly a piece of percpu state (in Xen's case its maintained on the 
> kernel side as per-cpu data,

What we often do for -rt is put a lock in such per-cpu data, and take
the data that is cpu-local when we start and aquire the lock, thereafter
we keep operating on that data no matter where we get migrated to.

That way you're optimistically per-cpu but still freely schedulable.

>  but in VMI it happens somewhere under their 
> ABI), and so we can't allow switching to another cpu while lazy update 
> mode is active.

Sounds like VMI is a bit of a problem there, luckily no sane person uses
that since its all closed source cruft ;-)

It might just end up meaning you cannot run a RT kernel on a VMI host --
something that's daft anyway.

> Preemption is also problematic because if we're doing lazy updates and 
> we switch to another task, it will likely get very confused if its 
> pagetable updates get deferred until some arbitrary point in the future...

Who will get confused? The preempted task doesn't care, as its not
running, and once it gets back to running we'll happily continue poking
at the page-tables and complete the operation like normal.

> So at the moment, we just disable preemption, and take advantage of the 
> existing work to make sure pagetable updates are not non-preemptible for 
> too long.  This has been fine so far, because almost all the work on 
> using lazy mmu updates has focused on usermode mappings.
> 
> But I can see how this is problematic from your perspective.  One thing 
> we could consider is making the lazy mmu mode a per-task property, so if 
> we get preempted we can flush any pending changes and safely switch to 
> another task, and then reenable it when we get scheduled in again.  
> (This may be already possible with the existing paravirt-ops hooks in 
> switch_to.)

That sounds like a fine option, we have these preempt notifiers for
exactly such cases I think.

> In this specific case, if the lazy mmu updates / non-preemptable section 
> is really causing heartburn, we can just back it out for now.

I'm not sure, I haven't ran an -rt kernel with your patch applied, so
I'm not sure it will explode. However I do dislike simply requiring
preemption disabled there, when its clearly something that's specific to
the lazy mmu stuff.

So I think that no matter how we're going to do it, it should be done in
the lazy mmu hooks. If that requires changing the
arch_{enter_,leave}lazy_mmu_mode() calls to change signature to take a
mm_struct pointer, then so be it.

