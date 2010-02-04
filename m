Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758441Ab0BDQoG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 11:44:06 -0500
Received: from casper.infradead.org ([85.118.1.10]:48936 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758367Ab0BDQoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 11:44:04 -0500
Subject: Re: [Patch 0/2] sysfs: fix s_active lockdep warning
From: Peter Zijlstra <peterz@infradead.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <gregkh@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, Cong Wang <amwang@redhat.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Miles Lane <miles.lane@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.44L0.1002041027070.2470-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1002041027070.2470-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Feb 2010 17:41:53 +0100
Message-ID: <1265301713.22001.128.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-04 at 11:35 -0500, Alan Stern wrote:
> Greg:
> 
> You have accepted Thomas's patch "drivers/base: Convert dev->sem to
> mutex".  It generates lockdep violations galore during device probing
> and removal!  Luckily lockdep is smart enough only to print the first
> occurrence.  Here's what I get early on during bootup:

<snip lockdep splat>

> On Thu, 4 Feb 2010, Peter Zijlstra wrote:
> 
> > The device tree had the problem that we could basically hold a device
> > lock and an unspecified number of parent locks (iirc this was due to
> > device probing, where we hold the bus lock while probing/adding child
> > device, recursively). 
> > 
> > If we place each dev->lock into the same class (which would naively
> > happen), then this would lead to recursive lock warnings. The proposed
> > solution for this is to create MAX_LOCK_DEPTH classes and assign them to
> > the dev->lock depending on the depth in the device tree (Alan said that
> > MAX_LOCK_DEPTH is sufficient for all practical cases).
> > 
> > static struct lock_class_key dev_tree_classes[MAX_LOCK_DEPTH];
> > 
> > device_add() or thereabouts would have something like:
> > 
> > #ifdef CONFIG_PROVE_LOCKING
> > 	BUG_ON(dev->depth >= MAX_LOCK_DEPTH);
> > 	lockdep_set_class(dev->lock, &dev_tree_classes[dev->depth]);
> > #endif
> 
> Unfortunately this doesn't really work.  Here is a patch implementing
> the scheme:
> 
> Index: usb-2.6/drivers/base/core.c
> ===================================================================
> --- usb-2.6.orig/drivers/base/core.c
> +++ usb-2.6/drivers/base/core.c
> @@ -22,6 +22,7 @@
>  #include <linux/kallsyms.h>
>  #include <linux/mutex.h>
>  #include <linux/async.h>
> +#include <linux/sched.h>
>  
>  #include "base.h"
>  #include "power/power.h"
> @@ -671,6 +672,26 @@ static void setup_parent(struct device *
>  		dev->kobj.parent = kobj;
>  }
>  
> +#ifdef CONFIG_PROVE_LOCKING
> +static struct lock_class_key dev_tree_classes[MAX_LOCK_DEPTH];
> +
> +static void setup_mutex_depth(struct device *dev, struct device *parent)
> +{
> +	int depth = 0;
> +
> +	/* Dynamically determine the device's depth in the device tree */
> +	while (parent) {
> +		++depth;
> +		parent = parent->parent;
> +	}
> +	BUG_ON(depth > MAX_LOCK_DEPTH);
> +	lockdep_set_class(&dev->mutex, &dev_tree_classes[depth]);
> +}
> +#else
> +static inline void setup_mutex_depth(struct device *dev,
> +		struct device *parent) {}
> +#endif
> +
>  static int device_add_class_symlinks(struct device *dev)
>  {
>  	int error;
> @@ -912,6 +933,7 @@ int device_add(struct device *dev)
>  
>  	parent = get_device(dev->parent);
>  	setup_parent(dev, parent);
> +	setup_mutex_depth(dev, parent);
>  
>  	/* use parent numa_node */
>  	if (parent)
> 
> 
> This doesn't address the fact that we really have multiple device trees
> (for example, class devices are handled separately from normal
> devices).  With the above patch installed, I still get lockdep
> violations farther on during boot:

<snip lockdep splat>

Hmm, so you have multiple interacting trees? I had understood you only
had a single device tree. So how many trees are there, is that fixed?
Does the device know what tree it is going to end up in?

If yes, then you can extend the setup_mutex_depth() function to pick a
different class stack for each tree.

