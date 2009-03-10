Return-Path: <linux-kernel-owner+w=401wt.eu-S1752146AbZCJE6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbZCJE6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 00:58:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbZCJE6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 00:58:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:49318 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbZCJE6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 00:58:13 -0400
Message-Id: <20090310045810.602528682@goodmis.org>
References: <20090310045710.286915983@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 10 Mar 2009 00:57:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "Martin J. Bligh" <mbligh@mbligh.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Larry Woodman <lwoodman@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/7] tracing: typecast sizeof and offsetof to unsigned int
Content-Disposition: inline; filename=0001-tracing-typecast-sizeof-and-offsetof-to-unsigned-in.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: fix compiler warnings

On x86_64 sizeof and offsetof are treated as long, where as on x86_32
they are int. This patch typecasts them to unsigned int to avoid
one arch giving warnings while the other does not.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_events.c |   15 ++++++++-------
 kernel/trace/trace_export.c |   10 +++++-----
 kernel/trace/trace_format.h |   12 ++++++------
 3 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 4488d90..fa32ca3 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -448,8 +448,9 @@ event_available_types_read(struct file *filp, char __user *ubuf, size_t cnt,
 }
 
 #undef FIELD
-#define FIELD(type, name) \
-	#type, #name, offsetof(typeof(field), name), sizeof(field.name)
+#define FIELD(type, name)						\
+	#type, #name, (unsigned int)offsetof(typeof(field), name),	\
+		(unsigned int)sizeof(field.name)
 
 static int trace_write_header(struct trace_seq *s)
 {
@@ -457,11 +458,11 @@ static int trace_write_header(struct trace_seq *s)
 
 	/* struct trace_entry */
 	return trace_seq_printf(s,
-				"\tfield:%s %s;\toffset:%lu;\tsize:%lu;\n"
-				"\tfield:%s %s;\toffset:%lu;\tsize:%lu;\n"
-				"\tfield:%s %s;\toffset:%lu;\tsize:%lu;\n"
-				"\tfield:%s %s;\toffset:%lu;\tsize:%lu;\n"
-				"\tfield:%s %s;\toffset:%lu;\tsize:%lu;\n"
+				"\tfield:%s %s;\toffset:%u;\tsize:%u;\n"
+				"\tfield:%s %s;\toffset:%u;\tsize:%u;\n"
+				"\tfield:%s %s;\toffset:%u;\tsize:%u;\n"
+				"\tfield:%s %s;\toffset:%u;\tsize:%u;\n"
+				"\tfield:%s %s;\toffset:%u;\tsize:%u;\n"
 				"\n",
 				FIELD(unsigned char, type),
 				FIELD(unsigned char, flags),
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index 0fb7be7..7162ab4 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -18,11 +18,11 @@
 #include "trace_format.h"
 
 #undef TRACE_FIELD_ZERO_CHAR
-#define TRACE_FIELD_ZERO_CHAR(item)				\
-	ret = trace_seq_printf(s, "\tfield: char " #item ";\t"	\
-			       "offset:%lu;\tsize:0;\n",	\
-			       offsetof(typeof(field), item));	\
-	if (!ret)						\
+#define TRACE_FIELD_ZERO_CHAR(item)					\
+	ret = trace_seq_printf(s, "\tfield: char " #item ";\t"		\
+			       "offset:%u;\tsize:0;\n",			\
+			       (unsigned int)offsetof(typeof(field), item)); \
+	if (!ret)							\
 		return 0;
 
 
diff --git a/kernel/trace/trace_format.h b/kernel/trace/trace_format.h
index 03f9a4c..97e59a9 100644
--- a/kernel/trace/trace_format.h
+++ b/kernel/trace/trace_format.h
@@ -22,9 +22,9 @@
 #undef TRACE_FIELD
 #define TRACE_FIELD(type, item, assign)					\
 	ret = trace_seq_printf(s, "\tfield:" #type " " #item ";\t"	\
-			       "offset:%lu;\tsize:%lu;\n",		\
-			       offsetof(typeof(field), item),		\
-			       sizeof(field.item));			\
+			       "offset:%u;\tsize:%u;\n",		\
+			       (unsigned int)offsetof(typeof(field), item), \
+			       (unsigned int)sizeof(field.item));	\
 	if (!ret)							\
 		return 0;
 
@@ -32,9 +32,9 @@
 #undef TRACE_FIELD_SPECIAL
 #define TRACE_FIELD_SPECIAL(type_item, item, cmd)			\
 	ret = trace_seq_printf(s, "\tfield special:" #type_item ";\t"	\
-			       "offset:%lu;\tsize:%lu;\n",		\
-			       offsetof(typeof(field), item),		\
-			       sizeof(field.item));			\
+			       "offset:%u;\tsize:%u;\n",		\
+			       (unsigned int)offsetof(typeof(field), item), \
+			       (unsigned int)sizeof(field.item));	\
 	if (!ret)							\
 		return 0;
 
-- 
1.6.1.3

-- 
