Return-Path: <linux-kernel-owner+w=401wt.eu-S1755693AbZIUJSC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbZIUJSC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 05:18:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755533AbZIUJSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 05:18:00 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:56661 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495AbZIUJR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 05:17:58 -0400
Date: Mon, 21 Sep 2009 11:17:59 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Always show Cpus_allowed field in /proc/<pid>/status.
Message-ID: <20090921091759.GF4649@osiris.boeblingen.de.ibm.com>
References: <20090921085155.GB4649@osiris.boeblingen.de.ibm.com>
 <20090921090627.GD4649@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090921090627.GD4649@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 11:06:27AM +0200, Heiko Carstens wrote:

> +void task_cpus_allowed(struct seq_file *m, struct task_struct *task)

sigh. This should have been static.. updated patch below.


Subject: [PATCH] Always show Cpus_allowed fields in /proc/<pid>/status.

From: Heiko Carstens <heiko.carstens@de.ibm.com>

The Cpus_allowed fields in /proc/<pid>/status is currently only shown in
case of CONFIG_CPUSETS. However their contents are also useful for the
!CONFIG_CPUSETS case.
So change the current behaviour and always show these fields.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 fs/proc/array.c |   11 +++++++++++
 kernel/cpuset.c |    8 +-------
 2 files changed, 12 insertions(+), 7 deletions(-)

Index: linux-2.6/fs/proc/array.c
===================================================================
--- linux-2.6.orig/fs/proc/array.c
+++ linux-2.6/fs/proc/array.c
@@ -321,6 +321,16 @@ static inline void task_context_switch_c
 			p->nivcsw);
 }
 
+static void task_cpus_allowed(struct seq_file *m, struct task_struct *task)
+{
+	seq_printf(m, "Cpus_allowed:\t");
+	seq_cpumask(m, &task->cpus_allowed);
+	seq_printf(m, "\n");
+	seq_printf(m, "Cpus_allowed_list:\t");
+	seq_cpumask_list(m, &task->cpus_allowed);
+	seq_printf(m, "\n");
+}
+
 int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
 			struct pid *pid, struct task_struct *task)
 {
@@ -335,6 +345,7 @@ int proc_pid_status(struct seq_file *m, 
 	}
 	task_sig(m, task);
 	task_cap(m, task);
+	task_cpus_allowed(m, task);
 	cpuset_task_status_allowed(m, task);
 #if defined(CONFIG_S390)
 	task_show_regs(m, task);
Index: linux-2.6/kernel/cpuset.c
===================================================================
--- linux-2.6.orig/kernel/cpuset.c
+++ linux-2.6/kernel/cpuset.c
@@ -2499,15 +2499,9 @@ const struct file_operations proc_cpuset
 };
 #endif /* CONFIG_PROC_PID_CPUSET */
 
-/* Display task cpus_allowed, mems_allowed in /proc/<pid>/status file. */
+/* Display task mems_allowed in /proc/<pid>/status file. */
 void cpuset_task_status_allowed(struct seq_file *m, struct task_struct *task)
 {
-	seq_printf(m, "Cpus_allowed:\t");
-	seq_cpumask(m, &task->cpus_allowed);
-	seq_printf(m, "\n");
-	seq_printf(m, "Cpus_allowed_list:\t");
-	seq_cpumask_list(m, &task->cpus_allowed);
-	seq_printf(m, "\n");
 	seq_printf(m, "Mems_allowed:\t");
 	seq_nodemask(m, &task->mems_allowed);
 	seq_printf(m, "\n");
