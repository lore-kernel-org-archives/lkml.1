Return-Path: <linux-kernel-owner+w=401wt.eu-S1757235AbZGPCzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235AbZGPCzI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 22:55:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757185AbZGPCzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 22:55:07 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50563 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757178AbZGPCzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 22:55:06 -0400
Message-ID: <4A5E962E.9020900@cn.fujitsu.com>
Date: Thu, 16 Jul 2009 10:53:34 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 1/2] tracing/events: add missing type info of dynamic arrays
References: <4A5E9604.2030103@cn.fujitsu.com>
In-Reply-To: <4A5E9604.2030103@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The format file doesn't contain enough information for
__dynamic_array/__string. The type name is missing.

Before:
  # cat format:
  name: irq_handler_entry
  ...
          field:__data_loc name;  offset:16;      size:2;

After:
  # cat format:
  name: irq_handler_entry
  ...
          field:__data_loc char[] name;  offset:16;      size:2;

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/trace/ftrace.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 1867553..cc78943 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
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
 
-- 1.6.3 
