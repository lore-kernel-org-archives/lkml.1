Return-Path: <linux-kernel-owner+w=401wt.eu-S1753052AbZIMTR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052AbZIMTR5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 15:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbZIMTR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 15:17:56 -0400
Received: from mail.gmx.net ([213.165.64.20]:42000 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751930AbZIMTRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 15:17:55 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/NWJIASGTNFLGKt2HvkohJDLt/CBNd6BRHeNAHIw
	b7lT/dHQehIfcT
Subject: Re: Epic regression in throughput since v2.6.23
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20090913154744.GA27066@elte.hu>
References: <20090906205952.GA6516@elte.hu>
	 <87hbvdiogq.fsf@depni.sinp.msu.ru> <873a6xdqwq.fsf@depni.sinp.msu.ru>
	 <20090909155223.GA12065@elte.hu> <87my53vo6d.fsf@depni.sinp.msu.ru>
	 <20090910065306.GB3920@elte.hu> <87ljkm9yew.fsf@depni.sinp.msu.ru>
	 <20090911061024.GA27833@elte.hu> <87iqfmx3tr.fsf@depni.sinp.msu.ru>
	 <20090913154744.GA27066@elte.hu>
Content-Type: text/plain
Date: Sun, 13 Sep 2009 21:17:52 +0200
Message-Id: <1252869472.14621.24.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-09-13 at 17:47 +0200, Ingo Molnar wrote:
> * Serge Belyshev <belyshev@depni.sinp.msu.ru> wrote:
> 
> > Note that the disabling NEW_FAIR_SLEEPERS doesn't fix 3% 
> > regression from v2.6.23, but instead makes "make -j4" runtime 
> > another 2% worse (27.05 -> 27.72).
> 
> ok - thanks for the numbers, will have a look.

Seems NEXT_BUDDY is hurting the -j4 build.

LAST_BUDDY helps, which makes some sense.. if a task has heated up
cache, and is wakeup preempted by a fast mover (kthread, make..), it can
get the CPU back with still toasty data.  Hm.  If NEXT_BUDDY is on, that
benefit would likely be frequently destroyed too, because NEXT_BUDDY is
preferred over LAST_BUDDY.

Anyway, I'm thinking of tracking forks/sec as a means of detecting the
fork/exec load.  Or, maybe just enable it when there's > 1 buddy pair
running.. or something.  After all, NEXT_BUDDY is about scalability, and
make -j4 on a quad surely doesn't need any scalability help :)

 Performance counter stats for 'make -j4 vmlinux':

stock
  111.625198810  seconds time elapsed  avg 112.120  1.00
  112.209501685  seconds time elapsed
  112.528258240  seconds time elapsed

NO_NEXT_BUDDY NO_LAST_BUDDY
  109.405064078  seconds time elapsed  avg 109.351  .975
  108.708076118  seconds time elapsed
  109.942346026  seconds time elapsed

NO_NEXT_BUDDY
  108.005756718  seconds time elapsed  avg 108.064  .963
  107.689862679  seconds time elapsed
  108.497117555  seconds time elapsed

NO_LAST_BUDDY
  110.208717063  seconds time elapsed  avg 110.120  .982
  110.362412902  seconds time elapsed
  109.791359601  seconds time elapsed


diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index aa7f841..7cfea64 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1501,7 +1501,8 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int sync)
 	 */
 	if (sched_feat(LAST_BUDDY) && likely(se->on_rq && curr != rq->idle))
 		set_last_buddy(se);
-	set_next_buddy(pse);
+	if (sched_feat(NEXT_BUDDY))
+		set_next_buddy(pse);
 
 	/*
 	 * We can come here with TIF_NEED_RESCHED already set from new task
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index e2dc63a..6e7070b 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -13,5 +13,6 @@ SCHED_FEAT(LB_BIAS, 1)
 SCHED_FEAT(LB_WAKEUP_UPDATE, 1)
 SCHED_FEAT(ASYM_EFF_LOAD, 1)
 SCHED_FEAT(WAKEUP_OVERLAP, 0)
+SCHED_FEAT(NEXT_BUDDY, 1)
 SCHED_FEAT(LAST_BUDDY, 1)
 SCHED_FEAT(OWNER_SPIN, 1)


