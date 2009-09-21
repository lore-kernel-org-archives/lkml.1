Return-Path: <linux-kernel-owner+w=401wt.eu-S1756024AbZIUMxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024AbZIUMxe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 08:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755969AbZIUMxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 08:53:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:54248 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755976AbZIUMxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 08:53:32 -0400
Date: Mon, 21 Sep 2009 12:52:06 GMT
From: tip-bot for Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       heiko.carstens@de.ibm.com, tglx@linutronix.de, oleg@redhat.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       heiko.carstens@de.ibm.com, tglx@linutronix.de, oleg@redhat.com,
       mingo@elte.hu
In-Reply-To: <20090921090627.GD4649@osiris.boeblingen.de.ibm.com>
References: <20090921090627.GD4649@osiris.boeblingen.de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Always show Cpus_allowed field in /proc/<pid>/status
Message-ID: <tip-d01d4827858cdc2e1c437c87ab65ec0a00fd40f8@git.kernel.org>
Git-Commit-ID: d01d4827858cdc2e1c437c87ab65ec0a00fd40f8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 21 Sep 2009 12:52:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d01d4827858cdc2e1c437c87ab65ec0a00fd40f8
Gitweb:     http://git.kernel.org/tip/d01d4827858cdc2e1c437c87ab65ec0a00fd40f8
Author:     Heiko Carstens <heiko.carstens@de.ibm.com>
AuthorDate: Mon, 21 Sep 2009 11:06:27 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 21 Sep 2009 11:37:27 +0200

sched: Always show Cpus_allowed field in /proc/<pid>/status

The Cpus_allowed fields in /proc/<pid>/status is currently only
shown in case of CONFIG_CPUSETS. However their contents are also
useful for the !CONFIG_CPUSETS case.

So change the current behaviour and always show these fields.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20090921090627.GD4649@osiris.boeblingen.de.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 fs/proc/array.c |   11 +++++++++++
 kernel/cpuset.c |    8 +-------
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 725a650..762aea9 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -321,6 +321,16 @@ static inline void task_context_switch_counts(struct seq_file *m,
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
@@ -335,6 +345,7 @@ int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
 	}
 	task_sig(m, task);
 	task_cap(m, task);
+	task_cpus_allowed(m, task);
 	cpuset_task_status_allowed(m, task);
 #if defined(CONFIG_S390)
 	task_show_regs(m, task);
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 7e75a41..b81f7f0 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2499,15 +2499,9 @@ const struct file_operations proc_cpuset_operations = {
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
