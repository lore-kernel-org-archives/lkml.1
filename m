Return-Path: <linux-kernel-owner+w=401wt.eu-S1760918AbXGJAjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760918AbXGJAjv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 20:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757175AbXGJAjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 20:39:42 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60441 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757526AbXGJAjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 20:39:41 -0400
Date: Tue, 10 Jul 2007 09:41:14 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Herbert van den Bergh <Herbert.van.den.Bergh@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, Dave McCracken <dave.mccracken@oracle.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] do not limit locked memory when RLIMIT_MEMLOCK is
 RLIM_INFINITY
Message-Id: <20070710094114.86db9e84.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4692D230.3050403@oracle.com>
References: <4692D230.3050403@oracle.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Jul 2007 17:26:24 -0700
Herbert van den Bergh <Herbert.van.den.Bergh@oracle.com> wrote:

> 
> This patch fixes a bug in mm/mlock.c on 32-bit architectures that prevents
> a user from locking more than 4GB of shared memory, or allocating more
> than 4GB of shared memory in hugepages, when rlim[RLIMIT_MEMLOCK] is
> set to RLIM_INFINITY.
> 
just curious...why a resouce which can be used longer than a process's
lifetime is limited by RLIMIT ?

Thanks,
-Kame


> Signed-off-by: Herbert van den Bergh <herbert.van.den.bergh@oracle.com>
> Acked-by: Chris Mason <chris.mason@oracle.com>
> 
> --- linux-2.6.22/mm/mlock.c.orig    2007-07-09 10:19:31.000000000 -0700
> +++ linux-2.6.22/mm/mlock.c    2007-07-09 10:19:19.000000000 -0700
> @@ -244,9 +244,12 @@ int user_shm_lock(size_t size, struct us
>  
>      locked = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
>      lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur;
> +    if (lock_limit == RLIM_INFINITY)
> +        allowed = 1;
>      lock_limit >>= PAGE_SHIFT;
>      spin_lock(&shmlock_user_lock);
> -    if (locked + user->locked_shm > lock_limit && !capable(CAP_IPC_LOCK))
> +    if (!allowed &&
> +        locked + user->locked_shm > lock_limit && !capable(CAP_IPC_LOCK))
>          goto out;
>      get_uid(user);
>      user->locked_shm += locked;
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

