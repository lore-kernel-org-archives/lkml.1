Return-Path: <linux-kernel-owner+w=401wt.eu-S1755199AbZCDQtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199AbZCDQtn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 11:49:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbZCDQtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 11:49:35 -0500
Received: from casper.infradead.org ([85.118.1.10]:51688 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882AbZCDQte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 11:49:34 -0500
Subject: Re: percpu allocator vs reclaim
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <49AEAEF2.7040908@kernel.org>
References: <1236184563.5330.8074.camel@laptop>
	 <49AEAEF2.7040908@kernel.org>
Content-Type: text/plain
Date: Wed, 04 Mar 2009 17:49:23 +0100
Message-Id: <1236185363.5330.8121.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-05 at 01:40 +0900, Tejun Heo wrote:
> Peter Zijlstra wrote:
> > Hi Tejun,
> > 
> > Thomas hit the below on recent -tip kernels.
> > 
> > Which basically states that we could deadlock due to reclaim lock
> > recursion.
> > 
> > Looking at the code I don't see a quick solution, other than using
> > GFP_NOFS, which is a bit of a bother (as I suspect it might easily grow
> > __GFP_IO inversion too, if it doesn't already have it).
> 
> Ah... maybe percpu allocator should just swallow @gfp.  Any better
> ideas? :-(

Could you somehow break that lock so that you get something like:

  alloc_lock
    kmalloc(GFP_KERNEL)
    free_lock

Where

 percpu_free()
   lock(free_lock)
     put area on free list

 percpu_alloc()
   lock(free_list)
     collect free list
   kmalloc()

Then the free code can be used from reclaim, because there's never an
allocation done while holding it, and the alloc path can first
check/cleanup whatever mess the last free left behind before trying an
allocation.



