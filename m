Return-Path: <linux-kernel-owner+w=401wt.eu-S1753951AbZIWCD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbZIWCD6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 22:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753735AbZIWCD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 22:03:57 -0400
Received: from nschwmtas01p.mx.bigpond.com ([61.9.189.137]:57100 "EHLO
	nschwmtas01p.mx.bigpond.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753612AbZIWCD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 22:03:57 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH] sched: Make sure task has correct sched_class after policy
	change
X-Mercurial-Node: 3d53eba431b0afc691a408d46542774656899fe3
Message-Id: <3d53eba431b0afc691a4.1253671436@mudlark.pw.nest>
User-Agent: Mercurial-patchbomb/1.3
Date: Wed, 23 Sep 2009 02:03:56 -0000
From: Peter Williams <pwil3058@bigpond.net.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing <linux-kernel@vger.kernel.org>
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at nschwotgx03p.mx.bigpond.com from [124.185.86.236] using ID pwil3058@bigpond.net.au at Wed, 23 Sep 2009 02:03:58 +0000
X-RPD-ScanID: Class unknown; VirusThreatLevel unknown, RefID str=0001.0A150204.4AB9820F.001C,ss=1,fgs=0
X-SIH-MSG-ID: qhE0FNH4TECznTh522DtQVUtlUy7/yU1v8pWRYIhuRsaSFjCscTAS8y9caBH0emzgC4vY1qVPGIwY67uXYzbt9CgI7xRU4o=
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
+	if (rt_prio(prio))
+		p->sched_class = &rt_sched_class;
 	set_load_weight(p);
 }
 
