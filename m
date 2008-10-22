Return-Path: <linux-kernel-owner+w=401wt.eu-S1753295AbYJVNh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295AbYJVNh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 09:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751561AbYJVNhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 09:37:13 -0400
Received: from tundra.namei.org ([65.99.196.166]:58655 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446AbYJVNhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 09:37:12 -0400
Date: Thu, 23 Oct 2008 00:37:02 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: hooanon05@yahoo.co.jp, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: __vm_enough_memory(), OVERCOMMIT_NEVER, current->mm, kernel
 thread
In-Reply-To: <20081022130926.44540b03@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LRH.1.10.0810230036100.21849@tundra.namei.org>
References: <7123.1224602071@jrobl> <20081021164619.341f01d9@lxorguk.ukuu.org.uk> <6775.1224630654@jrobl> <20081022092736.2a0795d1@lxorguk.ukuu.org.uk> <6689.1224674779@jrobl> <20081022130926.44540b03@lxorguk.ukuu.org.uk>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008, Alan Cox wrote:

[Adding lsm list to the cc]

> On Wed, 22 Oct 2008 20:26:19 +0900
> hooanon05@yahoo.co.jp wrote:
> 
> > 
> > Alan Cox:
> > > No - the shmem routine would use vm_enough_memory_fs which wouldn't care
> > > if current->mm is NULL, but the others would check.
> > 
> > Unfortunately I cannot imagine what new vm_enough_memory_fs() will be.
> > Would you show me its draft or pseudo code?
> 
> This is the patch I propose:
> 
> nfsd: Fix vm overcommit crash
> 
> From: Alan Cox <alan@redhat.com>
> 
> Junjiro R. Okajima reported a problem where knfsd crashes if you are using
> it to export shmemfs objects and run strict overcommit. In this situation
> the current->mm based modifier to the overcommit goes through a NULL
> pointer.
> 
> We could simply check for NULL and skip the modifier but we've caught other
> real bugs in the past from mm being NULL here - cases where we did need a
> valid mm set up (eg the exec bug about a year ago).
> 
> To preserve the checks and get the logic we want shuffle the checking
> around and add a new helper to the vm_ security wrappers
> 
> Also fix a current->mm reference in nommu that should use the passed mm

Looks ok to me.

Acked-by: James Morris <jmorris@namei.org>


> ---
> 
>  include/linux/security.h |    1 +
>  mm/mmap.c                |    3 ++-
>  mm/nommu.c               |    3 ++-
>  mm/shmem.c               |    4 ++--
>  security/security.c      |    9 +++++++++
>  5 files changed, 16 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/include/linux/security.h b/include/linux/security.h
> index f5c4a51..a2b8430 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -1585,6 +1585,7 @@ int security_syslog(int type);
>  int security_settime(struct timespec *ts, struct timezone *tz);
>  int security_vm_enough_memory(long pages);
>  int security_vm_enough_memory_mm(struct mm_struct *mm, long pages);
> +int security_vm_enough_memory_kern(long pages);
>  int security_bprm_alloc(struct linux_binprm *bprm);
>  void security_bprm_free(struct linux_binprm *bprm);
>  void security_bprm_apply_creds(struct linux_binprm *bprm, int unsafe);
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 74f4d15..de14ac2 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -175,7 +175,8 @@ int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
>  
>  	/* Don't let a single process grow too big:
>  	   leave 3% of the size of this process for other processes */
> -	allowed -= mm->total_vm / 32;
> +	if (mm)
> +		allowed -= mm->total_vm / 32;
>  
>  	/*
>  	 * cast `allowed' as a signed long because vm_committed_space
> diff --git a/mm/nommu.c b/mm/nommu.c
> index 2696b24..7695dc8 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -1454,7 +1454,8 @@ int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
>  
>  	/* Don't let a single process grow too big:
>  	   leave 3% of the size of this process for other processes */
> -	allowed -= current->mm->total_vm / 32;
> +	if (mm)
> +		allowed -= mm->total_vm / 32;
>  
>  	/*
>  	 * cast `allowed' as a signed long because vm_committed_space
> diff --git a/mm/shmem.c b/mm/shmem.c
> index d38d7e6..1677b3e 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -162,7 +162,7 @@ static inline struct shmem_sb_info *SHMEM_SB(struct super_block *sb)
>  static inline int shmem_acct_size(unsigned long flags, loff_t size)
>  {
>  	return (flags & VM_ACCOUNT)?
> -		security_vm_enough_memory(VM_ACCT(size)): 0;
> +		security_vm_enough_memory_kern(VM_ACCT(size)): 0;
>  }
>  
>  static inline void shmem_unacct_size(unsigned long flags, loff_t size)
> @@ -180,7 +180,7 @@ static inline void shmem_unacct_size(unsigned long flags, loff_t size)
>  static inline int shmem_acct_block(unsigned long flags)
>  {
>  	return (flags & VM_ACCOUNT)?
> -		0: security_vm_enough_memory(VM_ACCT(PAGE_CACHE_SIZE));
> +		0: security_vm_enough_memory_kern(VM_ACCT(PAGE_CACHE_SIZE));
>  }
>  
>  static inline void shmem_unacct_blocks(unsigned long flags, long pages)
> diff --git a/security/security.c b/security/security.c
> index 255b085..c0acfa7 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -198,14 +198,23 @@ int security_settime(struct timespec *ts, struct timezone *tz)
>  
>  int security_vm_enough_memory(long pages)
>  {
> +	WARN_ON(current->mm == NULL);
>  	return security_ops->vm_enough_memory(current->mm, pages);
>  }
>  
>  int security_vm_enough_memory_mm(struct mm_struct *mm, long pages)
>  {
> +	WARN_ON(mm == NULL);
>  	return security_ops->vm_enough_memory(mm, pages);
>  }
>  
> +int security_vm_enough_memory_kern(long pages)
> +{
> +	/* If current->mm is a kernel thread then we will pass NULL,
> +	   for this specific case that is fine */
> +	return security_ops->vm_enough_memory(current->mm, pages);
> +}
> +
>  int security_bprm_alloc(struct linux_binprm *bprm)
>  {
>  	return security_ops->bprm_alloc_security(bprm);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
James Morris
<jmorris@namei.org>
