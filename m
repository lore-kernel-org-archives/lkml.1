Return-Path: <linux-kernel-owner+w=401wt.eu-S933866AbZHEITo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933866AbZHEITo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 04:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933768AbZHEITn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 04:19:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:38370 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933741AbZHEITi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 04:19:38 -0400
Date: Wed, 5 Aug 2009 08:19:13 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, lizf@cn.fujitsu.com, rostedt@goodmis.org,
       tglx@linutronix.de
In-Reply-To: <4A5E964A.9000403@cn.fujitsu.com>
References: <4A5E964A.9000403@cn.fujitsu.com>
Subject: [tip:tracing/core] tracing/events: record the size of dynamic arrays
Message-ID: <tip-7d536cb3fb9993bdcd5a2fbaa6b0670ded4e101c@git.kernel.org>
Git-Commit-ID: 7d536cb3fb9993bdcd5a2fbaa6b0670ded4e101c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 05 Aug 2009 08:19:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7d536cb3fb9993bdcd5a2fbaa6b0670ded4e101c
Gitweb:     http://git.kernel.org/tip/7d536cb3fb9993bdcd5a2fbaa6b0670ded4e101c
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Thu, 16 Jul 2009 10:54:02 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 20 Jul 2009 11:38:44 -0400

tracing/events: record the size of dynamic arrays

When a dynamic array is defined, we add __data_loc_foo in
trace_entry to record the offset of the array, but the
size of the array is not recorded, which causes 2 problems:

- the event filter just compares the first 2 chars of the strings.

- parsers can't parse dynamic arrays.

So we encode the size of each dynamic array in the higher 16 bits
of __data_loc_foo, while the offset is in lower 16 bits.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4A5E964A.9000403@cn.fujitsu.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


---
 include/trace/ftrace.h             |   14 ++++++++------
 kernel/trace/trace_events_filter.c |    6 ++++--
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index cc78943..3cbb96e 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -25,7 +25,7 @@
 #define __array(type, item, len)	type	item[len];
 
 #undef __dynamic_array
-#define __dynamic_array(type, item, len) unsigned short __data_loc_##item;
+#define __dynamic_array(type, item, len) u32 __data_loc_##item;
 
 #undef __string
 #define __string(item, src) __dynamic_array(char, item, -1)
@@ -51,13 +51,14 @@
  * Include the following:
  *
  * struct ftrace_data_offsets_<call> {
- *	int				<item1>;
- *	int				<item2>;
+ *	u32				<item1>;
+ *	u32				<item2>;
  *	[...]
  * };
  *
- * The __dynamic_array() macro will create each int <item>, this is
+ * The __dynamic_array() macro will create each u32 <item>, this is
  * to keep the offset of each array from the beginning of the event.
+ * The size of an array is also encoded, in the higher 16 bits of <item>.
  */
 
 #undef __field
@@ -67,7 +68,7 @@
 #define __array(type, item, len)
 
 #undef __dynamic_array
-#define __dynamic_array(type, item, len)	int item;
+#define __dynamic_array(type, item, len)	u32 item;
 
 #undef __string
 #define __string(item, src) __dynamic_array(char, item, -1)
@@ -207,7 +208,7 @@ ftrace_format_##call(struct trace_seq *s)				\
 
 #undef __get_dynamic_array
 #define __get_dynamic_array(field)	\
-		((void *)__entry + __entry->__data_loc_##field)
+		((void *)__entry + (__entry->__data_loc_##field & 0xffff))
 
 #undef __get_str
 #define __get_str(field) (char *)__get_dynamic_array(field)
@@ -325,6 +326,7 @@ ftrace_define_fields_##call(void)					\
 #define __dynamic_array(type, item, len)				\
 	__data_offsets->item = __data_size +				\
 			       offsetof(typeof(*entry), __data);	\
+	__data_offsets->item |= (len * sizeof(type)) << 16;		\
 	__data_size += (len) * sizeof(type);
 
 #undef __string
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index b9aae72..1c80ef7 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -176,11 +176,13 @@ static int filter_pred_string(struct filter_pred *pred, void *event,
 static int filter_pred_strloc(struct filter_pred *pred, void *event,
 			      int val1, int val2)
 {
-	unsigned short str_loc = *(unsigned short *)(event + pred->offset);
+	u32 str_item = *(u32 *)(event + pred->offset);
+	int str_loc = str_item & 0xffff;
+	int str_len = str_item >> 16;
 	char *addr = (char *)(event + str_loc);
 	int cmp, match;
 
-	cmp = strncmp(addr, pred->str_val, pred->str_len);
+	cmp = strncmp(addr, pred->str_val, str_len);
 
 	match = (!cmp) ^ pred->not;
 
