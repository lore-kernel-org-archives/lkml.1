Return-Path: <linux-kernel-owner+w=401wt.eu-S1757983AbXEUHa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983AbXEUHa2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 03:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754933AbXEUHaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 03:30:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49647 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754629AbXEUHaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 03:30:19 -0400
Date: Mon, 21 May 2007 09:30:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Linux Kernel mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Scheduling tests on IPC methods, fc6, sd0.48, cfs12
Message-ID: <20070521073016.GB3915@elte.hu>
References: <464CE4AE.3030908@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464CE4AE.3030908@tmr.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Bill Davidsen <davidsen@tmr.com> wrote:

> I have posted the results of my initial testing, measuring IPC rates 
> using various schedulers under no load, limited nice load, and heavy 
> load at nice 0.
> 
> http://www.tmr.com/~davidsen/ctxbench_testing.html

nice! For this to become really representative though i'd like to ask 
for a real workload function to be used after the task gets the 
lock/message. The reason is that there is an inherent balancing conflict 
in this area: should the scheduler 'spread' tasks to other CPUs or not? 
In general, for all workloads that matter, the answer is almost always: 
'yes, it should'.

But in your ctxbench results the work a task performs after doing IPC is 
not reflected (the benchmark goes about to do the next IPC - hence 
penalizing scheduling strategies that move tasks to other CPUs) - hence 
the bonus of a scheduler properly spreading out tasks is not measured 
fairly. A real-life IPC workload is rarely just about messaging around 
(a single task could do that itself) - some real workload function is 
used. You can see this effect yourself: do a "taskset -p 01 $$" before 
running ctxbench and you'll see the numbers improve significantly on all 
of the schedulers.

As a solution i'd suggest to add a workload function with a 100 or 200 
usecs (or larger) cost (as a fixed-length loop or something like that) 
so that the 'spreading' effect/benefit gets measured fairly too.

	Ingo
