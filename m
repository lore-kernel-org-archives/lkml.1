Return-Path: <linux-kernel-owner+w=401wt.eu-S1760971AbZCSTpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760971AbZCSTpv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 15:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760053AbZCSTnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 15:43:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53501 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757678AbZCSTnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 15:43:21 -0400
Message-Id: <20090319194233.464914218@chello.nl>
References: <20090319192610.660857280@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 19 Mar 2009 20:26:14 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, paulus@samba.org, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 04/10] ftrace: ensure every event gets an id
Content-Disposition: inline; filename=ftrace_event_fmt_id.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously only TRACE_EVENT events got ids, because only they generated
raw output which needs to be demuxed from the trace.

In order to provide a unique ID for each event, register everybody, regardless.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/trace/trace_events_stage_3.h |   15 ++++++++++++++-
 kernel/trace/trace_output.c         |    5 +++++
 2 files changed, 19 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/trace/trace_events_stage_3.h
===================================================================
--- linux-2.6.orig/kernel/trace/trace_events_stage_3.h
+++ linux-2.6/kernel/trace/trace_events_stage_3.h
@@ -130,7 +130,19 @@ static void ftrace_unreg_event_##call(vo
 {									\
 	unregister_trace_##call(ftrace_event_##call);			\
 }									\
-
+									\
+static struct ftrace_event_call event_##call;				\
+									\
+static int ftrace_init_event_##call(void)				\
+{									\
+	int id;								\
+									\
+	id = register_ftrace_event(NULL);				\
+	if (!id)							\
+		return -ENODEV;						\
+	event_##call.id = id;						\
+	return 0;							\
+}
 
 #undef TRACE_FORMAT
 #define TRACE_FORMAT(call, proto, args, fmt)				\
@@ -140,6 +152,7 @@ __attribute__((__aligned__(4)))						\
 __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.name			= #call,				\
 	.system			= __stringify(TRACE_SYSTEM),		\
+	.raw_init		= ftrace_init_event_##call,		\
 	.regfunc		= ftrace_reg_event_##call,		\
 	.unregfunc		= ftrace_unreg_event_##call,		\
 }
Index: linux-2.6/kernel/trace/trace_output.c
===================================================================
--- linux-2.6.orig/kernel/trace/trace_output.c
+++ linux-2.6/kernel/trace/trace_output.c
@@ -444,6 +444,11 @@ int register_ftrace_event(struct trace_e
 
 	mutex_lock(&trace_event_mutex);
 
+	if (!event) {
+		ret = next_event_type++;
+		goto out;
+	}
+
 	if (!event->type)
 		event->type = next_event_type++;
 	else if (event->type > __TRACE_LAST_TYPE) {

-- 

