Return-Path: <linux-kernel-owner+w=401wt.eu-S935376AbXGMHox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935376AbXGMHox (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 03:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935151AbXGMHoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 03:44:38 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59268 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934799AbXGMHoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 03:44:38 -0400
Date: Fri, 13 Jul 2007 00:44:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Herbert van den Bergh <Herbert.van.den.Bergh@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Dave McCracken <dave.mccracken@oracle.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] do not limit locked memory when RLIMIT_MEMLOCK is
 RLIM_INFINITY
Message-Id: <20070713004408.b7162501.akpm@linux-foundation.org>
In-Reply-To: <4692D9E0.1000308@oracle.com>
References: <4692D9E0.1000308@oracle.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Jul 2007 17:59:12 -0700 Herbert van den Bergh <Herbert.van.den.Bergh@oracle.com> wrote:

> 
> [resending, since my previous message had tabs converted to spaces]
> 
> This patch fixes a bug in mm/mlock.c on 32-bit architectures that prevents
> a user from locking more than 4GB of shared memory, or allocating more
> than 4GB of shared memory in hugepages, when rlim[RLIMIT_MEMLOCK] is
> set to RLIM_INFINITY.
> 
> Signed-off-by: Herbert van den Bergh <herbert.van.den.bergh@oracle.com>
> Acked-by: Chris Mason <chris.mason@oracle.com>
> 
> --- linux-2.6.22/mm/mlock.c.orig	2007-07-09 10:19:31.000000000 -0700
> +++ linux-2.6.22/mm/mlock.c	2007-07-09 10:19:19.000000000 -0700
> @@ -244,9 +244,12 @@ int user_shm_lock(size_t size, struct us
>  
>  	locked = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
>  	lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur;
> +	if (lock_limit == RLIM_INFINITY)
> +		allowed = 1;
>  	lock_limit >>= PAGE_SHIFT;
>  	spin_lock(&shmlock_user_lock);
> -	if (locked + user->locked_shm > lock_limit && !capable(CAP_IPC_LOCK))
> +	if (!allowed &&
> +	    locked + user->locked_shm > lock_limit && !capable(CAP_IPC_LOCK))
>  		goto out;
>  	get_uid(user);
>  	user->locked_shm += locked;

OK.  Seems like a nasty bug if one happens to want to do that.  Should we
backport this into 2.6.22.x?

