Return-Path: <linux-kernel-owner+w=401wt.eu-S1757252AbXJBMQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252AbXJBMQX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 08:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbXJBMQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 08:16:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41250 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170AbXJBMQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 08:16:15 -0400
Date: Tue, 2 Oct 2007 14:15:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: Re: Linux 2.6.23-rc9 and a heads-up for the 2.6.24 series..
Message-ID: <20071002121556.GA22864@elte.hu>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org> <1191326858.28962.8.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1191326858.28962.8.camel@localhost>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Mel Gorman <mel@csn.ul.ie> wrote:

> Dirt. Booting with "profile=sleep,2" is broken in 2.6.23-rc9 and 
> 2.6.23-rc8 but working in 2.6.22. I was checking it out as part of a 
> discussion in another thread and noticed it broken in -mm as well 
> (2.6.23-rc8-mm2). Bisect is in progress but suggestions as to the 
> prime candidates are welcome or preferably, pointing out that I'm an 
> idiot because I missed twiddling some config change.

Mel, does the patch below fix this bug for you? (Note: you will need to 
enable CONFIG_SCHEDSTATS=y too.)

if yes, then Linus please pull this single fix from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git

  | Ingo Molnar (1):
  |      sched: fix profile=sleep
  |
  |  sched_fair.c |   10 ++++++++++
  |  1 file changed, 10 insertions(+)

risk is low: the new code only runs with CONFIG_SCHEDSTATS=y 
(default:off) and profile=sleep (default:off), so it ought to be fairly 
safe to add at this point. (and we had very similar code in v2.6.22 
anyway)

	Ingo

------------------------->
Subject: sched: fix profile=sleep
From: Ingo Molnar <mingo@elte.hu>

fix sleep profiling - we lost this chunk in the CFS merge.

Found-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: linux/kernel/sched_fair.c
===================================================================
--- linux.orig/kernel/sched_fair.c
+++ linux/kernel/sched_fair.c
@@ -639,6 +639,16 @@ static void enqueue_sleeper(struct cfs_r
 
 		se->block_start = 0;
 		se->sum_sleep_runtime += delta;
+
+		/*
+		 * Blocking time is in units of nanosecs, so shift by 20 to
+		 * get a milliseconds-range estimation of the amount of
+		 * time that the task spent sleeping:
+		 */
+		if (unlikely(prof_on == SLEEP_PROFILING)) {
+			profile_hits(SLEEP_PROFILING, (void *)get_wchan(tsk),
+				     delta >> 20);
+		}
 	}
 #endif
 }
