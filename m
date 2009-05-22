Return-Path: <linux-kernel-owner+w=401wt.eu-S1756845AbZEVI1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845AbZEVI1a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 04:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751853AbZEVI1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 04:27:23 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56200 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbZEVI1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 04:27:22 -0400
Date: Fri, 22 May 2009 17:25:45 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH] cgroups: handle failure of cgroup_populate_dir() at
 mount/remount
Message-Id: <20090522172545.1e5e5f81.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4A16153C.2080004@cn.fujitsu.com>
References: <4A16153C.2080004@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 May 2009 11:00:12 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> Now we have 'stat' file in both memory and cpuacct subsystems. If we
> mount these 2 subsystems with option 'noprefix', the creation of 'stat'
> file for cpuacct will fail, but without any notificatin to the user.
> 
> With this patch, we fail the mount/remount in this case.
> 

Hm, shouldn't we allow "noprefix" to be effective only agaisnt cpuset ?
I think it's just for backward-compatibility of cpuset.
(I don't like the option at all.)

Thanks,
-Kame

> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/cgroup.c |   18 ++++++++++++++++--
>  1 files changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index a7267bf..eab83f7 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -896,6 +896,7 @@ static int parse_cgroupfs_options(char *data,
>  static int cgroup_remount(struct super_block *sb, int *flags, char *data)
>  {
>  	int ret = 0;
> +	unsigned long subsys_bits;
>  	struct cgroupfs_root *root = sb->s_fs_info;
>  	struct cgroup *cgrp = &root->top_cgroup;
>  	struct cgroup_sb_opts opts;
> @@ -914,12 +915,17 @@ static int cgroup_remount(struct super_block *sb, int *flags, char *data)
>  		goto out_unlock;
>  	}
>  
> +	subsys_bits = root->subsys_bits;
>  	ret = rebind_subsystems(root, opts.subsys_bits);
>  	if (ret)
>  		goto out_unlock;
>  
>  	/* (re)populate subsystem files */
> -	cgroup_populate_dir(cgrp);
> +	ret = cgroup_populate_dir(cgrp);
> +	if (ret) {
> +		rebind_subsystems(root, subsys_bits);
> +		goto out_unlock;
> +	}
>  
>  	if (opts.release_agent)
>  		strcpy(root->release_agent_path, opts.release_agent);
> @@ -1122,9 +1128,13 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
>  		BUG_ON(!list_empty(&root_cgrp->children));
>  		BUG_ON(root->number_of_cgroups != 1);
>  
> -		cgroup_populate_dir(root_cgrp);
> +		ret = cgroup_populate_dir(root_cgrp);
> +
>  		mutex_unlock(&inode->i_mutex);
>  		mutex_unlock(&cgroup_mutex);
> +
> +		if (ret)
> +			goto drop_new_super;
>  	}
>  
>  	simple_set_mnt(mnt, sb);
> @@ -1803,6 +1813,10 @@ int cgroup_add_file(struct cgroup *cgrp,
>  		dput(dentry);
>  	} else
>  		error = PTR_ERR(dentry);
> +
> +	if (error)
> +		printk(KERN_WARNING "cgroup: Failed to create file '%s': %d\n",
> +		       name, error);
>  	return error;
>  }
>  
> -- 
> 1.5.4.rc3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

