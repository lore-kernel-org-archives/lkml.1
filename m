Return-Path: <linux-kernel-owner+w=401wt.eu-S1761330AbZCTKUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761330AbZCTKUr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 06:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760644AbZCTKU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 06:20:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:49053 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760470AbZCTKUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 06:20:24 -0400
Date: Fri, 20 Mar 2009 10:19:27 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, rostedt@goodmis.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090319194233.372534033@chello.nl>
References: <20090319194233.372534033@chello.nl>
Subject: [tip:tracing/ftrace] ftrace: provide an id file for each event
Message-ID: <tip-23725aeeab10ba02bcf10ec49ad73146b54cb52f@git.kernel.org>
Git-Commit-ID: 23725aeeab10ba02bcf10ec49ad73146b54cb52f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 20 Mar 2009 10:19:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  23725aeeab10ba02bcf10ec49ad73146b54cb52f
Gitweb:     http://git.kernel.org/tip/23725aeeab10ba02bcf10ec49ad73146b54cb52f
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 19 Mar 2009 20:26:13 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 20 Mar 2009 10:17:05 +0100

ftrace: provide an id file for each event

Since not every event has a format file to read the id from,
expose it explicitly in a separate file.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20090319194233.372534033@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace_events.c |   36 ++++++++++++++++++++++++++++++++++++
 1 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index c88227b..7763db8 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -412,6 +412,29 @@ event_format_read(struct file *filp, char __user *ubuf, size_t cnt,
 	return r;
 }
 
+static ssize_t
+event_id_read(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
+{
+	struct ftrace_event_call *call = filp->private_data;
+	struct trace_seq *s;
+	int r;
+
+	if (*ppos)
+		return 0;
+
+	s = kmalloc(sizeof(*s), GFP_KERNEL);
+	if (!s)
+		return -ENOMEM;
+
+	trace_seq_init(s);
+	trace_seq_printf(s, "%d\n", call->id);
+
+	r = simple_read_from_buffer(ubuf, cnt, ppos,
+				    s->buffer, s->len);
+	kfree(s);
+	return r;
+}
+
 static const struct seq_operations show_event_seq_ops = {
 	.start = t_start,
 	.next = t_next,
@@ -452,6 +475,11 @@ static const struct file_operations ftrace_event_format_fops = {
 	.read = event_format_read,
 };
 
+static const struct file_operations ftrace_event_id_fops = {
+	.open = tracing_open_generic,
+	.read = event_id_read,
+};
+
 static struct dentry *event_trace_events_dir(void)
 {
 	static struct dentry *d_tracer;
@@ -550,6 +578,14 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events)
 				   "'%s/enable' entry\n", call->name);
 	}
 
+	if (call->id) {
+		entry = debugfs_create_file("id", 0444, call->dir, call,
+				&ftrace_event_id_fops);
+		if (!entry)
+			pr_warning("Could not create debugfs '%s/id' entry\n",
+					call->name);
+	}
+
 	/* A trace may not want to export its format */
 	if (!call->show_format)
 		return 0;
