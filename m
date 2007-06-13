Return-Path: <linux-kernel-owner+w=401wt.eu-S1759991AbXFMTDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759991AbXFMTDx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 15:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbXFMTDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 15:03:43 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:4640 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbXFMTDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 15:03:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UUR5om6XaOhIMK0JU5nQ8JTYCH1T6CQBb2vpi1aAul8gEVkWRLknnBCsGf8NTy4bVnBn6PiB3FBToG/xYKVMfU8tPNdST7BFuzKatF0y6Ql4itvGgXXMX7vCdsCyL+n50cUDk744f8gPDsRSBD2KuQmv75QhXC/dZWKm0hYmVCg=
Message-ID: <a781481a0706131203g405a4407y1212bb397f14e8eb@mail.gmail.com>
Date: Thu, 14 Jun 2007 00:33:41 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Keiichi KII" <k-keiichi@bx.jp.nec.com>
Subject: Re: [RFC][PATCH -mm take5 4/7] using symlink for the net_device
Cc: "Matt Mackall" <mpm@selenic.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "David Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <a781481a0706130949j7b35e33ds9cda5d8a551c9d7d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <466FC455.5060001@bx.jp.nec.com> <466FC6ED.9060208@bx.jp.nec.com>
	 <a781481a0706130949j7b35e33ds9cda5d8a551c9d7d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again,

Ok, so sysfs_create_link() would be illegal from inside spin_lock_irqsave(),
and this is why we have to use the dual-list mechanism to react to the net
device rename. This isn't so obvious, a comment at the point where you
declare modify_target_list would be nice? (BTW temporary_list would be
a better name for that, IMO)

> On 6/13/07, Keiichi KII <k-keiichi@bx.jp.nec.com> wrote:
> > [...]
> > +static DECLARE_MUTEX(netdev_change_sem);
>
> The preferred style these days is to use a DEFINE_MUTEX
> (and the struct mutex primitives) for such locks that are used
> as binary semaphores.
>
> BTW, a comment here to note what this lock protects is required.
> [ You don't really need to give a comment for the target_list_lock
> because it's defined just below the "target_list". It's not equally obvious
> at first glance what is protected by the netdev_change_sem, however. ]

Ok, so reading through the code makes it obvious that this mutex is used
to protect against the following race:

Thread #1                               Thread #2
=========                               =========

[ NETDEV_CHANGENAME notifier ]          [ ioctl(NETCON_REMOVE_TARGET) ]

netconsole_event()
move from target_list to temp list
work on temp list
                                        kobject_unregister()
                                        -> release_target()
                                           -> remove_target()
move back to target_list

Which would mean a deleted/removed target added back => *boom*

But, the race still hasn't been closed properly!

You're taking the mutex only around "work on temp list" which is
insufficient, you need to ensure atomicity inside netconsole_event()
_completely_ like this (renaming netdev_change_sem to
netdev_changename_mtx):

> > +static int netconsole_event(struct notifier_block *this, unsigned long event,
> > +                           void *ptr)
> > +{
> > +       int error = 0;
> > +       unsigned long flags;
> > +       char *old_link_name = NULL, *new_link_name = NULL;
> > +       struct netconsole_target *nt, *tmp;
> > +       struct net_device *dev = ptr;
> > +       LIST_HEAD(modify_target_list);
> > +
> > +       if (event == NETDEV_CHANGENAME) {

mutex_lock(netdev_changename_mtx) here.

> > +               spin_lock_irqsave(&target_list_lock, flags);
> > +               list_for_each_entry_safe(nt, tmp, &target_list, list)
> > +                       if (nt->np.dev == dev)
> > +                               list_move(&nt->list, &modify_target_list);
> > +               spin_unlock_irqrestore(&target_list_lock, flags);

> > +               down(&netdev_change_sem);

This goes away.

> > +               list_for_each_entry(nt, &modify_target_list, list) {
> > + [...]
> > +               }

> > +               up(&netdev_change_sem);

So does this.

> > +               spin_lock_irqsave(&target_list_lock, flags);
> > +               list_for_each_entry_safe(nt, tmp, &modify_target_list, list)
> > +                       list_move(&nt->list, &target_list);
> > +               spin_unlock_irqrestore(&target_list_lock, flags);

mutex_unlock(netdev_changename_mtx) comes here.

> > +       }
> > +
> > +       return NOTIFY_DONE;
> > +}

> @@ -239,12 +240,14 @@ static void remove_target(struct netcons
>  {
>         unsigned long flags;
>
> +       down(&netdev_change_sem);
>         spin_lock_irqsave(&target_list_lock, flags);
>         list_del(&nt->list);
>         if (list_empty(&target_list))
>                 netpoll_cleanup(&nt->np);
>         spin_unlock_irqrestore(&target_list_lock, flags);
>         kfree(nt);
> +       up(&netdev_change_sem);
>  }

As I said earlier, the target_list_lock spin-locking needs to be
pushed out from here to the callers of remove_target.
=> mutex_lock(netdev_changename_mtx) must also be done
by them.

> +static char *make_netdev_class_name(char *netdev_name)
> +{
> +       char *name;
> +
> +       name = kasprintf(GFP_KERNEL, "net:%s", netdev_name);

Why the "net:" prefix in the filename?

> +       if (!name) {
> +               printk(KERN_ERR "netconsole: kmalloc() failed!\n");
> +               return NULL;
> +       }
> +
> +       return name;
> +}

And this doesn't want to be a separate function either.

>  static int setup_target_sysfs(struct netconsole_target *nt)
>  {
> +       int retval = 0;
> +       char *name;
> +
>         kobject_set_name(&nt->obj, "port%d", nt->id);
>         nt->obj.parent = &netconsole_miscdev.this_device->kobj;
>         nt->obj.ktype = &target_ktype;
> -       return kobject_register(&nt->obj);
> +       retval = kobject_register(&nt->obj);
> +       name = make_netdev_class_name(nt->np.dev_name);
> +       if (!name)
> +               return -ENOMEM;

Just call kasprintf() directly, why the obfuscation?

Satyam
