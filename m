Return-Path: <linux-kernel-owner+w=401wt.eu-S1758953AbZJNTb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758953AbZJNTb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 15:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759199AbZJNTa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 15:30:58 -0400
Received: from claw.goop.org ([74.207.240.146]:55339 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759085AbZJNT36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 15:29:58 -0400
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Xen-devel <xen-devel@lists.xensource.com>, kurt.hackel@oracle.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Avi Kivity <avi@redhat.com>, the arch/x86 maintainers <x86@kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 09/12] sched: add notifier for cross-cpu migrations
Date: Wed, 14 Oct 2009 12:28:33 -0700
Message-Id: <1255548516-15260-10-git-send-email-jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1255548516-15260-1-git-send-email-jeremy.fitzhardinge@citrix.com>
References: <1255548516-15260-1-git-send-email-jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a notifier to publish when a task gets migrated from one cpu to
another.  The first intended use is to export a "migration counter"
to usermode so that a task can tell whether its still running on the
same cpu (for use in vgetcpu and other vsyscall code).

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@linux.intel.com>
---
 include/linux/sched.h |    8 ++++++++
 kernel/sched.c        |   14 ++++++++++++++
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0f1ea4a..5186dd9 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -141,6 +141,14 @@ extern unsigned long nr_iowait(void);
 extern void calc_global_load(void);
 extern u64 cpu_nr_migrations(int cpu);
 
+/* Notifier for when a task gets migrated to a new CPU */
+struct task_migration_notifier {
+	struct task_struct *task;
+	int from_cpu;
+	int to_cpu;
+};
+extern void register_task_migration_notifier(struct notifier_block *n);
+
 extern unsigned long get_parent_ip(unsigned long addr);
 
 struct seq_file;
diff --git a/kernel/sched.c b/kernel/sched.c
index 1b59e26..3982e8e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1951,6 +1951,12 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
 	return delta < (s64)sysctl_sched_migration_cost;
 }
 
+static ATOMIC_NOTIFIER_HEAD(task_migration_notifier);
+
+void register_task_migration_notifier(struct notifier_block *n)
+{
+	atomic_notifier_chain_register(&task_migration_notifier, n);
+}
 
 void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 {
@@ -1973,6 +1979,8 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 		p->se.block_start -= clock_offset;
 #endif
 	if (old_cpu != new_cpu) {
+		struct task_migration_notifier tmn;
+
 		p->se.nr_migrations++;
 		new_rq->nr_migrations_in++;
 #ifdef CONFIG_SCHEDSTATS
@@ -1981,6 +1989,12 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 #endif
 		perf_swcounter_event(PERF_COUNT_SW_CPU_MIGRATIONS,
 				     1, 1, NULL, 0);
+
+		tmn.task = p;
+		tmn.from_cpu = old_cpu;
+		tmn.to_cpu = new_cpu;
+
+		atomic_notifier_call_chain(&task_migration_notifier, 0, &tmn);
 	}
 	p->se.vruntime -= old_cfsrq->min_vruntime -
 					 new_cfsrq->min_vruntime;
-- 
1.6.2.5

