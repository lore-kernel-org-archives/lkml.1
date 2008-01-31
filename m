Return-Path: <linux-kernel-owner+w=401wt.eu-S932781AbYAaK3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781AbYAaK3r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 05:29:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762490AbYAaK3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 05:29:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40259 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762678AbYAaK3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 05:29:35 -0500
Date: Thu, 31 Jan 2008 11:29:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: 2.6.24-git4+ regression
Message-ID: <20080131102919.GC27157@elte.hu>
References: <20080130135609.GA5100@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080130135609.GA5100@ics.muni.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Lukas Hejtmanek <xhejtman@ics.muni.cz> wrote:

> I noticed short thread in LKM regarding "sched: add vslice" causes 
> horrible interactivity under load.
> 
> I can see similar behavior. If I stress both CPU cores, even typing on 
> keyboard suffers from huge latencies, I can see letters appearing with 
> delay (typing into xterm). No swap is used at all, having 1GB free 
> RAM.
> 
> I noticed this bad behavior with 2.6.24-git[46], 2.6.24-rc8-git was 
> OK.

if you apply the current sched-fixes (rollup patch below), does it get 
any better?

	Ingo

Index: linux/kernel/sched_fair.c
===================================================================
--- linux.orig/kernel/sched_fair.c
+++ linux/kernel/sched_fair.c
@@ -520,7 +520,7 @@ place_entity(struct cfs_rq *cfs_rq, stru
 
 	if (!initial) {
 		/* sleeps upto a single latency don't count. */
-		if (sched_feat(NEW_FAIR_SLEEPERS) && entity_is_task(se))
+		if (sched_feat(NEW_FAIR_SLEEPERS))
 			vruntime -= sysctl_sched_latency;
 
 		/* ensure we never gain time by being placed backwards. */
@@ -1106,7 +1106,11 @@ static void check_preempt_wakeup(struct 
 	}
 
 	gran = sysctl_sched_wakeup_granularity;
-	if (unlikely(se->load.weight != NICE_0_LOAD))
+	/*
+	 * More easily preempt - nice tasks, while not making
+	 * it harder for + nice tasks.
+	 */
+	if (unlikely(se->load.weight > NICE_0_LOAD))
 		gran = calc_delta_fair(gran, &se->load);
 
 	if (pse->vruntime + gran < se->vruntime)
