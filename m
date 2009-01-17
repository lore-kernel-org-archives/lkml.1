Return-Path: <linux-kernel-owner+w=401wt.eu-S1761367AbZAQMAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761367AbZAQMAg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 07:00:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756434AbZAQMAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 07:00:25 -0500
Received: from casper.infradead.org ([85.118.1.10]:44876 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756247AbZAQMAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 07:00:24 -0500
Subject: Re: [git pull] scheduler fixes
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1232188484.6813.85.camel@marge.simson.net>
References: <20090111144305.GA7154@elte.hu>
	 <20090114121521.197dfc5e.akpm@linux-foundation.org>
	 <1231964647.14825.59.camel@laptop>
	 <20090116204049.f4d6ef1c.akpm@linux-foundation.org>
	 <1232173776.7073.21.camel@marge.simson.net>
	 <1232186054.6813.48.camel@marge.simson.net>
	 <1232186877.14073.59.camel@laptop>
	 <1232188484.6813.85.camel@marge.simson.net>
Content-Type: text/plain
Date: Sat, 17 Jan 2009 13:00:17 +0100
Message-Id: <1232193617.14073.67.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-17 at 11:34 +0100, Mike Galbraith wrote:
> > Right, how about we flip the 'initial' case in place_entity() for !
> > nr_exclusive wakeups.
> 
> Wouldn't that be more drastic than sleep denial?

Strictly speaking that DEBIT thing is valid for each wakeup, IIRC we
restricted it to clone() only because that was where we could actually
observe these latency spikes using a fork-bomb.

This reduces the latency hits to around 400ms, which is about right for
the given load.

---
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index f34cf42..d344605 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -671,7 +671,8 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 	 * little, place the new task so that it fits in the slot that
 	 * stays open at the end.
 	 */
-	if (initial && sched_feat(START_DEBIT))
+	if ((initial && sched_feat(START_DEBIT)) ||
+			(!initial && sched_feat(WAKER_DEBIT)))
 		vruntime += sched_vslice(cfs_rq, se);
 
 	if (!initial) {
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index 4569bfa..b5fddf0 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -1,4 +1,4 @@
-SCHED_FEAT(NEW_FAIR_SLEEPERS, 1)
+SCHED_FEAT(NEW_FAIR_SLEEPERS, 0)
 SCHED_FEAT(NORMALIZED_SLEEPER, 0)
 SCHED_FEAT(ADAPTIVE_GRAN, 1)
 SCHED_FEAT(WAKEUP_PREEMPT, 1)
@@ -15,3 +15,4 @@ SCHED_FEAT(ASYM_EFF_LOAD, 1)
 SCHED_FEAT(WAKEUP_OVERLAP, 0)
 SCHED_FEAT(LAST_BUDDY, 1)
 SCHED_FEAT(OWNER_SPIN, 1)
+SCHED_FEAT(WAKER_DEBIT, 1)


