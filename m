Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505Ab0BBP7Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 10:59:25 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:43266 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239Ab0BBP7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 10:59:21 -0500
X-Authority-Analysis: v=1.0 c=1 a=QUWSY34ASuwA:10 a=7U3hwN5JcxgA:10 a=VwQbUJbxAAAA:8 a=omOdbC7AAAAA:8 a=meVymXHHAAAA:8 a=enT3BnPoYh3wq0fAUY0A:9 a=MNmHfNkMvmBk7-5edOAA:7 a=ppRvNAwtUBgLn78LKwrKBAkCxSAA:4 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: [PATCH][GIT PULL][v2.6.33] tracing: Fix circular dead lock in
 stack trace
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 02 Feb 2010 10:59:18 -0500
Message-ID: <1265126358.29013.1273.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/urgent


Lai Jiangshan (1):
      tracing: Fix circular dead lock in stack trace

----
 kernel/trace/trace_stack.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)
---------------------------
commit 4f48f8b7fd18c44f8478174f9925cc3c059c6ce4
Author: Lai Jiangshan <laijs@cn.fujitsu.com>
Date:   Tue Feb 2 15:32:09 2010 +0800

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
 


