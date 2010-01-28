Return-Path: <linux-kernel-owner+w=401wt.eu-S1756159Ab0A1Jei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab0A1Jei (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 04:34:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755665Ab0A1Jec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 04:34:32 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:56106 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768Ab0A1Jea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 04:34:30 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Thu, 28 Jan 2010 10:34:21 +0100
From: Tomasz Fujak <t.fujak@samsung.com>
Subject: [PATCH/RFC v2 1/3] perfevents: Added performance event structure
 definition, export event description in the debugfs "perf_events_platform" file
In-reply-to: <1264671263-21412-1-git-send-email-t.fujak@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: acme@redhat.com, jamie.iles@picochip.com, will.deacon@arm.com,
       jpihet@mvista.com, mingo@elte.hu, peterz@infradead.org,
       p.osciak@samsung.com, m.szyprowski@samsung.com,
       kyungmin.park@samsung.com, m.nazarewicz@samsung.com,
       Tomasz Fujak <t.fujak@samsung.com>
Message-id: <1264671263-21412-2-git-send-email-t.fujak@samsung.com>
X-Mailer: git-send-email 1.6.5.3
References: <1264671263-21412-1-git-send-email-t.fujak@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomasz Fujak <t.fujak@samsung.com>
Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Pawel Osciak <p.osciak@samsung.com>
Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>

---
 include/linux/perf_event.h |   19 +++++++++
 kernel/perf_event.c        |   92 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 111 insertions(+), 0 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index c66b34f..b50e2b8 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -458,6 +458,12 @@ enum perf_callchain_context {
 
 #define PERF_MAX_STACK_DEPTH		255
 
+#define PERF_EVENT_RAW_BIT			(1ULL << 63)
+#define PERF_EVENT_RAW_TO_CONFIG(_val)	((_val) | PERF_EVENT_RAW_BIT)
+#define PERF_EVENT_CONFIG_TO_RAW(_val)	((_val) & ~PERF_EVENT_RAW_BIT)
+#define PERF_EVENT_IS_RAW(_val)		((_val) & PERF_EVENT_RAW_BIT)
+
+
 struct perf_callchain_entry {
 	__u64				nr;
 	__u64				ip[PERF_MAX_STACK_DEPTH];
@@ -554,6 +560,19 @@ struct perf_mmap_data {
 	void				*data_pages[0];
 };
 
+struct perf_event_description {
+	struct list_head	list;
+
+	/* type : 1, subsystem [0..7], id [56..63]*/
+	__u64				config;
+	__u64				min_value;	/* min. wakeup period */
+	__u64				max_value;	/* max. wakeup period */
+	__u32				flags;		/* ??? */
+	__u32				reserved[3];
+	char				*name;
+	char				*description;
+};
+
 struct perf_pending_entry {
 	struct perf_pending_entry *next;
 	void (*func)(struct perf_pending_entry *);
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 603c0d8..dc68f0b 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -31,6 +31,9 @@
 #include <linux/ftrace_event.h>
 #include <linux/hw_breakpoint.h>
 
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+
 #include <asm/irq_regs.h>
 
 /*
@@ -99,6 +102,10 @@ void __weak hw_perf_enable(void)		{ barrier(); }
 void __weak hw_perf_event_setup(int cpu)	{ barrier(); }
 void __weak hw_perf_event_setup_online(int cpu)	{ barrier(); }
 
+static LIST_HEAD(perf_event_empty);
+
+const struct list_head __weak *perf_events_platform;
+
 int __weak
 hw_perf_group_sched_in(struct perf_event *group_leader,
 	       struct perf_cpu_context *cpuctx,
@@ -5333,6 +5340,83 @@ perf_set_overcommit(struct sysdev_class *class, const char *buf, size_t count)
 	return count;
 }
 
+static void *platevent_seq_start(struct seq_file *s, loff_t *pos)
+{
+	struct list_head *spos = NULL;
+
+	if (perf_events_platform) {
+		loff_t count = *pos;
+		struct list_head *curr;
+
+		list_for_each(curr, perf_events_platform)
+			if (!count--)
+				break;
+
+		if (curr != perf_events_platform) {
+			s->private = perf_events_platform;
+			spos = curr;
+		}
+	}
+
+	return spos;
+}
+
+static void *platevent_seq_next(struct seq_file *s, void *v, loff_t *pos)
+{
+	struct list_head *curr = (struct list_head *)v;
+	struct list_head *head = (struct list_head *)s->private;
+
+	if (list_is_last(curr, head))
+		return NULL;
+
+	++(*pos);
+	return curr->next;
+}
+
+static void platevent_seq_stop(struct seq_file *s, void *v)
+{
+	kfree(v);
+}
+
+static int platevent_seq_show(struct seq_file *s, void *v)
+{
+	struct list_head *curr = (struct list_head *)v;
+
+	if (curr) {
+		struct perf_event_description *entry = list_entry(curr,
+					struct perf_event_description, list);
+
+		if (PERF_EVENT_IS_RAW(entry->config))
+			seq_printf(s, "0x%llx\t%s\t%lld-%lld\t%s\n",
+			PERF_EVENT_CONFIG_TO_RAW(entry->config),
+			entry->name, entry->min_value,
+			entry->max_value, entry->description);
+	}
+
+	return 0;
+}
+
+static const struct seq_operations platevent_seq_ops = {
+	.start = platevent_seq_start,
+	.next  = platevent_seq_next,
+	.stop  = platevent_seq_stop,
+	.show  = platevent_seq_show
+};
+
+static int platevent_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &platevent_seq_ops);
+};
+
+static const struct file_operations platevent_file_ops = {
+	.owner   = THIS_MODULE,
+	.open    = platevent_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = seq_release
+};
+
+
 static SYSDEV_CLASS_ATTR(
 				reserve_percpu,
 				0644,
@@ -5358,8 +5442,16 @@ static struct attribute_group perfclass_attr_group = {
 	.name			= "perf_events",
 };
 
+
 static int __init perf_event_sysfs_init(void)
 {
+	struct dentry *dentry;
+
+	dentry = debugfs_create_file("perf_events_platform", 0444, NULL,
+			NULL, &platevent_file_ops);
+	if (!dentry)
+		printk(KERN_WARNING "Cannot create debugfs entry 'perf_events_platform'\n");
+
 	return sysfs_create_group(&cpu_sysdev_class.kset.kobj,
 				  &perfclass_attr_group);
 }
-- 
1.5.4.3

