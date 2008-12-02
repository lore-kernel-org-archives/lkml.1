Return-Path: <linux-kernel-owner+w=401wt.eu-S1753851AbYLBBf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbYLBBf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 20:35:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbYLBBfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 20:35:19 -0500
Received: from smtp-out.google.com ([216.239.45.13]:43959 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbYLBBfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 20:35:18 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=vZts3Y3boNzWZAHfYLKEoGVxX324YYxOei8G2+Mjo8IakolTGmE1sW6VyBYF8zsdK
	uOWzxfwu6Nn4lHJIcT4uQ==
MIME-Version: 1.0
In-Reply-To: <492FC1BD.4010705@cn.fujitsu.com>
References: <492FC1BD.4010705@cn.fujitsu.com>
Date: Mon, 1 Dec 2008 17:35:15 -0800
Message-ID: <6599ad830812011735i565087dfg7ebad01a1f0400ad@mail.gmail.com>
Subject: Re: [PATCH 2/3] cgroups: add inactive subsystems to 
	rootnode.root_list
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2008 at 2:02 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> Though for an inactive hierarchy, we have subsys->root == &rootnode,
> but rootnode's root_list is always empty.

I think you mean "rootnode's subsys_list is always empty".

>
> The above code assumes rootnode.subsys_list links all inactive
> hierarchies.
>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/cgroup.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 33ba756..4e50e97 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -716,7 +716,7 @@ static int rebind_subsystems(struct cgroupfs_root *root,
>                        BUG_ON(dummytop->subsys[i]->cgroup != dummytop);
>                        cgrp->subsys[i] = dummytop->subsys[i];
>                        cgrp->subsys[i]->cgroup = cgrp;
> -                       list_add(&ss->sibling, &root->subsys_list);
> +                       list_move(&ss->sibling, &root->subsys_list);
>                        rcu_assign_pointer(ss->root, root);
>                        if (ss->bind)
>                                ss->bind(ss, cgrp);
> @@ -730,7 +730,7 @@ static int rebind_subsystems(struct cgroupfs_root *root,
>                        dummytop->subsys[i]->cgroup = dummytop;
>                        cgrp->subsys[i] = NULL;
>                        rcu_assign_pointer(subsys[i]->root, &rootnode);
> -                       list_del(&ss->sibling);
> +                       list_move(&ss->sibling, &rootnode.subsys_list);
>                } else if (bit & final_bits) {
>                        /* Subsystem state should already exist */
>                        BUG_ON(!cgrp->subsys[i]);
> @@ -2522,6 +2522,7 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss)
>        printk(KERN_INFO "Initializing cgroup subsys %s\n", ss->name);
>
>        /* Create the top cgroup state for this subsystem */
> +       list_add(&ss->sibling, &rootnode.root_list);

This is wrong. cgroup_subsys.sibling is a member of the list of
subsystems attached to a given root, and rootnode.root_list is a
member of the list of hierarchies. Did you actually meant
&rootnode.subsys_list?

Paul
