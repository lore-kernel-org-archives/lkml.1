Return-Path: <linux-kernel-owner+w=401wt.eu-S1759176AbZJMJGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759176AbZJMJGK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 05:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759113AbZJMJGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 05:06:09 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:41238 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759046AbZJMJGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 05:06:07 -0400
Subject: Re: ERESTARTSYS escaping from sem_wait with RTLinux patch
From: Blaise Gassend <blaise@willowgarage.com>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: Jeremy Leibs <leibs@willowgarage.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       "lkml," <linux-kernel@vger.kernel.org>
In-Reply-To: <4AD4080C.20703@us.ibm.com>
References: <1255165747.6385.117.camel@doodleydee>
	 <alpine.LFD.2.00.0910101931080.9428@localhost.localdomain>
	 <92be2ef30910102248t70d5e683tc525580fbf902af1@mail.gmail.com>
	 <4AD33A4D.4070006@us.ibm.com>
	 <1255384010.10236.123.camel@lts.willowgarage.com>
	 <4AD3BD57.6080703@us.ibm.com> <4AD3D6AE.2050609@us.ibm.com>
	 <4AD3FFB0.5030405@us.ibm.com>  <4AD4080C.20703@us.ibm.com>
Content-Type: text/plain
Organization: Willow Garage
Date: Tue, 13 Oct 2009 01:56:44 -0700
Message-Id: <1255424204.12737.233.camel@doodleydee>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When 3495 finally get's to run and complete it's futex_wake() call, the task
> still needs to be woken, so we wake it - but now it's enqueued with a different
> futex_q, which now has a valid lock_ptr, so upon wake-up we expect a signal!
> 
> OK, I believe this establishes root cause.  Now to come up with a fix...

Wow, good work Darren! You definitely have more experience than I do at
tracking down these in-kernel races, and I'm glad we have you looking at
this. I'm snarfing up useful techniques from your progress emails.

So if I understand correctly, there is a race between wake_futex and a
timeout (or a signal, but AFAIK when my python example is running
steady-state there are no signals). The problem occurs when wake_futex
gets preempted half-way through, after it has NULLed lock_ptr, but
before it has woken up the waiter. If a timeout/signal wakes the waiter,
and the waiter runs and starts waiting again before the waker resumes,
then the waker will end up waking the waiter a second time, without the
lock_ptr for the second wait being NULLified. This causes the waiter to
mis-interpret what woke it and leads to the fault we observed.

Now I am wondering if the workaround described here
http://markmail.org/message/at2s337yz3wclaif
for what seems like this same problem isn't actually a legitimate fix.
It ends up looking something like this: (lines 3 and 4 are new)

  ret = -ERESTARTSYS;
  if (!abs_time) {
    if (!signal_pending(current))
      set_tsk_thread_flag(current,TIF_SIGPENDING);
    goto out_put_key;
  }

I think this works because the only bad thing that is happening in the
scenario you worked out is that the waiter failed to detect that the
second wake was spurious, and instead interpreted it as a signal.
However, the waiter can easily detect that the wakeup is spurious:
1) a futex wakeup can be detected by unqueue_me returning 0
2) a timeout can be detected by looking at to->task
3) a signal can be detected by calling signal_pending

futex_wait is already doing 1) and 2). If it additionally did 3), which
I think it is an inexpensive check, then it could detect the spurious
wakeup, and restart the wait, either by doing a
set_tsk_thread_flag(current,TIF_SIGPENDING) and relying on the signal
handling to restart the syscall as in the patch above, or by looping
back to somewhere around the futex_wait_setup call.

All the other fix ideas that come to mind end up slowing down the common
case by introducing additional locking in futex_wakeup, and hence seem
less desirable.

At this point I'll admit that I'm out of my depth and see what you
think...

Blaise

