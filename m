Return-Path: <linux-kernel-owner+w=401wt.eu-S1761764AbZCPTAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761764AbZCPTAp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 15:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761536AbZCPTAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 15:00:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59452 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760515AbZCPTAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 15:00:13 -0400
Date: Mon, 16 Mar 2009 14:58:48 -0400
From: Jason Baron <jbaron@redhat.com>
To: mingo@elte.hu, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, acme@ghostprotocols.net, fweisbec@gmail.com,
       fche@redhat.com, peterz@infradead.org, compudj@krystal.dyndns.org
Subject: Re: [Patch 1/2] tracepoints for softirq entry/exit - add
	softirq-to-name array
Message-ID: <20090316185848.GA3111@redhat.com>
References: <20090312183336.GB3352@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090312183336.GB3352@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

I've update both patches to incorporate changes that were suggested - 
I've shortened the softirq string name and made it 'const'. Below is a
re-spun patch 1/2.

thanks,

-Jason


Signed-off-by: Jason Baron <jbaron@redhat.com>


---

 include/linux/interrupt.h |    6 ++++++
 kernel/softirq.c          |    8 +++++++-
 2 files changed, 13 insertions(+), 1 deletions(-)


diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index e7bcfd7..dd3ff3f 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -258,6 +258,12 @@ enum
 	NR_SOFTIRQS
 };
 
+/* map softirq index to softirq name. update 'softirq_to_name' in
+ * kernel/softirq.c when adding a new softirq.
+ */
+#define MAX_SOFTIRQ_NAME_LEN 10
+extern const char softirq_to_name[NR_SOFTIRQS][MAX_SOFTIRQ_NAME_LEN];
+
 /* softirq mask and active fields moved to irq_cpustat_t in
  * asm/hardirq.h to get better cache usage.  KAO
  */
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 40ff3cf..8f3ae57 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -53,6 +53,11 @@ static struct softirq_action softirq_vec[NR_SOFTIRQS] __cacheline_aligned_in_smp
 
 static DEFINE_PER_CPU(struct task_struct *, ksoftirqd);
 
+const char softirq_to_name[NR_SOFTIRQS][MAX_SOFTIRQ_NAME_LEN] = {
+	"HI", "TIMER", "NET_TX", "NET_RX", "BLOCK", "TASKLET", "SCHED",
+	"HRTIMER", "RCU"
+};
+
 /*
  * we cannot loop indefinitely here to avoid userspace starvation,
  * but we also don't want to introduce a worst case 1/HZ latency
@@ -209,9 +214,10 @@ restart:
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


