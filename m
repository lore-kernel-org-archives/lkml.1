Return-Path: <linux-kernel-owner+w=401wt.eu-S1756873AbZAIFdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873AbZAIFdw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 00:33:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755878AbZAIFde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 00:33:34 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56021 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881AbZAIFdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 00:33:33 -0500
Date: Fri, 9 Jan 2009 14:32:26 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "menage@google.com" <menage@google.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [RFC][PATCH] NOOP cgroup subsystem
Message-Id: <20090109143226.b79d21b4.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How about this idea ? Any comments are welcome.

-Kame

==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Add an NO OPERATION cgroup subsystem.

Cgroup itself is providing a feature to attach a task(PID) to some class.
This feature itself is very useful but "no operation" cgroup is not supported
now other than debug cgroup. (But debug cgroup should be for DEBUG. distro
may not configure it.)

Motivation: Simply classify Applications by cgroup
  When using cgroup for classifying applications, some kind of "control" or
  "account" subsys must be used. For flexible use of cgroup's nature of
  classifying applications, NOOP is useful. It can be used regardless of
  resource accounting unit or name spaces or some controls.
  IOW, NOOP cgroup allows users to tie PIDs with some nickname.

After this, application can be checked whether it's still alive or not by

	mount -t cgroup none /var/apps noop
	mkdir /var/apps/mydaemon
	echo 0 > /var/apps/mydaemon
	/etc/init.d/mydaemon start
	exit

This can be used as the same technique of "recording pid into /var/run/xxx.pid"
and not necessary to remove stale files. If mydaemon dies, tasks file will
be empty and notify_on_release handler can be used.

I myself want to use this for replacement of "ps -elf | grep" if libcgroup supports
ps under cgroup.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/cgroup_subsys.h |    4 ++++
 init/Kconfig                  |    9 +++++++++
 kernel/Makefile               |    1 +
 kernel/cgroup_noop.c          |   34 ++++++++++++++++++++++++++++++++++
 4 files changed, 48 insertions(+)

Index: mmotm-2.6.28-Jan8/include/linux/cgroup_subsys.h
===================================================================
--- mmotm-2.6.28-Jan8.orig/include/linux/cgroup_subsys.h
+++ mmotm-2.6.28-Jan8/include/linux/cgroup_subsys.h
@@ -59,4 +59,8 @@ SUBSYS(freezer)
 SUBSYS(net_cls)
 #endif
 
+#ifdef CONFIG_CGROUP_NOOP
+SUBSYS(noop)
+#endif
+
 /* */
Index: mmotm-2.6.28-Jan8/kernel/Makefile
===================================================================
--- mmotm-2.6.28-Jan8.orig/kernel/Makefile
+++ mmotm-2.6.28-Jan8/kernel/Makefile
@@ -61,6 +61,7 @@ obj-$(CONFIG_CGROUP_DEBUG) += cgroup_deb
 obj-$(CONFIG_CGROUP_FREEZER) += cgroup_freezer.o
 obj-$(CONFIG_CPUSETS) += cpuset.o
 obj-$(CONFIG_CGROUP_NS) += ns_cgroup.o
+obj-$(CONFIG_CGROUP_NOOP) += cgroup_noop.o
 obj-$(CONFIG_UTS_NS) += utsname.o
 obj-$(CONFIG_USER_NS) += user_namespace.o
 obj-$(CONFIG_PID_NS) += pid_namespace.o
Index: mmotm-2.6.28-Jan8/kernel/cgroup_noop.c
===================================================================
--- /dev/null
+++ mmotm-2.6.28-Jan8/kernel/cgroup_noop.c
@@ -0,0 +1,34 @@
+/*
+ * kernel/cgroup_noop.c - No Operation Cgroup. Just for organizing process tree
+ */
+
+#include <linux/cgroup.h>
+#include <linux/fs.h>
+#include <linux/slab.h>
+#include <linux/rcupdate.h>
+
+#include <asm/atomic.h>
+
+static struct cgroup_subsys_state *noop_create(struct cgroup_subsys *ss,
+						   struct cgroup *cont)
+{
+	struct cgroup_subsys_state *css = kzalloc(sizeof(*css), GFP_KERNEL);
+
+	if (!css)
+		return ERR_PTR(-ENOMEM);
+
+	return css;
+}
+
+static void noop_destroy(struct cgroup_subsys *ss, struct cgroup *cont)
+{
+	kfree(cont->subsys[noop_subsys_id]);
+}
+
+
+struct cgroup_subsys noop_subsys = {
+	.name = "noop",
+	.subsys_id = noop_subsys_id,
+	.create = noop_create,
+	.destroy = noop_destroy,
+};
Index: mmotm-2.6.28-Jan8/init/Kconfig
===================================================================
--- mmotm-2.6.28-Jan8.orig/init/Kconfig
+++ mmotm-2.6.28-Jan8/init/Kconfig
@@ -354,6 +354,15 @@ config CGROUP_DEBUG
 
 	  Say N if unsure
 
+config CGROUP_NOOP
+	bool "No Operation cgroup subsystem"
+	depends on CGROUPS
+	help
+	  This provides cgroup subsystem which has no special features. By
+	  this, you can classify applications freely. That is, you can
+	  classify applications regardless of accounting or control contexts
+	  of the system.
+
 config CGROUP_NS
         bool "Namespace cgroup subsystem"
         depends on CGROUPS

