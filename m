Return-Path: <linux-kernel-owner+w=401wt.eu-S1756461AbZKRWoJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461AbZKRWoJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 17:44:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756288AbZKRWoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 17:44:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756161AbZKRWoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 17:44:03 -0500
Date: Wed, 18 Nov 2009 17:43:44 -0500
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
       tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com
Message-Id: <b1975a8ef1ccd918bf511bc1376bd3838ae1eacb.1258580048.git.jbaron@redhat.com>
In-Reply-To: <cover.1258580048.git.jbaron@redhat.com>
References: <cover.1258580048.git.jbaron@redhat.com>
Subject: [RFC PATCH 5/6] jump label v3 - add module support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for 'jump label' for modules.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 arch/x86/kernel/jump_label.c |    5 ++++-
 include/linux/jump_label.h   |    2 ++
 include/linux/module.h       |   12 +++++++++++-
 kernel/module.c              |   25 +++++++++++++++++++++++++
 4 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
index 4131bbd..080062d 100644
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -1,6 +1,7 @@
 #include <linux/jump_label.h>
 #include <linux/memory.h>
 #include <linux/uaccess.h>
+#include <linux/module.h>
 #include <asm/alternative.h>
 
 #ifdef __HAVE_ARCH_JUMP_LABEL
@@ -47,8 +48,10 @@ int jump_label_update(const char *name, enum jump_label_type type, void *mod)
 {
 	struct jump_entry *iter;
 
-	if (mod)
+	if (mod) {
+		jump_label_update_module(name, type, mod);
 		return 0;
+	}
 
 	for (iter = __start___jump_table; iter < __stop___jump_table; iter++) {
 		if (!strcmp(name, iter->name)) {
diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 2719506..7935ff6 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -17,6 +17,8 @@ enum jump_label_type {
 #ifdef __HAVE_ARCH_JUMP_LABEL
 
 extern int jump_label_update(const char *name, enum jump_label_type type, void *mod);
+extern void jump_label_transform(struct jump_entry *entry,
+				 enum jump_label_type type);
 
 #define enable_jump_label(name, mod) \
 	jump_label_update(name, JUMP_LABEL_ENABLE, mod);
diff --git a/include/linux/module.h b/include/linux/module.h
index 819354a..307b64a 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -16,6 +16,7 @@
 #include <linux/kobject.h>
 #include <linux/moduleparam.h>
 #include <linux/tracepoint.h>
+#include <linux/jump_label.h>
 
 #include <asm/local.h>
 #include <asm/module.h>
@@ -355,7 +356,10 @@ struct module
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
@@ -557,6 +561,7 @@ extern void print_modules(void);
 
 extern void module_update_tracepoints(void);
 extern int module_get_iter_tracepoints(struct tracepoint_iter *iter);
+extern void jump_label_update_module(const char *name, enum jump_label_type type, void *mod);
 
 #else /* !CONFIG_MODULES... */
 #define EXPORT_SYMBOL(sym)
@@ -678,6 +683,11 @@ static inline int module_get_iter_tracepoints(struct tracepoint_iter *iter)
 	return 0;
 }
 
+static inline void jump_label_update_module(const char *name, enum jump_label_type type, void *mod)
+{
+	return;
+}
+
 #endif /* CONFIG_MODULES */
 
 struct device_driver;
diff --git a/kernel/module.c b/kernel/module.c
index 8b7d880..6b8a754 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -55,6 +55,7 @@
 #include <linux/async.h>
 #include <linux/percpu.h>
 #include <linux/kmemleak.h>
+#include <linux/jump_label.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/module.h>
@@ -2378,6 +2379,12 @@ static noinline struct module *load_module(void __user *umod,
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
@@ -3143,4 +3150,22 @@ int module_get_iter_tracepoints(struct tracepoint_iter *iter)
 	mutex_unlock(&module_mutex);
 	return found;
 }
+
+#endif
+
+#ifdef __HAVE_ARCH_JUMP_LABEL
+
+void jump_label_update_module(const char *name, enum jump_label_type type, void *data)
+{
+	struct jump_entry *entry;
+	struct module *mod = data;
+
+	for (entry = mod->jump_entries;
+		entry < mod->jump_entries + mod->num_jump_entries;
+		entry++) {
+			if (!strcmp(name, entry->name))
+				jump_label_transform(entry, type);
+	}
+}
+
 #endif
-- 
1.6.5.1

