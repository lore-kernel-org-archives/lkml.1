Return-Path: <linux-kernel-owner+w=401wt.eu-S1755334AbYH2ISW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbYH2ISW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 04:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbYH2ISL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 04:18:11 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:22029 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbYH2ISJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 04:18:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=vxZlH81XfgPaoOH+tjrw6FDqV1lx4nljB3Z84XLpHPJgzIHbcUysfmn08FQ3JDH4Uk
         bkluMgpl6avyXVBAVLS2bRZFguC6BAnaNwwPCAf8Velk2D0aMvK3VcGvepxiBgBKY8aF
         QBO5syvlZz6L/2HLh/um0+ddFSwrVbTZazZ9o=
Message-ID: <86802c440808290118ibacdd5es698b538aec55d136@mail.gmail.com>
Date: Fri, 29 Aug 2008 01:18:07 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [PATCH] x86: split e820 reserved entries record to late v4 - fix
Cc: linux-kernel@vger.kernel.org, "Yinghai Lu" <yhlu.kernel@gmail.com>
In-Reply-To: <1219997592-9975-1-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1219997592-9975-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 1:13 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> try to insert_resource second time, by expand the resource...
>
> for case: e820 reserved entry is partially overlapped with bar res...
>
> hope it will never happen
>
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>
> ---
>  arch/x86/kernel/e820.c |   32 ++++++++++++++++++++++++++++++--
>  include/linux/ioport.h |    1 +
>  kernel/resource.c      |   35 ++++++++++++++++++++++++++---------
>  3 files changed, 57 insertions(+), 11 deletions(-)
>
> Index: linux-2.6/arch/x86/kernel/e820.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/e820.c
> +++ linux-2.6/arch/x86/kernel/e820.c
> @@ -1319,8 +1319,36 @@ void __init e820_reserve_resources_late(
>
>        res = e820_res;
>        for (i = 0; i < e820.nr_map; i++) {
> -               if (!res->parent && res->end)
> -                       insert_resource(&iomem_resource, res);
> +               if (!res->parent && res->end) {
> +                       struct resource *ret;
> +
> +                       ret = __insert_resource(&iomem_resource, res);
> +                       if (ret) {
> +                               int updated = 0;
> +
> +                               printk(KERN_WARNING "found conflict: %s [%08llx, %08llx] with %s [%08llx, %08llx]\n",
> +                                       res->name, res->start, res->end,
> +                                       ret->name, ret->start, ret->end);
> +                               if (res->start > ret->start && res->start <= ret->end) {
> +                                       if (i && ret->start > e820_res[i-1].end) {
> +                                               res->start = ret->start;
> +                                               updated = 1;
> +                                       }
> +                               } else if (res->end > ret->start && res->end <= ret->end) {
> +                                       if (i < (e820.nr_map - 1) && ret->end > e820_res[i+1].start) {

should be
                                     if (i < (e820.nr_map - 1) &&
ret->end < e820_res[i+1].start) {

> +                                               res->end = ret->end;
> +                                               updated = 1;
> +                                       }
> +                               }
> +                               if (updated) {
> +                                       ret = __insert_resource(&iomem_resource, res);
> +                                       if (ret)
> +                                               printk(KERN_WARNING "second try found conflict: %s [%08llx, %08llx] with %s [%08llx, %08llx]\n",
> +                                                       res->name, res->start, res->end,
> +                                                       ret->name, ret->start, ret->end);
> +                               }
> +                       }
> +               }
>                res++;
>        }
>  }
> Index: linux-2.6/include/linux/ioport.h
> ===================================================================
> --- linux-2.6.orig/include/linux/ioport.h
> +++ linux-2.6/include/linux/ioport.h
> @@ -108,6 +108,7 @@ extern struct resource iomem_resource;
>
>  extern int request_resource(struct resource *root, struct resource *new);
>  extern int release_resource(struct resource *new);
> +extern struct resource *__insert_resource(struct resource *parent, struct resource *new);
>  extern int insert_resource(struct resource *parent, struct resource *new);
>  extern int allocate_resource(struct resource *root, struct resource *new,
>                             resource_size_t size, resource_size_t min,
> Index: linux-2.6/kernel/resource.c
> ===================================================================
> --- linux-2.6.orig/kernel/resource.c
> +++ linux-2.6/kernel/resource.c
> @@ -363,11 +363,11 @@ int allocate_resource(struct resource *r
>  EXPORT_SYMBOL(allocate_resource);
>
>  /**
> - * insert_resource - Inserts a resource in the resource tree
> + * __insert_resource - Inserts a resource in the resource tree
>  * @parent: parent of the new resource
>  * @new: new resource to insert
>  *
> - * Returns 0 on success, -EBUSY if the resource can't be inserted.
> + * Returns NULL on success, or first conflict resource.
>  *
>  * This function is equivalent to request_resource when no conflict
>  * happens. If a conflict happens, and the conflicting resources
> @@ -375,20 +375,20 @@ EXPORT_SYMBOL(allocate_resource);
>  * resource is inserted and the conflicting resources become children of
>  * the new resource.
>  */
> -int insert_resource(struct resource *parent, struct resource *new)
> +struct resource *__insert_resource(struct resource *parent, struct resource *new)
>  {
> -       int result;
> +       struct resource *ret_res;
>        struct resource *first, *next;
>
>        write_lock(&resource_lock);
>
>        for (;; parent = first) {
> -               result = 0;
> +               ret_res = NULL;
>                first = __request_resource(parent, new);
>                if (!first)
>                        goto out;
>
> -               result = -EBUSY;
> +               ret_res = first;
>                if (first == parent)
>                        goto out;
>
> @@ -400,15 +400,17 @@ int insert_resource(struct resource *par
>
>        for (next = first; ; next = next->sibling) {
>                /* Partial overlap? Bad, and unfixable */
> -               if (next->start < new->start || next->end > new->end)
> +               if (next->start < new->start || next->end > new->end) {
> +                       ret_res = next;
>                        goto out;
> +               }
>                if (!next->sibling)
>                        break;
>                if (next->sibling->start > new->end)
>                        break;
>        }
>
> -       result = 0;
> +       ret_res = NULL;
>
>        new->parent = parent;
>        new->sibling = next->sibling;
> @@ -429,10 +431,25 @@ int insert_resource(struct resource *par
>
>  out:
>        write_unlock(&resource_lock);
> -       return result;
> +       return ret_res;
>  }
>
>  /**
> + * insert_resource - Inserts a resource in the resource tree
> + * @parent: parent of the new resource
> + * @new: new resource to insert
> + *
> + * Returns 0 on success, -EBUSY if the resource can't be inserted.
> + */
> +int insert_resource(struct resource *parent, struct resource *new)
> +{
> +       struct resource *res_conflict;
> +
> +       res_conflict = __insert_resource(parent, new);
> +
> +       return res_conflict ? -EBUSY : 0;
> +}
> +/**
>  * adjust_resource - modify a resource's start and size
>  * @res: resource to modify
>  * @start: new start value
>
