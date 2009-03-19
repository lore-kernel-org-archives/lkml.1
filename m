Return-Path: <linux-kernel-owner+w=401wt.eu-S1760925AbZCSTo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760925AbZCSTo7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 15:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759714AbZCSTnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 15:43:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53498 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756665AbZCSTnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 15:43:20 -0400
Message-Id: <20090319194233.372534033@chello.nl>
References: <20090319192610.660857280@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 19 Mar 2009 20:26:13 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, paulus@samba.org, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 03/10] ftrace: provide an id file for each event
Content-Disposition: inline; filename=ftrace_event_id.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since not every event has a format file to read the id from, expose it
explicitly in a separate file.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/trace/trace_events.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

Index: linux-2.6/kernel/trace/trace_events.c
===================================================================
--- linux-2.6.orig/kernel/trace/trace_events.c
+++ linux-2.6/kernel/trace/trace_events.c
@@ -414,6 +414,29 @@ event_format_read(struct file *filp, cha
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
@@ -454,6 +477,11 @@ static const struct file_operations ftra
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
@@ -552,6 +580,14 @@ event_create_dir(struct ftrace_event_cal
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

-- 

