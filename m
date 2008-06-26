Return-Path: <linux-kernel-owner+w=401wt.eu-S1755598AbYFZPAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598AbYFZPAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 11:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbYFZPAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 11:00:31 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:14682 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbYFZPA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 11:00:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=q5pgAx2WFvqppn3qlcDRlJwFtJErG8dBrwUDYvAktd511bbGf50LwVPVuSx/Y25b+z
         rvozVV6Wf+nBXiTq+WEjxBZLXlxucjv0K0LRwkHtci/hCplocg3sI/QXazSLZd3TonoQ
         KsZXv7TZWy+R8u/yT/WTEkM2i6bOxld4D8Grg=
Message-ID: <74d0deb30806260800o48f2bf4ao2ccc498ab01ee087@mail.gmail.com>
Date: Thu, 26 Jun 2008 17:00:26 +0200
From: "pHilipp Zabel" <philipp.zabel@gmail.com>
To: "Dmitry Baryshkov" <dbaryshkov@gmail.com>
Subject: Re: [PATCH 1/3] Clocklib: add generic framework for managing clocks.
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>,
       "Russell King" <rmk+lkml@arm.linux.org.uk>,
       "Paul Mundt" <lethal@linux-sh.org>, "Pavel Machek" <pavel@ucw.cz>,
       tony@atomide.com, paul@pwsan.com,
       "David Brownell" <david-b@pacbell.net>,
       "Mark Brown" <broonie@opensource.wolfsonmicro.com>, ian <spyro@f2s.com>
In-Reply-To: <20080626125138.GA12415@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080626125033.GA7093@doriath.ww600.siemens.net>
	 <20080626125138.GA12415@doriath.ww600.siemens.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 2:51 PM, Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:
> Provide a generic framework that platform may choose
> to support clocks api. In particular this provides
> platform-independant struct clk definition, a full
> implementation of clocks api and a set of functions
> for registering and unregistering clocks in a safe way.
>
> Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
> ---
>  include/linux/clocklib.h |   58 ++++++++
>  lib/Kconfig              |    3 +
>  lib/Makefile             |    1 +
>  lib/clocklib.c           |  353 ++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 415 insertions(+), 0 deletions(-)
>  create mode 100644 include/linux/clocklib.h
>  create mode 100644 lib/clocklib.c
>
> diff --git a/include/linux/clocklib.h b/include/linux/clocklib.h
> new file mode 100644
> index 0000000..cf2b41e
> --- /dev/null
> +++ b/include/linux/clocklib.h
> @@ -0,0 +1,58 @@
> +/*
> + * Copyright (C) 2008 Dmitry Baryshkov
> + *
> + * This file is released under the GPL v2.
> + */
> +
> +#ifndef CLKLIB_H
> +#define CLKLIB_H
> +
> +#include <linux/spinlock.h>
> +#include <linux/kref.h>
> +
> +struct clk;
> +
> +/**
> + * struct clk_ops - generic clock management operations
> + * @can_get: checks whether passed device can get this clock
> + * @set_parent: reconfigures the clock to use specified parent
> + * @set_mode: enable or disable specified clock
> + * @get_rate: obtain the current clock rate of a specified clock
> + * @set_rate: set the clock rate for a specified clock
> + * @round_rate: adjust a reate to the exact rate a clock can provide
> + *
> + * This structure specifies clock operations that are used to configure
> + * specific clock.
> + */
> +struct clk_ops {
> +       int (*can_get)(struct clk *clk, struct device *dev);
> +       int (*set_parent)(struct clk *clk, struct clk *parent);
> +       int (*enable)(struct clk *clk);
> +       void (*disable)(struct clk *clk);
> +       unsigned long (*get_rate)(struct clk *clk);
> +       long (*round_rate)(struct clk *clk, unsigned long hz, bool apply);
> +};
> +
> +
> +struct clk {
> +       struct list_head node;
> +       spinlock_t *lock;
> +       struct kref ref;
> +       int usage;
> +#ifdef CONFIG_DEBUG_FS
> +       struct dentry *dir;
> +       struct dentry *info;
> +#endif
> +
> +       const char *name;
> +       struct clk *parent;
> +       struct clk_ops *ops;
> +       void (*release)(struct clk *clk);
> +};
> +
> +int clk_register(struct clk *clk);
> +void clk_unregister(struct clk *clk);
> +int clks_register(struct clk **clk, size_t num);
> +void clks_unregister(struct clk **clk, size_t num);
> +
> +#endif
> diff --git a/lib/Kconfig b/lib/Kconfig
> index 8cc8e87..592f5e1 100644
> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -13,6 +13,9 @@ config GENERIC_FIND_FIRST_BIT
>  config GENERIC_FIND_NEXT_BIT
>        def_bool n
>
> +config HAVE_CLOCKLIB
> +       tristate
> +
>  config CRC_CCITT
>        tristate "CRC-CCITT functions"
>        help
> diff --git a/lib/Makefile b/lib/Makefile
> index 74b0cfb..cee74e1 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -37,6 +37,7 @@ obj-$(CONFIG_PLIST) += plist.o
>  obj-$(CONFIG_DEBUG_PREEMPT) += smp_processor_id.o
>  obj-$(CONFIG_DEBUG_LIST) += list_debug.o
>  obj-$(CONFIG_DEBUG_OBJECTS) += debugobjects.o
> +obj-$(CONFIG_HAVE_CLOCKLIB) += clocklib.o
>
>  ifneq ($(CONFIG_HAVE_DEC_LOCK),y)
>   lib-y += dec_and_lock.o
> diff --git a/lib/clocklib.c b/lib/clocklib.c
> new file mode 100644
> index 0000000..590a665
> --- /dev/null
> +++ b/lib/clocklib.c
> @@ -0,0 +1,353 @@
> +/*
> + * Generic clocks API implementation
> + *
> + * Copyright (c) 2008 Dmitry Baryshkov
> + *
> + * This file is released under the GPL v2.
> + */
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/clk.h>
> +#include <linux/clocklib.h>
> +#include <linux/spinlock.h>
> +
> +static LIST_HEAD(clocks);
> +static DEFINE_SPINLOCK(clocks_lock);
> +
> +#ifdef CONFIG_DEBUG_FS
> +#include <linux/debugfs.h>
> +#include <linux/seq_file.h>
> +static struct dentry *clkdir;
> +
> +static int clocklib_show(struct seq_file *s, void *data)
> +{
> +       struct clk *clk = s->private;
> +
> +       BUG_ON(!clk);
> +
> +       seq_printf(s, "set_parent=%savailable\nusage=%d/%d\nrate=%10lu Hz\n",
> +                       clk->ops && clk->ops->set_parent ? "not " : "",
> +                       clk->usage, atomic_read(&clk->ref.refcount),
> +                       clk_get_rate(clk));
> +//     if (clk->ops && clk->ops->format)
> +//                     clk->ops->format(clk, s);

What about those?

> +
> +       return 0;
> +}
> +
> +static int clocklib_open(struct inode *inode, struct file *file)
> +{
> +       return single_open(file, clocklib_show, inode->i_private);
> +}
> +
> +static struct file_operations clocklib_operations = {
> +       .open           = clocklib_open,
> +       .read           = seq_read,
> +       .llseek         = seq_lseek,
> +       .release        = single_release,
> +};
> +
> +static int clk_debugfs_init(struct clk *clk)
> +{
> +       struct dentry *dir;
> +       struct dentry *info;
> +
> +       if (!clkdir)
> +               dump_stack();
> +
> +       dir = debugfs_create_dir(clk->name,
> +                       clk->parent ? clk->parent->dir : clkdir);
> +
> +       if (IS_ERR(dir))
> +               return PTR_ERR(dir);
> +
> +       info = debugfs_create_file("info", S_IFREG | S_IRUGO,
> +                       dir, clk, &clocklib_operations);
> +
> +       if (IS_ERR(info)) {
> +               debugfs_remove(dir);
> +               return PTR_ERR(info);
> +       }
> +
> +       clk->dir = dir;
> +       clk->info = info;
> +
> +       return 0;
> +}
> +
> +static void clk_debugfs_clean(struct clk *clk)
> +{
> +       if (clk->info)
> +               debugfs_remove(clk->info);
> +       clk->info = NULL;
> +
> +       if (clk->dir)
> +               debugfs_remove(clk->dir);
> +       clk->dir = NULL;
> +}
> +
> +static void clk_debugfs_reparent(struct clk *clk, struct clk *old, struct clk *new)
> +{
> +       struct dentry *oldd = old ? old->dir : clkdir;
> +       struct dentry *newd = new ? new->dir : clkdir;
> +       struct dentry *dir = debugfs_rename(oldd, clk->dir, newd, clk->name);
> +
> +       if (IS_ERR(dir))
> +               WARN_ON(1);
> +       else
> +               clk->dir = dir;
> +}
> +
> +static int __init clocklib_debugfs_init(void)
> +{
> +       clkdir = debugfs_create_dir("clocks", NULL);
> +       return 0;
> +}
> +core_initcall(clocklib_debugfs_init);
> +#else
> +#define clk_debugfs_init(clk) ({0;})
> +#define clk_debugfs_clean(clk) do {} while (0);
> +#define clk_debugfs_reparent(clk, old, new) do {} while (0);
> +#endif
> +
> +static int clk_can_get_def(struct clk *clk, struct device *dev)
> +{
> +       return 1;
> +}
> +
> +static unsigned long clk_get_rate_def(struct clk *clk)
> +{
> +       return 0;
> +}
> +
> +static long clk_round_rate_def(struct clk *clk, unsigned long hz, bool apply)
> +{
> +       long rate = clk->ops->get_rate(clk);
> +
> +       if (apply && hz != rate)
> +               return -EINVAL;
> +
> +       return rate;
> +}
> +
> +static void clk_release(struct kref *ref)
> +{
> +       struct clk *clk = container_of(ref, struct clk, ref);
> +
> +       BUG_ON(!clk->release);
> +
> +       if (clk->parent)
> +               kref_get(&clk->parent->ref);
> +
> +       clk->release(clk);
> +}
> +EXPORT_SYMBOL(clk_round_rate);
> +
> +struct clk* clk_get_parent(struct clk *clk)
> +{
> +       struct clk *parent;
> +
> +       spin_lock(clk->lock);
> +
> +       parent = clk->parent;
> +       kref_get(&parent->ref);
> +
> +       spin_unlock(clk->lock);
> +
> +       return parent;
> +}
> +EXPORT_SYMBOL(clk_get_parent);
> +
> +int clk_set_parent(struct clk *clk, struct clk *parent)
> +{
> +       int rc = -EINVAL;
> +       struct clk *old;
> +
> +       spin_lock(clk->lock);
> +
> +       if (!clk->ops->set_parent)
> +               goto out;
> +
> +       old = clk->parent;
> +
> +       rc = clk->ops->set_parent(clk, parent);
> +       if (rc)
> +               goto out;
> +
> +       kref_get(&parent->ref);
> +       clk->parent = parent;
> +
> +       clk_debugfs_reparent(clk, old, parent);
> +
> +       kref_put(&old->ref, clk_release);
> +
> +out:
> +       spin_unlock(clk->lock);
> +
> +       return rc;
> +}
> +EXPORT_SYMBOL(clk_set_parent);
> +
> +int clk_register(struct clk *clk)
> +{
> +       int rc;
> +
> +       BUG_ON(!clk->ops);
> +       BUG_ON(!clk->ops->enable || !clk->ops->disable);
> +
> +       if (!clk->ops->can_get)
> +               clk->ops->can_get = clk_can_get_def;
> +       if (!clk->ops->get_rate)
> +               clk->ops->get_rate = clk_get_rate_def;
> +       if (!clk->ops->round_rate)
> +               clk->ops->round_rate = clk_round_rate_def;
> +
> +       kref_init(&clk->ref);
> +
> +       spin_lock(&clocks_lock);
> +       if (clk->parent)
> +               kref_get(&clk->parent->ref);
> +       list_add_tail(&clk->node, &clocks);
> +
> +       rc = clk_debugfs_init(clk);
> +       if (rc) {
> +               list_del(&clk->node);
> +               kref_put(&clk->ref, clk_release);
> +       }
> +
> +       spin_unlock(&clocks_lock);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL(clk_register);
> +
> +void clk_unregister(struct clk *clk)
> +{
> +       spin_lock(&clocks_lock);
> +       clk_debugfs_clean(clk);
> +       list_del(&clk->node);
> +       kref_put(&clk->ref, clk_release);
> +       spin_unlock(&clocks_lock);
> +}
> +EXPORT_SYMBOL(clk_unregister);
> +
> +int clks_register(struct clk **clk, size_t num)
> +{
> +       int i;
> +       int rc;
> +       for (i = 0; i < num; i++) {
> +               rc = clk_register(clk[i]);
> +               if (rc)
> +                       return rc;
> +       }
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL(clks_register);
> +
> +void clks_unregister(struct clk **clk, size_t num)
> +{
> +       int i;
> +       for (i = 0; i < num; i++)
> +               clk_unregister(clk[i]);
> +}
> +EXPORT_SYMBOL(clks_unregister);
> +
> +struct clk *clk_get(struct device *dev, const char *id)
> +{
> +       struct clk *clk = NULL, *p;
> +
> +       spin_lock(&clocks_lock);
> +       list_for_each_entry(p, &clocks, node)
> +               if (strcmp(id, p->name) == 0 && p->ops->can_get(p, dev)) {
> +                       clk = p;
> +                       kref_get(&clk->ref);
> +                       break;
> +               }
> +
> +       spin_unlock(&clocks_lock);
> +
> +       return clk;
> +}
> +EXPORT_SYMBOL(clk_get);
> +
> +void clk_put(struct clk *clk)
> +{
> +       kref_put(&clk->ref, clk_release);
> +}
> +EXPORT_SYMBOL(clk_put);
> +
> +int clk_enable(struct clk *clk)
> +{
> +       int rc = 0;
> +
> +       spin_lock(clk->lock);
> +
> +       clk->usage++;
> +       if (clk->usage == 1)
> +               rc = clk->ops->enable(clk);
> +
> +       if (rc)
> +               clk->usage--;
> +
> +       spin_unlock(clk->lock);
> +
> +       return rc;
> +}
> +EXPORT_SYMBOL(clk_enable);
> +
> +void clk_disable(struct clk *clk)
> +{
> +       spin_lock(clk->lock);
> +
> +       WARN_ON(clk->usage <= 0);
> +
> +       clk->usage--;
> +       if (clk->usage == 0)
> +               clk->ops->disable(clk);
> +
> +       spin_unlock(clk->lock);
> +}
> +EXPORT_SYMBOL(clk_disable);
> +
> +unsigned long clk_get_rate(struct clk *clk)
> +{
> +       unsigned long hz;
> +
> +       spin_lock(clk->lock);
> +
> +       hz = clk->ops->get_rate(clk);
> +
> +       spin_unlock(clk->lock);
> +
> +       return hz;
> +}
> +EXPORT_SYMBOL(clk_get_rate);
> +
> +int clk_set_rate(struct clk *clk, unsigned long hz)
> +{
> +       long rc;
> +
> +       spin_lock(clk->lock);
> +
> +       rc = clk->ops->round_rate(clk, hz, 1);
> +
> +       spin_unlock(clk->lock);
> +
> +       return rc < 0 ? rc : 0;
> +}
> +EXPORT_SYMBOL(clk_set_rate);
> +
> +long clk_round_rate(struct clk *clk, unsigned long hz)
> +{
> +       long rc;
> +
> +       spin_lock(clk->lock);
> +
> +       rc = clk->ops->round_rate(clk, hz, 0);
> +
> +       spin_unlock(clk->lock);
> +
> +       return rc;
> +}
> +
> --
> 1.5.5.4
>
>
> --
> With best wishes
> Dmitry
>
>

regards
Philipp
