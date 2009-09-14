Return-Path: <linux-kernel-owner+w=401wt.eu-S1754131AbZINH4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbZINH4I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 03:56:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750915AbZINH4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 03:56:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63035 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbZINH4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 03:56:07 -0400
Message-ID: <4AADF6CC.1060809@cn.fujitsu.com>
Date: Mon, 14 Sep 2009 15:54:52 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] ftrace: Add compile-time check on F_printk()
References: <4AADF60B.5070407@cn.fujitsu.com>
In-Reply-To: <4AADF60B.5070407@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure F_printk() has corrent format and args, and make sure
changes in F_STRUCT() won't break F_printk().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace_export.c |   45 +++++++++++++++++++++++++++++++++++++++---
 1 files changed, 41 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index 4cb29d8..26e52df 100644
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
1.6.3

