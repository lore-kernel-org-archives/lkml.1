Return-Path: <linux-kernel-owner+w=401wt.eu-S1759116AbYFTREx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759116AbYFTREx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 13:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756346AbYFTREp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 13:04:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756032AbYFTREo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 13:04:44 -0400
Message-ID: <485BE2C4.5050101@redhat.com>
Date: Fri, 20 Jun 2008 13:03:00 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>
CC: Hideo AOKI <haoki@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: [RFC][Patch 1/2] markers: introduce DEFINE_TRACE for regular kernel
 markers
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I wrote a DEFINE_TRACE patch according to my suggestion. Users can still
use _trace_mark/trace_mark macro for their module.

This patch introduces DEFINE_TRACE() and _DEFINE_TRACE() macros for defining
inline functions which wraps trace_mark() and hides the fmt string.
These macros only for in-kernel regular markers, not for user-defined
markers.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
---
TODO:
- DEFINE_TRACE might better define 'trace_##name' marker instead of 'name'
 for avoiding conflict of marker names.

 include/linux/marker.h |   41 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 39 insertions(+), 2 deletions(-)

Index: 2.6.26-rc5-mm3/include/linux/marker.h
===================================================================
--- 2.6.26-rc5-mm3.orig/include/linux/marker.h	2008-06-16 12:27:50.000000000 -0400
+++ 2.6.26-rc5-mm3/include/linux/marker.h	2008-06-16 12:27:50.000000000 -0400
@@ -63,7 +63,7 @@ struct marker {
  * If generic is true, a variable read is used.
  * If generic is false, immediate values are used.
  */
-#define __trace_mark(generic, name, call_private, format, args...)	\
+#define ___trace_mark(generic, name, call_private, format, args...)	\
 	do {								\
 		static const char __mstrtab_##name[]			\
 		__attribute__((section("__markers_strings")))		\
@@ -73,13 +73,18 @@ struct marker {
 		{ __mstrtab_##name, &__mstrtab_##name[sizeof(#name)],	\
 		0, 0, marker_probe_cb,					\
 		{ __mark_empty_function, NULL}, NULL };			\
-		__mark_check_format(format, ## args);			\
 		if (unlikely(__mark_##name.state)) {			\
 			(*__mark_##name.call)				\
 				(&__mark_##name, call_private, ## args);\
 		}							\
 	} while (0)

+#define __trace_mark(generic, name, call_private, format, args...)	\
+	do {								\
+		__mark_check_format(format, ## args);			\
+		___trace_mark(generic, name, call_private, format, ## args); \
+	} while (0)
+
 extern void marker_update_probe_range(struct marker *begin,
 	struct marker *end);
 #else /* !CONFIG_MARKERS */
@@ -121,6 +126,38 @@ static inline void marker_update_probe_r
  */
 #define MARK_NOARGS " "

+/**
+ * DEFINE_TRACE - define a regular kernel trace point with code patching
+ * @name: marker name, not quoted.
+ * @vargs: parenthetical virtual arguments with types.
+ * @args: real arguments, not parenthetical.
+ *
+ * Define an inline function named trace_##name for regular kernel trace point.
+ * If the trace point has no arguments, set vargs to (void).
+ */
+#define DEFINE_TRACE(name, vargs, args...)		\
+static inline void trace_##name vargs			\
+{							\
+	___trace_mark(0, name, NULL, #vargs, ##args);	\
+}
+/**
+ * _DEFINE_TRACE - define a regular kernel trace point with variable read
+ * @name: marker name, not quoted.
+ * @vargs: parenthetical virtual arguments with types.
+ * @args: real arguments, not parenthetical.
+ *
+ * Define an inline function named trace_##name for regular kernel trace point.
+ * If the trace point has no arguments, set vargs to (void).
+ * Should be used for trace points in code paths where instruction
+ * modification based enabling is not welcome. (__init and __exit
+ * functions, lockdep, some traps, printk).
+ */
+#define _DEFINE_TRACE(name, vargs, args...)		\
+static inline void trace_##name vargs			\
+{							\
+	___trace_mark(1, name, NULL, #vargs, ##args);	\
+}
+
 /* To be used for string format validity checking with gcc */
 static inline void __printf(1, 2) ___mark_check_format(const char *fmt, ...)
 {
-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

