Return-Path: <linux-kernel-owner+w=401wt.eu-S1755539AbZLNJsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539AbZLNJsu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 04:48:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755469AbZLNJsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 04:48:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:48308 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755421AbZLNJsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 04:48:32 -0500
Date: Mon, 14 Dec 2009 09:48:01 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lizf@cn.fujitsu.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, jbaron@redhat.com,
       mhiramat@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, jbaron@redhat.com,
       mhiramat@redhat.com
In-Reply-To: <4B1DC549.5010705@cn.fujitsu.com>
References: <4B1DC549.5010705@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] tracing: Change event->profile_count to be int type
Message-ID: <tip-e00bf2ec60605eb95687b7a0c3b83c87c48541dc@git.kernel.org>
Git-Commit-ID: e00bf2ec60605eb95687b7a0c3b83c87c48541dc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e00bf2ec60605eb95687b7a0c3b83c87c48541dc
Gitweb:     http://git.kernel.org/tip/e00bf2ec60605eb95687b7a0c3b83c87c48541dc
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Tue, 8 Dec 2009 11:17:29 +0800
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Sun, 13 Dec 2009 18:37:28 +0100

tracing: Change event->profile_count to be int type

Like total_profile_count, struct ftrace_event_call::profile_count
is protected by event_mutex, so it doesn't need to be atomic_t.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <4B1DC549.5010705@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/ftrace_event.h       |    2 +-
 include/linux/syscalls.h           |    2 --
 include/trace/ftrace.h             |    1 -
 kernel/trace/trace_event_profile.c |    6 +++---
 kernel/trace/trace_kprobe.c        |    1 -
 5 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index db97c64..2233c98 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -131,7 +131,7 @@ struct ftrace_event_call {
 	void			*mod;
 	void			*data;
 
-	atomic_t		profile_count;
+	int			profile_count;
 	int			(*profile_enable)(struct ftrace_event_call *);
 	void			(*profile_disable)(struct ftrace_event_call *);
 };
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 94ac284..72d6986 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -102,12 +102,10 @@ struct perf_event_attr;
 #ifdef CONFIG_EVENT_PROFILE
 
 #define TRACE_SYS_ENTER_PROFILE_INIT(sname)				       \
-	.profile_count = ATOMIC_INIT(-1),				       \
 	.profile_enable = prof_sysenter_enable,				       \
 	.profile_disable = prof_sysenter_disable,
 
 #define TRACE_SYS_EXIT_PROFILE_INIT(sname)				       \
-	.profile_count = ATOMIC_INIT(-1),				       \
 	.profile_enable = prof_sysexit_enable,				       \
 	.profile_disable = prof_sysexit_disable,
 #else
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 0c21af8..7352315 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -629,7 +629,6 @@ static void ftrace_profile_disable_##name(struct ftrace_event_call *unused)\
 #ifdef CONFIG_EVENT_PROFILE
 
 #define _TRACE_PROFILE_INIT(call)					\
-	.profile_count = ATOMIC_INIT(-1),				\
 	.profile_enable = ftrace_profile_enable_##call,			\
 	.profile_disable = ftrace_profile_disable_##call,
 
diff --git a/kernel/trace/trace_event_profile.c b/kernel/trace/trace_event_profile.c
index d9c60f8..9e25573 100644
--- a/kernel/trace/trace_event_profile.c
+++ b/kernel/trace/trace_event_profile.c
@@ -25,7 +25,7 @@ static int ftrace_profile_enable_event(struct ftrace_event_call *event)
 	char *buf;
 	int ret = -ENOMEM;
 
-	if (atomic_inc_return(&event->profile_count))
+	if (event->profile_count++ > 0)
 		return 0;
 
 	if (!total_profile_count) {
@@ -56,7 +56,7 @@ fail_buf_nmi:
 		perf_trace_buf = NULL;
 	}
 fail_buf:
-	atomic_dec(&event->profile_count);
+	event->profile_count--;
 
 	return ret;
 }
@@ -83,7 +83,7 @@ static void ftrace_profile_disable_event(struct ftrace_event_call *event)
 {
 	char *buf, *nmi_buf;
 
-	if (!atomic_add_negative(-1, &event->profile_count))
+	if (--event->profile_count > 0)
 		return;
 
 	event->profile_disable(event);
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index e3c80e9..6ed2234 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1426,7 +1426,6 @@ static int register_probe_event(struct trace_probe *tp)
 	call->unregfunc = probe_event_disable;
 
 #ifdef CONFIG_EVENT_PROFILE
-	atomic_set(&call->profile_count, -1);
 	call->profile_enable = probe_profile_enable;
 	call->profile_disable = probe_profile_disable;
 #endif
