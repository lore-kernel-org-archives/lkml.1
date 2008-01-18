Return-Path: <linux-kernel-owner+w=401wt.eu-S1759972AbYARK1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759972AbYARK1W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 05:27:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755305AbYARK1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 05:27:13 -0500
Received: from hs-out-0708.google.com ([64.233.178.242]:3575 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755558AbYARK1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 05:27:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YgWzt9/e9s43ZQzud5aHNb/Z9gwRbPLEW/df8OWXQo0AkYUH94DNp79ce+ycGXpYlF5xHv31zALJr9EMgR/d6fhn7lGuo3Kn8ydMHoStUtIWztJzv/2RU+3WAf5aJMXdHdNQm/hrf1bQ7jgiW3AXFp2UvE1MUY65sEqtNTX/Xyc=
Message-ID: <a8e1da0801180227y1cd32468wb30954b8e181a97b@mail.gmail.com>
Date: Fri, 18 Jan 2008 18:27:08 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "rae l" <crquan@gmail.com>
Subject: Re: [PATCH] module: add modinfo support for all built-in modules
Cc: "Rusty Russell" <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
In-Reply-To: <91b13c310801180154s7931a03bh1d78ee60dadb9f9c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <91b13c310801180154s7931a03bh1d78ee60dadb9f9c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 18, 2008 5:54 PM, rae l <crquan@gmail.com> wrote:
> On Jan 16, 2008 8:25 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> > I'd love to see patches.  module_parm showed it's possible, if messy.
> >
> > Thanks!
> > Rusty.
>
> here's the patch, I added .modinfo section to the vmlinux, to collect
> built-in module information.
>
> I have just define __MODULE_INFO to another meaning while
> CONFIG_MODULES undefined
> (modules compiled built-in), instead of nothing; and so the
> MODULE_LICENSE, MODULE_AUTHOR,
> MODULE_DESCRIPTION's meaning also changed, each macro would define one
> struct kernel_modinfo
> entry in the .modinfo section of vmlinux; and one __initcall converts
> all these information to read-only
> files under /sys/modules/<module-name>/...
>
> but the MODULE_PARM_DESC macro is still different:
> it generates entries with the same tag, that would confuse
> sys_create_group, so I skipped them in the __initcall,
> since the parameters had been in /sys/modules/<>/parameters/(with perm
> non-zero) or didn't appear(with perm 0);
> I think the parameter description might be only useful for external
> module files, not needed in memory(under /sys/module/),
> so a better solution is define MODULE_PARM_DESC to nothing while
> CONFIG_MODULES undefined.
>
> Another possible defect is that it compares two modname with
> (km->modname != modname),
> that depends on a gcc feature: keep same constant string only one copy
> in the image,
> this did work on my test machines, but I'm not sure it's standard or
> not; and if not, I would change it to strcmp.
>
> Apperantly this approach will increase the kernel image size. on a
> moderate system(with 1.8MB bzImage),
> this patch would increase vmlinux 46KB and after compression increase
> bzImage 9.2KB.
> and in the increment of vmlinux, the .modinfo section occupied 5.3KB
> and others are constant strings.
>
> However, the iscsid can now work well when scsi_transport_iscsi module
> built-in without the problem refered in my former email.
>
> please give comments.
>
> From 50831a260b1ad2c8b495854a58408c1fbc75a3fe Mon Sep 17 00:00:00 2001
> From: Denis Cheng <crquan@gmail.com>
> Date: Fri, 18 Jan 2008 16:37:35 +0800
> Subject: [PATCH] module: add modinfo support for all built-in modules
>
> the current modinfo support is for external modules only, it provided module
> information under /sys/module/<XYZ>/, such as verion, ...;
> now some application(such as iscsid of open-iscsi) has been designed to
> use this module information; but built-in modules don't have modinfo support,
> so these apps would break if modules they depend on are compiled built-in.
>
> this patch add modinfo support for all built-in modules, so now no matter
> whether modules they depends on are built-in or external, modules' information
> could always be accessed from /sys/module/<XYZ>/version, apps won't break.
>
> Signed-off-by: Denis Cheng <crquan@gmail.com>
> ---
>  include/asm-generic/vmlinux.lds.h |    7 ++
>  include/linux/moduleparam.h       |   18 ++++-
>  kernel/module.c                   |  147 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 170 insertions(+), 2 deletions(-)
>
> diff --git a/include/asm-generic/vmlinux.lds.h
> b/include/asm-generic/vmlinux.lds.h
> index 9f584cc..896f0fe 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -137,6 +137,13 @@
>                 VMLINUX_SYMBOL(__start___param) = .;                    \
>                 *(__param)                                              \
>                 VMLINUX_SYMBOL(__stop___param) = .;                     \
> +       }                                                               \
> +                                                                       \
> +       /* Built-in module information. */                              \
> +       .modinfo : AT(ADDR(.modinfo) - LOAD_OFFSET) {                   \
> +               VMLINUX_SYMBOL(__start___modinfo) = .;                  \
> +               *(.modinfo)                                             \
> +               VMLINUX_SYMBOL(__stop___modinfo) = .;                   \
>                 VMLINUX_SYMBOL(__end_rodata) = .;                       \
>         }                                                               \
>                                                                         \
> diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
> index 13410b2..86ddbd4 100644
> --- a/include/linux/moduleparam.h
> +++ b/include/linux/moduleparam.h
> @@ -13,16 +13,30 @@
>  #define MODULE_PARAM_PREFIX KBUILD_MODNAME "."
>  #endif
>
> -#ifdef MODULE
>  #define ___module_cat(a,b) __mod_ ## a ## b
>  #define __module_cat(a,b) ___module_cat(a,b)
> +
> +#ifdef MODULE
>  #define __MODULE_INFO(tag, name, info)                                   \
>  static const char __module_cat(name,__LINE__)[]                                  \
>    __attribute_used__                                                     \
>    __attribute__((section(".modinfo"),unused)) = __stringify(tag) "=" info
>  #else  /* !MODULE */
> -#define __MODULE_INFO(tag, name, info)
> +struct kernel_modinfo {
> +       char *modname;
> +       char *tag;
> +       char *info;
> +};
> +#define __MODULE_INFO(tag, name, info)                                   \
> +static const struct kernel_modinfo __module_cat(name, __LINE__)          \
> +  __attribute_used__                                                     \
> +  __attribute__((section(".modinfo"), unused)) =                         \
> +  { KBUILD_MODNAME, __stringify(tag), info }
> +
> +extern const struct kernel_modinfo __start___modinfo[], __stop___modinfo[];
> +
>  #endif
> +
>  #define __MODULE_PARM_TYPE(name, _type)                                          \
>    __MODULE_INFO(parmtype, name##type, #name ":" _type)
>
> diff --git a/kernel/module.c b/kernel/module.c
> index c2e3e2e..9828918 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2609,3 +2609,150 @@ void module_update_markers(struct module
> *probe_module, int *refcount)
>         mutex_unlock(&module_mutex);
>  }
>  #endif
> +
> +#ifdef CONFIG_SYSFS
> +struct modinfo_attribute {
> +       struct module_attribute mattr;
> +       const struct kernel_modinfo *modinfo;
> +};
> +
> +struct module_modinfo_attrs {
> +       struct attribute_group grp;
> +       struct modinfo_attribute attrs[0];
> +};
> +
> +#define to_modinfo_attr(n) container_of(n, struct modinfo_attribute, mattr)
> +
> +static ssize_t modinfo_attr_show(struct module_attribute *mattr,
> +               struct module *mod, char *buf)
> +{
> +       const struct kernel_modinfo *km = to_modinfo_attr(mattr)->modinfo;
> +       return snprintf(buf, PAGE_SIZE, "%s\n", km->info);
> +}
> +
> +/* skip the parameters' description in .modinfo */
> +static __init int modinfo_skip(char *name)
> +{
> +       return (strlen(name) == 4 && !strncmp(name, "parm", 4)) ||
> +               (strlen(name) == 8 && !strncmp(name, "parmtype", 8));
> +}
> +
> +static __init void modinfo_sysfs_setup(struct module_kobject *mk,
> +                 const struct kernel_modinfo km_begin[],
> +                 unsigned int num_params)
> +{
> +       struct module_modinfo_attrs *mp;
> +       unsigned int valid_attrs = 0;
> +       unsigned int i, size[2];
> +       struct modinfo_attribute *pattr;
> +       struct attribute **gattr;
> +
> +       for (i = 0; i < num_params; ++i) {
> +               if (!modinfo_skip(km_begin[i].tag))
> +                       valid_attrs++;
> +       }
> +
> +       if (!valid_attrs)
> +               return;
> +
> +       size[0] = ALIGN(sizeof(*mp) +
> +                       valid_attrs * sizeof(mp->attrs[0]),
> +                       sizeof(mp->grp.attrs[0]));
> +       size[1] = (valid_attrs + 1) * sizeof(mp->grp.attrs[0]);
> +
> +       mp = kzalloc(size[0] + size[1], GFP_KERNEL);
> +       if (!mp)
> +               return;
> +
> +       mp->grp.attrs = (void *)mp + size[0];
> +
> +       pattr = &mp->attrs[0];
> +       gattr = &mp->grp.attrs[0];
> +       for (i = 0; i < valid_attrs; i++) {
> +               const struct kernel_modinfo *km = &km_begin[i];
> +               if (!modinfo_skip(km_begin[i].tag)) {
> +                       pattr->modinfo = km;
> +                       pattr->mattr.show = modinfo_attr_show;
> +                       pattr->mattr.attr.name = km->tag;
> +                       pattr->mattr.attr.mode = S_IRUGO;
> +                       *(gattr++) = &(pattr++)->mattr.attr;
> +               }
> +       }
> +
> +       if (sysfs_create_group(&mk->kobj, &mp->grp))
> +               kfree(mp);
> +}
> +
> +static void __init kernel_modinfo_sysfs_setup(const char *modname,
> +               const struct kernel_modinfo km_begin[],
> +               unsigned int num_params)
> +{
> +       struct kobject *mkobj;
> +       struct module_kobject *mk;
> +       int ret;
> +
> +       mkobj = kset_find_obj(&module_subsys, modname);
> +
> +       if (mkobj)
> +               mk = container_of(mkobj, struct module_kobject, kobj);
> +       else {
> +               mk = kzalloc(sizeof(struct module_kobject), GFP_KERNEL);
> +
> +               kobj_set_kset_s(mk, module_subsys);
> +               kobject_set_name(&mk->kobj, modname);
> +               kobject_init(&mk->kobj);
> +               ret = kobject_add(&mk->kobj);
> +               if (ret) {
> +                       printk(KERN_ERR "Module '%s' failed to be added to"
> +                                       " sysfs, error number %d\n",
> +                                       modname, ret);
> +                       printk(KERN_ERR "The system will be unstable now.\n");

Maybe should put mk->kobj for release

> +                       return;
> +               }
> +       }
> +
> +       modinfo_sysfs_setup(mk, km_begin, num_params);
> +
> +       if (mkobj) {
> +               /* kset_find_obj incremental a reference on mkobj */
> +               kobject_put(mkobj);
> +       } else
> +               kobject_uevent(&mk->kobj, KOBJ_ADD);

The if/else could be merged to the above one.

> +}
> +
> +/*
> + * module_info_sysfs_init is for built-in modules
> + *
> + * __initcall("6") is later than subsys_init
> + */
> +static int __init builtin_modinfo_sysfs_init(void)
> +{
> +       const struct kernel_modinfo *km, *km_begin = NULL;
> +       unsigned int count = 0;
> +       char *modname = NULL;
> +
> +       for (km = __start___modinfo; km < __stop___modinfo; km++) {
> +               /* new kbuild_modname? */
> +               if (km->modname != modname) {
> +                       /* add a new kobject for previous kernel_modinfo . */
> +                       if (count)
> +                               kernel_modinfo_sysfs_setup(modname,
> +                                               km_begin,
> +                                               count);
> +
> +                       modname = km->modname;
> +                       count = 0;
> +                       km_begin = km;
> +               }
> +               count++;
> +       }
> +
> +       /* last kernel_modinfo need to be registered as well */
> +       if (count)
> +               kernel_modinfo_sysfs_setup(modname, km_begin, count);
> +
> +       return 0;
> +}
> +__initcall(builtin_modinfo_sysfs_init);
> +
> +#endif
> --
> 1.5.3.5
>
> --
> Denis Cheng
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
