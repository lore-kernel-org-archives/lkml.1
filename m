Return-Path: <linux-kernel-owner+w=401wt.eu-S1755565AbZAZXnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbZAZXnH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 18:43:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbZAZXmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 18:42:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55828 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752648AbZAZXmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 18:42:50 -0500
Date: Mon, 26 Jan 2009 15:42:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: oleg@redhat.com, a.p.zijlstra@chello.nl, rusty@rustcorp.com.au,
       travis@sgi.com, mingo@redhat.com, davej@redhat.com,
       cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] work_on_cpu: Use our own workqueue.
Message-Id: <20090126154217.b312e278.akpm@linux-foundation.org>
In-Reply-To: <20090126225957.GA3999@elte.hu>
References: <20090126202022.GA8867@elte.hu>
	<20090126130046.37b8f34e.akpm@linux-foundation.org>
	<20090126212727.GA13670@elte.hu>
	<20090126133551.fab5e27a.akpm@linux-foundation.org>
	<20090126214516.GA22142@elte.hu>
	<20090126140116.35f9c173.akpm@linux-foundation.org>
	<20090126220537.GA6755@elte.hu>
	<20090126141605.707877bb.akpm@linux-foundation.org>
	<20090126222002.GB10215@elte.hu>
	<20090126145003.b29b81d7.akpm@linux-foundation.org>
	<20090126225957.GA3999@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2009 23:59:57 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Mon, 26 Jan 2009 23:20:02 +0100
> > Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > 
> > > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > > 
> > > > On Mon, 26 Jan 2009 23:05:37 +0100
> > > > Ingo Molnar <mingo@elte.hu> wrote:
> > > > 
> > > > > 
> > > > > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > > > > 
> > > > > > Well it turns out that I was having a less-than-usually-senile moment:
> > > > > > 
> > > > > > :     implement flush_work()
> > > > > 
> > > > > > Why isn't that working in this case??
> > > > > 
> > > > > how would that work in this case? We defer processing into the workqueue 
> > > > > exactly because we want its per-CPU properties.
> > > > 
> > > > It detaches the work item, moves it to head-of-queue, reinserts it then 
> > > > waits on it.  I think.
> > > > 
> > > > This might have a race+hole.  If a currently-running "unrelated" work 
> > > > item tries to take the lock which the flush_work() caller is holding 
> > > > then there's no way in which keventd will come back to execute the work 
> > > > item which we just put on the head of queue.
> > > 
> > > Correct - or the unrelated worklet might also be blocked on something - so 
> > > the window is rather large.
> > > 
> > 
> > hm, OK, that sucks.
> > 
> > But the deadlock still exists with Rusty's patches, doesn't it?  We 
> > still have a single kernel thread per CPU processing all the unrelated 
> > work_on_cpu() callers.  All we've done is to decouple work_on_cpu() from 
> > the keventd queue.
> 
> This particular deadlock does not exist - but you are indeed right that 
> similar types of 'unrelated' interactions might exist in the future, as 
> the usage of this facility is extended.

So... can we call the new kernel threads [kbandaidd]?

> > If correct, we'd need to create a gaggle of kernel threads on each call 
> > to work_on_cpu(), which doesn't sound nice.
> > 
> > A more efficient but trickier approach would be to create kernel threads 
> > within flush_work(), with which to run the CPU-specific worklet.  We 
> > only need to do that in the case where the CPU's keventd thread was off 
> > doing something and might deadlock, which will be rare. If the keventd 
> > was just parked waiting for something to do then we can safely feed it 
> > the to-be-flushed work item for immediate processing.
> 
> i think what you describe is a variant of the syslet thread pool ;-)

It's fairly simple.  The slightly tricky bit will be ensuring that
keventd will reliably swallow the work item which we just fed it,
before anything else.  But I guess the spinlock will be sufficient there.
But I don't think we should do any of this.

> > It'd be saner to just say "don't call work_on_cpu() while holding locks"
> > :( I bet there's some lockdep infrastructre which we could peek into to
> > add the assertion check...
> 
> The problem isnt doing the assertions - lockdep already covers workqueue 
> dependencies very efficiently.
> 
> The problem is the intrinsic utility of work_on_cpu(): we _really_ want 
> such a generic facility to be usable from any (blockable) context, just 
> like on_each_cpu(func, info) does for atomic functions, without 
> restrictions on locking context.

Do we?  work_on_cpu() is some last-gasp oh-i-screwed-my-code-up thing. 
We _really_ want people to use on_each_cpu()!

We should bust a gut to keep the number of callers to the
resource-intensive (deadlocky!) work_on_cpu() to a minimum.

(And to think that adding add_timer_on() creeped me out).


hm.  None of that was very helpful.  How to move forward?

I think I disagree that work_on_cpu() should be made into some robust,
smiled-upon core kernel facility.  It _is_ slow, it _is_ deadlockable. 
It should be positioned as something which is only used as a last
resort.  And if you _have_ to use it, sort out your locking!

Plus the number of code sites which want to fiddle with other CPUs in
this manner will always be small.  cpufreq, MCE, irq-affinity, things
like that.

What is the deadlock in acpi-cpufreq?  Which lock, and who is the
"other" holder of that lock?
