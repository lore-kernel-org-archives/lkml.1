Return-Path: <linux-kernel-owner+w=401wt.eu-S1757262AbZEGJUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262AbZEGJUZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 05:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754987AbZEGJUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 05:20:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:40205 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443AbZEGJUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 05:20:06 -0400
Date: Thu, 7 May 2009 09:19:37 GMT
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, lizf@cn.fujitsu.com, srostedt@redhat.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, rostedt@goodmis.org, srostedt@redhat.com,
       tglx@linutronix.de
In-Reply-To: <49FEAFD0.30106@cn.fujitsu.com>
References: <49FEAFD0.30106@cn.fujitsu.com>
Subject: [tip:tracing/core] tracing: reset ring buffer when removing modules with events
Message-ID: <tip-9456f0fa6d3cb944d3b9fc31c9a244e0362c26ea@git.kernel.org>
Git-Commit-ID: 9456f0fa6d3cb944d3b9fc31c9a244e0362c26ea
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 07 May 2009 09:19:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9456f0fa6d3cb944d3b9fc31c9a244e0362c26ea
Gitweb:     http://git.kernel.org/tip/9456f0fa6d3cb944d3b9fc31c9a244e0362c26ea
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Wed, 6 May 2009 21:54:09 -0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 6 May 2009 23:11:41 -0400

tracing: reset ring buffer when removing modules with events

Li Zefan found that there's a race using the event ids of events and
modules. When a module is loaded, an event id is incremented. We only
have 16 bits for event ids (65536) and there is a possible (but highly
unlikely) race that we could load and unload a module that registers
events so many times that the event id counter overflows.

When it overflows, it then restarts and goes looking for available
ids. An id is available if it was added by a module and released.

The race is if you have one module add an id, and then is removed.
Another module loaded can use that same event id. But if the old module
still had events in the ring buffer, the new module's call back would
get bogus data.  At best (and most likely) the output would just be
garbage. But if the module for some reason used pointers (not recommended)
then this could potentially crash.

The safest thing to do is just reset the ring buffer if a module that
registered events is removed.

[ Impact: prevent unpredictable results of event id overflows ]

Reported-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <49FEAFD0.30106@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


---
 kernel/trace/trace.c        |   10 ++++++++++
 kernel/trace/trace.h        |    2 ++
 kernel/trace/trace_events.c |    9 +++++++++
 3 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 4164a34..dd40d23 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -639,6 +639,16 @@ void tracing_reset_online_cpus(struct trace_array *tr)
 		tracing_reset(tr, cpu);
 }
 
+void tracing_reset_current(int cpu)
+{
+	tracing_reset(&global_trace, cpu);
+}
+
+void tracing_reset_current_online_cpus(void)
+{
+	tracing_reset_online_cpus(&global_trace);
+}
+
 #define SAVED_CMDLINES 128
 #define NO_CMDLINE_MAP UINT_MAX
 static unsigned map_pid_to_cmdline[PID_MAX_DEFAULT+1];
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 777c6c3..ba25793 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -409,6 +409,8 @@ int tracing_is_enabled(void);
 void trace_wake_up(void);
 void tracing_reset(struct trace_array *tr, int cpu);
 void tracing_reset_online_cpus(struct trace_array *tr);
+void tracing_reset_current(int cpu);
+void tracing_reset_current_online_cpus(void);
 int tracing_open_generic(struct inode *inode, struct file *filp);
 struct dentry *trace_create_file(const char *name,
 				 mode_t mode,
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 8d579ff..6d2c842 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -932,9 +932,11 @@ static void trace_module_remove_events(struct module *mod)
 {
 	struct ftrace_module_file_ops *file_ops;
 	struct ftrace_event_call *call, *p;
+	bool found = false;
 
 	list_for_each_entry_safe(call, p, &ftrace_events, list) {
 		if (call->mod == mod) {
+			found = true;
 			if (call->enabled) {
 				call->enabled = 0;
 				call->unregfunc();
@@ -957,6 +959,13 @@ static void trace_module_remove_events(struct module *mod)
 		list_del(&file_ops->list);
 		kfree(file_ops);
 	}
+
+	/*
+	 * It is safest to reset the ring buffer if the module being unloaded
+	 * registered any events.
+	 */
+	if (found)
+		tracing_reset_current_online_cpus();
 }
 
 static int trace_module_notify(struct notifier_block *self,
