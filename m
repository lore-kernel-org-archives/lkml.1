Return-Path: <linux-kernel-owner+w=401wt.eu-S1752873Ab0A0I3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab0A0I3e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 03:29:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850Ab0A0I3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 03:29:30 -0500
Received: from mail-iw0-f186.google.com ([209.85.223.186]:38170 "EHLO
	mail-iw0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab0A0I2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 03:28:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=GZiXJqazLQ4PqXe2/Be8H2oFS+iTP2zsHnrJg+6Bk8+w7ajlKBqMIbKPA7m8FU1vWU
         dP43y0gAux1cKSchVdK+bvukpLYo6998cMFldC+Wku1gysB2kGsv8G6fIg/94IcujyOs
         PmK88AZ5Qo5VX357Jid1Qk7wvhohMnk8m9hPU=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com
Subject: [PATCH 08/12] perf: export some syscall metadata
Date: Wed, 27 Jan 2010 02:27:59 -0600
Message-Id: <1264580883-15324-9-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1264580883-15324-1-git-send-email-tzanussi@gmail.com>
References: <1264580883-15324-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create and export a list of syscall_nr:syscall_name pairs from the
data in the syscalls_metadata, for use initially by perf trace.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 kernel/trace/trace_syscalls.c |   87 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 87 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index f6b0712..e037486 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -626,5 +626,92 @@ void prof_sysexit_disable(struct ftrace_event_call *call)
 	mutex_unlock(&syscall_trace_lock);
 }
 
+struct syscall_metadata **meta_skip(struct syscall_metadata **meta,
+				    loff_t *pos)
+{
+	struct syscall_metadata **end = syscalls_metadata + NR_syscalls;
+
+	do {
+		meta++;
+		(*pos)++;
+	} while (meta < end && *meta == NULL);
+
+	if (meta >= end)
+		meta = NULL;
+
+	return meta;
+}
+
+static void *syscall_map_start(struct seq_file *s, loff_t *pos)
+{
+	struct syscall_metadata **end = syscalls_metadata + NR_syscalls;
+	struct syscall_metadata **meta = syscalls_metadata + *pos;
+
+	if (meta >= end)
+		return NULL;
+
+	if (*meta == NULL)
+		meta = meta_skip(meta, pos);
+
+	return meta;
+}
+
+static void *syscall_map_next(struct seq_file *s, void *v, loff_t *pos)
+{
+	(*pos)++;
+
+	return syscall_map_start(s, pos);
+}
+
+static int syscall_map_show(struct seq_file *s, void *v)
+{
+	const struct syscall_metadata **meta = v;
+	const struct syscall_metadata *m = *meta;
+
+	seq_printf(s, "%d:", m->syscall_nr);
+	seq_printf(s, "%s\n", m->name);
+
+	return 0;
+}
+
+static void syscall_map_stop(struct seq_file *m, void *p)
+{
+}
+
+static const struct seq_operations show_syscall_map_seq_ops = {
+	.start = syscall_map_start,
+	.next = syscall_map_next,
+	.show = syscall_map_show,
+	.stop = syscall_map_stop,
+};
+
+static int syscall_map_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &show_syscall_map_seq_ops);
+}
+
+static const struct file_operations syscall_map_fops = {
+	.open = syscall_map_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = seq_release,
+};
+
+static __init int init_syscall_map(void)
+{
+	struct dentry *d_tracer;
+
+	d_tracer = tracing_init_dentry();
+	if (!d_tracer)
+		return 0;
+
+	trace_create_file("syscall_map", 0444, d_tracer,
+			  NULL, &syscall_map_fops);
+
+	return 0;
+}
+
+fs_initcall(init_syscall_map);
+
 #endif /* CONFIG_PERF_EVENTS */
 
-- 
1.6.4.GIT

