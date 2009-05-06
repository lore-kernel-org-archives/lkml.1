Return-Path: <linux-kernel-owner+w=401wt.eu-S1759804AbZEFMVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759804AbZEFMVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 08:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759792AbZEFMU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 08:20:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:36017 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759875AbZEFMUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 08:20:25 -0400
Date: Wed, 6 May 2009 12:19:43 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, a.p.zijlstra@chello.nl, lizf@cn.fujitsu.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tzanussi@gmail.com, lizf@cn.fujitsu.com, a.p.zijlstra@chello.nl,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4A00F709.3080800@cn.fujitsu.com>
References: <4A00F709.3080800@cn.fujitsu.com>
Subject: [tip:tracing/core] tracing/events: fix concurrent access to ftrace_events list
Message-ID: <tip-20c8928abe70e204bd077ab6cfe23002d7788983@git.kernel.org>
Git-Commit-ID: 20c8928abe70e204bd077ab6cfe23002d7788983
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 06 May 2009 12:19:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  20c8928abe70e204bd077ab6cfe23002d7788983
Gitweb:     http://git.kernel.org/tip/20c8928abe70e204bd077ab6cfe23002d7788983
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Wed, 6 May 2009 10:33:45 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 6 May 2009 10:38:19 +0200

tracing/events: fix concurrent access to ftrace_events list

A module will add/remove its trace events when it gets loaded/unloaded, so
the ftrace_events list is not "const", and concurrent access needs to be
protected.

This patch thus fixes races between loading/unloding modules and read
'available_events' or read/write 'set_event', etc.

Below shows how to reproduce the race:

 # for ((; ;)) { cat /mnt/tracing/available_events; } > /dev/null &
 # for ((; ;)) { insmod trace-events-sample.ko; rmmod sample; } &

After a while:

BUG: unable to handle kernel paging request at 0010011c
IP: [<c1080f27>] t_next+0x1b/0x2d
..
Call Trace:
 [<c10c90e6>] ? seq_read+0x217/0x30d
 [<c10c8ecf>] ? seq_read+0x0/0x30d
 [<c10b4c19>] ? vfs_read+0x8f/0x136
 [<c10b4fc3>] ? sys_read+0x40/0x65
 [<c1002a68>] ? sysenter_do_call+0x12/0x36

[ Impact: fix races when concurrent accessing ftrace_events list ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <4A00F709.3080800@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace.h               |    1 +
 kernel/trace/trace_event_profile.c |   19 ++++++++++++++-----
 kernel/trace/trace_events.c        |   20 +++++++++++---------
 kernel/trace/trace_events_filter.c |   10 +++++++---
 4 files changed, 33 insertions(+), 17 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 7736fe8..777c6c3 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -825,6 +825,7 @@ static int filter_pred_##size(struct filter_pred *pred, void *event,	\
 	return match;							\
 }
 
+extern struct mutex event_mutex;
 extern struct list_head ftrace_events;
 
 extern const char *__start___trace_bprintk_fmt[];
diff --git a/kernel/trace/trace_event_profile.c b/kernel/trace/trace_event_profile.c
index 7bf2ad6..5b5895a 100644
--- a/kernel/trace/trace_event_profile.c
+++ b/kernel/trace/trace_event_profile.c
@@ -10,21 +10,30 @@
 int ftrace_profile_enable(int event_id)
 {
 	struct ftrace_event_call *event;
+	int ret = -EINVAL;
 
+	mutex_lock(&event_mutex);
 	list_for_each_entry(event, &ftrace_events, list) {
-		if (event->id == event_id)
-			return event->profile_enable(event);
+		if (event->id == event_id) {
+			ret = event->profile_enable(event);
+			break;
+		}
 	}
+	mutex_unlock(&event_mutex);
 
-	return -EINVAL;
+	return ret;
 }
 
 void ftrace_profile_disable(int event_id)
 {
 	struct ftrace_event_call *event;
 
+	mutex_lock(&event_mutex);
 	list_for_each_entry(event, &ftrace_events, list) {
-		if (event->id == event_id)
-			return event->profile_disable(event);
+		if (event->id == event_id) {
+			event->profile_disable(event);
+			break;
+		}
 	}
+	mutex_unlock(&event_mutex);
 }
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index f251a15..8d579ff 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -21,7 +21,7 @@
 
 #define TRACE_SYSTEM "TRACE_SYSTEM"
 
-static DEFINE_MUTEX(event_mutex);
+DEFINE_MUTEX(event_mutex);
 
 LIST_HEAD(ftrace_events);
 
@@ -80,6 +80,7 @@ static void ftrace_clear_events(void)
 {
 	struct ftrace_event_call *call;
 
+	mutex_lock(&event_mutex);
 	list_for_each_entry(call, &ftrace_events, list) {
 
 		if (call->enabled) {
@@ -87,6 +88,7 @@ static void ftrace_clear_events(void)
 			call->unregfunc();
 		}
 	}
+	mutex_unlock(&event_mutex);
 }
 
 static void ftrace_event_enable_disable(struct ftrace_event_call *call,
@@ -274,6 +276,9 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 
 static void *t_start(struct seq_file *m, loff_t *pos)
 {
+	mutex_lock(&event_mutex);
+	if (*pos == 0)
+		m->private = ftrace_events.next;
 	return t_next(m, NULL, pos);
 }
 
@@ -303,6 +308,9 @@ s_next(struct seq_file *m, void *v, loff_t *pos)
 
 static void *s_start(struct seq_file *m, loff_t *pos)
 {
+	mutex_lock(&event_mutex);
+	if (*pos == 0)
+		m->private = ftrace_events.next;
 	return s_next(m, NULL, pos);
 }
 
@@ -319,12 +327,12 @@ static int t_show(struct seq_file *m, void *v)
 
 static void t_stop(struct seq_file *m, void *p)
 {
+	mutex_unlock(&event_mutex);
 }
 
 static int
 ftrace_event_seq_open(struct inode *inode, struct file *file)
 {
-	int ret;
 	const struct seq_operations *seq_ops;
 
 	if ((file->f_mode & FMODE_WRITE) &&
@@ -332,13 +340,7 @@ ftrace_event_seq_open(struct inode *inode, struct file *file)
 		ftrace_clear_events();
 
 	seq_ops = inode->i_private;
-	ret = seq_open(file, seq_ops);
-	if (!ret) {
-		struct seq_file *m = file->private_data;
-
-		m->private = ftrace_events.next;
-	}
-	return ret;
+	return seq_open(file, seq_ops);
 }
 
 static ssize_t
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index ce07b81..7ac6910 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -408,6 +408,7 @@ static void filter_free_subsystem_preds(struct event_subsystem *system)
 		filter->n_preds = 0;
 	}
 
+	mutex_lock(&event_mutex);
 	list_for_each_entry(call, &ftrace_events, list) {
 		if (!call->define_fields)
 			continue;
@@ -417,6 +418,7 @@ static void filter_free_subsystem_preds(struct event_subsystem *system)
 			remove_filter_string(call->filter);
 		}
 	}
+	mutex_unlock(&event_mutex);
 }
 
 static int filter_add_pred_fn(struct filter_parse_state *ps,
@@ -567,6 +569,7 @@ static int filter_add_subsystem_pred(struct filter_parse_state *ps,
 {
 	struct event_filter *filter = system->filter;
 	struct ftrace_event_call *call;
+	int err = 0;
 
 	if (!filter->preds) {
 		filter->preds = kzalloc(MAX_FILTER_PRED * sizeof(pred),
@@ -584,8 +587,8 @@ static int filter_add_subsystem_pred(struct filter_parse_state *ps,
 	filter->preds[filter->n_preds] = pred;
 	filter->n_preds++;
 
+	mutex_lock(&event_mutex);
 	list_for_each_entry(call, &ftrace_events, list) {
-		int err;
 
 		if (!call->define_fields)
 			continue;
@@ -597,12 +600,13 @@ static int filter_add_subsystem_pred(struct filter_parse_state *ps,
 		if (err) {
 			filter_free_subsystem_preds(system);
 			parse_error(ps, FILT_ERR_BAD_SUBSYS_FILTER, 0);
-			return err;
+			break;
 		}
 		replace_filter_string(call->filter, filter_string);
 	}
+	mutex_unlock(&event_mutex);
 
-	return 0;
+	return err;
 }
 
 static void parse_init(struct filter_parse_state *ps,
