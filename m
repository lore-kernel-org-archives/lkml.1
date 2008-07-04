Return-Path: <linux-kernel-owner+w=401wt.eu-S1756511AbYGDX5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511AbYGDX5N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 19:57:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112AbYGDXzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 19:55:18 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:42512 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023AbYGDXzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 19:55:12 -0400
Message-Id: <20080704235429.484402197@polymtl.ca>
References: <20080704235207.147809973@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 04 Jul 2008 19:52:19 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alexander Viro <viro@zeniv.linux.org.uk>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [RFC patch 12/12] LTTng instrumentation net tracepoint probes
Content-Disposition: inline; filename=lttng-instrumentation-net-tracepoints-probes.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Fri,  4 Jul 2008 23:54:30 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a module which declares net tracepoint probes, using markers.

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
 net/Makefile    |    3 +
 net/net-trace.c |  105 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 108 insertions(+)

Index: linux-2.6-lttng/net/Makefile
===================================================================
--- linux-2.6-lttng.orig/net/Makefile	2008-07-04 19:16:42.000000000 -0400
+++ linux-2.6-lttng/net/Makefile	2008-07-04 19:16:44.000000000 -0400
@@ -11,6 +11,9 @@ obj-$(CONFIG_NET)		:= socket.o core/
 
 tmp-$(CONFIG_COMPAT) 		:= compat.o
 obj-$(CONFIG_NET)		+= $(tmp-y)
+ifeq ($(CONFIG_NET),y)
+obj-$(CONFIG_TRACEPROBES)	+= net-trace.o
+endif
 
 # LLC has to be linked before the files in net/802/
 obj-$(CONFIG_LLC)		+= llc/
Index: linux-2.6-lttng/net/net-trace.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/net/net-trace.c	2008-07-04 19:19:04.000000000 -0400
@@ -0,0 +1,105 @@
+/*
+ * net/net-trace.c
+ *
+ * Net tracepoint probes.
+ */
+
+#include <linux/module.h>
+#include "net-trace.h"
+
+static void probe_net_dev_xmit(struct sk_buff *skb)
+{
+	trace_mark(net_dev_xmit, "skb %p protocol #2u%hu", skb, skb->protocol);
+}
+
+static void probe_net_dev_receive(struct sk_buff *skb)
+{
+	trace_mark(net_dev_receive, "skb %p protocol #2u%hu",
+		skb, skb->protocol);
+}
+
+static void probe_net_del_ifa_ipv4(struct in_ifaddr *ifa)
+{
+	trace_mark(net_del_ifa_ipv4, "label %s", ifa->ifa_label);
+}
+
+static void probe_net_insert_ifa_ipv4(struct in_ifaddr *ifa)
+{
+	trace_mark(net_insert_ifa_ipv4, "label %s address #4u%lu",
+		ifa->ifa_label, (unsigned long)ifa->ifa_address);
+}
+
+static void probe_net_socket_sendmsg(struct socket *sock, struct msghdr *msg,
+		size_t size, int ret)
+{
+	trace_mark(net_socket_sendmsg,
+		"sock %p family %d type %d protocol %d size %zu",
+		sock, sock->sk->sk_family, sock->sk->sk_type,
+		sock->sk->sk_protocol, size);
+}
+
+static void probe_net_socket_recvmsg(struct socket *sock, struct msghdr *msg,
+		size_t size, int flags, int ret)
+{
+	trace_mark(net_socket_recvmsg,
+		"sock %p family %d type %d protocol %d size %zu",
+		sock, sock->sk->sk_family, sock->sk->sk_type,
+		sock->sk->sk_protocol, size);
+}
+
+static void probe_net_socket_create(struct socket *sock, int fd)
+{
+	trace_mark(net_socket_create,
+		"sock %p family %d type %d protocol %d fd %d",
+		sock, sock->sk->sk_family, sock->sk->sk_type,
+		sock->sk->sk_protocol, fd);
+}
+
+static void probe_net_socket_call(int call, unsigned long a0)
+{
+	trace_mark(net_socket_call, "call %d a0 %lu", call, a0);
+}
+
+int __init net_trace_init(void)
+{
+	int ret;
+
+	ret = register_trace_net_dev_xmit(probe_net_dev_xmit);
+	WARN_ON(ret);
+	ret = register_trace_net_dev_receive(probe_net_dev_receive);
+	WARN_ON(ret);
+	ret = register_trace_net_del_ifa_ipv4(probe_net_del_ifa_ipv4);
+	WARN_ON(ret);
+	ret = register_trace_net_insert_ifa_ipv4(probe_net_insert_ifa_ipv4);
+	WARN_ON(ret);
+	ret = register_trace_net_socket_sendmsg(probe_net_socket_sendmsg);
+	WARN_ON(ret);
+	ret = register_trace_net_socket_recvmsg(probe_net_socket_recvmsg);
+	WARN_ON(ret);
+	ret = register_trace_net_socket_create(probe_net_socket_create);
+	WARN_ON(ret);
+	ret = register_trace_net_socket_call(probe_net_socket_call);
+	WARN_ON(ret);
+
+	return 0;
+}
+
+module_init(net_trace_init);
+
+void __exit net_trace_exit(void)
+{
+	unregister_trace_net_socket_call(probe_net_socket_call);
+	unregister_trace_net_socket_create(probe_net_socket_create);
+	unregister_trace_net_socket_recvmsg(probe_net_socket_recvmsg);
+	unregister_trace_net_socket_sendmsg(probe_net_socket_sendmsg);
+	unregister_trace_net_insert_ifa_ipv4(probe_net_insert_ifa_ipv4);
+	unregister_trace_net_del_ifa_ipv4(probe_net_del_ifa_ipv4);
+	unregister_trace_net_dev_receive(probe_net_dev_receive);
+	unregister_trace_net_dev_xmit(probe_net_dev_xmit);
+}
+
+module_exit(net_trace_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mathieu Desnoyers");
+MODULE_DESCRIPTION("Net Tracepoint Probes");

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
