Return-Path: <linux-kernel-owner+w=401wt.eu-S1757249AbZCLSgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249AbZCLSgD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 14:36:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757278AbZCLSfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 14:35:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39182 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756825AbZCLSfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 14:35:38 -0400
Date: Thu, 12 Mar 2009 14:33:36 -0400
From: Jason Baron <jbaron@redhat.com>
To: mingo@elte.hu, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, acme@ghostprotocols.net, fweisbec@gmail.com,
       fche@redhat.com, peterz@infradead.org, compudj@krystal.dyndns.org
Subject: [Patch 1/2] tracepoints for softirq entry/exit - add
	softirq-to-name array
Message-ID: <20090312183336.GB3352@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


create a 'softirq_to_name' array, which is indexed by softirq #, so
that we can easily convert between the softirq index # and its name, in
order to get more meaningful output messages.

Signed-off-by: Jason Baron <jbaron@redhat.com>

---

 include/linux/interrupt.h |    5 +++++
 kernel/softirq.c          |    9 ++++++++-
 2 files changed, 13 insertions(+), 1 deletions(-)


diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index e7bcfd7..da82ee4 100644
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
index 40ff3cf..ba1511f 100644
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
