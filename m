Return-Path: <linux-kernel-owner+w=401wt.eu-S1762437AbZAPMAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762437AbZAPMAB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 07:00:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759577AbZAPL7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 06:59:50 -0500
Received: from ozlabs.org ([203.10.76.45]:38124 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760301AbZAPL7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 06:59:48 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18800.30380.277025.456930@cargo.ozlabs.ibm.com>
Date: Fri, 16 Jan 2009 22:59:40 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH] perf_counter: Add counter enable/disable ioctls
In-Reply-To: <20090116110703.GA18165@elte.hu>
References: <18800.25726.604410.232889@cargo.ozlabs.ibm.com>
	<20090116110703.GA18165@elte.hu>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> Okay - please let me know when i can pull it - the extension of counter 
> ops to the 'family' looks nice and desirable.

Thanks - I'll try to do some basic testing this weekend.  I won't get
a chance to do any extensive testing for the next two weeks because
I'll be on vacation.

> I'm wondering, should it also extend to all members of a group perhaps - 
> or should that be separate ioctls?
> 
> It makes sense to individually enable/disable a single counter within a 
> group - including the group leader. So i guess we need 3 variants:
> 
>  - disable/enable single counter
>  - disable/enable group
>  - disable/enable family
> 
> We might as well just offer a single variant initially: 'disable/enable 
> everything that can be iterated from that counter', and provide more 
> specialized variants only once the specific need arises?

Well, each member of a group has its own family.  I don't see any need
to enable/disable the top-level (parent) counter separately from its
children, but as you say, if the need arises we can add that.

We can enable/disable individual subsidiary group members (and their
families) since we have an fd for each member.  We would only need
separate 'single counter' and 'group' ioctls for the group leader, and
once again we could add that if the need arises.

Currently the ioctls on the group leader disable/enable the whole
group.  I'm not sure that enabling/disabling individual counters in
the group will really be all that useful, but I put it in for
subsidiary counters since it falls out pretty easily and naturally in
the code.  If users want to disable/enable each counter in a group
individually, they could add an extra dummy counter (say a cpu_clock
counter) to be the group leader and then just mostly ignore it.

So I think that boils down to saying that what I have implemented is
the single variant that you propose in your last quoted paragraph
above. :)

> > I have to admit to a small element of cargo-cult programming in 
> > __perf_counter_enable and __perf_counter_disable: I put calls to 
> > curr_rq_lock_irq_save/restore in there because I was following the model 
> > of __perf_install_in_context, but I don't know what they do (beyond 
> > disabling/restoring interrupts) or why they are needed.  What are they 
> > there for?
> 
> That's an ugly detail: we can only observe and update the current task 
> clock with the runqueue lock held. So right now the counter ops are 
> structured so that we first take the rq lock (which implies irq disable as 
> well), and then all sw counters can assume that the rq lock is held.

OK.  Is there any advantage of the task_clock over the cpu_clock?
Could we get rid of task_clock (and therefore remove the
curr_rq_lock_* calls) and just use the cpu_clock?

Also, since we know we're only taking differences between readings on
the same cpu, could we use sched_clock() instead of cpu_clock() to
reduce overhead?  (We certainly could on powerpc, since we have
synchronized timebase registers, but I know you don't have that luxury
on x86. :)

Paul.
