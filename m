Return-Path: <linux-kernel-owner+w=401wt.eu-S1753232AbZLMNJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbZLMNJq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 08:09:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753099AbZLMNJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 08:09:35 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:51043 "HELO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753139AbZLMNIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 08:08:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qizMuOcOBpvVmS3ammoDe4mm+yDAEH9wCKCf9n/T03tldlUsuFH87a+bUxg2oJi9kw
         cG6+s2FclYcSreJrXEnkjMenhx51wviaK1EryNAZTEJ/xZsimrldVbWCQFIp7Dr/lVN7
         tG8pAAHcr5fkQI0sBxDNt5msLJtGj/atP5vLo=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Jason Baron <jbaron@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 11/13] tracing: Change event->profile_count to be int type
Date: Sun, 13 Dec 2009 14:08:12 +0100
Message-Id: <1260709694-5166-12-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1260709694-5166-1-git-send-regression-fweisbec@gmail.com>
References: <1260709694-5166-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

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
-- 
1.6.2.3

