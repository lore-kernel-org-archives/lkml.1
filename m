Return-Path: <linux-kernel-owner+w=401wt.eu-S1756159AbZIKTcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159AbZIKTcx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 15:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756089AbZIKTce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 15:32:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:38220 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755766AbZIKTcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 15:32:33 -0400
Message-Id: <20090911193235.694610367@goodmis.org>
References: <20090911193153.444303577@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 11 Sep 2009 15:31:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/6] tracing: move tgid out of generic entry and into userstack
Content-Disposition: inline; filename=0001-tracing-move-tgid-out-of-generic-entry-and-into-user.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The userstack trace required the recording of the tgid entry.
Unfortunately, it was added to the generic entry where it wasted
4 bytes of every entry and was only used by one entry.

This patch moves it out of the generic field and moves it into the
only user (userstack_entry).

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h |    1 -
 kernel/trace/trace.c         |    2 +-
 kernel/trace/trace.h         |    1 +
 kernel/trace/trace_events.c  |    5 +----
 kernel/trace/trace_output.c  |    2 +-
 5 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 23f7179..06c795b 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -34,7 +34,6 @@ struct trace_entry {
 	unsigned char		flags;
 	unsigned char		preempt_count;
 	int			pid;
-	int			tgid;
 };
 
 #define FTRACE_MAX_EVENT						\
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 5c75dee..1a37da2 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -886,7 +886,6 @@ tracing_generic_entry_update(struct trace_entry *entry, unsigned long flags,
 
 	entry->preempt_count		= pc & 0xff;
 	entry->pid			= (tsk) ? tsk->pid : 0;
-	entry->tgid			= (tsk) ? tsk->tgid : 0;
 	entry->flags =
 #ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
 		(irqs_disabled_flags(flags) ? TRACE_FLAG_IRQS_OFF : 0) |
@@ -1068,6 +1067,7 @@ ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags, int pc)
 		return;
 	entry	= ring_buffer_event_data(event);
 
+	entry->tgid		= current->tgid;
 	memset(&entry->caller, 0, sizeof(entry->caller));
 
 	trace.nr_entries	= 0;
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index acaa680..b69697b 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -101,6 +101,7 @@ struct stack_entry {
 
 struct userstack_entry {
 	struct trace_entry	ent;
+	unsigned int		tgid;
 	unsigned long		caller[FTRACE_STACK_ENTRIES];
 };
 
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 78b1ed2..28d9202 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -86,7 +86,6 @@ int trace_define_common_fields(struct ftrace_event_call *call)
 	__common_field(unsigned char, flags);
 	__common_field(unsigned char, preempt_count);
 	__common_field(int, pid);
-	__common_field(int, tgid);
 
 	return ret;
 }
@@ -572,13 +571,11 @@ static int trace_write_header(struct trace_seq *s)
 				"\tfield:%s %s;\toffset:%zu;\tsize:%zu;\n"
 				"\tfield:%s %s;\toffset:%zu;\tsize:%zu;\n"
 				"\tfield:%s %s;\toffset:%zu;\tsize:%zu;\n"
-				"\tfield:%s %s;\toffset:%zu;\tsize:%zu;\n"
 				"\n",
 				FIELD(unsigned short, type),
 				FIELD(unsigned char, flags),
 				FIELD(unsigned char, preempt_count),
-				FIELD(int, pid),
-				FIELD(int, tgid));
+				FIELD(int, pid));
 }
 
 static ssize_t
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index e0c2545..be34a6a 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -407,7 +407,7 @@ seq_print_userip_objs(const struct userstack_entry *entry, struct trace_seq *s,
 		 * since individual threads might have already quit!
 		 */
 		rcu_read_lock();
-		task = find_task_by_vpid(entry->ent.tgid);
+		task = find_task_by_vpid(entry->tgid);
 		if (task)
 			mm = get_task_mm(task);
 		rcu_read_unlock();
-- 
1.6.3.3

-- 
