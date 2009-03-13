Return-Path: <linux-kernel-owner+w=401wt.eu-S1753597AbZCMEDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597AbZCMEDs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 00:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbZCMEDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 00:03:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:38060 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350AbZCMEDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 00:03:37 -0400
Date: Fri, 13 Mar 2009 04:02:57 GMT
From: Jason Baron <jbaron@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       srostedt@redhat.com, jbaron@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       srostedt@redhat.com, tglx@linutronix.de, jbaron@redhat.com
In-Reply-To: <20090312183336.GB3352@redhat.com>
References: <20090312183336.GB3352@redhat.com>
Subject: [tip:tracing/ftrace] tracing: tracepoints for softirq entry/exit - add softirq-to-name array
Message-ID: <tip-5d592b44b29a1d73e13d5c9e3426eed843bdc359@git.kernel.org>
Git-Commit-ID: 5d592b44b29a1d73e13d5c9e3426eed843bdc359
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 04:02:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5d592b44b29a1d73e13d5c9e3426eed843bdc359
Gitweb:     http://git.kernel.org/tip/5d592b44b29a1d73e13d5c9e3426eed843bdc359
Author:     Jason Baron <jbaron@redhat.com>
AuthorDate: Thu, 12 Mar 2009 14:33:36 -0400
Commit:     Steven Rostedt <srostedt@redhat.com>
CommitDate: Thu, 12 Mar 2009 21:15:02 -0400

tracing: tracepoints for softirq entry/exit - add softirq-to-name array

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
