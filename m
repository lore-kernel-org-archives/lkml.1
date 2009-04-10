Return-Path: <linux-kernel-owner+w=401wt.eu-S937378AbZDJAIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937378AbZDJAIb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 20:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760451AbZDJAIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 20:08:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52274 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754017AbZDJAIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 20:08:20 -0400
Date: Thu, 9 Apr 2009 17:06:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: serue@us.ibm.com, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
Subject: Re: [PATCH] devcgroup: skip superfluous checks when found the
 DEV_ALL elem
Message-Id: <20090409170610.9ee6e8e4.akpm@linux-foundation.org>
In-Reply-To: <49DAE8E4.2030106@cn.fujitsu.com>
References: <49DAE8E4.2030106@cn.fujitsu.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Apr 2009 13:47:16 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> While walking through the whitelist, if the DEV_ALL item is found,
> no more check is needed.
> 

It's unobvious whether this is a behavioural change, a bugfix or just a
speedup?

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

