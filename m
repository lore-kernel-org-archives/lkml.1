Return-Path: <linux-kernel-owner+w=401wt.eu-S1752215AbZA0XAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215AbZA0XAz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 18:00:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751262AbZA0XAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 18:00:46 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34331 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750943AbZA0XAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 18:00:45 -0500
Date: Tue, 27 Jan 2009 15:00:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tony Battersby <tonyb@cybernetics.com>
Cc: linux-kernel@vger.kernel.org, olsajiri@gmail.com, jkosina@suse.cz
Subject: Re: [PATCH 2/2] make shm_get_stat() more robust
Message-Id: <20090127150021.ee417076.akpm@linux-foundation.org>
In-Reply-To: <497F8F2D.600@cybernetics.com>
References: <497F8F2D.600@cybernetics.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2009 17:48:13 -0500
Tony Battersby <tonyb@cybernetics.com> wrote:

> shm_get_stat() assumes idr_find(&shm_ids(ns).ipcs_idr) returns
> "struct shmid_kernel *"; all other callers assume that it returns
> "struct kern_ipc_perm *".  This works because "struct kern_ipc_perm"
> is currently the first member of "struct shmid_kernel", but it would
> be better to use container_of() to prevent future breakage.
> 
> Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
> ---
> --- linux-2.6.29-rc2-git3/ipc/shm.c.orig	2009-01-27 16:23:10.000000000 -0500
> +++ linux-2.6.29-rc2-git3/ipc/shm.c	2009-01-27 16:24:19.000000000 -0500
> @@ -551,12 +551,14 @@ static void shm_get_stat(struct ipc_name
>  	in_use = shm_ids(ns).in_use;
>  
>  	for (total = 0, next_id = 0; total < in_use; next_id++) {
> +		struct kern_ipc_perm *ipc;
>  		struct shmid_kernel *shp;
>  		struct inode *inode;
>  
> -		shp = idr_find(&shm_ids(ns).ipcs_idr, next_id);
> -		if (shp == NULL)
> +		ipc = idr_find(&shm_ids(ns).ipcs_idr, next_id);
> +		if (ipc == NULL)
>  			continue;
> +		shp = container_of(ipc, struct shmid_kernel, shm_perm);
>  
>  		inode = shp->shm_file->f_path.dentry->d_inode;
>  

yup, well spotted.

It would be good to add a little typesafe wrapper:

static inline struct kern_ipc_perm *shm_idr_find(struct ipc_ids *ipc_ids)
{
	return idr_find(&ipc_ids->ipcs_idr);
}

(or similar)

so that this sort of mistake cannot happen again.


As you've found, open-coded use of a bare void*-returning function is a
bit dangerous.

