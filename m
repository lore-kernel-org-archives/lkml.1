Return-Path: <linux-kernel-owner+w=401wt.eu-S1755422AbZGBCaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422AbZGBCaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 22:30:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbZGBC34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 22:29:56 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51360 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632AbZGBC3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 22:29:55 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 2 Jul 2009 11:28:14 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Paul Menage <menage@google.com>
Cc: lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org
Subject: Re: [PATCH 1/9] [RFC] Support named cgroups hierarchies
Message-Id: <20090702112814.ddf0c280.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090702021057.14469.37548.stgit@menage.mtv.corp.google.com>
References: <20090702020624.14469.47066.stgit@menage.mtv.corp.google.com>
	<20090702021057.14469.37548.stgit@menage.mtv.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Jul 2009 19:10:58 -0700
Paul Menage <menage@google.com> wrote:

> [RFC] Support named cgroups hierarchies
> 
> To simplify referring to cgroup hierarchies in mount statements, and
> to allow disambiguation in the presence of empty hierarchies and
> multiply-bindable subsystems (see later patches in series) this patch
> adds support for naming a new cgroup hierarchy via the "name=" mount
> option
> 
> A pre-existing hierarchy may be specified by either name or by
> subsystems; a hierarchy's name cannot be changed by a remount
> operation.
> 
> Example usage:
> 
> # To create a hierarchy called "foo" containing the "cpu" subsystem
> mount -t cgroup -oname=foo,cpu cgroup /mnt/cgroup1
> 
> # To mount the "foo" hierarchy on a second location
> mount -t cgroup -oname=foo cgroup /mnt/cgroup2
> 
> Open issues:
> 
> - should the specification be via a name= option as in this patch, or
>   should we simply use the "device name" as passed to the mount()
>   system call?  Using the device name is more conceptually clean and
>   consistent with the filesystem API; however, given that the device
>   name is currently ignored by cgroups, this would lead to a
>   user-visible behaviour change.
> 

IMHO, name= option is good because people think device name for pseudo file
system has no meanings. I think just leaving it as "no meaning" is better.



> Signed-off-by: Paul Menage <menage@google.com>
> 
> ---
> 
>  kernel/cgroup.c |  136 ++++++++++++++++++++++++++++++++++++-------------------
>  1 files changed, 88 insertions(+), 48 deletions(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index ea255fe..940f28d 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -59,6 +59,8 @@ static struct cgroup_subsys *subsys[] = {
>  #include <linux/cgroup_subsys.h>
>  };
>  
> +#define MAX_CGROUP_ROOT_NAMELEN 64
> +

I don't like long names but....isn't this too short ? How about NAME_MAX ?


>  /*
>   * A cgroupfs_root represents the root of a cgroup hierarchy,
>   * and may be associated with a superblock to form an active
> @@ -93,6 +95,9 @@ struct cgroupfs_root {
>  
>  	/* The path to use for release notifications. */
>  	char release_agent_path[PATH_MAX];
> +
> +	/* The name for this hierarchy - may be empty */
> +	char name[MAX_CGROUP_ROOT_NAMELEN];
>  };
>  
If you don't want to make cgroupfs_root bigger,

	cgroupfs_root {
		......
		/* this must be the bottom of struct */
		char name[0];
	}

Is a choice.

BTW, reading a patch, any kind of charactors are allowed ?

Thanks,
-Kame


>  /*
> @@ -828,6 +833,8 @@ static int cgroup_show_options(struct seq_file *seq, struct vfsmount *vfs)
>  		seq_puts(seq, ",noprefix");
>  	if (strlen(root->release_agent_path))
>  		seq_printf(seq, ",release_agent=%s", root->release_agent_path);
> +	if (strlen(root->name))
> +		seq_printf(seq, ",name=%s", root->name);
>  	mutex_unlock(&cgroup_mutex);
>  	return 0;
>  }
> @@ -836,12 +843,15 @@ struct cgroup_sb_opts {
>  	unsigned long subsys_bits;
>  	unsigned long flags;
>  	char *release_agent;
> +	char *name;
> +	/* A flag indicating that a root was created from this options block */
> +	bool created_root;
>  };
>  
>  /* Convert a hierarchy specifier into a bitmask of subsystems and
>   * flags. */
>  static int parse_cgroupfs_options(char *data,
> -				     struct cgroup_sb_opts *opts)
> +				  struct cgroup_sb_opts *opts)
>  {
>  	char *token, *o = data ?: "all";
>  	unsigned long mask = (unsigned long)-1;
> @@ -850,9 +860,7 @@ static int parse_cgroupfs_options(char *data,
>  	mask = ~(1UL << cpuset_subsys_id);
>  #endif
>  
> -	opts->subsys_bits = 0;
> -	opts->flags = 0;
> -	opts->release_agent = NULL;
> +	memset(opts, 0, sizeof(*opts));
>  
>  	while ((token = strsep(&o, ",")) != NULL) {
>  		if (!*token)
> @@ -872,11 +880,19 @@ static int parse_cgroupfs_options(char *data,
>  			/* Specifying two release agents is forbidden */
>  			if (opts->release_agent)
>  				return -EINVAL;
> -			opts->release_agent = kzalloc(PATH_MAX, GFP_KERNEL);
> +			opts->release_agent =
> +				kstrndup(token + 14, PATH_MAX, GFP_KERNEL);
>  			if (!opts->release_agent)
>  				return -ENOMEM;
> -			strncpy(opts->release_agent, token + 14, PATH_MAX - 1);
> -			opts->release_agent[PATH_MAX - 1] = 0;
> +		} else if (!strncmp(token, "name=", 5)) {
> +			/* Specifying two names is forbidden */
> +			if (opts->name)
> +				return -EINVAL;
> +			opts->name = kstrndup(token + 5,
> +					      MAX_CGROUP_ROOT_NAMELEN,
> +					      GFP_KERNEL);
> +			if (!opts->name)
> +				return -ENOMEM;
>  		} else {
>  			struct cgroup_subsys *ss;
>  			int i;
> @@ -903,7 +919,7 @@ static int parse_cgroupfs_options(char *data,
>  		return -EINVAL;
>  
>  	/* We can't have an empty hierarchy */
> -	if (!opts->subsys_bits)
> +	if (!opts->subsys_bits && !opts->name)
>  		return -EINVAL;
>  
>  	return 0;
> @@ -931,6 +947,12 @@ static int cgroup_remount(struct super_block *sb, int *flags, char *data)
>  		goto out_unlock;
>  	}
>  
> +	/* Don't allow name to change at remount */
> +	if (opts.name && strcmp(opts.name, root->name)) {
> +		ret = -EINVAL;
> +		goto out_unlock;
> +	}
> +
>  	ret = rebind_subsystems(root, opts.subsys_bits);
>  	if (ret)
>  		goto out_unlock;
> @@ -942,6 +964,7 @@ static int cgroup_remount(struct super_block *sb, int *flags, char *data)
>  		strcpy(root->release_agent_path, opts.release_agent);
>   out_unlock:
>  	kfree(opts.release_agent);
> +	kfree(opts.name);
>  	mutex_unlock(&cgroup_mutex);
>  	mutex_unlock(&cgrp->dentry->d_inode->i_mutex);
>  	unlock_kernel();
> @@ -963,6 +986,7 @@ static void init_cgroup_housekeeping(struct cgroup *cgrp)
>  	INIT_LIST_HEAD(&cgrp->release_list);
>  	init_rwsem(&cgrp->pids_mutex);
>  }
> +
>  static void init_cgroup_root(struct cgroupfs_root *root)
>  {
>  	struct cgroup *cgrp = &root->top_cgroup;
> @@ -976,28 +1000,56 @@ static void init_cgroup_root(struct cgroupfs_root *root)
>  
>  static int cgroup_test_super(struct super_block *sb, void *data)
>  {
> -	struct cgroupfs_root *new = data;
> +	struct cgroup_sb_opts *new = data;
>  	struct cgroupfs_root *root = sb->s_fs_info;
>  
> -	/* First check subsystems */
> -	if (new->subsys_bits != root->subsys_bits)
> -	    return 0;
> +	/* If we asked for a name then it must match */
> +	if (new->name && strcmp(new->name, root->name))
> +		return 0;
>  
> -	/* Next check flags */
> -	if (new->flags != root->flags)
> +	/* If we asked for subsystems then they must match */
> +	if (new->subsys_bits && new->subsys_bits != root->subsys_bits)
>  		return 0;
>  
>  	return 1;
>  }
>  
> +static struct cgroupfs_root *cgroup_root_from_opts(struct cgroup_sb_opts *opts)
> +{
> +	struct cgroupfs_root *root;
> +
> +	if (!opts->subsys_bits)
> +		return ERR_PTR(-EINVAL);
> +
> +	root = kzalloc(sizeof(*root), GFP_KERNEL);
> +	if (!root)
> +		return ERR_PTR(-ENOMEM);
> +
> +	init_cgroup_root(root);
> +	root->subsys_bits = opts->subsys_bits;
> +	root->flags = opts->flags;
> +	if (opts->release_agent)
> +		strcpy(root->release_agent_path, opts->release_agent);
> +	if (opts->name)
> +		strcpy(root->name, opts->name);
> +	opts->created_root = true;
> +	return root;
> +}
> +
>  static int cgroup_set_super(struct super_block *sb, void *data)
>  {
>  	int ret;
> -	struct cgroupfs_root *root = data;
> +	struct cgroup_sb_opts *opts = data;
> +	struct cgroupfs_root *root;
>  
> +	root = cgroup_root_from_opts(opts);
> +	if (IS_ERR(root))
> +		return PTR_ERR(root);
>  	ret = set_anon_super(sb, NULL);
> -	if (ret)
> +	if (ret) {
> +		kfree(root);
>  		return ret;
> +	}
>  
>  	sb->s_fs_info = root;
>  	root->sb = sb;
> @@ -1039,44 +1091,23 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
>  	struct cgroup_sb_opts opts;
>  	int ret = 0;
>  	struct super_block *sb;
> -	struct cgroupfs_root *root;
> -	struct list_head tmp_cg_links;
>  
>  	/* First find the desired set of subsystems */
>  	ret = parse_cgroupfs_options(data, &opts);
> -	if (ret) {
> -		kfree(opts.release_agent);
> -		return ret;
> -	}
> -
> -	root = kzalloc(sizeof(*root), GFP_KERNEL);
> -	if (!root) {
> -		kfree(opts.release_agent);
> -		return -ENOMEM;
> -	}
> -
> -	init_cgroup_root(root);
> -	root->subsys_bits = opts.subsys_bits;
> -	root->flags = opts.flags;
> -	if (opts.release_agent) {
> -		strcpy(root->release_agent_path, opts.release_agent);
> -		kfree(opts.release_agent);
> -	}
> +	if (ret)
> +		goto out_err;
>  
> -	sb = sget(fs_type, cgroup_test_super, cgroup_set_super, root);
> +	sb = sget(fs_type, cgroup_test_super, cgroup_set_super, &opts);
>  
>  	if (IS_ERR(sb)) {
> -		kfree(root);
> -		return PTR_ERR(sb);
> +		ret = PTR_ERR(sb);
> +		goto out_err;
>  	}
>  
> -	if (sb->s_fs_info != root) {
> -		/* Reusing an existing superblock */
> -		BUG_ON(sb->s_root == NULL);
> -		kfree(root);
> -		root = NULL;
> -	} else {
> +	if (opts.created_root) {
>  		/* New superblock */
> +		struct cgroupfs_root *root = sb->s_fs_info;
> +		struct list_head tmp_cg_links;
>  		struct cgroup *root_cgrp = &root->top_cgroup;
>  		struct inode *inode;
>  		int i;
> @@ -1109,7 +1140,8 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
>  		if (ret == -EBUSY) {
>  			mutex_unlock(&cgroup_mutex);
>  			mutex_unlock(&inode->i_mutex);
> -			goto free_cg_links;
> +			free_cg_links(&tmp_cg_links);
> +			goto drop_new_super;
>  		}
>  
>  		/* EBUSY should be the only error here */
> @@ -1146,12 +1178,17 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
>  	}
>  
>  	simple_set_mnt(mnt, sb);
> +	kfree(opts.release_agent);
> +	kfree(opts.name);
>  	return 0;
>  
> - free_cg_links:
> -	free_cg_links(&tmp_cg_links);
>   drop_new_super:
>  	deactivate_locked_super(sb);
> +
> + out_err:
> +	kfree(opts.release_agent);
> +	kfree(opts.name);
> +
>  	return ret;
>  }
>  
> @@ -2923,6 +2960,9 @@ static int proc_cgroup_show(struct seq_file *m, void *v)
>  		seq_printf(m, "%lu:", root->subsys_bits);
>  		for_each_subsys(root, ss)
>  			seq_printf(m, "%s%s", count++ ? "," : "", ss->name);
> +		if (strlen(root->name))
> +			seq_printf(m, "%sname=%s",
> +				   count ? "," : "", root->name);
>  		seq_putc(m, ':');
>  		get_first_subsys(&root->top_cgroup, NULL, &subsys_id);
>  		cgrp = task_cgroup(tsk, subsys_id);
> 
> 

