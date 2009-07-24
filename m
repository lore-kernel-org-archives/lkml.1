Return-Path: <linux-kernel-owner+w=401wt.eu-S1753740AbZGXUD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740AbZGXUD2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 16:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753717AbZGXUDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 16:03:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55302 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753661AbZGXUDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 16:03:23 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip -v13 07/11] tracing: Introduce TRACE_FIELD_ZERO() macro
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Tom Zanussi <tzanussi@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Date: Fri, 24 Jul 2009 16:06:10 -0400
Message-ID: <20090724200610.25904.47397.stgit@localhost.localdomain>
In-Reply-To: <20090724200527.25904.2562.stgit@localhost.localdomain>
References: <20090724200527.25904.2562.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use TRACE_FIELD_ZERO(type, item) instead of TRACE_FIELD_ZERO_CHAR(item).
This also includes a fix of TRACE_ZERO_CHAR() macro.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---

 kernel/trace/trace_event_types.h |    4 ++--
 kernel/trace/trace_export.c      |   16 ++++++++--------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/trace_event_types.h b/kernel/trace/trace_event_types.h
index 6db005e..e74f090 100644
--- a/kernel/trace/trace_event_types.h
+++ b/kernel/trace/trace_event_types.h
@@ -109,7 +109,7 @@ TRACE_EVENT_FORMAT(bprint, TRACE_BPRINT, bprint_entry, ignore,
 	TRACE_STRUCT(
 		TRACE_FIELD(unsigned long, ip, ip)
 		TRACE_FIELD(char *, fmt, fmt)
-		TRACE_FIELD_ZERO_CHAR(buf)
+		TRACE_FIELD_ZERO(char, buf)
 	),
 	TP_RAW_FMT("%08lx (%d) fmt:%p %s")
 );
@@ -117,7 +117,7 @@ TRACE_EVENT_FORMAT(bprint, TRACE_BPRINT, bprint_entry, ignore,
 TRACE_EVENT_FORMAT(print, TRACE_PRINT, print_entry, ignore,
 	TRACE_STRUCT(
 		TRACE_FIELD(unsigned long, ip, ip)
-		TRACE_FIELD_ZERO_CHAR(buf)
+		TRACE_FIELD_ZERO(char, buf)
 	),
 	TP_RAW_FMT("%08lx (%d) fmt:%p %s")
 );
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index 7cee79d..23125b5 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -42,9 +42,9 @@ extern void __bad_type_size(void);
 	if (!ret)							\
 		return 0;
 
-#undef TRACE_FIELD_ZERO_CHAR
-#define TRACE_FIELD_ZERO_CHAR(item)					\
-	ret = trace_seq_printf(s, "\tfield:char " #item ";\t"		\
+#undef TRACE_FIELD_ZERO
+#define TRACE_FIELD_ZERO(type, item)					\
+	ret = trace_seq_printf(s, "\tfield:" #type " " #item ";\t"	\
 			       "offset:%u;\tsize:0;\n",			\
 			       (unsigned int)offsetof(typeof(field), item)); \
 	if (!ret)							\
@@ -90,9 +90,6 @@ ftrace_format_##call(struct ftrace_event_call *dummy, struct trace_seq *s)\
 
 #include "trace_event_types.h"
 
-#undef TRACE_ZERO_CHAR
-#define TRACE_ZERO_CHAR(arg)
-
 #undef TRACE_FIELD
 #define TRACE_FIELD(type, item, assign)\
 	entry->item = assign;
@@ -105,6 +102,9 @@ ftrace_format_##call(struct ftrace_event_call *dummy, struct trace_seq *s)\
 #define TRACE_FIELD_SIGN(type, item, assign, is_signed)	\
 	TRACE_FIELD(type, item, assign)
 
+#undef TRACE_FIELD_ZERO
+#define TRACE_FIELD_ZERO(type, item)
+
 #undef TP_CMD
 #define TP_CMD(cmd...)	cmd
 
@@ -176,8 +176,8 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 	if (ret)							\
 		return ret;
 
-#undef TRACE_FIELD_ZERO_CHAR
-#define TRACE_FIELD_ZERO_CHAR(item)
+#undef TRACE_FIELD_ZERO
+#define TRACE_FIELD_ZERO(type, item)
 
 #undef TRACE_EVENT_FORMAT
 #define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
