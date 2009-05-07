Return-Path: <linux-kernel-owner+w=401wt.eu-S1762217AbZEGDRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762217AbZEGDRA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 23:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756458AbZEGDOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 23:14:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48268 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214AbZEGDOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 23:14:35 -0400
Message-Id: <20090507031434.807772092@goodmis.org>
References: <20090507031335.815354104@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 06 May 2009 23:13:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 7/7] tracing: add hierarchical enabling of events
Content-Disposition: inline; filename=0007-tracing-add-hierarchical-enabling-of-events.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

With the current event directory, you can only enable individual events.
The file debugfs/tracing/set_event is used to be able to enable or
disable several events at once. But that can still be awkward.

This patch adds hierarchical enabling of events. That is, each directory
in debugfs/tracing/events has an "enable" file. This file can enable
or disable all events within the directory and below.

 # echo 1 > /debugfs/tracing/events/enable

will enable all events.

 # echo 1 > /debugfs/tracing/events/sched/enable

will enable all events in the sched subsystem.

 # echo 1 > /debugfs/tracing/events/enable
 # echo 0 > /debugfs/tracing/events/irq/enable

will enable all events, but then disable just the irq subsystem events.

When reading one of these enable files, there are four results:

 0 - all events this file affects are disabled
 1 - all events this file affects are enabled
 X - there is a mixture of events enabled and disabled
 ? - this file does not affect any event

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |  140 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 140 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 6d2c842..87feb01 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -400,6 +400,133 @@ event_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	return cnt;
 }
 
+static ssize_t
+system_enable_read(struct file *filp, char __user *ubuf, size_t cnt,
+		   loff_t *ppos)
+{
+	const char *system = filp->private_data;
+	struct ftrace_event_call *call;
+	char buf[2];
+	int set = -1;
+	int all = 0;
+	int ret;
+
+	if (system[0] == '*')
+		all = 1;
+
+	mutex_lock(&event_mutex);
+	list_for_each_entry(call, &ftrace_events, list) {
+		if (!call->name || !call->regfunc)
+			continue;
+
+		if (!all && strcmp(call->system, system) != 0)
+			continue;
+
+		/*
+		 * We need to find out if all the events are set
+		 * or if all events or cleared, or if we have
+		 * a mixture.
+		 */
+		if (call->enabled) {
+			switch (set) {
+			case -1:
+				set = 1;
+				break;
+			case 0:
+				set = 2;
+				break;
+			}
+		} else {
+			switch (set) {
+			case -1:
+				set = 0;
+				break;
+			case 1:
+				set = 2;
+				break;
+			}
+		}
+		/*
+		 * If we have a mixture, no need to look further.
+		 */
+		if (set == 2)
+			break;
+	}
+	mutex_unlock(&event_mutex);
+
+	buf[1] = '\n';
+	switch (set) {
+	case 0:
+		buf[0] = '0';
+		break;
+	case 1:
+		buf[0] = '1';
+		break;
+	case 2:
+		buf[0] = 'X';
+		break;
+	default:
+		buf[0] = '?';
+	}
+
+	ret = simple_read_from_buffer(ubuf, cnt, ppos, buf, 2);
+
+	return ret;
+}
+
+static ssize_t
+system_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
+		    loff_t *ppos)
+{
+	const char *system = filp->private_data;
+	unsigned long val;
+	char *command;
+	char buf[64];
+	ssize_t ret;
+
+	if (cnt >= sizeof(buf))
+		return -EINVAL;
+
+	if (copy_from_user(&buf, ubuf, cnt))
+		return -EFAULT;
+
+	buf[cnt] = 0;
+
+	ret = strict_strtoul(buf, 10, &val);
+	if (ret < 0)
+		return ret;
+
+	ret = tracing_update_buffers();
+	if (ret < 0)
+		return ret;
+
+	switch (val) {
+	case 0:
+	case 1:
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	command = kstrdup(system, GFP_KERNEL);
+	if (!command)
+		return -ENOMEM;
+
+	ret = ftrace_set_clr_event(command, val);
+	if (ret)
+		goto out_free;
+
+	ret = cnt;
+
+ out_free:
+	kfree(command);
+
+	*ppos += cnt;
+
+	return ret;
+}
+
 extern char *__bad_type_size(void);
 
 #undef FIELD
@@ -686,6 +813,12 @@ static const struct file_operations ftrace_subsystem_filter_fops = {
 	.write = subsystem_filter_write,
 };
 
+static const struct file_operations ftrace_system_enable_fops = {
+	.open = tracing_open_generic,
+	.read = system_enable_read,
+	.write = system_enable_write,
+};
+
 static const struct file_operations ftrace_show_header_fops = {
 	.open = tracing_open_generic,
 	.read = show_header,
@@ -768,6 +901,10 @@ event_subsystem_dir(const char *name, struct dentry *d_events)
 			   "'%s/filter' entry\n", name);
 	}
 
+	entry = trace_create_file("enable", 0644, system->entry,
+				  (void *)system->name,
+				  &ftrace_system_enable_fops);
+
 	return system->entry;
 }
 
@@ -1041,6 +1178,9 @@ static __init int event_trace_init(void)
 			  ring_buffer_print_entry_header,
 			  &ftrace_show_header_fops);
 
+	trace_create_file("enable", 0644, d_events,
+			  "*:*", &ftrace_system_enable_fops);
+
 	for_each_event(call, __start_ftrace_events, __stop_ftrace_events) {
 		/* The linker may leave blanks */
 		if (!call->name)
-- 
1.6.2.4

-- 
