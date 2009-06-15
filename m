Return-Path: <linux-kernel-owner+w=401wt.eu-S1753578AbZFOCzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578AbZFOCzU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 22:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752082AbZFOCzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 22:55:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56929 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751294AbZFOCzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 22:55:08 -0400
Message-ID: <4A35B86A.7070608@cn.fujitsu.com>
Date: Mon, 15 Jun 2009 10:56:42 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] tracing: fix a typo in tracing_cpumask_write()
References: <4A35B84B.40904@cn.fujitsu.com>
In-Reply-To: <4A35B84B.40904@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's tracing_cpumask_new that should be kfree()ed.

This causes tracing_cpumask to be freed due to the typo:

 # echo z > tracing_cpumask
 bash: echo: write error: Invalid argument

And subsequent reads/writes to tracing_cpuamsk will access this
already-freed tracing_cpumask, thus may lead to crash.

[ Impact: fix leak and crash when writing invalid val to tracing_cpumask ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
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
1.5.4.rc3

