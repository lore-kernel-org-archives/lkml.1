Return-Path: <linux-kernel-owner+w=401wt.eu-S1759229AbZIQHro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759229AbZIQHro (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 03:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757383AbZIQHrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 03:47:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:48468 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756509AbZIQHrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 03:47:42 -0400
Date: Thu, 17 Sep 2009 07:47:12 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, lizf@cn.fujitsu.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <4AADF6CC.1060809@cn.fujitsu.com>
References: <4AADF6CC.1060809@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] ftrace: add compile-time check on F_printk()
Message-ID: <tip-05ffa2d02066c2cb169c02d5417308ee8ecab638@git.kernel.org>
Git-Commit-ID: 05ffa2d02066c2cb169c02d5417308ee8ecab638
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 17 Sep 2009 07:47:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  05ffa2d02066c2cb169c02d5417308ee8ecab638
Gitweb:     http://git.kernel.org/tip/05ffa2d02066c2cb169c02d5417308ee8ecab638
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Mon, 14 Sep 2009 15:54:52 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 14 Sep 2009 11:42:10 -0400

ftrace: add compile-time check on F_printk()

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
 
 
