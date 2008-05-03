Return-Path: <linux-kernel-owner+w=401wt.eu-S1755989AbYECVix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbYECVix (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 17:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755523AbYECViZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 17:38:25 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:51074 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730AbYECViQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 17:38:16 -0400
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: linux-mm@kvack.org
Cc: Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Sun, 04 May 2008 03:07:36 +0530
Message-Id: <20080503213736.3140.83278.sendpatchset@localhost.localdomain>
In-Reply-To: <20080503213726.3140.68845.sendpatchset@localhost.localdomain>
References: <20080503213726.3140.68845.sendpatchset@localhost.localdomain>
Subject: [-mm][PATCH 1/4] Setup the rlimit controller
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



This patch sets up the rlimit cgroup controller. It adds the basic create,
destroy and populate functionality. The user interface provided is very
similar to the memory resource controller. The rlimit controller can be
enhanced easily in the future to control mlocked pages.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 include/linux/cgroup_subsys.h |    4 +
 include/linux/rlimitcgroup.h  |   19 +++++
 init/Kconfig                  |   10 ++
 mm/Makefile                   |    1 
 mm/rlimitcgroup.c             |  141 ++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 175 insertions(+)

diff -puN /dev/null mm/rlimitcgroup.c
--- /dev/null	2008-05-03 22:12:13.033285313 +0530
+++ linux-2.6.25-balbir/mm/rlimitcgroup.c	2008-05-04 02:52:51.000000000 +0530
@@ -0,0 +1,141 @@
+/*
+ * Copyright © International Business Machines  Corp., 2008
+ *
+ * Author: Balbir Singh <balbir@linux.vnet.ibm.com>
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
+ * Provide resource limits for tasks in a control group. A lot of code is
+ * duplicated from the memory controller (this code is common to almost
+ * all controllers). TODO: Consider writing a tool that can generate this
+ * code.
+ */
+#include <linux/cgroup.h>
+#include <linux/mm.h>
+#include <linux/smp.h>
+#include <linux/rcupdate.h>
+#include <linux/slab.h>
+#include <linux/swap.h>
+#include <linux/spinlock.h>
+#include <linux/fs.h>
+#include <linux/res_counter.h>
+#include <linux/rlimitcgroup.h>
+
+struct cgroup_subsys rlimit_cgroup_subsys;
+
+struct rlimit_cgroup {
+	struct cgroup_subsys_state css;
+	struct res_counter as_res;	/* address space counter */
+};
+
+static struct rlimit_cgroup init_rlimit_cgroup;
+
+struct rlimit_cgroup *rlimit_cgroup_from_cgrp(struct cgroup *cgrp)
+{
+	return container_of(cgroup_subsys_state(cgrp, rlimit_cgroup_subsys_id),
+				struct rlimit_cgroup, css);
+}
+
+static struct cgroup_subsys_state *
+rlimit_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cgrp)
+{
+	struct rlimit_cgroup *rcg;
+
+	if (unlikely(cgrp->parent == NULL))
+		rcg = &init_rlimit_cgroup;
+	else {
+		rcg = kzalloc(sizeof(*rcg), GFP_KERNEL);
+		if (!rcg)
+			return ERR_PTR(-ENOMEM);
+	}
+	res_counter_init(&rcg->as_res);
+	return &rcg->css;
+}
+
+static void rlimit_cgroup_destroy(struct cgroup_subsys *ss, struct cgroup *cgrp)
+{
+	kfree(rlimit_cgroup_from_cgrp(cgrp));
+}
+
+static int rlimit_cgroup_reset(struct cgroup *cgrp, unsigned int event)
+{
+	struct rlimit_cgroup *rcg;
+
+	rcg = rlimit_cgroup_from_cgrp(cgrp);
+	switch (event) {
+	case RES_FAILCNT:
+		res_counter_reset_failcnt(&rcg->as_res);
+		break;
+	}
+	return 0;
+}
+
+static u64 rlimit_cgroup_read(struct cgroup *cgrp, struct cftype *cft)
+{
+	return res_counter_read_u64(&rlimit_cgroup_from_cgrp(cgrp)->as_res,
+					cft->private);
+}
+
+static int rlimit_cgroup_write_strategy(char *buf, unsigned long long *tmp)
+{
+	*tmp = memparse(buf, &buf);
+	if (*buf != '\0')
+		return -EINVAL;
+
+	*tmp = ((*tmp + PAGE_SIZE) >> PAGE_SHIFT) << PAGE_SHIFT;
+	return 0;
+}
+
+static ssize_t rlimit_cgroup_write(struct cgroup *cgrp, struct cftype *cft,
+					struct file *file,
+					const char __user *userbuf,
+					size_t nbytes,
+					loff_t *ppos)
+{
+	return res_counter_write(&rlimit_cgroup_from_cgrp(cgrp)->as_res,
+					cft->private, userbuf, nbytes, ppos,
+					rlimit_cgroup_write_strategy);
+}
+
+static struct cftype rlimit_cgroup_files[] = {
+	{
+		.name = "usage_in_bytes",
+		.private = RES_USAGE,
+		.read_u64 = rlimit_cgroup_read,
+	},
+	{
+		.name = "limit_in_bytes",
+		.private = RES_LIMIT,
+		.write = rlimit_cgroup_write,
+		.read_u64 = rlimit_cgroup_read,
+	},
+	{
+		.name = "failcnt",
+		.private = RES_FAILCNT,
+		.trigger = rlimit_cgroup_reset,
+		.read_u64 = rlimit_cgroup_read,
+	},
+};
+
+static int rlimit_cgroup_populate(struct cgroup_subsys *ss, struct cgroup *cgrp)
+{
+	return cgroup_add_files(cgrp, ss, rlimit_cgroup_files,
+				ARRAY_SIZE(rlimit_cgroup_files));
+}
+
+struct cgroup_subsys rlimit_cgroup_subsys = {
+	.name = "rlimit",
+	.subsys_id = rlimit_cgroup_subsys_id,
+	.create = rlimit_cgroup_create,
+	.destroy = rlimit_cgroup_destroy,
+	.populate = rlimit_cgroup_populate,
+	.early_init = 0,
+};
diff -puN /dev/null include/linux/rlimitcgroup.h
--- /dev/null	2008-05-03 22:12:13.033285313 +0530
+++ linux-2.6.25-balbir/include/linux/rlimitcgroup.h	2008-05-04 02:53:02.000000000 +0530
@@ -0,0 +1,19 @@
+/*
+ * Copyright © International Business Machines  Corp., 2008
+ *
+ * Author: Balbir Singh <balbir@linux.vnet.ibm.com>
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
+ */
+#ifndef LINUX_RLIMITCGROUP_H
+#define LINUX_RLIMITCGROUP_H
+
+#endif /* LINUX_RLIMITCGROUP_H */
diff -puN include/linux/cgroup_subsys.h~rlimit-controller-setup include/linux/cgroup_subsys.h
--- linux-2.6.25/include/linux/cgroup_subsys.h~rlimit-controller-setup	2008-05-04 02:52:51.000000000 +0530
+++ linux-2.6.25-balbir/include/linux/cgroup_subsys.h	2008-05-04 02:52:51.000000000 +0530
@@ -47,4 +47,8 @@ SUBSYS(mem_cgroup)
 SUBSYS(devices)
 #endif
 
+#ifdef CONFIG_CGROUP_RLIMIT_CTLR
+SUBSYS(rlimit_cgroup)
+#endif
+
 /* */
diff -puN init/Kconfig~rlimit-controller-setup init/Kconfig
--- linux-2.6.25/init/Kconfig~rlimit-controller-setup	2008-05-04 02:52:51.000000000 +0530
+++ linux-2.6.25-balbir/init/Kconfig	2008-05-04 02:52:51.000000000 +0530
@@ -393,6 +393,16 @@ config CGROUP_MEM_RES_CTLR
 	  This config option also selects MM_OWNER config option, which
 	  could in turn add some fork/exit overhead.
 
+config CGROUP_RLIMIT_CTLR
+	bool "rlimit controls for cgroups"
+	depends on CGROUPS && RESOURCE_COUNTERS && MMU
+	select MM_OWNER
+	help
+	  Provides resource limits for all the tasks belonging to a
+	  control group. CGROUP_MEM_RES_CTLR provides support for physical
+	  memory RSS and Page Cache control. Virtual address space control
+	  is provided by this controller.
+
 config SYSFS_DEPRECATED
 	bool
 
diff -puN mm/Makefile~rlimit-controller-setup mm/Makefile
--- linux-2.6.25/mm/Makefile~rlimit-controller-setup	2008-05-04 02:52:51.000000000 +0530
+++ linux-2.6.25-balbir/mm/Makefile	2008-05-04 02:52:51.000000000 +0530
@@ -33,4 +33,5 @@ obj-$(CONFIG_MIGRATION) += migrate.o
 obj-$(CONFIG_SMP) += allocpercpu.o
 obj-$(CONFIG_QUICKLIST) += quicklist.o
 obj-$(CONFIG_CGROUP_MEM_RES_CTLR) += memcontrol.o
+obj-$(CONFIG_CGROUP_RLIMIT_CTLR) += rlimitcgroup.o
 
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
