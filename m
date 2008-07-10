Return-Path: <linux-kernel-owner+w=401wt.eu-S1758116AbYGJOd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116AbYGJOd0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 10:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756977AbYGJOcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 10:32:43 -0400
Received: from nebensachen.de ([195.34.83.29]:41987 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756273AbYGJOck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 10:32:40 -0400
X-Hashcash: 1:20:080710:mingo@elte.hu::ykIe4NBNvnHNCwtT:00002ZgX
X-Hashcash: 1:20:080710:linux-kernel@vger.kernel.org::VZvm4Rnx6uLWSllb:00000000000000000000000000000000000L1
X-Hashcash: 1:20:080710:roland@redhat.com::9p54n3HvPSyrzLP7:000000000000000000000000000000000000000000003EQz
X-Hashcash: 1:20:080710:a.p.zijlstra@chello.nl::3A0uemDh6yreOFAI:00000000000000000000000000000000000000046C1
X-Hashcash: 1:20:080710:dmitry.adamushko@gmail.com::x0TL102LJXqpRIaZ:000000000000000000000000000000000005lX8
From: Elias Oltmanns <eo@nebensachen.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: Scheduling issue with signal handling
References: <87wsju88b1.fsf@denkblock.local> <20080710085500.GA19918@elte.hu>
Date: Thu, 10 Jul 2008 16:30:25 +0200
In-Reply-To: <20080710085500.GA19918@elte.hu> (Ingo Molnar's message of "Thu,
	10 Jul 2008 10:55:00 +0200")
Message-ID: <87bq1595ha.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> wrote:
> * Elias Oltmanns <eo@nebensachen.de> wrote:
>
>> By sprinkling some printk()s all over the place, I've managed to 
>> establish the following sequence of events taking place in the event 
>> of delayed signal handling as described above: The first Ctrl+Z event 
>> enqueues a SIGTSTP signal which eventually results in a call to 
>> kick_process(). For some reason though, the signal isn't handled 
>> straight away but remains on the queue for some time. Consequently, 
>> subsequent Ctrl+Z events result in echoing another ^Z to the terminal 
>> but everything related to sending a signal is skipped (and rightly so) 
>> because the kernel detects that a SIGTSTP is still pending. 
>> Eventually, get_signal_to_deliver() dequeues the SIGTSTP signal and 
>> the shell propt appears.
>> 
>> My question is this: Even under high disk I/O pressure, the threads 
>> dealing with I/O to the terminal evidently still get their turn as 
>> indicated by the sequence of ^Z appearing on screen. Why is it then, 
>> that the threads which are meant to process the SIGTSTP or SIGINT 
>> signals aren't scheduled for some seconds and is there a way to change 
>> this?
>> 
>> Please let me know if there is anything I can try to investigate this 
>> any further or if you need further information.
>> 
>> Thanks in advance,
>> 
>> Elias
>> 
>> [1] http://lkml.org/lkml/2008/6/28/50
>
> hm, kick_process() is a no-op on !SMP.
>
> Basically, when a new signal is queued and a task is already running, it 
> will run in due course and process the signal the moment it's scheduled 
> again. (unless the signal is blocked)
>
> If a task is not already running, then the signal code will wake up the 
> task and it will then process the signal the moment it's executed.
>
> The maximum latency of a runnable task hitting the CPU is controlled via 
> /proc/sys/kernel/sched_latency [available if CONFIG_SCHED_DEBUG=y in the 
> .config] - 20 milliseconds on uniprocessors.
>
> Several seconds of lag is almost out of question and would indicate a 
> serious scheduler bug, or - which is far more likely - either an 
> application signal processing hickup or a kernel signal processing 
> hickup.

I feel quite certain that the kernel is the part to blame, one way or
another.

>
> If the lag happens with the task you can observe its worst-case
> scheduling delay by looking at /proc/<PID>/sched, if you also have 
> CONFIG_SCHEDSTAT=y in your .config.

Nothing suspicious regarding the applications involved here. The only
threads with se.max_wait values between, say, 50 msecs and 190 msecs are
things like ksoftirqd/0, udevd and the likes.

[...]
> That's 3.3 msecs _worst case_, on a system that has otherwise quite 
> insane load:
>
>  10:53:57 up  2:48,  2 users,  load average: 77.56, 94.33, 102.75

Very impressive. I don't think I have ever observed the tenth part of
that load on my system.

>
> So several seconds of delay, if it came from the scheduler, would be
> really anomalous.

With the patch below applied to next-20080708, I can quite easily
produce the following:

denkblock:/mnt# fg
find / > /dev/null
^Z[  421.968364] complete_signal(): sig = 20.
^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z^Z[  423.224898] get_signal_to_deliver(): signr = 20.

[4]+  Stopped                 find / > /dev/null
denkblock:/mnt#

That's about 1.26 msecs, not quite the worst case yet, but still
absurdly long by my reckoning given that the system does still respond
to keyboard events.

>
> As a final measure, instead of printk's, you could try the scheduler
> tracer in linux-next (CONFIG_CONTEXT_SWITCH_TRACER=y), to have an exact 
> idea about what is going on and when. (see /debug/tracing/README)
>
> [ You might also want to try CONFIG_FTRACE=y and CONFIG_DYNAMIC_FTRACE=y
>   for extremely finegrained kernel tracing - available in linux-next 
>   too. ]

Well, I've generated a trace using sched_switch. Right now, I can't make
head or tail of it and it's a ridiculous amount of data. If you'd like
to have a look at it, I can put it online somewhere. Alternatively, you
could give me a hint as to how I can read it or what I can do to
generate / filter / process the relevant data.

Thanks,

Elias

--------
diff --git a/kernel/signal.c b/kernel/signal.c
index 6c0958e..8ae57f8 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -721,11 +721,18 @@ static inline int wants_signal(int sig, struct task_struct *p)
 	return task_curr(p) || !signal_pending(p);
 }
 
+static inline void print_sig(const char *msg, int sig)
+{
+	if (sig == SIGTSTP || sig == SIGINT)
+		printk(msg, sig);
+}
+
 static void complete_signal(int sig, struct task_struct *p, int group)
 {
 	struct signal_struct *signal = p->signal;
 	struct task_struct *t;
 
+	print_sig("complete_signal(): sig = %d.\n", sig);
 	/*
 	 * Now find a thread we can wake up to take the signal off the queue.
 	 *
@@ -1778,6 +1785,7 @@ relock:
 			break; /* will return 0 */
 
 		if (signr != SIGKILL) {
+			print_sig("get_signal_to_deliver(): signr = %d.\n", signr);
 			signr = ptrace_signal(signr, info, regs, cookie);
 			if (!signr)
 				continue;
