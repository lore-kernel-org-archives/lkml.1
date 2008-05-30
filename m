Return-Path: <linux-kernel-owner+w=401wt.eu-S1757372AbYE3I2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372AbYE3I2z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 04:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbYE3I2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 04:28:46 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:54810 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbYE3I2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 04:28:44 -0400
Date: Fri, 30 May 2008 01:27:54 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nadia.Derbey@bull.net
Cc: manfred@colorfullife.com, lnxninja@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, efault@gmx.de, akpm@linux-foundation.org
Subject: Re: [PATCH 8/9] Call idr_find() without locking in ipc_lock()
Message-ID: <20080530082754.GK4943@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080507113553.395937000@bull.net> <20080507113737.964082000@bull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080507113737.964082000@bull.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2008 at 01:36:01PM +0200, Nadia.Derbey@bull.net wrote:
> [PATCH 08/09]
> 
> This patch makes idr_find() called locklessly in ipc_lock(), since the idr
> tree is now RCU protected.

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
> 
> ---
>  ipc/util.c |    9 ---------
>  1 file changed, 9 deletions(-)
> 
> Index: linux-2.6.25-mm1/ipc/util.c
> ===================================================================
> --- linux-2.6.25-mm1.orig/ipc/util.c	2008-05-06 17:15:10.000000000 +0200
> +++ linux-2.6.25-mm1/ipc/util.c	2008-05-07 09:56:20.000000000 +0200
> @@ -688,10 +688,6 @@ void ipc64_perm_to_ipc_perm (struct ipc6
>   * Look for an id in the ipc ids idr and lock the associated ipc object.
>   *
>   * The ipc object is locked on exit.
> - *
> - * This is the routine that should be called when the rw_mutex is not already
> - * held, i.e. idr tree not protected: it protects the idr tree in read mode
> - * during the idr_find().
>   */
> 
>  struct kern_ipc_perm *ipc_lock(struct ipc_ids *ids, int id)
> @@ -699,18 +695,13 @@ struct kern_ipc_perm *ipc_lock(struct ip
>  	struct kern_ipc_perm *out;
>  	int lid = ipcid_to_idx(id);
> 
> -	down_read(&ids->rw_mutex);
> -
>  	rcu_read_lock();
>  	out = idr_find(&ids->ipcs_idr, lid);
>  	if (out == NULL) {
>  		rcu_read_unlock();
> -		up_read(&ids->rw_mutex);
>  		return ERR_PTR(-EINVAL);
>  	}
> 
> -	up_read(&ids->rw_mutex);
> -
>  	spin_lock(&out->lock);
>  	
>  	/* ipc_rmid() may have already freed the ID while ipc_lock
> 
> --
