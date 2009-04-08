Return-Path: <linux-kernel-owner+w=401wt.eu-S1759078AbZDHCzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759078AbZDHCzY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 22:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754014AbZDHCzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 22:55:09 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:43255 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833AbZDHCzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 22:55:08 -0400
Date: Tue, 7 Apr 2009 21:55:05 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH] devcgroup: skip superfluous checks when found the
	DEV_ALL elem
Message-ID: <20090408025505.GA28159@us.ibm.com>
References: <49DAE8E4.2030106@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49DAE8E4.2030106@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Li Zefan (lizf@cn.fujitsu.com):
> While walking through the whitelist, if the DEV_ALL item is found,
> no more check is needed.

Right, because the DEV_ALL item always has all permissions.


> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Acked-by: Serge Hallyn <serue@us.ibm.com>

thanks,
-serge

> ---
>  security/device_cgroup.c |   10 ++++++----
>  1 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/security/device_cgroup.c b/security/device_cgroup.c
> index 5fda7df..b8186ba 100644
> --- a/security/device_cgroup.c
> +++ b/security/device_cgroup.c
> @@ -490,7 +490,7 @@ int devcgroup_inode_permission(struct inode *inode, int mask)
> 
>  	list_for_each_entry_rcu(wh, &dev_cgroup->whitelist, list) {
>  		if (wh->type & DEV_ALL)
> -			goto acc_check;
> +			goto found;
>  		if ((wh->type & DEV_BLOCK) && !S_ISBLK(inode->i_mode))
>  			continue;
>  		if ((wh->type & DEV_CHAR) && !S_ISCHR(inode->i_mode))
> @@ -499,11 +499,12 @@ int devcgroup_inode_permission(struct inode *inode, int mask)
>  			continue;
>  		if (wh->minor != ~0 && wh->minor != iminor(inode))
>  			continue;
> -acc_check:
> +
>  		if ((mask & MAY_WRITE) && !(wh->access & ACC_WRITE))
>  			continue;
>  		if ((mask & MAY_READ) && !(wh->access & ACC_READ))
>  			continue;
> +found:
>  		rcu_read_unlock();
>  		return 0;
>  	}
> @@ -527,7 +528,7 @@ int devcgroup_inode_mknod(int mode, dev_t dev)
> 
>  	list_for_each_entry_rcu(wh, &dev_cgroup->whitelist, list) {
>  		if (wh->type & DEV_ALL)
> -			goto acc_check;
> +			goto found;
>  		if ((wh->type & DEV_BLOCK) && !S_ISBLK(mode))
>  			continue;
>  		if ((wh->type & DEV_CHAR) && !S_ISCHR(mode))
> @@ -536,9 +537,10 @@ int devcgroup_inode_mknod(int mode, dev_t dev)
>  			continue;
>  		if (wh->minor != ~0 && wh->minor != MINOR(dev))
>  			continue;
> -acc_check:
> +
>  		if (!(wh->access & ACC_MKNOD))
>  			continue;
> +found:
>  		rcu_read_unlock();
>  		return 0;
>  	}
> -- 
> 1.5.4.rc3
