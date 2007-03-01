Return-Path: <linux-kernel-owner+w=401wt.eu-S965553AbXCAUD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965553AbXCAUD7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 15:03:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965556AbXCAUD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 15:03:59 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:50724 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965553AbXCAUD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 15:03:58 -0500
Message-ID: <45E731AD.70507@vmware.com>
Date: Thu, 01 Mar 2007 12:03:57 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Daniel Hecht <dhecht@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Bug in on_each_cpu?
References: <45E6AC1A.8050608@vmware.com>	<20070301024524.c7c8ea1a.akpm@linux-foundation.org>	<45E6BA3A.2040306@vmware.com> <20070301072859.aea3c4da.akpm@linux-foundation.org>
In-Reply-To: <20070301072859.aea3c4da.akpm@linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------040509010207060507050404"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040509010207060507050404
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Andrew Morton wrote:
> On Thu, 01 Mar 2007 03:34:18 -0800 Zachary Amsden <zach@vmware.com> wrote:
>
>   
>>> Why is it a bug?  Because there's a deadlock where this CPU is waiting for
>>> CPU A to take the IPI, but CPU A is waiting (with interrupts disabled) for
>>> this CPU to take an IPI.
>>>   
>>>       
>> Then the bug is not in on_each_cpu().  It is in the usage of 
>> clock_was_set().  For example, look at do_settimeofday in kernel/timer.c:
>>
>>         write_sequnlock_irqrestore(&xtime_lock, flags);
>>
>>         /* signal hrtimers about time change */
>>         clock_was_set();
>>
>>         return 0;
>>     
>
> Perhaps a WARN_ON(irqs_disabled()) in clock_was_set() would help.  But probably
> the one in smp_call_function() will suffice.
>   

I'm a little unsure of how the timers play with sysfs suspend/resume, 
but calling do_settimeofday with irqs disabled is now clearly a bug.  
I'm thinking if these two cases don't fire under use, then we can safely 
down-convert the call sites.  Ingo, Thomas, what do you think of this 
(untested, unverified, patch attached):  is it true?

> yup.  I once played with adding warnings in places like spin_lock_irq(), 
> but there were false positives from places which were odd-but-correct.
>
> It would be worth revisiting however.
>   

Yes, I recall non-linear control flow in the floppy and ide drivers that 
did this, and were odd, but correct under certain call conventions.  
Whether they remain correct or still exist should be worth revisiting.

I think at least in the timer code, we should preserve the same 
invariants across the two implementations of do_getttimeofday.  One uses 
write_seqlock_irq, the other write_seqlock_irqsave.  This confused me 
into thinking it was safe to call do_gettimeofday with irqs disabled (it 
used to be in 2.6.20).  But they both call clock_was_set, and thus 
on_each_cpu, so either both of them have a bug or they both can be 
reduced to irq instead of irqsave.  I'm guessing the latter is the case.

Zach

--------------040509010207060507050404
Content-Type: text/plain;
 name="gettimeofday-irq-reduce.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gettimeofday-irq-reduce.patch"


Index: linux-2.6.21/kernel/timer.c
===================================================================
--- linux-2.6.21.orig/kernel/timer.c	2007-02-16 16:45:44.000000000 -0800
+++ linux-2.6.21/kernel/timer.c	2007-03-01 11:56:23.000000000 -0800
@@ -841,14 +841,14 @@ EXPORT_SYMBOL(do_gettimeofday);
  */
 int do_settimeofday(struct timespec *tv)
 {
-	unsigned long flags;
 	time_t wtm_sec, sec = tv->tv_sec;
 	long wtm_nsec, nsec = tv->tv_nsec;
 
 	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
 		return -EINVAL;
 
-	write_seqlock_irqsave(&xtime_lock, flags);
+	BUG_ON(irqs_disabled());
+	write_seqlock_irq(&xtime_lock);
 
 	nsec -= __get_nsec_offset();
 
@@ -861,7 +861,7 @@ int do_settimeofday(struct timespec *tv)
 	clock->error = 0;
 	ntp_clear();
 
-	write_sequnlock_irqrestore(&xtime_lock, flags);
+	write_sequnlock_irq(&xtime_lock);
 
 	/* signal hrtimers about time change */
 	clock_was_set();
@@ -981,6 +981,7 @@ static int timekeeping_resume(struct sys
 	unsigned long flags;
 	unsigned long now = read_persistent_clock();
 
+	WARN_ON_ONCE(irqs_disabled());
 	write_seqlock_irqsave(&xtime_lock, flags);
 
 	if (now && (now > timekeeping_suspend_time)) {

--------------040509010207060507050404--
