Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab0BBHeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 02:34:09 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54449 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750736Ab0BBHeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 02:34:05 -0500
Message-ID: <4B67D4F9.9080905@cn.fujitsu.com>
Date: Tue, 02 Feb 2010 15:32:09 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing: fix circular dead lock
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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
---
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
 





