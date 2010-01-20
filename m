Return-Path: <linux-kernel-owner+w=401wt.eu-S1751951Ab0ATJV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951Ab0ATJV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 04:21:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673Ab0ATJVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 04:21:55 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:10076 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab0ATJVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 04:21:54 -0500
X-Greylist: delayed 601 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Jan 2010 04:21:54 EST
Date: Wed, 20 Jan 2010 10:11:45 +0100
From: Tomasz Fujak <t.fujak@samsung.com>
Subject: [PATCH v1 1/2] perfevent: Add performance event structure definition
 and 'extevents' sysfs entry
In-reply-to: <1263978706-15499-1-git-send-email-t.fujak@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: jamie.iles@picochip.com, will.deacon@arm.com, jpihet@mvista.com,
       mingo@elte.hu, peterz@infradead.org, p.osciak@samsung.com,
       m.szyprowski@samsung.com, kyungmin.park@samsung.com,
       Tomasz Fujak <t.fujak@samsung.com>
Message-id: <1263978706-15499-2-git-send-email-t.fujak@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.6.5.3
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1263978706-15499-1-git-send-email-t.fujak@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a structure that contains single hardware performance event
 definition (including name and description fields), and sysfs entry suited
to export machine-dependent list of events.

Signed-off-by: Tomasz Fujak <t.fujak@samsung.com>
Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>

---
 include/linux/perf_event.h |   19 +++++++++++++++++++
 kernel/perf_event.c        |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 9e70126..4dc4d73 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -447,6 +447,12 @@ enum perf_callchain_context {
 
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
@@ -538,6 +544,19 @@ struct perf_mmap_data {
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
index 7f29643..4223870 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -97,6 +97,13 @@ void __weak hw_perf_enable(void)		{ barrier(); }
 void __weak hw_perf_event_setup(int cpu)	{ barrier(); }
 void __weak hw_perf_event_setup_online(int cpu)	{ barrier(); }
 
+static LIST_HEAD(perf_event_empty);
+
+const struct list_head __weak *hw_perf_event_get_list(void)
+{
+	return &perf_event_empty;
+}
+
 int __weak
 hw_perf_group_sched_in(struct perf_event *group_leader,
 	       struct perf_cpu_context *cpuctx,
@@ -5097,6 +5104,23 @@ perf_set_overcommit(struct sysdev_class *class, const char *buf, size_t count)
 	return count;
 }
 
+static ssize_t perf_show_extevents(struct sysdev_class *class, char *buf)
+{
+	char *str = buf;
+	const struct list_head *head = hw_perf_event_get_list();
+	const struct perf_event_description *entry;
+
+	list_for_each_entry(entry, head, list)
+		if (PERF_EVENT_IS_RAW(entry->config))
+			str +=  sprintf(str, "0x%llx\t%s\t%lld-%lld\t%s\n",
+				PERF_EVENT_CONFIG_TO_RAW(entry->config),
+				entry->name, entry->min_value,
+				entry->max_value, entry->description);
+
+	return str - buf;
+}
+
+
 static SYSDEV_CLASS_ATTR(
 				reserve_percpu,
 				0644,
@@ -5111,9 +5135,17 @@ static SYSDEV_CLASS_ATTR(
 				perf_set_overcommit
 			);
 
+static SYSDEV_CLASS_ATTR(
+				extevents,
+				0444,
+				perf_show_extevents,
+				NULL
+			);
+
 static struct attribute *perfclass_attrs[] = {
 	&attr_reserve_percpu.attr,
 	&attr_overcommit.attr,
+	&attr_extevents.attr,
 	NULL
 };
 
-- 
1.5.4.3

