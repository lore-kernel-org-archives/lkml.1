Return-Path: <linux-kernel-owner+w=401wt.eu-S1764330AbZLQKy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764330AbZLQKy3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 05:54:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762268AbZLQKyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 05:54:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:54026 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752876AbZLQKyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 05:54:11 -0500
Date: Thu, 17 Dec 2009 10:51:47 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: acme@redhat.com, mingo@redhat.com, peterz@infradead.org,
       dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, paulus@samba.org,
       jkenisto@us.ibm.com, hch@infradead.org, ananth@in.ibm.com,
       srikar@linux.vnet.ibm.com, mingo@elte.hu, prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, acme@redhat.com, peterz@infradead.org,
       dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, paulus@samba.org,
       jkenisto@us.ibm.com, hch@infradead.org, ananth@in.ibm.com,
       srikar@linux.vnet.ibm.com, prasad@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20091216222408.14459.68790.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091216222408.14459.68790.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] kprobe-tracer: Check new event/group name
Message-ID: <tip-6f3cf440470650b3841d325acacd0c5ea9504c68@git.kernel.org>
Git-Commit-ID: 6f3cf440470650b3841d325acacd0c5ea9504c68
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6f3cf440470650b3841d325acacd0c5ea9504c68
Gitweb:     http://git.kernel.org/tip/6f3cf440470650b3841d325acacd0c5ea9504c68
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Wed, 16 Dec 2009 17:24:08 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 17 Dec 2009 09:42:44 +0100

kprobe-tracer: Check new event/group name

Check new event/group name is same syntax as a C symbol. In other
words, checking the name is as like as other tracepoint events.

This can prevent user to create an event with useless name (e.g.
foo|bar, foo*bar).

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
LKML-Reference: <20091216222408.14459.68790.stgit@dhcp-100-2-132.bos.redhat.com>
[ v2: minor cleanups ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace_kprobe.c |   31 +++++++++++++++++++++++++------
 1 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 7ecab06..375f81a 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -282,6 +282,18 @@ static int kprobe_dispatcher(struct kprobe *kp, struct pt_regs *regs);
 static int kretprobe_dispatcher(struct kretprobe_instance *ri,
 				struct pt_regs *regs);
 
+/* Check the name is good for event/group */
+static int check_event_name(const char *name)
+{
+	if (!isalpha(*name) && *name != '_')
+		return 0;
+	while (*++name != '\0') {
+		if (!isalpha(*name) && !isdigit(*name) && *name != '_')
+			return 0;
+	}
+	return 1;
+}
+
 /*
  * Allocate new trace_probe and initialize it (including kprobes).
  */
@@ -293,10 +305,11 @@ static struct trace_probe *alloc_trace_probe(const char *group,
 					     int nargs, int is_return)
 {
 	struct trace_probe *tp;
+	int ret = -ENOMEM;
 
 	tp = kzalloc(SIZEOF_TRACE_PROBE(nargs), GFP_KERNEL);
 	if (!tp)
-		return ERR_PTR(-ENOMEM);
+		return ERR_PTR(ret);
 
 	if (symbol) {
 		tp->symbol = kstrdup(symbol, GFP_KERNEL);
@@ -312,14 +325,20 @@ static struct trace_probe *alloc_trace_probe(const char *group,
 	else
 		tp->rp.kp.pre_handler = kprobe_dispatcher;
 
-	if (!event)
+	if (!event || !check_event_name(event)) {
+		ret = -EINVAL;
 		goto error;
+	}
+
 	tp->call.name = kstrdup(event, GFP_KERNEL);
 	if (!tp->call.name)
 		goto error;
 
-	if (!group)
+	if (!group || !check_event_name(group)) {
+		ret = -EINVAL;
 		goto error;
+	}
+
 	tp->call.system = kstrdup(group, GFP_KERNEL);
 	if (!tp->call.system)
 		goto error;
@@ -330,7 +349,7 @@ error:
 	kfree(tp->call.name);
 	kfree(tp->symbol);
 	kfree(tp);
-	return ERR_PTR(-ENOMEM);
+	return ERR_PTR(ret);
 }
 
 static void free_probe_arg(struct probe_arg *arg)
@@ -695,10 +714,10 @@ static int create_trace_probe(int argc, char **argv)
 	if (!event) {
 		/* Make a new event name */
 		if (symbol)
-			snprintf(buf, MAX_EVENT_NAME_LEN, "%c@%s%+ld",
+			snprintf(buf, MAX_EVENT_NAME_LEN, "%c_%s_%ld",
 				 is_return ? 'r' : 'p', symbol, offset);
 		else
-			snprintf(buf, MAX_EVENT_NAME_LEN, "%c@0x%p",
+			snprintf(buf, MAX_EVENT_NAME_LEN, "%c_0x%p",
 				 is_return ? 'r' : 'p', addr);
 		event = buf;
 	}
