Return-Path: <linux-kernel-owner+w=401wt.eu-S1755586AbXFKPoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586AbXFKPoE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 11:44:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467AbXFKPny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 11:43:54 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:36556 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426AbXFKPnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 11:43:53 -0400
Date: Mon, 11 Jun 2007 21:22:12 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, efault@gmx.de, kernel@kolivas.org,
       containers@lists.osdl.org, ckrm-tech@lists.sourceforge.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       pwil3058@bigpond.net.au, tingy@cs.umass.edu, tong.n.li@intel.com,
       wli@holomorphy.com, linux-kernel@vger.kernel.org,
       dmitry.adamushko@gmail.com, balbir@in.ibm.com
Subject: [RFC][PATCH 2/6] task's cpu information needs to be always correct
Message-ID: <20070611155212.GB2109@in.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20070611154724.GA32435@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070611154724.GA32435@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We rely very much on task_cpu(p) to be correct at all times, so that we
can correctly find the runqueue from which the task has to be removed or
added to.

There is however one place in the scheduler where this assumption of
task_cpu(p) being correct is broken. This patch fixes that piece of
code.

(Thanks to Balbir Singh for pointing this out to me)

Signed-off-by : Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>

---
 kernel/sched.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

Index: current/kernel/sched.c
===================================================================
--- current.orig/kernel/sched.c	2007-06-09 15:07:17.000000000 +0530
+++ current/kernel/sched.c	2007-06-09 15:07:32.000000000 +0530
@@ -4624,7 +4624,7 @@
 static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
 {
 	struct rq *rq_dest, *rq_src;
-	int ret = 0;
+	int ret = 0, on_rq;
 
 	if (unlikely(cpu_is_offline(dest_cpu)))
 		return ret;
@@ -4640,9 +4640,11 @@
 	if (!cpu_isset(dest_cpu, p->cpus_allowed))
 		goto out;
 
-	set_task_cpu(p, dest_cpu);
-	if (p->se.on_rq) {
+	on_rq = p->se.on_rq;
+	if (on_rq)
 		deactivate_task(rq_src, p, 0);
+	set_task_cpu(p, dest_cpu);
+	if (on_rq) {
 		activate_task(rq_dest, p, 0);
 		check_preempt_curr(rq_dest, p);
 	}
-- 
Regards,
vatsa
