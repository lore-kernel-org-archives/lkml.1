Return-Path: <linux-kernel-owner+w=401wt.eu-S1759411AbZCZPuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759411AbZCZPuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 11:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758457AbZCZPuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 11:50:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:57814 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757307AbZCZPuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 11:50:04 -0400
Message-Id: <20090326155001.579598235@goodmis.org>
References: <20090326154918.330439698@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 26 Mar 2009 11:49:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/2] tracing: add size checks for exported ftrace internal structures
Content-Disposition: inline; filename=0002-tracing-add-size-checks-for-exported-ftrace-interna.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The events exported by TRACE_EVENT are automated and are guaranteed
to be correct when used.

The internal ftrace sturctures on the other hand are more manually
exported. These require the ftrace maintainer to make sure they
are up to date.

This patch adds a size check to help flag when a type changes in
an internal ftrace data structure, and the update needs to be reflected
in the export.

If a export is incorrect, then the only harm is that the user space
tools will not know how to correctly read the internal structures of
ftrace.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_events.c |    3 +++
 kernel/trace/trace_export.c |    4 ++++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index d0f9968..4a1c1bc 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -341,8 +341,11 @@ event_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	return cnt;
 }
 
+extern char *__bad_type_size(void);
+
 #undef FIELD
 #define FIELD(type, name)						\
+	sizeof(type) != sizeof(field.name) ? __bad_type_size() :	\
 	#type, #name, offsetof(typeof(field), name), sizeof(field.name)
 
 static int trace_write_header(struct trace_seq *s)
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index 4d9952d..4ae01bc 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -19,8 +19,12 @@
 #undef TRACE_STRUCT
 #define TRACE_STRUCT(args...) args
 
+extern void __bad_type_size(void);
+
 #undef TRACE_FIELD
 #define TRACE_FIELD(type, item, assign)					\
+	if (sizeof(type) != sizeof(field.item))				\
+		__bad_type_size();					\
 	ret = trace_seq_printf(s, "\tfield:" #type " " #item ";\t"	\
 			       "offset:%u;\tsize:%u;\n",		\
 			       (unsigned int)offsetof(typeof(field), item), \
-- 
1.6.2

-- 
