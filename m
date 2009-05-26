Return-Path: <linux-kernel-owner+w=401wt.eu-S1752411AbZEZEDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411AbZEZEDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 00:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750822AbZEZEDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 00:03:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57054 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751145AbZEZEDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 00:03:04 -0400
Message-ID: <4A1B6A4C.3070407@cn.fujitsu.com>
Date: Tue, 26 May 2009 12:04:28 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Steven Whitehouse <swhiteho@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jeff Moyer <jmoyer@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/2] tracing/events: make __string() more general
References: <4A1B6A2F.2040703@cn.fujitsu.com>
In-Reply-To: <4A1B6A2F.2040703@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes __string(..., src) to __string(..., len), thus makes it more
general, and then block TRACE_EVENT() can use it.

Also introduce __fetch_str(), which is used in TP_assign() and returns
the address of the string, while __get_str() is used in TP_print().

[ Impact: TRACE_EVENT api change ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/trace/events/irq.h     |   12 ++++++------
 include/trace/events/lockdep.h |    8 ++++----
 include/trace/ftrace.h         |   21 +++++++++++++--------
 3 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
index 32a9f7e..ce2b939 100644
--- a/include/trace/events/irq.h
+++ b/include/trace/events/irq.h
@@ -25,8 +25,8 @@ TRACE_EVENT(irq_handler_entry,
 	TP_ARGS(irq, action),
 
 	TP_STRUCT__entry(
-		__field(	int,	irq		)
-		__string(	name,	action->name	)
+		__field(	int,	irq			)
+		__string(	name,	strlen(action->name)	)
 	),
 
 	TP_fast_assign(
@@ -86,8 +86,8 @@ TRACE_EVENT(softirq_entry,
 	TP_ARGS(h, vec),
 
 	TP_STRUCT__entry(
-		__field(	int,	vec			)
-		__string(	name,	softirq_to_name[h-vec]	)
+		__field(	int,	vec				)
+		__string(	name,	strlen(softirq_to_name[h-vec])	)
 	),
 
 	TP_fast_assign(
@@ -116,8 +116,8 @@ TRACE_EVENT(softirq_exit,
 	TP_ARGS(h, vec),
 
 	TP_STRUCT__entry(
-		__field(	int,	vec			)
-		__string(	name,	softirq_to_name[h-vec]	)
+		__field(	int,	vec				)
+		__string(	name,	strlen(softirq_to_name[h-vec])	)
 	),
 
 	TP_fast_assign(
diff --git a/include/trace/events/lockdep.h b/include/trace/events/lockdep.h
index 0e956c9..e6218fd 100644
--- a/include/trace/events/lockdep.h
+++ b/include/trace/events/lockdep.h
@@ -19,7 +19,7 @@ TRACE_EVENT(lock_acquire,
 
 	TP_STRUCT__entry(
 		__field(unsigned int, flags)
-		__string(name, lock->name)
+		__string(name, strlen(lock->name))
 	),
 
 	TP_fast_assign(
@@ -39,7 +39,7 @@ TRACE_EVENT(lock_release,
 	TP_ARGS(lock, nested, ip),
 
 	TP_STRUCT__entry(
-		__string(name, lock->name)
+		__string(name, strlen(lock->name))
 	),
 
 	TP_fast_assign(
@@ -58,7 +58,7 @@ TRACE_EVENT(lock_contended,
 	TP_ARGS(lock, ip),
 
 	TP_STRUCT__entry(
-		__string(name, lock->name)
+		__string(name, strlen(lock->name))
 	),
 
 	TP_fast_assign(
@@ -74,7 +74,7 @@ TRACE_EVENT(lock_acquired,
 	TP_ARGS(lock, ip, waittime),
 
 	TP_STRUCT__entry(
-		__string(name, lock->name)
+		__string(name, strlen(lock->name))
 		__field(unsigned long, wait_usec)
 		__field(unsigned long, wait_nsec_rem)
 	),
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index b5ff2e8..430f7d2 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -25,7 +25,7 @@
 #define __field(type, item)		type	item;
 
 #undef __string
-#define __string(item, src)		unsigned short	__str_loc_##item;
+#define __string(item, len)		unsigned short	__str_loc_##item;
 
 #undef TP_STRUCT__entry
 #define TP_STRUCT__entry(args...) args
@@ -66,7 +66,7 @@
 #define __field(type, item);
 
 #undef __string
-#define __string(item, src)	int item;
+#define __string(item, len)	int item;
 
 #undef TRACE_EVENT
 #define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
@@ -186,7 +186,7 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 		return 0;
 
 #undef __string
-#define __string(item, src)						       \
+#define __string(item, len)						       \
 	ret = trace_seq_printf(s, "\tfield: __str_loc " #item ";\t"	       \
 			       "offset:%u;tsize:%u;\n",			       \
 			       (unsigned int)offsetof(typeof(field),	       \
@@ -239,7 +239,7 @@ ftrace_format_##call(struct trace_seq *s)				\
 		return ret;
 
 #undef __string
-#define __string(item, src)						       \
+#define __string(item, len)						       \
 	ret = trace_define_field(event_call, "__str_loc", #item,	       \
 				offsetof(typeof(field), __str_loc_##item),     \
 				 sizeof(field.__str_loc_##item), 0);
@@ -411,10 +411,15 @@ static void ftrace_profile_disable_##call(struct ftrace_event_call *call) \
 #define __array(type, item, len)
 
 #undef __string
-#define __string(item, src)						       \
-	__str_offsets.item = __str_size +				       \
-			     offsetof(typeof(*entry), __str_data);	       \
-	__str_size += strlen(src) + 1;
+#define __string(item, len)						 \
+	__str_offsets.item = __str_size +				 \
+			     offsetof(typeof(*entry), __str_data);	 \
+	__str_size += (len) + 1;
+
+#undef __fetch_str
+#define __fetch_str(dst)						\
+	({__entry->__str_loc_##dst = __str_offsets.dst;			\
+	__get_str(dst);})
 
 #undef __assign_str
 #define __assign_str(dst, src)						\
-- 
1.5.4.rc3


