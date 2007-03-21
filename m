Return-Path: <linux-kernel-owner+w=401wt.eu-S1752301AbXCUO6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301AbXCUO6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 10:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752281AbXCUO6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 10:58:00 -0400
Received: from mail.gmx.net ([213.165.64.20]:35551 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752036AbXCUO57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 10:57:59 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19k1WpvGPRkuZVqEyQDIaPGUvYcRJfD/5QTpErMol
	ScigTVzpoA0qGj
Subject: Re: RSDL v0.31
From: Mike Galbraith <efault@gmx.de>
To: Willy Tarreau <w@1wt.eu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Xavier Bestel <xavier.bestel@free.fr>, Mark Lord <lkml@rtr.ca>,
       Al Boldi <a1426z@gawab.com>, Con Kolivas <kernel@kolivas.org>,
       ck@vds.kolivas.org, Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Nicholas Miell <nmiell@comcast.net>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1174377787.9756.21.camel@Homer.simpson.net>
References: <200703042335.26785.a1426z@gawab.com>
	 <200703172048.46267.kernel@kolivas.org>
	 <1174125534.7734.2.camel@Homer.simpson.net>
	 <200703172355.30989.a1426z@gawab.com> <45FEB54A.3040602@rtr.ca>
	 <1174321617.30876.69.camel@frg-rhel40-em64t-04> <45FEBBF5.9060002@rtr.ca>
	 <1174322580.30876.72.camel@frg-rhel40-em64t-04>
	 <Pine.LNX.4.64.0703192006130.6730@woody.linux-foundation.org>
	 <20070320061152.GW943@1wt.eu>  <1174377787.9756.21.camel@Homer.simpson.net>
Content-Type: text/plain
Date: Wed, 21 Mar 2007 15:57:44 +0100
Message-Id: <1174489064.5379.42.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-20 at 09:03 +0100, Mike Galbraith wrote:

> Moving right along to the bugs part, I hope others are looking as well,
> and not only talking.
> 
> One area that looks pretty fishy to me is cross-cpu wakeups and task
> migration.  p->rotation appears to lose all meaning when you cross the
> cpu boundary, and try_to_wake_up()is using that information in the
> cross-cpu case.  In pull_task() OTOH, it checks to see if the task ran
> on the remote cpu (at all, hmm), and if so tags the task accordingly.

Doing the same in try_to_wake_up()delivered a counter intuitive result.
I expected sleeping tasks to suffer a bit, because when a task wakes up
on a different cpu, the chance of it being in the same rotation is
practically nil, so it would be issued a new quota when it hit
recalc_task_prio() and begin a new walk down the stairs.  In the case
where it's is told that the awakening task is running in the same
rotation (as is done in pull_task, and with the patchlet below), since
p->array isn't NULLed any more when the task is dequeued, there would be
an array (last it was queued in), there's going to be time_slice (see no
way 0 time_slice can happen, and nothing good would happen in
task_running_tick() if it could), and since per instrumentation nobody
is ever overrunning runqueue quota, it should just continue to march
down the stairs, and receive less bandwidth than the full restart.

What happened is below.

'f' is a progglet which sleeps a bit and burns a bit, duration depending
on argument given. 'sh' is a shell 100% hog.  In this scenario, the
argument was set such that 'f' used right at 50% cpu.  All are started
at the same time, and I froze top when the first 'f' reached 1:00.

virgin 2.6.21-rc3-rsdl-smp
top - 13:52:50 up 7 min, 12 users,  load average: 3.45, 2.89, 1.51

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND
 6560 root      31   0  2892 1236 1032 R   82  0.1   1:50.24 1 sh
 6558 root      28   0  1428  276  228 S   42  0.0   1:00.09 1 f
 6557 root      30   0  1424  280  228 R   35  0.0   1:00.25 0 f
 6559 root      39   0  1424  276  228 R   33  0.0   0:58.36 0 f
 6420 root      23   0  2372 1068  764 R    3  0.1   0:04.68 0 top

patched as below 2.6.21-rc3-rsdl-smp
top - 14:09:28 up 6 min, 12 users,  load average: 3.52, 2.70, 1.29

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND
 6517 root      38   0  2892 1240 1032 R   59  0.1   1:31.12 1 sh
 6515 root      24   0  1424  280  228 R   51  0.0   1:00.10 0 f
 6514 root      37   0  1428  280  228 R   42  0.0   1:00.58 1 f
 6516 root      24   0  1428  280  228 R   41  0.0   1:00.01 0 f
 6430 root      23   0  2372 1056  764 R    2  0.1   0:05.53 0 top

--- kernel/sched.c.org	2007-03-15 07:04:51.000000000 +0100
+++ kernel/sched.c	2007-03-21 13:55:22.000000000 +0100
@@ -1416,7 +1416,8 @@ static int try_to_wake_up(struct task_st
 	if (cpu == this_cpu) {
 		schedstat_inc(rq, ttwu_local);
 		goto out_set_cpu;
-	}
+	} else if (p->rotation == cpu_rq(cpu)->prio_rotation)
+		p->rotation = cpu_rq(this_cpu)->prio_rotation;
 
 	for_each_domain(this_cpu, sd) {
 		if (cpu_isset(cpu, sd->span)) {

Same test with virgin 2.6.20.3-smp for reference.
top - 14:46:10 up 18 min, 12 users,  load average: 3.70, 1.89, 1.07

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND
 6529 root      15   0  1424  280  228 S   54  0.0   1:00.26 1 f
 6530 root      15   0  1428  280  228 R   50  0.0   0:59.03 0 f
 6531 root      15   0  1424  280  228 R   48  0.0   0:59.29 1 f
 6532 root      25   0  2892 1240 1032 R   40  0.1   1:00.54 0 sh
 6457 root      15   0  2380 1056  764 R    1  0.1   0:02.34 1 top

I was more than a bit surprised that mainline did this well, considering
that the proggy was one someone posted long time ago to demonstrate
starvation issues with the interactivity estimator.  (source not
available unfortunately, was apparently still on my old PIII box along
with the one Willy posted when I installed opensuse 10.2 on it.  damn.
trivial thing though)

	-Mike

