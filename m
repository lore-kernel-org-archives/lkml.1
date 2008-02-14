Return-Path: <linux-kernel-owner+w=401wt.eu-S1760156AbYBNLVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760156AbYBNLVM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 06:21:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753495AbYBNLVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 06:21:00 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:35486 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbYBNLU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 06:20:59 -0500
Subject: Re: Regression in latest sched-git
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>
In-Reply-To: <20080212185355.GA6320@linux.vnet.ibm.com>
References: <20080212185355.GA6320@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Thu, 14 Feb 2008 12:20:41 +0100
Message-Id: <1202988041.6297.6.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dhaval,

How does this patch (on top of todays sched-devel.git) work for you?

It keeps my laptop nice and spiffy when I run

let i=0; while [ $i -lt 100 ]; do let i+=1; while :; do :; done & done

under a third user (nobody). This generates huge latencies for the nobody 
user (up to 1.6s) but root and peter don't seem to get above 40ms

---
 include/linux/sched.h |    1 +
 kernel/sched_fair.c   |    6 +++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -925,6 +925,7 @@ struct sched_entity {
 	u64			exec_start;
 	u64			sum_exec_runtime;
 	u64			vruntime;
+	u64			vperiod;
 	u64			prev_sum_exec_runtime;
 
 #ifdef CONFIG_SCHEDSTATS
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -220,9 +220,11 @@ static inline u64 min_vruntime(u64 min_v
 
 static inline s64 entity_key(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	return se->vruntime - cfs_rq->min_vruntime;
+	return se->vruntime + se->vperiod - cfs_rq->min_vruntime;
 }
 
+static u64 sched_vslice_add(struct cfs_rq *cfs_rq, struct sched_entity *se);
+
 /*
  * Enqueue an entity into the rb-tree:
  */
@@ -240,6 +242,8 @@ static void __enqueue_entity(struct cfs_
 	if (se == cfs_rq->curr)
 		return;
 
+	se->vperiod = sched_vslice_add(cfs_rq, se);
+
 	cfs_rq = &rq_of(cfs_rq)->cfs;
 
 	link = &cfs_rq->tasks_timeline.rb_node;


