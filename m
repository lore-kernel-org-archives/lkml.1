Return-Path: <linux-kernel-owner+w=401wt.eu-S1422815AbXBPAQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422815AbXBPAQy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 19:16:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422816AbXBPAQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 19:16:53 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:15636 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422815AbXBPAQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 19:16:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=sNKZHqP3Cqf41jXkZVgH1Nyq05xyCTCcliYtR7byofaZrZ6DYYI7bAf6yiUJy5rmP5tJxT2793opoUP52lQYUPMPPGAS/TDxUbPMyPJDRDlDkHPO6wLDLD+Ich67OhHqlmDTi2Txf2tIjAh0UdpvoUUmSPCeO3zsLPJX1M+FuGE=
Message-ID: <45D4F7EC.90908@googlemail.com>
Date: Fri, 16 Feb 2007 01:16:44 +0100
User-Agent: Thunderbird 1.5.0.9 (X11/20070130)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] shm:  Fix the locking and cleanup error handling in do_shmat.
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>	<45D47020.1010309@googlemail.com>	<20070215140232.0aba86a7.akpm@linux-foundation.org>	<45D4EBB3.2060800@googlemail.com> <m1r6srhsrt.fsf_-_@ebiederm.dsl.xmission.com>
In-Reply-To: <m1r6srhsrt.fsf_-_@ebiederm.dsl.xmission.com>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman napisał(a):
> When enhancing do_shmat I forgot to take into account that shm_lock
> is a spinlock, and was allocating memory with the lock held.
> 
> This patch fixes that by grabbing a reference to the dentry and
> mounts of shm_file before we drop the shm_lock and then performing
> the memory allocations.
> 
> This is also a bit of a general scrub on the error handling.
> Everything is now forced through the single return statement
> for clarity, and the handling of the return address now uses
> fewer casts.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---
>  ipc/shm.c |   56 ++++++++++++++++++++++++++++++++------------------------
>  1 files changed, 32 insertions(+), 24 deletions(-)
> 
> diff --git a/ipc/shm.c b/ipc/shm.c
> index e0b6544..26b935b 100644
> --- a/ipc/shm.c
> +++ b/ipc/shm.c
> @@ -815,15 +815,16 @@ long do_shmat(int shmid, char __user *shmaddr, int shmflg, ulong *raddr)
>  	unsigned long flags;
>  	unsigned long prot;
>  	int acc_mode;
> -	void *user_addr;
> +	unsigned long user_addr;
>  	struct ipc_namespace *ns;
>  	struct shm_file_data *sfd;
> +	struct path path;
>  	mode_t f_mode;
>  
> -	if (shmid < 0) {
> -		err = -EINVAL;
> +	err = -EINVAL;
> +	if (shmid < 0)
>  		goto out;
> -	} else if ((addr = (ulong)shmaddr)) {
> +	else if ((addr = (ulong)shmaddr)) {
>  		if (addr & (SHMLBA-1)) {
>  			if (shmflg & SHM_RND)
>  				addr &= ~(SHMLBA-1);	   /* round down */
> @@ -831,12 +832,12 @@ long do_shmat(int shmid, char __user *shmaddr, int shmflg, ulong *raddr)
>  #ifndef __ARCH_FORCE_SHMLBA
>  				if (addr & ~PAGE_MASK)
>  #endif
> -					return -EINVAL;
> +					goto out;
>  		}
>  		flags = MAP_SHARED | MAP_FIXED;
>  	} else {
>  		if ((shmflg & SHM_REMAP))
> -			return -EINVAL;
> +			goto out;
>  
>  		flags = MAP_SHARED;
>  	}
> @@ -860,7 +861,6 @@ long do_shmat(int shmid, char __user *shmaddr, int shmflg, ulong *raddr)
>  	 * additional creator id...
>  	 */
>  	ns = current->nsproxy->ipc_ns;
> -	err = -EINVAL;
>  	shp = shm_lock(ns, shmid);
>  	if(shp == NULL)
>  		goto out;
> @@ -877,19 +877,25 @@ long do_shmat(int shmid, char __user *shmaddr, int shmflg, ulong *raddr)
>  	if (err)
>  		goto out_unlock;
>  
> +	path.dentry = dget(shp->shm_file->f_path.dentry);
> +	path.mnt    = mntget(shp->shm_file->f_path.mnt);
> +	shp->shm_nattch++;
> +	size = i_size_read(path.dentry->d_inode);
> +	shm_unlock(shp);
> +
>  	err = -ENOMEM;
>  	sfd = kzalloc(sizeof(*sfd), GFP_KERNEL);
>  	if (!sfd)
> -		goto out_unlock;
> +		goto out_put_path;
>  
> +	err = -ENOMEM;
>  	file = get_empty_filp();
>  	if (!file)
>  		goto out_free;
>  
>  	file->f_op = &shm_file_operations;
>  	file->private_data = sfd;
> -	file->f_path.dentry = dget(shp->shm_file->f_path.dentry);
> -	file->f_path.mnt = mntget(shp->shm_file->f_path.mnt);
> +	file->f_path = path;
>  	file->f_mapping = shp->shm_file->f_mapping;
>  	file->f_mode = f_mode;
>  	sfd->id = shp->id;
> @@ -897,13 +903,9 @@ long do_shmat(int shmid, char __user *shmaddr, int shmflg, ulong *raddr)
>  	sfd->file = shp->shm_file;
>  	sfd->vm_ops = NULL;
>  
> -	size = i_size_read(file->f_path.dentry->d_inode);
> -	shp->shm_nattch++;
> -	shm_unlock(shp);
> -
>  	down_write(&current->mm->mmap_sem);
>  	if (addr && !(shmflg & SHM_REMAP)) {
> -		user_addr = ERR_PTR(-EINVAL);
> +		err = -EINVAL;
>  		if (find_vma_intersection(current->mm, addr, addr + size))
>  			goto invalid;
>  		/*
> @@ -915,13 +917,17 @@ long do_shmat(int shmid, char __user *shmaddr, int shmflg, ulong *raddr)
>  			goto invalid;
>  	}
>  		
> -	user_addr = (void*) do_mmap (file, addr, size, prot, flags, 0);
> -
> +	user_addr = do_mmap (file, addr, size, prot, flags, 0);
> +	*raddr = user_addr;
> +	err = 0;
> +	if (IS_ERR_VALUE(user_addr))
> +		err = (long)user_addr;
>  invalid:
>  	up_write(&current->mm->mmap_sem);
> -
> +	
>  	fput(file);
>  
> +out_nattch:
>  	mutex_lock(&shm_ids(ns).mutex);
>  	shp = shm_lock(ns, shmid);
>  	BUG_ON(!shp);
> @@ -933,17 +939,19 @@ invalid:

^^^^

???


>  		shm_unlock(shp);
>  	mutex_unlock(&shm_ids(ns).mutex);
>  
> -	*raddr = (unsigned long) user_addr;
> -	err = 0;
> -	if (IS_ERR(user_addr))
> -		err = PTR_ERR(user_addr);
>  out:
>  	return err;
> -out_free:
> -	kfree(sfd);
> +
>  out_unlock:
>  	shm_unlock(shp);
>  	goto out;
> +
> +out_free:
> +	kfree(sfd);
> +out_put_path:
> +	dput(path.dentry);
> +	mntput(path.mnt);
> +	goto out_nattch;
>  		

^^^^ tabs

>  }
>  

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
