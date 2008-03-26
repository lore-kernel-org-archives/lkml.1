Return-Path: <linux-kernel-owner+w=401wt.eu-S1757407AbYCZPwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407AbYCZPwX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 11:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbYCZPwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 11:52:15 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:56593 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbYCZPwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 11:52:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=WO6QmvK6Oi+Cg9CZrpYnFOPsak+cQvkpeemsEStNzzMejy7/ixIVy4rT/uJe496ljono32SxSrqT28oAG+WKV228+KYY/Suv9HONwJ79LNSpFgaOMJrZ1j4h+6A6qqtxAPTDhZ64QUXtlI/YGGiV8BXftyNT3n28Uas95P5goas=
Date: Wed, 26 Mar 2008 18:52:03 +0300
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, hskinnemoen@atmel.com, domen.puncer@telargo.com,
       lethal@linux-sh.org, tony@atomide.com, rmk+kernel@arm.linux.org.uk,
       paul@pwsan.com
Subject: [PATCH 1/3] Clocklib: add generic framework for managing clocks.
Message-ID: <20080326155203.GA15405@doriath.ww600.siemens.net>
References: <20080326154913.GA15326@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080326154913.GA15326@doriath.ww600.siemens.net>
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
 include/linux/clklib.h |  120 ++++++++++++++++++
 init/Kconfig           |    7 +
 kernel/Makefile        |    1 +
 kernel/clklib.c        |  315 ++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 443 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/clklib.h
 create mode 100644 kernel/clklib.c

diff --git a/include/linux/clklib.h b/include/linux/clklib.h
new file mode 100644
index 0000000..92f0a45
--- /dev/null
+++ b/include/linux/clklib.h
@@ -0,0 +1,120 @@
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
+struct clk {
+	struct list_head node;
+	struct clk	*parent;
+
+	const char	*name;
+	struct module	*owner;
+
+	int		users;
+	unsigned long	rate;
+	int		delay;
+
+	int (*can_get)	(struct clk *, struct device *);
+	int (*set_parent) (struct clk *, struct clk *);
+	int (*enable)	(struct clk *);
+	void (*disable)	(struct clk *);
+	unsigned long (*getrate) (struct clk*);
+	int (*setrate)	(struct clk *, unsigned long);
+	long (*roundrate) (struct clk *, unsigned long);
+
+	void		*priv;
+};
+
+int __must_check clk_register(struct clk *clk);
+void clk_unregister(struct clk *clk);
+static void __maybe_unused clks_unregister(struct clk *clks, size_t num)
+{
+	int i;
+	for (i = num - 1; i >= 0;  i++) {
+		clk_unregister(&clks[i]);
+	}
+}
+
+static int __must_check __maybe_unused clks_register(struct clk *clks, size_t num)
+{
+	int i;
+	int ret;
+	for (i = 0; i < num; i++) {
+		ret = clk_register(&clks[i]);
+		if (ret != 0)
+			goto cleanup;
+	}
+
+	return 0;
+
+cleanup:
+	clks_unregister(clks, i);
+
+	for (i -- ; i >= 0; i--) {
+		clk_unregister(&clks[i]);
+	}
+
+	return ret;
+}
+
+int __must_check clk_alloc_function(const char *parent, struct clk *clk);
+
+struct clk_function {
+	const char *parent;
+	struct clk *clk;
+};
+
+#define CLK_FUNC(_clock, _function, _can_get, _data, _format) \
+	{						\
+		.parent = _clock,			\
+		.clk = &(struct clk) {			\
+			.name= _function,		\
+			.owner = THIS_MODULE,		\
+			.can_get = _can_get,		\
+			.priv = _data,			\
+			.format = _format,		\
+		},					\
+	}
+
+static void __maybe_unused clk_free_functions(
+		struct clk_function *funcs,
+		int num)
+{
+	int i;
+
+	for (i = num - 1; i >= 0; i--) {
+		clk_unregister(funcs[i].clk);
+	}
+}
+
+static int __must_check __maybe_unused clk_alloc_functions(
+		struct clk_function *funcs,
+		int num)
+{
+	int i;
+	int rc;
+
+	for (i = 0; i < num; i++) {
+		rc = clk_alloc_function(funcs[i].parent, funcs[i].clk);
+
+		if (rc) {
+			printk(KERN_ERR "Error allocating %s.%s function.\n",
+					funcs[i].parent,
+					funcs[i].clk->name);
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
index 0000000..b41e7c2
--- /dev/null
+++ b/kernel/clklib.c
@@ -0,0 +1,315 @@
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
+		    (p->can_get && p->can_get(p, dev)) &&
+		    try_module_get(p->owner)) {
+			clk = p;
+			break;
+		}
+	}
+
+	list_for_each_entry(p, &clocks, node) {
+		if (strcmp(id, p->name) == 0 &&
+		    !p->can_get &&
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
+	if (!clk || IS_ERR(clk))
+		return -EINVAL;
+
+	if (!clk->set_parent)
+		return -EINVAL;
+
+	spin_lock_irqsave(&clocks_lock, flags);
+
+	rc = clk->set_parent(clk, parent);
+	if (!rc)
+		clk->parent = parent;
+
+	spin_unlock_irqrestore(&clocks_lock, flags);
+
+	return rc;
+}
+EXPORT_SYMBOL(clk_set_parent);
+
+static void __clk_disable(struct clk *clk)
+{
+	if (clk->users <= 0) {
+		WARN_ON(1);
+		return;
+	}
+
+	if (--clk->users == 0)
+		if (clk->disable)
+			clk->disable(clk);
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
+	if (clk->users++ != 0) {
+		return 0;
+	}
+
+	if (clk->enable) {
+		rc = clk->enable(clk);
+		if (rc) {
+			if (clk->parent)
+				__clk_disable(clk->parent);
+
+			return rc;
+		}
+	}
+
+	if (clk->delay)
+		udelay(clk->delay);
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
+	for (;;) {
+		if (rate || !clk)
+			return rate;
+
+		if (clk->getrate)
+			rate = clk->getrate(clk);
+		else if (clk->rate)
+			rate = clk->rate;
+		else
+			clk = clk->parent;
+	}
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
+	long res;
+	unsigned long flags;
+
+	if (!clk || IS_ERR(clk))
+		return -EINVAL;
+
+	spin_lock_irqsave(&clocks_lock, flags);
+
+	if (clk->roundrate)
+		res = clk->roundrate(clk, rate);
+	else
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
+		if (clk->setrate) {
+			rc = clk->setrate(clk, rate);
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
+	if (rc) {
+		kfree(clk);
+	}
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

