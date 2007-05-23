Return-Path: <linux-kernel-owner+w=401wt.eu-S935627AbXEWRMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935627AbXEWRMK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 13:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934745AbXEWRLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 13:11:44 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:46256 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763137AbXEWRLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 13:11:43 -0400
Date: Wed, 23 May 2007 22:21:26 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, efault@gmx.de, kernel@kolivas.org,
       containers@lists.osdl.org, ckrm-tech@lists.sourceforge.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       pwil3058@bigpond.net.au, tingy@cs.umass.edu, tong.n.li@intel.com,
       wli@holomorphy.com
Subject: [RFC] [PATCH 1/3] task_cpu(p) needs to be correct always
Message-ID: <20070523165126.GB6595@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070523164859.GA6595@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070523164859.GA6595@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We rely very much on task_cpu(p) to be correct at all times, so that we can
correctly find the task_grp_rq from which the task has to be removed or added
to.

There is however one place in the scheduler where this assumption of
task_cpu(p) being correct is broken. This patch fixes that piece of code.

(Thanks to Balbir Singh for pointing this out to me)

Signed-off-by : Srivatsa Vaddagiri <vatsa@in.ibm.com>

---
 kernel/sched.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: linux-2.6.21-rc7/kernel/sched.c
===================================================================
--- linux-2.6.21-rc7.orig/kernel/sched.c	2007-05-23 20:46:41.000000000 +0530
+++ linux-2.6.21-rc7/kernel/sched.c	2007-05-23 20:48:26.000000000 +0530
@@ -4571,7 +4571,7 @@
 static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
 {
 	struct rq *rq_dest, *rq_src;
-	int ret = 0;
+	int ret = 0, on_rq;
 
 	if (unlikely(cpu_is_offline(dest_cpu)))
 		return ret;
@@ -4587,9 +4587,11 @@
 	if (!cpu_isset(dest_cpu, p->cpus_allowed))
 		goto out;
 
-	set_task_cpu(p, dest_cpu);
-	if (p->on_rq) {
+	on_rq = p->on_rq;
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
