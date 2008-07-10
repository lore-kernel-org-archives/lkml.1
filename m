Return-Path: <linux-kernel-owner+w=401wt.eu-S1756343AbYGJIz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343AbYGJIz1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 04:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbYGJIzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 04:55:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37662 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340AbYGJIzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 04:55:15 -0400
Date: Thu, 10 Jul 2008 10:55:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Elias Oltmanns <eo@nebensachen.de>
Cc: linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: Scheduling issue with signal handling
Message-ID: <20080710085500.GA19918@elte.hu>
References: <87wsju88b1.fsf@denkblock.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wsju88b1.fsf@denkblock.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Elias Oltmanns <eo@nebensachen.de> wrote:

> By sprinkling some printk()s all over the place, I've managed to 
> establish the following sequence of events taking place in the event 
> of delayed signal handling as described above: The first Ctrl+Z event 
> enqueues a SIGTSTP signal which eventually results in a call to 
> kick_process(). For some reason though, the signal isn't handled 
> straight away but remains on the queue for some time. Consequently, 
> subsequent Ctrl+Z events result in echoing another ^Z to the terminal 
> but everything related to sending a signal is skipped (and rightly so) 
> because the kernel detects that a SIGTSTP is still pending. 
> Eventually, get_signal_to_deliver() dequeues the SIGTSTP signal and 
> the shell propt appears.
> 
> My question is this: Even under high disk I/O pressure, the threads 
> dealing with I/O to the terminal evidently still get their turn as 
> indicated by the sequence of ^Z appearing on screen. Why is it then, 
> that the threads which are meant to process the SIGTSTP or SIGINT 
> signals aren't scheduled for some seconds and is there a way to change 
> this?
> 
> Please let me know if there is anything I can try to investigate this 
> any further or if you need further information.
> 
> Thanks in advance,
> 
> Elias
> 
> [1] http://lkml.org/lkml/2008/6/28/50

hm, kick_process() is a no-op on !SMP.

Basically, when a new signal is queued and a task is already running, it 
will run in due course and process the signal the moment it's scheduled 
again. (unless the signal is blocked)

If a task is not already running, then the signal code will wake up the 
task and it will then process the signal the moment it's executed.

The maximum latency of a runnable task hitting the CPU is controlled via 
/proc/sys/kernel/sched_latency [available if CONFIG_SCHED_DEBUG=y in the 
.config] - 20 milliseconds on uniprocessors.

Several seconds of lag is almost out of question and would indicate a 
serious scheduler bug, or - which is far more likely - either an 
application signal processing hickup or a kernel signal processing 
hickup.

If the lag happens with the task you can observe its worst-case 
scheduling delay by looking at /proc/<PID>/sched, if you also have 
CONFIG_SCHEDSTAT=y in your .config.

For example, a random shell's delays on a testbox:

  phoenix:~> grep se.wait_max /proc/$$/sched
  se.wait_max                        :             3.338588

That's 3.3 msecs _worst case_, on a system that has otherwise quite 
insane load:

 10:53:57 up  2:48,  2 users,  load average: 77.56, 94.33, 102.75

So several seconds of delay, if it came from the scheduler, would be 
really anomalous.

As a final measure, instead of printk's, you could try the scheduler 
tracer in linux-next (CONFIG_CONTEXT_SWITCH_TRACER=y), to have an exact 
idea about what is going on and when. (see /debug/tracing/README)

[ You might also want to try CONFIG_FTRACE=y and CONFIG_DYNAMIC_FTRACE=y
  for extremely finegrained kernel tracing - available in linux-next 
  too. ]

	Ingo
