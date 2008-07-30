Return-Path: <linux-kernel-owner+w=401wt.eu-S1759220AbYG3IPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759220AbYG3IPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 04:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbYG3IPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 04:15:15 -0400
Received: from smtp-out.google.com ([216.239.33.17]:44140 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbYG3IPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 04:15:13 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=GBKlz4qvHdQLCwpkV3E3yv6YHtcu79wnI8ZrmPTHDAqiOBOVQ6UrqV374IicaI82/
	fBn0+MjVN6NQw7MjFIjgA==
Message-ID: <6599ad830807300115w5e6a620cw18b63fbcf60fb778@mail.gmail.com>
Date: Wed, 30 Jul 2008 01:15:03 -0700
From: "Paul Menage" <menage@google.com>
To: "Li Zefan" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] cgroup: remove duplicate code in allocate_cg_link()
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Linux Containers" <containers@lists.linux-foundation.org>
In-Reply-To: <488D2D0A.7050006@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <488D2D0A.7050006@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 27, 2008 at 7:20 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> - just call free_cg_links() in allocate_cg_links()
> - the list will get initialized in allocate_cg_links(), so don't init
>  it twice
>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

(Belatedly) Acked-by: Paul Menage <menage@google.com>

Thanks, looks like a good cleanup.

> ---
>  kernel/cgroup.c |   30 ++++++++++++------------------
>  1 files changed, 12 insertions(+), 18 deletions(-)
>
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 28debe4..249a517 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -355,6 +355,17 @@ static struct css_set *find_existing_css_set(
>        return NULL;
>  }
>
> +static void free_cg_links(struct list_head *tmp)
> +{
> +       struct cg_cgroup_link *link;
> +       struct cg_cgroup_link *saved_link;
> +
> +       list_for_each_entry_safe(link, saved_link, tmp, cgrp_link_list) {
> +               list_del(&link->cgrp_link_list);
> +               kfree(link);
> +       }
> +}
> +
>  /*
>  * allocate_cg_links() allocates "count" cg_cgroup_link structures
>  * and chains them on tmp through their cgrp_link_list fields. Returns 0 on
> @@ -363,17 +374,12 @@ static struct css_set *find_existing_css_set(
>  static int allocate_cg_links(int count, struct list_head *tmp)
>  {
>        struct cg_cgroup_link *link;
> -       struct cg_cgroup_link *saved_link;
>        int i;
>        INIT_LIST_HEAD(tmp);
>        for (i = 0; i < count; i++) {
>                link = kmalloc(sizeof(*link), GFP_KERNEL);
>                if (!link) {
> -                       list_for_each_entry_safe(link, saved_link, tmp,
> -                                                cgrp_link_list) {
> -                               list_del(&link->cgrp_link_list);
> -                               kfree(link);
> -                       }
> +                       free_cg_links(tmp);
>                        return -ENOMEM;
>                }
>                list_add(&link->cgrp_link_list, tmp);
> @@ -381,17 +387,6 @@ static int allocate_cg_links(int count, struct list_head *tmp)
>        return 0;
>  }
>
> -static void free_cg_links(struct list_head *tmp)
> -{
> -       struct cg_cgroup_link *link;
> -       struct cg_cgroup_link *saved_link;
> -
> -       list_for_each_entry_safe(link, saved_link, tmp, cgrp_link_list) {
> -               list_del(&link->cgrp_link_list);
> -               kfree(link);
> -       }
> -}
> -
>  /*
>  * find_css_set() takes an existing cgroup group and a
>  * cgroup object, and returns a css_set object that's
> @@ -956,7 +951,6 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
>        struct super_block *sb;
>        struct cgroupfs_root *root;
>        struct list_head tmp_cg_links;
> -       INIT_LIST_HEAD(&tmp_cg_links);
>
>        /* First find the desired set of subsystems */
>        ret = parse_cgroupfs_options(data, &opts);
> --
> 1.5.4.rc3
>
>
