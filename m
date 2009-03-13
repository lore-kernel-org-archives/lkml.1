Return-Path: <linux-kernel-owner+w=401wt.eu-S1758879AbZCMCoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758879AbZCMCoh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 22:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753755AbZCMCim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 22:38:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:43780 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758542AbZCMCia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 22:38:30 -0400
Message-Id: <20090313023827.379165780@goodmis.org>
References: <20090313023704.971438367@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 12 Mar 2009 22:37:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 12/16] tracing: tracepoints for softirq entry/exit - add softirq-to-name array
Content-Disposition: inline; filename=0012-tracing-tracepoints-for-softirq-entry-exit-add-so.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

Create a 'softirq_to_name' array, which is indexed by softirq #, so
that we can easily convert between the softirq index # and its name, in
order to get more meaningful output messages.

LKML-Reference: <20090312183336.GB3352@redhat.com>
Signed-off-by: Jason Baron <jbaron@redhat.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/interrupt.h |    5 +++++
 kernel/softirq.c          |    9 ++++++++-
 2 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 472f117..9b7e9d7 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -258,6 +258,11 @@ enum
 	NR_SOFTIRQS
 };
 
+/* map softirq index to softirq name. update 'softirq_to_name' in
+ * kernel/softirq.c when adding a new softirq.
+ */
+extern char *softirq_to_name[NR_SOFTIRQS];
+
 /* softirq mask and active fields moved to irq_cpustat_t in
  * asm/hardirq.h to get better cache usage.  KAO
  */
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 7571bcb..9f90fdc 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -53,6 +53,12 @@ static struct softirq_action softirq_vec[NR_SOFTIRQS] __cacheline_aligned_in_smp
 
 static DEFINE_PER_CPU(struct task_struct *, ksoftirqd);
 
+char *softirq_to_name[NR_SOFTIRQS] = {
+	"HI_SOFTIRQ", "TIMER_SOFTIRQ", "NET_TX_SOFTIRQ", "NET_RX_SOFTIRQ",
+	"BLOCK_SOFTIRQ", "TASKLET_SOFTIRQ", "SCHED_SOFTIRQ", "HRTIMER_SOFTIRQ",
+	"RCU_SOFTIRQ"
+};
+
 /*
  * we cannot loop indefinitely here to avoid userspace starvation,
  * but we also don't want to introduce a worst case 1/HZ latency
@@ -209,9 +215,10 @@ restart:
 			h->action(h);
 
 			if (unlikely(prev_count != preempt_count())) {
-				printk(KERN_ERR "huh, entered softirq %td %p"
+				printk(KERN_ERR "huh, entered softirq %td %s %p"
 				       "with preempt_count %08x,"
 				       " exited with %08x?\n", h - softirq_vec,
+				       softirq_to_name[h - softirq_vec],
 				       h->action, prev_count, preempt_count());
 				preempt_count() = prev_count;
 			}
-- 
1.6.1.3

-- 
