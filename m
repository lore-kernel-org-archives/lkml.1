Return-Path: <linux-kernel-owner+w=401wt.eu-S1757608AbYAYJKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757608AbYAYJKH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 04:10:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751582AbYAYJJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 04:09:46 -0500
Received: from wx-out-0506.google.com ([66.249.82.224]:31816 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbYAYJJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 04:09:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iELsAck+ZATujj1FYZ5Rf7J0I+jHIqGP4EbKY/FNUUpmy7igw9I27Yae/wuZg+pallj/fOlgAfO+OMea4jBG0mAcIarobYADz/2si1dMaCiYuofxQIDmPnjjr5NDFL6KxH88qQRxvp6kkSckzLVRxjL/t1/ttbI6l9DdmtQc+Hg=
Message-ID: <a8e1da0801250109u69e75a5p9cd5815451a8a196@mail.gmail.com>
Date: Fri, 25 Jan 2008 17:09:41 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Subject: Re: [PATCH 044/196] kset: add kset_create_and_add function
Cc: linux-kernel@vger.kernel.org, "Kay Sievers" <kay.sievers@vrfy.org>,
       "Miklos Szeredi" <miklos@szeredi.hu>
In-Reply-To: <1201245134-4876-44-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080125071127.GA4860@kroah.com>
	 <1201245134-4876-44-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 25, 2008 3:09 PM, Greg Kroah-Hartman <gregkh@suse.de> wrote:
> Now ksets can be dynamically created on the fly, no static definitions
> are required.  Thanks to Miklos for hints on how to make this work
> better for the callers.
>
> And thanks to Kay for finding some stupid bugs in my original version
> and pointing out that we need to handle the fact that kobject's can have
> a kset as a parent and to handle that properly in kobject_add().
>
> Cc: Kay Sievers <kay.sievers@vrfy.org>
> Cc: Miklos Szeredi <miklos@szeredi.hu>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  include/linux/kobject.h |    4 ++-
>  lib/kobject.c           |   92 ++++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 94 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/kobject.h b/include/linux/kobject.h
> index 0b97b3a..f91aeb7 100644
> --- a/include/linux/kobject.h
> +++ b/include/linux/kobject.h
> @@ -150,11 +150,13 @@ struct kset {
>         struct kset_uevent_ops  *uevent_ops;
>  };
>
> -
>  extern void kset_init(struct kset * k);
>  extern int __must_check kset_add(struct kset * k);
>  extern int __must_check kset_register(struct kset * k);
>  extern void kset_unregister(struct kset * k);
> +extern struct kset * __must_check kset_create_and_add(const char *name,
> +                                               struct kset_uevent_ops *u,
> +                                               struct kobject *parent_kobj);
>
>  static inline struct kset * to_kset(struct kobject * kobj)
>  {
> diff --git a/lib/kobject.c b/lib/kobject.c
> index 8f24940..4fb27ba 100644
> --- a/lib/kobject.c
> +++ b/lib/kobject.c
> @@ -186,8 +186,15 @@ int kobject_add(struct kobject * kobj)
>         if (kobj->kset) {
>                 spin_lock(&kobj->kset->list_lock);
>
> -               if (!parent)
> +               if (!parent) {
>                         parent = kobject_get(&kobj->kset->kobj);
> +                       /*
> +                        * If the kset is our parent, get a second
> +                        * reference, we drop both the kset and the
> +                        * parent ref on cleanup
> +                        */
> +                       kobject_get(parent);
> +               }
>
>                 list_add_tail(&kobj->entry,&kobj->kset->list);
>                 spin_unlock(&kobj->kset->list_lock);
> @@ -787,6 +794,89 @@ int subsys_create_file(struct kset *s, struct subsys_attribute *a)
>         return error;
>  }
>
> +static void kset_release(struct kobject *kobj)
> +{
> +       struct kset *kset = container_of(kobj, struct kset, kobj);
> +       pr_debug("kset %s: now freed\n", kobject_name(kobj));
> +       kfree(kset);
> +}
> +
> +static struct kobj_type kset_type = {
> +       .release = kset_release,
> +};
> +
> +/**
> + * kset_create - create a struct kset dynamically
> + *
> + * @name: the name for the kset
> + * @uevent_ops: a struct kset_uevent_ops for the kset
> + * @parent_kobj: the parent kobject of this kset, if any.
> + *
> + * This function creates a kset structure dynamically.  This structure can
> + * then be registered with the system and show up in sysfs with a call to
> + * kset_register().  When you are finished with this structure, if
> + * kset_register() has been called, call kset_unregister() and the
> + * structure will be dynamically freed when it is no longer being used.
> + *
> + * If the kset was not able to be created, NULL will be returned.
> + */
> +static struct kset *kset_create(const char *name,
> +                               struct kset_uevent_ops *uevent_ops,
> +                               struct kobject *parent_kobj)
> +{
> +       struct kset *kset;
> +
> +       kset = kzalloc(sizeof(*kset), GFP_KERNEL);
> +       if (!kset)
> +               return NULL;
> +       kobject_set_name(&kset->kobj, name);
> +       kset->uevent_ops = uevent_ops;
> +       kset->kobj.parent = parent_kobj;
> +
> +       /*
> +        * The kobject of this kset will have a type of kset_type and belong to
> +        * no kset itself.  That way we can properly free it when it is
> +        * finished being used.
> +        */
> +       kset->kobj.ktype = &kset_type;
> +       kset->kobj.kset = NULL;
> +
> +       return kset;
> +}
> +
> +/**
> + * kset_create_and_add - create a struct kset dynamically and add it to sysfs
> + *
> + * @name: the name for the kset
> + * @uevent_ops: a struct kset_uevent_ops for the kset
> + * @parent_kobj: the parent kobject of this kset, if any.
> + *
> + * This function creates a kset structure dynamically and registers it
> + * with sysfs.  When you are finished with this structure, call
> + * kset_unregister() and the structure will be dynamically freed when it
> + * is no longer being used.
> + *
> + * If the kset was not able to be created, NULL will be returned.
> + */
> +struct kset *kset_create_and_add(const char *name,
> +                                struct kset_uevent_ops *uevent_ops,
> +                                struct kobject *parent_kobj)
> +{
> +       struct kset *kset;
> +       int error;
> +
> +       kset = kset_create(name, uevent_ops, parent_kobj);
> +       if (!kset)
> +               return NULL;
> +       error = kset_register(kset);
> +       if (error) {
> +               kfree(kset);

How about : kobject_put(&kset->kobj);

> +               return NULL;
> +       }
> +       return kset;
> +}
> +EXPORT_SYMBOL_GPL(kset_create_and_add);
> +
>  EXPORT_SYMBOL(kobject_init);
>  EXPORT_SYMBOL(kobject_register);
>  EXPORT_SYMBOL(kobject_unregister);
> --
> 1.5.3.8
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
