Return-Path: <linux-kernel-owner+w=401wt.eu-S1752238AbYJaNDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbYJaNDx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 09:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbYJaNDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 09:03:44 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55362 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751302AbYJaNDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 09:03:44 -0400
Date: Fri, 31 Oct 2008 08:03:41 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] small optimization to update_curr_rt
Message-ID: <20081031130341.GA12018@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A very minor improvement, but might it be better to check sched_rt_runtime(rt_rq)
before taking the rt_runtime_lock?

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>

--

 kernel/sched_rt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/kernel/sched_rt.c
===================================================================
--- linux.orig/kernel/sched_rt.c	2008-10-22 16:10:03.000000000 -0500
+++ linux/kernel/sched_rt.c	2008-10-31 07:57:19.000000000 -0500
@@ -537,13 +537,13 @@ static void update_curr_rt(struct rq *rq
 	for_each_sched_rt_entity(rt_se) {
 		rt_rq = rt_rq_of_se(rt_se);
 
-		spin_lock(&rt_rq->rt_runtime_lock);
 		if (sched_rt_runtime(rt_rq) != RUNTIME_INF) {
+			spin_lock(&rt_rq->rt_runtime_lock);
 			rt_rq->rt_time += delta_exec;
 			if (sched_rt_runtime_exceeded(rt_rq))
 				resched_task(curr);
+			spin_unlock(&rt_rq->rt_runtime_lock);
 		}
-		spin_unlock(&rt_rq->rt_runtime_lock);
 	}
 }
 
