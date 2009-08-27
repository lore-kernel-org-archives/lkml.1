Return-Path: <linux-kernel-owner+w=401wt.eu-S1751368AbZH0Kmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751368AbZH0Kmk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 06:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751163AbZH0Kmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 06:42:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54403 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751150AbZH0Kmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 06:42:38 -0400
Message-ID: <4A9662FE.3080400@cn.fujitsu.com>
Date: Thu, 27 Aug 2009 18:42:06 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Wei Yongjun <yjwei@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] tracing/events: parameter check for __string() and *_str()
References: <4A966288.8020402@cn.fujitsu.com>
In-Reply-To: <4A966288.8020402@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: : ISVW-6.0.0.2339-3.52.0.1010-13974000
X-TM-AS-Result: : No
X-TM-AS-Category-Info: : 31:0.000000
X-TM-AS-MatchedID: : 1-150644-150673-150675-110539-188019
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we pass a NULL pointer to __string() and *_str(), kernel will
crash, this patch stop it and print the NULL pointer to user, for
example:

sshd-2545  [000]    95.588404: napi_poll: ifname=<NULL>

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 include/trace/ftrace.h             |   11 +++++++----
 kernel/trace/trace_events_filter.c |    2 +-
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 360a77a..036aa0e 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -229,8 +229,9 @@ ftrace_format_##call(struct ftrace_event_call *unused,			\
 #define TP_printk(fmt, args...) fmt "\n", args
 
 #undef __get_dynamic_array
-#define __get_dynamic_array(field)	\
-		((void *)__entry + (__entry->__data_loc_##field & 0xffff))
+#define __get_dynamic_array(field)					\
+	((__entry->__data_loc_##field & 0xffff0000) ?			\
+	((void *)__entry + (__entry->__data_loc_##field & 0xffff)) : NULL)
 
 #undef __get_str
 #define __get_str(field) (char *)__get_dynamic_array(field)
@@ -357,7 +358,8 @@ ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
 	__data_size += (len) * sizeof(type);
 
 #undef __string
-#define __string(item, src) __dynamic_array(char, item, strlen(src) + 1)       \
+#define __string(item, src)						\
+	__dynamic_array(char, item, src ? strlen(src) + 1 : 0)
 
 #undef TRACE_EVENT
 #define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
@@ -554,7 +556,8 @@ static void ftrace_profile_disable_##call(struct ftrace_event_call *event_call)\
 
 #undef __assign_str
 #define __assign_str(dst, src)						\
-	strcpy(__get_str(dst), src);
+	if (src) 							\
+		strcpy(__get_str(dst), src);
 
 #undef TRACE_EVENT
 #define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 9f03082..9f1838a 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -196,7 +196,7 @@ static int filter_pred_strloc(struct filter_pred *pred, void *event,
 	char *addr = (char *)(event + str_loc);
 	int cmp, match;
 
-	cmp = strncmp(addr, pred->str_val, str_len);
+	cmp = str_len ? strncmp(addr, pred->str_val, str_len) : -1;
 
 	match = (!cmp) ^ pred->not;
 
-- 
1.6.1.2


