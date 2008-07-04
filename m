Return-Path: <linux-kernel-owner+w=401wt.eu-S1757273AbYGDX6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273AbYGDX6i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 19:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755406AbYGDXzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 19:55:46 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:42565 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755361AbYGDXzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 19:55:43 -0400
Message-Id: <20080704235427.330418022@polymtl.ca>
References: <20080704235207.147809973@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 04 Jul 2008 19:52:15 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alexander Viro <viro@zeniv.linux.org.uk>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [RFC patch 08/12] LTTng instrumentation FS tracepoint probes
Content-Disposition: inline; filename=lttng-instrumentation-fs-tracepoints-probes.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Fri,  4 Jul 2008 23:54:27 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a module which declares FS tracepoint probes, using markers.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Alexander Viro <viro@zeniv.linux.org.uk>
CC: 'Peter Zijlstra' <peterz@infradead.org>
CC: "Frank Ch. Eigler" <fche@redhat.com>
CC: 'Ingo Molnar' <mingo@elte.hu>
CC: 'Hideo AOKI' <haoki@redhat.com>
CC: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
CC: 'Steven Rostedt' <rostedt@goodmis.org>
CC: Masami Hiramatsu <mhiramat@redhat.com>
---
 fs/Makefile   |    1 
 fs/fs-trace.c |  167 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 168 insertions(+)

Index: linux-2.6-lttng/fs/fs-trace.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/fs/fs-trace.c	2008-07-04 19:30:42.000000000 -0400
@@ -0,0 +1,167 @@
+/*
+ * fs/fs-trace.c
+ *
+ * FS tracepoint probes.
+ */
+
+#include <linux/module.h>
+#include <linux/buffer_head.h>
+#include "fs-trace.h"
+
+static void probe_fs_buffer_wait_start(struct buffer_head *bh)
+{
+	trace_mark(fs_buffer_wait_start, "bh %p", bh);
+}
+
+static void probe_fs_buffer_wait_end(struct buffer_head *bh)
+{
+	trace_mark(fs_buffer_wait_end, "bh %p", bh);
+}
+
+static void probe_fs_exec(char *filename)
+{
+	trace_mark(fs_exec, "filename %s", filename);
+}
+
+static void probe_fs_ioctl(unsigned int fd, unsigned int cmd, unsigned long arg)
+{
+	trace_mark(fs_ioctl, "fd %u cmd %u arg %lu", fd, cmd, arg);
+}
+
+static void probe_fs_open(int fd, char *filename)
+{
+	trace_mark(fs_open, "fd %d filename %s", fd, filename);
+}
+
+static void probe_fs_close(unsigned int fd)
+{
+	trace_mark(fs_close, "fd %u", fd);
+}
+
+static void probe_fs_lseek(unsigned int fd, long offset, unsigned int origin)
+{
+	trace_mark(fs_lseek, "fd %u offset %ld origin %u", fd, offset, origin);
+}
+
+static void probe_fs_llseek(unsigned int fd, loff_t offset, unsigned int origin)
+{
+	trace_mark(fs_llseek, "fd %u offset %lld origin %u", fd,
+			(long long)offset, origin);
+}
+
+static void probe_fs_read(unsigned int fd, char __user *buf, size_t count,
+		ssize_t ret)
+{
+	trace_mark(fs_read, "fd %u count %zu", fd, count);
+}
+
+static void probe_fs_write(unsigned int fd, const char __user *buf,
+		size_t count, ssize_t ret)
+{
+	trace_mark(fs_write, "fd %u count %zu", fd, count);
+}
+
+static void probe_fs_pread64(unsigned int fd, char __user *buf, size_t count,
+		loff_t pos, ssize_t ret)
+{
+	trace_mark(fs_pread64, "fd %u count %zu pos %llu",
+			fd, count, (unsigned long long)pos);
+}
+
+static void probe_fs_pwrite64(unsigned int fd, const char __user *buf,
+		size_t count, loff_t pos, ssize_t ret)
+{
+	trace_mark(fs_pwrite64, "fd %u count %zu pos %llu",
+			fd, count, (unsigned long long)pos);
+}
+
+static void probe_fs_readv(unsigned long fd, const struct iovec __user *vec,
+		unsigned long vlen, ssize_t ret)
+{
+	trace_mark(fs_readv, "fd %lu vlen %lu", fd, vlen);
+}
+
+static void probe_fs_writev(unsigned long fd, const struct iovec __user *vec,
+		unsigned long vlen, ssize_t ret)
+{
+	trace_mark(fs_writev, "fd %lu vlen %lu", fd, vlen);
+}
+
+static void probe_fs_select(int fd, s64 timeout)
+{
+	trace_mark(fs_select, "fd %d timeout #8d%lld", fd, (long long)timeout);
+}
+
+static void probe_fs_poll(int fd)
+{
+	trace_mark(fs_pollfd, "fd %d", fd);
+}
+
+
+int __init fs_trace_init(void)
+{
+	int ret;
+
+	ret = register_trace_fs_buffer_wait_start(probe_fs_buffer_wait_start);
+	WARN_ON(ret);
+	ret = register_trace_fs_buffer_wait_end(probe_fs_buffer_wait_end);
+	WARN_ON(ret);
+	ret = register_trace_fs_exec(probe_fs_exec);
+	WARN_ON(ret);
+	ret = register_trace_fs_ioctl(probe_fs_ioctl);
+	WARN_ON(ret);
+	ret = register_trace_fs_open(probe_fs_open);
+	WARN_ON(ret);
+	ret = register_trace_fs_close(probe_fs_close);
+	WARN_ON(ret);
+	ret = register_trace_fs_lseek(probe_fs_lseek);
+	WARN_ON(ret);
+	ret = register_trace_fs_llseek(probe_fs_llseek);
+	WARN_ON(ret);
+	ret = register_trace_fs_read(probe_fs_read);
+	WARN_ON(ret);
+	ret = register_trace_fs_write(probe_fs_write);
+	WARN_ON(ret);
+	ret = register_trace_fs_pread64(probe_fs_pread64);
+	WARN_ON(ret);
+	ret = register_trace_fs_pwrite64(probe_fs_pwrite64);
+	WARN_ON(ret);
+	ret = register_trace_fs_readv(probe_fs_readv);
+	WARN_ON(ret);
+	ret = register_trace_fs_writev(probe_fs_writev);
+	WARN_ON(ret);
+	ret = register_trace_fs_select(probe_fs_select);
+	WARN_ON(ret);
+	ret = register_trace_fs_poll(probe_fs_poll);
+	WARN_ON(ret);
+
+	return 0;
+}
+
+module_init(fs_trace_init);
+
+void __exit fs_trace_exit(void)
+{
+	unregister_trace_fs_poll(probe_fs_poll);
+	unregister_trace_fs_select(probe_fs_select);
+	unregister_trace_fs_writev(probe_fs_writev);
+	unregister_trace_fs_readv(probe_fs_readv);
+	unregister_trace_fs_pwrite64(probe_fs_pwrite64);
+	unregister_trace_fs_pread64(probe_fs_pread64);
+	unregister_trace_fs_write(probe_fs_write);
+	unregister_trace_fs_read(probe_fs_read);
+	unregister_trace_fs_llseek(probe_fs_llseek);
+	unregister_trace_fs_lseek(probe_fs_lseek);
+	unregister_trace_fs_close(probe_fs_close);
+	unregister_trace_fs_open(probe_fs_open);
+	unregister_trace_fs_ioctl(probe_fs_ioctl);
+	unregister_trace_fs_exec(probe_fs_exec);
+	unregister_trace_fs_buffer_wait_end(probe_fs_buffer_wait_end);
+	unregister_trace_fs_buffer_wait_start(probe_fs_buffer_wait_start);
+}
+
+module_exit(fs_trace_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mathieu Desnoyers");
+MODULE_DESCRIPTION("FS Tracepoint Probes");
Index: linux-2.6-lttng/fs/Makefile
===================================================================
--- linux-2.6-lttng.orig/fs/Makefile	2008-07-04 19:21:32.000000000 -0400
+++ linux-2.6-lttng/fs/Makefile	2008-07-04 19:26:08.000000000 -0400
@@ -63,6 +63,7 @@ obj-$(CONFIG_CONFIGFS_FS)	+= configfs/
 obj-y				+= devpts/
 
 obj-$(CONFIG_PROFILING)		+= dcookies.o
+obj-$(CONFIG_TRACEPROBES)	+= fs-trace.o
 obj-$(CONFIG_DLM)		+= dlm/
  
 # Do not add any filesystems before this line

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
