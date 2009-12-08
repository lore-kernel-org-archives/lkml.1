Return-Path: <linux-kernel-owner+w=401wt.eu-S1754216AbZLHHjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbZLHHjI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 02:39:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbZLHHjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 02:39:07 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53420 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753448AbZLHHjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 02:39:06 -0500
Message-ID: <4B1E0283.70108@cn.fujitsu.com>
Date: Tue, 08 Dec 2009 15:38:43 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ben Blum <bblum@andrew.cmu.edu>
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, menage@google.com
Subject: Re: [RFC] [PATCH 1/5] cgroups: revamp subsys array
References: <20091204085349.GA18867@andrew.cmu.edu> <20091204085508.GA18912@andrew.cmu.edu>
In-Reply-To: <20091204085508.GA18912@andrew.cmu.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -1291,6 +1324,7 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
>  	struct cgroupfs_root *new_root;
>  
>  	/* First find the desired set of subsystems */
> +	down_read(&subsys_mutex);

Hmm.. this can lead to deadlock. sget() returns success with sb->s_umount
held, so here we have:

	down_read(&subsys_mutex);

	down_write(&sb->s_umount);

On the other hand, sb->s_umount is held before calling kill_sb(),
so when umounting we have:

	down_write(&sb->s_umount);

	down_read(&subsys_mutex);

>  	ret = parse_cgroupfs_options(data, &opts);
>  	if (ret)
>  		goto out_err;
> @@ -1367,6 +1401,8 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
>  			free_cg_links(&tmp_cg_links);
>  			goto drop_new_super;
>  		}
> +		/* done with subsys stuff and no other failure case */
> +		up_read(&subsys_mutex);
>  
>  		/* EBUSY should be the only error here */
>  		BUG_ON(ret);
> @@ -1415,6 +1451,7 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
>   drop_new_super:
>  	deactivate_locked_super(sb);
>   out_err:
> +	up_read(&subsys_mutex);
>  	kfree(opts.release_agent);
>  	kfree(opts.name);
>  
> @@ -1434,10 +1471,12 @@ static void cgroup_kill_sb(struct super_block *sb) {
>  	BUG_ON(!list_empty(&cgrp->children));
>  	BUG_ON(!list_empty(&cgrp->sibling));
>  
> +	down_read(&subsys_mutex);
>  	mutex_lock(&cgroup_mutex);
>  
>  	/* Rebind all subsystems back to the default hierarchy */
>  	ret = rebind_subsystems(root, 0);
> +	up_read(&subsys_mutex);
>  	/* Shouldn't be able to fail ... */
>  	BUG_ON(ret);
>  


