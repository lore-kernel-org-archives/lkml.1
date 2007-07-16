Return-Path: <linux-kernel-owner+w=401wt.eu-S1765675AbXGPWSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765675AbXGPWSW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 18:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbXGPWSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 18:18:13 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51031 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752377AbXGPWSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 18:18:12 -0400
Date: Mon, 16 Jul 2007 15:17:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Emelianov <xemul@openvz.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org
Subject: Re: [PATCH] Fix user struct leakage with locked IPC shem segment
Message-Id: <20070716151738.2f4b5cf4.akpm@linux-foundation.org>
In-Reply-To: <469B636C.3060007@openvz.org>
References: <469B636C.3060007@openvz.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2007 16:24:12 +0400
Pavel Emelianov <xemul@openvz.org> wrote:

> When user locks an ipc shmem segmant with SHM_LOCK ctl and the
> segment is already locked the shmem_lock() function returns 0. 
> After this the subsequent code leaks the existing user struct:

I'm curious.  For the past few months, people@openvz.org have discovered
(and fixed) an ongoing stream of obscure but serious and quite
long-standing bugs.

How are you discovering these bugs?

> == ipc/shm.c: sys_shmctl() ==
>      ...
>      err = shmem_lock(shp->shm_file, 1, user);
>      if (!err) {
>           shp->shm_perm.mode |= SHM_LOCKED;
>           shp->mlock_user = user;
>      }
>      ...
> ==
> 
> Other results of this are:
> 1. the new shp->mlock_user is not get-ed and will point to freed
>    memory when the task dies.

That sounds fairly serious - can this lead to memory corruption and crashes?

> 2. the RLIMIT_MEMLOCK is screwed on both user structs.
> 
> The exploit looks like this:
> 
> ==
>     id = shmget(...);
>     setresuid(uid, 0, 0);
>     shmctl(id, SHM_LOCK, NULL);
>     setresuid(uid + 1, 0, 0);
>     shmctl(id, SHM_LOCK, NULL);
> ==
> 
> My solution is to return 0 to the userspace and do not change the
> segment's user.
> 
> Signed-off-by: Pavel Emelianov <xemul@openvz.org>
> 
> ---
> 
> --- ./ipc/shm.c.shlfix	2007-07-06 10:58:57.000000000 +0400
> +++ ./ipc/shm.c	2007-07-16 16:12:34.000000000 +0400
> @@ -715,7 +715,7 @@ asmlinkage long sys_shmctl (int shmid, i
>  			struct user_struct * user = current->user;
>  			if (!is_file_hugepages(shp->shm_file)) {
>  				err = shmem_lock(shp->shm_file, 1, user);
> -				if (!err) {
> +				if (!err && !(shp->shm_perm.mode & SHM_LOCKED)){
>  					shp->shm_perm.mode |= SHM_LOCKED;
>  					shp->mlock_user = user;
>  				}
