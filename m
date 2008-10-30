Return-Path: <linux-kernel-owner+w=401wt.eu-S1755177AbYJ3Mf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbYJ3Mf0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 08:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753869AbYJ3MfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 08:35:13 -0400
Received: from mail-gx0-f30.google.com ([209.85.217.30]:58450 "EHLO
	mail-gx0-f30.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808AbYJ3MfL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 08:35:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=JfuAgHbF/YEWaJgWPHAX0c9P66zIrZJsrLrjtSC/5blaTBJn/JXuvNdhqsfSShx3ds
         +P/ATaV5BokV8GDYAZpU2WyfuV5/v7Ra9cOBGaltFLaJL7kztvMPoBzs5+LZpQe5m1Ll
         TorZSQ8d1FlL6Q/VPNT8YFcdzy+jAF9pj0RsU=
Message-ID: <b0438a630810300535m3d66c4d2se37d93cb1eeb0d31@mail.gmail.com>
Date: Thu, 30 Oct 2008 13:35:09 +0100
From: "=?ISO-8859-1?Q?Miguel_=C1ngel_=C1lvarez?=" <gotzoncabanes@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] ixp4xx: clock API
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

This is and implementation of clock API for IXP4XX based on PXA2XX.
(linux-2.6.27.4). I would appreciate comments on it.

Signed-off-by: Miguel Angel Alvarez <gotzoncabanes@gmail.com>
---
diff -uprN linux-2.6.27.4_orig/arch/arm/mach-ixp4xx/clock.c
linux-2.6.27.4/arch/arm/mach-ixp4xx/clock.c
--- linux-2.6.27.4_orig/arch/arm/mach-ixp4xx/clock.c    1970-01-01
01:00:00.000000000 +0100
+++ linux-2.6.27.4/arch/arm/mach-ixp4xx/clock.c    2008-10-30
12:17:01.000000000 +0100
@@ -0,0 +1,132 @@
+/*
+ *  linux/arch/arm/mach-sa1100/clock.c
+ */
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/string.h>
+#include <linux/clk.h>
+#include <linux/spinlock.h>
+#include <linux/platform_device.h>
+#include <linux/delay.h>
+
+#include <mach/hardware.h>
+
+#include <mach/clock.h>
+
+static LIST_HEAD(clocks);
+static DEFINE_MUTEX(clocks_mutex);
+static DEFINE_SPINLOCK(clocks_lock);
+
+static struct clk *clk_lookup(struct device *dev, const char *id)
+{
+    struct clk *p;
+
+    list_for_each_entry(p, &clocks, node)
+        if (strcmp(id, p->name) == 0 && p->dev == dev)
+            return p;
+
+    return NULL;
+}
+
+struct clk *clk_get(struct device *dev, const char *id)
+{
+    struct clk *p, *clk = ERR_PTR(-ENOENT);
+
+    mutex_lock(&clocks_mutex);
+    p = clk_lookup(dev, id);
+    if (!p)
+        p = clk_lookup(NULL, id);
+    if (p)
+        clk = p;
+    mutex_unlock(&clocks_mutex);
+
+    return clk;
+}
+EXPORT_SYMBOL(clk_get);
+
+void clk_put(struct clk *clk)
+{
+}
+EXPORT_SYMBOL(clk_put);
+
+int clk_enable(struct clk *clk)
+{
+    unsigned long flags;
+
+    spin_lock_irqsave(&clocks_lock, flags);
+    if (clk->enabled++ == 0)
+        clk->ops->enable(clk);
+    spin_unlock_irqrestore(&clocks_lock, flags);
+
+    if (clk->delay)
+        udelay(clk->delay);
+
+    return 0;
+}
+EXPORT_SYMBOL(clk_enable);
+
+void clk_disable(struct clk *clk)
+{
+    unsigned long flags;
+
+    WARN_ON(clk->enabled == 0);
+
+    spin_lock_irqsave(&clocks_lock, flags);
+    if (--clk->enabled == 0)
+        clk->ops->disable(clk);
+    spin_unlock_irqrestore(&clocks_lock, flags);
+}
+EXPORT_SYMBOL(clk_disable);
+
+unsigned long clk_get_rate(struct clk *clk)
+{
+    unsigned long rate;
+
+    rate = clk->rate;
+    if (clk->ops->getrate)
+        rate = clk->ops->getrate(clk);
+
+    return rate;
+}
+EXPORT_SYMBOL(clk_get_rate);
+
+void clk_void_enable(struct clk *clk)
+{
+}
+
+void clk_void_disable(struct clk *clk)
+{
+}
+
+const struct clkops clk_void_ops = {
+    .enable        = clk_void_enable,
+    .disable    = clk_void_disable,
+};
+
+static struct clk common_clks[] = {
+    {
+        .name        = "SSPCLK",
+        .ops        = &clk_void_ops,
+        .rate        = 3686400,
+    },
+};
+
+void clks_register(struct clk *clks, size_t num)
+{
+    int i;
+
+    mutex_lock(&clocks_mutex);
+    for (i = 0; i < num; i++)
+        list_add(&clks[i].node, &clocks);
+    mutex_unlock(&clocks_mutex);
+}
+
+static int __init clk_init(void)
+{
+    clks_register(common_clks, ARRAY_SIZE(common_clks));
+    return 0;
+}
+arch_initcall(clk_init);
diff -uprN linux-2.6.27.4_orig/arch/arm/mach-ixp4xx/include/mach/clock.h
linux-2.6.27.4/arch/arm/mach-ixp4xx/include/mach/clock.h
--- linux-2.6.27.4_orig/arch/arm/mach-ixp4xx/include/mach/clock.h
1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.27.4/arch/arm/mach-ixp4xx/include/mach/clock.h
2008-10-30 12:17:19.000000000 +0100
@@ -0,0 +1,44 @@
+struct clk;
+
+struct clkops {
+    void            (*enable)(struct clk *);
+    void            (*disable)(struct clk *);
+    unsigned long        (*getrate)(struct clk *);
+};
+
+struct clk {
+    struct list_head    node;
+    const char        *name;
+    struct device        *dev;
+    const struct clkops    *ops;
+    unsigned long        rate;
+    unsigned int        cken;
+    unsigned int        delay;
+    unsigned int        enabled;
+};
+
+#define INIT_CKEN(_name, _cken, _rate, _delay, _dev)    \
+    {                        \
+        .name    = _name,            \
+        .dev    = _dev,                \
+        .ops    = &clk_cken_ops,        \
+        .rate    = _rate,            \
+        .cken    = CKEN_##_cken,            \
+        .delay    = _delay,            \
+    }
+
+#define INIT_CK(_name, _cken, _ops, _dev)        \
+    {                        \
+        .name    = _name,            \
+        .dev    = _dev,                \
+        .ops    = _ops,                \
+        .cken    = CKEN_##_cken,            \
+    }
+
+extern const struct clkops clk_cken_ops;
+
+void clk_cken_enable(struct clk *clk);
+void clk_cken_disable(struct clk *clk);
+
+void clks_register(struct clk *clks, size_t num);
+
diff -uprN linux-2.6.27.4_orig/arch/arm/mach-ixp4xx/Makefile
linux-2.6.27.4/arch/arm/mach-ixp4xx/Makefile
--- linux-2.6.27.4_orig/arch/arm/mach-ixp4xx/Makefile    2008-10-30
12:01:27.000000000 +0100
+++ linux-2.6.27.4/arch/arm/mach-ixp4xx/Makefile    2008-10-30
12:17:46.000000000 +0100
@@ -17,7 +17,7 @@ obj-pci-$(CONFIG_MACH_GATEWAY7001)    += ga
 obj-pci-$(CONFIG_MACH_WG302V2)        += wg302v2-pci.o
 obj-pci-$(CONFIG_MACH_FSG)        += fsg-pci.o

-obj-y    += common.o
+obj-y    += common.o clock.o

 obj-$(CONFIG_ARCH_IXDP4XX)    += ixdp425-setup.o
 obj-$(CONFIG_MACH_AVILA)    += avila-setup.o

Miguel Ángel Álvarez
