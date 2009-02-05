Return-Path: <linux-kernel-owner+w=401wt.eu-S1762293AbZBECDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762293AbZBECDY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 21:03:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbZBECDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 21:03:15 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60991 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbZBECDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 21:03:14 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Ravikiran G Thirumalai <kiran@scalex86.org>
Subject: Re: [patch] mm: Fix SHM_HUGETLB to work with users in hugetlb_shm_group
Cc: kosaki.motohiro@jp.fujitsu.com, wli@movementarian.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, shai@scalex86.org, Mel Gorman <mel@csn.ul.ie>,
       Nishanth Aravamudan <nacc@us.ibm.com>
In-Reply-To: <20090205004157.GC6794@localdomain>
References: <20090204221121.GD10229@movementarian.org> <20090205004157.GC6794@localdomain>
Message-Id: <20090205104735.ECDA.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu,  5 Feb 2009 11:03:09 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc to Mel and Nishanth)

I think this requirement is reasonable. but I also hope Mel or Nishanth
review this.


<<intentionally full quote>>

> On Wed, Feb 04, 2009 at 05:11:21PM -0500, wli@movementarian.org wrote:
> >On Wed, Feb 04, 2009 at 02:04:28PM -0800, Ravikiran G Thirumalai wrote:
> >> ...
> >> As I see it we have the following options to fix this inconsistency:
> >> 1. Do not depend on RLIMIT_MEMLOCK for hugetlb shm mappings.  If a user
> >>    has CAP_IPC_LOCK or if user belongs to /proc/sys/vm/hugetlb_shm_group,
> >>    he should be able to use shm memory according to shmmax and shmall OR
> >> 2. Update the hugetlbpage documentation to mention the resource limit based
> >>    limitation, and remove the useless /proc/sys/vm/hugetlb_shm_group sysctl
> >> Which one is better?  I am leaning towards 1. and have a patch ready for 1.
> >> but I might be missing some historical reason for using RLIMIT_MEMLOCK with
> >> SHM_HUGETLB.
> >
> >We should do (1) because the hugetlb_shm_group and CAP_IPC_LOCK bits
> >should both continue to work as they did prior to RLIMIT_MEMLOCK -based
> >management of hugetlb. Please make sure the new RLIMIT_MEMLOCK -based
> >management still enables hugetlb shm when hugetlb_shm_group and
> >CAP_IPC_LOCK don't apply.
> >
> 
> OK, here's the patch.
> 
> Thanks,
> Kiran
> 
> 
> Fix hugetlb subsystem so that non root users belonging to hugetlb_shm_group
> can actually allocate hugetlb backed shm.
> 
> Currently non root users cannot even map one large page using SHM_HUGETLB
> when they belong to the gid in /proc/sys/vm/hugetlb_shm_group.
> This is because allocation size is verified against RLIMIT_MEMLOCK resource
> limit even if the user belongs to hugetlb_shm_group.
> 
> This patch
> 1. Fixes hugetlb subsystem so that users with CAP_IPC_LOCK and users
>    belonging to hugetlb_shm_group don't need to be restricted with
>    RLIMIT_MEMLOCK resource limits
> 2. If a user has sufficient memlock limit he can still allocate the hugetlb
>    shm segment.
> 
> Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
> 
> ---
> 
>  Documentation/vm/hugetlbpage.txt |   11 ++++++-----
>  fs/hugetlbfs/inode.c             |   18 ++++++++++++------
>  include/linux/mm.h               |    2 ++
>  mm/mlock.c                       |   11 ++++++++---
>  4 files changed, 28 insertions(+), 14 deletions(-)
> 
> Index: linux-2.6-tip/fs/hugetlbfs/inode.c
> ===================================================================
> --- linux-2.6-tip.orig/fs/hugetlbfs/inode.c	2009-02-04 15:21:45.000000000 -0800
> +++ linux-2.6-tip/fs/hugetlbfs/inode.c	2009-02-04 15:23:19.000000000 -0800
> @@ -943,8 +943,15 @@ static struct vfsmount *hugetlbfs_vfsmou
>  static int can_do_hugetlb_shm(void)
>  {
>  	return likely(capable(CAP_IPC_LOCK) ||
> -			in_group_p(sysctl_hugetlb_shm_group) ||
> -			can_do_mlock());
> +			in_group_p(sysctl_hugetlb_shm_group));
> +}
> +
> +static void acct_huge_shm_lock(size_t size, struct user_struct *user)
> +{
> +	unsigned long pages = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
> +	spin_lock(&shmlock_user_lock);
> +	acct_shm_lock(pages, user);
> +	spin_unlock(&shmlock_user_lock);
>  }
>  
>  struct file *hugetlb_file_setup(const char *name, size_t size)
> @@ -959,12 +966,11 @@ struct file *hugetlb_file_setup(const ch
>  	if (!hugetlbfs_vfsmount)
>  		return ERR_PTR(-ENOENT);
>  
> -	if (!can_do_hugetlb_shm())
> +	if (can_do_hugetlb_shm())
> +		acct_huge_shm_lock(size, user);
> +	else if (!user_shm_lock(size, user))
>  		return ERR_PTR(-EPERM);
>  
> -	if (!user_shm_lock(size, user))
> -		return ERR_PTR(-ENOMEM);
> -
>  	root = hugetlbfs_vfsmount->mnt_root;
>  	quick_string.name = name;
>  	quick_string.len = strlen(quick_string.name);
> Index: linux-2.6-tip/include/linux/mm.h
> ===================================================================
> --- linux-2.6-tip.orig/include/linux/mm.h	2009-02-04 15:21:45.000000000 -0800
> +++ linux-2.6-tip/include/linux/mm.h	2009-02-04 15:23:19.000000000 -0800
> @@ -737,8 +737,10 @@ extern unsigned long shmem_get_unmapped_
>  #endif
>  
>  extern int can_do_mlock(void);
> +extern void acct_shm_lock(unsigned long, struct user_struct *);
>  extern int user_shm_lock(size_t, struct user_struct *);
>  extern void user_shm_unlock(size_t, struct user_struct *);
> +extern spinlock_t shmlock_user_lock;
>  
>  /*
>   * Parameter block passed down to zap_pte_range in exceptional cases.
> Index: linux-2.6-tip/mm/mlock.c
> ===================================================================
> --- linux-2.6-tip.orig/mm/mlock.c	2009-02-04 15:21:45.000000000 -0800
> +++ linux-2.6-tip/mm/mlock.c	2009-02-04 15:23:19.000000000 -0800
> @@ -637,7 +637,13 @@ SYSCALL_DEFINE0(munlockall)
>   * Objects with different lifetime than processes (SHM_LOCK and SHM_HUGETLB
>   * shm segments) get accounted against the user_struct instead.
>   */
> -static DEFINE_SPINLOCK(shmlock_user_lock);
> +DEFINE_SPINLOCK(shmlock_user_lock);
> +
> +void acct_shm_lock(unsigned long pages, struct user_struct *user)
> +{
> +	get_uid(user);
> +	user->locked_shm += pages;
> +}
>  
>  int user_shm_lock(size_t size, struct user_struct *user)
>  {
> @@ -653,8 +659,7 @@ int user_shm_lock(size_t size, struct us
>  	if (!allowed &&
>  	    locked + user->locked_shm > lock_limit && !capable(CAP_IPC_LOCK))
>  		goto out;
> -	get_uid(user);
> -	user->locked_shm += locked;
> +	acct_shm_lock(locked, user);
>  	allowed = 1;
>  out:
>  	spin_unlock(&shmlock_user_lock);
> Index: linux-2.6-tip/Documentation/vm/hugetlbpage.txt
> ===================================================================
> --- linux-2.6-tip.orig/Documentation/vm/hugetlbpage.txt	2009-02-04 15:21:45.000000000 -0800
> +++ linux-2.6-tip/Documentation/vm/hugetlbpage.txt	2009-02-04 15:23:19.000000000 -0800
> @@ -147,11 +147,12 @@ used to change the file attributes on hu
>  
>  Also, it is important to note that no such mount command is required if the
>  applications are going to use only shmat/shmget system calls.  Users who
> -wish to use hugetlb page via shared memory segment should be a member of
> -a supplementary group and system admin needs to configure that gid into
> -/proc/sys/vm/hugetlb_shm_group.  It is possible for same or different
> -applications to use any combination of mmaps and shm* calls, though the
> -mount of filesystem will be required for using mmap calls.
> +wish to use hugetlb page via shared memory segment should either have
> +sufficient memlock resource limits or, they need to be a member of
> +a supplementary group, and system admin needs to configure that gid into
> +/proc/sys/vm/hugetlb_shm_group. It is possible for same or different
> +applications to use any combination of mmaps and shm* calls, though
> +the mount of filesystem will be required for using mmap calls.
>  
>  *******************************************************************
>  
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>



