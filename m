Return-Path: <linux-kernel-owner+w=401wt.eu-S1762312AbXFTJ2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762312AbXFTJ2a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 05:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752506AbXFTJ2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 05:28:22 -0400
Received: from mx10.go2.pl ([193.17.41.74]:54456 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751493AbXFTJ2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 05:28:21 -0400
Date: Wed, 20 Jun 2007 11:36:12 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Miklos Szeredi <miklos@szeredi.hu>,
       cebbert@redhat.com, chris@atlee.ca, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, akpm@linux-foundation.org
Subject: Re: [BUG] long freezes on thinkpad t60
Message-ID: <20070620093612.GA1626@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706180857120.14121@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 18-06-2007 18:34, Linus Torvalds wrote:
> 
> On Mon, 18 Jun 2007, Ingo Molnar wrote:
>> To test this theory, could you try the patch below, does this fix your 
>> hangs too?
> 
> I really think this the the wrong approach, although *testing* it makes 
> sense.
> 
> I think we need to handle loops that take, release, and then immediately 
> re-take differently.
> 
> Such loops are _usually_ of the form where they really just release the 
> lock for some latency reason, but in this case I think it's actually just 
> a bug.
> 
> That code does:
> 
> 	if (unlikely(p->array || task_running(rq, p))) {
> 
> to decide if it needs to just unlock and repeat, but then to decide if it 
> need to *yield* it only uses *one* of those tests (namely 
> 
> 	preempted = !task_running(rq, p);
> 	..
> 	if (preempted)
> 		yield();
> 
> and I think that's just broken. It basically says:
> 
>  - if the task is running, I will busy-loop on getting/releasing the 
>    task_rq_lock
> 
> and that is the _real_ bug here.

I don't agree with this (+ I know it doesn't matter).

The real bug is what Chuck Ebbert wrote: "Spinlocks aren't fair".
And here they are simply lawlessly not fair.

I cannot see any reason why any of tasks doing simultaneously
"busy-loop on getting/releasing" a spinlock should starve almost
to death another one doing the same (or simply waiting to get this
lock) even without cpu_relax. Of course, lawfulness of such
behavior is questionable, and should be fixed like here.
 
> Trying to make the spinlocks do somethign else than what they do is just 
> papering over the real bug. The real bug is that anybody who just 
> busy-loops getting a lock is wasting resources so much that we should not 
> be at all surprised that some multi-core or NUMA situations will get 
> starvation.

On the other hand it seems spinlocks should be at least a little
more immune to such bugs: slowdown is OK but not freezing. Current
behavior could suggest this unfairness could harm some tasks even
without any loops present - but it's not visible enough.

So, I'm surprised this thread seems to stop after this patch, and
there is no try to make the most of this ideal testing case to
improve spinlock design btw.

Regards,
Jarek P.
