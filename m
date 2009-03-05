Return-Path: <linux-kernel-owner+w=401wt.eu-S1758049AbZCEX3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049AbZCEX3q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 18:29:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757879AbZCEX2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 18:28:40 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:47920 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756790AbZCEX2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 18:28:39 -0500
Message-Id: <20090305225518.578359190@polymtl.ca>
References: <20090305224728.947235917@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 05 Mar 2009 17:47:59 -0500
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
Subject: [RFC patch 31/41] LTTng userspace event v2
Content-Disposition: inline; filename=lttng-userspace-write-event.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu,  5 Mar 2009 23:14:15 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add userspace event support to LTTng.

Simply has to write to :

/debugfs/ltt/write_event

E.g. :

echo "Error X happened !" > /debugfs/ltt/write_event

(assuming debugfs is mounted under /debugfs)

Todo :
Maybe use ltt_relay_user_blocking to block if channel is full rather than losing
an event ? Be careful about effect of stopped tracing on userspace...

Changelog :
- Support correctly when multiple strings are sent to the same write.
- Cut the strings at each \n or \0.
- Made sure we never return a count value larger than the requested count. Count
  is counting the number of _source_ data used, not the number of trace bytes
  written.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 ltt/Kconfig               |    9 +++
 ltt/Makefile              |    1 
 ltt/ltt-userspace-event.c |  131 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 141 insertions(+)

Index: linux-2.6-lttng/ltt/Kconfig
===================================================================
--- linux-2.6-lttng.orig/ltt/Kconfig	2009-03-05 16:09:08.000000000 -0500
+++ linux-2.6-lttng/ltt/Kconfig	2009-03-05 16:09:41.000000000 -0500
@@ -114,6 +114,15 @@ config LTT_DEBUG_EVENT_SIZE
 	help
 	  Tracer-internal option to help debugging event type encoding problems.
 
+config LTT_USERSPACE_EVENT
+	tristate "Support logging events from userspace"
+	depends on LTT_TRACER
+	depends on LTT_FAST_SERIALIZE
+	default m
+	help
+	  This option lets userspace write text events in
+	  /debugfs/ltt/write_event.
+
 config LTT_VMCORE
 	bool "Support trace extraction from crash dump"
 	default y
Index: linux-2.6-lttng/ltt/Makefile
===================================================================
--- linux-2.6-lttng.orig/ltt/Makefile	2009-03-05 16:09:20.000000000 -0500
+++ linux-2.6-lttng/ltt/Makefile	2009-03-05 16:09:53.000000000 -0500
@@ -12,3 +12,4 @@ obj-$(CONFIG_LTT_SERIALIZE)		+= ltt-seri
 obj-$(CONFIG_LTT_STATEDUMP)		+= ltt-statedump.o
 obj-$(CONFIG_LTT_FAST_SERIALIZE)	+= ltt-type-serializer.o
 obj-$(CONFIG_LTT_TRACE_CONTROL)		+= ltt-trace-control.o
+obj-$(CONFIG_LTT_USERSPACE_EVENT)	+= ltt-userspace-event.o
Index: linux-2.6-lttng/ltt/ltt-userspace-event.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/ltt/ltt-userspace-event.c	2009-03-05 16:09:41.000000000 -0500
@@ -0,0 +1,131 @@
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
+#include <linux/marker.h>
+#include <linux/uaccess.h>
+#include <linux/gfp.h>
+#include <linux/fs.h>
+#include <linux/debugfs.h>
+#include <linux/ltt-type-serializer.h>
+
+#define LTT_WRITE_EVENT_FILE	"write_event"
+
+DEFINE_MARKER(userspace, event, "string %s");
+static struct dentry *ltt_event_file;
+
+/**
+ * write_event - write a userspace string into the trace system
+ * @file: file pointer
+ * @user_buf: user string
+ * @count: length to copy, including the final NULL
+ * @ppos: unused
+ *
+ * Copy a string into a trace event, in channel "userspace", event "event".
+ * Copies until either \n or \0 is reached.
+ * On success, returns the number of bytes copied from the source, including the
+ * \n or \0 character (if there was one in the count range). It cannot return
+ * more than count.
+ * Inspired from tracing_mark_write implementation from Steven Rostedt and
+ * Ingo Molnar.
+ */
+static ssize_t write_event(struct file *file, const char __user *user_buf,
+		size_t count, loff_t *ppos)
+{
+	struct marker *marker;
+	char *buf, *end;
+	long copycount;
+	ssize_t ret;
+
+	buf = kmalloc(count + 1, GFP_KERNEL);
+	if (!buf) {
+		ret = -ENOMEM;
+		goto string_out;
+	}
+	copycount = strncpy_from_user(buf, user_buf, count);
+	if (copycount < 0) {
+		ret = -EFAULT;
+		goto string_err;
+	}
+	/* Cut from the first nil or newline. */
+	buf[copycount] = '\0';
+	end = strchr(buf, '\n');
+	if (end) {
+		*end = '\0';
+		copycount = end - buf;
+	}
+	/* Add final \0 to copycount */
+	copycount++;
+	marker = &GET_MARKER(userspace, event);
+	ltt_specialized_trace(marker, marker->single.probe_private,
+		buf, copycount, sizeof(char));
+	/* If there is no \0 nor \n in count, do not return a larger value */
+	ret = min_t(size_t, copycount, count);
+string_err:
+	kfree(buf);
+string_out:
+	return ret;
+}
+
+static const struct file_operations ltt_userspace_operations = {
+	.write = write_event,
+};
+
+static int __init ltt_userspace_init(void)
+{
+	struct dentry *ltt_root_dentry;
+	int err = 0;
+
+	ltt_root_dentry = get_ltt_root();
+	if (!ltt_root_dentry) {
+		err = -ENOENT;
+		goto err_no_root;
+	}
+
+	ltt_event_file = debugfs_create_file(LTT_WRITE_EVENT_FILE,
+					     S_IWUGO,
+					     ltt_root_dentry,
+					     NULL,
+					     &ltt_userspace_operations);
+	if (IS_ERR(ltt_event_file) || !ltt_event_file) {
+		printk(KERN_ERR
+			"ltt_userspace_init: failed to create file %s\n",
+			LTT_WRITE_EVENT_FILE);
+		err = -EPERM;
+		goto err_no_file;
+	}
+
+	return err;
+err_no_file:
+	put_ltt_root();
+err_no_root:
+	return err;
+}
+
+static void __exit ltt_userspace_exit(void)
+{
+	debugfs_remove(ltt_event_file);
+	put_ltt_root();
+}
+
+module_init(ltt_userspace_init);
+module_exit(ltt_userspace_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>");
+MODULE_DESCRIPTION("Linux Trace Toolkit Userspace Event");

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
