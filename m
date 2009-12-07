Return-Path: <linux-kernel-owner+w=401wt.eu-S1758764AbZLGHkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764AbZLGHkh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 02:40:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758711AbZLGHkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 02:40:36 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49708 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754368AbZLGHkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 02:40:35 -0500
Message-ID: <4B1CB15F.3000403@cn.fujitsu.com>
Date: Mon, 07 Dec 2009 15:40:15 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 01/13] tracing: Extract duplicate ftrace_raw_init_event_foo()
References: <4B1CB14A.4080402@cn.fujitsu.com>
In-Reply-To: <4B1CB14A.4080402@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define ftrace_raw_init_event_foo() for each event class rather
than for each event:

   text    data     bss     dec     hex filename
5459553 2005772 7103796 14569121         de4ea1 vmlinux.o.old
5456157 2005772 7103796 14565725         de415d vmlinux.o

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/trace/ftrace.h |   34 +++++++++++++++-------------------
 1 files changed, 15 insertions(+), 19 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index d1b3de9..4d114c9 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -647,9 +647,6 @@ static void ftrace_profile_disable_##name(struct ftrace_event_call *unused)\
  *
  */
 
-#undef TP_FMT
-#define TP_FMT(fmt, args...)	fmt "\n", ##args
-
 #ifdef CONFIG_EVENT_PROFILE
 
 #define _TRACE_PROFILE_INIT(call)					\
@@ -716,6 +713,18 @@ static void ftrace_raw_event_id_##call(struct ftrace_event_call *event_call, \
 	if (!filter_current_check_discard(buffer, event_call, entry, event)) \
 		trace_nowake_buffer_unlock_commit(buffer,		\
 						  event, irq_flags, pc); \
+}									\
+									\
+static int ftrace_raw_init_event_##call(struct ftrace_event_call *event_call)\
+{									\
+	int id;								\
+									\
+	id = register_ftrace_event(event_call->event);			\
+	if (!id)							\
+		return -ENODEV;						\
+	event_call->id = id;						\
+	INIT_LIST_HEAD(&event_call->fields);				\
+	return 0;							\
 }
 
 #undef DEFINE_EVENT
@@ -744,19 +753,7 @@ static void ftrace_raw_unreg_event_##call(struct ftrace_event_call *unused)\
 									\
 static struct trace_event ftrace_event_type_##call = {			\
 	.trace			= ftrace_raw_output_##call,		\
-};									\
-									\
-static int ftrace_raw_init_event_##call(struct ftrace_event_call *unused)\
-{									\
-	int id;								\
-									\
-	id = register_ftrace_event(&ftrace_event_type_##call);		\
-	if (!id)							\
-		return -ENODEV;						\
-	event_##call.id = id;						\
-	INIT_LIST_HEAD(&event_##call.fields);				\
-	return 0;							\
-}
+};
 
 #undef DEFINE_EVENT_PRINT
 #define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
@@ -776,7 +773,7 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.name			= #call,				\
 	.system			= __stringify(TRACE_SYSTEM),		\
 	.event			= &ftrace_event_type_##call,		\
-	.raw_init		= ftrace_raw_init_event_##call,		\
+	.raw_init		= ftrace_raw_init_event_##template,	\
 	.regfunc		= ftrace_raw_reg_event_##call,		\
 	.unregfunc		= ftrace_raw_unreg_event_##call,	\
 	.show_format		= ftrace_format_##template,		\
@@ -793,7 +790,7 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.name			= #call,				\
 	.system			= __stringify(TRACE_SYSTEM),		\
 	.event			= &ftrace_event_type_##call,		\
-	.raw_init		= ftrace_raw_init_event_##call,		\
+	.raw_init		= ftrace_raw_init_event_##template,	\
 	.regfunc		= ftrace_raw_reg_event_##call,		\
 	.unregfunc		= ftrace_raw_unreg_event_##call,	\
 	.show_format		= ftrace_format_##call,			\
@@ -953,7 +950,6 @@ end:									\
 	perf_swevent_put_recursion_context(rctx);			\
 end_recursion:								\
 	local_irq_restore(irq_flags);					\
-									\
 }
 
 #undef DEFINE_EVENT
-- 
1.6.3

