Return-Path: <linux-kernel-owner+w=401wt.eu-S1753795AbZDYDVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795AbZDYDVA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 23:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752690AbZDYDUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 23:20:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42221 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbZDYDUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 23:20:49 -0400
Date: Sat, 25 Apr 2009 04:20:49 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: npiggin@suse.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch 01/27] fs: cleanup files_lock
Message-ID: <20090425032049.GT8633@ZenIV.linux.org.uk>
References: <20090425012020.457460929@suse.de> <20090425012209.061706790@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090425012209.061706790@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Alan Cc'ed due to tty part of it]

On Sat, Apr 25, 2009 at 11:20:21AM +1000, npiggin@suse.de wrote:

>  	set_bit(TTY_PTY_LOCK, &tty->flags); /* LOCK THE SLAVE */
>  	filp->private_data = tty;
> -	file_move(filp, &tty->tty_files);
> +
> +	mutex_lock(&tty_mutex);
> +	file_list_del(filp);
> +	list_add(&filp->f_u.fu_list, &tty->tty_files);
> +	mutex_unlock(&tty_mutex);

Is there any problem with just shifting mutex_unlock down from several lines
above?


(in do_tty_hangup)
> +	mutex_lock(&tty_mutex);
> +
>  	/* inuse_filps is protected by the single kernel lock */
>  	lock_kernel();

isn't it too early?

> @@ -553,8 +566,7 @@ static void do_tty_hangup(struct work_st
>  	}
>  	spin_unlock(&redirect_lock);
>  
> -	check_tty_count(tty, "do_tty_hangup");
> -	file_list_lock();

i.e. why not here?

> +	__check_tty_count(tty, "do_tty_hangup");
>  	/* This breaks for file handles being sent over AF_UNIX sockets ? */
>  	list_for_each_entry(filp, &tty->tty_files, f_u.fu_list) {
>  		if (filp->f_op->write == redirected_tty_write)

> @@ -1467,9 +1479,9 @@ static void release_one_tty(struct kref
>  	tty_driver_kref_put(driver);
>  	module_put(driver->owner);
>  
> -	file_list_lock();
> +	mutex_lock(&tty_mutex);
>  	list_del_init(&tty->tty_files);
> -	file_list_unlock();
> +	mutex_unlock(&tty_mutex);

Umm... why is it safe from the deadlock POV?

> @@ -1836,8 +1849,12 @@ got_driver:
>  		return PTR_ERR(tty);
>  
>  	filp->private_data = tty;
> -	file_move(filp, &tty->tty_files);
> -	check_tty_count(tty, "tty_open");
> +	mutex_lock(&tty_mutex);
> +	BUG_ON(list_empty(&filp->f_u.fu_list));
> +	file_list_del(filp); /* __dentry_open has put it on the sb list */
> +	list_add(&filp->f_u.fu_list, &tty->tty_files);
> +	__check_tty_count(tty, "tty_open");
> +	mutex_unlock(&tty_mutex);

a) why not simply shift mutex_unlock from several lines above?
b) that code really looks b0rken - what happens if you block on that
mutex_lock and somebody else comes and sees (at least) inconsistent
tty->count?

====

Could you split that into direct move (one patch) + changes?

> +/**
> + *	mark_files_ro - mark all files read-only
> + *	@sb: superblock in question
> + *
> + *	All files are marked read-only.  We don't care about pending
> + *	delete files so this should be used in 'force' mode only.
> + */
> +void mark_files_ro(struct super_block *sb)

BTW, I'd rather merge mnt_write_count one first, so reordering of those
would be appreciated; mnt_write_count + move that function + this patch
is the order I'd prefer.
