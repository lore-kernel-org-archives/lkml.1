Return-Path: <linux-kernel-owner+w=401wt.eu-S1756658AbYGMUyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658AbYGMUyV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 16:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755504AbYGMUxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 16:53:54 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:8512 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040AbYGMUxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 16:53:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=lUF3qxjN4LB2WMU24oOfYweoF+hqkykM79IkCFZB9IcC8IOhLY4XmOFXMwkcFzrrL7
         mc9vln8DSOhGLAu9+thpd7tMds0nPR78a75wM/leVML7en53LM4hyBquIjKC0r1vAadA
         rKUKhNvkvedBFU3yjUh9VCGwsIADp2et62x0A=
Message-ID: <bc64b4640807131353j32487b90o645d2040e26ff6f0@mail.gmail.com>
Date: Mon, 14 Jul 2008 00:53:51 +0400
From: Dmitry <dbaryshkov@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] genclk: add generic framework for managing clocks.
Cc: linux-kernel@vger.kernel.org,
       "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>,
       "Russell King" <rmk+lkml@arm.linux.org.uk>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "pHilipp Zabel" <philipp.zabel@gmail.com>,
       "Pavel Machek" <pavel@ucw.cz>, tony@atomide.com, paul@pwsan.com,
       "David Brownell" <david-b@pacbell.net>,
       "Mark Brown" <broonie@opensource.wolfsonmicro.com>, ian <spyro@f2s.com>
In-Reply-To: <20080712234823.e632c7f9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080708134242.GA6176@doriath.ww600.siemens.net>
	 <20080708134336.GA6240@doriath.ww600.siemens.net>
	 <20080712234823.e632c7f9.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/13, Andrew Morton <akpm@linux-foundation.org>:
> On Tue, 8 Jul 2008 17:43:36 +0400 Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:
>
>  > Provide a generic framework that platform may choose
>  > to support clocks api. In particular this provides
>  > platform-independant struct clk definition, a full
>  > implementation of clocks api and a set of functions
>  > for registering and unregistering clocks in a safe way.
>  >
>
>
> So I'll merge this into -mm and, unless there be suitably-serious
>  objections, into 2.6.27.
>
>  The other two patches got rejects all over the place - so many that I
>  didn't even attempt to fix them.  Perhaps you were developing againt
>  Linus's tree, which really is not a successful strategy late in the
>  -rc's.

Strange. They were developed against Russell's arm:devel. Please check
against that tree.

>
>  >
>  > ...
>
> >
>  > +struct clk_priv {
>  > +     struct list_head node;
>  > +#ifdef CONFIG_DEBUG_SPINLOCK
>  > +     struct lock_class_key lock_key;
>  > +#endif
>
>
> hm, what's this unusual-but-uncommented code doing in here?  Please
>  always comment unusual code.
>
>  There is already a zero-byte version of `struct lock_class_key' in
>  include/linux/lockdep.h, dependent upon CONFIG_LOCKDEP.
>
>  Methinks some explanation and fixing is needed here.

Fine, I'll drop that conditional compilation and always use struct
lock_class_key.
The whole thing is required to make lockdep work with clocklib.
Otherwise it thinks that all locks inside struct clk belong to the
same class and "detects" deadlock when code tries to lock a clock,
when already holding the lock for the other one.

>
>  >
>  > ...
>
> >
>  > +#include "genclk.h"
>  > +
>  > +LIST_HEAD(clocks);
>
>
> whoa.  We have a kernel-wide symbol called "locks"?
>
>  afaict that won't cause any linkage errors, but those compilation units
>  which already have static variables called "clocks" will explode if
>  they deliberately or accidentally include your header file.

The header file defining the "clocks" and clocks_lock is for private
use only, e.g. the debugfs code. I will change that to
genclk-namespace those.

>  I suggest that this be renamed to something more subsystem-specific.
>  genclk_clocks?
>
>  Or, better, refactor the code a bit and make it static.  Do other
>  compilation units _really_ need to go poking into genclk's internals?
>  Would it be better to always access this data structure via API calls?
>
>  > +DEFINE_SPINLOCK(clocks_lock);
>
>  genclk_clocks_lock.
>
>
>  > +static int clk_can_get_def(struct clk *clk, struct device *dev)
>  > +{
>  > +     return 1;
>  > +}
>  > +
>  > +static unsigned long clk_get_rate_def(struct clk *clk)
>  > +{
>  > +     return 0;
>  > +}
>  > +
>  > +static long clk_round_rate_def(struct clk *clk, unsigned long hz, bool apply)
>  > +{
>  > +     long rate = clk->ops->get_rate(clk);
>  > +
>  > +     if (apply && hz != rate)
>  > +             return -EINVAL;
>  > +
>  > +     return rate;
>  > +}
>  > +
>  > +static void clk_release(struct kref *ref)
>  > +{
>  > +     struct clk *clk = container_of(ref, struct clk, priv.ref);
>  > +
>  > +     BUG_ON(!clk->release);
>  > +
>  > +     if (clk->parent)
>  > +             kref_get(&clk->parent->priv.ref);
>  > +
>  > +     clk->release(clk);
>  > +}
>  > +EXPORT_SYMBOL(clk_round_rate);
>
>
> This export is in the wrong place.
>
>
>  > +struct clk* clk_get_parent(struct clk *clk)
>
>
> checkpatch.pl, please.
>
>
>  > +{
>  > +     struct clk *parent;
>  > +
>  > +     spin_lock(&clk->priv.lock);
>  > +
>  > +     parent = clk->parent;
>  > +     kref_get(&parent->priv.ref);
>  > +
>  > +     spin_unlock(&clk->priv.lock);
>  > +
>  > +     return parent;
>  > +}
>  > +EXPORT_SYMBOL(clk_get_parent);
>
>
> As this is a new kernel-wide utility library, it is appropriate that
>  all of its public interfaces (at least) be documented.  An appropriate
>  way of doing that is via kerneldoc annotation.  Please don't forget to
>  document return values and call environment prerequisites (eg: requires
>  foo_lock, may be called from interrupt context, etc, etc).
>
>
>  > +int clk_set_parent(struct clk *clk, struct clk *parent)
>  > +{
>  > +     int rc = -EINVAL;
>  > +     struct clk *old;
>  > +
>  > +     spin_lock(&clk->priv.lock);
>  > +
>  > +     if (!clk->ops->set_parent)
>  > +             goto out;
>  > +
>  > +     old = clk->parent;
>  > +
>  > +     rc = clk->ops->set_parent(clk, parent);
>  > +     if (rc)
>  > +             goto out;
>  > +
>  > +     kref_get(&parent->priv.ref);
>  > +     clk->parent = parent;
>  > +
>  > +     clk_debugfs_reparent(clk, old, parent);
>  > +
>  > +     kref_put(&old->priv.ref, clk_release);
>  > +
>  > +out:
>  > +     spin_unlock(&clk->priv.lock);
>  > +
>  > +     return rc;
>  > +}
>  > +EXPORT_SYMBOL(clk_set_parent);
>  > +
>  > +int clk_register(struct clk *clk)
>  > +{
>  > +     int rc;
>  > +
>  > +     BUG_ON(!clk->ops);
>  > +     BUG_ON(!clk->ops->enable || !clk->ops->disable);
>  > +
>  > +     if (!clk->ops->can_get)
>  > +             clk->ops->can_get = clk_can_get_def;
>  > +     if (!clk->ops->get_rate)
>  > +             clk->ops->get_rate = clk_get_rate_def;
>  > +     if (!clk->ops->round_rate)
>  > +             clk->ops->round_rate = clk_round_rate_def;
>  > +
>  > +     kref_init(&clk->priv.ref);
>  > +#ifdef CONFIG_DEBUG_SPINLOCK
>  > +     __spin_lock_init(&clk->priv.lock, "&clk->priv.lock", &clk->priv.lock_key);
>  > +#else
>  > +     spin_lock_init(&clk->priv.lock);
>  > +#endif
>
>
> Something's wrong here, I suspect.

See above. That was IMO the most clean way to make this code work with lockdep.

>  > +     spin_lock(&clocks_lock);
>  > +     if (clk->parent)
>  > +             kref_get(&clk->parent->priv.ref);
>  > +     list_add_tail(&clk->priv.node, &clocks);
>  > +
>  > +     rc = clk_debugfs_init(clk);
>  > +     if (rc) {
>  > +             list_del(&clk->priv.node);
>  > +             kref_put(&clk->priv.ref, clk_release);
>  > +     }
>  > +
>  > +     spin_unlock(&clocks_lock);
>  > +
>  > +     return 0;
>  > +}
>  > +EXPORT_SYMBOL(clk_register);
>  > +
>  > +void clk_unregister(struct clk *clk)
>  > +{
>  > +     spin_lock(&clocks_lock);
>  > +     clk_debugfs_clean(clk);
>
>
> can't call debugfs_remove() under spinlock.

Because of mutex usage? I'll move it outside of the lock.

>  > +     list_del(&clk->priv.node);
>  > +     kref_put(&clk->priv.ref, clk_release);
>
>
> Might not be able to call kref_put(), either.

I'll move it outside of the spinlock. But tell me please, why?

>
>
>  > +     spin_unlock(&clocks_lock);
>  > +}
>  > +EXPORT_SYMBOL(clk_unregister);
>
>
> Please always test code with all kernel debug options enabled.  See
>  Documentation/SubmitChecklist.

Usually I do build code with all debugs enabled...

>
>  >
>  > ...
>
> >
>  > +int clk_debugfs_init(struct clk *clk)
>  > +{
>  > +     struct dentry *dir;
>  > +     struct dentry *info;
>  > +
>  > +     /*
>  > +      * We initialise it here, because this call can be executed from within arch code,
>  > +      * so specifyint correct initialisation place is a bit tricky
>  > +      */
>  > +     if (!clkdir)
>  > +             clkdir = debugfs_create_dir("clocks", NULL);
>
>
> Missed a check for debugfs_create_dir() failure

>  > +     dir = debugfs_create_dir(clk->name,
>  > +                     clk->parent ? clk->parent->dir : clkdir);
>  > +
>  > +     if (IS_ERR(dir))
>  > +             return PTR_ERR(dir);
>  > +
>  > +     info = debugfs_create_file("info", S_IFREG | S_IRUGO,
>  > +                     dir, clk, &genclk_operations);
>  > +
>  > +     if (IS_ERR(info)) {
>  > +             debugfs_remove(dir);
>  > +             return PTR_ERR(info);
>  > +     }
>  > +
>  > +     clk->dir = dir;
>  > +     clk->priv.info = info;
>  > +
>  > +     return 0;
>  > +}
>  > +
>  >
>  > ...
>  >
>
> > +void clk_debugfs_reparent(struct clk *clk, struct clk *old, struct clk *new)
>  > +{
>  > +     struct dentry *oldd = old ? old->dir : clkdir;
>  > +     struct dentry *newd = new ? new->dir : clkdir;
>  > +     struct dentry *dir = debugfs_rename(oldd, clk->dir, newd, clk->name);
>  > +
>  > +     if (IS_ERR(dir))
>  > +             WARN_ON(1);
>  > +     else
>  > +             clk->dir = dir;
>  > +}
>
>
> Could do
>
>         if (!WARN_ON(IS_ERR(dir)))
>                 clk->dir = dir;
>
>  Or not.  What you have there is clearer.

I'll leave my version, as it's really more clean.

>
>  Quite a bit of rework is needed here and it needs to be fully retested.
>  I won't apply it after all.

The updated patch will be posted few hours later.


-- 
With best wishes
Dmitry
