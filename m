Return-Path: <linux-kernel-owner+w=401wt.eu-S1759414AbZF2Jxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759414AbZF2Jxx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 05:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbZF2Jxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 05:53:45 -0400
Received: from ey-out-1920.google.com ([74.125.78.147]:37624 "EHLO
	ey-out-1920.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759324AbZF2Jxn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 05:53:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=coXtaYt2eZ02pTU9fcULxQKRF/rN0x7VfUKgQNBGzfgxlIZMr6m/LCEc1JnmsEke3D
         7UtEUyR3N3SH3TFFvj8CIvsB1kDcBBmb+nrpvcI4L5CzqT/2naF+Qb8p+89wJU1cjTyN
         NQBHxdfl35OsD1ThtnE3l9v2ncOcgKetXOIQ4=
MIME-Version: 1.0
In-Reply-To: <m17hyw1s0h.fsf@fess.ebiederm.org>
References: <20090626143652.GB6281@localdomain.by>
	 <20090626144949.GA24173@suse.de>
	 <20090626232339.GD3858@localdomain.by>
	 <m18wjeqven.fsf@fess.ebiederm.org>
	 <20090627093932.GB3342@localdomain.by>
	 <1246147018.24693.97.camel@yio.site>
	 <m17hyw1s0h.fsf@fess.ebiederm.org>
Date: Mon, 29 Jun 2009 17:53:45 +0800
Message-ID: <a8e1da0906290253s378a11aehc74da47c608cb9dc@mail.gmail.com>
Subject: Re: [PATCH] kobject_set_name_vargs memory leak
From: Dave Young <hidave.darkstar@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       Sergey Senozhatsky <sergey.senozhatsky@mail.by>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 28, 2009 at 8:07 PM, Eric W. Biederman<ebiederm@xmission.com> wrote:
> Kay Sievers <kay.sievers@vrfy.org> writes:
>
>> On Sat, 2009-06-27 at 12:39 +0300, Sergey Senozhatsky wrote:
>>
>>> > >> Or something along those lines, I can't remember the exact reasoning
>>> > >> this early in the morning.
>>> > >>
>>> > >> Kay, do you remember?
>>
>> Hmm, yes, I think there was only something to work around during the
>> transition from the static name array, which is gone now. At least I
>> can't see anything we need to care about with the current code.
>>
>>> Sorry, correct one.
>>>
>>> diff --git a/lib/kobject.c b/lib/kobject.c
>>> index b512b74..3ab224b 100644
>>> --- a/lib/kobject.c
>>> +++ b/lib/kobject.c
>>> @@ -215,7 +215,6 @@ static int kobject_add_internal(struct kobject *kobj)
>>>  int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
>>>                                va_list vargs)
>>>  {
>>> -    const char *old_name = kobj->name;
>>
>> I guess, that would leak an allocated name, when it is set several times
>> in a row? Something like this?
>
> But setting a kobject's name several times in a row is a bug.  You
> need to call kobject_rename if you are going to change the name.

Agree

>
> So how about we fix the driver core not to do that.  Stop treating fmt
> as a flag, and make it clear kobject_add should not be passed a name.
>
> I really hate DWIM functions there is no maintaining them.

How about set name in kobject_init? or another kobject_init_with_name?

>
> Something like this patch:
>
>  block/blk-sysfs.c          |    6 ++++-
>  block/elevator.c           |    4 ++-
>  drivers/base/core.c        |   10 ++++++---
>  drivers/firmware/memmap.c  |    3 +-
>  drivers/md/md.c            |    5 +++-
>  drivers/net/iseries_veth.c |    4 +--
>  drivers/uio/uio.c          |    9 +++-----
>  include/linux/kobject.h    |    3 --
>  lib/kobject.c              |   46 ++++++++++++++-------------------------------
>  9 files changed, 43 insertions(+), 47 deletions(-)
>
> diff --git a/lib/kobject.c b/lib/kobject.c
> index b512b74..92da396 100644
> --- a/lib/kobject.c
> +++ b/lib/kobject.c
> @@ -215,11 +215,9 @@ static int kobject_add_internal(struct kobject *kobj)
>  int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
>                                  va_list vargs)
>  {
> -       const char *old_name = kobj->name;
>        char *s;
>
> -       if (kobj->name && !fmt)
> -               return 0;
> +       BUG_ON(kobj->name);
>
>        kobj->name = kvasprintf(GFP_KERNEL, fmt, vargs);
>        if (!kobj->name)
> @@ -229,7 +227,6 @@ int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
>        while ((s = strchr(kobj->name, '/')))
>                s[0] = '!';
>
> -       kfree(old_name);
>        return 0;
>  }
>
> @@ -296,20 +293,6 @@ error:
>  }
>  EXPORT_SYMBOL(kobject_init);
>
> -static int kobject_add_varg(struct kobject *kobj, struct kobject *parent,
> -                           const char *fmt, va_list vargs)
> -{
> -       int retval;
> -
> -       retval = kobject_set_name_vargs(kobj, fmt, vargs);
> -       if (retval) {
> -               printk(KERN_ERR "kobject: can not set name properly!\n");
> -               return retval;
> -       }
> -       kobj->parent = parent;
> -       return kobject_add_internal(kobj);
> -}
> -
>  /**
>  * kobject_add - the main kobject add function
>  * @kobj: the kobject to add
> @@ -335,15 +318,14 @@ static int kobject_add_varg(struct kobject *kobj, struct kobject *parent,
>  * kobject_uevent() with the UEVENT_ADD parameter to ensure that
>  * userspace is properly notified of this kobject's creation.
>  */
> -int kobject_add(struct kobject *kobj, struct kobject *parent,
> -               const char *fmt, ...)
> +int kobject_add(struct kobject *kobj, struct kobject *parent)
>  {
> -       va_list args;
> -       int retval;
> -
>        if (!kobj)
>                return -EINVAL;
>
> +       if (!kobj->name)
> +               return -EINVAL;
> +
>        if (!kobj->state_initialized) {
>                printk(KERN_ERR "kobject '%s' (%p): tried to add an "
>                       "uninitialized object, something is seriously wrong.\n",
> @@ -351,11 +333,8 @@ int kobject_add(struct kobject *kobj, struct kobject *parent,
>                dump_stack();
>                return -EINVAL;
>        }
> -       va_start(args, fmt);
> -       retval = kobject_add_varg(kobj, parent, fmt, args);
> -       va_end(args);
> -
> -       return retval;
> +       kobj->parent = parent;
> +       return kobject_add_internal(kobj);
>  }
>  EXPORT_SYMBOL(kobject_add);
>
> @@ -379,9 +358,12 @@ int kobject_init_and_add(struct kobject *kobj, struct kobj_type *ktype,
>        kobject_init(kobj, ktype);
>
>        va_start(args, fmt);
> -       retval = kobject_add_varg(kobj, parent, fmt, args);
> +       retval = kobject_set_name(kobj, fmt, args);
>        va_end(args);
>
> +       if (!retval)
> +               retval = kobject_add(kobj, parent);
> +
>        return retval;
>  }
>  EXPORT_SYMBOL_GPL(kobject_init_and_add);
> @@ -653,7 +635,9 @@ struct kobject *kobject_create_and_add(const char *name, struct kobject *parent)
>        if (!kobj)
>                return NULL;
>
> -       retval = kobject_add(kobj, parent, "%s", name);
> +       retval = kobject_set_name(kobj, "%s", name);
> +       if (!retval)
> +               retval = kobject_add(kobj, parent);
>        if (retval) {
>                printk(KERN_WARNING "%s: kobject_add error: %d\n",
>                       __func__, retval);
> @@ -798,7 +782,7 @@ static struct kset *kset_create(const char *name,
>        kset = kzalloc(sizeof(*kset), GFP_KERNEL);
>        if (!kset)
>                return NULL;
> -       retval = kobject_set_name(&kset->kobj, name);
> +       retval = kobject_set_name(&kset->kobj, "%s", name);
>        if (retval) {
>                kfree(kset);
>                return NULL;
> diff --git a/include/linux/kobject.h b/include/linux/kobject.h
> index 58ae8e0..de5f5d1 100644
> --- a/include/linux/kobject.h
> +++ b/include/linux/kobject.h
> @@ -83,8 +83,7 @@ static inline const char *kobject_name(const struct kobject *kobj)
>
>  extern void kobject_init(struct kobject *kobj, struct kobj_type *ktype);
>  extern int __must_check kobject_add(struct kobject *kobj,
> -                                   struct kobject *parent,
> -                                   const char *fmt, ...);
> +                                   struct kobject *parent);
>  extern int __must_check kobject_init_and_add(struct kobject *kobj,
>                                             struct kobj_type *ktype,
>                                             struct kobject *parent,
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index b1cd040..64f7270 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -433,7 +433,11 @@ int blk_register_queue(struct gendisk *disk)
>        if (ret)
>                return ret;
>
> -       ret = kobject_add(&q->kobj, kobject_get(&dev->kobj), "%s", "queue");
> +       ret = kobj_set_name(&q->kobj, "%s", "queue");
> +       if (ret < 0)
> +               return ret;
> +
> +       ret = kobject_add(&q->kobj, kobject_get(&dev->kobj));
>        if (ret < 0)
>                return ret;
>
> diff --git a/block/elevator.c b/block/elevator.c
> index ca86192..f26dca0 100644
> --- a/block/elevator.c
> +++ b/block/elevator.c
> @@ -903,7 +903,9 @@ int elv_register_queue(struct request_queue *q)
>        struct elevator_queue *e = q->elevator;
>        int error;
>
> -       error = kobject_add(&e->kobj, &q->kobj, "%s", "iosched");
> +       error = kobject_set_name(&e->kobj, "%s", "iosched");
> +       if (!error)
> +               error = kobject_add(&e->kobj, &q->kobj);
>        if (!error) {
>                struct elv_fs_entry *attr = e->elevator_type->elevator_attrs;
>                if (attr) {
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 7ecb193..f0cfa8a 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -625,7 +625,12 @@ static struct kobject *get_device_parent(struct device *dev,
>                if (!k)
>                        return NULL;
>                k->kset = &dev->class->p->class_dirs;
> -               retval = kobject_add(k, parent_kobj, "%s", dev->class->name);
> +               retval = kobject_set_name(k, "%s", dev->class->name);
> +               if (retval < 0) {
> +                       kobject_put(k);
> +                       return NULL;
> +               }
> +               retval = kobject_add(k, parent_kobj);
>                if (retval < 0) {
>                        kobject_put(k);
>                        return NULL;
> @@ -900,8 +905,7 @@ int device_add(struct device *dev)
>                set_dev_node(dev, dev_to_node(parent));
>
>        /* first, register with generic layer. */
> -       /* we require the name to be set before, and pass NULL */
> -       error = kobject_add(&dev->kobj, dev->kobj.parent, NULL);
> +       error = kobject_add(&dev->kobj, dev->kobj.parent);
>        if (error)
>                goto Error;
>
> diff --git a/drivers/firmware/memmap.c b/drivers/firmware/memmap.c
> index d5ea8a6..161a165 100644
> --- a/drivers/firmware/memmap.c
> +++ b/drivers/firmware/memmap.c
> @@ -224,7 +224,8 @@ static int __init memmap_init(void)
>
>        list_for_each_entry(entry, &map_entries, list) {
>                entry->kobj.kset = memmap_kset;
> -               if (kobject_add(&entry->kobj, NULL, "%d", i++))
> +               if (kobject_set_name(&entry->kobj, "%d", i++) ||
> +                   kobject_add(&entry->kobj, NULL))
>                        kobject_put(&entry->kobj);
>        }
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 09be637..2f9fa72 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1575,7 +1575,10 @@ static int bind_rdev_to_array(mdk_rdev_t * rdev, mddev_t * mddev)
>        rdev->mddev = mddev;
>        printk(KERN_INFO "md: bind<%s>\n", b);
>
> -       if ((err = kobject_add(&rdev->kobj, &mddev->kobj, "dev-%s", b)))
> +       if ((err = kobject_set_name(&rdev->kobj, "dev-%s", b)))
> +               goto fail;
> +
> +       if ((err = kobject_add(&rdev->kobj, &mddev->kobj)))
>                goto fail;
>
>        ko = &part_to_dev(rdev->bdev->bd_part)->kobj;
> diff --git a/drivers/net/iseries_veth.c b/drivers/net/iseries_veth.c
> index e44215c..a024c24 100644
> --- a/drivers/net/iseries_veth.c
> +++ b/drivers/net/iseries_veth.c
> @@ -1089,8 +1089,8 @@ static struct net_device *veth_probe_one(int vlan,
>                return NULL;
>        }
>
> -       kobject_init(&port->kobject, &veth_port_ktype);
> -       if (0 != kobject_add(&port->kobject, &dev->dev.kobj, "veth_port"))
> +       if (kobject_init_and_add(&port->kobject, &veth_port_ktype,
> +                                &dev->dev.kobj, "%s", "veth_port")
>                veth_error("Failed adding port for %s to sysfs.\n", dev->name);
>
>        veth_info("%s attached to iSeries vlan %d (LPAR map = 0x%.4X)\n",
> diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
> index 03efb06..7c53bb9 100644
> --- a/drivers/uio/uio.c
> +++ b/drivers/uio/uio.c
> @@ -303,10 +303,10 @@ static int uio_dev_add_attributes(struct uio_device *idev)
>                map = kzalloc(sizeof(*map), GFP_KERNEL);
>                if (!map)
>                        goto err_map;
> -               kobject_init(&map->kobj, &map_attr_type);
>                map->mem = mem;
>                mem->map = map;
> -               ret = kobject_add(&map->kobj, idev->map_dir, "map%d", mi);
> +               ret = kobject_init_and_add(&map->kobj, &map_attr_type,
> +                                          idev->map_dir, "map%d", mi);
>                if (ret)
>                        goto err_map;
>                ret = kobject_uevent(&map->kobj, KOBJ_ADD);
> @@ -328,11 +328,10 @@ static int uio_dev_add_attributes(struct uio_device *idev)
>                portio = kzalloc(sizeof(*portio), GFP_KERNEL);
>                if (!portio)
>                        goto err_portio;
> -               kobject_init(&portio->kobj, &portio_attr_type);
>                portio->port = port;
>                port->portio = portio;
> -               ret = kobject_add(&portio->kobj, idev->portio_dir,
> -                                                       "port%d", pi);
> +               ret = kobject_init_and_add(&portio->kobj, &portio_attr_type,
> +                                          idev->portio_dir, "port%d", pi);
>                if (ret)
>                        goto err_portio;
>                ret = kobject_uevent(&portio->kobj, KOBJ_ADD);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Regards
dave
