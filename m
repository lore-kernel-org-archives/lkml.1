Return-Path: <linux-kernel-owner+w=401wt.eu-S933468AbZFOSOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933468AbZFOSOA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933375AbZFOSNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:13:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:42623 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933369AbZFOSNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:13:37 -0400
Date: Mon, 15 Jun 2009 18:13:14 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, lizf@cn.fujitsu.com, rostedt@goodmis.org,
       tglx@linutronix.de
In-Reply-To: <4A35B86A.7070608@cn.fujitsu.com>
References: <4A35B86A.7070608@cn.fujitsu.com>
Subject: [tip:tracing/urgent] tracing: fix a typo in tracing_cpumask_write()
Message-ID: <tip-215368e8e59023d6a0abdda896923018d74fdf7f@git.kernel.org>
Git-Commit-ID: 215368e8e59023d6a0abdda896923018d74fdf7f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 15 Jun 2009 18:13:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  215368e8e59023d6a0abdda896923018d74fdf7f
Gitweb:     http://git.kernel.org/tip/215368e8e59023d6a0abdda896923018d74fdf7f
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Mon, 15 Jun 2009 10:56:42 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 15 Jun 2009 11:37:12 -0400

tracing: fix a typo in tracing_cpumask_write()

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
