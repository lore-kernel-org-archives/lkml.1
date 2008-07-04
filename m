Return-Path: <linux-kernel-owner+w=401wt.eu-S1755701AbYGDX5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701AbYGDX5z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 19:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755283AbYGDXzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 19:55:42 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:42558 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755221AbYGDXzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 19:55:41 -0400
Message-Id: <20080704235427.864110351@polymtl.ca>
References: <20080704235207.147809973@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 04 Jul 2008 19:52:16 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alexander Viro <viro@zeniv.linux.org.uk>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [RFC patch 09/12] LTTng instrumentation ipc tracepoint probes
Content-Disposition: inline; filename=lttng-instrumentation-ipc-tracepoints-probes.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Fri,  4 Jul 2008 23:54:28 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a module which declares ipc tracepoint probes, using markers.

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
 ipc/Makefile    |    2 +-
 ipc/ipc-trace.c |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/ipc/Makefile
===================================================================
--- linux-2.6-lttng.orig/ipc/Makefile	2008-07-04 10:04:27.000000000 -0400
+++ linux-2.6-lttng/ipc/Makefile	2008-07-04 10:04:32.000000000 -0400
@@ -8,4 +8,4 @@ obj-$(CONFIG_SYSVIPC_SYSCTL) += ipc_sysc
 obj_mq-$(CONFIG_COMPAT) += compat_mq.o
 obj-$(CONFIG_POSIX_MQUEUE) += mqueue.o msgutil.o $(obj_mq-y)
 obj-$(CONFIG_IPC_NS) += namespace.o
-
+obj-$(CONFIG_TRACEPROBES) += ipc-trace.o
Index: linux-2.6-lttng/ipc/ipc-trace.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/ipc/ipc-trace.c	2008-07-04 10:15:10.000000000 -0400
@@ -0,0 +1,52 @@
+/*
+ * ipc/ipc-trace.c
+ *
+ * IPC tracepoint probes.
+ */
+
+#include <linux/module.h>
+#include "ipc-trace.h"
+
+static void probe_ipc_msg_create(long id, int flags)
+{
+	trace_mark(ipc_msg_create, "id %ld flags %d", id, flags);
+}
+
+static void probe_ipc_sem_create(long id, int flags)
+{
+	trace_mark(ipc_sem_create, "id %ld flags %d", id, flags);
+}
+
+static void probe_ipc_shm_create(long id, int flags)
+{
+	trace_mark(ipc_shm_create, "id %ld flags %d", id, flags);
+}
+
+int __init ipc_trace_init(void)
+{
+	int ret;
+
+	ret = register_trace_ipc_msg_create(probe_ipc_msg_create);
+	WARN_ON(ret);
+	ret = register_trace_ipc_sem_create(probe_ipc_sem_create);
+	WARN_ON(ret);
+	ret = register_trace_ipc_shm_create(probe_ipc_shm_create);
+	WARN_ON(ret);
+
+	return 0;
+}
+
+module_init(ipc_trace_init);
+
+void __exit ipc_trace_exit(void)
+{
+	unregister_trace_ipc_shm_create(probe_ipc_shm_create);
+	unregister_trace_ipc_sem_create(probe_ipc_sem_create);
+	unregister_trace_ipc_msg_create(probe_ipc_msg_create);
+}
+
+module_exit(ipc_trace_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mathieu Desnoyers");
+MODULE_DESCRIPTION("IPC Tracepoint Probes");

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
