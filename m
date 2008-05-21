Return-Path: <linux-kernel-owner+w=401wt.eu-S935106AbYEUPbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935106AbYEUPbI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 11:31:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761098AbYEUPau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 11:30:50 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:33339 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758109AbYEUPas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 11:30:48 -0400
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: linux-mm@kvack.org
Cc: Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, Pavel Emelianov <xemul@openvz.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 21 May 2008 20:59:48 +0530
Message-Id: <20080521152948.15001.39361.sendpatchset@localhost.localdomain>
In-Reply-To: <20080521152921.15001.65968.sendpatchset@localhost.localdomain>
References: <20080521152921.15001.65968.sendpatchset@localhost.localdomain>
Subject: [-mm][PATCH 2/4] Setup the memrlimit controller (v5)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch sets up the rlimit cgroup controller. It adds the basic create,
destroy and populate functionality. The user interface provided is very
similar to the memory resource controller. The rlimit controller can be
enhanced easily in the future to control mlocked pages.

Changelog v3->v4

1. Use PAGE_ALIGN()
2. Rename rlimit to memrlimit

Acked-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 include/linux/cgroup_subsys.h   |    4 +
 include/linux/memrlimitcgroup.h |   19 +++++
 init/Kconfig                    |   10 ++
 mm/Makefile                     |    1 
 mm/memrlimitcgroup.c            |  144 ++++++++++++++++++++++++++++++++++++++++
 5 files changed, 178 insertions(+)

diff -puN include/linux/cgroup_subsys.h~memrlimit-controller-setup include/linux/cgroup_subsys.h
--- linux-2.6.26-rc2/include/linux/cgroup_subsys.h~memrlimit-controller-setup	2008-05-21 20:56:50.000000000 +0530
+++ linux-2.6.26-rc2-balbir/include/linux/cgroup_subsys.h	2008-05-21 20:56:50.000000000 +0530
@@ -47,4 +47,8 @@ SUBSYS(mem_cgroup)
 SUBSYS(devices)
 #endif
 
+#ifdef CONFIG_CGROUP_MEMRLIMIT_CTLR
+SUBSYS(memrlimit_cgroup)
+#endif
+
 /* */
diff -puN /dev/null include/linux/memrlimitcgroup.h
--- /dev/null	2008-05-16 21:23:36.290004010 +0530
+++ linux-2.6.26-rc2-balbir/include/linux/memrlimitcgroup.h	2008-05-21 20:56:50.000000000 +0530
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
+#ifndef LINUX_MEMRLIMITCGROUP_H
+#define LINUX_MEMRLIMITCGROUP_H
+
+#endif /* LINUX_MEMRLIMITCGROUP_H */
diff -puN init/Kconfig~memrlimit-controller-setup init/Kconfig
--- linux-2.6.26-rc2/init/Kconfig~memrlimit-controller-setup	2008-05-21 20:56:50.000000000 +0530
+++ linux-2.6.26-rc2-balbir/init/Kconfig	2008-05-21 20:56:50.000000000 +0530
@@ -407,6 +407,16 @@ config CGROUP_MEM_RES_CTLR
 	  This config option also selects MM_OWNER config option, which
 	  could in turn add some fork/exit overhead.
 
+config CGROUP_MEMRLIMIT_CTLR
+	bool "Memory resource limit controls for cgroups"
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
 
diff -puN mm/Makefile~memrlimit-controller-setup mm/Makefile
--- linux-2.6.26-rc2/mm/Makefile~memrlimit-controller-setup	2008-05-21 20:56:50.000000000 +0530
+++ linux-2.6.26-rc2-balbir/mm/Makefile	2008-05-21 20:56:50.000000000 +0530
@@ -34,4 +34,5 @@ obj-$(CONFIG_MIGRATION) += migrate.o
 obj-$(CONFIG_SMP) += allocpercpu.o
 obj-$(CONFIG_QUICKLIST) += quicklist.o
 obj-$(CONFIG_CGROUP_MEM_RES_CTLR) += memcontrol.o
+obj-$(CONFIG_CGROUP_MEMRLIMIT_CTLR) += memrlimitcgroup.o
 
diff -puN /dev/null mm/memrlimitcgroup.c
--- /dev/null	2008-05-16 21:23:36.290004010 +0530
+++ linux-2.6.26-rc2-balbir/mm/memrlimitcgroup.c	2008-05-21 20:56:50.000000000 +0530
@@ -0,0 +1,144 @@
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
+ * Provide memory resource limits for tasks in a control group. A lot of code is
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
+#include <linux/memrlimitcgroup.h>
+
+struct cgroup_subsys memrlimit_cgroup_subsys;
+
+struct memrlimit_cgroup {
+	struct cgroup_subsys_state css;
+	struct res_counter as_res;	/* address space counter */
+};
+
+static struct memrlimit_cgroup init_memrlimit_cgroup;
+
+static struct memrlimit_cgroup *memrlimit_cgroup_from_cgrp(struct cgroup *cgrp)
+{
+	return container_of(cgroup_subsys_state(cgrp,
+				memrlimit_cgroup_subsys_id),
+				struct memrlimit_cgroup, css);
+}
+
+static struct cgroup_subsys_state *
+memrlimit_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cgrp)
+{
+	struct memrlimit_cgroup *memrcg;
+
+	if (unlikely(cgrp->parent == NULL))
+		memrcg = &init_memrlimit_cgroup;
+	else {
+		memrcg = kzalloc(sizeof(*memrcg), GFP_KERNEL);
+		if (!memrcg)
+			return ERR_PTR(-ENOMEM);
+	}
+	res_counter_init(&memrcg->as_res);
+	return &memrcg->css;
+}
+
+static void memrlimit_cgroup_destroy(struct cgroup_subsys *ss,
+					struct cgroup *cgrp)
+{
+	kfree(memrlimit_cgroup_from_cgrp(cgrp));
+}
+
+static int memrlimit_cgroup_reset(struct cgroup *cgrp, unsigned int event)
+{
+	struct memrlimit_cgroup *memrcg;
+
+	memrcg = memrlimit_cgroup_from_cgrp(cgrp);
+	switch (event) {
+	case RES_FAILCNT:
+		res_counter_reset_failcnt(&memrcg->as_res);
+		break;
+	}
+	return 0;
+}
+
+static u64 memrlimit_cgroup_read(struct cgroup *cgrp, struct cftype *cft)
+{
+	return res_counter_read_u64(&memrlimit_cgroup_from_cgrp(cgrp)->as_res,
+					cft->private);
+}
+
+static int memrlimit_cgroup_write_strategy(char *buf, unsigned long long *tmp)
+{
+	*tmp = memparse(buf, &buf);
+	if (*buf != '\0')
+		return -EINVAL;
+
+	*tmp = PAGE_ALIGN(*tmp);
+	return 0;
+}
+
+static ssize_t memrlimit_cgroup_write(struct cgroup *cgrp, struct cftype *cft,
+					struct file *file,
+					const char __user *userbuf,
+					size_t nbytes,
+					loff_t *ppos)
+{
+	return res_counter_write(&memrlimit_cgroup_from_cgrp(cgrp)->as_res,
+					cft->private, userbuf, nbytes, ppos,
+					memrlimit_cgroup_write_strategy);
+}
+
+static struct cftype memrlimit_cgroup_files[] = {
+	{
+		.name = "usage_in_bytes",
+		.private = RES_USAGE,
+		.read_u64 = memrlimit_cgroup_read,
+	},
+	{
+		.name = "limit_in_bytes",
+		.private = RES_LIMIT,
+		.write = memrlimit_cgroup_write,
+		.read_u64 = memrlimit_cgroup_read,
+	},
+	{
+		.name = "failcnt",
+		.private = RES_FAILCNT,
+		.trigger = memrlimit_cgroup_reset,
+		.read_u64 = memrlimit_cgroup_read,
+	},
+};
+
+static int memrlimit_cgroup_populate(struct cgroup_subsys *ss,
+					struct cgroup *cgrp)
+{
+	return cgroup_add_files(cgrp, ss, memrlimit_cgroup_files,
+				ARRAY_SIZE(memrlimit_cgroup_files));
+}
+
+struct cgroup_subsys memrlimit_cgroup_subsys = {
+	.name = "memrlimit",
+	.subsys_id = memrlimit_cgroup_subsys_id,
+	.create = memrlimit_cgroup_create,
+	.destroy = memrlimit_cgroup_destroy,
+	.populate = memrlimit_cgroup_populate,
+	.early_init = 0,
+};
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
