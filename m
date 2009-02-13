Return-Path: <linux-kernel-owner+w=401wt.eu-S1758596AbZBMLqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758596AbZBMLqu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 06:46:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbZBMLql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 06:46:41 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41605 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbZBMLqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 06:46:40 -0500
Subject: Re: [PATCH] mm: disable preemption in apply_to_pte_range
From: Peter Zijlstra <peterz@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-mm@kvack.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4994CF35.60507@goop.org>
References: <4994BCF0.30005@goop.org>	<4994C052.9060907@goop.org>
	 <20090212165539.5ce51468.akpm@linux-foundation.org>
	 <4994CF35.60507@goop.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 13 Feb 2009 12:48:30 +0100
Message-Id: <1234525710.6519.17.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-12 at 17:39 -0800, Jeremy Fitzhardinge wrote:

> In general the model for lazy updates is that you're batching the 
> updates in some queue somewhere, which is almost certainly a piece of 
> percpu state being maintained by someone.  Its therefore broken and/or 
> meaningless to have the code making the updates wandering between cpus 
> for the duration of the lazy updates.
> 
> > If so, should we do the preempt_disable/enable within those functions? 
> > Probably not worth the cost, I guess.
> 
> The specific rules are that 
> arch_enter_lazy_mmu_mode()/arch_leave_lazy_mmu_mode() require you to be 
> holding the appropriate pte locks for the ptes you're updating, so 
> preemption is naturally disabled in that case.

Right, except on -rt where the pte lock is a mutex.

> This all goes a bit strange with init_mm's non-requirement for taking 
> pte locks.  The caller has to arrange for some kind of serialization on 
> updating the range in question, and that could be a mutex.  Explicitly 
> disabling preemption in enter_lazy_mmu_mode would make sense for this 
> case, but it would be redundant for the common case of batched updates 
> to usermode ptes.

I really utterly hate how you just plonk preempt_disable() in there
unconditionally and without very clear comments on how and why.

I'd rather we'd fix up the init_mm to also have a pte lock.
