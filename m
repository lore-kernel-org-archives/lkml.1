Return-Path: <linux-kernel-owner+w=401wt.eu-S1756438AbZCLST0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438AbZCLST0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 14:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbZCLSTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 14:19:17 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:33925 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbZCLSTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 14:19:16 -0400
Date: Thu, 12 Mar 2009 13:19:12 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH] devcgroup: avoid using cgroup_lock
Message-ID: <20090312181912.GA20144@us.ibm.com>
References: <49B869BB.7030907@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B869BB.7030907@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Li Zefan (lizf@cn.fujitsu.com):
> There is nothing special that has to be protected by cgroup_lock,
> so introduce devcgroup_mtuex for it's own use.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  security/device_cgroup.c |   21 +++++++++++++--------
>  1 files changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/security/device_cgroup.c b/security/device_cgroup.c
> index 3aacd0f..5fda7df 100644
> --- a/security/device_cgroup.c
> +++ b/security/device_cgroup.c
> @@ -11,6 +11,7 @@
>  #include <linux/uaccess.h>
>  #include <linux/seq_file.h>
>  #include <linux/rcupdate.h>
> +#include <linux/mutex.h>
> 
>  #define ACC_MKNOD 1
>  #define ACC_READ  2
> @@ -21,9 +22,11 @@
>  #define DEV_CHAR  2
>  #define DEV_ALL   4  /* this represents all devices */
> 
> +static DEFINE_MUTEX(devcgroup_mutex);
> +
>  /*
>   * whitelist locking rules:
> - * hold cgroup_lock() for update/read.
> + * hold devcgroup_mutex for update/read.
>   * hold rcu_read_lock() for read.
>   */
> 
> @@ -67,7 +70,7 @@ static int devcgroup_can_attach(struct cgroup_subsys *ss,
>  }
> 
>  /*
> - * called under cgroup_lock()
> + * called under devcgroup_mutex
>   */
>  static int dev_whitelist_copy(struct list_head *dest, struct list_head *orig)
>  {
> @@ -92,7 +95,7 @@ free_and_exit:
> 
>  /* Stupid prototype - don't bother combining existing entries */
>  /*
> - * called under cgroup_lock()
> + * called under devcgroup_mutex
>   */
>  static int dev_whitelist_add(struct dev_cgroup *dev_cgroup,
>  			struct dev_whitelist_item *wh)
> @@ -130,7 +133,7 @@ static void whitelist_item_free(struct rcu_head *rcu)
>  }
> 
>  /*
> - * called under cgroup_lock()
> + * called under devcgroup_mutex
>   */
>  static void dev_whitelist_rm(struct dev_cgroup *dev_cgroup,
>  			struct dev_whitelist_item *wh)
> @@ -185,8 +188,10 @@ static struct cgroup_subsys_state *devcgroup_create(struct cgroup_subsys *ss,
>  		list_add(&wh->list, &dev_cgroup->whitelist);
>  	} else {
>  		parent_dev_cgroup = cgroup_to_devcgroup(parent_cgroup);
> +		mutex_lock(&devcgroup_mutex);
>  		ret = dev_whitelist_copy(&dev_cgroup->whitelist,
>  				&parent_dev_cgroup->whitelist);
> +		mutex_unlock(&devcgroup_mutex);
>  		if (ret) {
>  			kfree(dev_cgroup);
>  			return ERR_PTR(ret);
> @@ -273,7 +278,7 @@ static int devcgroup_seq_read(struct cgroup *cgroup, struct cftype *cft,
>   * does the access granted to dev_cgroup c contain the access
>   * requested in whitelist item refwh.
>   * return 1 if yes, 0 if no.
> - * call with c->lock held
> + * call with devcgroup_mutex held
>   */
>  static int may_access_whitelist(struct dev_cgroup *c,
>  				       struct dev_whitelist_item *refwh)
> @@ -426,11 +431,11 @@ static int devcgroup_access_write(struct cgroup *cgrp, struct cftype *cft,
>  				  const char *buffer)
>  {
>  	int retval;
> -	if (!cgroup_lock_live_group(cgrp))

Does it matter that we no longer check for cgroup_is_removed()?

> -		return -ENODEV;
> +
> +	mutex_lock(&devcgroup_mutex);
>  	retval = devcgroup_update_access(cgroup_to_devcgroup(cgrp),
>  					 cft->private, buffer);
> -	cgroup_unlock();
> +	mutex_unlock(&devcgroup_mutex);
>  	return retval;
>  }
> 
> -- 
> 1.5.4.rc3
