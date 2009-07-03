Return-Path: <linux-kernel-owner+w=401wt.eu-S1757466AbZGCCbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466AbZGCCbw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 22:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbZGCCbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 22:31:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53927 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751475AbZGCCbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 22:31:43 -0400
Message-ID: <4A4D6DC4.10708@cn.fujitsu.com>
Date: Fri, 03 Jul 2009 10:32:36 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 1/9] [RFC] Support named cgroups hierarchies
References: <20090702020624.14469.47066.stgit@menage.mtv.corp.google.com> <20090702021057.14469.37548.stgit@menage.mtv.corp.google.com>
In-Reply-To: <20090702021057.14469.37548.stgit@menage.mtv.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

cgroup_set_super() is called with spinlock held, so we
can't do kmalloc(GFP_KERNEL).

sget(...)
{
	spin_lock(&sb_lock);
	...
	err = set(s, data);
	if (err) {
		spin_unlock(&sb_lock);
	...
}

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
