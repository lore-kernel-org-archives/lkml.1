Return-Path: <linux-kernel-owner+w=401wt.eu-S1755565AbYHYQou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbYHYQou (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 12:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753833AbYHYQom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 12:44:42 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:39179 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753940AbYHYQom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 12:44:42 -0400
Date: Mon, 25 Aug 2008 11:43:04 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH] devcgroup: fix race against rmdir()
Message-ID: <20080825164304.GA13583@us.ibm.com>
References: <48B2174E.9060608@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B2174E.9060608@cn.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Li Zefan (lizf@cn.fujitsu.com):
> During the use of a dev_cgroup, we should guarantee the corresponding
> cgroup won't be deleted (i.e. via rmdir). This can be done through
> css_get(&dev_cgroup->css), but here we can just get and use the
> dev_cgroup under rcu_read_lock.
> 
> And also remove checking NULL dev_cgroup, it won't be NULL since a task
> always belongs to a cgroup.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Looks good.  Thanks, Li.

Acked-by: Serge Hallyn <serue@us.ibm.com>

> ---
>  security/device_cgroup.c |   18 +++++++++---------
>  1 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/security/device_cgroup.c b/security/device_cgroup.c
> index 7bd296c..46f2397 100644
> --- a/security/device_cgroup.c
> +++ b/security/device_cgroup.c
> @@ -508,12 +508,11 @@ int devcgroup_inode_permission(struct inode *inode, int mask)
>  		return 0;
>  	if (!S_ISBLK(inode->i_mode) && !S_ISCHR(inode->i_mode))
>  		return 0;
> -	dev_cgroup = css_to_devcgroup(task_subsys_state(current,
> -				devices_subsys_id));
> -	if (!dev_cgroup)
> -		return 0;
> 
>  	rcu_read_lock();
> +
> +	dev_cgroup = task_devcgroup(current);
> +
>  	list_for_each_entry_rcu(wh, &dev_cgroup->whitelist, list) {
>  		if (wh->type & DEV_ALL)
>  			goto acc_check;
> @@ -533,6 +532,7 @@ acc_check:
>  		rcu_read_unlock();
>  		return 0;
>  	}
> +
>  	rcu_read_unlock();
> 
>  	return -EPERM;
> @@ -543,12 +543,10 @@ int devcgroup_inode_mknod(int mode, dev_t dev)
>  	struct dev_cgroup *dev_cgroup;
>  	struct dev_whitelist_item *wh;
> 
> -	dev_cgroup = css_to_devcgroup(task_subsys_state(current,
> -				devices_subsys_id));
> -	if (!dev_cgroup)
> -		return 0;
> -
>  	rcu_read_lock();
> +
> +	dev_cgroup = task_devcgroup(current);
> +
>  	list_for_each_entry(wh, &dev_cgroup->whitelist, list) {
>  		if (wh->type & DEV_ALL)
>  			goto acc_check;
> @@ -566,6 +564,8 @@ acc_check:
>  		rcu_read_unlock();
>  		return 0;
>  	}
> +
>  	rcu_read_unlock();
> +
>  	return -EPERM;
>  }
> -- 
> 1.5.4.rc3
