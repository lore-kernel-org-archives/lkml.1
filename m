Return-Path: <linux-kernel-owner+w=401wt.eu-S1756450AbZICU0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450AbZICU0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 16:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756436AbZICU0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 16:26:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756374AbZICU0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 16:26:13 -0400
Date: Thu, 3 Sep 2009 16:26:00 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, roland@redhat.com, rth@redhat.com,
       mingo@elte.hu
Message-Id: <8932ec639d9fd6995c847493dabefe25b5392f4e.1252007851.git.jbaron@redhat.com>
In-Reply-To: <cover.1252007851.git.jbaron@redhat.com>
References: <cover.1252007851.git.jbaron@redhat.com>
Subject: [PATCH 3/4] RFC: implement tracepoints on top of jump patching
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert tracepoints to use the new jump patching infrastructure. See
how easy it is!

Also, notice there is a patch to comment out the workqueue tracepoints. Without
this patch I had some panic when doing the code patching. I think this is
probably due to an iteraction b/w stop_machine() using workqueues to do the
actual patching and the workqueue code itself.



Signed-off-by: Jason Baron <jbaron@redhat.com>
 
---
 arch/x86/kernel/test_nx.c      |    3 +++
 include/linux/tracepoint.h     |   38 ++++++++++++++++++++++----------------
 kernel/trace/trace_workqueue.c |    2 ++
 kernel/tracepoint.c            |    9 +++++++++
 4 files changed, 36 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/test_nx.c b/arch/x86/kernel/test_nx.c
index 787a5e4..3dab463 100644
--- a/arch/x86/kernel/test_nx.c
+++ b/arch/x86/kernel/test_nx.c
@@ -15,6 +15,9 @@
 
 #include <asm/uaccess.h>
 #include <asm/asm.h>
+#include <linux/jump_label.h>
+
+JUMP_LABEL_NAME(kmalloc);
 
 extern int rodata_test_data;
 
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 63a3f7a..fdd2d8b 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -16,6 +16,7 @@
 
 #include <linux/types.h>
 #include <linux/rcupdate.h>
+#include <linux/jump_label.h>
 
 struct module;
 struct tracepoint;
@@ -63,21 +64,25 @@ struct tracepoint {
  * not add unwanted padding between the beginning of the section and the
  * structure. Force alignment to the same alignment as the section start.
  */
-#define DECLARE_TRACE(name, proto, args)				\
-	extern struct tracepoint __tracepoint_##name;			\
-	static inline void trace_##name(proto)				\
-	{								\
-		if (unlikely(__tracepoint_##name.state))		\
-			__DO_TRACE(&__tracepoint_##name,		\
-				TP_PROTO(proto), TP_ARGS(args));	\
-	}								\
-	static inline int register_trace_##name(void (*probe)(proto))	\
-	{								\
-		return tracepoint_probe_register(#name, (void *)probe);	\
-	}								\
-	static inline int unregister_trace_##name(void (*probe)(proto))	\
-	{								\
-		return tracepoint_probe_unregister(#name, (void *)probe);\
+#define DECLARE_TRACE(name, proto, args)				     \
+	extern struct tracepoint __tracepoint_##name;			     \
+	extern const char __sjstrtab_##name[];				     \
+	static inline void trace_##name(proto)				     \
+	{								     \
+		JUMP_LABEL_IF(name, trace_label, __tracepoint_##name.state); \
+		if (0) {						     \
+trace_label:								     \
+			__DO_TRACE(&__tracepoint_##name,		     \
+				TP_PROTO(proto), TP_ARGS(args));	     \
+		}							     \
+	}								     \
+	static inline int register_trace_##name(void (*probe)(proto))	     \
+	{								     \
+		return tracepoint_probe_register(#name, (void *)probe);	     \
+	}								     \
+	static inline int unregister_trace_##name(void (*probe)(proto))	     \
+	{								     \
+		return tracepoint_probe_unregister(#name, (void *)probe);    \
 	}
 
 
@@ -86,7 +91,8 @@ struct tracepoint {
 	__attribute__((section("__tracepoints_strings"))) = #name;	\
 	struct tracepoint __tracepoint_##name				\
 	__attribute__((section("__tracepoints"), aligned(32))) =	\
-		{ __tpstrtab_##name, 0, reg, unreg, NULL }
+		{ __tpstrtab_##name, 0, reg, unreg, NULL };		\
+	JUMP_LABEL_NAME(name);
 
 #define DEFINE_TRACE(name)						\
 	DEFINE_TRACE_FN(name, NULL, NULL);
diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
index 40cafb0..bc38428 100644
--- a/kernel/trace/trace_workqueue.c
+++ b/kernel/trace/trace_workqueue.c
@@ -258,6 +258,7 @@ int __init trace_workqueue_early_init(void)
 {
 	int ret, cpu;
 
+	/*
 	ret = register_trace_workqueue_insertion(probe_workqueue_insertion);
 	if (ret)
 		goto out;
@@ -273,6 +274,7 @@ int __init trace_workqueue_early_init(void)
 	ret = register_trace_workqueue_destruction(probe_workqueue_destruction);
 	if (ret)
 		goto no_creation;
+	*/
 
 	for_each_possible_cpu(cpu) {
 		spin_lock_init(&workqueue_cpu_stat(cpu)->lock);
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 9489a0a..1b4acc0 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -25,6 +25,7 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/jump_label.h>
 
 extern struct tracepoint __start___tracepoints[];
 extern struct tracepoint __stop___tracepoints[];
@@ -256,6 +257,11 @@ static void set_tracepoint(struct tracepoint_entry **entry,
 	 * is used.
 	 */
 	rcu_assign_pointer(elem->funcs, (*entry)->funcs);
+	if (!elem->state && active) {
+		printk("set_tracepoint: call run_make_jump: %s\n", elem->name);
+		run_make_jump(elem->name);
+	} else if (elem->state && !active)
+		run_make_nop(elem->name);
 	elem->state = active;
 }
 
@@ -270,6 +276,9 @@ static void disable_tracepoint(struct tracepoint *elem)
 	if (elem->unregfunc && elem->state)
 		elem->unregfunc();
 
+	if (elem->state)
+		run_make_nop(elem->name);
+
 	elem->state = 0;
 	rcu_assign_pointer(elem->funcs, NULL);
 }
-- 
1.6.2.5

