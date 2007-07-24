Return-Path: <linux-kernel-owner+w=401wt.eu-S1758211AbXGXV35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758211AbXGXV35 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 17:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbXGXV3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 17:29:49 -0400
Received: from gate.crashing.org ([63.228.1.57]:51515 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881AbXGXV3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 17:29:48 -0400
Subject: Re: [patch] mm: reduce pagetable-freeing latencies
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>
In-Reply-To: <p73abtmt2y7.fsf@bingen.suse.de>
References: <20070724083855.GA858@elte.hu>
	 <20070724015441.8604d85d.akpm@linux-foundation.org>
	 <1185270045.5439.249.camel@localhost.localdomain>
	 <p73abtmt2y7.fsf@bingen.suse.de>
Content-Type: text/plain
Date: Wed, 25 Jul 2007 07:29:18 +1000
Message-Id: <1185312559.5439.276.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-24 at 14:13 +0200, Andi Kleen wrote:
> Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:
> 
> > > What a truly putrid patch.  I am suspecting that this was a quick
> > > get-you-out-of-trouble thing, which then got forgotten about.
> > > 
> > > We have two months to do the "right fix".  Please?
> > 
> > Working on it... 
> 
> Ideally the patch would DTRT even on non preemptible kernels,
> aka do cond_resched()s when needed.

First is to rework the batch structure to make it more manageable. That
is, patch #1 will keep the page list in per-cpu (and thus non-preempt),
but the batch "head" will be on the stack.

Now, there are two approaches regarding getting rid of the
get_cpu/put_cpu:

 - One is to have a small number of entries for the page list in the
batch structure on the stack, and attempt to gfp' a page for more. If
that fails, we can still free, though with less batching, using only the
few entries in the batch struct itself. That's Hugh initial appraoch
iirc.

 - Another is to hook up with those folks who've been asking for a
notifier that we are being preempted/scheduled out. In this case, I can
happily access the per-cpu list, and just trigger a batch flush if we
happen to be scheduled out.

I tend to prefer the former solution though, gfp should be fast, and
there is no need to force a flush if we get scheduled out. It would be
rare to hit the worst case scenario of falling back to the few page
heads in the batch itself. On the other hand, that solution has the
problem of bloating the stack a bit (with the few page pointers) even in
the case where I plan to use the extended batch outside of zap_*, such
as fork, mprotect, ....

So I'll first do patch #1, which will not fix the problem, but will make
the fix easier to fit in, in the meantime, please provide feedback of
your preferred solution for avoiding the get/put_cpu of the 2 above,
unless you find a good 3rd one.

Cheers,
Ben.

