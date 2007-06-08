Return-Path: <linux-kernel-owner+w=401wt.eu-S968510AbXFHKTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968510AbXFHKTT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 06:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937783AbXFHKTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 06:19:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55437 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937767AbXFHKTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 06:19:04 -0400
Date: Fri, 8 Jun 2007 12:18:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matt Mackall <mpm@selenic.com>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Interesting interaction between lguest and CFS
Message-ID: <20070608101843.GA2381@elte.hu>
References: <20070604173710.GR11166@waste.org> <20070604175436.GC30274@elte.hu> <20070604184106.GG11115@waste.org> <20070605071904.GB25163@elte.hu> <20070605140342.GR11115@waste.org> <b647ffbd0706050814u1e145b82qdb344d475d9ffe93@mail.gmail.com> <b647ffbd0706050841v2a326fb4n128249131ccbc11a@mail.gmail.com> <20070605195015.GA24348@elte.hu> <20070606202314.GH11115@waste.org> <20070608093429.GA22699@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070608093429.GA22699@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
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


* Ingo Molnar <mingo@elte.hu> wrote:

> thanks. It shows the anomaly in action:

> So all the time references we have show that (no surprise here) 1 
> second passed between the two samples. But sched_clock() shows a 
> _large_ jump:
> 
>   .clock                 : 125652924079659272
>   .clock                 : 125653018059166371
> 
> also reflected in .clock_max_delta:
> 
>   .clock_max_delta       : 92976502936
> 
> that's a 93 seconds jump (!) in a single 1-second sample. [...]

we also had a similar jump in exec_clock, which suggests that the 
sched_clock() "jump" occured while there was a task running. (i.e. not 
during ACPI-C2/C3) Could you try the patch below? It should catch such 
large jumps. The 'clock_overflows' counter in /proc/sched_debug will 
show whether this new protection triggered on your box.

	Ingo

Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -149,12 +149,12 @@ struct rq {
 
 	u64 clock, prev_clock_raw;
 	s64 clock_max_delta;
-	u64 fair_clock, prev_fair_clock;
-	u64 exec_clock, prev_exec_clock;
+	u64 fair_clock, prev_fair_clock;
+	u64 exec_clock, prev_exec_clock;
 	s64 wait_runtime;
 	unsigned long wait_runtime_overruns, wait_runtime_underruns;
 
-	unsigned int clock_warps;
+	unsigned int clock_warps, clock_overflows;
 	unsigned int clock_unstable_events;
 
 	struct sched_class *load_balance_class;
@@ -245,9 +245,17 @@ static inline unsigned long long __rq_cl
 		clock++;
 		rq->clock_warps++;
 	} else {
-		if (unlikely(delta > rq->clock_max_delta))
-			rq->clock_max_delta = delta;
-		clock += delta;
+		/*
+		 * Catch too large forward jumps too:
+		 */
+		if (delta > 2*TICK_NSEC) {
+			clock++;
+			rq->clock_overflows++;
+		} else {
+			if (unlikely(delta > rq->clock_max_delta))
+				rq->clock_max_delta = delta;
+			clock += delta;
+		}
 	}
 
 	rq->prev_clock_raw = now;
Index: linux/kernel/sched_debug.c
===================================================================
--- linux.orig/kernel/sched_debug.c
+++ linux/kernel/sched_debug.c
@@ -117,13 +119,13 @@ static void print_cpu(struct seq_file *m
 	P(clock);
 	P(prev_clock_raw);
 	P(clock_warps);
+	P(clock_overflows);
 	P(clock_unstable_events);
 	P(clock_max_delta);
-	rq->clock_max_delta = 0;
 	P(fair_clock);
-	P(prev_fair_clock);
+	P(prev_fair_clock);
 	P(exec_clock);
-	P(prev_exec_clock);
+	P(prev_exec_clock);
 	P(wait_runtime);
 	P(wait_runtime_overruns);
 	P(wait_runtime_underruns);
