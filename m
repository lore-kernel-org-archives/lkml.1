Return-Path: <linux-kernel-owner+w=401wt.eu-S1752884AbZH1M3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbZH1M3n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 08:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbZH1M3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 08:29:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:55514 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917AbZH1M3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 08:29:36 -0400
Date: Fri, 28 Aug 2009 12:29:09 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lizf@cn.fujitsu.com, jistone@redhat.com, fweisbec@gmail.com,
       srostedt@redhat.com, tglx@linutronix.de, jbaron@redhat.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, jistone@redhat.com, fweisbec@gmail.com,
       srostedt@redhat.com, tglx@linutronix.de, jbaron@redhat.com,
       mingo@elte.hu
In-Reply-To: <1251413406-6704-1-git-send-email-fweisbec@gmail.com>
References: <1251413406-6704-1-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Fix double CPP substitution in TRACE_EVENT_FN
Message-ID: <tip-0dd7b74787eaf7858c6c573353a83c3e2766e674@git.kernel.org>
Git-Commit-ID: 0dd7b74787eaf7858c6c573353a83c3e2766e674
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 28 Aug 2009 12:29:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0dd7b74787eaf7858c6c573353a83c3e2766e674
Gitweb:     http://git.kernel.org/tip/0dd7b74787eaf7858c6c573353a83c3e2766e674
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Fri, 28 Aug 2009 00:50:06 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 28 Aug 2009 13:55:04 +0200

tracing: Fix double CPP substitution in TRACE_EVENT_FN

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
LKML-Reference: <1251413406-6704-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
 
