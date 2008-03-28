Return-Path: <linux-kernel-owner+w=401wt.eu-S1754591AbYC1BCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbYC1BCf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 21:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753273AbYC1BC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 21:02:27 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:48923 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753305AbYC1BC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 21:02:26 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AisFAO/f60dMQWoK/2dsb2JhbACBWqlughc
Date: Thu, 27 Mar 2008 21:02:24 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Markers - remove extra format argument
Message-ID: <20080328010223.GA8186@Krystal>
References: <20080327132057.449831367@polymtl.ca> <200803280101.30026.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <200803280101.30026.vda.linux@googlemail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 20:39:01 up 27 days, 20:49,  6 users,  load average: 0.21, 0.40,
	0.50
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denys Vlasenko <vda.linux@googlemail.com> :

> Not in this patch, but I noticed:
> 
> #define __trace_mark(name, call_private, format, args...)               \
>         do {                                                            \
>                 static const char __mstrtab_##name[]                    \
>                 __attribute__((section("__markers_strings")))           \
>                 = #name "\0" format;                                    \
>                 static struct marker __mark_##name                      \
>                 __attribute__((section("__markers"), aligned(8))) =     \
>                 { __mstrtab_##name, &__mstrtab_##name[sizeof(#name)],   \
>                 0, 0, marker_probe_cb,                                  \
>                 { __mark_empty_function, NULL}, NULL };                 \
>                 __mark_check_format(format, ## args);                   \
>                 if (unlikely(__mark_##name.state)) {                    \
>                         (*__mark_##name.call)                           \
>                                 (&__mark_##name, call_private,          \
>                                 format, ## args);                       \
>                 }                                                       \
>         } while (0)
> 
> In this call:
> 
>                         (*__mark_##name.call)                           \
>                                 (&__mark_##name, call_private,          \
>                                 format, ## args);                       \
> 
> you make gcc allocate duplicate format string. You can use
> &__mstrtab_##name[sizeof(#name)] instead since it holds the same string,
> or drop ", format," above and "const char *fmt" from here:
> 
>         void (*call)(const struct marker *mdata,        /* Probe wrapper */
>                 void *call_private, const char *fmt, ...);
> 
> since mdata->format is the same and all callees which need it can take it there.

Very good point. I actually thought about dropping it, since it would
remove an unnecessary argument from the stack. And actually, since I now
have the marker_probe_cb sitting between the marker site and the
callbacks, there is no API change required. Thanks :)

Mathieu

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Denys Vlasenko <vda.linux@googlemail.com>
---
 include/linux/marker.h |   11 +++++------
 kernel/marker.c        |   30 ++++++++++++++----------------
 2 files changed, 19 insertions(+), 22 deletions(-)

Index: linux-2.6-lttng/include/linux/marker.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/marker.h	2008-03-27 20:51:34.000000000 -0400
+++ linux-2.6-lttng/include/linux/marker.h	2008-03-27 20:54:55.000000000 -0400
@@ -44,8 +44,8 @@ struct marker {
 				 */
 	char state;		/* Marker state. */
 	char ptype;		/* probe type : 0 : single, 1 : multi */
-	void (*call)(const struct marker *mdata,	/* Probe wrapper */
-		void *call_private, const char *fmt, ...);
+				/* Probe wrapper */
+	void (*call)(const struct marker *mdata, void *call_private, ...);
 	struct marker_probe_closure single;
 	struct marker_probe_closure *multi;
 } __attribute__((aligned(8)));
@@ -72,8 +72,7 @@ struct marker {
 		__mark_check_format(format, ## args);			\
 		if (unlikely(__mark_##name.state)) {			\
 			(*__mark_##name.call)				\
-				(&__mark_##name, call_private,		\
-				format, ## args);			\
+				(&__mark_##name, call_private, ## args);\
 		}							\
 	} while (0)
 
@@ -117,9 +116,9 @@ static inline void __printf(1, 2) ___mar
 extern marker_probe_func __mark_empty_function;
 
 extern void marker_probe_cb(const struct marker *mdata,
-	void *call_private, const char *fmt, ...);
+	void *call_private, ...);
 extern void marker_probe_cb_noarg(const struct marker *mdata,
-	void *call_private, const char *fmt, ...);
+	void *call_private, ...);
 
 /*
  * Connect a probe to a marker.
Index: linux-2.6-lttng/kernel/marker.c
===================================================================
--- linux-2.6-lttng.orig/kernel/marker.c	2008-03-27 20:52:09.000000000 -0400
+++ linux-2.6-lttng/kernel/marker.c	2008-03-27 20:56:13.000000000 -0400
@@ -54,8 +54,8 @@ static DEFINE_MUTEX(markers_mutex);
 struct marker_entry {
 	struct hlist_node hlist;
 	char *format;
-	void (*call)(const struct marker *mdata,	/* Probe wrapper */
-		void *call_private, const char *fmt, ...);
+			/* Probe wrapper */
+	void (*call)(const struct marker *mdata, void *call_private, ...);
 	struct marker_probe_closure single;
 	struct marker_probe_closure *multi;
 	int refcount;	/* Number of times armed. 0 if disarmed. */
@@ -90,15 +90,13 @@ EXPORT_SYMBOL_GPL(__mark_empty_function)
  * marker_probe_cb Callback that prepares the variable argument list for probes.
  * @mdata: pointer of type struct marker
  * @call_private: caller site private data
- * @fmt: format string
  * @...:  Variable argument list.
  *
  * Since we do not use "typical" pointer based RCU in the 1 argument case, we
  * need to put a full smp_rmb() in this branch. This is why we do not use
  * rcu_dereference() for the pointer read.
  */
-void marker_probe_cb(const struct marker *mdata, void *call_private,
-	const char *fmt, ...)
+void marker_probe_cb(const struct marker *mdata, void *call_private, ...)
 {
 	va_list args;
 	char ptype;
@@ -119,8 +117,9 @@ void marker_probe_cb(const struct marker
 		/* Must read the ptr before private data. They are not data
 		 * dependant, so we put an explicit smp_rmb() here. */
 		smp_rmb();
-		va_start(args, fmt);
-		func(mdata->single.probe_private, call_private, fmt, &args);
+		va_start(args, call_private);
+		func(mdata->single.probe_private, call_private, mdata->format,
+			&args);
 		va_end(args);
 	} else {
 		struct marker_probe_closure *multi;
@@ -135,9 +134,9 @@ void marker_probe_cb(const struct marker
 		smp_read_barrier_depends();
 		multi = mdata->multi;
 		for (i = 0; multi[i].func; i++) {
-			va_start(args, fmt);
-			multi[i].func(multi[i].probe_private, call_private, fmt,
-				&args);
+			va_start(args, call_private);
+			multi[i].func(multi[i].probe_private, call_private,
+				mdata->format, &args);
 			va_end(args);
 		}
 	}
@@ -149,13 +148,11 @@ EXPORT_SYMBOL_GPL(marker_probe_cb);
  * marker_probe_cb Callback that does not prepare the variable argument list.
  * @mdata: pointer of type struct marker
  * @call_private: caller site private data
- * @fmt: format string
  * @...:  Variable argument list.
  *
  * Should be connected to markers "MARK_NOARGS".
  */
-void marker_probe_cb_noarg(const struct marker *mdata,
-	void *call_private, const char *fmt, ...)
+void marker_probe_cb_noarg(const struct marker *mdata, void *call_private, ...)
 {
 	va_list args;	/* not initialized */
 	char ptype;
@@ -171,7 +168,8 @@ void marker_probe_cb_noarg(const struct 
 		/* Must read the ptr before private data. They are not data
 		 * dependant, so we put an explicit smp_rmb() here. */
 		smp_rmb();
-		func(mdata->single.probe_private, call_private, fmt, &args);
+		func(mdata->single.probe_private, call_private, mdata->format,
+			&args);
 	} else {
 		struct marker_probe_closure *multi;
 		int i;
@@ -185,8 +183,8 @@ void marker_probe_cb_noarg(const struct 
 		smp_read_barrier_depends();
 		multi = mdata->multi;
 		for (i = 0; multi[i].func; i++)
-			multi[i].func(multi[i].probe_private, call_private, fmt,
-				&args);
+			multi[i].func(multi[i].probe_private, call_private,
+				mdata->format, &args);
 	}
 	preempt_enable();
 }

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
