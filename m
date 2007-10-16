Return-Path: <linux-kernel-owner+w=401wt.eu-S965624AbXJPUhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965624AbXJPUhz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 16:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760286AbXJPUho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 16:37:44 -0400
Received: from smtp-out.google.com ([216.239.45.13]:11325 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761542AbXJPUhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 16:37:43 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:mime-version:
	content-type:content-transfer-encoding:content-disposition;
	b=jWw/H2VH45Wn8101oR1nk4cPH6XTxVfymX/z4zPgQy4u95acvgn0cOxwRrlXRF4zO
	G++HDW3R7xJMhGIZKco/g==
Message-ID: <b040c32a0710161337l24d61d45h61be0ded72b54a9f@mail.gmail.com>
Date: Tue, 16 Oct 2007 13:37:40 -0700
From: "Ken Chen" <kenchen@google.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: [patch] sched: schedstat needs a diet
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

schedstat is useful in investigating CPU scheduler behavior.  Ideally,
I think it is beneficial to have it on all the time.  However, the
cost of turning it on in production system is quite high, largely due
to number of events it collects and also due to its large memory
footprint.

Most of the fields probably don't need to be full 64-bit on 64-bit
arch.  Rolling over 4 billion events will most like take a long time
and user space tool can be made to accommodate that.  I'm proposing
kernel to cut back most of variable width on 64-bit system.  (note,
the following patch doesn't affect 32-bit system).


Signed-off-by: Ken Chen <kenchen@google.com>


diff --git a/include/linux/sched.h b/include/linux/sched.h
index 592e3a5..311a8bd 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -562,7 +562,7 @@ struct sched_info {
 			   last_queued;	/* when we were last queued to run */
 #ifdef CONFIG_SCHEDSTATS
 	/* BKL stats */
-	unsigned long bkl_count;
+	unsigned int bkl_count;
 #endif
 };
 #endif /* defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT) */
@@ -698,34 +698,34 @@ struct sched_domain {

 #ifdef CONFIG_SCHEDSTATS
 	/* load_balance() stats */
-	unsigned long lb_count[CPU_MAX_IDLE_TYPES];
-	unsigned long lb_failed[CPU_MAX_IDLE_TYPES];
-	unsigned long lb_balanced[CPU_MAX_IDLE_TYPES];
-	unsigned long lb_imbalance[CPU_MAX_IDLE_TYPES];
-	unsigned long lb_gained[CPU_MAX_IDLE_TYPES];
-	unsigned long lb_hot_gained[CPU_MAX_IDLE_TYPES];
-	unsigned long lb_nobusyg[CPU_MAX_IDLE_TYPES];
-	unsigned long lb_nobusyq[CPU_MAX_IDLE_TYPES];
+	unsigned int lb_count[CPU_MAX_IDLE_TYPES];
+	unsigned int lb_failed[CPU_MAX_IDLE_TYPES];
+	unsigned int lb_balanced[CPU_MAX_IDLE_TYPES];
+	unsigned int lb_imbalance[CPU_MAX_IDLE_TYPES];
+	unsigned int lb_gained[CPU_MAX_IDLE_TYPES];
+	unsigned int lb_hot_gained[CPU_MAX_IDLE_TYPES];
+	unsigned int lb_nobusyg[CPU_MAX_IDLE_TYPES];
+	unsigned int lb_nobusyq[CPU_MAX_IDLE_TYPES];

 	/* Active load balancing */
-	unsigned long alb_count;
-	unsigned long alb_failed;
-	unsigned long alb_pushed;
+	unsigned int alb_count;
+	unsigned int alb_failed;
+	unsigned int alb_pushed;

 	/* SD_BALANCE_EXEC stats */
-	unsigned long sbe_count;
-	unsigned long sbe_balanced;
-	unsigned long sbe_pushed;
+	unsigned int sbe_count;
+	unsigned int sbe_balanced;
+	unsigned int sbe_pushed;

 	/* SD_BALANCE_FORK stats */
-	unsigned long sbf_count;
-	unsigned long sbf_balanced;
-	unsigned long sbf_pushed;
+	unsigned int sbf_count;
+	unsigned int sbf_balanced;
+	unsigned int sbf_pushed;

 	/* try_to_wake_up() stats */
-	unsigned long ttwu_wake_remote;
-	unsigned long ttwu_move_affine;
-	unsigned long ttwu_move_balance;
+	unsigned int ttwu_wake_remote;
+	unsigned int ttwu_move_affine;
+	unsigned int ttwu_move_balance;
 #endif
 };

diff --git a/kernel/sched.c b/kernel/sched.c
index 0da2b26..5e7fce9 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -328,22 +328,22 @@ struct rq {
 	struct sched_info rq_sched_info;

 	/* sys_sched_yield() stats */
-	unsigned long yld_exp_empty;
-	unsigned long yld_act_empty;
-	unsigned long yld_both_empty;
-	unsigned long yld_count;
+	unsigned int yld_exp_empty;
+	unsigned int yld_act_empty;
+	unsigned int yld_both_empty;
+	unsigned int yld_count;

 	/* schedule() stats */
-	unsigned long sched_switch;
-	unsigned long sched_count;
-	unsigned long sched_goidle;
+	unsigned int sched_switch;
+	unsigned int sched_count;
+	unsigned int sched_goidle;

 	/* try_to_wake_up() stats */
-	unsigned long ttwu_count;
-	unsigned long ttwu_local;
+	unsigned int ttwu_count;
+	unsigned int ttwu_local;

 	/* BKL stats */
-	unsigned long bkl_count;
+	unsigned int bkl_count;
 #endif
 	struct lock_class_key rq_lock_key;
 };
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index a5e517e..e6fb392 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -137,7 +137,7 @@ void print_cfs_rq(struct seq_file *m, int cpu,
struct cfs_rq *cfs_rq)
 	SEQ_printf(m, "  .%-30s: %ld\n", "nr_running", cfs_rq->nr_running);
 	SEQ_printf(m, "  .%-30s: %ld\n", "load", cfs_rq->load.weight);
 #ifdef CONFIG_SCHEDSTATS
-	SEQ_printf(m, "  .%-30s: %ld\n", "bkl_count",
+	SEQ_printf(m, "  .%-30s: %d\n", "bkl_count",
 			rq->bkl_count);
 #endif
 	SEQ_printf(m, "  .%-30s: %ld\n", "nr_spread_over",
diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
index 1c08484..ef1a7df 100644
--- a/kernel/sched_stats.h
+++ b/kernel/sched_stats.h
@@ -21,7 +21,7 @@ static int show_schedstat(struct seq_file *seq, void *v)

 		/* runqueue-specific stats */
 		seq_printf(seq,
-		    "cpu%d %lu %lu %lu %lu %lu %lu %lu %lu %lu %llu %llu %lu",
+		    "cpu%d %u %u %u %u %u %u %u %u %u %llu %llu %lu",
 		    cpu, rq->yld_both_empty,
 		    rq->yld_act_empty, rq->yld_exp_empty, rq->yld_count,
 		    rq->sched_switch, rq->sched_count, rq->sched_goidle,
@@ -42,8 +42,7 @@ static int show_schedstat(struct seq_file *seq, void *v)
 			seq_printf(seq, "domain%d %s", dcount++, mask_str);
 			for (itype = CPU_IDLE; itype < CPU_MAX_IDLE_TYPES;
 					itype++) {
-				seq_printf(seq, " %lu %lu %lu %lu %lu %lu %lu "
-						"%lu",
+				seq_printf(seq, " %u %u %u %u %u %u %u %u",
 				    sd->lb_count[itype],
 				    sd->lb_balanced[itype],
 				    sd->lb_failed[itype],
@@ -53,8 +52,7 @@ static int show_schedstat(struct seq_file *seq, void *v)
 				    sd->lb_nobusyq[itype],
 				    sd->lb_nobusyg[itype]);
 			}
-			seq_printf(seq, " %lu %lu %lu %lu %lu %lu %lu %lu %lu"
-			    " %lu %lu %lu\n",
+			seq_printf(seq, " %u %u %u %u %u %u %u %u %u %u %u %u\n",
 			    sd->alb_count, sd->alb_failed, sd->alb_pushed,
 			    sd->sbe_count, sd->sbe_balanced, sd->sbe_pushed,
 			    sd->sbf_count, sd->sbf_balanced, sd->sbf_pushed,
