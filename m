Return-Path: <linux-kernel-owner+w=401wt.eu-S1755605AbYGHNoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605AbYGHNoE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 09:44:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbYGHNny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 09:43:54 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:56003 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992AbYGHNnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 09:43:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=F0BRUUMzCDeX8tRNmn49S5xY4HIz7AcUnRcroBQmePHsEgiBYCmTF/O+dm2ufQYwi4
         wCA19z0eewz3ZNv9Fnms+UD/6E4SZnyhErSehfeVDnSSYtU+X9iJtd5nwwHtSp1y8cru
         omZ0QRnauGQdOTd8PQ46ws/MbO6zrj/sEGfqc=
Date: Tue, 8 Jul 2008 17:43:36 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       tony@atomide.com, paul@pwsan.com, David Brownell <david-b@pacbell.net>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>, ian <spyro@f2s.com>
Subject: [PATCH 1/3] genclk: add generic framework for managing clocks.
Message-ID: <20080708134336.GA6240@doriath.ww600.siemens.net>
References: <20080708134242.GA6176@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080708134242.GA6176@doriath.ww600.siemens.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a generic framework that platform may choose
to support clocks api. In particular this provides
platform-independant struct clk definition, a full
implementation of clocks api and a set of functions
for registering and unregistering clocks in a safe way.

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
---
 include/linux/generic_clk.h    |   72 +++++++++++
 init/Kconfig                   |    3 +
 kernel/Makefile                |    2 +
 kernel/genclk/Makefile         |    2 +
 kernel/genclk/genclk.c         |  264 ++++++++++++++++++++++++++++++++++++++++
 kernel/genclk/genclk.h         |   21 +++
 kernel/genclk/genclk_debugfs.c |   97 +++++++++++++++
 7 files changed, 461 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/generic_clk.h
 create mode 100644 kernel/genclk/Makefile
 create mode 100644 kernel/genclk/genclk.c
 create mode 100644 kernel/genclk/genclk.h
 create mode 100644 kernel/genclk/genclk_debugfs.c

diff --git a/include/linux/generic_clk.h b/include/linux/generic_clk.h
new file mode 100644
index 0000000..c211966
--- /dev/null
+++ b/include/linux/generic_clk.h
@@ -0,0 +1,72 @@
+/*
+ * Copyright (C) 2008 Dmitry Baryshkov
+ *
+ * This file is released under the GPL v2.
+ */
+
+#ifndef GENERIC_CLK_H
+#define GENERIC_CLK_H
+
+#include <linux/spinlock.h>
+#include <linux/kref.h>
+
+struct clk;
+struct device;
+
+/**
+ * struct clk_ops - generic clock management operations
+ * @can_get: checks whether passed device can get this clock
+ * @set_parent: reconfigures the clock to use specified parent
+ * @set_mode: enable or disable specified clock
+ * @get_rate: obtain the current clock rate of a specified clock
+ * @set_rate: set the clock rate for a specified clock
+ * @round_rate: adjust a reate to the exact rate a clock can provide
+ *
+ * This structure specifies clock operations that are used to configure
+ * specific clock.
+ */
+struct clk_ops {
+	int (*can_get)(struct clk *clk, struct device *dev);
+	int (*set_parent)(struct clk *clk, struct clk *parent);
+	int (*enable)(struct clk *clk);
+	void (*disable)(struct clk *clk);
+	unsigned long (*get_rate)(struct clk *clk);
+	long (*round_rate)(struct clk *clk, unsigned long hz, bool apply);
+};
+
+/*
+ * This is a part of struct clk that is used by generic_clk core.
+ * Don't ever touch it.
+ */
+struct clk_priv {
+	struct list_head node;
+#ifdef CONFIG_DEBUG_SPINLOCK
+	struct lock_class_key lock_key;
+#endif
+	spinlock_t lock;
+	struct kref ref;
+	int usage;
+#ifdef CONFIG_DEBUG_FS
+	struct dentry *info;
+#endif
+};
+
+struct clk {
+	const char *name;
+	struct clk *parent;
+	struct clk_ops *ops;
+	void (*release)(struct clk *clk);
+
+#ifdef CONFIG_DEBUG_FS
+	struct dentry *dir;
+#endif
+
+	struct clk_priv priv;
+};
+
+int clk_register(struct clk *clk);
+void clk_unregister(struct clk *clk);
+int clks_register(struct clk **clk, size_t num);
+void clks_unregister(struct clk **clk, size_t num);
+
+#endif
diff --git a/init/Kconfig b/init/Kconfig
index 6199d11..2b016ce 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -800,6 +800,9 @@ config PROC_PAGE_MONITOR
 	  /proc/kpagecount, and /proc/kpageflags. Disabling these
           interfaces will reduce the size of the kernel by approximately 4kb.
 
+config HAVE_GENERIC_CLOCKS
+	bool
+
 endmenu		# General setup
 
 config SLABINFO
diff --git a/kernel/Makefile b/kernel/Makefile
index 1c9938a..3d9aa05 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -70,6 +70,8 @@ obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
 obj-$(CONFIG_MARKERS) += marker.o
 obj-$(CONFIG_LATENCYTOP) += latencytop.o
 
+obj-$(CONFIG_HAVE_GENERIC_CLOCKS) += genclk/
+
 ifneq ($(CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
 # needed for x86 only.  Why this used to be enabled for all architectures is beyond
diff --git a/kernel/genclk/Makefile b/kernel/genclk/Makefile
new file mode 100644
index 0000000..39df420
--- /dev/null
+++ b/kernel/genclk/Makefile
@@ -0,0 +1,2 @@
+obj-y := genclk.o
+obj-$(CONFIG_DEBUG_FS) += genclk_debugfs.o
diff --git a/kernel/genclk/genclk.c b/kernel/genclk/genclk.c
new file mode 100644
index 0000000..c76ab49
--- /dev/null
+++ b/kernel/genclk/genclk.c
@@ -0,0 +1,264 @@
+/*
+ * Generic clocks API implementation
+ *
+ * Copyright (c) 2008 Dmitry Baryshkov
+ *
+ * This file is released under the GPL v2.
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/clk.h>
+#include <linux/generic_clk.h>
+#include <linux/spinlock.h>
+
+#include "genclk.h"
+
+LIST_HEAD(clocks);
+DEFINE_SPINLOCK(clocks_lock);
+
+static int clk_can_get_def(struct clk *clk, struct device *dev)
+{
+	return 1;
+}
+
+static unsigned long clk_get_rate_def(struct clk *clk)
+{
+	return 0;
+}
+
+static long clk_round_rate_def(struct clk *clk, unsigned long hz, bool apply)
+{
+	long rate = clk->ops->get_rate(clk);
+
+	if (apply && hz != rate)
+		return -EINVAL;
+
+	return rate;
+}
+
+static void clk_release(struct kref *ref)
+{
+	struct clk *clk = container_of(ref, struct clk, priv.ref);
+
+	BUG_ON(!clk->release);
+
+	if (clk->parent)
+		kref_get(&clk->parent->priv.ref);
+
+	clk->release(clk);
+}
+EXPORT_SYMBOL(clk_round_rate);
+
+struct clk* clk_get_parent(struct clk *clk)
+{
+	struct clk *parent;
+
+	spin_lock(&clk->priv.lock);
+
+	parent = clk->parent;
+	kref_get(&parent->priv.ref);
+
+	spin_unlock(&clk->priv.lock);
+
+	return parent;
+}
+EXPORT_SYMBOL(clk_get_parent);
+
+int clk_set_parent(struct clk *clk, struct clk *parent)
+{
+	int rc = -EINVAL;
+	struct clk *old;
+
+	spin_lock(&clk->priv.lock);
+
+	if (!clk->ops->set_parent)
+		goto out;
+
+	old = clk->parent;
+
+	rc = clk->ops->set_parent(clk, parent);
+	if (rc)
+		goto out;
+
+	kref_get(&parent->priv.ref);
+	clk->parent = parent;
+
+	clk_debugfs_reparent(clk, old, parent);
+
+	kref_put(&old->priv.ref, clk_release);
+
+out:
+	spin_unlock(&clk->priv.lock);
+
+	return rc;
+}
+EXPORT_SYMBOL(clk_set_parent);
+
+int clk_register(struct clk *clk)
+{
+	int rc;
+
+	BUG_ON(!clk->ops);
+	BUG_ON(!clk->ops->enable || !clk->ops->disable);
+
+	if (!clk->ops->can_get)
+		clk->ops->can_get = clk_can_get_def;
+	if (!clk->ops->get_rate)
+		clk->ops->get_rate = clk_get_rate_def;
+	if (!clk->ops->round_rate)
+		clk->ops->round_rate = clk_round_rate_def;
+
+	kref_init(&clk->priv.ref);
+#ifdef CONFIG_DEBUG_SPINLOCK
+	__spin_lock_init(&clk->priv.lock, "&clk->priv.lock", &clk->priv.lock_key);
+#else
+	spin_lock_init(&clk->priv.lock);
+#endif
+
+	spin_lock(&clocks_lock);
+	if (clk->parent)
+		kref_get(&clk->parent->priv.ref);
+	list_add_tail(&clk->priv.node, &clocks);
+
+	rc = clk_debugfs_init(clk);
+	if (rc) {
+		list_del(&clk->priv.node);
+		kref_put(&clk->priv.ref, clk_release);
+	}
+
+	spin_unlock(&clocks_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL(clk_register);
+
+void clk_unregister(struct clk *clk)
+{
+	spin_lock(&clocks_lock);
+	clk_debugfs_clean(clk);
+	list_del(&clk->priv.node);
+	kref_put(&clk->priv.ref, clk_release);
+	spin_unlock(&clocks_lock);
+}
+EXPORT_SYMBOL(clk_unregister);
+
+int clks_register(struct clk **clk, size_t num)
+{
+	int i;
+	int rc;
+	for (i = 0; i < num; i++) {
+		rc = clk_register(clk[i]);
+		if (rc)
+			return rc;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(clks_register);
+
+void clks_unregister(struct clk **clk, size_t num)
+{
+	int i;
+	for (i = 0; i < num; i++)
+		clk_unregister(clk[i]);
+}
+EXPORT_SYMBOL(clks_unregister);
+
+struct clk *clk_get(struct device *dev, const char *id)
+{
+	struct clk *clk = NULL, *p;
+
+	spin_lock(&clocks_lock);
+	list_for_each_entry(p, &clocks, priv.node)
+		if (strcmp(id, p->name) == 0 && p->ops->can_get(p, dev)) {
+			clk = p;
+			kref_get(&clk->priv.ref);
+			break;
+		}
+
+	spin_unlock(&clocks_lock);
+
+	return clk;
+}
+EXPORT_SYMBOL(clk_get);
+
+void clk_put(struct clk *clk)
+{
+	kref_put(&clk->priv.ref, clk_release);
+}
+EXPORT_SYMBOL(clk_put);
+
+int clk_enable(struct clk *clk)
+{
+	int rc = 0;
+
+	spin_lock(&clk->priv.lock);
+
+	clk->priv.usage++;
+	if (clk->priv.usage == 1)
+		rc = clk->ops->enable(clk);
+
+	if (rc)
+		clk->priv.usage--;
+
+	spin_unlock(&clk->priv.lock);
+
+	return rc;
+}
+EXPORT_SYMBOL(clk_enable);
+
+void clk_disable(struct clk *clk)
+{
+	spin_lock(&clk->priv.lock);
+
+	WARN_ON(clk->priv.usage <= 0);
+
+	clk->priv.usage--;
+	if (clk->priv.usage == 0)
+		clk->ops->disable(clk);
+
+	spin_unlock(&clk->priv.lock);
+}
+EXPORT_SYMBOL(clk_disable);
+
+unsigned long clk_get_rate(struct clk *clk)
+{
+	unsigned long hz;
+
+	spin_lock(&clk->priv.lock);
+
+	hz = clk->ops->get_rate(clk);
+
+	spin_unlock(&clk->priv.lock);
+
+	return hz;
+}
+EXPORT_SYMBOL(clk_get_rate);
+
+int clk_set_rate(struct clk *clk, unsigned long hz)
+{
+	long rc;
+
+	spin_lock(&clk->priv.lock);
+
+	rc = clk->ops->round_rate(clk, hz, 1);
+
+	spin_unlock(&clk->priv.lock);
+
+	return rc < 0 ? rc : 0;
+}
+EXPORT_SYMBOL(clk_set_rate);
+
+long clk_round_rate(struct clk *clk, unsigned long hz)
+{
+	long rc;
+
+	spin_lock(&clk->priv.lock);
+
+	rc = clk->ops->round_rate(clk, hz, 0);
+
+	spin_unlock(&clk->priv.lock);
+
+	return rc;
+}
+
diff --git a/kernel/genclk/genclk.h b/kernel/genclk/genclk.h
new file mode 100644
index 0000000..5b8d12c
--- /dev/null
+++ b/kernel/genclk/genclk.h
@@ -0,0 +1,21 @@
+#ifndef GENCLK_H
+#define GENCLK_H
+
+#include <linux/list.h>
+#include <linux/spinlock.h>
+
+extern struct list_head clocks;
+extern spinlock_t clocks_lock;
+
+#ifdef CONFIG_DEBUG_FS
+int clk_debugfs_init(struct clk *clk);
+void clk_debugfs_clean(struct clk *clk);
+void clk_debugfs_reparent(struct clk *clk, struct clk *old, struct clk *new);
+#else
+#define clk_debugfs_init(clk) ({0;})
+#define clk_debugfs_clean(clk) do {} while (0);
+#define clk_debugfs_reparent(clk, old, new) do {} while (0);
+#endif
+
+
+#endif
diff --git a/kernel/genclk/genclk_debugfs.c b/kernel/genclk/genclk_debugfs.c
new file mode 100644
index 0000000..b8acd38
--- /dev/null
+++ b/kernel/genclk/genclk_debugfs.c
@@ -0,0 +1,97 @@
+/*
+ * Generic clocks API implementation
+ *
+ * Copyright (c) 2008 Dmitry Baryshkov
+ *
+ * This file is released under the GPL v2.
+ */
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+#include <linux/clk.h>
+#include <linux/generic_clk.h>
+
+#include "genclk.h"
+
+static struct dentry *clkdir;
+
+static int genclk_show(struct seq_file *s, void *data)
+{
+	struct clk *clk = s->private;
+
+	BUG_ON(!clk);
+
+	seq_printf(s, "set_parent=%savailable\nusage=%d/%d\nrate=%10lu Hz\n",
+			clk->ops && clk->ops->set_parent ? "" : "not ",
+			clk->priv.usage, atomic_read(&clk->priv.ref.refcount),
+			clk_get_rate(clk));
+
+	return 0;
+}
+
+static int genclk_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, genclk_show, inode->i_private);
+}
+
+static struct file_operations genclk_operations = {
+	.open		= genclk_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+int clk_debugfs_init(struct clk *clk)
+{
+	struct dentry *dir;
+	struct dentry *info;
+
+	/*
+	 * We initialise it here, because this call can be executed from within arch code,
+	 * so specifyint correct initialisation place is a bit tricky
+	 */
+	if (!clkdir)
+		clkdir = debugfs_create_dir("clocks", NULL);
+
+	dir = debugfs_create_dir(clk->name,
+			clk->parent ? clk->parent->dir : clkdir);
+
+	if (IS_ERR(dir))
+		return PTR_ERR(dir);
+
+	info = debugfs_create_file("info", S_IFREG | S_IRUGO,
+			dir, clk, &genclk_operations);
+
+	if (IS_ERR(info)) {
+		debugfs_remove(dir);
+		return PTR_ERR(info);
+	}
+
+	clk->dir = dir;
+	clk->priv.info = info;
+
+	return 0;
+}
+
+void clk_debugfs_clean(struct clk *clk)
+{
+	if (clk->priv.info)
+		debugfs_remove(clk->priv.info);
+	clk->priv.info = NULL;
+
+	if (clk->dir)
+		debugfs_remove(clk->dir);
+	clk->dir = NULL;
+}
+
+void clk_debugfs_reparent(struct clk *clk, struct clk *old, struct clk *new)
+{
+	struct dentry *oldd = old ? old->dir : clkdir;
+	struct dentry *newd = new ? new->dir : clkdir;
+	struct dentry *dir = debugfs_rename(oldd, clk->dir, newd, clk->name);
+
+	if (IS_ERR(dir))
+		WARN_ON(1);
+	else
+		clk->dir = dir;
+}
+
-- 
1.5.6


-- 
With best wishes
Dmitry

