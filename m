Return-Path: <linux-kernel-owner+w=401wt.eu-S1754966AbYLKG36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966AbYLKG36 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 01:29:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbYLKG3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 01:29:48 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:55461 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbYLKG3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 01:29:47 -0500
Date: Thu, 11 Dec 2008 11:59:40 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: menage@google.com
Cc: kamezawa.hiroyu@jp.fujitsu.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [RFC][PATCH 1/3] CGroups: Add a per-subsystem hierarchy_mutex
Message-ID: <20081211062940.GJ3008@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: menage@google.com, kamezawa.hiroyu@jp.fujitsu.com,
	containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20081210233654.563182000@menage.corp.google.com> <20081210234432.065445000@menage.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20081210234432.065445000@menage.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* menage@google.com <menage@google.com> [2008-12-10 15:36:55]:

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
> Thus if the subsystem holds its own hierarchy_mutex, it can safely
> traverse its own hierarchy.
>

Ths sounds reasonable, a further abstraction in the future could be to
provide the visitor pattern. Allow cgroups to do the walking and have
callbacks called during the visit.
 
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
>  /*
>   * cgroup_create - create a cgroup
>   * @parent: cgroup that will be parent of the new cgroup
> @@ -2374,7 +2400,9 @@ static long cgroup_create(struct cgroup 
>  		init_cgroup_css(css, ss, cgrp);
>  	}
> 
> +	cgroup_lock_hierarchy(root);
>  	list_add(&cgrp->sibling, &cgrp->parent->children);
> +	cgroup_unlock_hierarchy(root);
>  	root->number_of_cgroups++;
> 
>  	err = cgroup_create_dir(cgrp, dentry, mode);
> @@ -2492,8 +2520,12 @@ static int cgroup_rmdir(struct inode *un
>  	if (!list_empty(&cgrp->release_list))
>  		list_del(&cgrp->release_list);
>  	spin_unlock(&release_list_lock);
> -	/* delete my sibling from parent->children */
> +
> +	cgroup_lock_hierarchy(cgrp->root);
> +	/* delete this cgroup from parent->children */
>  	list_del(&cgrp->sibling);
> +	cgroup_unlock_hierarchy(cgrp->root);
> +
>  	spin_lock(&cgrp->dentry->d_lock);
>  	d = dget(cgrp->dentry);
>  	spin_unlock(&d->d_lock);
> @@ -2535,6 +2567,7 @@ static void __init cgroup_init_subsys(st
>  	 * need to invoke fork callbacks here. */
>  	BUG_ON(!list_empty(&init_task.tasks));
> 
> +	mutex_init(&ss->hierarchy_mutex);
>  	ss->active = 1;
>  }
> 
> Index: hierarchy_lock-mmotm-2008-12-09/Documentation/cgroups/cgroups.txt
> ===================================================================
> --- hierarchy_lock-mmotm-2008-12-09.orig/Documentation/cgroups/cgroups.txt
> +++ hierarchy_lock-mmotm-2008-12-09/Documentation/cgroups/cgroups.txt
> @@ -528,7 +528,7 @@ example in cpusets, no task may attach b
>  up.
> 
>  void bind(struct cgroup_subsys *ss, struct cgroup *root)
> -(cgroup_mutex held by caller)
> +(cgroup_mutex and ss->hierarchy_mutex held by caller)
>

Seems reasonable, I was wondering if instead of acquiring a mutex per
subsystem that shares the root, if we can collapse it to a single
mutex and prevent cgroup from changing binding. Those are
optimizations that we can think of later

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com> 

-- 
	Balbir
