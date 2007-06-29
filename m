Return-Path: <linux-kernel-owner+w=401wt.eu-S1756927AbXF2VRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927AbXF2VRu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 17:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755457AbXF2VRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 17:17:43 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:43200 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755405AbXF2VRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 17:17:43 -0400
Subject: Re: [patch 1/5] avoid tlb gather restarts.
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Hugh Dickins <hugh@veritas.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <Pine.LNX.4.64.0706291927260.1509@blonde.wat.veritas.com>
References: <20070629135530.912094590@de.ibm.com>
	 <20070629141527.557443600@de.ibm.com>
	 <Pine.LNX.4.64.0706291927260.1509@blonde.wat.veritas.com>
Content-Type: text/plain
Organization: IBM Corporation
Date: Fri, 29 Jun 2007 23:19:44 +0200
Message-Id: <1183151984.13635.16.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-29 at 19:56 +0100, Hugh Dickins wrote:
> I don't dare comment on your page_mkclean_one patch (5/5),
> that dirty page business has grown too subtle for me.

Oh yes, the dirty handling is tricky. I had to fix a really nasty bug
with it lately. As for page_mkclean_one the difference is that it
doesn't claim a page is dirty if only the write protect bit has not been
set. If we manage to lose dirty bits from ptes and have to rely on the
write protect bit to take over the job, then we have a different problem
altogether, no ?

> Your cleanups 2-4 look good, especially the mm_types.h one (how
> confident are you that everything builds?), and I'm glad we can
> now lay ptep_establish to rest.  Though I think you may have 
> missed removing a __HAVE_ARCH_PTEP... from frv at least?

Ok, thanks for the review. I take a look at frv to see if I missed
something.

> But this one...
> 
> On Fri, 29 Jun 2007, Martin Schwidefsky wrote:
> 
> > If need_resched() is false it is unnecessary to call tlb_finish_mmu()
> > and tlb_gather_mmu() for each vma in unmap_vmas(). Moving the tlb gather
> > restart under the if that contains the cond_resched() will avoid
> > unnecessary tlb flush operations that are triggered by tlb_finish_mmu() 
> > and tlb_gather_mmu().
> > 
> > Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> Sorry, no.  It looks reasonable, but unmap_vmas is treading a delicate
> and uncomfortable line between hi-performance and lo-latency: you've
> chosen to improve performance at the expense of latency.

That it true, my only concern had been performance. You likely have a
point here.

> You think you're just moving the finish/gather to where they're
> actually necessary; but the thing is, that per-cpu struct mmu_gather
> is liable to accumulate a lot of unpreemptible work for the future
> tlb_finish_mmu, particularly when anon pages are associated with swap.

Hmm, ok, so you are saying that we should do a flush at the end of each
vma.

> So although there may be no need to resched right now, if we keep on
> gathering more and more without flushing, we'll be very unresponsive
> when a resched is needed later on.  Hence Ingo's ZAP_BLOCK_SIZE to
> split it up, small when CONFIG_PREEMPT, more reasonable but still
> limited when not.

Would it be acceptable to call tlb_flush_mmu instead of the
tlb_finish_mmu / tlb_gather_mmu pair if the condition around
cond_resched evaluates to false?
The background for this change is that I'm working on another patch that
will change the tlb flushing for s390 quite a bit. We won't have
anything to flush with tlb_finish_mmu because we will either flush all
tlbs with tlb_gather_mmu or each pte seperatly. The pages will always be
freed immediatly. If we are forced to restart the tlb gather then we'll
do multiple flush_tlb_mm because the information that we already flushed
everything is lost with tlb_finish_mmu.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


