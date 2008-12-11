Return-Path: <linux-kernel-owner+w=401wt.eu-S1756244AbYLKAij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbYLKAij (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 19:38:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbYLKAi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 19:38:29 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47663 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442AbYLKAi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 19:38:28 -0500
Date: Thu, 11 Dec 2008 09:37:33 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: menage@google.com
Cc: balbir@linux.vnet.ibm.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [RFC][PATCH 1/3] CGroups: Add a per-subsystem hierarchy_mutex
Message-Id: <20081211093733.c24deb6e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081210234432.065445000@menage.corp.google.com>
References: <20081210233654.563182000@menage.corp.google.com>
	<20081210234432.065445000@menage.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thank you for this work.

On Wed, 10 Dec 2008 15:36:55 -0800
menage@google.com wrote:

> This patch adds a hierarchy_mutex to the cgroup_subsys object that
> protects changes to the hierarchy observed by that subsystem. It is
> taken by the cgroup subsystem (in addition to cgroup_mutex) for the
> following operations:
> 
> - linking a cgroup into that subsystem's cgroup tree
> - unlinking a cgroup from that subsystem's cgroup tree
> - moving the subsystem to/from a hierarchy (including across the
>   bind() callback)
> 
o.k. usage is very clear.

> Thus if the subsystem holds its own hierarchy_mutex, it can safely
> traverse its own hierarchy.
> 
> Signed-off-by: Paul Menage <menage@google.com>
> 
> ---
> 
>  Documentation/cgroups/cgroups.txt |    2 +-
>  include/linux/cgroup.h            |    9 ++++++++-
>  kernel/cgroup.c                   |   37 +++++++++++++++++++++++++++++++++++--
>  3 files changed, 44 insertions(+), 4 deletions(-)
> 
> Index: hierarchy_lock-mmotm-2008-12-09/include/linux/cgroup.h
> ===================================================================
> --- hierarchy_lock-mmotm-2008-12-09.orig/include/linux/cgroup.h
> +++ hierarchy_lock-mmotm-2008-12-09/include/linux/cgroup.h
> @@ -337,8 +337,15 @@ struct cgroup_subsys {
>  #define MAX_CGROUP_TYPE_NAMELEN 32
>  	const char *name;
>  
> -	struct cgroupfs_root *root;
> +	/*
> +	 * Protects sibling/children links of cgroups in this
> +	 * hierarchy, plus protects which hierarchy (or none) the
> +	 * subsystem is a part of (i.e. root/sibling)
> +	 */
> +	struct mutex hierarchy_mutex;
>  
> +	/* Protected by this->hierarchy_mutex and cgroup_lock() */
> +	struct cgroupfs_root *root;
>  	struct list_head sibling;
>  };
>  
> Index: hierarchy_lock-mmotm-2008-12-09/kernel/cgroup.c
> ===================================================================
> --- hierarchy_lock-mmotm-2008-12-09.orig/kernel/cgroup.c
> +++ hierarchy_lock-mmotm-2008-12-09/kernel/cgroup.c
> @@ -714,23 +714,26 @@ static int rebind_subsystems(struct cgro
>  			BUG_ON(cgrp->subsys[i]);
>  			BUG_ON(!dummytop->subsys[i]);
>  			BUG_ON(dummytop->subsys[i]->cgroup != dummytop);
> +			mutex_lock(&ss->hierarchy_mutex);
>  			cgrp->subsys[i] = dummytop->subsys[i];
>  			cgrp->subsys[i]->cgroup = cgrp;
>  			list_move(&ss->sibling, &root->subsys_list);
>  			ss->root = root;
>  			if (ss->bind)
>  				ss->bind(ss, cgrp);
> -
> +			mutex_unlock(&ss->hierarchy_mutex);
>  		} else if (bit & removed_bits) {
>  			/* We're removing this subsystem */
>  			BUG_ON(cgrp->subsys[i] != dummytop->subsys[i]);
>  			BUG_ON(cgrp->subsys[i]->cgroup != cgrp);
> +			mutex_lock(&ss->hierarchy_mutex);
>  			if (ss->bind)
>  				ss->bind(ss, dummytop);
>  			dummytop->subsys[i]->cgroup = dummytop;
>  			cgrp->subsys[i] = NULL;
>  			subsys[i]->root = &rootnode;
>  			list_move(&ss->sibling, &rootnode.subsys_list);
> +			mutex_unlock(&ss->hierarchy_mutex);
>  		} else if (bit & final_bits) {
>  			/* Subsystem state should already exist */
>  			BUG_ON(!cgrp->subsys[i]);
> @@ -2326,6 +2329,29 @@ static void init_cgroup_css(struct cgrou
>  	cgrp->subsys[ss->subsys_id] = css;
>  }
>  
> +static void cgroup_lock_hierarchy(struct cgroupfs_root *root)
> +{
> +	/* We need to take each hierarchy_mutex in a consistent order */
> +	int i;
> +
> +	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
> +		struct cgroup_subsys *ss = subsys[i];
> +		if (ss->root == root)
> +			mutex_lock_nested(&ss->hierarchy_mutex, i);
> +	}
> +}
> +
> +static void cgroup_unlock_hierarchy(struct cgroupfs_root *root)
> +{
> +	int i;
> +
> +	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
> +		struct cgroup_subsys *ss = subsys[i];
> +		if (ss->root == root)
> +			mutex_unlock(&ss->hierarchy_mutex);
> +	}
> +}
> +
Maybe no problem..but I don't like releasing lock in the order of acquiring lock.

	for (i = CGROUP_SUBSYS_COUNT - 1; i >=0; i--)  ?


-Kame


