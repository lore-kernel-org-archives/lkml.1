Return-Path: <linux-kernel-owner+w=401wt.eu-S1762345AbYF0Uad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762345AbYF0Uad (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 16:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760879AbYF0U3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 16:29:50 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:54013 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760584AbYF0U3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 16:29:48 -0400
Date: Fri, 27 Jun 2008 15:29:43 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Serge Hallyn <serue@us.ibm.com>
Subject: Re: [PATCH] devcgroup: relax white-list protection down to RCU
Message-ID: <20080627202943.GA13956@us.ibm.com>
References: <48651BDC.5030104@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48651BDC.5030104@openvz.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Pavel Emelyanov (xemul@openvz.org):
> Currently this list is protected with a simple spinlock, even
> for reading from one. This is OK, but can be better.
> 
> Actually I want it to be better very much, since after replacing
> the OpenVZ device permissions engine with the cgroup-based one
> I noticed, that we set 12 default device permissions for each newly
> created container (for /dev/null, full, terminals, ect devices),
> and people sometimes have up to 20 perms more, so traversing the
> ~30-40 elements list under a spinlock doesn't seem very good.
> 
> Here's the liter RCU protection for white-list.
> 
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
> 
> ---
> 
> diff --git a/security/device_cgroup.c b/security/device_cgroup.c
> index 4ea5836..9d940c3 100644
> --- a/security/device_cgroup.c
> +++ b/security/device_cgroup.c
> @@ -41,6 +41,7 @@ struct dev_whitelist_item {
>  	short type;
>  	short access;
>  	struct list_head list;
> +	struct rcu_head rcu;
>  };
> 
>  struct dev_cgroup {
> @@ -110,11 +111,19 @@ static int dev_whitelist_add(struct dev_cgroup *dev_cgroup,
> 
>  	memcpy(whcopy, wh, sizeof(*whcopy));
>  	spin_lock(&dev_cgroup->lock);
> -	list_add_tail(&whcopy->list, &dev_cgroup->whitelist);
> +	list_add_tail_rcu(&whcopy->list, &dev_cgroup->whitelist);
>  	spin_unlock(&dev_cgroup->lock);
>  	return 0;
>  }
> 
> +static void whitelist_item_free(struct rcu_head *rcu)
> +{
> +	struct dev_whitelist_item *item;
> +
> +	item = container_of(rcu, struct dev_whitelist_item, rcu);
> +	kfree(item);
> +}
> +
>  /*
>   * called under cgroup_lock()
>   * since the list is visible to other tasks, we need the spinlock also
> @@ -138,8 +147,8 @@ static void dev_whitelist_rm(struct dev_cgroup *dev_cgroup,
>  remove:
>  		walk->access &= ~wh->access;
>  		if (!walk->access) {
> -			list_del(&walk->list);
> -			kfree(walk);
> +			list_del_rcu(&walk->list);
> +			call_rcu(&walk->rcu, whitelist_item_free);

The only thing I'd suggest is that a call_rcu() really isn't necessary.
You'd avoid the rcu_head in each dev_whitelist_item if you just did

			synchronize_rcu();
			kfree(walk);

here.  Downside is you're keeping the cgroup_lock() a little longer
then...

But that's just an idea.  Whether you do that or not,

Acked-by: Serge Hallyn <serue@us.ibm.com>

Thanks for doing this.

-serge

>  		}
>  	}
>  	spin_unlock(&dev_cgroup->lock);
> @@ -246,15 +255,15 @@ static int devcgroup_seq_read(struct cgroup *cgroup, struct cftype *cft,
>  	struct dev_whitelist_item *wh;
>  	char maj[MAJMINLEN], min[MAJMINLEN], acc[ACCLEN];
> 
> -	spin_lock(&devcgroup->lock);
> -	list_for_each_entry(wh, &devcgroup->whitelist, list) {
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(wh, &devcgroup->whitelist, list) {
>  		set_access(acc, wh->access);
>  		set_majmin(maj, wh->major);
>  		set_majmin(min, wh->minor);
>  		seq_printf(m, "%c %s:%s %s\n", type_to_char(wh->type),
>  			   maj, min, acc);
>  	}
> -	spin_unlock(&devcgroup->lock);
> +	rcu_read_unlock();
> 
>  	return 0;
>  }
> @@ -516,8 +525,8 @@ int devcgroup_inode_permission(struct inode *inode, int mask)
>  	if (!dev_cgroup)
>  		return 0;
> 
> -	spin_lock(&dev_cgroup->lock);
> -	list_for_each_entry(wh, &dev_cgroup->whitelist, list) {
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(wh, &dev_cgroup->whitelist, list) {
>  		if (wh->type & DEV_ALL)
>  			goto acc_check;
>  		if ((wh->type & DEV_BLOCK) && !S_ISBLK(inode->i_mode))
> @@ -533,10 +542,10 @@ acc_check:
>  			continue;
>  		if ((mask & MAY_READ) && !(wh->access & ACC_READ))
>  			continue;
> -		spin_unlock(&dev_cgroup->lock);
> +		rcu_read_unlock();
>  		return 0;
>  	}
> -	spin_unlock(&dev_cgroup->lock);
> +	rcu_read_unlock();
> 
>  	return -EPERM;
>  }
> @@ -552,7 +561,7 @@ int devcgroup_inode_mknod(int mode, dev_t dev)
>  	if (!dev_cgroup)
>  		return 0;
> 
> -	spin_lock(&dev_cgroup->lock);
> +	rcu_read_lock();
>  	list_for_each_entry(wh, &dev_cgroup->whitelist, list) {
>  		if (wh->type & DEV_ALL)
>  			goto acc_check;
> @@ -567,9 +576,9 @@ int devcgroup_inode_mknod(int mode, dev_t dev)
>  acc_check:
>  		if (!(wh->access & ACC_MKNOD))
>  			continue;
> -		spin_unlock(&dev_cgroup->lock);
> +		rcu_read_unlock();
>  		return 0;
>  	}
> -	spin_unlock(&dev_cgroup->lock);
> +	rcu_read_unlock();
>  	return -EPERM;
>  }
