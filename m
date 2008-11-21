Return-Path: <linux-kernel-owner+w=401wt.eu-S1757274AbYKUTBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274AbYKUTBk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 14:01:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754022AbYKUTBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 14:01:31 -0500
Received: from smtp-out.google.com ([216.239.45.13]:22988 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017AbYKUTBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 14:01:30 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=vTNHi7OYvRvliqejdO9pk5RRJu5LpxiepKMbzegHcBLARFNuXmdcCLEOFtPUUmv97
	DXcS2NO55P+q3Kl/Jzf+g==
MIME-Version: 1.0
In-Reply-To: <49267618.6080802@cn.fujitsu.com>
References: <49267618.6080802@cn.fujitsu.com>
Date: Fri, 21 Nov 2008 11:01:28 -0800
Message-ID: <6599ad830811211101t12cf74eh974bdbf9e7afa360@mail.gmail.com>
Subject: Re: [PATCH] cgroups: don't put struct cgroupfs_root protected by RCU
From: Paul Menage <menage@google.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2008 at 12:49 AM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
>
> we don't access struct cgroupfs_root in fast path,
> so we should not put struct cgroupfs_root protected by RCU
>
> but the comment in struct cgroup_subsys.root confuse us.
>
> struct cgroup_subsys.root is used in these places:
>
> 1 find_css_set(): if (ss->root->subsys_list.next == &ss->sibling)
> 2 rebind_subsystems(): if (ss->root != &rootnode)
>                       rcu_assign_pointer(ss->root, root);
>                       rcu_assign_pointer(subsys[i]->root, &rootnode);
> 3 cgroup_has_css_refs(): if (ss->root != cgrp->root)
> 4 cgroup_init_subsys(): ss->root = &rootnode;
> 5 proc_cgroupstats_show(): ss->name, ss->root->subsys_bits,
>                           ss->root->number_of_cgroups, !ss->disabled);
> 6 cgroup_clone(): root = subsys->root;
>                  if ((root != subsys->root) ||
>
> all these place we have held cgroup_lock() or we don't dereference to
> struct cgroupfs_root. It's means wo don't need RCU when use
> struct cgroup_subsys.root, and we should not put struct cgroupfs_root
> protected by RCU.
>
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Reviewed-by: Paul Menage <menage@google.com>

Thanks, seems reasonable.

> ---
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index 1164963..22901ff 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -343,7 +345,6 @@ struct cgroup_subsys {
>  #define MAX_CGROUP_TYPE_NAMELEN 32
>        const char *name;
>
> -       /* Protected by RCU */
>        struct cgroupfs_root *root;
>
>        struct list_head sibling;
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 358e775..ddc10ac 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -717,7 +722,7 @@ static int rebind_subsystems(struct cgroupfs_root *root,
>                        cgrp->subsys[i] = dummytop->subsys[i];
>                        cgrp->subsys[i]->cgroup = cgrp;
>                        list_add(&ss->sibling, &root->subsys_list);
> -                       rcu_assign_pointer(ss->root, root);
> +                       ss->root = root;
>                        if (ss->bind)
>                                ss->bind(ss, cgrp);
>
> @@ -729,7 +734,7 @@ static int rebind_subsystems(struct cgroupfs_root *root,
>                                ss->bind(ss, dummytop);
>                        dummytop->subsys[i]->cgroup = dummytop;
>                        cgrp->subsys[i] = NULL;
> -                       rcu_assign_pointer(subsys[i]->root, &rootnode);
> +                       subsys[i]->root = &rootnode;
>                        list_del(&ss->sibling);
>                } else if (bit & final_bits) {
>                        /* Subsystem state should already exist */
>
>
>
