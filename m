Return-Path: <linux-kernel-owner+w=401wt.eu-S934648AbZJIWDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934648AbZJIWDJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 18:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934392AbZJIWDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 18:03:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:46449 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933225AbZJIWDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 18:03:08 -0400
Subject: Re: [PATCH RFC] sched: add notifier for process migration
From: Peter Zijlstra <peterz@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Avi Kivity <avi@redhat.com>,
       Andi Kleen <ak@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <4ACFA4C5.4020607@goop.org>
References: <4ACFA4C5.4020607@goop.org>
Content-Type: text/plain
Date: Sat, 10 Oct 2009 00:02:18 +0200
Message-Id: <1255125738.7439.17.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-09 at 14:01 -0700, Jeremy Fitzhardinge wrote:

> I'm working on adding vsyscall (vread) support for
> arch/x86/kernel/pvclock.c.  The algorithm needs to look up per-cpu tsc
> parameters (aka pvclock_vcpu_time_info) so that it can compute global
> system time from the tsc.  To do this, it needs to grab a consistent
> snapshot of (tsc, time_info).

time_info as in gettimeofday()?, that's supposed to be globally
consistent, so get that first and then get the tsc and you're as race
free as you're ever going to get from userspace.

> Obviously this is all racy from usermode, because there are two levels
> of scheduling going on the virtual case: kernel scheduling of tasks to
> vcpus, and hypervisor scheduling of vcpus to pcpus.  The latter is dealt
> with a version number in the tsc parameter structure to indicate changes
> in the params (which could be due to scheduling, power events, etc).
> 
> To deal with kernel scheduling I want a second version number to let
> usermode know they've been migrated to a new (v)cpu and need to try
> again with updated time parameters.  Specifically, update the version on
> the "from" vcpu so that usermode (vsyscall) code holding an old pointer
> can see the number change and reload the cpu number and get a pointer to
> the new cpu's time_info.

/me utterly confused.

> Initially I was doing this with a preempt notifier on sched_out, but Avi
> pointed out that this was a pessimistic approximation of what I really
> want, which is notification on cross-cpu migration.  And since migration
> is an inherently expensive operation, the overhead of a notifier here
> should be negligible.  (Aside from that, the preempt notifier mechanism
> isn't intended to be enabled on every process on the system.)

And here you're utterly failing to explain what you want such a notifier
would do.

> So I'm proposing this patch.  My questions are:
> 
>    1. Does this look generally reasonable?

I'm generally confused and not at all clear as to how things would work.
Afaik the vdso is a global entity and does not contain per-cpu or
per-task state.

If you're proposing to increment a global seq count on every task
migration, then I think its a terribly bad idea.

>    2. Will this notifier actually be called every time a task gets
>       migrated between CPUs?  Are there cases where migration may happen
>       via some other path? (Though for my particular case I only care
>       about migration when the task is actually preempted; if it goes to
>       sleep on one cpu and happens to wake on another then it wasn't in
>       the middle of getting time so it doesn't matter.)

No, you've missed quite a lot of cases.

>    3. Or is there a better way to achieve what I want?
> 
> This might also be a generally useful extension to vgetcpu() caching so
> that usermode can definitively tell whether the cpu number has changed
> under its feet and needs to be reloaded via lsl/rdtscp, rather than
> having to rely on a jiffies-based approximation.

I've got no idea how vgetcpu() works, but since the vdso page is global
and not per-task, I can't really see how it could work sanely.

