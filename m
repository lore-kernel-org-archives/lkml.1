Return-Path: <linux-kernel-owner+w=401wt.eu-S1751832AbZIXXS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832AbZIXXS3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 19:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbZIXXS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 19:18:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49832 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807AbZIXXS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 19:18:26 -0400
Date: Thu, 24 Sep 2009 19:18:00 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, mathieu.desnoyers@polymtl.ca, tglx@linutronix.de,
       rostedt@goodmis.org, ak@suse.de, roland@redhat.com, rth@redhat.com,
       mhiramat@redhat.com
Message-Id: <812eba02291a0bc933073ed429a9a0a60cf88f28.1253831946.git.jbaron@redhat.com>
In-Reply-To: <cover.1253831945.git.jbaron@redhat.com>
References: <cover.1253831945.git.jbaron@redhat.com>
Subject: [PATCH 4/4] jump label - tracepoint implementation
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Implement tracepoints if conditional on top of jump labels.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 include/linux/tracepoint.h |   31 +++++++++++++++++--------------
 kernel/tracepoint.c        |   10 ++++++++++
 2 files changed, 27 insertions(+), 14 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 63a3f7a..e7e2910 100644
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
+		JUMP_LABEL(name, trace_label, __tracepoint_##name.state);\
+		__DO_TRACE(&__tracepoint_##name,			 \
+			   TP_PROTO(proto), TP_ARGS(args));		 \
+trace_label:								 \
+		return;							 \
+	}								 \
+	static inline int register_trace_##name(void (*probe)(proto))	 \
+	{								 \
+		return tracepoint_probe_register(#name, (void *)probe);	 \
+	}								 \
+	static inline int unregister_trace_##name(void (*probe)(proto))	 \
+	{								 \
 		return tracepoint_probe_unregister(#name, (void *)probe);\
 	}
 
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 9489a0a..e06bce8 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -25,6 +25,7 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/jump_label.h>
 
 extern struct tracepoint __start___tracepoints[];
 extern struct tracepoint __stop___tracepoints[];
@@ -256,6 +257,12 @@ static void set_tracepoint(struct tracepoint_entry **entry,
 	 * is used.
 	 */
 	rcu_assign_pointer(elem->funcs, (*entry)->funcs);
+
+	if (!elem->state && active) {
+		enable_jump_label_locked(elem->name);
+	} else if (elem->state && !active)
+		disable_jump_label_locked(elem->name);
+
 	elem->state = active;
 }
 
@@ -270,6 +277,9 @@ static void disable_tracepoint(struct tracepoint *elem)
 	if (elem->unregfunc && elem->state)
 		elem->unregfunc();
 
+	if (elem->state)
+		disable_jump_label_locked(elem->name);
+
 	elem->state = 0;
 	rcu_assign_pointer(elem->funcs, NULL);
 }
-- 
1.6.2.5

