Return-Path: <linux-kernel-owner+w=401wt.eu-S1757937AbYE3I3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937AbYE3I3Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 04:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753014AbYE3I3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 04:29:12 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:55305 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbYE3I3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 04:29:10 -0400
Date: Fri, 30 May 2008 01:29:04 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nadia.Derbey@bull.net
Cc: manfred@colorfullife.com, lnxninja@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, efault@gmx.de, akpm@linux-foundation.org
Subject: Re: [PATCH 9/9] Get rid of ipc_lock_down()
Message-ID: <20080530082904.GL4943@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080507113553.395937000@bull.net> <20080507113738.379341000@bull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080507113738.379341000@bull.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2008 at 01:36:02PM +0200, Nadia.Derbey@bull.net wrote:
> [PATCH 09/09]
> 
> This patch removes the ipc_lock_down() routines: they used to call idr_find()
> locklessly (given that the ipc ids lock was already held), so they are not
> needed anymore.

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
> 
> ---
>  ipc/shm.c  |   21 +++------------------
>  ipc/util.c |   52 +---------------------------------------------------
>  ipc/util.h |    6 ------
>  3 files changed, 4 insertions(+), 75 deletions(-)
> 
> Index: linux-2.6.25-mm1/ipc/util.c
> ===================================================================
> --- linux-2.6.25-mm1.orig/ipc/util.c	2008-05-07 09:56:20.000000000 +0200
> +++ linux-2.6.25-mm1/ipc/util.c	2008-05-07 09:58:32.000000000 +0200
> @@ -716,56 +716,6 @@ struct kern_ipc_perm *ipc_lock(struct ip
>  	return out;
>  }
> 
> -/**
> - * ipc_lock_down - Lock an ipc structure with rw_sem held
> - * @ids: IPC identifier set
> - * @id: ipc id to look for
> - *
> - * Look for an id in the ipc ids idr and lock the associated ipc object.
> - *
> - * The ipc object is locked on exit.
> - *
> - * This is the routine that should be called when the rw_mutex is already
> - * held, i.e. idr tree protected.
> - */
> -
> -struct kern_ipc_perm *ipc_lock_down(struct ipc_ids *ids, int id)
> -{
> -	struct kern_ipc_perm *out;
> -	int lid = ipcid_to_idx(id);
> -
> -	rcu_read_lock();
> -	out = idr_find(&ids->ipcs_idr, lid);
> -	if (out == NULL) {
> -		rcu_read_unlock();
> -		return ERR_PTR(-EINVAL);
> -	}
> -
> -	spin_lock(&out->lock);
> -
> -	/*
> -	 * No need to verify that the structure is still valid since the
> -	 * rw_mutex is held.
> -	 */
> -	return out;
> -}
> -
> -struct kern_ipc_perm *ipc_lock_check_down(struct ipc_ids *ids, int id)
> -{
> -	struct kern_ipc_perm *out;
> -
> -	out = ipc_lock_down(ids, id);
> -	if (IS_ERR(out))
> -		return out;
> -
> -	if (ipc_checkid(out, id)) {
> -		ipc_unlock(out);
> -		return ERR_PTR(-EIDRM);
> -	}
> -
> -	return out;
> -}
> -
>  struct kern_ipc_perm *ipc_lock_check(struct ipc_ids *ids, int id)
>  {
>  	struct kern_ipc_perm *out;
> @@ -837,7 +787,7 @@ struct kern_ipc_perm *ipcctl_pre_down(st
>  	int err;
> 
>  	down_write(&ids->rw_mutex);
> -	ipcp = ipc_lock_check_down(ids, id);
> +	ipcp = ipc_lock_check(ids, id);
>  	if (IS_ERR(ipcp)) {
>  		err = PTR_ERR(ipcp);
>  		goto out_up;
> Index: linux-2.6.25-mm1/ipc/util.h
> ===================================================================
> --- linux-2.6.25-mm1.orig/ipc/util.h	2008-05-06 17:15:10.000000000 +0200
> +++ linux-2.6.25-mm1/ipc/util.h	2008-05-07 09:59:31.000000000 +0200
> @@ -102,11 +102,6 @@ void* ipc_rcu_alloc(int size);
>  void ipc_rcu_getref(void *ptr);
>  void ipc_rcu_putref(void *ptr);
> 
> -/*
> - * ipc_lock_down: called with rw_mutex held
> - * ipc_lock: called without that lock held
> - */
> -struct kern_ipc_perm *ipc_lock_down(struct ipc_ids *, int);
>  struct kern_ipc_perm *ipc_lock(struct ipc_ids *, int);
> 
>  void kernel_to_ipc64_perm(struct kern_ipc_perm *in, struct ipc64_perm *out);
> @@ -155,7 +150,6 @@ static inline void ipc_unlock(struct ker
>  	rcu_read_unlock();
>  }
> 
> -struct kern_ipc_perm *ipc_lock_check_down(struct ipc_ids *ids, int id);
>  struct kern_ipc_perm *ipc_lock_check(struct ipc_ids *ids, int id);
>  int ipcget(struct ipc_namespace *ns, struct ipc_ids *ids,
>  			struct ipc_ops *ops, struct ipc_params *params);
> Index: linux-2.6.25-mm1/ipc/shm.c
> ===================================================================
> --- linux-2.6.25-mm1.orig/ipc/shm.c	2008-05-06 17:15:10.000000000 +0200
> +++ linux-2.6.25-mm1/ipc/shm.c	2008-05-07 10:01:05.000000000 +0200
> @@ -112,23 +112,8 @@ void __init shm_init (void)
>  }
> 
>  /*
> - * shm_lock_(check_)down routines are called in the paths where the rw_mutex
> - * is held to protect access to the idr tree.
> - */
> -static inline struct shmid_kernel *shm_lock_down(struct ipc_namespace *ns,
> -						int id)
> -{
> -	struct kern_ipc_perm *ipcp = ipc_lock_down(&shm_ids(ns), id);
> -
> -	if (IS_ERR(ipcp))
> -		return (struct shmid_kernel *)ipcp;
> -
> -	return container_of(ipcp, struct shmid_kernel, shm_perm);
> -}
> -
> -/*
>   * shm_lock_(check_) routines are called in the paths where the rw_mutex
> - * is not held.
> + * is not necessarily held.
>   */
>  static inline struct shmid_kernel *shm_lock(struct ipc_namespace *ns, int id)
>  {
> @@ -211,7 +196,7 @@ static void shm_close(struct vm_area_str
> 
>  	down_write(&shm_ids(ns).rw_mutex);
>  	/* remove from the list of attaches of the shm segment */
> -	shp = shm_lock_down(ns, sfd->id);
> +	shp = shm_lock(ns, sfd->id);
>  	BUG_ON(IS_ERR(shp));
>  	shp->shm_lprid = task_tgid_vnr(current);
>  	shp->shm_dtim = get_seconds();
> @@ -933,7 +918,7 @@ invalid:
> 
>  out_nattch:
>  	down_write(&shm_ids(ns).rw_mutex);
> -	shp = shm_lock_down(ns, shmid);
> +	shp = shm_lock(ns, shmid);
>  	BUG_ON(IS_ERR(shp));
>  	shp->shm_nattch--;
>  	if(shp->shm_nattch == 0 &&
> 
> --
