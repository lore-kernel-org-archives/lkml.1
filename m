Return-Path: <linux-kernel-owner+w=401wt.eu-S1756090AbXENPIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090AbXENPIY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 11:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754791AbXENPIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 11:08:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56558 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754776AbXENPIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 11:08:15 -0400
Date: Mon, 14 May 2007 17:08:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Hazelton <dhazelton@enter.net>
Cc: William Lee Irwin III <wli@holomorphy.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, efault@gmx.de,
       tingy@cs.umass.edu, linux-kernel@vger.kernel.org
Subject: Re: fair clock use in CFS
Message-ID: <20070514150800.GB29307@elte.hu>
References: <20070514083358.GA29775@in.ibm.com> <20070514110500.GV19966@holomorphy.com> <20070514115049.GA28721@elte.hu> <200705141031.13528.dhazelton@enter.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705141031.13528.dhazelton@enter.net>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Hazelton <dhazelton@enter.net> wrote:

> [...] In a fair scheduler I'd expect all tasks to get the exact same 
> amount of time on the processor. So if there are 10 tasks running at 
> nice 0 and the current task has run for 20msecs before a new task is 
> swapped onto the CPU, the new task and *all* other tasks waiting to 
> get onto the CPU should get the same 20msecs. [...]

What happens in CFS is that in exchange for this task's 20 msecs the 
other tasks get 2 msecs each. (and not only the one that gets on the CPU 
next) So each task is handled equal. What i described was the first step 
- for each task the same step happens (whenever it gets on the CPU, and 
accounted/weighted for the precise period they spent waiting - so the 
second task would get +4 msecs credited, the third task +6 msecs, etc., 
etc.).

but really - nothing beats first-hand experience: please just boot into 
a CFS kernel and test its precision a bit. You can pick it up from the 
usual place:

   http://people.redhat.com/mingo/cfs-scheduler/

For example start 10 CPU hogs at once from a shell:

   for (( N=0; N < 10; N++ )); do ( while :; do :; done ) & done

[ type 'killall bash' in the same shell to get rid of them. ]

then watch their CPU usage via 'top'. While the system is otherwise idle 
you should get something like this after half a minute of runtime:

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 2689 mingo     20   0  5968  560  276 R 10.0  0.1   0:03.45 bash
 2692 mingo     20   0  5968  564  280 R 10.0  0.1   0:03.45 bash
 2693 mingo     20   0  5968  564  280 R 10.0  0.1   0:03.45 bash
 2694 mingo     20   0  5968  564  280 R 10.0  0.1   0:03.45 bash
 2695 mingo     20   0  5968  564  280 R 10.0  0.1   0:03.45 bash
 2698 mingo     20   0  5968  564  280 R 10.0  0.1   0:03.45 bash
 2690 mingo     20   0  5968  564  280 R  9.9  0.1   0:03.45 bash
 2691 mingo     20   0  5968  564  280 R  9.9  0.1   0:03.45 bash
 2696 mingo     20   0  5968  564  280 R  9.9  0.1   0:03.45 bash
 2697 mingo     20   0  5968  564  280 R  9.9  0.1   0:03.45 bash

with each task having exactly the same 'TIME+' field in top. (the more 
equal those fields, the more precise/fair the scheduler is. In the above 
output each got its precise share of 3.45 seconds of CPU time.)

then as a next phase of testing please run various things on the system 
(without stopping these loops) and try to get CFS "out of balance" - 
you'll succeed if you manage to get an unequal 'TIME+' field for them. 
Please try _really_ hard to break it. You can run any workload.

Or try massive_intr.c from:

   http://lkml.org/lkml/2007/3/26/319

which uses a much less trivial scheduling pattern to test a scheduler's 
precision of scheduling)

 $ ./massive_intr 9 10
 002765  00000125
 002767  00000125
 002762  00000125
 002769  00000125
 002768  00000126
 002761  00000126
 002763  00000126
 002766  00000126
 002764  00000126

(the second column is runtime - the more equal, the more precise/fair 
the scheduler.)

	Ingo
