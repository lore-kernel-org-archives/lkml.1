Return-Path: <linux-kernel-owner+w=401wt.eu-S1755015AbXEBLAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015AbXEBLAH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 07:00:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993044AbXEBLAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 07:00:07 -0400
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:35578 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755018AbXEBLAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 07:00:04 -0400
Message-ID: <46386F2B.9050307@linux.vnet.ibm.com>
Date: Wed, 02 May 2007 16:29:55 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v8
References: <20070501212223.GA29867@elte.hu> <463854F3.3020403@linux.vnet.ibm.com> <20070502100545.GA6857@elte.hu>
In-Reply-To: <20070502100545.GA6857@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> With -v7 I would run the n/n+1 test. Basically on a system with n 
>> cpus, I would run n+1 tasks and see how their load is distributed. I 
>> usually find that the last two tasks would get stuck on one CPU on the 
>> system and would get half the cpu time as their other peers. I think 
>> this issue has been around for long even before CFS. But while I was 
>> investigating that, I found that with -v8, all the n+1 tasks are stuck 
>> on the same cpu.
> 
> i believe this problem is specific to powerpc - load is distributed fine 
> on i686/x86_64 and your sched_debug shows a cpu_load[0] == 0 on CPU#2 
> which is 'impossible'. (I sent a few suggestions off-Cc about how to 
> debug this.)
> 
> 	Ingo

Hi, Ingo

The suggestions helped, here is a fix tested on PowerPC only.

Patch and Description
=====================


Load balancing on PowerPC is broken. Running 5 tasks on a 4 cpu system
results in all 5 tasks running on the same CPU. Based on Ingo's feedback,
I instrumented and debugged update_load_fair().

The problem is with comparing a s64 values with (s64)ULONG_MAX, which
evaluates to -1. Then we check if exec_delta64 and fair_delta64 are greater
than (s64)ULONG_MAX (-1), if so we assign (s64)ULONG_MAX to the respective
values.

The fix is to compare these values against (s64)LONG_MAX and assign
(s64)LONG_MAX to exec_delta64 and fair_delta64 if they are greater than
(s64)LONG_MAX.

Tested on PowerPC, the regression is gone, tasks are load balanced as they
were in v7.

Output of top

  5614 root      20   0  4912  784  252 R   52  0.0   3:27.49 3 bash 

  5620 root      20   0  4912  784  252 R   47  0.0   3:07.38 2 bash 

  5617 root      20   0  4912  784  252 R   47  0.0   3:08.18 0 bash 

  5624 root      20   0  4912  784  252 R   26  0.0   1:42.97 1 bash 

  5621 root      20   0  4912  784  252 R   26  0.0   1:43.14 1 bash 


Tasks 5624 and 5621 getting half of their peer values is a separate issue
altogether.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

  kernel/sched.c |   10 +++++-----
  1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN kernel/sched.c~cfs-fix-load-balancing-arith kernel/sched.c
--- linux-2.6.21/kernel/sched.c~cfs-fix-load-balancing-arith	2007-05-02 
16:16:20.000000000 +0530
+++ linux-2.6.21-balbir/kernel/sched.c	2007-05-02 16:16:47.000000000 +0530
@@ -1533,19 +1533,19 @@ static void update_load_fair(struct rq *
  	this_rq->prev_exec_clock = this_rq->exec_clock;
  	WARN_ON_ONCE(exec_delta64 <= 0);

-	if (fair_delta64 > (s64)ULONG_MAX)
-		fair_delta64 = (s64)ULONG_MAX;
+	if (fair_delta64 > (s64)LONG_MAX)
+		fair_delta64 = (s64)LONG_MAX;
  	fair_delta = (unsigned long)fair_delta64;

-	if (exec_delta64 > (s64)ULONG_MAX)
-		exec_delta64 = (s64)ULONG_MAX;
+	if (exec_delta64 > (s64)LONG_MAX)
+		exec_delta64 = (s64)LONG_MAX;
  	exec_delta = (unsigned long)exec_delta64;
  	if (exec_delta > TICK_NSEC)
  		exec_delta = TICK_NSEC;

  	idle_delta = TICK_NSEC - exec_delta;

-	tmp = SCHED_LOAD_SCALE * exec_delta / fair_delta;
+	tmp = (SCHED_LOAD_SCALE * exec_delta) / fair_delta;
  	tmp64 = (u64)tmp * (u64)exec_delta;
  	do_div(tmp64, TICK_NSEC);
  	this_load = (unsigned long)tmp64;
_


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
