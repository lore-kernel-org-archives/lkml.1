Return-Path: <linux-kernel-owner+w=401wt.eu-S1752809AbZIXXSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbZIXXSX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 19:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbZIXXSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 19:18:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7222 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613AbZIXXSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 19:18:17 -0400
Date: Thu, 24 Sep 2009 19:17:56 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, mathieu.desnoyers@polymtl.ca, tglx@linutronix.de,
       rostedt@goodmis.org, ak@suse.de, roland@redhat.com, rth@redhat.com,
       mhiramat@redhat.com
Message-Id: <169a7c0645cfe4700425e9beaf0265062b93cc15.1253831946.git.jbaron@redhat.com>
In-Reply-To: <cover.1253831945.git.jbaron@redhat.com>
References: <cover.1253831945.git.jbaron@redhat.com>
Subject: [PATCH 3/4] jump label - add module support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Add module support to jump label patching.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 arch/x86/kernel/jump_label.c |    4 +++-
 include/linux/jump_label.h   |   34 ++++++++++++++++++++++++++--------
 include/linux/module.h       |   12 +++++++++++-
 kernel/module.c              |   31 +++++++++++++++++++++++++++++++
 4 files changed, 71 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
index 207947d..d057c3f 100644
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -2,6 +2,7 @@
 #include <linux/memory.h>
 #include <linux/kprobes.h>
 #include <linux/uaccess.h>
+#include <linux/module.h>
 
 #ifdef __HAVE_ARCH_JUMP_LABEL
 
@@ -73,7 +74,7 @@ void jump_label_transform(struct jump_entry *entry, enum jump_label_type type)
 	mutex_unlock(&text_mutex);
 }
 
-int jump_label_update(const char *name, enum jump_label_type type)
+int jump_label_update(const char *name, enum jump_label_type type, int module_lock)
 {
 	struct jump_entry *iter;
 	
@@ -85,6 +86,7 @@ int jump_label_update(const char *name, enum jump_label_type type)
 				jump_label_transform(iter, type);
 		}
 	}
+	jump_label_update_modules(name, type, module_lock);
 	mutex_unlock(&jump_label_mutex);
 	return 0;
 }
diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index eb0a4ef..1033d35 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -23,13 +23,22 @@ enum jump_label_instruction {
 
 #ifdef __HAVE_ARCH_JUMP_LABEL
 
-extern int jump_label_update(const char *name, enum jump_label_type type);
+extern int jump_label_update(const char *name, enum jump_label_type type,
+			     int module_lock);
+extern void jump_label_transform(struct jump_entry *entry,
+				 enum jump_label_type type);
 
-#define enable_jump_label(name) \
-	jump_label_update(name, JUMP_LABEL_ENABLE);
+#define enable_jump_label_locked(name) \
+	jump_label_update(name, JUMP_LABEL_ENABLE, 1);
 
-#define disable_jump_label(name) \
-	jump_label_update(name, JUMP_LABEL_DISABLE);
+#define disable_jump_label_locked(name) \
+	jump_label_update(name, JUMP_LABEL_DISABLE, 1);
+
+#define enable_jump_label_unlocked(name) \
+	jump_label_update(name, JUMP_LABEL_ENABLE, 0);
+
+#define disable_jump_label_unlocked(name) \
+	jump_label_update(name, JUMP_LABEL_DISABLE, 0);
 
 #else
 
@@ -37,13 +46,22 @@ extern int jump_label_update(const char *name, enum jump_label_type type);
 	if (likely(!cond))			\
 		goto label;
 
-static inline int enable_jump_label(const char *name, enum jump_label_type type)
+static inline int enable_jump_label_locked(const char *name)
+{
+	return 0;
+}
+
+static inline int disable_jump_label_locked(const char *name)
+{
+	return 0;
+}
+
+static inline int enable_jump_label_unlocked(const char *name)
 {
 	return 0;
 }
 
-static inline int disable_jump_label(const char *name,
-				     enum jump_label_type type)
+static inline int disable_jump_label_unlocked(const char *name)
 {
 	return 0;
 }
diff --git a/include/linux/module.h b/include/linux/module.h
index 86863cd..911f5c9 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -17,6 +17,7 @@
 #include <linux/moduleparam.h>
 #include <linux/marker.h>
 #include <linux/tracepoint.h>
+#include <linux/jump_label.h>
 
 #include <asm/local.h>
 #include <asm/module.h>
@@ -353,7 +354,10 @@ struct module
 	struct tracepoint *tracepoints;
 	unsigned int num_tracepoints;
 #endif
-
+#ifdef __HAVE_ARCH_JUMP_LABEL
+	struct jump_entry *jump_entries;
+	unsigned int num_jump_entries;
+#endif
 #ifdef CONFIG_TRACING
 	const char **trace_bprintk_fmt_start;
 	unsigned int num_trace_bprintk_fmt;
@@ -557,6 +561,7 @@ extern void module_update_markers(void);
 
 extern void module_update_tracepoints(void);
 extern int module_get_iter_tracepoints(struct tracepoint_iter *iter);
+extern void jump_label_update_modules(const char *name, enum jump_label_type type, int module_lock);
 
 #else /* !CONFIG_MODULES... */
 #define EXPORT_SYMBOL(sym)
@@ -682,6 +687,11 @@ static inline int module_get_iter_tracepoints(struct tracepoint_iter *iter)
 	return 0;
 }
 
+static inline void jump_label_update_modules(const char *name, enum jump_label_type type, int module_lock)
+{
+	return 0;
+}
+
 #endif /* CONFIG_MODULES */
 
 struct device_driver;
diff --git a/kernel/module.c b/kernel/module.c
index 46580ed..01c2343 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -54,6 +54,7 @@
 #include <linux/async.h>
 #include <linux/percpu.h>
 #include <linux/kmemleak.h>
+#include <linux/jump_label.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/module.h>
@@ -2247,6 +2248,12 @@ static noinline struct module *load_module(void __user *umod,
 					sizeof(*mod->tracepoints),
 					&mod->num_tracepoints);
 #endif
+#ifdef __HAVE_ARCH_JUMP_LABEL
+	mod->jump_entries = section_objs(hdr, sechdrs, secstrings,
+					"__jump_table",
+					sizeof(*mod->jump_entries),
+					&mod->num_jump_entries);
+#endif
 #ifdef CONFIG_EVENT_TRACING
 	mod->trace_events = section_objs(hdr, sechdrs, secstrings,
 					 "_ftrace_events",
@@ -3017,4 +3024,28 @@ int module_get_iter_tracepoints(struct tracepoint_iter *iter)
 	mutex_unlock(&module_mutex);
 	return found;
 }
+
+#endif
+
+#ifdef __HAVE_ARCH_JUMP_LABEL
+
+void jump_label_update_modules(const char *name, enum jump_label_type type, int module_lock)
+{
+	struct module *iter_mod;
+	struct jump_entry *entry;
+
+	if (!module_lock)
+		mutex_lock(&module_mutex);
+	list_for_each_entry(iter_mod, &modules, list) {
+		for(entry = iter_mod->jump_entries;
+		    entry < iter_mod->jump_entries + iter_mod->num_jump_entries;
+		    entry++) {
+				if (!strcmp(name, entry->name))
+					jump_label_transform(entry, type);
+		}
+	}
+	if (!module_lock)
+		mutex_unlock(&module_mutex);
+}
+
 #endif
-- 
1.6.2.5

