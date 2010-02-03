Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab0BCFTT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 00:19:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:55596 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073Ab0BCFTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 00:19:14 -0500
Date: Wed, 3 Feb 2010 05:18:38 GMT
From: tip-bot for Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, lizf@cn.fujitsu.com, tglx@linutronix.de,
       laijs@cn.fujitsu.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, rostedt@goodmis.org, tglx@linutronix.de,
       laijs@cn.fujitsu.com
In-Reply-To: <4B67D4F9.9080905@cn.fujitsu.com>
References: <4B67D4F9.9080905@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] tracing: Fix circular dead lock in stack trace
Message-ID: <tip-4f48f8b7fd18c44f8478174f9925cc3c059c6ce4@git.kernel.org>
Git-Commit-ID: 4f48f8b7fd18c44f8478174f9925cc3c059c6ce4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 03 Feb 2010 05:18:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4f48f8b7fd18c44f8478174f9925cc3c059c6ce4
Gitweb:     http://git.kernel.org/tip/4f48f8b7fd18c44f8478174f9925cc3c059c6ce4
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Tue, 2 Feb 2010 15:32:09 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 2 Feb 2010 10:20:18 -0500

tracing: Fix circular dead lock in stack trace

When we cat <debugfs>/tracing/stack_trace, we may cause circular lock:
sys_read()
  t_start()
     arch_spin_lock(&max_stack_lock);

  t_show()
     seq_printf(), vsnprintf() .... /* they are all trace-able,
       when they are traced, max_stack_lock may be required again. */

The following script can trigger this circular dead lock very easy:
#!/bin/bash

echo 1 > /proc/sys/kernel/stack_tracer_enabled

mount -t debugfs xxx /mnt > /dev/null 2>&1

(
# make check_stack() zealous to require max_stack_lock
for ((; ;))
{
	echo 1 > /mnt/tracing/stack_max_size
}
) &

for ((; ;))
{
	cat /mnt/tracing/stack_trace > /dev/null
}

To fix this bug, we increase the percpu trace_active before
require the lock.

Reported-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
LKML-Reference: <4B67D4F9.9080905@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_stack.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

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
 
