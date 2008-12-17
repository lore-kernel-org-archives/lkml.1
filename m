Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752831AbYLQRck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbYLQRck (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 12:32:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344AbYLQRca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 12:32:30 -0500
Received: from bc.sympatico.ca ([209.226.175.184]:38938 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750996AbYLQRc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 12:32:29 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvgEAIPASElMROB9/2dsb2JhbACBbLxyWJEugwY
Date: Wed, 17 Dec 2008 12:32:24 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ltt-dev@lists.casi.polymtl.ca, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [ltt-dev] [PATCH] Simple LTTng userspace events through debugfs
Message-ID: <20081217173223.GA32699@Krystal>
References: <20081215231040.GA5936@Krystal> <20081216194201.GE843@elte.hu> <20081217041628.GA5409@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081217041628.GA5409@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:30:35 up 30 days, 18:11,  2 users,  load average: 0.42, 0.98,
	1.23
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (compudj@krystal.dyndns.org) wrote:
> * Ingo Molnar (mingo@elte.hu) wrote:
> > 
> > * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > 
> > > Hi,
> > > 
> > > I looked at kmemtrace and noticed that the presence of a debugfs 
> > > "marker" file, which lets userspace write events into the trace buffers.
> > > 
> > > So I just did the same with a
> > > 
> > > /debugfs/ltt/write_event
> > 
> > you mean similar to ftrace's /debug/tracing/trace_marker ? ;-)
> > 
> 
> Quite similar, yes :)
> 
> Looking at tracing_mark_write(), I am wondering if the fact that it
> returns a count including the added \n is an expected side effect ? A
> write() returning a count larger than the number of bytes written seems
> to be a bit unexpected... But if we remove the \n from the count, then
> the case where one write \0 into the event content would end up doing an
> endless loop.
> 

I fixed this in the following implementation for LTTng. Made an hybrid
of both approaches, using \n and \0 as string delimiter, and fixed the
problem with returned count larger than the requested count.


LTTng userspace event v2

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
 ltt/ltt-userspace-event.c |  129 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 139 insertions(+)

Index: linux-2.6-lttng/ltt/Kconfig
===================================================================
--- linux-2.6-lttng.orig/ltt/Kconfig	2008-12-16 12:21:13.000000000 -0500
+++ linux-2.6-lttng/ltt/Kconfig	2008-12-16 12:21:14.000000000 -0500
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
--- linux-2.6-lttng.orig/ltt/Makefile	2008-12-16 12:21:14.000000000 -0500
+++ linux-2.6-lttng/ltt/Makefile	2008-12-16 12:21:14.000000000 -0500
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
+++ linux-2.6-lttng/ltt/ltt-userspace-event.c	2008-12-17 12:03:43.000000000 -0500
@@ -0,0 +1,129 @@
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
+	printk("copy count %ld\n", copycount);
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
