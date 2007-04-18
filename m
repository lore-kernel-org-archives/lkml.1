Return-Path: <linux-kernel-owner+w=401wt.eu-S932966AbXDRIEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932966AbXDRIEi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 04:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932997AbXDRIEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 04:04:38 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:42598 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932966AbXDRIEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 04:04:35 -0400
Date: Wed, 18 Apr 2007 10:07:09 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg K-H <greg@kroah.com>,
       Rusty Russell <rusty@rustcorp.com.au>, dmitry.torokhov@gmail.com
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
Message-ID: <20070418100709.3c710e00@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070417184110.GJ10619@htj.dyndns.org>
References: <20070416193619.4659a847@gondolin.boeblingen.de.ibm.com>
	<20070417184110.GJ10619@htj.dyndns.org>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Apr 2007 03:41:10 +0900,
Tejun Heo <htejun@gmail.com> wrote:

> Hello, all.
> 
> Agreed with the problem but I'm not very enthusiastic for adding
> kobj->owner.  How about the following?  exit() routines will have to
> do device_unregister_wait() instead of device_unregister().  On return
> from it, it's guaranteed that all references to it are dropped and
> ->release is finished.

Sounds interesting. Kind of like the completion approach, but with the
dangerous bits outside the module.

> The caller is responsible for avoiding
> deadlock, of course.

I think that wording is a bit too strong. Of course, if the device is
unregistered in the exit routine, the module must make sure it gave up
all references it itself obtained. However, it doesn't have any control
about who obtained a reference during the object's lifetime. If an
outsider holds on to a reference, we'll lock up until this reference
has been given up (but I guess this is what we want).

> 
> The code is only compile-tested and is more of proof-of-concept than
> working code.
> 
> DO NOT APPLY.

<snip>

> diff --git a/lib/kobject.c b/lib/kobject.c
> index 057921c..22e5148 100644
> --- a/lib/kobject.c
> +++ b/lib/kobject.c
> @@ -16,6 +16,15 @@
>  #include <linux/stat.h>
>  #include <linux/slab.h>
> 
> +struct kobj_wait {
> +	struct list_head	list;
> +	struct kobject		*kobj;
> +	struct completion	cmpl;
> +};
> +
> +static spinlock_t kobj_wait_lock = SPIN_LOCK_UNLOCKED;
> +static LIST_HEAD(kobj_wait_list);
> +
>  /**
>   *	populate_dir - populate directory with attributes.
>   *	@kobj:	object we're working on.
> @@ -425,6 +434,23 @@ void kobject_unregister(struct kobject * kobj)
>  }
> 
>  /**
> + *	kobject_unregister_wait - unregister, put and wait
> + *	@kobj:	object going away
> + *
> + *	Remove @kobj from hierarchy, decrement refcount and wait for
> + *	it to die.
> + */
> +void kobject_unregister_wait(struct kobject * kobj)
> +{
> +	if (!kobj)
> +		return;
> +	pr_debug("kobject %s: unregistering\n",kobject_name(kobj));
> +	kobject_uevent(kobj, KOBJ_REMOVE);
> +	kobject_del(kobj);
> +	kobject_put_wait(kobj);
> +}
> +
> +/**
>   *	kobject_get - increment refcount for object.
>   *	@kobj:	object.
>   */
> @@ -446,8 +472,22 @@ void kobject_cleanup(struct kobject * kobj)
>  	struct kobj_type * t = get_ktype(kobj);
>  	struct kset * s = kobj->kset;
>  	struct kobject * parent = kobj->parent;
> +	struct kobj_wait *kwait;
> +	unsigned long flags;
> 
>  	pr_debug("kobject %s: cleaning up\n",kobject_name(kobj));
> +
> +	/* is somebody waiting for @kobj to die? */
> +	spin_lock_irqsave(&kobj_wait_lock, flags);
> +	list_for_each_entry(kwait, &kobj_wait_list, list) {
> +		if (kwait->kobj == kobj) {
> +			list_del_init(&kwait->list);
> +			break;
> +		}
> +	}
> +	spin_unlock_irqrestore(&kobj_wait_lock, flags);
> +
> +	/* clean up */
>  	if (kobj->k_name != kobj->name)
>  		kfree(kobj->k_name);
>  	kobj->k_name = NULL;
> @@ -456,6 +496,10 @@ void kobject_cleanup(struct kobject * kobj)
>  	if (s)
>  		kset_put(s);
>  	kobject_put(parent);
> +
> +	/* notify waiter */
> +	if (kwait)
> +		complete(&kwait->cmpl);
>  }
> 
>  static void kobject_release(struct kref *kref)
> @@ -475,6 +519,42 @@ void kobject_put(struct kobject * kobj)
>  		kref_put(&kobj->kref, kobject_release);
>  }
> 
> +/**
> + *	kobject_put_wait - put and wait for all references to go away
> + *	@kobj:	object
> + *
> + *	This function is used by @kobj owner to kill it - it puts a
> + *	reference to @kobj and waits till all the references are gone
> + *	and ->release is finished.  @kobj must have been deleted and
> + *	the caller is responsible for guaranteeing that all references
> + *	will be dropped in foreseeable future.
> + */
> +void kobject_put_wait(struct kobject * kobj)
> +{
> +	struct kobj_wait kwait;
> +	unsigned long flags;
> +
> +	if (!kobj)
> +		return;
> +
> +	BUG_ON(!list_empty(&kobj->entry));
> +
> +	init_completion(&kwait.cmpl);
> +	kwait.kobj = kobj;
> +
> +	spin_lock_irqsave(&kobj_wait_lock, flags);
> +	list_add(&kwait.list, &kobj_wait_list);
> +	spin_unlock_irqrestore(&kobj_wait_lock, flags);
> +
> +	kobject_put(kobj);
> +
> +	if (!wait_for_completion_timeout(&kwait.cmpl, 30 * HZ)) {
> +		printk(KERN_WARNING "kobject_put_wait: kobject %p is still "
> +		       "alive after 30s, possible reference count bug\n", kobj);
> +		dump_stack();
> +		wait_for_completion(&kwait.cmpl);
> +	}
> +}
> 

Couldn't this waiting be made simpler?
- add completion to kobject in kobject_unregister_wait()
- call kobject_put(), then wait_for_completion()
- in kobject_cleanup(), save completion from kobject, call release
function, then complete() on saved completion

I'll toy with this a bit.
