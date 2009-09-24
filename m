Return-Path: <linux-kernel-owner+w=401wt.eu-S1753683AbZIXOnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683AbZIXOnV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 10:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753661AbZIXOnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 10:43:18 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:48240 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753646AbZIXOnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 10:43:15 -0400
Message-Id: <20090924133400.830759403@polymtl.ca>
References: <20090924132626.485545323@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 24 Sep 2009 09:26:38 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [patch 12/12] Tracepoints - Immediate Values
Content-Disposition: inline; filename=tracepoints-immediate-values.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu, 24 Sep 2009 14:07:33 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use immediate values in tracepoints.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: 'Peter Zijlstra' <peterz@infradead.org>
CC: "Frank Ch. Eigler" <fche@redhat.com>
CC: 'Ingo Molnar' <mingo@elte.hu>
CC: 'Hideo AOKI' <haoki@redhat.com>
CC: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
CC: 'Steven Rostedt' <rostedt@goodmis.org>
---
 include/linux/tracepoint.h |   33 +++++++++++++++++++++++++++------
 kernel/tracepoint.c        |   14 +++++++++-----
 2 files changed, 36 insertions(+), 11 deletions(-)

Index: linux.trees.git/include/linux/tracepoint.h
===================================================================
--- linux.trees.git.orig/include/linux/tracepoint.h	2009-09-24 08:52:55.000000000 -0400
+++ linux.trees.git/include/linux/tracepoint.h	2009-09-24 09:05:29.000000000 -0400
@@ -14,6 +14,7 @@
  * See the file COPYING for more details.
  */
 
+#include <linux/immediate.h>
 #include <linux/types.h>
 #include <linux/rcupdate.h>
 
@@ -22,7 +23,7 @@ struct tracepoint;
 
 struct tracepoint {
 	const char *name;		/* Tracepoint name */
-	int state;			/* State. */
+	DEFINE_IMV(char, state);	/* State. */
 	void (*regfunc)(void);
 	void (*unregfunc)(void);
 	void **funcs;
@@ -58,18 +59,38 @@ struct tracepoint {
 		rcu_read_unlock_sched_notrace();			\
 	} while (0)
 
+#define __CHECK_TRACE(name, generic, proto, args)			\
+	do {								\
+		if (!generic) {						\
+			if (unlikely(imv_read(__tracepoint_##name.state))) \
+				__DO_TRACE(&__tracepoint_##name,	\
+					TP_PROTO(proto), TP_ARGS(args));\
+		} else {						\
+			if (unlikely(_imv_read(__tracepoint_##name.state))) \
+				__DO_TRACE(&__tracepoint_##name,	\
+					TP_PROTO(proto), TP_ARGS(args));\
+		}							\
+	} while (0)
+
 /*
  * Make sure the alignment of the structure in the __tracepoints section will
  * not add unwanted padding between the beginning of the section and the
  * structure. Force alignment to the same alignment as the section start.
+ *
+ * The "generic" argument, passed to the declared __trace_##name inline
+ * function controls which tracepoint enabling mechanism must be used.
+ * If generic is true, a variable read is used.
+ * If generic is false, immediate values are used.
  */
 #define DECLARE_TRACE(name, proto, args)				\
 	extern struct tracepoint __tracepoint_##name;			\
 	static inline void trace_##name(proto)				\
 	{								\
-		if (unlikely(__tracepoint_##name.state))		\
-			__DO_TRACE(&__tracepoint_##name,		\
-				TP_PROTO(proto), TP_ARGS(args));	\
+		__CHECK_TRACE(name, 0, TP_PROTO(proto), TP_ARGS(args));	\
+	}								\
+	static inline void _trace_##name(proto)				\
+	{								\
+		__CHECK_TRACE(name, 1, TP_PROTO(proto), TP_ARGS(args));	\
 	}								\
 	static inline int register_trace_##name(void (*probe)(proto))	\
 	{								\
@@ -101,10 +122,10 @@ extern void tracepoint_update_probe_rang
 
 #else /* !CONFIG_TRACEPOINTS */
 #define DECLARE_TRACE(name, proto, args)				\
-	static inline void _do_trace_##name(struct tracepoint *tp, proto) \
-	{ }								\
 	static inline void trace_##name(proto)				\
 	{ }								\
+	static inline void _trace_##name(proto)				\
+	{ }								\
 	static inline int register_trace_##name(void (*probe)(proto))	\
 	{								\
 		return -ENOSYS;						\
Index: linux.trees.git/kernel/tracepoint.c
===================================================================
--- linux.trees.git.orig/kernel/tracepoint.c	2009-09-24 08:52:55.000000000 -0400
+++ linux.trees.git/kernel/tracepoint.c	2009-09-24 09:11:13.000000000 -0400
@@ -25,6 +25,7 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/immediate.h>
 
 extern struct tracepoint __start___tracepoints[];
 extern struct tracepoint __stop___tracepoints[];
@@ -243,9 +244,9 @@ static void set_tracepoint(struct tracep
 {
 	WARN_ON(strcmp((*entry)->name, elem->name) != 0);
 
-	if (elem->regfunc && !elem->state && active)
+	if (elem->regfunc && !_imv_read(elem->state) && active)
 		elem->regfunc();
-	else if (elem->unregfunc && elem->state && !active)
+	else if (elem->unregfunc && _imv_read(elem->state) && !active)
 		elem->unregfunc();
 
 	/*
@@ -256,7 +257,7 @@ static void set_tracepoint(struct tracep
 	 * is used.
 	 */
 	rcu_assign_pointer(elem->funcs, (*entry)->funcs);
-	elem->state = active;
+	elem->state__imv = active;
 }
 
 /*
@@ -267,10 +268,10 @@ static void set_tracepoint(struct tracep
  */
 static void disable_tracepoint(struct tracepoint *elem)
 {
-	if (elem->unregfunc && elem->state)
+	if (elem->unregfunc && _imv_read(elem->state))
 		elem->unregfunc();
 
-	elem->state = 0;
+	elem->state__imv = 0;
 	rcu_assign_pointer(elem->funcs, NULL);
 }
 
@@ -313,6 +314,9 @@ static void tracepoint_update_probes(voi
 		__stop___tracepoints);
 	/* tracepoints in modules. */
 	module_update_tracepoints();
+	/* Update immediate values */
+	core_imv_update();
+	module_imv_update();
 }
 
 static void *tracepoint_add_probe(const char *name, void *probe)

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
