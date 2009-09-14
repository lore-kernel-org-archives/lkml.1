Return-Path: <linux-kernel-owner+w=401wt.eu-S1756196AbZINQfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbZINQfa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 12:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756158AbZINQfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 12:35:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:53297 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389AbZINQee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 12:34:34 -0400
Message-Id: <20090914163436.980273278@goodmis.org>
References: <20090914163355.162375454@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 14 Sep 2009 12:33:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 4/6] ftrace: add compile-time check on F_printk()
Content-Disposition: inline; filename=0004-ftrace-add-compile-time-check-on-F_printk.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

Make sure F_printk() has corrent format and args, and make sure
changes in F_STRUCT() won't break F_printk().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4AADF6CC.1060809@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_export.c |   45 +++++++++++++++++++++++++++++++++++++++---
 1 files changed, 41 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index 4cb29d8..2435d55 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -23,6 +23,47 @@
 #define __field_struct(type, item)
 
 #undef __field
+#define __field(type, item)				type item;
+
+#undef __field_desc
+#define __field_desc(type, container, item)		type item;
+
+#undef __array
+#define __array(type, item, size)			type item[size];
+
+#undef __array_desc
+#define __array_desc(type, container, item, size)	type item[size];
+
+#undef __dynamic_array
+#define __dynamic_array(type, item)			type item[];
+
+#undef F_STRUCT
+#define F_STRUCT(args...)				args
+
+#undef F_printk
+#define F_printk(fmt, args...) fmt, args
+
+#undef FTRACE_ENTRY
+#define FTRACE_ENTRY(name, struct_name, id, tstruct, print)	\
+struct ____ftrace_##name {					\
+	tstruct							\
+};								\
+static void __used ____ftrace_check_##name(void)		\
+{								\
+	struct ____ftrace_##name *__entry = NULL;		\
+								\
+	/* force cmpile-time check on F_printk() */		\
+	printk(print);						\
+}
+
+#undef FTRACE_ENTRY_DUP
+#define FTRACE_ENTRY_DUP(name, struct_name, id, tstruct, print)	\
+	FTRACE_ENTRY(name, struct_name, id, PARAMS(tstruct), PARAMS(print))
+
+#include "trace_entries.h"
+
+
+#undef __field
 #define __field(type, item)						\
 	ret = trace_seq_printf(s, "\tfield:" #type " " #item ";\t"	\
 			       "offset:%zu;\tsize:%zu;\n",		\
@@ -88,10 +129,6 @@ ftrace_format_##name(struct ftrace_event_call *unused,			\
 	return ret;							\
 }
 
-#undef FTRACE_ENTRY_DUP
-#define FTRACE_ENTRY_DUP(name, struct_name, id, tstruct, print)	\
-	FTRACE_ENTRY(name, struct_name, id, PARAMS(tstruct), PARAMS(print))
-
 #include "trace_entries.h"
 
 
-- 
1.6.3.3

-- 
