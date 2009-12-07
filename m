Return-Path: <linux-kernel-owner+w=401wt.eu-S1758931AbZLGHoJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758931AbZLGHoJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 02:44:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758760AbZLGHoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 02:44:08 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50956 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758706AbZLGHoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 02:44:05 -0500
Message-ID: <4B1CB231.7030807@cn.fujitsu.com>
Date: Mon, 07 Dec 2009 15:43:45 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 11/13] tracing: Change event->profile_count to be int type
References: <4B1CB14A.4080402@cn.fujitsu.com>
In-Reply-To: <4B1CB14A.4080402@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like total_profile_count, struct ftrace_event_call::profile_count
is protected by event_mutex, so it doesn't need to be atomic_t.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/linux/ftrace_event.h       |    2 +-
 include/linux/syscalls.h           |    2 --
 include/trace/ftrace.h             |    1 -
 kernel/trace/trace_event_profile.c |    6 +++---
 kernel/trace/trace_kprobe.c        |    1 -
 5 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 02de70f..22a04d9 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -130,7 +130,7 @@ struct ftrace_event_call {
 	void			*mod;
 	void			*data;
 
-	atomic_t		profile_count;
+	int			profile_count;
 	int			(*profile_enable)(struct ftrace_event_call *);
 	void			(*profile_disable)(struct ftrace_event_call *);
 };
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index e79e2f3..d3ecfb9 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -101,12 +101,10 @@ struct perf_event_attr;
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
index 4aac981..51f045b 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -640,7 +640,6 @@ static void ftrace_profile_disable_##name(struct ftrace_event_call *unused)\
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
1.6.3

