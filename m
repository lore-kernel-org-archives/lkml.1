Return-Path: <linux-kernel-owner+w=401wt.eu-S932389AbXIMT1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389AbXIMT1k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 15:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753584AbXIMT1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 15:27:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752164AbXIMT1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 15:27:30 -0400
Message-ID: <46E98F0C.10504@redhat.com>
Date: Thu, 13 Sep 2007 15:27:08 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Pavel Emelyanov <xemul@openvz.org>
CC: Trond Myklebust <trond.myklebust@fys.uio.no>,
       "J. Bruce Fields" <bfields@fieldses.org>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: Re: [PATCH] Memory shortage can result in inconsistent flocks state
References: <46E68C35.7040001@openvz.org>
In-Reply-To: <46E68C35.7040001@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2007 08:38 AM, Pavel Emelyanov wrote:
> When the flock_lock_file() is called to change the flock
> from F_RDLCK to F_WRLCK or vice versa the existing flock
> can be removed without appropriate warning.
> 
> Look:
>         for_each_lock(inode, before) {
>                 struct file_lock *fl = *before;
>                 if (IS_POSIX(fl))
>                         break;
>                 if (IS_LEASE(fl))
>                         continue;
>                 if (filp != fl->fl_file)
>                         continue;
>                 if (request->fl_type == fl->fl_type)
>                         goto out;
>                 found = 1;
>                 locks_delete_lock(before); <<<<<< !
>                 break;
>         }
> 
> if after this point the subsequent locks_alloc_lock() will
> fail the return code will be -ENOMEM, but the existing lock
> is already removed.
> 
> This is a known feature that such "re-locking" is not atomic,
> but in the racy case the file should stay locked (although by
> some other process), but in this case the file will be unlocked.
> 
> The proposal is to prepare the lock in advance keeping no chance
> to fail in the future code.
> 
> Found during making the flocks pid-namespaces aware.
> 
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
> 
> ---
> 
> diff --git a/fs/locks.c b/fs/locks.c
> index 0db1a14..f59d066 100644
> --- a/fs/locks.c
> +++ b/fs/locks.c
> @@ -732,6 +732,14 @@ static int flock_lock_file(struct file *
>  	lock_kernel();
>  	if (request->fl_flags & FL_ACCESS)
>  		goto find_conflict;
> +
> +	if (request->fl_type != F_UNLCK) {
> +		error = -ENOMEM;
> +		new_fl = locks_alloc_lock();
> +		if (new_fl == NULL)
> +			goto out;
> +	}
> +
>  	for_each_lock(inode, before) {
>  		struct file_lock *fl = *before;
>  		if (IS_POSIX(fl))
> @@ -753,10 +761,6 @@ static int flock_lock_file(struct file *
>  		goto out;
>  	}
>  
> -	error = -ENOMEM;
> -	new_fl = locks_alloc_lock();
> -	if (new_fl == NULL)
> -		goto out;
>  	/*
>  	 * If a higher-priority process was blocked on the old file lock,
>  	 * give it the opportunity to lock the file.

Doesn't that create a leak in some cases?

>         for_each_lock(inode, before) {
>                 struct file_lock *fl = *before;
>                 if (IS_POSIX(fl))
>                         break;
>                 if (IS_LEASE(fl))
>                         continue;
>                 if (filp != fl->fl_file)
>                         continue;
>                 if (request->fl_type == fl->fl_type)
>                         goto out;  <<<<<<<<<<<<<<<< LEAK?
>                 found = 1;
>                 locks_delete_lock(before);
>                 break;
>         }
