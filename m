Return-Path: <linux-kernel-owner+w=401wt.eu-S2992765AbXDRPXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992765AbXDRPXw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 11:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992766AbXDRPXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 11:23:52 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:14416 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992765AbXDRPXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 11:23:51 -0400
Date: Wed, 18 Apr 2007 17:26:26 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Tejun Heo <htejun@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       Greg K-H <greg@kroah.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
Message-ID: <20070418172626.198b96c2@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <Pine.LNX.4.44L0.0704181032060.12246-100000@iolanthe.rowland.org>
References: <20070417184110.GJ10619@htj.dyndns.org>
	<Pine.LNX.4.44L0.0704181032060.12246-100000@iolanthe.rowland.org>
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

On Wed, 18 Apr 2007 10:53:55 -0400 (EDT),
Alan Stern <stern@rowland.harvard.edu> wrote:

> Many drivers, especially those for hot-pluggable buses, register and
> unregister devices dynamically.  These events can occur in time-critical
> situations, where the driver cannot afford to wait for all the references
> to be dropped when unregistering a device.  It's okay to wait in a module
> exit routine, but to make things work the routine would have to wait for
> references to _all_ unregistered objects to go away, not just the
> references for the objects it unregisters at exit time.

Uh, yes, didn't think of that. I'd even say that's the majority of
devices allocated in a driver.

> BTW, Cornelia, there's a small problem with your patch set.  You have
> kobject_init() try to grab a reference to kobj->owner, but it's quite
> possible for kobj->owner to contain uninitialized garbage since the rest
> of the kernel is still unaware of its existence.  There's a patch below to
> fix things up.  I've got a second patch which makes device_initialize()  
> pass an owner to the embedded kobject, but I want to try it out a little
> before posting it.  :-)

I was relying on the object being zeroed after allocation (and the
caller of kobject_initialize already setting ->owner), but passing an
owner via the initializing routine sounds saner. Thanks for looking at
that.


> Index: usb-2.6/include/linux/kobject.h
> ===================================================================
> --- usb-2.6.orig/include/linux/kobject.h
> +++ usb-2.6/include/linux/kobject.h
> @@ -71,7 +71,8 @@ static inline const char * kobject_name(
>  	return kobj->k_name;
>  }
> 
> -extern void kobject_init(struct kobject *);
> +extern void kobject_init_owner(struct kobject *, struct module *owner);
> +#define kobject_init(kobj)	kobject_init_owner(kobj, THIS_MODULE)
>  extern void kobject_cleanup(struct kobject *);
> 
>  extern int __must_check kobject_add(struct kobject *);
> @@ -84,7 +85,9 @@ extern int __must_check kobject_shadow_r
>  						const char *new_name);
>  extern int __must_check kobject_move(struct kobject *, struct kobject *);
> 
> -extern int __must_check kobject_register(struct kobject *);
> +extern int __must_check kobject_register_owner(struct kobject *,
> +		struct module *owner);
> +#define kobject_register(kobj)	kobject_register_owner(kobj, THIS_MODULE)
>  extern void kobject_unregister(struct kobject *);
> 
>  extern struct kobject * kobject_get(struct kobject *);
> Index: usb-2.6/lib/kobject.c
> ===================================================================
> --- usb-2.6.orig/lib/kobject.c
> +++ usb-2.6/lib/kobject.c
> @@ -164,10 +164,11 @@ static void verify_dynamic_kobject_alloc
>  #endif
> 
>  /**
> - *	kobject_init - initialize object.
> + *	kobject_init_onwer - initialize object.
>   *	@kobj:	object in question.
> + *	@owner: module owning @kobj.
>   */
> -void kobject_init(struct kobject * kobj)
> +void kobject_init_owner(struct kobject * kobj, struct module *owner)
>  {
>  	if (!kobj)
>  		return;
> @@ -178,6 +179,7 @@ void kobject_init(struct kobject * kobj)
>  	init_waitqueue_head(&kobj->poll);
>  	kobj->kset = kset_get(kobj->kset);
>  	/* Attempt to grab reference of owning module's kobject. */
> +	kobj->owner = owner;
>  	mod_kobject_get(kobj->owner);
>  }
> 
> @@ -272,15 +274,16 @@ int kobject_add(struct kobject * kobj)
> 
> 
>  /**
> - *	kobject_register - initialize and add an object.
> + *	kobject_register_owner - initialize and add an object.
>   *	@kobj:	object in question.
> + *	@owner:	module owning @kobj.
>   */
> 
> -int kobject_register(struct kobject * kobj)
> +int kobject_register_owner(struct kobject * kobj, struct module *owner)
>  {
>  	int error = -EINVAL;
>  	if (kobj) {
> -		kobject_init(kobj);
> +		kobject_init_owner(kobj, owner);
>  		error = kobject_add(kobj);
>  		if (!error)
>  			kobject_uevent(kobj, KOBJ_ADD);
> @@ -750,8 +753,8 @@ void subsys_remove_file(struct subsystem
>  }
>  #endif  /*  0  */
> 
> -EXPORT_SYMBOL(kobject_init);
> -EXPORT_SYMBOL(kobject_register);
> +EXPORT_SYMBOL(kobject_init_owner);
> +EXPORT_SYMBOL(kobject_register_owner);
>  EXPORT_SYMBOL(kobject_unregister);
>  EXPORT_SYMBOL(kobject_get);
>  EXPORT_SYMBOL(kobject_put);
> 

Hm, this means we always have an owner (until we explicitely call
kobject_{init,register}_owner(kobj, NULL)) - which may be unneeded in
some cases. But better to err on the safe side, I suppose.
