Return-Path: <linux-kernel-owner+w=401wt.eu-S1765519AbXFETU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765519AbXFETU4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 15:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760792AbXFETUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 15:20:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48660 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761295AbXFETUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 15:20:47 -0400
Date: Tue, 5 Jun 2007 21:20:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: Re: glitch1 results - 2.6.21.3-cfs-v15
Message-ID: <20070605192040.GA21148@elte.hu>
References: <46648A72.8010401@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46648A72.8010401@tmr.com>
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


* Bill Davidsen <davidsen@tmr.com> wrote:

> I have added cfs15 to the chart at 
> www.tmr.com/~davidsen/sched_smooth_05.html and updated the source of 
> the test at www.tmr.com/~public/source if anyone wants to run test on 
> their hardware.

thanks!

> I feel that on my hardware cfs-13 was the smoothest for this test and 
> for watching videos. Even relatively light load:
>   nice -10 make -j4 -s
> of a kernel would cause jumps on the video, gears or youtube.

ah, found this bug i think! Does the patch below fix it for you and does 
it bring back v13's smoothness for the reniced kernel build?

	Ingo

Index: linux/kernel/sched_fair.c
===================================================================
--- linux.orig/kernel/sched_fair.c
+++ linux/kernel/sched_fair.c
@@ -385,6 +374,7 @@ static void enqueue_sleeper(struct rq *r
 	 * during the whole sleep period:
 	 */
 	delta_fair = div64_s(delta_fair * load, load + p->load_weight);
+	delta_fair = div64_s(delta_fair * p->load_weight, NICE_0_LOAD);
 
 	prev_runtime = p->wait_runtime;
 	__add_wait_runtime(rq, p, delta_fair);
