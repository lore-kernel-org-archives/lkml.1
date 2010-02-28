Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031623Ab0B1I6K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 03:58:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:36811 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031613Ab0B1I6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 03:58:07 -0500
Date: Sun, 28 Feb 2010 08:57:37 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, tj@kernel.org, sfr@canb.auug.org.au,
       tglx@linutronix.de, prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, tj@kernel.org, tglx@linutronix.de,
       sfr@canb.auug.org.au, prasad@linux.vnet.ibm.com
In-Reply-To: <4B7B4B7A.9050902@kernel.org>
References: <4B7B4B7A.9050902@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] percpu: Add __percpu sparse annotations to hw_breakpoint
Message-ID: <tip-44ee63587dce85593c22497140db16f4e5027860@git.kernel.org>
Git-Commit-ID: 44ee63587dce85593c22497140db16f4e5027860
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 28 Feb 2010 08:57:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  44ee63587dce85593c22497140db16f4e5027860
Gitweb:     http://git.kernel.org/tip/44ee63587dce85593c22497140db16f4e5027860
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Wed, 17 Feb 2010 10:50:50 +0900
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Sat, 27 Feb 2010 16:23:39 +0100

percpu: Add __percpu sparse annotations to hw_breakpoint

Add __percpu sparse annotations to hw_breakpoint.

These annotations are to make sparse consider percpu variables to be
in a different address space and warn if accessed without going
through percpu accessors.  This patch doesn't affect normal builds.

In kernel/hw_breakpoint.c, per_cpu(nr_task_bp_pinned, cpu)'s will
trigger spurious noderef related warnings from sparse.  Changing it to
&per_cpu(nr_task_bp_pinned[0], cpu) will work around the problem but
deemed to ugly by the maintainer.  Leave it alone until better
solution can be found.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
LKML-Reference: <4B7B4B7A.9050902@kernel.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/hw_breakpoint.h           |    8 ++++----
 kernel/hw_breakpoint.c                  |   10 +++++-----
 samples/hw_breakpoint/data_breakpoint.c |    6 +++---
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
index 5977b72..c70d27a 100644
--- a/include/linux/hw_breakpoint.h
+++ b/include/linux/hw_breakpoint.h
@@ -66,14 +66,14 @@ register_wide_hw_breakpoint_cpu(struct perf_event_attr *attr,
 				perf_overflow_handler_t	triggered,
 				int cpu);
 
-extern struct perf_event **
+extern struct perf_event * __percpu *
 register_wide_hw_breakpoint(struct perf_event_attr *attr,
 			    perf_overflow_handler_t triggered);
 
 extern int register_perf_hw_breakpoint(struct perf_event *bp);
 extern int __register_perf_hw_breakpoint(struct perf_event *bp);
 extern void unregister_hw_breakpoint(struct perf_event *bp);
-extern void unregister_wide_hw_breakpoint(struct perf_event **cpu_events);
+extern void unregister_wide_hw_breakpoint(struct perf_event * __percpu *cpu_events);
 
 extern int dbg_reserve_bp_slot(struct perf_event *bp);
 extern int dbg_release_bp_slot(struct perf_event *bp);
@@ -100,7 +100,7 @@ static inline struct perf_event *
 register_wide_hw_breakpoint_cpu(struct perf_event_attr *attr,
 				perf_overflow_handler_t	 triggered,
 				int cpu)		{ return NULL; }
-static inline struct perf_event **
+static inline struct perf_event * __percpu *
 register_wide_hw_breakpoint(struct perf_event_attr *attr,
 			    perf_overflow_handler_t triggered)	{ return NULL; }
 static inline int
@@ -109,7 +109,7 @@ static inline int
 __register_perf_hw_breakpoint(struct perf_event *bp) 	{ return -ENOSYS; }
 static inline void unregister_hw_breakpoint(struct perf_event *bp)	{ }
 static inline void
-unregister_wide_hw_breakpoint(struct perf_event **cpu_events)		{ }
+unregister_wide_hw_breakpoint(struct perf_event * __percpu *cpu_events)	{ }
 static inline int
 reserve_bp_slot(struct perf_event *bp)			{return -ENOSYS; }
 static inline void release_bp_slot(struct perf_event *bp) 		{ }
diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index 967e661..6542eac 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -413,17 +413,17 @@ EXPORT_SYMBOL_GPL(unregister_hw_breakpoint);
  *
  * @return a set of per_cpu pointers to perf events
  */
-struct perf_event **
+struct perf_event * __percpu *
 register_wide_hw_breakpoint(struct perf_event_attr *attr,
 			    perf_overflow_handler_t triggered)
 {
-	struct perf_event **cpu_events, **pevent, *bp;
+	struct perf_event * __percpu *cpu_events, **pevent, *bp;
 	long err;
 	int cpu;
 
 	cpu_events = alloc_percpu(typeof(*cpu_events));
 	if (!cpu_events)
-		return ERR_PTR(-ENOMEM);
+		return (void __percpu __force *)ERR_PTR(-ENOMEM);
 
 	get_online_cpus();
 	for_each_online_cpu(cpu) {
@@ -451,7 +451,7 @@ fail:
 	put_online_cpus();
 
 	free_percpu(cpu_events);
-	return ERR_PTR(err);
+	return (void __percpu __force *)ERR_PTR(err);
 }
 EXPORT_SYMBOL_GPL(register_wide_hw_breakpoint);
 
@@ -459,7 +459,7 @@ EXPORT_SYMBOL_GPL(register_wide_hw_breakpoint);
  * unregister_wide_hw_breakpoint - unregister a wide breakpoint in the kernel
  * @cpu_events: the per cpu set of events to unregister
  */
-void unregister_wide_hw_breakpoint(struct perf_event **cpu_events)
+void unregister_wide_hw_breakpoint(struct perf_event * __percpu *cpu_events)
 {
 	int cpu;
 	struct perf_event **pevent;
diff --git a/samples/hw_breakpoint/data_breakpoint.c b/samples/hw_breakpoint/data_breakpoint.c
index c69cbe9..bd0f337 100644
--- a/samples/hw_breakpoint/data_breakpoint.c
+++ b/samples/hw_breakpoint/data_breakpoint.c
@@ -34,7 +34,7 @@
 #include <linux/perf_event.h>
 #include <linux/hw_breakpoint.h>
 
-struct perf_event **sample_hbp;
+struct perf_event * __percpu *sample_hbp;
 
 static char ksym_name[KSYM_NAME_LEN] = "pid_max";
 module_param_string(ksym, ksym_name, KSYM_NAME_LEN, S_IRUGO);
@@ -61,8 +61,8 @@ static int __init hw_break_module_init(void)
 	attr.bp_type = HW_BREAKPOINT_W | HW_BREAKPOINT_R;
 
 	sample_hbp = register_wide_hw_breakpoint(&attr, sample_hbp_handler);
-	if (IS_ERR(sample_hbp)) {
-		ret = PTR_ERR(sample_hbp);
+	if (IS_ERR((void __force *)sample_hbp)) {
+		ret = PTR_ERR((void __force *)sample_hbp);
 		goto fail;
 	}
 
