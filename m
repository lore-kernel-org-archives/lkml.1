Return-Path: <linux-kernel-owner+w=401wt.eu-S1756420AbYLOXK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420AbYLOXK4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 18:10:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709AbYLOXKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 18:10:47 -0500
Received: from tomts13.bellnexxia.net ([209.226.175.34]:41036 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752673AbYLOXKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 18:10:44 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AroEAPlsRklMROB9/2dsb2JhbACBbMsogn4
Date: Mon, 15 Dec 2008 18:10:40 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: ltt-dev@lists.casi.polymtl.ca
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] Simple LTTng userspace events through debugfs
Message-ID: <20081215231040.GA5936@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:56:30 up 28 days, 22:36,  5 users,  load average: 0.65, 0.80,
	0.63
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I looked at kmemtrace and noticed that the presence of a debugfs
"marker" file, which lets userspace write events into the trace buffers.

So I just did the same with a 

/debugfs/ltt/write_event

file in LTTng. This should be OK for userspace tracing which does not
require high throughput. It allows userspace to write a string up to
4095-bytes long into the channel named "userspace", event named "event".

This new feature is available in LTTng 0.68 (for kernel 2.6.27.9). For
the curious, I provide the patch applied on top of the LTTng tree below.

Mathieu


LTTng userspace event

Add userspace event support to LTTng.

Simply has to write to :

/debugfs/ltt/write_event

E.g. :

echo "Error X happened !" > /debugfs/ltt/write_event

(assuming debugfs is mounted under /debugfs)

Todo :
Maybe use ltt_relay_user_blocking to block if channel is full rather than losing
an event ? Be careful about effect of stopped tracing on userspace...

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 ltt/Kconfig               |    9 +++
 ltt/Makefile              |    1 
 ltt/ltt-userspace-event.c |  120 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 130 insertions(+)

Index: linux-2.6-lttng/ltt/Kconfig
===================================================================
--- linux-2.6-lttng.orig/ltt/Kconfig	2008-12-15 16:18:04.000000000 -0500
+++ linux-2.6-lttng/ltt/Kconfig	2008-12-15 16:18:08.000000000 -0500
@@ -125,6 +125,15 @@ config LTT_DEBUG_EVENT_SIZE
 	help
 	  Tracer-internal option to help debugging event type encoding problems.
 
+config LTT_USERSPACE_EVENT
+	tristate "Support logging events from userspace"
+	depends on LTT_TRACER
+	depends on LTT_TRACEPROBES
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
--- linux-2.6-lttng.orig/ltt/Makefile	2008-12-15 16:18:04.000000000 -0500
+++ linux-2.6-lttng/ltt/Makefile	2008-12-15 16:18:08.000000000 -0500
@@ -5,6 +5,7 @@
 obj-$(CONFIG_MARKERS)			+= ltt-channels.o
 obj-$(CONFIG_LTT)			+= ltt-core.o
 obj-$(CONFIG_LTT_TRACER)		+= ltt-tracer.o
+obj-$(CONFIG_LTT_USERSPACE_EVENT)	+= ltt-userspace-event.o
 obj-$(CONFIG_LTT_RELAY)			+= ltt-relay.o
 obj-$(CONFIG_LTT_RELAY_LOCKED)		+= ltt-relay-locked.o
 obj-$(CONFIG_LTT_RELAY_ALLOC)		+= ltt-relay-alloc.o
Index: linux-2.6-lttng/ltt/ltt-userspace-event.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/ltt/ltt-userspace-event.c	2008-12-15 17:19:33.000000000 -0500
@@ -0,0 +1,120 @@
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
+
+#include "probes/ltt-type-serializer.h"
+
+#define LTT_WRITE_EVENT_FILE	"write_event"
+
+DEFINE_MARKER(userspace, event, "string %s");
+static struct dentry *ltt_event_file;
+
+/**
+ * write_event: write a userspace string into the trace stream
+ * @file: file pointer
+ * @user_buf: user string
+ * @count: length to copy, including the final NULL
+ * @ppos: unused
+ *
+ * Copy at most a 4095-bytes string into a trace event, in channel "userspace",
+ * event "event". Returns -E2BIG if string is larger than 4095kB. Last byte is
+ * kept for NULL character.
+ * On success, returns the number of bytes copied (without NULL character).
+ */
+static ssize_t write_event(struct file *file, const char __user *user_buf,
+		size_t count, loff_t *ppos)
+{
+	struct marker *marker;
+	char *page;
+	int ret;
+
+	if (count > PAGE_SIZE - 1) {
+		ret = -E2BIG;
+		goto string_out;
+	}
+	page = (char *)__get_free_page(GFP_TEMPORARY);
+	if (!page) {
+		ret = -ENOMEM;
+		goto string_out;
+	}
+	ret = copy_from_user(page, user_buf, count);
+	if (ret) {
+		ret = -EFAULT;
+		goto string_err;
+	}
+	page[count] = '\0';
+
+	marker = &GET_MARKER(userspace, event);
+	ltt_specialized_trace(marker, marker->single.probe_private,
+		page, count + 1, sizeof(char));
+	ret = count;
+string_err:
+	free_page((unsigned long)page);
+string_out:
+	return ret;
+}
+
+static struct file_operations ltt_userspace_operations = {
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
+err_no_file:
+err_no_root:
+	return err;
+}
+
+static void __exit ltt_userspace_exit(void)
+{
+	debugfs_remove(ltt_event_file);
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
