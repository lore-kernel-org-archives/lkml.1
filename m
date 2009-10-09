Return-Path: <linux-kernel-owner+w=401wt.eu-S1761368AbZJIVCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761368AbZJIVCn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 17:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755847AbZJIVCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 17:02:42 -0400
Received: from claw.goop.org ([74.207.240.146]:44217 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755482AbZJIVCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 17:02:42 -0400
Message-ID: <4ACFA4C5.4020607@goop.org>
Date: Fri, 09 Oct 2009 14:01:57 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Avi Kivity <avi@redhat.com>,
       Andi Kleen <ak@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH RFC] sched: add notifier for process migration
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm working on adding vsyscall (vread) support for
arch/x86/kernel/pvclock.c.  The algorithm needs to look up per-cpu tsc
parameters (aka pvclock_vcpu_time_info) so that it can compute global
system time from the tsc.  To do this, it needs to grab a consistent
snapshot of (tsc, time_info).

Obviously this is all racy from usermode, because there are two levels
of scheduling going on the virtual case: kernel scheduling of tasks to
vcpus, and hypervisor scheduling of vcpus to pcpus.  The latter is dealt
with a version number in the tsc parameter structure to indicate changes
in the params (which could be due to scheduling, power events, etc).

To deal with kernel scheduling I want a second version number to let
usermode know they've been migrated to a new (v)cpu and need to try
again with updated time parameters.  Specifically, update the version on
the "from" vcpu so that usermode (vsyscall) code holding an old pointer
can see the number change and reload the cpu number and get a pointer to
the new cpu's time_info.

Initially I was doing this with a preempt notifier on sched_out, but Avi
pointed out that this was a pessimistic approximation of what I really
want, which is notification on cross-cpu migration.  And since migration
is an inherently expensive operation, the overhead of a notifier here
should be negligible.  (Aside from that, the preempt notifier mechanism
isn't intended to be enabled on every process on the system.)

So I'm proposing this patch.  My questions are:

   1. Does this look generally reasonable?
   2. Will this notifier actually be called every time a task gets
      migrated between CPUs?  Are there cases where migration may happen
      via some other path? (Though for my particular case I only care
      about migration when the task is actually preempted; if it goes to
      sleep on one cpu and happens to wake on another then it wasn't in
      the middle of getting time so it doesn't matter.)
   3. Or is there a better way to achieve what I want?

This might also be a generally useful extension to vgetcpu() caching so
that usermode can definitively tell whether the cpu number has changed
under its feet and needs to be reloaded via lsl/rdtscp, rather than
having to rely on a jiffies-based approximation.

Thanks,
    J

[PATCH] sched: add notifier for cross-cpu migrations

It can be useful to know when a task has migrated to another cpu (to invalidate some
per-cpu per-task cache, for example).

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0f1ea4a..a1c843a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -141,6 +141,13 @@ extern unsigned long nr_iowait(void);
 extern void calc_global_load(void);
 extern u64 cpu_nr_migrations(int cpu);
 
+struct migration_notifier {
+	struct task_struct *task;
+	int from_cpu;
+	int to_cpu;
+};
+extern void register_migration_notifier(struct notifier_block *n);
+
 extern unsigned long get_parent_ip(unsigned long addr);
 
 struct seq_file;
diff --git a/kernel/sched.c b/kernel/sched.c
index 1b59e26..b998504 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7005,6 +7005,13 @@ out:
 }
 EXPORT_SYMBOL_GPL(set_cpus_allowed_ptr);
 
+static ATOMIC_NOTIFIER_HEAD(migration_notifications);
+
+void register_migration_notifier(struct notifier_block *n)
+{
+	atomic_notifier_chain_register(&migration_notifications, n);
+}
+
 /*
  * Move (not current) task off this cpu, onto dest cpu. We're doing
  * this because either it can't run here any more (set_cpus_allowed()
@@ -7020,6 +7027,7 @@ static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
 {
 	struct rq *rq_dest, *rq_src;
 	int ret = 0, on_rq;
+	struct migration_notifier mn;
 
 	if (unlikely(!cpu_active(dest_cpu)))
 		return ret;
@@ -7044,6 +7052,13 @@ static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
 		activate_task(rq_dest, p, 0);
 		check_preempt_curr(rq_dest, p, 0);
 	}
+
+	mn.task = p;
+	mn.from_cpu = src_cpu;
+	mn.to_cpu = dest_cpu;
+
+	atomic_notifier_call_chain(&migration_notifications, 0, &mn);
+
 done:
 	ret = 1;
 fail:


