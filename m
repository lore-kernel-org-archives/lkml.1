Return-Path: <linux-kernel-owner+w=401wt.eu-S1752241AbZAZPWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbZAZPWe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 10:22:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbZAZPW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 10:22:26 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40953 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbZAZPWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 10:22:25 -0500
Date: Mon, 26 Jan 2009 16:22:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Laurent Riffard <laurent.riffard@free.fr>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: improve preempt debugging
Message-ID: <20090126152213.GI9128@elte.hu>
References: <0090126150909.GG9128@elte.hu> <20090126151521.8534.46503.stgit@nx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090126151521.8534.46503.stgit@nx>
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


* Alexey Zaytsev <alexey.zaytsev@gmail.com> wrote:

> From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
> Subject: [PATCH] Set the initial softirq preempt count to SOFTIRQ_OFFSET
> 
> Does not changes the preemption semantics, as the
> softirq's obviously can't be preempted, but fixes
> a spurious warning in sub_preempt_count, which
> happens when the preempt count is returned to
> zero, and the interrupted thread is holding the
> BKL.
> 
> Signed-off-by: Alexey Zaytsev <alexey.zaytsev@gmail.com>

applied to tip/sched/urgent, thanks Alexey.

I also re-added Nick's original patch on top of that (see it below) - this 
way we'll see whether it's all sorted out for good.

Thanks,

	Ingo

------------------>
>From ed094285f3495ad5393fc424011c926f1b6138c1 Mon Sep 17 00:00:00 2001
From: Nick Piggin <nickpiggin@yahoo.com.au>
Date: Tue, 30 Sep 2008 20:50:27 +1000
Subject: [PATCH] sched: improve preempt debugging

This patch helped me out with a problem I recently had....

Basically, when the kernel lock is held, then preempt_count underflow does not
get detected until it is released which may be a long time (and arbitrarily,
eg at different points it may be rescheduled). If the bkl is released at
schedule, the resulting output is actually fairly cryptic...

With any other lock that elevates preempt_count, it is illegal to schedule
under it (which would get found pretty quickly). bkl allows scheduling with
preempt_count elevated, which makes underflows hard to debug.

Signed-off-by: Ingo Molnar <mingo@elte.hu>

[ This is a re-try of this commit:

    7317d7b: sched: improve preempt debugging

  which was reverted in:

    01e3eb8: Revert "sched: improve preempt debugging"

  because this commit:

    d04d99d: x86: set the initial softirq preempt count to SOFTIRQ_OFFSET

  Fixes the real cause of the spurious warning. ]
---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 52bbf1c..8c2be1e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4440,7 +4440,7 @@ void __kprobes sub_preempt_count(int val)
 	/*
 	 * Underflow?
 	 */
-	if (DEBUG_LOCKS_WARN_ON(val > preempt_count()))
+       if (DEBUG_LOCKS_WARN_ON(val > preempt_count() - (!!kernel_locked())))
 		return;
 	/*
 	 * Is the spinlock portion underflowing?
