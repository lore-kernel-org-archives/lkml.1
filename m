Return-Path: <linux-kernel-owner+w=401wt.eu-S1760789AbYBKWLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760789AbYBKWLY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 17:11:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757588AbYBKWLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 17:11:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35482 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757504AbYBKWLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 17:11:08 -0500
Date: Mon, 11 Feb 2008 23:10:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alessandro Suardi <alessandro.suardi@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: 2.6.24-git2: Oracle 11g VKTM process enters R state on startup
	and is unkillable [still broken in 2.6.25-rc1]
Message-ID: <20080211221034.GA2587@elte.hu>
References: <5a4c581d0802110820l1fcbb1ffib874f268b4ab7eae@mail.gmail.com> <200802112009.31018.rjw@sisk.pl> <alpine.LFD.1.00.0802111131310.2920@woody.linux-foundation.org> <200802112056.17839.rjw@sisk.pl> <20080211204921.GA24806@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080211204921.GA24806@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> no, they were not lost, they just didnt pass QA here (they crashed on 
> a particularly hard to debug 8-way box i have) and Peter worked on 
> that queue of fixes up until today to get it really correct. Could you 
> check:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git
> 
> combo patch below as well - whichever you prefer. The shortlog can be 
> found below as well - but i dont yet consider this pullable, i'd like 
> it to see pass a full night of randconfig tests on my test-systems.

ok, we just found the reason for the 8-way crash, the delta fix from 
Peter is below if any of you have tried the previous combo patch. 
Updated sched.git as well, new HEAD is 
fec13e45305d69fd0bd23b30bd05a0a42cf341f8.

	Ingo

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -219,6 +219,10 @@ static void start_rt_bandwidth(struct rt
 	if (rt_b->rt_runtime == RUNTIME_INF)
 		return;
 
+	if (hrtimer_active(&rt_b->rt_period_timer))
+		return;
+
+	spin_lock(&rt_b->rt_runtime_lock);
 	for (;;) {
 		if (hrtimer_active(&rt_b->rt_period_timer))
 			break;
@@ -229,6 +233,7 @@ static void start_rt_bandwidth(struct rt
 			      rt_b->rt_period_timer.expires,
 			      HRTIMER_MODE_ABS);
 	}
+	spin_unlock(&rt_b->rt_runtime_lock);
 }
 
 #ifdef CONFIG_RT_GROUP_SCHED
