Return-Path: <linux-kernel-owner+w=401wt.eu-S1752594AbYAWJKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594AbYAWJKQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 04:10:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbYAWJJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 04:09:57 -0500
Received: from as1.cineca.com ([130.186.84.213]:60586 "EHLO as1.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198AbYAWJJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 04:09:54 -0500
Message-ID: <47970448.7010609@users.sourceforge.net>
From: Andrea Righi <righiandr@users.sourceforge.net>
Reply-To: righiandr@users.sourceforge.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.12) Gecko/20070604 Thunderbird/1.5.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Balbir Singh <balbir@linux.vnet.ibm.com>, Naveen Gupta <ngupta@google.com>,
       Paul Menage <menage@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>
Subject: [RFC] [PATCH] cgroup: limit network bandwidth
X-Enigmail-Version: 0.95.0
OpenPGP: id=77CEF397;
	url=keyserver.veridis.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Date: Wed, 23 Jan 2008 10:09:28 +0100 (MET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow to limit the network bandwidth for specific process containers (cgroups)
imposing additional delays in the sockets' sendmsg()/recvmsg() calls made by
those processes that exceed the limits defined in the control group filesystem.

Example:
  # mkdir /dev/cgroup
  # mount -t cgroup -onet net /dev/cgroup
  # cd /dev/cgroup
  # mkdir foo
  --> the cgroup foo has been created
  # /bin/echo $$ > foo/tasks
  # /bin/echo 1024 > foo/net.tcp
  # /bin/echo 2048 > foo/net.tot
  # sh
  --> the subshell 'sh' is running in cgroup "foo" that has a maximum network
      bandwidth for TCP traffic of 1MB/s and 2MB/s for total network
      activities.

The netlimit approach can be easily extended to support additional network
protocols or different socket families or types (PF_UNIX, PF_BLUETOOTH,
SOCK_SEQPACKET, etc.).

Signed-off-by: Andrea Righi <a.righi@cineca.it>
---

diff -urpN linux-2.6.24-rc8/include/linux/cgroup_netlimit.h linux-2.6.24-rc8-cgroup-netlimit/include/linux/cgroup_netlimit.h
--- linux-2.6.24-rc8/include/linux/cgroup_netlimit.h	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.24-rc8-cgroup-netlimit/include/linux/cgroup_netlimit.h	2008-01-22 21:36:15.000000000 +0100
@@ -0,0 +1,29 @@
+#ifndef CGROUP_NETLIMIT_H
+#define CGROUP_NETLIMIT_H
+
+enum {
+	CGROUP_NETLIMIT_TOT,
+	CGROUP_NETLIMIT_TCP,
+	CGROUP_NETLIMIT_UDP,
+	CGROUP_NETLIMIT_RAW,
+	/* This sets the size of the different netlimit types */
+	CGROUP_NETLIMIT_END,
+};
+
+#define CGROUP_NETLIMIT_FILE(_x, _y) \
+	{ \
+		.name = _x, \
+		.read = netlimit_read, \
+		.write_uint = netlimit_write_uint, \
+		.private = _y, \
+	}
+
+#ifdef CONFIG_CGROUP_NETLIMIT
+extern void cgroup_nl_acct(int limit_id, size_t bytes);
+extern void cgroup_nl_throttle(int limit_id, int interruptible);
+#else
+static inline void cgroup_nl_acct(int limit_id, size_t bytes) { }
+static inline void cgroup_nl_throttle(int limit_id, int interruptible) { }
+#endif /* CONFIG_CGROUP_NETLIMIT */
+
+#endif
diff -urpN linux-2.6.24-rc8/include/linux/cgroup_subsys.h linux-2.6.24-rc8-cgroup-netlimit/include/linux/cgroup_subsys.h
--- linux-2.6.24-rc8/include/linux/cgroup_subsys.h	2008-01-16 05:22:48.000000000 +0100
+++ linux-2.6.24-rc8-cgroup-netlimit/include/linux/cgroup_subsys.h	2008-01-22 14:42:17.000000000 +0100
@@ -37,3 +37,9 @@ SUBSYS(cpuacct)
 
 /* */
 
+#ifdef CONFIG_CGROUP_NETLIMIT
+SUBSYS(netlimit)
+#endif
+
+/* */
+
diff -urpN linux-2.6.24-rc8/init/Kconfig linux-2.6.24-rc8-cgroup-netlimit/init/Kconfig
--- linux-2.6.24-rc8/init/Kconfig	2008-01-16 05:22:48.000000000 +0100
+++ linux-2.6.24-rc8-cgroup-netlimit/init/Kconfig	2008-01-23 00:44:04.000000000 +0100
@@ -313,6 +313,15 @@ config CGROUP_NS
           for instance virtual servers and checkpoint/restart
           jobs.
 
+config CGROUP_NETLIMIT
+        bool "Enable cgroup network bandwidth limitinig (EXPERIMENTAL)"
+        depends on EXPERIMENTAL && CGROUPS
+        help
+	  This allows to define network bandwidth limiting/shaping rules for
+	  specific cgroup(s).
+
+	  Say N if unsure.
+
 config CPUSETS
 	bool "Cpuset support"
 	depends on SMP && CGROUPS
diff -urpN linux-2.6.24-rc8/kernel/cgroup_netlimit.c linux-2.6.24-rc8-cgroup-netlimit/kernel/cgroup_netlimit.c
--- linux-2.6.24-rc8/kernel/cgroup_netlimit.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.24-rc8-cgroup-netlimit/kernel/cgroup_netlimit.c	2008-01-22 21:35:53.000000000 +0100
@@ -0,0 +1,229 @@
+/*
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License as published by the Free Software Foundation; either
+ * version 2 of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ *
+ * Copyright (C) 2008 Andrea Righi <a.righi@cineca.it>
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/cgroup.h>
+#include <linux/slab.h>
+#include <linux/gfp.h>
+#include <linux/err.h>
+#include <linux/sched.h>
+#include <linux/fs.h>
+#include <linux/jiffies.h>
+#include <linux/spinlock.h>
+#include <linux/cgroup_netlimit.h>
+
+struct netlimit {
+	struct cgroup_subsys_state css;
+	spinlock_t lock[CGROUP_NETLIMIT_END];
+	unsigned long bandwidth[CGROUP_NETLIMIT_END];
+	unsigned long req[CGROUP_NETLIMIT_END];
+	unsigned long last_request[CGROUP_NETLIMIT_END];
+};
+
+static inline struct netlimit *cgroup_to_netlimit(struct cgroup *cont)
+{
+	return container_of(cgroup_subsys_state(cont, netlimit_subsys_id),
+			    struct netlimit, css);
+}
+
+static inline struct netlimit *task_to_netlimit(struct task_struct *task)
+{
+	return container_of(task_subsys_state(task, netlimit_subsys_id),
+			    struct netlimit, css);
+}
+
+/*
+ * Rules: you can only create a cgroup if:
+ *   1. you are capable(CAP_SYS_ADMIN)
+ *   2. the target cgroup is a descendant of your own cgroup
+ *
+ * Note: called from kernel/cgroup.c with cgroup_lock() held.
+ */
+static struct cgroup_subsys_state *netlimit_create(
+			struct cgroup_subsys *ss, struct cgroup *cont)
+{
+	struct netlimit *nl;
+	int i;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return ERR_PTR(-EPERM);
+
+	if (!cgroup_is_descendant(cont))
+		return ERR_PTR(-EPERM);
+
+	nl = kzalloc(sizeof(struct netlimit), GFP_KERNEL);
+	if (unlikely(!nl))
+		return ERR_PTR(-ENOMEM);
+
+	for (i = 0; i < CGROUP_NETLIMIT_END; i++) {
+		spin_lock_init(&nl->lock[i]);
+		nl->last_request[i] = jiffies;
+	}
+
+	return &nl->css;
+}
+
+/*
+ * Note: called from kernel/cgroup.c with cgroup_lock() held.
+ */
+static void netlimit_destroy(struct cgroup_subsys *ss, struct cgroup *cont)
+{
+	kfree(cgroup_to_netlimit(cont));
+}
+
+static ssize_t netlimit_read(struct cgroup *cont, struct cftype *cft,
+			       struct file *file, char __user *buf,
+			       size_t nbytes, loff_t *ppos)
+{
+	ssize_t count, ret;
+	unsigned long delta, bandwidth, req, last_request;
+	struct netlimit *nl;
+	char *page;
+
+	page = (char *)__get_free_page(GFP_TEMPORARY);
+	if (!page)
+		return -ENOMEM;
+
+	cgroup_lock();
+	if (cgroup_is_removed(cont)) {
+		cgroup_unlock();
+		ret = -ENODEV;
+		goto out;
+	}
+
+	nl = cgroup_to_netlimit(cont);
+	spin_lock_irq(&nl->lock[cft->private]);
+
+	delta = (long)jiffies - (long)nl->last_request[cft->private];
+	bandwidth = nl->bandwidth[cft->private];
+	req = nl->req[cft->private];
+	last_request = nl->last_request[cft->private];
+
+	spin_unlock_irq(&nl->lock[cft->private]);
+	cgroup_unlock();
+
+	/* print additional debugging stuff */
+	count = sprintf(page, "         type: %s\n"
+			      "max-bandwidth: %lu KB/sec\n"
+			      "    requested: %lu KB\n"
+			      " last request: %lu jiffies\n"
+			      "        delta: %lu jiffies\n",
+			      cft->name,
+			      bandwidth, req >> 10, last_request, delta);
+
+	ret = simple_read_from_buffer(buf, nbytes, ppos, page, count);
+
+out:
+	free_page((unsigned long)page);
+	return ret;
+}
+
+static int netlimit_write_uint(struct cgroup *cont, struct cftype *cft,
+				 u64 val)
+{
+	struct netlimit *nl;
+	int ret = 0;
+
+	cgroup_lock();
+	if (cgroup_is_removed(cont)) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	nl = cgroup_to_netlimit(cont);
+
+	spin_lock_irq(&nl->lock[cft->private]);
+	nl->bandwidth[cft->private] = (unsigned long)val;
+	nl->req[cft->private] = 0;
+	nl->last_request[cft->private] = jiffies;
+	spin_unlock_irq(&nl->lock[cft->private]);
+
+out:
+	cgroup_unlock();
+	return ret;
+}
+
+static struct cftype files[] = {
+	CGROUP_NETLIMIT_FILE("tot", CGROUP_NETLIMIT_TOT),
+	CGROUP_NETLIMIT_FILE("tcp", CGROUP_NETLIMIT_TCP),
+	CGROUP_NETLIMIT_FILE("udp", CGROUP_NETLIMIT_UDP),
+	CGROUP_NETLIMIT_FILE("raw", CGROUP_NETLIMIT_RAW),
+};
+
+static int netlimit_populate(struct cgroup_subsys *ss, struct cgroup *cont)
+{
+	return cgroup_add_files(cont, ss, files, ARRAY_SIZE(files));
+}
+
+struct cgroup_subsys netlimit_subsys = {
+	.name = "net",
+	.create = netlimit_create,
+	.destroy = netlimit_destroy,
+	.populate = netlimit_populate,
+	.subsys_id = netlimit_subsys_id,
+};
+
+void cgroup_nl_acct(int limit_id, size_t bytes)
+{
+	struct netlimit *nl;
+
+	nl = task_to_netlimit(current);
+	if (!nl || !nl->bandwidth[limit_id])
+		return;
+
+	nl->req[limit_id] += bytes;
+}
+EXPORT_SYMBOL(cgroup_nl_acct);
+
+void cgroup_nl_throttle(int limit_id, int interruptible)
+{
+	struct netlimit *nl;
+	unsigned long delta, t;
+	long sleep;
+
+	nl = task_to_netlimit(current);
+	if (!nl || !nl->bandwidth[limit_id])
+		return;
+
+	delta = (long)jiffies - (long)nl->last_request[limit_id];
+	if (!delta)
+		return;
+
+	t = msecs_to_jiffies(nl->req[limit_id] / nl->bandwidth[limit_id]);
+	if (!t)
+		return;
+
+	sleep = t - delta;
+	if (sleep > 0) {
+		pr_debug("cgroup-netlimit(%s):"
+			 " task %p (%s) must sleep %lu jiffies\n",
+			 files[limit_id].name,
+			 current, current->comm, sleep);
+		if (interruptible)
+			schedule_timeout_interruptible(sleep);
+		else
+			schedule_timeout_uninterruptible(sleep);
+		return;
+	}
+
+	nl->req[limit_id] = 0;
+	nl->last_request[limit_id] = jiffies;
+}
+EXPORT_SYMBOL(cgroup_nl_throttle);
diff -urpN linux-2.6.24-rc8/kernel/Makefile linux-2.6.24-rc8-cgroup-netlimit/kernel/Makefile
--- linux-2.6.24-rc8/kernel/Makefile	2008-01-16 05:22:48.000000000 +0100
+++ linux-2.6.24-rc8-cgroup-netlimit/kernel/Makefile	2008-01-22 11:39:23.000000000 +0100
@@ -41,6 +41,7 @@ obj-$(CONFIG_CGROUPS) += cgroup.o
 obj-$(CONFIG_CGROUP_DEBUG) += cgroup_debug.o
 obj-$(CONFIG_CPUSETS) += cpuset.o
 obj-$(CONFIG_CGROUP_NS) += ns_cgroup.o
+obj-$(CONFIG_CGROUP_NETLIMIT) += cgroup_netlimit.o
 obj-$(CONFIG_IKCONFIG) += configs.o
 obj-$(CONFIG_STOP_MACHINE) += stop_machine.o
 obj-$(CONFIG_AUDIT) += audit.o auditfilter.o
diff -urpN linux-2.6.24-rc8/net/socket.c linux-2.6.24-rc8-cgroup-netlimit/net/socket.c
--- linux-2.6.24-rc8/net/socket.c	2008-01-16 05:22:48.000000000 +0100
+++ linux-2.6.24-rc8-cgroup-netlimit/net/socket.c	2008-01-22 21:33:46.000000000 +0100
@@ -85,6 +85,7 @@
 #include <linux/audit.h>
 #include <linux/wireless.h>
 #include <linux/nsproxy.h>
+#include <linux/cgroup_netlimit.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -551,10 +552,33 @@ static inline int __sock_sendmsg(struct 
 	si->size = size;
 
 	err = security_socket_sendmsg(sock, msg, size);
-	if (err)
-		return err;
+	if (!err)
+		err = sock->ops->sendmsg(iocb, sock, msg, size);
 
-	return sock->ops->sendmsg(iocb, sock, msg, size);
+	if (err >= 0 && sock->sk) {
+		switch (sock->sk->sk_family) {
+		case PF_INET:
+		case PF_INET6:
+			switch (sock->sk->sk_type) {
+			case SOCK_STREAM:
+				cgroup_nl_acct(CGROUP_NETLIMIT_TCP, size);
+				cgroup_nl_throttle(CGROUP_NETLIMIT_TCP, 1);
+				break;
+			case SOCK_DGRAM:
+				cgroup_nl_acct(CGROUP_NETLIMIT_UDP, size);
+				cgroup_nl_throttle(CGROUP_NETLIMIT_UDP, 1);
+				break;
+			case SOCK_RAW:
+				cgroup_nl_acct(CGROUP_NETLIMIT_RAW, size);
+				cgroup_nl_throttle(CGROUP_NETLIMIT_RAW, 1);
+				break;
+			}
+			cgroup_nl_acct(CGROUP_NETLIMIT_TOT, size);
+			cgroup_nl_throttle(CGROUP_NETLIMIT_TOT, 1);
+		}
+	}
+
+	return err;
 }
 
 int sock_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
@@ -633,10 +657,33 @@ static inline int __sock_recvmsg(struct 
 	si->flags = flags;
 
 	err = security_socket_recvmsg(sock, msg, size, flags);
-	if (err)
-		return err;
+	if (!err)
+		err = sock->ops->recvmsg(iocb, sock, msg, size, flags);
 
-	return sock->ops->recvmsg(iocb, sock, msg, size, flags);
+	if (err >= 0 && sock->sk) {
+		switch (sock->sk->sk_family) {
+		case PF_INET:
+		case PF_INET6:
+			switch (sock->sk->sk_type) {
+			case SOCK_STREAM:
+				cgroup_nl_acct(CGROUP_NETLIMIT_TCP, size);
+				cgroup_nl_throttle(CGROUP_NETLIMIT_TCP, 1);
+				break;
+			case SOCK_DGRAM:
+				cgroup_nl_acct(CGROUP_NETLIMIT_UDP, size);
+				cgroup_nl_throttle(CGROUP_NETLIMIT_UDP, 1);
+				break;
+			case SOCK_RAW:
+				cgroup_nl_acct(CGROUP_NETLIMIT_RAW, size);
+				cgroup_nl_throttle(CGROUP_NETLIMIT_RAW, 1);
+				break;
+			}
+			cgroup_nl_acct(CGROUP_NETLIMIT_TOT, size);
+			cgroup_nl_throttle(CGROUP_NETLIMIT_TOT, 1);
+		}
+	}
+
+	return err;
 }
 
 int sock_recvmsg(struct socket *sock, struct msghdr *msg,
