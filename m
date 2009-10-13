Return-Path: <linux-kernel-owner+w=401wt.eu-S1760211AbZJMPOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760211AbZJMPOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 11:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760163AbZJMPOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 11:14:45 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:35284 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbZJMPOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 11:14:44 -0400
Message-ID: <4AD49928.40600@us.ibm.com>
Date: Tue, 13 Oct 2009 08:13:44 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Blaise Gassend <blaise@willowgarage.com>
CC: Jeremy Leibs <leibs@willowgarage.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       "lkml," <linux-kernel@vger.kernel.org>
Subject: Re: ERESTARTSYS escaping from sem_wait with RTLinux patch
References: <1255165747.6385.117.camel@doodleydee> <alpine.LFD.2.00.0910101931080.9428@localhost.localdomain> <92be2ef30910102248t70d5e683tc525580fbf902af1@mail.gmail.com> <4AD33A4D.4070006@us.ibm.com> <1255384010.10236.123.camel@lts.willowgarage.com> <4AD3BD57.6080703@us.ibm.com> <4AD3D6AE.2050609@us.ibm.com> <4AD3FFB0.5030405@us.ibm.com>  <4AD4080C.20703@us.ibm.com> <1255424204.12737.233.camel@doodleydee>
In-Reply-To: <1255424204.12737.233.camel@doodleydee>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Blaise Gassend wrote:
>> When 3495 finally get's to run and complete it's futex_wake() call, the task
>> still needs to be woken, so we wake it - but now it's enqueued with a different
>> futex_q, which now has a valid lock_ptr, so upon wake-up we expect a signal!
>>
>> OK, I believe this establishes root cause.  Now to come up with a fix...
> 
> Wow, good work Darren! You definitely have more experience than I do at
> tracking down these in-kernel races, and I'm glad we have you looking at
> this. I'm snarfing up useful techniques from your progress emails.

Great, I learn a lot from reading other people's status-type email as 
well.  Glad I can be on the contributing end once and a while :)

> 
> So if I understand correctly, there is a race between wake_futex and a
> timeout (or a signal, but AFAIK when my python example is running
> steady-state there are no signals). The problem occurs when wake_futex
> gets preempted half-way through, after it has NULLed lock_ptr, but
> before it has woken up the waiter. If a timeout/signal wakes the waiter,
> and the waiter runs and starts waiting again before the waker resumes,
> then the waker will end up waking the waiter a second time, without the
> lock_ptr for the second wait being NULLified. This causes the waiter to
> mis-interpret what woke it and leads to the fault we observed.
> 
> Now I am wondering if the workaround described here
> http://markmail.org/message/at2s337yz3wclaif
> for what seems like this same problem isn't actually a legitimate fix.
> It ends up looking something like this: (lines 3 and 4 are new)
> 
>   ret = -ERESTARTSYS;
>   if (!abs_time) {
>     if (!signal_pending(current))
>       set_tsk_thread_flag(current,TIF_SIGPENDING);
>     goto out_put_key;
>   }

The trouble with this is it is a bandaid to a fundamentally broken 
wake-up path. I tried flagging the waiters on the wake-list as already 
woken and then skipping them in the wake_futex_list(), but this got ugly 
really fast.

Talking with Thomas a bit more we're not sure the patch that introduced 
this lockless waking actually does any good, as the normal wakeup path 
doesn't take the hb->lock anyway, it's more likely the contention was 
due to an app like this that wakes a task and almost immediately puts it 
back to sleep on a futex before the waker has a chance to drop the hb->lock.

The futex wake-up path is complicated enough as it is, in my personal 
opinion, we are better off dropping the "lockless wake-up" patch and 
removing the race and simplifying the wake-up path at the same time.

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
