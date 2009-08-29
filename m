Return-Path: <linux-kernel-owner+w=401wt.eu-S1751908AbZH2Hwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbZH2Hwx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 03:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbZH2Hww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 03:52:52 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:37882 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbZH2Hwv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 03:52:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type:content-transfer-encoding;
        b=jJ9JAGj9ELAoeemlDkVEE3BD7leTGJVTouiyM5xtwkEBP5ppQ5hes6qlncXOfdHjwq
         m9vRXsZtAu6Dtw7w+oyPl615OtBT66ktC6YRllutJ490EjpMHmFj2yieCVbxmRVT/zt6
         LDl3sVhg+Z/hCKmx+ZU1J/3FnhGM9UicU5A/I=
MIME-Version: 1.0
Date: Sat, 29 Aug 2009 09:47:17 +0200
X-Google-Sender-Auth: 460dbeee978c309b
Message-ID: <3efb10970908290047k6f4d5a14of148db7f2b179f18@mail.gmail.com>
Subject: Re: System lockup with 2.6.26.8-rt16 on ARM9 [Solved]
From: Remy Bohmer <linux@bohmer.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

> We are running into a bug on a ARM926 processor with 2.6.26.8-rt16
> where the system stops scheduling any thread while the hard-irq
> handlers keep on running (and waking up tasks with wake_up_process())
> What happens is that the system is idle and is continuously polling on
> need_resched() in the cpu_idle() routine (arch/arm/kernel/process.c)
> But, need_resched() keeps on returning false, so the system stays in
> the idle loop and __schedule is never called.
>
> While debugging this we noticed/tried several things already:
> * default_idle() wakes up properly when an interrupt occurs.
> * Interrupt handling keeps on running, but no interrupt threads are
> scheduled either.
> * Triggering a different interrupt source sometimes get the system out
> of the lockup condition.
> * removing the loop with need_resched() to force the system to call
> __schedule() after waking up from default_idle() has no effect, the
> scheduler does not schedule any threads that are clearly runnable. See
> logging below.
> * preempt_schedule_irq() is not called after an irq during the lockup.
> Probably it is because the check on preempt_count!=0 in __irq_svc (in
> arch/arm/kernel/entry-armv.S).
> * We have excluded any relation with any user application by adding
> root_delay=<1-month-in-seconds> to the kernel commandline.
> * We stripped down the kernel as much as possible, excluding almost
> all drivers, including removing the networking layer. (but with
> networking and a ping flood it seems easier to reproduce)
> * Problem exists with NO_HZ, HRT as well as without it.
>
> We call 'print_cpu()' when a lockup occurs. We call it directly from a
> hard-irq handler.
> (canary_check is a kernel thread that is part of our debugging code.
> It is a thread that is directly scheduled via wake_up_process() from
> the system timer irq. We check from the hard-irq handler if this
> thread is being scheduled, if not the system is locked up and we dump
> this logging)
>
> [ 8931.475755]
> [ 8931.475769] cpu#0
> [ 8931.479186]   .nr_running                    : 3
> [ 8931.483809]   .load                          : 532566
> [ 8931.488862]   .nr_switches                   : 37438443
> [ 8931.494089]   .nr_load_updates               : 860943
> [ 8931.499142]   .nr_uninterruptible            : 1
> [ 8931.503761]   .jiffies                       : 830943
> [ 8931.508816]   .next_balance                  : 0.000000
> [ 8931.514043]   .curr->pid                     : 0
> [ 8931.518664]   .clock                         : 8931475.737362
> [ 8931.524411]   .cpu_load[0]                   : 532566
> [ 8931.529464]   .cpu_load[1]                   : 532420
> [ 8931.534516]   .cpu_load[2]                   : 516298
> [ 8931.539569]   .cpu_load[3]                   : 433653
> [ 8931.544621]   .cpu_load[4]                   : 310689
> [ 8931.549674]   .rt.rt_nr_running              : 3
> [ 8931.554293]   .rt.rt_nr_uninterruptible      : 4294967293
> [ 8931.559694]
> [ 8931.559703] cfs_rq[0]:
> [ 8931.563548]   .exec_clock                    : 0.000000
> [ 8931.568778]   .MIN_vruntime                  : 0.000001
> [ 8931.574007]   .min_vruntime                  : 1254.953603
> [ 8931.579496]   .max_vruntime                  : 0.000001
> [ 8931.584724]   .spread                        : 0.000000
> [ 8931.589952]   .spread0                       : 0.000000
> [ 8931.595178]   .nr_running                    : 0
> [ 8931.599796]   .load                          : 0
> [ 8931.604414]   .nr_spread_over                : 0
> [ 8931.609048]
> [ 8931.609056] runnable tasks:
> [ 8931.609067]             task   PID         tree-key  switches  prio
>    exec-runtime         sum-exec        sum-sleep
> [ 8931.609094] ----------------------------------------------------------------------------------------------------------
> [ 8931.634702]     sirq-timer/0     5         6.652438   1003780    59
>              0               0               0.000000
> 0.000000               0.000000
> [ 8931.649795]     canary_check    33        78.141669    860433     0
>              0               0               0.000000
> 0.000000               0.000000
> [ 8931.664887]           IRQ-57   243       832.211283  13874273    59
>              0               0               0.000000
> 0.000000               0.000000
> [ 8931.764591]
>

Well, we found the root cause of this problem.
It turned out to be caused by sched_clock() that made disjunct time jumps.
This caused this check to become true in kernel/sched_rt.c:370:
         if (rt_rq->rt_time > runtime) {
                rt_rq->rt_throttled = 1;
                if (rt_rq_throttled(rt_rq)) {
                        sched_rt_rq_dequeue(rt_rq);
                        return 1;
                }
        }

The end results is that all realtime tasks got throttled for a long
time, and that time got extended every time sched_clock() made such a
jump. I would never have expected the scheduler would show this kind
of behaviour while CONFIG_RT_GROUP_SCHED is _not_ set...

The root-cause of the sched_clock being faulty was a synchronisation
issue between 2 clock domains. The CPU clock and the clock domain of
the peripheral (GPT) on which the sched_clock() implementation was
based. The GPT made jumps backwards which triggered a false wraparound
detection in the conversion of 32->64 bit timestamps, causing the time
to jump about 356 seconds in the future...

Thinking about this, we would have found it much earlier if
print_cpu() would have printed the 'throttled' state of a task as
well.
Besides that, it would have helped a lot if the scheduler would print
a message if such time jumps happen...

If there is interest I can provide a patch for that.


Kind regards,

Remy
