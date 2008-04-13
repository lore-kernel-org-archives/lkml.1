Return-Path: <linux-kernel-owner+w=401wt.eu-S1758648AbYDMOnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648AbYDMOnd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 10:43:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752684AbYDMOnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 10:43:25 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:50119 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbYDMOnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 10:43:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=nhKpKNFHDEeZjLPcUZf30GK9ciaQo8SKRmVgT9TG+QKgR/xo/m/g7el58N0l8jKlsBPSXEbqiBM4eH0hx6eMLFR1MiQ8C9tw82yD29YS7FjnBjMU2TO3c8LQEudZrpTZHgpasZ85ShaeWoesd1uI9bZRqAP3ScwwsLGEiyAer74=
Date: Sun, 13 Apr 2008 18:43:12 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       tony@atomide.com, paul@pwsan.com, David Brownell <david-b@pacbell.net>
Subject: [PATCH 1/5] Clocklib: add generic framework for managing clocks.
Message-ID: <20080413144312.GA1943@doriath.ww600.siemens.net>
References: <20080413144138.GA31665@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080413144138.GA31665@doriath.ww600.siemens.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
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
 MAINTAINERS            |    5 +
 include/linux/clklib.h |  144 +++++++++++++++++++++
 init/Kconfig           |    7 +
 kernel/Makefile        |    1 +
 kernel/clklib.c        |  334 ++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 491 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/clklib.h
 create mode 100644 kernel/clklib.c

diff --git a/MAINTAINERS b/MAINTAINERS
index aaca5cc..a8fbac3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1083,6 +1083,11 @@ P:	Joel Schopp
 M:	jschopp@austin.ibm.com
 S:	Supported
 
+CLOCKLIB INFRASTRUCTURE
+P:	Dmitry Baryshkov
+M:	dbaryshkov@gmail.com
+S:	Maintained
+
 COMMON INTERNET FILE SYSTEM (CIFS)
 P:	Steve French
 M:	sfrench@samba.org
diff --git a/include/linux/clklib.h b/include/linux/clklib.h
new file mode 100644
index 0000000..9545159
--- /dev/null
+++ b/include/linux/clklib.h
@@ -0,0 +1,144 @@
+/*
+ * Copyright (C) 2008 Dmitry Baryshkov
+ *
+ * This file is released under the GPL v2.
+ */
+
+#ifndef CLKLIB_H
+#define CLKLIB_H
+
+#include <linux/list.h>
+
+struct seq_file;
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
+	int (*set_mode)(struct clk *clk, bool enable);
+	unsigned long (*get_rate)(struct clk *clk);
+	int (*set_rate)(struct clk *, unsigned long);
+	long (*round_rate)(struct clk *, unsigned long);
+};
+
+/**
+ * struct clk - generic struct clk implementation used in the clocklib
+ * @node: used to place all clocks in a list
+ * @parent: the parent clock
+ * @owner: module holding all the functions
+ * @name: the name of this clock
+ * @users: count how many users have enabled this clock
+ * @ops: a pointer to clock management operations
+ */
+struct clk {
+	struct list_head node;
+	struct clk	*parent;
+	struct module *owner;
+
+	const char	*name;
+	int		users;
+
+	const struct clk_ops *ops;
+};
+
+int __must_check clk_register(struct clk *clk);
+void clk_unregister(struct clk *clk);
+
+static inline void clks_unregister(struct clk **clks, size_t num)
+{
+	int i;
+	for (i = num - 1; i >= 0;  i++)
+		clk_unregister(clks[i]);
+}
+
+static inline int __must_check clks_register(struct clk **clks, size_t num)
+{
+	int i;
+	int ret;
+	for (i = 0; i < num; i++) {
+		ret = clk_register(clks[i]);
+		if (ret != 0)
+			goto cleanup;
+	}
+
+	return 0;
+
+cleanup:
+	clks_unregister(clks, i);
+
+	return ret;
+}
+
+int __must_check clk_alloc_function(const char *parent, struct clk *clk);
+
+/*
+ * struct clk_function - helper that allows easy registration of clock "functions"
+ * @parent: the name of the parent clock
+ * @clk: the clock that will be set up and installed
+ *
+ * Sometimes single clock will have multiple users or several clocks
+ * will be bound to similar devices. This allows one to register
+ * simple wrapper clocks that serve only naming purposes.
+ */
+struct clk_function {
+	const char *parent;
+	void *priv;
+	struct clk clk;
+};
+
+#define CLK_FUNC(_clock, _function, _ops, _data)	\
+	{						\
+		.parent = _clock,			\
+		.priv	= _data,			\
+		.clk = {				\
+			.name = _function,		\
+			.owner = THIS_MODULE,		\
+			.ops = _ops,			\
+		},					\
+	}
+#define FUNC_TO_CLK(func)	&(&(struct clk_function) func)->clk
+
+static inline void clk_free_functions(
+		struct clk_function *funcs,
+		int num)
+{
+	int i;
+
+	for (i = num - 1; i >= 0; i--)
+		clk_unregister(&funcs[i].clk);
+}
+
+static inline int __must_check clk_alloc_functions(
+		struct clk_function *funcs,
+		int num)
+{
+	int i;
+	int rc;
+
+	for (i = 0; i < num; i++) {
+		rc = clk_alloc_function(funcs[i].parent, &funcs[i].clk);
+
+		if (rc) {
+			printk(KERN_ERR "Error allocating %s.%s function.\n",
+					funcs[i].parent,
+					funcs[i].clk.name);
+			clk_free_functions(funcs, i);
+			return rc;
+		}
+	}
+
+	return 0;
+}
+
+#endif
diff --git a/init/Kconfig b/init/Kconfig
index a97924b..1dd9ce2 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -504,6 +504,13 @@ config CC_OPTIMIZE_FOR_SIZE
 config SYSCTL
 	bool
 
+config HAVE_CLOCK_LIB
+	bool
+	help
+	  Platforms select clocklib if they use this infrastructure
+	  for managing their clocks both built into SoC and provided
+	  by external devices.
+
 menuconfig EMBEDDED
 	bool "Configure standard kernel features (for small systems)"
 	help
diff --git a/kernel/Makefile b/kernel/Makefile
index 6c584c5..afaed51 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -68,6 +68,7 @@ obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
 obj-$(CONFIG_MARKERS) += marker.o
 obj-$(CONFIG_LATENCYTOP) += latencytop.o
+obj-$(CONFIG_HAVE_CLOCK_LIB) += clklib.o
 
 ifneq ($(CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
diff --git a/kernel/clklib.c b/kernel/clklib.c
new file mode 100644
index 0000000..024a232
--- /dev/null
+++ b/kernel/clklib.c
@@ -0,0 +1,334 @@
+/*
+ * kernel/clklib.c
+ *
+ * Copyright (C) 2008 Dmitry Baryshkov
+ *
+ * Generic clocks API implementation
+ *
+ * This file is released under the GPL v2.
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/clk.h>
+#include <linux/clklib.h>
+#include <linux/spinlock.h>
+#include <linux/err.h>
+#include <linux/delay.h>
+
+static LIST_HEAD(clocks);
+static DEFINE_SPINLOCK(clocks_lock);
+
+static int __clk_register(struct clk *clk)
+{
+	if (clk->parent &&
+	    !try_module_get(clk->parent->owner))
+		return -EINVAL;
+
+	list_add_tail(&clk->node, &clocks);
+
+	return 0;
+}
+
+int __must_check clk_register(struct clk *clk)
+{
+	unsigned long flags;
+	int rc;
+
+	spin_lock_irqsave(&clocks_lock, flags);
+
+	rc = __clk_register(clk);
+
+	spin_unlock_irqrestore(&clocks_lock, flags);
+
+	return rc;
+}
+EXPORT_SYMBOL(clk_register);
+
+void clk_unregister(struct clk *clk)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&clocks_lock, flags);
+	list_del(&clk->node);
+	if (clk->parent)
+		module_put(clk->parent->owner);
+	spin_unlock_irqrestore(&clocks_lock, flags);
+}
+EXPORT_SYMBOL(clk_unregister);
+
+struct clk *clk_get(struct device *dev, const char *id)
+{
+	struct clk *p, *clk = ERR_PTR(-ENOENT);
+	unsigned long flags;
+
+	spin_lock_irqsave(&clocks_lock, flags);
+
+	list_for_each_entry(p, &clocks, node) {
+		if (strcmp(id, p->name) == 0 &&
+		    (p->ops && p->ops->can_get && p->ops->can_get(p, dev)) &&
+		    try_module_get(p->owner)) {
+			clk = p;
+			break;
+		}
+	}
+
+	list_for_each_entry(p, &clocks, node) {
+		if (strcmp(id, p->name) == 0 &&
+		    (!p->ops || !p->ops->can_get) &&
+		    try_module_get(p->owner)) {
+			clk = p;
+			break;
+		}
+	}
+
+	spin_unlock_irqrestore(&clocks_lock, flags);
+
+	return clk;
+}
+EXPORT_SYMBOL(clk_get);
+
+void clk_put(struct clk *clk)
+{
+	unsigned long flags;
+
+	if (!clk || IS_ERR(clk))
+		return;
+
+	spin_lock_irqsave(&clocks_lock, flags);
+
+	module_put(clk->owner);
+
+	spin_unlock_irqrestore(&clocks_lock, flags);
+}
+EXPORT_SYMBOL(clk_put);
+
+int clk_set_parent(struct clk *clk, struct clk *parent)
+{
+	int rc;
+	unsigned long flags;
+
+	if (!clk || IS_ERR(clk) || !clk->ops || !clk->ops->set_parent)
+		return -EINVAL;
+
+	spin_lock_irqsave(&clocks_lock, flags);
+
+	rc = clk->ops->set_parent(clk, parent);
+	if (!rc)
+		clk->parent = parent;
+
+	spin_unlock_irqrestore(&clocks_lock, flags);
+
+	return rc;
+}
+EXPORT_SYMBOL(clk_set_parent);
+
+struct clk *clk_get_parent(struct clk *clk)
+{
+	struct clk *parent;
+	unsigned long flags;
+
+	spin_lock_irqsave(&clocks_lock, flags);
+
+	parent = clk->parent;
+
+	spin_unlock_irqrestore(&clocks_lock, flags);
+
+	return parent;
+
+}
+
+static void __clk_disable(struct clk *clk)
+{
+	if (clk->users <= 0) {
+		WARN_ON(1);
+		return;
+	}
+
+	if (--clk->users == 0)
+		if (clk->ops && clk->ops->set_mode)
+			clk->ops->set_mode(clk, false);
+
+	if (clk->parent)
+		__clk_disable(clk->parent);
+}
+
+void clk_disable(struct clk *clk)
+{
+	unsigned long flags;
+
+	if (!clk || IS_ERR(clk))
+		return;
+
+	spin_lock_irqsave(&clocks_lock, flags);
+
+	__clk_disable(clk);
+
+	spin_unlock_irqrestore(&clocks_lock, flags);
+}
+EXPORT_SYMBOL(clk_disable);
+
+static int __clk_enable(struct clk *clk)
+{
+	int rc = 0;
+
+	if (clk->parent) {
+		rc = __clk_enable(clk->parent);
+
+		if (rc)
+			return rc;
+	}
+
+	if (clk->users++ != 0)
+		return 0;
+
+	if (clk->ops && clk->ops->set_mode) {
+		rc = clk->ops->set_mode(clk, true);
+		if (rc) {
+			if (clk->parent)
+				__clk_disable(clk->parent);
+
+			return rc;
+		}
+	}
+
+	return rc;
+}
+
+int clk_enable(struct clk *clk)
+{
+	unsigned long flags;
+	int rc;
+
+	if (!clk || IS_ERR(clk))
+		return -EINVAL;
+
+	spin_lock_irqsave(&clocks_lock, flags);
+
+	rc = __clk_enable(clk);
+
+	spin_unlock_irqrestore(&clocks_lock, flags);
+
+	return rc;
+}
+EXPORT_SYMBOL(clk_enable);
+
+static unsigned long __clk_get_rate(struct clk *clk)
+{
+	unsigned long rate = 0;
+
+	while (clk) {
+		if (clk->ops && clk->ops->get_rate) {
+			rate = clk->ops->get_rate(clk);
+			break;
+		} else
+			clk = clk->parent;
+	}
+
+	return rate;
+}
+
+unsigned long clk_get_rate(struct clk *clk)
+{
+	unsigned long rate = 0;
+	unsigned long flags;
+
+	if (!clk || IS_ERR(clk))
+		return -EINVAL;
+
+	spin_lock_irqsave(&clocks_lock, flags);
+
+	rate = __clk_get_rate(clk);
+
+	spin_unlock_irqrestore(&clocks_lock, flags);
+
+	return rate;
+}
+EXPORT_SYMBOL(clk_get_rate);
+
+long clk_round_rate(struct clk *clk, unsigned long rate)
+{
+	long res = 0;
+	unsigned long flags;
+	struct clk *pclk;
+
+	if (!clk || IS_ERR(clk))
+		return -EINVAL;
+
+	spin_lock_irqsave(&clocks_lock, flags);
+
+	for (pclk = clk; !res && pclk ; pclk = pclk->parent) {
+		if (pclk->ops && pclk->ops->round_rate)
+			res = pclk->ops->round_rate(clk, rate);
+	}
+
+	if (!res)
+		res = __clk_get_rate(clk);
+
+	spin_unlock_irqrestore(&clocks_lock, flags);
+
+	return res;
+}
+EXPORT_SYMBOL(clk_round_rate);
+
+int clk_set_rate(struct clk *clk, unsigned long rate)
+{
+	int rc = -EINVAL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&clocks_lock, flags);
+
+	while (clk && !IS_ERR(clk)) {
+		if (clk->ops && clk->ops->set_rate) {
+			rc = clk->ops->set_rate(clk, rate);
+			break;
+		}
+
+		clk = clk->parent;
+	}
+
+	spin_unlock_irqrestore(&clocks_lock, flags);
+
+	return rc;
+}
+EXPORT_SYMBOL(clk_set_rate);
+
+int clk_alloc_function(const char *parent, struct clk *clk)
+{
+	int rc = 0;
+	unsigned long flags;
+	struct clk *pclk;
+	bool found = false;
+
+	spin_lock_irqsave(&clocks_lock, flags);
+
+	list_for_each_entry(pclk, &clocks, node) {
+		if (strcmp(parent, pclk->name) == 0 &&
+		    try_module_get(pclk->owner)) {
+			found = true;
+			break;
+		}
+	}
+
+	if (!found) {
+		rc = -ENODEV;
+		goto out;
+	}
+
+	clk->parent = pclk;
+
+	__clk_register(clk);
+	/*
+	 * We locked parent owner during search
+	 * and also in __clk_register. Free one reference
+	 */
+	module_put(pclk->owner);
+
+out:
+	if (rc)
+		kfree(clk);
+
+	spin_unlock_irqrestore(&clocks_lock, flags);
+
+	return rc;
+}
+EXPORT_SYMBOL(clk_alloc_function);
-- 
1.5.4.4


-- 
With best wishes
Dmitry

