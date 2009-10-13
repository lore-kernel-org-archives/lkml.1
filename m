Return-Path: <linux-kernel-owner+w=401wt.eu-S1761359AbZJMVZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761359AbZJMVZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 17:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751721AbZJMVZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 17:25:38 -0400
Received: from claw.goop.org ([74.207.240.146]:56327 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458AbZJMVZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 17:25:37 -0400
Message-ID: <4AD4F02C.9060203@goop.org>
Date: Tue, 13 Oct 2009 14:25:00 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH RFC] sched: add notifier for process migration
References: <4ACFA4C5.4020607@goop.org> <1255125738.7439.17.camel@laptop>	 <4ACFBC98.4070701@goop.org> <1255158863.7866.25.camel@twins>	 <4AD04E50.7060001@redhat.com> <1255166662.7866.28.camel@twins>	 <4AD055B3.8070705@goop.org> <1255169528.7521.3.camel@laptop>
In-Reply-To: <1255169528.7521.3.camel@laptop>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/09 03:12, Peter Zijlstra wrote:
> A well, look at set_task_cpu(): new_rq->nr_migrations_in++;
>   

How does this look?

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Date: Wed, 7 Oct 2009 13:43:31 -0700
Subject: [PATCH] sched: add notifier for cross-cpu migrations

It can be useful to know when a task has migrated to another cpu (to invalidate some
per-cpu per-task cache, for example).

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

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


