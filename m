Return-Path: <linux-kernel-owner+w=401wt.eu-S1760509AbZCTKUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760509AbZCTKUa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 06:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758912AbZCTKUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 06:20:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:49040 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756043AbZCTKUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 06:20:10 -0400
Date: Fri, 20 Mar 2009 10:19:38 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, rostedt@goodmis.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090319194233.464914218@chello.nl>
References: <20090319194233.464914218@chello.nl>
Subject: [tip:tracing/ftrace] ftrace: ensure every event gets an id
Message-ID: <tip-28bea271e58e429eccfad3d7ee2ad12d6ee015bf@git.kernel.org>
Git-Commit-ID: 28bea271e58e429eccfad3d7ee2ad12d6ee015bf
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 20 Mar 2009 10:19:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  28bea271e58e429eccfad3d7ee2ad12d6ee015bf
Gitweb:     http://git.kernel.org/tip/28bea271e58e429eccfad3d7ee2ad12d6ee015bf
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 19 Mar 2009 20:26:14 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 20 Mar 2009 10:17:06 +0100

ftrace: ensure every event gets an id

Impact: widen user-space visibe event IDs to all events

Previously only TRACE_EVENT events got ids, because only they
generated raw output which needs to be demuxed from the trace.

In order to provide a unique ID for each event, register everybody,
regardless.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20090319194233.464914218@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace_events_stage_3.h |   15 ++++++++++++++-
 kernel/trace/trace_output.c         |    5 +++++
 2 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_events_stage_3.h b/kernel/trace/trace_events_stage_3.h
index ae2e323..4c26d97 100644
--- a/kernel/trace/trace_events_stage_3.h
+++ b/kernel/trace/trace_events_stage_3.h
@@ -130,7 +130,19 @@ static void ftrace_unreg_event_##call(void)				\
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
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index b451417..19261fd 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -481,6 +481,11 @@ int register_ftrace_event(struct trace_event *event)
 
 	mutex_lock(&trace_event_mutex);
 
+	if (!event) {
+		ret = next_event_type++;
+		goto out;
+	}
+
 	if (!event->type)
 		event->type = next_event_type++;
 	else if (event->type > __TRACE_LAST_TYPE) {
