Return-Path: <linux-kernel-owner+w=401wt.eu-S1752756AbYGWMeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbYGWMeM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 08:34:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbYGWMdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 08:33:49 -0400
Received: from ns.miraclelinux.com ([219.118.163.66]:56388 "EHLO
	mail.miraclelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbYGWMdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 08:33:47 -0400
Message-ID: <488722E4.7010203@miraclelinux.com>
Date: Wed, 23 Jul 2008 21:24:04 +0900
From: Hirofumi Nakagawa <hnakagawa@miraclelinux.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: menage@google.com
Subject: [RFC][PATCH][1/3] rlimit cgroup
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.3.1.294258, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2008.7.23.121701
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Hirofumi Nakagawa <hnakagawa@miraclelinux.com>
---
 include/linux/cgroup_subsys.h |    4
 init/Kconfig                  |    9 ++
 kernel/Makefile               |    1
 kernel/cgroup_rlimit.c        |  179 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 193 insertions(+)

--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.26-rc8-mm1/kernel/cgroup_rlimit.c	2008-07-23 18:52:34.000000000 +0900
@@ -0,0 +1,179 @@
+/*
+ *	Copyright (C) 2008 MIRACLE LINUX Corp.
+ *
+ *	Written by Hirofumi Nakagawa <hnakagawa@miraclelinux.com>
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License as
+ *	published by the Free Software Foundation, version 2.
+ */
+#include <linux/cgroup.h>
+#include <linux/err.h>
+#include <linux/mutex.h>
+#include <linux/resource.h>
+#include <linux/seq_file.h>
+#include <linux/slab.h>
+
+struct cgroup_subsys rlimit_cgroup_subsys __read_mostly;
+
+struct rlimit_cgroup {
+	struct cgroup_subsys_state css;
+
+	struct rlimit rlim[RLIM_NLIMITS];
+
+	struct mutex lock;
+};
+
+static struct rlimit_cgroup *rlimit_cgroup_from_cgrp(struct cgroup *cgrp)
+{
+	return container_of(cgroup_subsys_state(cgrp, rlimit_cgroup_subsys_id),
+			struct rlimit_cgroup, css);
+}
+
+static int parse_rlimit_input(struct rlimit *limit, const char *buf)
+{
+	int c, n;
+
+	c = sscanf(buf, "%d %ld %ld", &n, &limit->rlim_cur, &limit->rlim_max);
+	if (c != 3)
+		return -1;
+
+	return n;
+}
+
+static int rlimit_limits_write_string(struct cgroup *cgrp,
+	struct cftype *cft,
+	const char *buffer)
+{
+	struct rlimit_cgroup *rlimitcg = rlimit_cgroup_from_cgrp(cgrp);
+	struct rlimit limit;
+	struct cgroup_iter it;
+	struct task_struct *tsk;
+	int n;
+
+	n = parse_rlimit_input(&limit, buffer);
+	if (n < 0)
+		return -EINVAL;
+
+	mutex_lock(&rlimitcg->lock);
+	rlimitcg->rlim[n] = limit;
+
+	cgroup_iter_start(cgrp, &it);
+
+	while ((tsk = cgroup_iter_next(cgrp, &it)))
+		__setrlimit(tsk, n, &limit);
+
+	cgroup_iter_end(cgrp, &it);
+
+	mutex_unlock(&rlimitcg->lock);
+
+	return 0;
+}
+
+static int rlimit_limits_read_seq_string(struct cgroup *cgrp,
+	struct cftype *cft,
+	struct seq_file *m)
+{
+	struct rlimit_cgroup *rlimitcg = rlimit_cgroup_from_cgrp(cgrp);
+	char buf[91];
+	int i, c;
+
+	mutex_lock(&rlimitcg->lock);
+	sprintf(buf, "%-10s %-25s %-20s %-20s %-10s\n",
+		"Number", "Limit", "Soft Limit", "Hard Limit", "Unit");
+	seq_puts(m, buf);
+
+	for (i = 0; i < RLIM_NLIMITS; i++) {
+		c = sprintf(buf, "%-10d ", i);
+
+		if (rlimitcg->rlim[i].rlim_cur == RLIM_INFINITY)
+			c += sprintf(&buf[c], "%-25s %-20s ",
+					lnames[i].name, "unlimited");
+		else
+			c += sprintf(&buf[c], "%-25s %-20lu ",
+				lnames[i].name, rlimitcg->rlim[i].rlim_cur);
+
+		if (rlimitcg->rlim[i].rlim_max == RLIM_INFINITY)
+			c += sprintf(&buf[c], "%-20s ", "unlimited");
+		else
+			c += sprintf(&buf[c], "%-20lu ",
+					rlimitcg->rlim[i].rlim_max);
+
+		if (lnames[i].unit)
+			sprintf(&buf[c], "%-10s\n",
+					lnames[i].unit);
+		else
+			sprintf(&buf[c], "\n");
+
+		seq_puts(m, buf);
+	}
+
+	mutex_unlock(&rlimitcg->lock);
+
+	return 0;
+}
+
+static struct cftype rlimit_cgroup_files[] = {
+	{
+		.name = "limits",
+		.write_string = rlimit_limits_write_string,
+		.read_seq_string = rlimit_limits_read_seq_string,
+	},
+};
+
+static struct cgroup_subsys_state*
+rlimit_cgroup_create(struct cgroup_subsys *ss,
+	struct cgroup *cgrp)
+{
+	struct rlimit_cgroup *rlimitcg;
+	int i;
+
+	rlimitcg = kzalloc(sizeof(struct rlimit_cgroup), GFP_KERNEL);
+	if (!rlimitcg)
+		return ERR_PTR(-ENOMEM);
+
+	mutex_init(&rlimitcg->lock);
+
+	for (i = 0; i < RLIM_NLIMITS; i++)
+		rlimitcg->rlim[i] = current->signal->rlim[i];
+
+	return &rlimitcg->css;
+}
+
+static void rlimit_cgroup_destroy(struct cgroup_subsys *ss, struct cgroup *cgrp)
+{
+	kfree(rlimit_cgroup_from_cgrp(cgrp));
+}
+
+static void rlimit_cgroup_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
+	struct cgroup *old_cgrp, struct task_struct *tsk)
+{
+	struct rlimit_cgroup *rlimitcg = rlimit_cgroup_from_cgrp(cgrp);
+	int i;
+
+	mutex_lock(&rlimitcg->lock);
+	for (i = 0; i < RLIM_NLIMITS; i++)
+		__setrlimit(tsk, i, &rlimitcg->rlim[i]);
+	mutex_unlock(&rlimitcg->lock);
+}
+
+
+static int rlimit_cgroup_populate(struct cgroup_subsys *ss,
+	struct cgroup *cgrp)
+{
+	if (rlimit_cgroup_subsys.disabled)
+		return 0;
+
+	return cgroup_add_files(cgrp, ss, rlimit_cgroup_files,
+			ARRAY_SIZE(rlimit_cgroup_files));
+}
+
+struct cgroup_subsys rlimit_cgroup_subsys = {
+	.name = "rlimit",
+	.subsys_id = rlimit_cgroup_subsys_id,
+	.create = rlimit_cgroup_create,
+	.destroy = rlimit_cgroup_destroy,
+	.attach = rlimit_cgroup_attach,
+	.populate = rlimit_cgroup_populate,
+	.early_init = 0,
+};
--- linux-2.6.26-rc8-mm1.orig/kernel/Makefile	2008-07-23 18:48:04.000000000 +0900
+++ linux-2.6.26-rc8-mm1/kernel/Makefile	2008-07-23 18:48:09.000000000 +0900
@@ -51,6 +51,7 @@ obj-$(CONFIG_KEXEC) += kexec.o
 obj-$(CONFIG_COMPAT) += compat.o
 obj-$(CONFIG_CGROUPS) += cgroup.o
 obj-$(CONFIG_CGROUP_DEBUG) += cgroup_debug.o
+obj-$(CONFIG_CGROUP_RLIMIT) += cgroup_rlimit.o
 obj-$(CONFIG_CPUSETS) += cpuset.o
 obj-$(CONFIG_CGROUP_NS) += ns_cgroup.o
 obj-$(CONFIG_UTS_NS) += utsname.o
--- linux-2.6.26-rc8-mm1.orig/include/linux/cgroup_subsys.h	2008-07-23 18:48:04.000000000 +0900
+++ linux-2.6.26-rc8-mm1/include/linux/cgroup_subsys.h	2008-07-23 18:48:09.000000000 +0900
@@ -52,3 +52,7 @@ SUBSYS(memrlimit_cgroup)
 #endif

 /* */
+
+#ifdef CONFIG_CGROUP_RLIMIT
+SUBSYS(rlimit_cgroup)
+#endif
--- linux-2.6.26-rc8-mm1.orig/init/Kconfig	2008-07-23 18:48:04.000000000 +0900
+++ linux-2.6.26-rc8-mm1/init/Kconfig	2008-07-23 21:20:36.000000000 +0900
@@ -290,6 +290,15 @@ config CGROUP_DEBUG

 	  Say N if unsure

+config CGROUP_RLIMIT
+	bool "Simple rlimit interface cgroup subsystem"
+       	depends on CGROUPS && EXPERIMENTAL
+       	default n
+       	help
+	  Provides a rlimit interface cgroup subsystem.
+
+	  Say N if unsure
+
 config CGROUP_NS
         bool "Namespace cgroup subsystem"
         depends on CGROUPS


