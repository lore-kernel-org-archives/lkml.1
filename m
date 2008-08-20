Return-Path: <linux-kernel-owner+w=401wt.eu-S1755408AbYHTT35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbYHTT35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 15:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756724AbYHTT1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 15:27:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59694 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756894AbYHTT1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 15:27:20 -0400
Date: Wed, 20 Aug 2008 12:25:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: mingo@elte.hu, jens.axboe@oracle.com, a.p.zijlstra@chello.nl,
       cborntra@de.ibm.com, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org, arjan@infradead.org
Subject: Re: [PATCH RFC 1/3] Add a trigger API for efficient non-blocking
 waiting
Message-Id: <20080820122546.6022d91d.akpm@linux-foundation.org>
In-Reply-To: <48AC6593.80505@goop.org>
References: <48A70185.2020600@goop.org>
	<20080819232108.c03660fa.akpm@linux-foundation.org>
	<48AC6593.80505@goop.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Aug 2008 11:42:27 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Andrew Morton wrote:
> > On Sat, 16 Aug 2008 09:34:13 -0700 Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> >
> >   
> >> There are various places in the kernel which wish to wait for a
> >> condition to come true while in a non-blocking context.  Existing
> >> examples of this are stop_machine() and smp_call_function_mask().
> >> (No doubt there are other instances of this pattern in the tree.)
> >>
> >> Thus far, the only way to achieve this is by spinning with a
> >> cpu_relax() loop.  This is fine if the condition becomes true very
> >> quickly, but it is not ideal:
> >>
> >>  - There's little opportunity to put the CPUs into a low-power state.
> >>    cpu_relax() may do this to some extent, but if the wait is
> >>    relatively long, then we can probably do better.
> >>     
> >
> > If this change saves a significant amount of power then we should fix
> > the offending callsites.
> >   
> 
> Fix them how?  In general we're talking about contexts where we can't
> block, and where the wait time is limited by some property of the
> platform, such as IPI time or interrupt latency (though doing a
> cross-cpu call of a long-running function would be something we could fix).

ah, OK, I'd failed to note that you had identified two specific culprits.

Are either of these operations executed frequently enough for there to
be significant energy savings here?

> >>  - In a virtual environment, spinning virtual CPUs just waste CPU
> >>    resources, and may steal CPU time from vCPUs which need it to make
> >>    progress.  The trigger API allows the vCPUs to give up their CPU
> >>    entirely.  The s390 people observed a problem with stop_machine
> >>    taking a very long time (seconds) when there are more vcpus than
> >>    available cpus.
> >>     
> >
> > If this change saves a significant amount of virtual-cpu-time then we
> > should fix the offending callsites.
> >   
> 
> This case isn't particularly about saving vcpu time, but making timely
> progress.  stop_machine() gets all the cpus into a spinloop, where they
> spin waiting for an event to tell them to go to their next state-machine
> state.  By definition this can't be a blocking operation (since the
> whole point is that they're high priority threads that prevent anything
> else from running).  But in the virtual case, the fact that they're all
> spinning means that the underlying hypervisor has no idea who's just
> spinning, and who's trying to do some work needed to make overall
> progress, so the whole thing gets bogged down.

hm.  I'm surprised that stop_machine() is executed frequently enough
for you to care.  What's causing it?

> Now perhaps we could solve stop_machine by modifying the scheduler in
> some way, where you can block the run queue so that you sit in the idle
> loop even though there's runnable processes waiting.  But even then,
> stop_machine requires that interrupts be disabled, which means the we're
> pretty much limited to spinning.

If stop_machine() is the _only_ problematic callsite and we reasonably
expect that no new ones will pop up then sure, a
stop_machine()-specific fix might be appropriate.

Otherwise, sure, we'd need to loko at something more general.

> So my proposal is to add a non-scheduler-blocking operation which is
> semantically equivalent to spinning, but gives the underlying platform
> more information about what's going on.
> 
> Arjan suggested that since this is more or less equivalent to a
> completion, we should just implement "spinpletions" - a spinning
> completion.  This should be more familiar to kernel programmers, and
> should be just as useful as triggers.
> 
> I've run out of time to work on this now, but Rusty has hinted he'll
> pick up the baton...
> 
> (I'd also like to hear from other architecture folks, particularly s390,
> to make sure this is going to be useful to them too.)
> 
>     J
