Return-Path: <linux-kernel-owner+w=401wt.eu-S933397AbXBCAQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933397AbXBCAQq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 19:16:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933398AbXBCAQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 19:16:46 -0500
Received: from smtp.osdl.org ([65.172.181.24]:46139 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933397AbXBCAQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 19:16:45 -0500
Date: Fri, 2 Feb 2007 16:16:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: akuster@mvista.com
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Nigel Cunningham <nigel@suspend2.net>
Subject: Re: [patch 1/1] PM: Adds remount fs ro at suspend
Message-Id: <20070202161611.cf8b4328.akpm@linux-foundation.org>
In-Reply-To: <20070202235132.EDBDF1C448@hermes.mvista.com>
References: <20070202235132.EDBDF1C448@hermes.mvista.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Feb 2007 13:50:10 -1000
akuster@mvista.com wrote:

> 
> 
> This adds the ability for the file system to remounted as read only during a
> system suspend.  Log the mount points so when the resume occurs, they can be 
> remounted back to their original states. This is so in an advent of a power
> failure, we try our best to keep data from being corrupted or lost.
> 

Well the code appears simple enough, but I've not previously heard anyone
express a need for this feature.  But I know how to cc people who might
have heard this.


Minor coding-style observations:

> 
> diff -puN fs/super.c~suspend_fs_ro fs/super.c
> --- linux-2.6_sdio/fs/super.c~suspend_fs_ro	2007-02-01 13:35:46.000000000 -1000
> +++ linux-2.6_sdio-akuster/fs/super.c	2007-02-01 13:35:50.000000000 -1000
> @@ -47,6 +47,70 @@ struct file_system_type *get_fs_type(con
>  LIST_HEAD(super_blocks);
>  DEFINE_SPINLOCK(sb_lock);
>  
> +#ifdef CONFIG_SUSPEND_REMOUNTFS
> +/*
> + * Code to preserve filesystem data during suspend.
> + */
> +
> +struct suspremount {
> +struct super_block *sb;
> +struct suspremount *next;
> +};

The fields of this struct need a leading tab.

The name "suspremount" might be unpopular.  suspend_remount_state would be
more kernely.


> +static struct suspremount *suspremount_list;
> +
> +void suspend_remount_log_fs(struct super_block *sb)
> +{
> +	struct suspremount *remountp;
> +
> +	if ((remountp = (struct suspremount *)
> +		kmalloc(sizeof(struct suspremount), GFP_KERNEL)) != NULL) {

The typecast is unneeded, and the compounded assign-and-test is not
preferred style.  So here, please use

	struct suspremount *remountp;

	remountp = kmalloc(sizeof(*remountp), GFP_KERNEL);
	if (remountp != NULL) {

> +
> +/*
> + * Remount filesystems prior to suspend, in case the
> + * power source is removed (ie, battery removed) or
> + * battery dies during suspend.
> + */
> +
> +void suspend_remount_all_fs_ro(void)
> +{
> +	suspremount_list = NULL;
> +	emergency_remount();
> +}
> +EXPORT_SYMBOL(suspend_remount_all_fs_ro);

Why is this exported to modules?

> +void resume_remount_fs_rw(void)
> +{
> +	struct suspremount *remountp;
> +
> +	remountp = suspremount_list;
> +
> +	while (remountp != NULL) {
> +		struct suspremount *tp;
> +		struct super_block *sb;
> +		int flags, ret;
> +
> +		sb = remountp->sb;
> +		flags = 0;
> +		if (sb->s_op && sb->s_op->remount_fs) {
> +			ret = sb->s_op->remount_fs(sb, &flags, NULL);
> +			if (ret) printk("resume_remount_rw: error %d\n", ret);

newline needed here.

super_block_operations.remount_fs() is supposed to be called under lock_super().
Some filesystems might go BUG over this, or something.   Was there a reason to
not do this?

> +		}
> +
> +		tp = remountp->next;
> +		kfree(remountp);
> +		remountp = tp;
> +	}
> +	suspremount_list = NULL;
> +}
> +EXPORT_SYMBOL(resume_remount_fs_rw);

Why the export?

All this code is singly-threaded at a much higher level (I hope), hence
that list doesn't need locking.  However a comment explaining this might be
good.

> @@ -613,6 +677,9 @@ int do_remount_sb(struct super_block *sb
>  		unlock_super(sb);
>  		if (retval)
>  			return retval;
> +#ifdef CONFIG_SUSPEND_REMOUNTFS
> +		suspend_remount_log_fs(sb);
> +#endif

We try to avoid putting ifdefs in C files.  So in a header file, do

struct super_block;
#ifdef CONFIG_SUSPEND_REMOUNTFS
extern void suspend_remount_log_fs(struct super_block *sb);
#else
static inline void suspend_remount_log_fs(struct super_block *sb) {}
#endif

> +#ifdef CONFIG_SUSPEND_REMOUNTFS
> +	/*
> +	* Remount filesystems prior to suspend, in case the
> +	* power source is removed (ie, battery removed) or
> +	* battery dies during suspend.
> +	*/
> +
> +	suspend_remount_all_fs_ro();
> +#endif

Ditto here.

> +#ifdef CONFIG_SUSPEND_REMOUNTFS
> +	resume_remount_fs_rw();
> +#endif

And here.


