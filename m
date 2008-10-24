Return-Path: <linux-kernel-owner+w=401wt.eu-S1754051AbYJXGA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbYJXGA2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 02:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751066AbYJXGAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 02:00:19 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:35898 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695AbYJXGAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 02:00:18 -0400
Subject: Re: [PATCH 1/1] SYSVIPC - Fix the ipc structures initialization
From: Nadia Derbey <Nadia.Derbey@bull.net>
To: akpm@linux-foundation.org
Cc: cboulte@gmail.com, manfred@colorfullife.com, linux-kernel@vger.kernel.org
In-Reply-To: <20081023135732.138544330@bull.net>
References: <20081023135714.914147053@bull.net>
	 <20081023135732.138544330@bull.net>
Content-Type: text/plain
Date: Fri, 24 Oct 2008 07:59:32 +0200
Message-Id: <1224827972.2595.107.camel@frecb000730.frec.bull.fr>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-23 at 15:57 +0200, Nadia.Derbey@bull.net wrote:
> plain text document attachment
> (ipc-fix-sysvipc_structures_initialization.patch)
> This patch is a fix for Bugzilla bug
> http://bugzilla.kernel.org/show_bug.cgi?id=11796.
> 
> To summarize, a simple testcase is concurrently running an infinite loop on
> msgctl(IPC_STAT) and a call to msgget():
> 
> while (1)
>    msgctl(id, IPC_STAT)    1
>                            |
>                            |
>                            |
>                            2 id = msgget(key, IPC_CREAT)
>                            |
>                            |
>                            |
> 
> In the interval [1-2], the id doesn't exist yet.
> 
> In that test, the problem is the following:
> When we are calling ipc_addid() from msgget() the msq structure is not
> completely initialized. So idr_get_new() is inserting a pointer into the
> idr tree, and the structure which is pointed to has, among other fields,
> its lock uninitialized.
> 
> Since msgctl(IPC_STAT) is looping while (1), idr_find() returns the
> pointer as soon as it is inserted into the IDR tree. And ipc_lock()
> calls spin_lock(&mqs->lock), while we have not initialized that lock
> yet.
> 
> This patch moves the spin_lock_init() before the call to ipc_addid().
> It also sets the "deleted" flag to 1 in the window between msg structure
> allocation and msg structure locking in ipc_addid().
> 
> The fix has been applied to semaphores and shm segments too.

I just did my own review :-) and found out there's a possible
factorization: the 'deleted' flag can be set once in util.c, instead of
setting it separately for msg queues, semaphores and shm.

Resending the patch right now. Sorry for the noise.

Regards,
Nadia

> 
> Regards,
> Nadia
> 
> 
> Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
> 
> ---
>  ipc/msg.c  |    9 +++++++++
>  ipc/sem.c  |    9 +++++++++
>  ipc/shm.c  |    9 +++++++++
>  ipc/util.c |    3 ++-
>  4 files changed, 29 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.27/ipc/msg.c
> ===================================================================
> --- linux-2.6.27.orig/ipc/msg.c	2008-10-23 15:20:46.000000000 +0200
> +++ linux-2.6.27/ipc/msg.c	2008-10-23 16:38:59.000000000 +0200
> @@ -191,6 +191,15 @@ static int newque(struct ipc_namespace *
>  	msq->q_perm.mode = msgflg & S_IRWXUGO;
>  	msq->q_perm.key = key;
>  
> +	/*
> +	 * We have a window between the time msq is inserted into the idr
> +	 * tree (done in ipc_addid()) and the time it is actually locked.
> +	 * In order to be safe during that window set the msq as deleted:
> +	 * a concurrent ipc_lock() will see it as not present until the
> +	 * initialization phase is complete.
> +	 */
> +	msq->q_perm.deleted = 1;
> +
>  	msq->q_perm.security = NULL;
>  	retval = security_msg_queue_alloc(msq);
>  	if (retval) {
> Index: linux-2.6.27/ipc/util.c
> ===================================================================
> --- linux-2.6.27.orig/ipc/util.c	2008-10-23 15:20:46.000000000 +0200
> +++ linux-2.6.27/ipc/util.c	2008-10-23 15:33:37.000000000 +0200
> @@ -266,6 +266,8 @@ int ipc_addid(struct ipc_ids* ids, struc
>  	if (ids->in_use >= size)
>  		return -ENOSPC;
>  
> +	spin_lock_init(&new->lock);
> +
>  	err = idr_get_new(&ids->ipcs_idr, new, &id);
>  	if (err)
>  		return err;
> @@ -280,7 +282,6 @@ int ipc_addid(struct ipc_ids* ids, struc
>  		ids->seq = 0;
>  
>  	new->id = ipc_buildid(id, new->seq);
> -	spin_lock_init(&new->lock);
>  	new->deleted = 0;
>  	rcu_read_lock();
>  	spin_lock(&new->lock);
> Index: linux-2.6.27/ipc/sem.c
> ===================================================================
> --- linux-2.6.27.orig/ipc/sem.c	2008-10-23 15:20:46.000000000 +0200
> +++ linux-2.6.27/ipc/sem.c	2008-10-23 15:57:27.000000000 +0200
> @@ -256,6 +256,15 @@ static int newary(struct ipc_namespace *
>  	sma->sem_perm.mode = (semflg & S_IRWXUGO);
>  	sma->sem_perm.key = key;
>  
> +	/*
> +	 * We have a window between the time sma is inserted into the idr
> +	 * tree (done in ipc_addid()) and the time it is actually locked.
> +	 * In order to be safe during that window set the sma as deleted:
> +	 * a concurrent ipc_lock() will see it as not present until the
> +	 * initialization phase is complete.
> +	 */
> +	sma->sem_perm.deleted = 1;
> +
>  	sma->sem_perm.security = NULL;
>  	retval = security_sem_alloc(sma);
>  	if (retval) {
> Index: linux-2.6.27/ipc/shm.c
> ===================================================================
> --- linux-2.6.27.orig/ipc/shm.c	2008-10-23 15:20:46.000000000 +0200
> +++ linux-2.6.27/ipc/shm.c	2008-10-23 15:56:32.000000000 +0200
> @@ -355,6 +355,15 @@ static int newseg(struct ipc_namespace *
>  	shp->shm_perm.mode = (shmflg & S_IRWXUGO);
>  	shp->mlock_user = NULL;
>  
> +	/*
> +	 * We have a window between the time shp is inserted into the idr
> +	 * tree (done in ipc_addid()) and the time it is actually locked.
> +	 * In order to be safe during that window set the shp as deleted:
> +	 * a concurrent ipc_lock() will see it as not present until the
> +	 * initialization phase is complete.
> +	 */
> +	shp->shm_perm.deleted = 1;
> +
>  	shp->shm_perm.security = NULL;
>  	error = security_shm_alloc(shp);
>  	if (error) {
> 
-- 
Nadia Derbey <Nadia.Derbey@bull.net>

