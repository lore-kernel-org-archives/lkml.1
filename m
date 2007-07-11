Return-Path: <linux-kernel-owner+w=401wt.eu-S934495AbXGKWj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934495AbXGKWj7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 18:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757855AbXGKWjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 18:39:51 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:5637 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667AbXGKWju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 18:39:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qE2MCFXXdpo/feEV93M8dLHSFJsACLG0CD3dPqA7ivnMakoCBOnn5SBY1KrHYZp+8D2amXmKy52IYlu+h52Ul1wUx4STbVxBxjC2c8Jwt1cY6s8gd7TcP2d14hN/4wNd2CBWquG/XCFW9xexstMfsbNg6RW9rBPwuVAYCOs/tlE=
Message-ID: <a44ae5cd0707111539l5e5adc4ct76ae2f4cb9063e58@mail.gmail.com>
Date: Wed, 11 Jul 2007 15:39:49 -0700
From: "Miles Lane" <miles.lane@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: 2.6.22-rc6-mm1 -- BUG - EIP: [<c01a77a1>] sysfs_addrm_finish+0x1c2/0x226 SS:ESP 0068:c5ff9db8
Cc: "Andrew Morton" <akpm@osdl.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <4694A769.7040502@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a44ae5cd0707030932h16a90ca3j8ad65b7a3ec64b03@mail.gmail.com>
	 <a44ae5cd0707040036x74c82dcci12b0a3f83a27af56@mail.gmail.com>
	 <468C9E74.4080606@gmail.com>
	 <a44ae5cd0707060101g38147b2gb3d33d9903082113@mail.gmail.com>
	 <468F36F5.4010803@gmail.com>
	 <a44ae5cd0707071753g6dd4445bsaac2e2296327e510@mail.gmail.com>
	 <469038EF.7040709@gmail.com>
	 <a44ae5cd0707072156y7d0c9e5am2ded3efdc036bcf7@mail.gmail.com>
	 <469484E1.6040000@gmail.com> <4694A769.7040502@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/11/07, Tejun Heo <htejun@gmail.com> wrote:
> Tejun Heo wrote:
> > Miles Lane wrote:
> >>> Thanks a lot.  Just in case, if you remove the patch (patch -R -p1), the
> >>> oops goes away, right?
> >> I double-checked.  I can boot fine after building without your patch.
> >> Also, I reproduced the initial BUG I reported (triggered by
> >> "modprobe -r ipw2200").
> >
> > This is creepy.  I was able to reproduce the oops here with your
> > configuration file and making buffers for kallsyms static solved the
> > problem.  It isn't stack overflow.  At maximum those arrays added 254
> > bytes to the stack and when the oops occurs stack area was left more
> > than enough.  I'll keep looking into why that happened but the attached
> > patch should get us going on the original subject.
>
> Alright, found out what was going on.  KSYM_NAME_LEN doesn't include
> space for the trailing '\0'.  Gees, I've read enough assembly for the
> month to find that out.  Anyways, here's proper debug patch.
>
> Thanks.
>
> --
> tejun
>
> ---
>  fs/sysfs/dir.c        |   43 +++++++++++++++++++++++++++++++++++++++++++
>  fs/sysfs/sysfs.h      |   16 ++--------------
>  include/linux/sysfs.h |    3 +++
>  net/core/net-sysfs.c  |    6 +++++-
>  4 files changed, 53 insertions(+), 15 deletions(-)
>
> Index: tree0/fs/sysfs/dir.c
> ===================================================================
> --- tree0.orig/fs/sysfs/dir.c
> +++ tree0/fs/sysfs/dir.c
> @@ -11,15 +11,52 @@
>  #include <linux/namei.h>
>  #include <linux/idr.h>
>  #include <linux/completion.h>
> +#include <linux/kallsyms.h>
>  #include <asm/semaphore.h>
>  #include "sysfs.h"
>
> +struct kobject *sysfs_debug_me;
> +
>  DEFINE_MUTEX(sysfs_mutex);
>  spinlock_t sysfs_assoc_lock = SPIN_LOCK_UNLOCKED;
>
>  static spinlock_t sysfs_ino_lock = SPIN_LOCK_UNLOCKED;
>  static DEFINE_IDA(sysfs_ino_ida);
>
> +struct sysfs_dirent * sysfs_get(struct sysfs_dirent * sd)
> +{
> +       if (sd) {
> +               if (sd->s_flags & SYSFS_FLAG_XXX) {
> +                       char c0[KSYM_NAME_LEN + 1], c1[KSYM_NAME_LEN + 1];
> +
> +                       lookup_symbol_name((unsigned long)__builtin_return_address(0), c0);
> +                       lookup_symbol_name((unsigned long)__builtin_return_address(1), c1);
> +
> +                       printk("sysfs_get(%s): cnt=%d++ called from %s:%s\n",
> +                              sd->s_name, atomic_read(&sd->s_count), c0, c1);
> +               }
> +               WARN_ON(!atomic_read(&sd->s_count));
> +               atomic_inc(&sd->s_count);
> +       }
> +       return sd;
> +}
> +
> +void sysfs_put(struct sysfs_dirent * sd)
> +{
> +       if (sd && sd->s_flags & SYSFS_FLAG_XXX) {
> +               char c0[KSYM_NAME_LEN + 1], c1[KSYM_NAME_LEN + 1];
> +
> +               lookup_symbol_name((unsigned long)__builtin_return_address(0), c0);
> +               lookup_symbol_name((unsigned long)__builtin_return_address(1), c1);
> +
> +               printk("sysfs_put(%s): cnt=%d-- called from %s:%s\n",
> +                      sd->s_name, atomic_read(&sd->s_count), c0, c1);
> +       }
> +
> +       if (sd && atomic_dec_and_test(&sd->s_count))
> +               release_sysfs_dirent(sd);
> +}
> +
>  /**
>   *     sysfs_link_sibling - link sysfs_dirent into sibling list
>   *     @sd: sysfs_dirent of interest
> @@ -317,6 +354,10 @@ void release_sysfs_dirent(struct sysfs_d
>          * sd->s_parent won't change beneath us.
>          */
>         parent_sd = sd->s_parent;
> +       if (parent_sd->s_flags & SYSFS_FLAG_XXX)
> +               printk("put from release(%s): cnt=%d-- (rel=%s)\n",
> +                      parent_sd->s_name, atomic_read(&parent_sd->s_count),
> +                      sd->s_name);
>
>         if (sysfs_type(sd) == SYSFS_KOBJ_LINK)
>                 sysfs_put(sd->s_elem.symlink.target_sd);
> @@ -695,6 +736,8 @@ static int create_dir(struct kobject *ko
>         if (!sd)
>                 return -ENOMEM;
>         sd->s_elem.dir.kobj = kobj;
> +       if (sysfs_debug_me && sysfs_debug_me == kobj)
> +               sd->s_flags |= SYSFS_FLAG_XXX;
>
>         /* link in */
>         sysfs_addrm_start(&acxt, parent_sd);
> Index: tree0/fs/sysfs/sysfs.h
> ===================================================================
> --- tree0.orig/fs/sysfs/sysfs.h
> +++ tree0/fs/sysfs/sysfs.h
> @@ -108,20 +108,8 @@ static inline unsigned int sysfs_type(st
>         return sd->s_flags & SYSFS_TYPE_MASK;
>  }
>
> -static inline struct sysfs_dirent * sysfs_get(struct sysfs_dirent * sd)
> -{
> -       if (sd) {
> -               WARN_ON(!atomic_read(&sd->s_count));
> -               atomic_inc(&sd->s_count);
> -       }
> -       return sd;
> -}
> -
> -static inline void sysfs_put(struct sysfs_dirent * sd)
> -{
> -       if (sd && atomic_dec_and_test(&sd->s_count))
> -               release_sysfs_dirent(sd);
> -}
> +struct sysfs_dirent * sysfs_get(struct sysfs_dirent * sd);
> +void sysfs_put(struct sysfs_dirent * sd);
>
>  static inline int sysfs_is_shadowed_inode(struct inode *inode)
>  {
> Index: tree0/include/linux/sysfs.h
> ===================================================================
> --- tree0.orig/include/linux/sysfs.h
> +++ tree0/include/linux/sysfs.h
> @@ -87,9 +87,12 @@ struct sysfs_ops {
>
>  #define SYSFS_FLAG_MASK                ~SYSFS_TYPE_MASK
>  #define SYSFS_FLAG_REMOVED     0x0100
> +#define SYSFS_FLAG_XXX         0x0200
>
>  #ifdef CONFIG_SYSFS
>
> +extern struct kobject *sysfs_debug_me;
> +
>  extern int sysfs_schedule_callback(struct kobject *kobj,
>                 void (*func)(void *), void *data, struct module *owner);
>
> Index: tree0/net/core/net-sysfs.c
> ===================================================================
> --- tree0.orig/net/core/net-sysfs.c
> +++ tree0/net/core/net-sysfs.c
> @@ -472,6 +472,7 @@ int netdev_register_sysfs(struct net_dev
>  {
>         struct device *dev = &(net->dev);
>         struct attribute_group **groups = net->sysfs_groups;
> +       int rc;
>
>         device_initialize(dev);
>         dev->class = &net_class;
> @@ -489,7 +490,10 @@ int netdev_register_sysfs(struct net_dev
>                 *groups++ = &wireless_group;
>  #endif
>
> -       return device_add(dev);
> +       sysfs_debug_me = &dev->kobj;
> +       rc = device_add(dev);
> +       sysfs_debug_me = NULL;
> +       return rc;
>  }
>
>  int netdev_sysfs_init(void)
>
>

Tejun,

Does this patch replace or add to the last patch you sent me?
I'll try applying them with --dry-run and assume that if #1 + #2
doesn't apply cleanly, then you only want me to test with this
latest patch.

I'll be able to test this later this evening.  I've had house guests and
so haven't been available the last few days.

        Miles
