Return-Path: <linux-kernel-owner+w=401wt.eu-S1752107AbZIGIOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbZIGIOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 04:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751929AbZIGIOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 04:14:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63944 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752058AbZIGIOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 04:14:31 -0400
Message-ID: <4AA4C09E.4050704@cn.fujitsu.com>
Date: Mon, 07 Sep 2009 16:13:18 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/6] tracing/syscalls: Add profile filter support
References: <4AA4C04D.1050201@cn.fujitsu.com>
In-Reply-To: <4AA4C04D.1050201@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes syscall profile events filter-able.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/linux/syscalls.h      |   14 ++++++++++----
 kernel/trace/trace_syscalls.c |    9 +++++++--
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index a8e3782..510d941 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -103,30 +103,36 @@ struct perf_counter_attr;
 static int prof_sysenter_enable_##sname(struct ftrace_event_call *event_call)  \
 {									       \
 	int ret = 0;							       \
-	if (!atomic_inc_return(&event_enter_##sname.profile_count))	       \
+	if (!atomic_inc_return(&event_call->profile_count))		       \
 		ret = reg_prof_syscall_enter("sys"#sname);		       \
 	return ret;							       \
 }									       \
 									       \
 static void prof_sysenter_disable_##sname(struct ftrace_event_call *event_call)\
 {									       \
-	if (atomic_add_negative(-1, &event_enter_##sname.profile_count))       \
+	if (atomic_add_negative(-1, &event_call->profile_count)) {	       \
 		unreg_prof_syscall_enter("sys"#sname);			       \
+		tracepoint_synchronize_unregister();			       \
+		destroy_profile_preds(event_call);			       \
+	}								       \
 }
 
 #define TRACE_SYS_EXIT_PROFILE(sname)					       \
 static int prof_sysexit_enable_##sname(struct ftrace_event_call *event_call)   \
 {									       \
 	int ret = 0;							       \
-	if (!atomic_inc_return(&event_exit_##sname.profile_count))	       \
+	if (!atomic_inc_return(&event_call->profile_count))		       \
 		ret = reg_prof_syscall_exit("sys"#sname);		       \
 	return ret;							       \
 }									       \
 									       \
 static void prof_sysexit_disable_##sname(struct ftrace_event_call *event_call) \
 {                                                                              \
-	if (atomic_add_negative(-1, &event_exit_##sname.profile_count))	       \
+	if (atomic_add_negative(-1, &event_call->profile_count)) {	       \
 		unreg_prof_syscall_exit("sys"#sname);			       \
+		tracepoint_synchronize_unregister();			       \
+		destroy_profile_preds(event_call);			       \
+	}								       \
 }
 
 #define TRACE_SYS_ENTER_PROFILE_INIT(sname)				       \
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 8712ce3..c2faf98 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -414,7 +414,10 @@ static void prof_syscall_enter(struct pt_regs *regs, long id)
 		rec->nr = syscall_nr;
 		syscall_get_arguments(current, regs, 0, sys_data->nb_args,
 				       (unsigned long *)&rec->args);
-		perf_tpcounter_event(sys_data->enter_id, 0, 1, rec, size);
+
+		if (profile_filter_check(sys_data->enter_event, &rec))
+			perf_tpcounter_event(sys_data->enter_id, 0, 1,
+					     rec, size);
 	} while(0);
 }
 
@@ -476,7 +479,9 @@ static void prof_syscall_exit(struct pt_regs *regs, long ret)
 	rec.nr = syscall_nr;
 	rec.ret = syscall_get_return_value(current, regs);
 
-	perf_tpcounter_event(sys_data->exit_id, 0, 1, &rec, sizeof(rec));
+	if (profile_filter_check(sys_data->exit_event, &rec))
+		perf_tpcounter_event(sys_data->exit_id, 0, 1,
+				     &rec, sizeof(rec));
 }
 
 int reg_prof_syscall_exit(char *name)
-- 
1.6.3

