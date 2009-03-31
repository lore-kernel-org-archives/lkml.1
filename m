Return-Path: <linux-kernel-owner+w=401wt.eu-S1761766AbZCaFtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761766AbZCaFtc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 01:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757487AbZCaFtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 01:49:21 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:45171 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582AbZCaFtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 01:49:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=sTCfqvjxkxHknyJfvzLLRmEUVS3Rbl9A3unrq2rayfzGZGSoI2EJRhxWNLWo973bdh
         dYgWULnih1kufMLvTpPHUPKLvSht4b/sIXzTCbVvpJ0qohgU58vp16LiLkd3Kdsjt69u
         3d4ZxS7auKMq3+JSCqmsrxA741lAws+sqWPV0=
Subject: [PATCH] tracing/filters: add TRACE_EVENT_FORMAT_NOFILTER event
 macro
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       fweisbec@gmail.com
Content-Type: text/plain
Date: Tue, 31 Mar 2009 00:49:16 -0500
Message-Id: <1238478556.6749.14.camel@bookworm>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker suggested that the trace_special event shouldn't be
filterable; this patch adds a TRACE_EVENT_FORMAT_NOFILTER event macro
that allows an event format to be exported without having a filter
attached, and removes filtering from the trace_special event.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>

---
 kernel/trace/trace.c             |    2 --
 kernel/trace/trace.h             |    2 ++
 kernel/trace/trace_event_types.h |    2 +-
 kernel/trace/trace_export.c      |   33 +++++++++++++++++++++++++++++++++
 4 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 39b5de1..5e4163d 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1064,7 +1064,6 @@ ftrace_trace_special(void *__tr,
 		     unsigned long arg1, unsigned long arg2, unsigned long arg3,
 		     int pc)
 {
-	struct ftrace_event_call *call = &event_special;
 	struct ring_buffer_event *event;
 	struct trace_array *tr = __tr;
 	struct special_entry *entry;
@@ -1077,7 +1076,6 @@ ftrace_trace_special(void *__tr,
 	entry->arg1			= arg1;
 	entry->arg2			= arg2;
 	entry->arg3			= arg3;
-	filter_check_discard(call, entry, event);
 	trace_buffer_unlock_commit(tr, event, 0, pc);
 }
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index f56c628..0d2973c 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -909,6 +909,8 @@ do {									\
 #undef TRACE_EVENT_FORMAT
 #define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
 	extern struct ftrace_event_call event_##call;
+#undef TRACE_EVENT_FORMAT_NOFILTER
+#define TRACE_EVENT_FORMAT_NOFILTER(call, proto, args, fmt, tstruct, tpfmt)
 #include "trace_event_types.h"
 
 #endif /* _LINUX_KERNEL_TRACE_H */
diff --git a/kernel/trace/trace_event_types.h b/kernel/trace/trace_event_types.h
index 95b147a..cfcecc4 100644
--- a/kernel/trace/trace_event_types.h
+++ b/kernel/trace/trace_event_types.h
@@ -57,7 +57,7 @@ TRACE_EVENT_FORMAT(context_switch, TRACE_CTX, ctx_switch_entry, ignore,
 	TP_RAW_FMT("%u:%u:%u  ==+ %u:%u:%u [%03u]")
 );
 
-TRACE_EVENT_FORMAT(special, TRACE_SPECIAL, special_entry, ignore,
+TRACE_EVENT_FORMAT_NOFILTER(special, TRACE_SPECIAL, special_entry, ignore,
 	TRACE_STRUCT(
 		TRACE_FIELD(unsigned long, arg1, arg1)
 		TRACE_FIELD(unsigned long, arg2, arg2)
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index 47989be..a16a29d 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -65,6 +65,22 @@ ftrace_format_##call(struct trace_seq *s)				\
 	return ret;							\
 }
 
+#undef TRACE_EVENT_FORMAT_NOFILTER
+#define TRACE_EVENT_FORMAT_NOFILTER(call, proto, args, fmt, tstruct,	\
+				    tpfmt)				\
+static int								\
+ftrace_format_##call(struct trace_seq *s)				\
+{									\
+	struct args field;						\
+	int ret;							\
+									\
+	tstruct;							\
+									\
+	trace_seq_printf(s, "\nprint fmt: \"%s\"\n", tpfmt);		\
+									\
+	return ret;							\
+}
+
 #include "trace_event_types.h"
 
 #undef TRACE_ZERO_CHAR
@@ -109,6 +125,19 @@ static int ftrace_raw_init_event_##call(void)				\
 	return 0;							\
 }									\
 
+#undef TRACE_EVENT_FORMAT_NOFILTER
+#define TRACE_EVENT_FORMAT_NOFILTER(call, proto, args, fmt, tstruct,	\
+				    tpfmt)				\
+									\
+struct ftrace_event_call __used						\
+__attribute__((__aligned__(4)))						\
+__attribute__((section("_ftrace_events"))) event_##call = {		\
+	.name			= #call,				\
+	.id			= proto,				\
+	.system			= __stringify(TRACE_SYSTEM),		\
+	.show_format		= ftrace_format_##call,			\
+};
+
 #include "trace_event_types.h"
 
 #undef TRACE_FIELD
@@ -150,4 +179,8 @@ ftrace_define_fields_##call(void)					\
 	return ret;							\
 }
 
+#undef TRACE_EVENT_FORMAT_NOFILTER
+#define TRACE_EVENT_FORMAT_NOFILTER(call, proto, args, fmt, tstruct,	\
+				    tpfmt)
+
 #include "trace_event_types.h"
-- 
1.5.6.3



