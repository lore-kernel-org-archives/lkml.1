Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030507Ab0B0SZl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 13:25:41 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:8905 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030293Ab0B0SZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 13:25:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rMTL7W5xA/PzRc599UMrv4GU0RuJHRdXkSe1spJBMkq4zEg/opMo/sqEzoUNMnVyqp
         oUOtt3YLgJ8r9cLdICRo1CMQ3HBubMetDOzEVWpJa0HkKtmuDsAllI90ktyaNiWN3vd+
         vCNRTPD4+H2GRr/90Wzi/IyUXXJsQ13Z/z694=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/5] percpu: Add __percpu sparse annotations to hw_breakpoint
Date: Sat, 27 Feb 2010 19:25:29 +0100
Message-Id: <1267295133-6320-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1267295133-6320-1-git-send-regression-fweisbec@gmail.com>
References: <1267295133-6320-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

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
 
-- 
1.6.2.3

