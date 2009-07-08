Return-Path: <linux-kernel-owner+w=401wt.eu-S1757725AbZGHHKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757725AbZGHHKr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 03:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753163AbZGHHKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 03:10:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64278 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753251AbZGHHKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 03:10:38 -0400
Message-ID: <4A544692.6010000@cn.fujitsu.com>
Date: Wed, 08 Jul 2009 15:11:14 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [Patch] tracing: fix missed type name
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


events/SYSTEM/TP/format does not contain enough
information for __dynamic_array or __string. It misses
the type name.

__data_loc ITEM  ==> __data_loc TYPE[] ITEM

Then "__data_loc" is a storage modifier like "register" or "static".

Two additional fixes, it's also important for user.

__data_loc [TYPE] ==> __data_loc TYPE[]

TYPE ITEM[LEN] ==> TYPE[LEN] ITEM

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 1867553..8df5b20 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -111,7 +111,7 @@
 
 #undef __array
 #define __array(type, item, len)						\
-	ret = trace_seq_printf(s, "\tfield:" #type " " #item "[" #len "];\t"	\
+	ret = trace_seq_printf(s, "\tfield:" #type "[" #len "] " #item ";\t"	\
 			       "offset:%u;\tsize:%u;\n",		\
 			       (unsigned int)offsetof(typeof(field), item), \
 			       (unsigned int)sizeof(field.item));	\
@@ -120,7 +120,7 @@
 
 #undef __dynamic_array
 #define __dynamic_array(type, item, len)				       \
-	ret = trace_seq_printf(s, "\tfield:__data_loc " #item ";\t"	       \
+	ret = trace_seq_printf(s, "\tfield:__data_loc " #type "[] " #item ";\t"\
 			       "offset:%u;\tsize:%u;\n",		       \
 			       (unsigned int)offsetof(typeof(field),	       \
 					__data_loc_##item),		       \
@@ -279,7 +279,7 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 
 #undef __dynamic_array
 #define __dynamic_array(type, item, len)				       \
-	ret = trace_define_field(event_call, "__data_loc" "[" #type "]", #item,\
+	ret = trace_define_field(event_call, "__data_loc " #type "[]", #item,  \
 				offsetof(typeof(field), __data_loc_##item),    \
 				 sizeof(field.__data_loc_##item), 0);
 


