Return-Path: <linux-kernel-owner+w=401wt.eu-S1753242AbYI3K6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbYI3K6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 06:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752208AbYI3K6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 06:58:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34313 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829AbYI3K6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 06:58:30 -0400
Date: Tue, 30 Sep 2008 12:58:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [rfc] "improve" preempt debugging
Message-ID: <20080930105814.GA7712@elte.hu>
References: <200809302050.27306.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809302050.27306.nickpiggin@yahoo.com.au>
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


* Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> Hi, don't know if you really like this patch or not, but it helped me 
> out with a problem I recently had....
> 
> Basically, when the kernel lock is held, then preempt_count underflow 
> does not get detected until it is released which may be a long time 
> (and arbitrarily, eg at different points it may be rescheduled). If 
> the bkl is released at schedule, the resulting output is actually 
> fairly cryptic...
> 
> With any other lock that elevates preempt_count, it is illegal to 
> schedule under it (which would get found pretty quickly). bkl allows 
> scheduling with preempt_count elevated, which makes underflows hard to 
> debug.
> 
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c       2008-09-30 11:32:56.000000000 +1000
> +++ linux-2.6/kernel/sched.c    2008-09-30 11:38:18.000000000 +1000
> @@ -4305,7 +4305,7 @@ void __kprobes sub_preempt_count(int val
>         /*
>          * Underflow?
>          */
> -       if (DEBUG_LOCKS_WARN_ON(val > preempt_count()))
> +       if (DEBUG_LOCKS_WARN_ON(val > preempt_count() - (!!kernel_locked())))
>                 return;

looks useful to me. This hardcodes a "BKL is tied to preempt-off" 
assumption but that should be OK - when get rid of the BKL by turning it 
into a plain mutex we have to remember to remove this.

applied the commit below to tip/core/locking, thanks Nick!

Peter, does it look good to you too?

	Ingo

--------------->
>From 7317d7b87edb41a9135e30be1ec3f7ef817c53dd Mon Sep 17 00:00:00 2001
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
---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 9889080..ec3bd1f 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4305,7 +4305,7 @@ void __kprobes sub_preempt_count(int val)
 	/*
 	 * Underflow?
 	 */
-	if (DEBUG_LOCKS_WARN_ON(val > preempt_count()))
+       if (DEBUG_LOCKS_WARN_ON(val > preempt_count() - (!!kernel_locked())))
 		return;
 	/*
 	 * Is the spinlock portion underflowing?
