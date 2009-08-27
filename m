Return-Path: <linux-kernel-owner+w=401wt.eu-S1751054AbZH0WuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751054AbZH0WuL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 18:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750854AbZH0WuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 18:50:09 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:39314 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbZH0WuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 18:50:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=N44H/WBYqNzc/T4qd60mCzH6GfTXLkc7Jes9kath/QHn3tIO8TWCRPmwHCbXhnuw3e
         a6c+VQM3hX7PXO0a0XPWvB1PEAo3PJy0yO75hnN1ujtfqPosjeE4kw9tV4dkjYw9p95E
         bSKHsNpd2TfCvqzcjj9Ygi+odm2TSVKHvtJLM=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Josh Stone <jistone@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>, Jason Baron <jbaron@redhat.com>
Subject: [PATCH] tracing: Fix double CPP substitution in TRACE_EVENT_FN
Date: Fri, 28 Aug 2009 00:50:06 +0200
Message-Id: <1251413406-6704-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <tip-97419875865859fd2403e66266c02ce028e2f5ab@git.kernel.org>
References: <tip-97419875865859fd2403e66266c02ce028e2f5ab@git.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TRACE_EVENT_FN relays on TRACE_EVENT by reprocessing its parameters
into the ftrace events CPP macro. This leads to a double substitution
in some cases.

For example, a bad consequence is a format always prefixed by
"%s, %s\n" for every TRACE_EVENT_FN based events.

Eg:
	cat /debug/tracing/events/syscalls/sys_enter/format
	[...]
	print fmt: "%s, %s\n", "\"NR %ld (%lx, %lx, %lx, %lx, %lx, %lx)\"",\
	"REC->id, REC->args[0], REC->args[1], REC->args[2], REC->args[3],\
	REC->args[4], REC->args[5]"

This creates a failure in post-processing tools such as perf trace or
trace-cmd.

Then drop this double substitution and replace it by a new __cpparg()
macro that relays CPP arguments containing commas.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Josh Stone <jistone@redhat.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: Jason Baron <jbaron@redhat.com>
---
 include/trace/ftrace.h |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 360a77a..57c56a9 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -45,14 +45,15 @@
 	};							\
 	static struct ftrace_event_call event_##name
 
+#undef __cpparg
+#define __cpparg(arg...) arg
+
 /* Callbacks are meaningless to ftrace. */
 #undef TRACE_EVENT_FN
-#define TRACE_EVENT_FN(name, proto, args, tstruct,		\
-		assign, print, reg, unreg)			\
-	TRACE_EVENT(name, TP_PROTO(proto), TP_ARGS(args),	\
-		TP_STRUCT__entry(tstruct),			\
-		TP_fast_assign(assign),				\
-		TP_printk(print))
+#define TRACE_EVENT_FN(name, proto, args, tstruct,			\
+		assign, print, reg, unreg)				\
+	TRACE_EVENT(name, __cpparg(proto), __cpparg(args),		\
+		__cpparg(tstruct), __cpparg(assign), __cpparg(print))	\
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
-- 
1.6.2.3

