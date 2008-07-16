Return-Path: <linux-kernel-owner+w=401wt.eu-S1756776AbYGPU3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776AbYGPU3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 16:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbYGPU3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 16:29:16 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:59596 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbYGPU3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 16:29:15 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5340"; a="4603905"
Message-ID: <487E5A15.8030302@qualcomm.com>
Date: Wed, 16 Jul 2008 13:29:09 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: mingo@elte.hu, a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
       pj@sgi.com, ghaskins@novell.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpu hotplug, sched: Introduce cpu_active_map and redo
 sched domain managment (take 2)
References: <1216122229-4865-1-git-send-email-maxk@qualcomm.com> <b647ffbd0807160157maba3934vef9b9d74680d6508@mail.gmail.com>
In-Reply-To: <b647ffbd0807160157maba3934vef9b9d74680d6508@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Dmitry Adamushko wrote:
> 2008/7/15 Max Krasnyansky <maxk@qualcomm.com>:
>> From: Max Krasnyanskiy <maxk@qualcomm.com>
>>
>> Addressed Ingo's comments and merged on top of latest Linus's tree.
> 
> a few remarks:
> 
> (1) in __migrate_task(), a test for !cpu_active(dest_cpu) should be
> done after double_rq_lock() [ or add the second one ]
> 
> migration_thread() calls __migrate_task() with disabled interrupts (no
> rq-locks held), i.e. if we merely rely on rq-locks for
> synchronization, this can race with cpu_down(dest_cpu).
> 
> [ assume, the test was done in __migration_task() and it's about to
> take double_lock()... and at this time, down_cpu(dest_cpu) starts and
> completes on another CPU ]
> 
> note, we may still take the rq-lock for a "dead" cpu in this case and
> then only do a check (remark: in fact, not with stop_machine() in
> place _but_ I consider that we don't make any assumptions on its
> behavior);
Hmm, as you suggested I added synchronize_sched() after clearing the active
bit (see below). Is that not nought enough ? I mean you mentioned that
stop_machine syncs things up, I assume synchronize_sched does too.

I guess testing inside the double_rq_lock() does not hurt anyway. We already
have fail recovery path there. But are you sure it's needed given the explicit
sync (in fact we have double sync now :), one with synchronize_sched() and
then with the stop_machine)).

> (2) it's worth to take a look at the use of any_online_cpu():
> 
> many places are ok, because there will be an additional check against
> cpu_active_mask later on, but e.g.
> 
> set_cpus_allowed_ptr() ->
> migrate_task(p, any_online_cpu(mask), ...) ->
> migrate_task(p, dest_cpu)
> 
> doesn't seem to have any verifications wrt cpu_active_map.
How about we just introduce any_active_cpu() and replace all the usages of
any_online_cpu() in the scheduler ?

> (3) I assume, we have some kind of explicit sched_sync() after
> cpu_clear(cpu, cpu_active_mask) because:
> 
> (a) not all places where task-migration may take place do take the
> rq-lock for dest_cpu : e.g. try_to_wake_up() or even
> sched_migrate_task() [ yes, there is a special (one might call
> "subtle") assumption/restriction in this case ]
> 
> that's why the fact that cpu_down() takes the rq-lock for
> soon-to-be-offline cpu at some point can not be a "natural" sync.
> point to guarantee that "stale" cpu_active_map is not used.
> 
> (b) in fact, stop_machine() acts as a (very strong) sync. point,
> sched-wise. But perhaps, we don't want to have this new easy-to-follow
> approach to be built on top of assumptions on how something from
> another sub-system behaves.
Yep. As you suggested I've added synchronize_sched() and updated the comment
that explains the deal with the stop machine.
	http://lkml.org/lkml/2008/7/15/736
Peter, already ACKed it.

Max
