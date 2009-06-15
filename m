Return-Path: <linux-kernel-owner+w=401wt.eu-S1763041AbZFOPo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763041AbZFOPo5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 11:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760909AbZFOPoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 11:44:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40130 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743AbZFOPoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 11:44:09 -0400
Message-Id: <20090615154410.950808103@goodmis.org>
References: <20090615154226.058101204@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 15 Jun 2009 11:42:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 3/7] tracing: fix a typo in tracing_cpumask_write()
Content-Disposition: inline; filename=0003-tracing-fix-a-typo-in-tracing_cpumask_write.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

It's tracing_cpumask_new that should be kfree()ed.

This causes tracing_cpumask to be freed due to the typo:

 # echo z > tracing_cpumask
 bash: echo: write error: Invalid argument

And subsequent reads/writes to tracing_cpuamsk will access this
already-freed tracing_cpumask, thus may lead to crash.

[ Impact: fix leak and crash when writing invalid val to tracing_cpumask ]

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4A35B86A.7070608@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8acd9b8..7355a38 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2191,11 +2191,12 @@ tracing_cpumask_write(struct file *filp, const char __user *ubuf,
 	if (!alloc_cpumask_var(&tracing_cpumask_new, GFP_KERNEL))
 		return -ENOMEM;
 
-	mutex_lock(&tracing_cpumask_update_lock);
 	err = cpumask_parse_user(ubuf, count, tracing_cpumask_new);
 	if (err)
 		goto err_unlock;
 
+	mutex_lock(&tracing_cpumask_update_lock);
+
 	local_irq_disable();
 	__raw_spin_lock(&ftrace_max_lock);
 	for_each_tracing_cpu(cpu) {
@@ -2223,8 +2224,7 @@ tracing_cpumask_write(struct file *filp, const char __user *ubuf,
 	return count;
 
 err_unlock:
-	mutex_unlock(&tracing_cpumask_update_lock);
-	free_cpumask_var(tracing_cpumask);
+	free_cpumask_var(tracing_cpumask_new);
 
 	return err;
 }
-- 
1.6.3.1

-- 
