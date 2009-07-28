Return-Path: <linux-kernel-owner+w=401wt.eu-S1752254AbZG1X1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254AbZG1X1c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbZG1X1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:27:31 -0400
Received: from smtp-out.google.com ([216.239.45.13]:18264 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbZG1X1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:27:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=QL82vNN1ve6+qXB8auyA9HVH35bEUlLTdVPSdJmU51P4OEug6zMSU1kQ0An//Xrm2
	S7eupDeG+OH0qk8eq0Cbg==
From: Paul Menage <menage@google.com>
Subject: [PATCH 2/4] Move the cgroup debug subsys into cgroup.c to access
	internal state
To: lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
       kamezawa.hiroyu@jp.fujitsu.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org
Date: Tue, 28 Jul 2009 16:26:26 -0700
Message-ID: <20090728232626.20156.76787.stgit@menage.mtv.corp.google.com>
In-Reply-To: <20090728232508.20156.17943.stgit@menage.mtv.corp.google.com>
References: <20090728232508.20156.17943.stgit@menage.mtv.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the cgroup debug subsys into cgroup.c to access internal state

While it's architecturally clean to have the cgroup debug subsystem be
completely independent of the cgroups framework, it limits its
usefulness for debugging the contents of internal data structures.
Move the debug subsystem code into the scope of all the cgroups data
structures to make more detailed debugging possible.

Signed-off-by: Paul Menage <menage@google.com>
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---

 kernel/Makefile       |    1 
 kernel/cgroup.c       |   88 +++++++++++++++++++++++++++++++++++++++++
 kernel/cgroup_debug.c |  105 -------------------------------------------------
 3 files changed, 88 insertions(+), 106 deletions(-)
 delete mode 100644 kernel/cgroup_debug.c

diff --git a/kernel/Makefile b/kernel/Makefile
index ecbd483..251adfe 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -58,7 +58,6 @@ obj-$(CONFIG_KEXEC) += kexec.o
 obj-$(CONFIG_BACKTRACE_SELF_TEST) += backtracetest.o
 obj-$(CONFIG_COMPAT) += compat.o
 obj-$(CONFIG_CGROUPS) += cgroup.o
-obj-$(CONFIG_CGROUP_DEBUG) += cgroup_debug.o
 obj-$(CONFIG_CGROUP_FREEZER) += cgroup_freezer.o
 obj-$(CONFIG_CPUSETS) += cpuset.o
 obj-$(CONFIG_CGROUP_NS) += ns_cgroup.o
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 85573e8..9491dbb 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3761,3 +3761,91 @@ css_get_next(struct cgroup_subsys *ss, int id,
 	return ret;
 }
 
+#ifdef CONFIG_CGROUP_DEBUG
+static struct cgroup_subsys_state *debug_create(struct cgroup_subsys *ss,
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
+static void debug_destroy(struct cgroup_subsys *ss, struct cgroup *cont)
+{
+	kfree(cont->subsys[debug_subsys_id]);
+}
+
+static u64 cgroup_refcount_read(struct cgroup *cont, struct cftype *cft)
+{
+	return atomic_read(&cont->count);
+}
+
+static u64 debug_taskcount_read(struct cgroup *cont, struct cftype *cft)
+{
+	return cgroup_task_count(cont);
+}
+
+static u64 current_css_set_read(struct cgroup *cont, struct cftype *cft)
+{
+	return (u64)(unsigned long)current->cgroups;
+}
+
+static u64 current_css_set_refcount_read(struct cgroup *cont,
+					   struct cftype *cft)
+{
+	u64 count;
+
+	rcu_read_lock();
+	count = atomic_read(&current->cgroups->refcount);
+	rcu_read_unlock();
+	return count;
+}
+
+static u64 releasable_read(struct cgroup *cgrp, struct cftype *cft)
+{
+	return test_bit(CGRP_RELEASABLE, &cgrp->flags);
+}
+
+static struct cftype debug_files[] =  {
+	{
+		.name = "cgroup_refcount",
+		.read_u64 = cgroup_refcount_read,
+	},
+	{
+		.name = "taskcount",
+		.read_u64 = debug_taskcount_read,
+	},
+
+	{
+		.name = "current_css_set",
+		.read_u64 = current_css_set_read,
+	},
+
+	{
+		.name = "current_css_set_refcount",
+		.read_u64 = current_css_set_refcount_read,
+	},
+
+	{
+		.name = "releasable",
+		.read_u64 = releasable_read,
+	},
+};
+
+static int debug_populate(struct cgroup_subsys *ss, struct cgroup *cont)
+{
+	return cgroup_add_files(cont, ss, debug_files,
+				ARRAY_SIZE(debug_files));
+}
+
+struct cgroup_subsys debug_subsys = {
+	.name = "debug",
+	.create = debug_create,
+	.destroy = debug_destroy,
+	.populate = debug_populate,
+	.subsys_id = debug_subsys_id,
+};
+#endif /* CONFIG_CGROUP_DEBUG */
diff --git a/kernel/cgroup_debug.c b/kernel/cgroup_debug.c
deleted file mode 100644
index 0c92d79..0000000
--- a/kernel/cgroup_debug.c
+++ /dev/null
@@ -1,105 +0,0 @@
-/*
- * kernel/cgroup_debug.c - Example cgroup subsystem that
- * exposes debug info
- *
- * Copyright (C) Google Inc, 2007
- *
- * Developed by Paul Menage (menage@google.com)
- *
- */
-
-#include <linux/cgroup.h>
-#include <linux/fs.h>
-#include <linux/slab.h>
-#include <linux/rcupdate.h>
-
-#include <asm/atomic.h>
-
-static struct cgroup_subsys_state *debug_create(struct cgroup_subsys *ss,
-						   struct cgroup *cont)
-{
-	struct cgroup_subsys_state *css = kzalloc(sizeof(*css), GFP_KERNEL);
-
-	if (!css)
-		return ERR_PTR(-ENOMEM);
-
-	return css;
-}
-
-static void debug_destroy(struct cgroup_subsys *ss, struct cgroup *cont)
-{
-	kfree(cont->subsys[debug_subsys_id]);
-}
-
-static u64 cgroup_refcount_read(struct cgroup *cont, struct cftype *cft)
-{
-	return atomic_read(&cont->count);
-}
-
-static u64 taskcount_read(struct cgroup *cont, struct cftype *cft)
-{
-	u64 count;
-
-	count = cgroup_task_count(cont);
-	return count;
-}
-
-static u64 current_css_set_read(struct cgroup *cont, struct cftype *cft)
-{
-	return (u64)(long)current->cgroups;
-}
-
-static u64 current_css_set_refcount_read(struct cgroup *cont,
-					   struct cftype *cft)
-{
-	u64 count;
-
-	rcu_read_lock();
-	count = atomic_read(&current->cgroups->refcount);
-	rcu_read_unlock();
-	return count;
-}
-
-static u64 releasable_read(struct cgroup *cgrp, struct cftype *cft)
-{
-	return test_bit(CGRP_RELEASABLE, &cgrp->flags);
-}
-
-static struct cftype files[] =  {
-	{
-		.name = "cgroup_refcount",
-		.read_u64 = cgroup_refcount_read,
-	},
-	{
-		.name = "taskcount",
-		.read_u64 = taskcount_read,
-	},
-
-	{
-		.name = "current_css_set",
-		.read_u64 = current_css_set_read,
-	},
-
-	{
-		.name = "current_css_set_refcount",
-		.read_u64 = current_css_set_refcount_read,
-	},
-
-	{
-		.name = "releasable",
-		.read_u64 = releasable_read,
-	},
-};
-
-static int debug_populate(struct cgroup_subsys *ss, struct cgroup *cont)
-{
-	return cgroup_add_files(cont, ss, files, ARRAY_SIZE(files));
-}
-
-struct cgroup_subsys debug_subsys = {
-	.name = "debug",
-	.create = debug_create,
-	.destroy = debug_destroy,
-	.populate = debug_populate,
-	.subsys_id = debug_subsys_id,
-};

