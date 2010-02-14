Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156Ab0BNJJY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 04:09:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37902 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764Ab0BNJJW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 04:09:22 -0500
Date: Sun, 14 Feb 2010 10:09:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] tracing fixes
Message-ID: <20100214090913.GA26388@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest tracing-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-fixes-for-linus

 Thanks,

	Ingo

------------------>
Heiko Carstens (1):
      tracing/kprobes: Fix probe parsing

Lai Jiangshan (1):
      tracing: Fix circular dead lock in stack trace


 kernel/trace/trace_kprobe.c |    2 +-
 kernel/trace/trace_stack.c  |   24 ++++++++++++++++++++++++
 2 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 6ea90c0..50b1b82 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -689,7 +689,7 @@ static int create_trace_probe(int argc, char **argv)
 			return -EINVAL;
 		}
 		/* an address specified */
-		ret = strict_strtoul(&argv[0][2], 0, (unsigned long *)&addr);
+		ret = strict_strtoul(&argv[1][0], 0, (unsigned long *)&addr);
 		if (ret) {
 			pr_info("Failed to parse address.\n");
 			return ret;
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index 678a512..f4bc9b2 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -157,6 +157,7 @@ stack_max_size_write(struct file *filp, const char __user *ubuf,
 	unsigned long val, flags;
 	char buf[64];
 	int ret;
+	int cpu;
 
 	if (count >= sizeof(buf))
 		return -EINVAL;
@@ -171,9 +172,20 @@ stack_max_size_write(struct file *filp, const char __user *ubuf,
 		return ret;
 
 	local_irq_save(flags);
+
+	/*
+	 * In case we trace inside arch_spin_lock() or after (NMI),
+	 * we will cause circular lock, so we also need to increase
+	 * the percpu trace_active here.
+	 */
+	cpu = smp_processor_id();
+	per_cpu(trace_active, cpu)++;
+
 	arch_spin_lock(&max_stack_lock);
 	*ptr = val;
 	arch_spin_unlock(&max_stack_lock);
+
+	per_cpu(trace_active, cpu)--;
 	local_irq_restore(flags);
 
 	return count;
@@ -206,7 +218,13 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 
 static void *t_start(struct seq_file *m, loff_t *pos)
 {
+	int cpu;
+
 	local_irq_disable();
+
+	cpu = smp_processor_id();
+	per_cpu(trace_active, cpu)++;
+
 	arch_spin_lock(&max_stack_lock);
 
 	if (*pos == 0)
@@ -217,7 +235,13 @@ static void *t_start(struct seq_file *m, loff_t *pos)
 
 static void t_stop(struct seq_file *m, void *p)
 {
+	int cpu;
+
 	arch_spin_unlock(&max_stack_lock);
+
+	cpu = smp_processor_id();
+	per_cpu(trace_active, cpu)--;
+
 	local_irq_enable();
 }
 
