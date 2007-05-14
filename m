Return-Path: <linux-kernel-owner+w=401wt.eu-S1032864AbXENL7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032864AbXENL7Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 07:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032056AbXENLvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 07:51:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40213 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031144AbXENLvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 07:51:03 -0400
Date: Mon, 14 May 2007 13:50:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>, efault@gmx.de, tingy@cs.umass.edu,
       linux-kernel@vger.kernel.org
Subject: Re: fair clock use in CFS
Message-ID: <20070514115049.GA28721@elte.hu>
References: <20070514083358.GA29775@in.ibm.com> <20070514102929.GL31925@holomorphy.com> <20070514103120.GA23766@elte.hu> <20070514110500.GV19966@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070514110500.GV19966@holomorphy.com>
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


* William Lee Irwin III <wli@holomorphy.com> wrote:

> On Mon, May 14, 2007 at 12:31:20PM +0200, Ingo Molnar wrote:
> > please clarify - exactly what is a mistake? Thanks,
> 
> The variability in ->fair_clock advancement rate was the mistake, at 
> least according to my way of thinking. [...]

you are quite wrong. Lets consider the following example:

we have 10 tasks running (all at nice 0). The current task spends 20 
msecs on the CPU and a new task is picked. How much CPU time did that 
waiting task get entitled to during its 20 msecs wait? If fair_clock was 
constant as you suggest then we'd give it 20 msecs - but its true 'fair 
expectation' of CPU time was only 20/10 == 2 msecs!

So a 'constant' fair_clock would turn the whole equilibrium upside down 
(it would inflate p->wait_runtime values and the global sum would not be 
roughly constant anymore but would run up very fast), especially during 
fluctuating loads.

the fair_clock is the fundamental expression of "fair CPU timeline", and 
task's expected runtime is always measured by that, not by the real 
clock. The only time when we measure the true time is when a _single_ 
task runs on the CPU - but in that case the task truly spent a small 
amount of time on the CPU, exclusively. See the exec_time calculations 
in kernel/sched_fair.c.

	Ingo
