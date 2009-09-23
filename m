Return-Path: <linux-kernel-owner+w=401wt.eu-S1751731AbZIWEyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731AbZIWEyt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 00:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751426AbZIWEys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 00:54:48 -0400
Received: from nskntqsrv03p.mx.bigpond.com ([61.9.168.237]:17740 "EHLO
	nskntqsrv03p.mx.bigpond.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750861AbZIWEys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 00:54:48 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH] sched: Make sure task has correct sched_class after policy
	change
X-Mercurial-Node: e286470be617e07797b7f45d4b4099ae39cf6641
Message-Id: <e286470be617e07797b7.1253672517@mudlark.pw.nest>
User-Agent: Mercurial-patchbomb/1.3
Date: Wed, 23 Sep 2009 02:21:57 -0000
From: Peter Williams <pwil3058@bigpond.net.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing <linux-kernel@vger.kernel.org>
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at nskntotgx01p.mx.bigpond.com from [124.185.86.236] using ID pwil3058@bigpond.net.au at Wed, 23 Sep 2009 02:21:58 +0000
X-RPD-ScanID: Class unknown; VirusThreatLevel unknown, RefID str=0001.0A150203.4AB98647.006A,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From the code in rt_mutex_setprio(), it is evident that the intention
is that task's with a RT 'prio' value as a consequence of receiving a PI
boost also have their 'sched_class' field set to '&rt_sched_class'.
However, the code in __setscheduler() could result in this intention
being frustrated.

This patch fixes this problem.

Signed-off-by: Peter Williams <pwil3058@bigpond.net.au>

diff --git a/kernel/sched.c b/kernel/sched.c
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6159,6 +6159,8 @@ __setscheduler(struct rq *rq, struct tas
 	p->normal_prio = normal_prio(p);
 	/* we are holding p->pi_lock already */
 	p->prio = rt_mutex_getprio(p);
+	if (rt_prio(p->prio))
+		p->sched_class = &rt_sched_class;
 	set_load_weight(p);
 }
 
