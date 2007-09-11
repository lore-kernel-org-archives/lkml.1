Return-Path: <linux-kernel-owner+w=401wt.eu-S1763496AbXIKL2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763496AbXIKL2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 07:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755355AbXIKL2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 07:28:40 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:3693 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762036AbXIKL2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 07:28:39 -0400
Date: Tue, 11 Sep 2007 13:28:41 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Mike Galbraith <efault@gmx.de>
cc: Ingo Molnar <mingo@elte.hu>, Daniel Walker <dwalker@mvista.com>,
       linux-kernel@vger.kernel.org, peterz@infradead.org
Subject: Re: [ANNOUNCE/RFC] Really Fair Scheduler
In-Reply-To: <1189491525.6536.19.camel@Homer.simpson.net>
Message-ID: <Pine.LNX.4.64.0709111317070.1817@scrub.home>
References: <Pine.LNX.4.64.0708310139280.1817@scrub.home> 
 <1188694367.11196.42.camel@dhcp193.mvista.com>  <20070902072029.GA24427@elte.hu>
  <Pine.LNX.4.64.0709071634450.1817@scrub.home>  <1189238208.6575.54.camel@Homer.simpson.net>
  <Pine.LNX.4.64.0709102338170.1817@scrub.home> <1189491525.6536.19.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 11 Sep 2007, Mike Galbraith wrote:

> I still see the fairtest2 sleeper startup anomaly.  Sometimes it starts
> up normally, others the sleeper is a delayed.  Seems to require idle
> time to trigger worst case startup delay.
> 
> 14854 root      20   0  1568  468  384 R   52  0.0   0:07.50 1 fairtest2
> 14855 root      20   0  1568  112   28 R   45  0.0   0:00.46 1 fairtest2
> 
> Everything else still seems fine.  Boot-time warnings:
> 
> [  113.504259] audit(1189488395.753:2): audit_pid=5403 old=0 by auid=4294967295
> [  114.077979] IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
> [  116.281216] 4,f70355a0(5633,b,d1cef00): 32af5bc18d4,31b49210000,f70355a0(5633,b,d1cef00),2
> [  116.298004] WARNING: at kernel/sched_norm.c:271 verify_queue()
> [  116.312380]  [<c0105188>] show_trace_log_lvl+0x1a/0x30
> [  116.326193]  [<c0105d83>] show_trace+0x12/0x14
> [  116.339270]  [<c0105d9b>] dump_stack+0x16/0x18
> [  116.352199]  [<c011e61a>] verify_queue+0x2f8/0x3fb
> [  116.365406]  [<c011e8a3>] enqueue_entity+0x186/0x21b
> [  116.378571]  [<c0123344>] enqueue_task_fair+0x2f/0x31
> [  116.391545]  [<c011d043>] enqueue_task+0xd/0x18
> [  116.403833]  [<c011dffe>] activate_task+0x20/0x2d
> [  116.416174]  [<c0120336>] __migrate_task+0x9a/0xc4
> [  116.428490]  [<c0122d0b>] migration_thread+0x175/0x220
> [  116.441159]  [<c01393f7>] kthread+0x37/0x59
> [  116.452824]  [<c0104dd3>] kernel_thread_helper+0x7/0x14
> [  116.465582]  =======================

Damn, I forgot that tasks which are reniced or migrate to another cpu 
need some more initialization, so the small incremental patch does that.
Thanks again for testing.

bye, Roman

Index: linux-2.6/kernel/sched_norm.c
===================================================================
--- linux-2.6.orig/kernel/sched_norm.c	2007-09-11 13:15:00.000000000 +0200
+++ linux-2.6/kernel/sched_norm.c	2007-09-11 13:13:43.000000000 +0200
@@ -326,11 +326,14 @@ static void update_curr(struct cfs_rq *c
 }
 
 static void
-enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
+enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int wakeup)
 {
 	verify_queue(cfs_rq, cfs_rq->curr != se, se);
 	cfs_rq->time_avg_min = kclock_max(cfs_rq->time_avg_min, get_time_avg(cfs_rq));
-	se->time_norm = kclock_max(cfs_rq->time_avg_min - se->req_weight_inv, se->time_norm);
+	if (likely(wakeup))
+		se->time_norm = kclock_max(cfs_rq->time_avg_min - se->req_weight_inv, se->time_norm);
+	else
+		se->time_norm = cfs_rq->time_avg_min;
 
 	cfs_rq->nr_running++;
 	cfs_rq->weight_sum += 1 << se->weight_shift;
@@ -553,7 +556,7 @@ static void enqueue_task_fair(struct rq 
 		if (se->on_rq)
 			break;
 		cfs_rq = cfs_rq_of(se);
-		enqueue_entity(cfs_rq, se);
+		enqueue_entity(cfs_rq, se, wakeup);
 	}
 }
 
@@ -813,7 +816,7 @@ static void task_new_fair(struct rq *rq,
 	rq->curr->se.time_norm -= time;
 	se->time_norm = rq->curr->se.time_norm;
 
-	enqueue_entity(cfs_rq, se);
+	enqueue_entity(cfs_rq, se, 1);
 	p->se.on_rq = 1;
 
 	cfs_rq->next = se;
