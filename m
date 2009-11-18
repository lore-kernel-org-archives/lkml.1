Return-Path: <linux-kernel-owner+w=401wt.eu-S1757574AbZKRWon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574AbZKRWon (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 17:44:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756328AbZKRWoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 17:44:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753685AbZKRWoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 17:44:05 -0500
Date: Wed, 18 Nov 2009 17:43:49 -0500
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
       tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com
Message-Id: <dd0e9ae03f42f2e5934cc33bd8b44f08045c4ec2.1258580048.git.jbaron@redhat.com>
In-Reply-To: <cover.1258580048.git.jbaron@redhat.com>
References: <cover.1258580048.git.jbaron@redhat.com>
Subject: [RFC PATCH 6/6] jump label v3 - tracepoint support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of the jump label infrastructure for tracepoints.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 include/linux/tracepoint.h |   35 +++++++++++++++++++----------------
 kernel/module.c            |    2 +-
 kernel/tracepoint.c        |   25 ++++++++++++++++++-------
 3 files changed, 38 insertions(+), 24 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 2aac8a8..7c4e9cb 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -16,6 +16,7 @@
 
 #include <linux/types.h>
 #include <linux/rcupdate.h>
+#include <linux/jump_label.h>
 
 struct module;
 struct tracepoint;
@@ -63,20 +64,22 @@ struct tracepoint {
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
+#define DECLARE_TRACE(name, proto, args)				 \
+	extern struct tracepoint __tracepoint_##name;			 \
+	static inline void trace_##name(proto)				 \
+	{								 \
+		JUMP_LABEL(name, do_trace, __tracepoint_##name.state);   \
+		return;							 \
+do_trace:								 \
+		__DO_TRACE(&__tracepoint_##name,			 \
+			   TP_PROTO(proto), TP_ARGS(args));		 \
+	}								 \
+	static inline int register_trace_##name(void (*probe)(proto))	 \
+	{								 \
+		return tracepoint_probe_register(#name, (void *)probe);	 \
+	}								 \
+	static inline int unregister_trace_##name(void (*probe)(proto))	 \
+	{								 \
 		return tracepoint_probe_unregister(#name, (void *)probe);\
 	}
 
@@ -97,7 +100,7 @@ struct tracepoint {
 	EXPORT_SYMBOL(__tracepoint_##name)
 
 extern void tracepoint_update_probe_range(struct tracepoint *begin,
-	struct tracepoint *end);
+	struct tracepoint *end, void *data);
 
 #else /* !CONFIG_TRACEPOINTS */
 #define DECLARE_TRACE(name, proto, args)				\
@@ -120,7 +123,7 @@ extern void tracepoint_update_probe_range(struct tracepoint *begin,
 #define EXPORT_TRACEPOINT_SYMBOL(name)
 
 static inline void tracepoint_update_probe_range(struct tracepoint *begin,
-	struct tracepoint *end)
+	struct tracepoint *end, void *data)
 { }
 #endif /* CONFIG_TRACEPOINTS */
 #endif /* DECLARE_TRACE */
diff --git a/kernel/module.c b/kernel/module.c
index 6b8a754..7ceba66 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3114,7 +3114,7 @@ void module_update_tracepoints(void)
 	list_for_each_entry(mod, &modules, list)
 		if (!mod->taints)
 			tracepoint_update_probe_range(mod->tracepoints,
-				mod->tracepoints + mod->num_tracepoints);
+				mod->tracepoints + mod->num_tracepoints, mod);
 	mutex_unlock(&module_mutex);
 }
 
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index cc89be5..d78f4b0 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -25,6 +25,7 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/jump_label.h>
 
 extern struct tracepoint __start___tracepoints[];
 extern struct tracepoint __stop___tracepoints[];
@@ -239,7 +240,7 @@ static inline void remove_tracepoint(struct tracepoint_entry *e)
  * Sets the probe callback corresponding to one tracepoint.
  */
 static void set_tracepoint(struct tracepoint_entry **entry,
-	struct tracepoint *elem, int active)
+	struct tracepoint *elem, int active, void *data)
 {
 	WARN_ON(strcmp((*entry)->name, elem->name) != 0);
 
@@ -256,6 +257,12 @@ static void set_tracepoint(struct tracepoint_entry **entry,
 	 * is used.
 	 */
 	rcu_assign_pointer(elem->funcs, (*entry)->funcs);
+
+	if (!elem->state && active)
+		enable_jump_label(elem->name, data);
+	else if (elem->state && !active)
+		disable_jump_label(elem->name, data);
+
 	elem->state = active;
 }
 
@@ -265,11 +272,14 @@ static void set_tracepoint(struct tracepoint_entry **entry,
  * function insures that the original callback is not used anymore. This insured
  * by preempt_disable around the call site.
  */
-static void disable_tracepoint(struct tracepoint *elem)
+static void disable_tracepoint(struct tracepoint *elem, void *data)
 {
 	if (elem->unregfunc && elem->state)
 		elem->unregfunc();
 
+	if (elem->state)
+		disable_jump_label(elem->name, data);
+
 	elem->state = 0;
 	rcu_assign_pointer(elem->funcs, NULL);
 }
@@ -282,7 +292,8 @@ static void disable_tracepoint(struct tracepoint *elem)
  * Updates the probe callback corresponding to a range of tracepoints.
  */
 void
-tracepoint_update_probe_range(struct tracepoint *begin, struct tracepoint *end)
+tracepoint_update_probe_range(struct tracepoint *begin, struct tracepoint *end,
+				void *data)
 {
 	struct tracepoint *iter;
 	struct tracepoint_entry *mark_entry;
@@ -295,9 +306,9 @@ tracepoint_update_probe_range(struct tracepoint *begin, struct tracepoint *end)
 		mark_entry = get_tracepoint(iter->name);
 		if (mark_entry) {
 			set_tracepoint(&mark_entry, iter,
-					!!mark_entry->refcount);
+					!!mark_entry->refcount, data);
 		} else {
-			disable_tracepoint(iter);
+			disable_tracepoint(iter, data);
 		}
 	}
 	mutex_unlock(&tracepoints_mutex);
@@ -310,7 +321,7 @@ static void tracepoint_update_probes(void)
 {
 	/* Core kernel tracepoints */
 	tracepoint_update_probe_range(__start___tracepoints,
-		__stop___tracepoints);
+		__stop___tracepoints, NULL);
 	/* tracepoints in modules. */
 	module_update_tracepoints();
 }
@@ -565,7 +576,7 @@ int tracepoint_module_notify(struct notifier_block *self,
 	case MODULE_STATE_COMING:
 	case MODULE_STATE_GOING:
 		tracepoint_update_probe_range(mod->tracepoints,
-			mod->tracepoints + mod->num_tracepoints);
+			mod->tracepoints + mod->num_tracepoints, data);
 		break;
 	}
 	return 0;
-- 
1.6.5.1

