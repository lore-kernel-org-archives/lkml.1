Return-Path: <linux-kernel-owner+w=401wt.eu-S1759257AbYGPVzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759257AbYGPVzk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 17:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755619AbYGPVzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 17:55:32 -0400
Received: from rn-out-0910.google.com ([64.233.170.184]:5459 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010AbYGPVzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 17:55:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=BxIBpy0BgKf8xKf/ZyS5zqVGsIwUg7pgV+/iFGmHprAOGQ44W05FUZrCfxyNejUwbe
         cGgvuAKK5dftShvZ5SnLJU5pNlngyxCYUhPluFZqlSqSU5BTt4G4fAL87d2Sm5adYFj2
         7M4liK9D+ePNHJ2Y/Ni/n8HzGPyW52eOpfeE0=
Message-ID: <b647ffbd0807161455gf9b36ddwea8a843832adf66b@mail.gmail.com>
Date: Wed, 16 Jul 2008 23:55:30 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Max Krasnyansky" <maxk@qualcomm.com>
Subject: Re: [PATCH] cpu hotplug, sched: Introduce cpu_active_map and redo sched domain managment (take 2)
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
       pj@sgi.com, ghaskins@novell.com, linux-kernel@vger.kernel.org
In-Reply-To: <487E5A15.8030302@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1216122229-4865-1-git-send-email-maxk@qualcomm.com>
	 <b647ffbd0807160157maba3934vef9b9d74680d6508@mail.gmail.com>
	 <487E5A15.8030302@qualcomm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/16 Max Krasnyansky <maxk@qualcomm.com>:
>
>
> Dmitry Adamushko wrote:
>> 2008/7/15 Max Krasnyansky <maxk@qualcomm.com>:
>>> From: Max Krasnyanskiy <maxk@qualcomm.com>
>>>
>>> Addressed Ingo's comments and merged on top of latest Linus's tree.
>>
>> a few remarks:
>>
>> (1) in __migrate_task(), a test for !cpu_active(dest_cpu) should be
>> done after double_rq_lock() [ or add the second one ]
>>
>> migration_thread() calls __migrate_task() with disabled interrupts (no
>> rq-locks held), i.e. if we merely rely on rq-locks for
>> synchronization, this can race with cpu_down(dest_cpu).
>>
>> [ assume, the test was done in __migration_task() and it's about to
>> take double_lock()... and at this time, down_cpu(dest_cpu) starts and
>> completes on another CPU ]
>>
>> note, we may still take the rq-lock for a "dead" cpu in this case and
>> then only do a check (remark: in fact, not with stop_machine() in
>> place _but_ I consider that we don't make any assumptions on its
>> behavior);
> Hmm, as you suggested I added synchronize_sched() after clearing the active
> bit (see below). Is that not nought enough ? I mean you mentioned that
> stop_machine syncs things up, I assume synchronize_sched does too.

Yes, sorry for the noise here.

 * synchronize_sched - block until all CPUs have exited any non-preemptive
 * kernel code sequences

so "any non-preemptive" sections, not just the ones with run-queue
locks being held.


>> (2) it's worth to take a look at the use of any_online_cpu():
>>
>> many places are ok, because there will be an additional check against
>> cpu_active_mask later on, but e.g.
>>
>> set_cpus_allowed_ptr() ->
>> migrate_task(p, any_online_cpu(mask), ...) ->
>> migrate_task(p, dest_cpu)
>>
>> doesn't seem to have any verifications wrt cpu_active_map.
> How about we just introduce any_active_cpu() and replace all the usages of
> any_online_cpu() in the scheduler ?

I think, at least for places related to task placement (like
migrate_task(..., any_online_cpu()) it would make sense,
consistency-wise.



>
> Max
>

-- 
Best regards,
Dmitry Adamushko
