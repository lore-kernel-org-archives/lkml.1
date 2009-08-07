Return-Path: <linux-kernel-owner+w=401wt.eu-S1756943AbZHGAYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943AbZHGAYx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 20:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756722AbZHGAYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 20:24:52 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:48497 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756697AbZHGAYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 20:24:51 -0400
Message-ID: <4A7B7449.7070008@us.ibm.com>
Date: Thu, 06 Aug 2009 17:24:41 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
CC: tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       mingo@elte.hu, dino@in.ibm.com, johnstul@us.ibm.com,
       John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH 1/2] Update woken requeued futex_q lock_ptr
References: <4A7A009E.2000202@us.ibm.com> <4A7A016C.1090002@us.ibm.com> <4A7A66D7.3090203@us.ibm.com>
In-Reply-To: <4A7A66D7.3090203@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Darren Hart wrote:
> Darren Hart wrote:
>> futex_requeue() can acquire the lock on behalf of a waiter during the 
>> requeue
>> loop in the event of a lock steal or owner died. 
>> futex_wait_requeue_pi() cleans
>> up the pi_state owner, using the lock_ptr to protect against 
>> concurrent access
>> to the pi_state.  The pi_state is found on the requeue target futex 
>> hash bucket
>> so the lock_ptr needs to be updated accordingly.  The problem 
>> manifested by
>> triggering the WARN_ON in lookup_pi_state() about the pid != 
>> pi_state->owner
>> pid.
>> The astute reviewer will note that still exists a race between the time
>> futex_requeue() releases hb2->lock() and the time when 
>> futex_wait_requeue_pi()
>> acquires it.  During this time the pi_state and the futex uaddr are 
>> not in sync
>> with the rt_mutex ownership.  This patch closes the window to the 
>> point where
>> my tests now pass, but we still need to address it.
>>
>> Note: Please apply to mainline and rt
>>
> 
> 
>> static inline
>> -void requeue_pi_wake_futex(struct futex_q *q, union futex_key *key)
>> +void requeue_pi_wake_futex(struct futex_q *q, union futex_key *key,
>> +               struct futex_hash_bucket *hb)
>> {
>>     drop_futex_key_refs(&q->key);
>>     get_futex_key_refs(key);
>>     q->key = *key;
>> +    q->lock_ptr = &hb->lock;
> 
> Hrm... turns out changing this breaks the 
> handle_early_requeue_pi_wakeup() logic.  I'll have to respin this patch 
> to account for that as well.  Please hold off on this patch.

In fact, this doesn't affect the handle_early_requeue_pi_wakeup() code 
in the slightest.  It only needs to hold a hb->lock (either one is 
adequate) to ensure the requeue routine has completed.  By changing the 
q->lock_ptr of the waiter to hb2->lock we ensure the pi_state is 
protected from concurrent access by futex_wait_requeue_pi() and new 
contending threads.

Ingo, please apply to tip/urgent.

Thanks,

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
