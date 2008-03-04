Return-Path: <linux-kernel-owner+w=401wt.eu-S932388AbYCDQjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388AbYCDQjO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 11:39:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765706AbYCDQeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 11:34:00 -0500
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:46306 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765683AbYCDQdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:33:55 -0500
Date: Tue, 4 Mar 2008 22:03:39 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Holger Kiehl <Holger.Kiehl@dwd.de>, linux-kernel@vger.kernel.org,
       vatsa@linux.vnet.ibm.com, mingo@elte.hu, gregkh@suse.de
Subject: Re: sysfs: duplicate filename '74' can not be created
Message-ID: <20080304163339.GA11160@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20080304160940.GC19059@localhost.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080304160940.GC19059@localhost.sw.ru>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2008 at 07:09:40PM +0300, Alexey Dobriyan wrote:
> [Cc'ing /sys/kernel/uids guys]
> 

[Also adding gregkh to the cc :)]

> > Mar  3 13:50:01 helena kernel: sysfs: duplicate filename '74' can not be created
> > Mar  3 13:50:01 helena kernel: WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
> > Mar  3 13:50:01 helena kernel: Pid: 21911, comm: sshd Not tainted 2.6.24.3 #1
> 
> I see only one suspicious place: KOBJ_ADD is sent even if sysfs file
> creation failed and kobject is happily removed. But this almost
> certainly separate bug.
> 
> 
> 
> You can try this debugging patch. Post several first consecutive messages.
> [crosses fingers]
> 
> --- a/kernel/user.c
> +++ b/kernel/user.c
> @@ -179,8 +179,11 @@ static int user_kobject_create(struct user_struct *up)
>  		goto done;
> 
>  	error = sysfs_create_file(kobj, &up->user_attr.attr);
> -	if (error)
> +	if (error) {
> +		printk("%s: %p->uid = %d\n", __func__, up, up->uid);
> +		WARN_ON(1);
>  		kobject_del(kobj);
> +	}
> 
>  	kobject_uevent(kobj, KOBJ_ADD);
> 
> @@ -363,6 +366,7 @@ struct user_struct * alloc_uid(struct user_namespace *ns, uid_t uid)
>  		}
> 
>  		if (sched_create_user(new) < 0) {
> +			WARN_ON(1);
>  			key_put(new->uid_keyring);
>  			key_put(new->session_keyring);
>  			kmem_cache_free(uid_cachep, new);
> @@ -371,6 +375,7 @@ struct user_struct * alloc_uid(struct user_namespace *ns, uid_t uid)
>  		}
> 
>  		if (user_kobject_create(new)) {
> +			WARN_ON(1);
>  			sched_destroy_user(new);
>  			key_put(new->uid_keyring);
>  			key_put(new->session_keyring);
> @@ -386,6 +391,10 @@ struct user_struct * alloc_uid(struct user_namespace *ns, uid_t uid)
>  		spin_lock_irq(&uidhash_lock);
>  		up = uid_hash_find(uid, hashent);
>  		if (up) {
> +#ifdef CONFIG_FAIR_USER_SCHED
> +			printk("%s: %p->uid = %d\n", __func__, up, up->uid);
> +			WARN_ON(1);
> +#endif
>  			/* This case is not possible when CONFIG_FAIR_USER_SCHED
>  			 * is defined, since we serialize alloc_uid() using
>  			 * uids_mutex. Hence no need to call
> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
> index 7af90fc..3479c55 100644
> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c
> @@ -32,6 +32,8 @@ static struct user_namespace *clone_user_ns(struct user_namespace *old_ns)
>  	struct user_struct *new_user;
>  	int n;
> 
> +	printk("%s: ENTER\n", __func__);
> +
>  	ns = kmalloc(sizeof(struct user_namespace), GFP_KERNEL);
>  	if (!ns)
>  		return ERR_PTR(-ENOMEM);

-- 
regards,
Dhaval
