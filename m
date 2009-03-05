Return-Path: <linux-kernel-owner+w=401wt.eu-S1757788AbZCEX1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757788AbZCEX1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 18:27:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757578AbZCEX1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 18:27:06 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:33598 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757253AbZCEX1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 18:27:04 -0500
Message-Id: <20090305225518.820107709@polymtl.ca>
References: <20090305224728.947235917@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 05 Mar 2009 17:48:00 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, ltt-dev@lists.casi.polymtl.ca,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Martin Bligh <mbligh@google.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       mrubin@google.com, md@google.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [RFC patch 32/41] LTTng filter
Content-Disposition: inline; filename=lttng-filter.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu,  5 Mar 2009 23:14:15 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Filter module providing the filter/ directory entry.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/linux/ltt-tracer.h |    2 +
 ltt/Kconfig                |    3 ++
 ltt/Makefile               |    1 
 ltt/ltt-filter.c           |   66 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 72 insertions(+)

Index: linux-2.6-lttng/ltt/Makefile
===================================================================
--- linux-2.6-lttng.orig/ltt/Makefile	2009-03-05 16:09:53.000000000 -0500
+++ linux-2.6-lttng/ltt/Makefile	2009-03-05 16:10:10.000000000 -0500
@@ -13,3 +13,4 @@ obj-$(CONFIG_LTT_STATEDUMP)		+= ltt-stat
 obj-$(CONFIG_LTT_FAST_SERIALIZE)	+= ltt-type-serializer.o
 obj-$(CONFIG_LTT_TRACE_CONTROL)		+= ltt-trace-control.o
 obj-$(CONFIG_LTT_USERSPACE_EVENT)	+= ltt-userspace-event.o
+obj-$(CONFIG_LTT_FILTER)		+= ltt-filter.o
Index: linux-2.6-lttng/ltt/ltt-filter.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/ltt/ltt-filter.c	2009-03-05 16:09:59.000000000 -0500
@@ -0,0 +1,66 @@
+/*
+ * Copyright (C) 2008 Mathieu Desnoyers
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
+ */
+
+#include <linux/module.h>
+#include <linux/debugfs.h>
+#include <linux/fs.h>
+#include <linux/ltt-tracer.h>
+#include <linux/mutex.h>
+
+#define LTT_FILTER_DIR	"filter"
+
+/*
+ * Protects the ltt_filter_dir allocation.
+ */
+static DEFINE_MUTEX(ltt_filter_mutex);
+
+static struct dentry *ltt_filter_dir;
+
+struct dentry *get_filter_root(void)
+{
+	struct dentry *ltt_root_dentry;
+
+	mutex_lock(&ltt_filter_mutex);
+	if (!ltt_filter_dir) {
+		ltt_root_dentry = get_ltt_root();
+		if (!ltt_root_dentry)
+			goto err_no_root;
+
+		ltt_filter_dir = debugfs_create_dir(LTT_FILTER_DIR,
+						    ltt_root_dentry);
+		if (!ltt_filter_dir)
+			printk(KERN_ERR
+				"ltt_filter_init: failed to create dir %s\n",
+				LTT_FILTER_DIR);
+	}
+err_no_root:
+	mutex_unlock(&ltt_filter_mutex);
+	return ltt_filter_dir;
+}
+EXPORT_SYMBOL_GPL(get_filter_root);
+
+static void __exit ltt_filter_exit(void)
+{
+	debugfs_remove(ltt_filter_dir);
+}
+
+module_exit(ltt_filter_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>");
+MODULE_DESCRIPTION("Linux Trace Toolkit Filter");
Index: linux-2.6-lttng/include/linux/ltt-tracer.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/ltt-tracer.h	2009-03-05 16:08:41.000000000 -0500
+++ linux-2.6-lttng/include/linux/ltt-tracer.h	2009-03-05 16:09:59.000000000 -0500
@@ -648,6 +648,8 @@ enum ltt_filter_control_msg {
 extern int ltt_filter_control(enum ltt_filter_control_msg msg,
 		const char *trace_name);
 
+extern struct dentry *get_filter_root(void);
+
 void ltt_write_trace_header(struct ltt_trace_struct *trace,
 		struct ltt_subbuffer_header *header);
 extern void ltt_buffer_destroy(struct ltt_channel_struct *ltt_chan);
Index: linux-2.6-lttng/ltt/Kconfig
===================================================================
--- linux-2.6-lttng.orig/ltt/Kconfig	2009-03-05 16:09:41.000000000 -0500
+++ linux-2.6-lttng/ltt/Kconfig	2009-03-05 16:09:59.000000000 -0500
@@ -28,6 +28,9 @@ menuconfig LTT
 
 if LTT
 
+config LTT_FILTER
+	tristate
+
 config LTT_RELAY_ALLOC
 	def_bool n
 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
