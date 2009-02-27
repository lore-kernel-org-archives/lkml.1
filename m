Return-Path: <linux-kernel-owner+w=401wt.eu-S1750892AbZB0JCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750892AbZB0JCF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 04:02:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755456AbZB0JBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 04:01:20 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:24533 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815AbZB0JBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 04:01:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=Z4qF/NcaPM04kLJFdEFk/HnI/xz9xhCqaqEuGC7nu9AUg4mIbDLdgvRRwvaFQY8Dhf
         InEiN0cHehaWOfAl68/xhKJBLrVLVau4ScuPxtGwIhk9iZXoBptaMbwqFPJiJN5EOdYv
         zHkdKvWpNUszLLvuyhbOShVLqixZohYccS0wE=
Subject: [PATCH 2/4] zedtrace generic kernel filtering
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 27 Feb 2009 03:00:56 -0600
Message-Id: <1235725256.8512.88.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add generic kernel filtering.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>

---
 kernel/trace/trace_binary/Makefile     |    2 +-
 kernel/trace/trace_binary/zed.c        |  103 +++++++++--
 kernel/trace/trace_binary/zed.h        |   15 ++
 kernel/trace/trace_binary/zed_filter.c |  301 ++++++++++++++++++++++++++++++++
 kernel/trace/trace_binary/zed_filter.h |   45 +++++
 kernel/trace/trace_binary/zed_sched.c  |    4 +
 6 files changed, 451 insertions(+), 19 deletions(-)
 create mode 100644 kernel/trace/trace_binary/zed_filter.c
 create mode 100644 kernel/trace/trace_binary/zed_filter.h

diff --git a/kernel/trace/trace_binary/Makefile b/kernel/trace/trace_binary/Makefile
index 558e17a..26b3c8e 100644
--- a/kernel/trace/trace_binary/Makefile
+++ b/kernel/trace/trace_binary/Makefile
@@ -1,3 +1,3 @@
 obj-$(CONFIG_ZEDTRACE) += zedtrace.o
 
-zedtrace-objs := zed.o zed_sched.o
+zedtrace-objs := zed.o zed_filter.o zed_sched.o
diff --git a/kernel/trace/trace_binary/zed.c b/kernel/trace/trace_binary/zed.c
index 171d2e5..13d301e 100644
--- a/kernel/trace/trace_binary/zed.c
+++ b/kernel/trace/trace_binary/zed.c
@@ -25,6 +25,7 @@
 #include <linux/debugfs.h>
 #include <trace/sched.h>
 #include "zed.h"
+#include "zed_filter.h"
 
 /* globals */
 
@@ -118,6 +119,7 @@ static ssize_t zed_event_desc_read(struct file *filp, char __user *buffer,
 				  field->name, field->type, field->offset,
 				  field->size);
 	}
+	length += print_preds(event, page, length);
 
 	if (length >= 0)
 		length = simple_read_from_buffer(buffer, count, ppos, page,
@@ -133,8 +135,10 @@ static ssize_t zed_event_desc_write(struct file *filp,
 				    size_t count, loff_t *ppos)
 {
 	struct zed_event *event = filp->private_data;
-	char buf[32], *tmp;
-	int enable;
+	char buf[32], *pbuf = buf;
+	char *field_name = NULL;
+	int compound = 0, or = 0, not = 0, enable;
+	unsigned long long val;
 
 	if (count > sizeof(buf))
 		return -EINVAL;
@@ -144,14 +148,22 @@ static ssize_t zed_event_desc_write(struct file *filp,
 	if (copy_from_user(buf, buffer, count))
 		return -EFAULT;
 
-	enable = simple_strtol(buf, &tmp, 10);
-	if (tmp == buf)
+	enable = parse_filter_enable(&pbuf, &not, &or, &compound,
+				     &field_name, &val);
+	if (enable < 0)
 		return -EINVAL;
 
-	if (enable)
-		*event->trace_flags = 1;
-	else
+	if (enable == 1) {
 		*event->trace_flags = 0;
+		zed_free_preds(event);
+		return count;
+	} else if (enable == 2) {
+		*event->trace_flags = 1;
+		return count;
+	}
+
+	if (zed_add_pred(event, field_name, val, not, or, !compound))
+		return -EINVAL;
 
 	return count;
 }
@@ -192,8 +204,11 @@ static void subsys_enable_all(char *subsys, int enable)
 		event = zed_events[i];
 		if (!event)
 			break;
-		if (!strcmp(event->subsys_name, subsys))
+		if (!strcmp(event->subsys_name, subsys)) {
 			*event->trace_flags = enable;
+			if (!enable)
+				zed_free_preds(event);
+		}
 	}
 }
 
@@ -207,6 +222,40 @@ static void enable_all(int enable)
 		if (!event)
 			break;
 		*event->trace_flags = enable;
+		if (!enable)
+			zed_free_preds(event);
+	}
+}
+
+static void subsys_pred_all(char *subsys, char *field_name,
+			    unsigned long long val, int not, int or,
+			    int compound)
+{
+	struct zed_event *event;
+	int i;
+
+	for (i = 0; i < MAX_EVENTS; i++) {
+		event = zed_events[i];
+		if (!event)
+			break;
+		if (!strcmp(event->subsys_name, subsys))
+			zed_add_pred(event, field_name, val, not, or,
+				     !compound);
+	}
+}
+
+static void pred_all(char *field_name,
+		     unsigned long long val, int not, int or,
+		     int compound)
+{
+	struct zed_event *event;
+	int i;
+
+	for (i = 0; i < MAX_EVENTS; i++) {
+		event = zed_events[i];
+		if (!event)
+			break;
+		zed_add_pred(event, field_name, val, not, or, !compound);
 	}
 }
 
@@ -221,8 +270,10 @@ static ssize_t all_write(struct file *filp, const char __user *buffer,
 			 size_t count, loff_t *ppos)
 {
 	char *subsys = filp->private_data;
-	char buf[32], *tmp;
-	int enable;
+	char buf[32], *pbuf = buf;
+	char *field_name = NULL;
+	int compound = 0, or = 0, not = 0, enable;
+	unsigned long long val;
 
 	if (count > sizeof(buf))
 		return -EINVAL;
@@ -232,22 +283,31 @@ static ssize_t all_write(struct file *filp, const char __user *buffer,
 	if (copy_from_user(buf, buffer, count))
 		return -EFAULT;
 
-	enable = simple_strtol(buf, &tmp, 10);
-	if (tmp == buf)
+	enable = parse_filter_enable(&pbuf, &not, &or, &compound,
+				     &field_name, &val);
+
+	if (enable < 0)
 		return -EINVAL;
 
-	if (enable) {
-		if (subsys)
-			subsys_enable_all(subsys, 1);
-		else
-			enable_all(1);
-	} else {
+	if (enable == 1) {
 		if (subsys)
 			subsys_enable_all(subsys, 0);
 		else
 			enable_all(0);
+		return count;
+	} else if (enable == 2) {
+		if (subsys)
+			subsys_enable_all(subsys, 1);
+		else
+			enable_all(1);
+		return count;
 	}
 
+	if (subsys)
+		subsys_pred_all(subsys, field_name, val, not, or, compound);
+	else
+		pred_all(field_name, val, not, or, compound);
+
 	return count;
 }
 
@@ -318,6 +378,11 @@ static int remove_subsys(char *name)
 	return 0;
 }
 
+void zed_set_core_event(enum zed_event_id event_id)
+{
+	zed_events[event_id]->core = 1;
+}
+
 /**
  *	register_zed_event() - create an event description file for an event
  */
@@ -348,6 +413,8 @@ static struct zed_event *register_zed_event(char *subsys_name,
 	event->size = event_size;
 	event->trace_flags = trace_flags;
 	event->subsys_name = subsys->name;
+	event->preds = NULL;
+	event->core = 0;
 
 	register_zed_field(event, "magic", "u32",
 			   offsetof(struct zed_header, magic),
diff --git a/kernel/trace/trace_binary/zed.h b/kernel/trace/trace_binary/zed.h
index 3cbef4b..56a6295 100644
--- a/kernel/trace/trace_binary/zed.h
+++ b/kernel/trace/trace_binary/zed.h
@@ -100,6 +100,8 @@ struct zed_event {
 	int size;
 	int *trace_flags;
 	struct list_head field_list;
+	struct zed_pred **preds;
+	int core;
 };
 
 /*
@@ -118,6 +120,8 @@ extern struct zed_event *zed_events[MAX_EVENTS];
 extern u32 *zed_trace_sequence;
 extern unsigned int zed_tracing;
 
+#include "zed_filter.h"
+
 /*
  * event definition macros
  */
@@ -169,6 +173,8 @@ ID_EVENTS(EVENTS(EVENT_ID, COMMA));
 
 EVENTS(DECLARE_EVENT, SEMICOLON);
 
+extern void zed_set_core_event(enum zed_event_id event_id);
+
 /*
  * Macros to generate boilerplate tracepoint entry/exit code.
 */
@@ -208,9 +214,18 @@ EVENTS(DECLARE_EVENT, SEMICOLON);
 
 #define ZED_TRACEPOINT_EXIT(name)					\
 	exit:								\
+	if (zed_events[name##_trace]->preds)				\
+		if (!zed_match_preds(zed_events[name##_trace], zed_event)) \
+			zed_unreserve(name##_trace, var_len);		\
 	local_irq_restore(zed_flags);					\
 	}								\
 
+static inline void zed_unreserve(enum zed_event_id event_id, int var_len)
+{
+	struct rchan_buf *buf = zed_channel->buf[smp_processor_id()];
+	buf->offset -= zed_events[event_id]->size + var_len;
+}
+
 /**
  *	zed_reserve() - reserve a slot large enough for event_id
  *	@event_id: auto-generated event id (see documentation)
diff --git a/kernel/trace/trace_binary/zed_filter.c b/kernel/trace/trace_binary/zed_filter.c
new file mode 100644
index 0000000..f467bf0
--- /dev/null
+++ b/kernel/trace/trace_binary/zed_filter.c
@@ -0,0 +1,301 @@
+/*
+ * zed_filter - generic event filtering
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) 2009 Tom Zanussi <tzanussi@gmail.com>
+ */
+
+#include <linux/module.h>
+#include <linux/list.h>
+#include <linux/jhash.h>
+#include <linux/vmalloc.h>
+#include <linux/debugfs.h>
+#include <trace/sched.h>
+#include <trace/block.h>
+#include "zed.h"
+
+static int zed_pred_64(struct zed_pred *pred, void *event)
+{
+	u64 *addr = (u64 *)(event + pred->offset);
+	u64 val = (u64)pred->val;
+	int match;
+
+	match = (val == *addr) ^ pred->not;
+
+	return match;
+}
+
+static int zed_pred_32(struct zed_pred *pred, void *event)
+{
+	u32 *addr = (u32 *)(event + pred->offset);
+	u32 val = (u32)pred->val;
+	int match;
+
+	match = (val == *addr) ^ pred->not;
+
+	return match;
+}
+
+static int zed_pred_16(struct zed_pred *pred, void *event)
+{
+	u16 *addr = (u16 *)(event + pred->offset);
+	u16 val = (u16)pred->val;
+	int match;
+
+	match = (val == *addr) ^ pred->not;
+
+	return match;
+}
+
+static int zed_pred_8(struct zed_pred *pred, void *event)
+{
+	u8 *addr = (u8 *)(event + pred->offset);
+	u8 val = (u8)pred->val;
+	int match;
+
+	match = (val == *addr) ^ pred->not;
+
+	return match;
+}
+
+static char *field_with_offset(struct zed_event *event, int offset)
+{
+	struct zed_field *field;
+	struct list_head *entry, *tmp;
+
+	list_for_each_safe(entry, tmp, &event->field_list) {
+		field = list_entry(entry, struct zed_field, link);
+		if (field->offset == offset)
+			return field->name;
+	}
+	return NULL;
+}
+
+/**
+ *	zed_match_preds() - return 1 if event matches, 0 otherwise (discard)
+ */
+int zed_match_preds(struct zed_event *event, void *rec)
+{
+	struct zed_pred *pred;
+	int i, matched;
+
+	for (i = 0; i < MAX_PRED; i++) {
+		if (event->preds[i]) {
+			pred = event->preds[i];
+			matched = pred->fn(pred, rec);
+			if (!matched && !pred->or)
+				return 0;
+			if (matched && pred->or)
+				return 1;
+		} else
+			break;
+	}
+
+	return 1;
+}
+
+ssize_t print_preds(struct zed_event *event, char *page, ssize_t length)
+{
+	ssize_t this_len = 0;
+	char *field_name;
+	struct zed_pred *pred;
+	int i;
+
+	this_len += sprintf(page + length + this_len, "filters:\n\t");
+	if (!event->preds) {
+		this_len += sprintf(page + length + this_len, "none\n");
+		return this_len;
+	}
+
+	for (i = 0; i < MAX_PRED; i++) {
+		if (event->preds[i]) {
+			pred = event->preds[i];
+			field_name = field_with_offset(event, pred->offset);
+			if (i)
+				this_len += sprintf(page + length + this_len,
+					    pred->or ? "\tor " : "\tand ");
+			this_len += sprintf(page + length + this_len,
+					    "%s ", field_name);
+			this_len += sprintf(page + length + this_len,
+					    pred->not ? "!= " : "== ");
+			this_len += sprintf(page + length + this_len,
+					    "%llu\n", pred->val);
+		} else
+			break;
+	}
+
+	return this_len;
+}
+
+void zed_free_preds(struct zed_event *event)
+{
+	if (event->preds) {
+		int i;
+		for (i = 0; i < MAX_PRED; i++) {
+			kfree(event->preds[i]);
+			event->preds[i] = NULL;
+		}
+		kfree(event->preds);
+		event->preds = NULL;
+	}
+}
+
+static int __zed_add_pred(struct zed_event *event,
+			  zed_pred_t fn, u64 val, int offset,
+			  int not, int or, int clear)
+{
+	int i;
+	struct zed_pred *pred = kmalloc(sizeof(*pred), GFP_KERNEL);
+
+	if (!pred)
+		return -ENOMEM;
+
+	pred->fn = fn;
+	pred->val = val;
+	pred->offset = offset;
+	pred->not = not;
+	pred->or = or;
+
+	if (event->preds && clear)
+		zed_free_preds(event);
+
+	if (!event->preds) {
+		event->preds = kzalloc(MAX_PRED * sizeof(pred), GFP_KERNEL);
+		if (!event->preds)
+			return -ENOMEM;
+	}
+
+	for (i = 0; i < MAX_PRED; i++) {
+		if (!event->preds[i]) {
+			event->preds[i] = pred;
+			return 0;
+		}
+	}
+	return -ENOMEM;
+}
+
+static struct zed_field *find_zed_field(struct zed_event *event,
+					char *field_name)
+{
+	struct zed_field *field;
+	struct list_head *entry, *tmp;
+
+	list_for_each_safe(entry, tmp, &event->field_list) {
+		field = list_entry(entry, struct zed_field, link);
+		if (!strcmp(field->name, field_name))
+			return field;
+	}
+	return NULL;
+}
+
+int zed_add_pred(struct zed_event *event, char *field_name,
+		 u64 val, int not, int or, int clear)
+{
+	struct zed_field *field;
+	zed_pred_t fn;
+
+	if (event->core)
+		return -EINVAL;
+
+	field = find_zed_field(event, field_name);
+	if (!field)
+		return -EINVAL;
+
+	switch (field->size) {
+	case 8:
+		fn = zed_pred_64;
+		break;
+	case 4:
+		fn = zed_pred_32;
+		break;
+	case 2:
+		fn = zed_pred_16;
+		break;
+	case 1:
+		fn = zed_pred_8;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return __zed_add_pred(event, fn, val, field->offset, not, or, clear);
+}
+
+int parse_filter_enable(char **pbuf, int *not, int *or, int *compound,
+			char **field_name, unsigned long long *val)
+{
+	char *tmp, *tok, *val_str = NULL;
+	int tok_n = 0;
+
+	/* field ==/!= number, or/and field ==/!= number, number */
+	while ((tok = strsep(pbuf, " \n"))) {
+		if (tok_n == 0) {
+			if (!strcmp(tok, "0"))
+				return 1;
+			else if (!strcmp(tok, "1"))
+				return 2;
+			else if (!strcmp(tok, "and")) {
+				*or = 0;
+				*compound = 1;
+			} else if (!strcmp(tok, "or")) {
+				*or = 1;
+				*compound = 1;
+			} else
+				*field_name = tok;
+			tok_n = 1;
+			continue;
+		}
+		if (tok_n == 1) {
+			if (!*field_name)
+				*field_name = tok;
+			else if (!strcmp(tok, "!="))
+				*not = 1;
+			else if (!strcmp(tok, "=="))
+				*not = 0;
+			else
+				return -EINVAL;
+			tok_n = 2;
+			continue;
+		}
+		if (tok_n == 2) {
+			if (*compound) {
+				if (!strcmp(tok, "!="))
+					*not = 1;
+				else if (!strcmp(tok, "=="))
+					*not = 0;
+				else
+					return -EINVAL;
+			} else {
+				val_str = tok;
+				break; /* done */
+			}
+			tok_n = 3;
+			continue;
+		}
+		if (tok_n == 3) {
+			val_str = tok;
+			break; /* done */
+		}
+	}
+
+	*val = simple_strtoull(val_str, &tmp, 10);
+	if (tmp == val_str)
+		return -EINVAL;
+
+	return 0;
+}
+
+
diff --git a/kernel/trace/trace_binary/zed_filter.h b/kernel/trace/trace_binary/zed_filter.h
new file mode 100644
index 0000000..1942eb9
--- /dev/null
+++ b/kernel/trace/trace_binary/zed_filter.h
@@ -0,0 +1,45 @@
+/*
+ * zedtrace filter declarations
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) 2009 Tom Zanussi <tzanussi@gmail.com>
+ */
+
+#ifndef _ZED_FILTER_H
+#define _ZED_FILTER_H
+
+#define MAX_PRED 8
+
+typedef int (*zed_pred_t) (struct zed_pred *pred, void *event);
+
+struct zed_pred {
+	zed_pred_t fn;
+	u64 val;
+	int offset;
+	int not;
+	int or;
+};
+
+extern ssize_t print_preds(struct zed_event *event, char *page,
+			   ssize_t length);
+extern int parse_filter_enable(char **pbuf, int *not, int *or, int *compound,
+			       char **field_name, unsigned long long *val);
+extern int zed_add_pred(struct zed_event *event, char *field_name,
+			u64 val, int not, int or, int clear);
+extern void zed_free_preds(struct zed_event *event);
+extern int zed_match_preds(struct zed_event *event, void *rec);
+
+#endif /* _ZED_FILTER_H */
diff --git a/kernel/trace/trace_binary/zed_sched.c b/kernel/trace/trace_binary/zed_sched.c
index 8eba079..9d9bcc8 100644
--- a/kernel/trace/trace_binary/zed_sched.c
+++ b/kernel/trace/trace_binary/zed_sched.c
@@ -197,5 +197,9 @@ void zed_disable_sched_tracepoints(void)
 
 void zed_sched_init(void)
 {
+	zed_set_core_event(sched_switch_trace);
+	zed_set_core_event(sched_migrate_task_trace);
+	zed_set_core_event(sched_process_fork_trace);
+	zed_set_core_event(sched_process_exit_trace);
 }
 
-- 
1.5.6.3



