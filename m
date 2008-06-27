Return-Path: <linux-kernel-owner+w=401wt.eu-S1757846AbYF0MFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757846AbYF0MFK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:05:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757101AbYF0L6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 07:58:15 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:7218 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754652AbYF0L5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 07:57:54 -0400
Message-Id: <20080627115212.100333545@chello.nl>
References: <20080627114109.724249622@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 13:41:32 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 23/30] sched: optimize effective_load()
Content-Disposition: inline; filename=sched-simplyfy-effective-load.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s_i = S * rw_i / \Sum_j rw_j

 -> \Sum_j rw_j = S * rw_i / s_i

 -> s'_i = S * (rw_i + w) / (\Sum_j rw_j + w)

delta s = s' - s = S * (rw + w) / ((S * rw / s) + w)
        = s * (S * (rw + w) / (S * rw + s * w) - 1)

 a = S*(rw+w), b = S*rw + s*w

delta s = s * (a-b) / b

IOW, trade one divide for two multiplies

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_fair.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1079,16 +1079,16 @@ static unsigned long effective_load(stru
 	for_each_sched_entity(se) {
 #define D(n) (likely(n) ? (n) : 1)
 
-		long S, Srw, rw, s, sn;
+		long S, rw, s, a, b;
 
 		S = se->my_q->tg->shares;
 		s = se->my_q->shares;
 		rw = se->my_q->load.weight;
 
-		Srw = S * rw / D(s);
-		sn = S * (rw + wl) / D(Srw + wg);
+		a = S*(rw + wl);
+		b = S*rw + s*wg;
 
-		wl = sn - s;
+		wl = s*(a-b)/D(b);
 		wg = 0;
 #undef D
 	}

-- 

