Return-Path: <linux-kernel-owner+w=401wt.eu-S935274AbXHLQWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935274AbXHLQWH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 12:22:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932202AbXHLQVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 12:21:54 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:8448 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765870AbXHLQVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 12:21:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=fYgt4my6TaH5gRbIzOp+roDqAVGPXvBd7CHp79hMsXORSvJzOlTlGsK7ewwA3OE1s1taPF1R3DKifwAc6MWUjcghH1ntdtBWQoSXDSYz1N6Xys/ozSiHymKCOGLZj7d5jbimxYKTIohKAO0ioSSsHEk6hkr93IjNIKvOI1cO3jw=
Date: Sun, 12 Aug 2007 20:21:43 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: WU Fengguang <wfg@mail.ustc.edu.cn>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Paul Moore <paul.moore@hp.com>, Stephen Smalley <sds@epoch.ncsc.mil>,
       Chris Vance <cvance@nai.com>, Wayne Salamon <wsalamon@nai.com>,
       James Morris <jmorris@redhat.com>, dgoeddel@trustedcs.com
Subject: Re: [BUGFIX] NULL pointer dereference in __vm_enough_memory()
Message-ID: <20070812162143.GA7202@cvg>
References: <20070812141905.4ee423b9@the-village.bc.nu> <386927758.14086@ustc.edu.cn> <20070812161744.200d4252@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070812161744.200d4252@the-village.bc.nu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Alan Cox - Sun, Aug 12, 2007 at 04:17:44PM +0100]
| Try this (it compiles but isnt tested). Its a weekend here, the sun is
| shining, the beach is a short walk, and I have more interesting things to
| do right now 8)
| 
| 
| diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.23rc1-mm1/include/linux/mm.h linux-2.6.23rc1-mm1/include/linux/mm.h
| --- linux.vanilla-2.6.23rc1-mm1/include/linux/mm.h	2007-07-26 15:02:58.000000000 +0100
| +++ linux-2.6.23rc1-mm1/include/linux/mm.h	2007-08-12 13:54:24.614647536 +0100
| @@ -1079,7 +1079,7 @@
|  }
|  
|  /* mmap.c */
| -extern int __vm_enough_memory(long pages, int cap_sys_admin);
| +extern int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin);
|  extern void vma_adjust(struct vm_area_struct *vma, unsigned long start,
|  	unsigned long end, pgoff_t pgoff, struct vm_area_struct *insert);
|  extern struct vm_area_struct *vma_merge(struct mm_struct *,
| diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.23rc1-mm1/include/linux/security.h linux-2.6.23rc1-mm1/include/linux/security.h
| --- linux.vanilla-2.6.23rc1-mm1/include/linux/security.h	2007-07-26 15:02:58.000000000 +0100
| +++ linux-2.6.23rc1-mm1/include/linux/security.h	2007-08-12 14:13:10.383504656 +0100
| @@ -58,7 +58,7 @@
|  extern int cap_task_setioprio (struct task_struct *p, int ioprio);
|  extern int cap_task_setnice (struct task_struct *p, int nice);
|  extern int cap_syslog (int type);
| -extern int cap_vm_enough_memory (long pages);
| +extern int cap_vm_enough_memory (struct mm_struct *mm, long pages);
|  
|  struct msghdr;
|  struct sk_buff;
| @@ -1129,6 +1129,7 @@
|   *	Return 0 if permission is granted.
|   * @vm_enough_memory:
|   *	Check permissions for allocating a new virtual mapping.
| + *	@mm contains the mm struct it is being added to.
|   *      @pages contains the number of pages.
|   *	Return 0 if permission is granted.
|   *
| @@ -1173,7 +1174,7 @@
|  	int (*quota_on) (struct dentry * dentry);
|  	int (*syslog) (int type);
|  	int (*settime) (struct timespec *ts, struct timezone *tz);
| -	int (*vm_enough_memory) (long pages);
| +	int (*vm_enough_memory) (struct mm_struct *mm, long pages);
|  
|  	int (*bprm_alloc_security) (struct linux_binprm * bprm);
|  	void (*bprm_free_security) (struct linux_binprm * bprm);
| @@ -1439,6 +1440,7 @@
|  int security_syslog(int type);
|  int security_settime(struct timespec *ts, struct timezone *tz);
|  int security_vm_enough_memory(long pages);
| +int security_vm_enough_memory_mm(struct mm_struct *mm, long pages);
|  int security_bprm_alloc(struct linux_binprm *bprm);
|  void security_bprm_free(struct linux_binprm *bprm);
|  void security_bprm_apply_creds(struct linux_binprm *bprm, int unsafe);
| diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.23rc1-mm1/mm/mmap.c linux-2.6.23rc1-mm1/mm/mmap.c
| --- linux.vanilla-2.6.23rc1-mm1/mm/mmap.c	2007-07-26 15:02:58.000000000 +0100
| +++ linux-2.6.23rc1-mm1/mm/mmap.c	2007-08-12 13:53:22.000000000 +0100
| @@ -93,7 +93,7 @@
|   * Note this is a helper function intended to be used by LSMs which
|   * wish to use this logic.
|   */
| -int __vm_enough_memory(long pages, int cap_sys_admin)
| +int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
|  {
|  	unsigned long free, allowed;
|  
| @@ -166,7 +166,7 @@
|  
|  	/* Don't let a single process grow too big:
|  	   leave 3% of the size of this process for other processes */
| -	allowed -= current->mm->total_vm / 32;
| +	allowed -= mm->total_vm / 32;

So mm->total_vm is 0 for __bprm_mm_init case. Is that ok? Or I miss
something?

|  
|  	/*
|  	 * cast `allowed' as a signed long because vm_committed_space
| @@ -2058,7 +2058,7 @@
|  	if (__vma && __vma->vm_start < vma->vm_end)
|  		return -ENOMEM;
|  	if ((vma->vm_flags & VM_ACCOUNT) &&
| -	     security_vm_enough_memory(vma_pages(vma)))
| +	     security_vm_enough_memory_mm(mm, vma_pages(vma)))
|  		return -ENOMEM;
|  	vma_link(mm, vma, prev, rb_link, rb_parent);
|  	return 0;
| diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.23rc1-mm1/mm/nommu.c linux-2.6.23rc1-mm1/mm/nommu.c
| --- linux.vanilla-2.6.23rc1-mm1/mm/nommu.c	2007-07-26 15:02:08.000000000 +0100
| +++ linux-2.6.23rc1-mm1/mm/nommu.c	2007-08-12 13:53:57.000000000 +0100
| @@ -1270,7 +1270,7 @@
|   * Note this is a helper function intended to be used by LSMs which
|   * wish to use this logic.
|   */
| -int __vm_enough_memory(long pages, int cap_sys_admin)
| +int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
|  {
|  	unsigned long free, allowed;
|  
| diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.23rc1-mm1/security/commoncap.c linux-2.6.23rc1-mm1/security/commoncap.c
| --- linux.vanilla-2.6.23rc1-mm1/security/commoncap.c	2007-07-26 15:02:59.000000000 +0100
| +++ linux-2.6.23rc1-mm1/security/commoncap.c	2007-08-12 14:13:29.000000000 +0100
| @@ -489,13 +489,13 @@
|  	return 0;
|  }
|  
| -int cap_vm_enough_memory(long pages)
| +int cap_vm_enough_memory(struct mm_struct *mm, long pages)
|  {
|  	int cap_sys_admin = 0;
|  
|  	if (cap_capable(current, CAP_SYS_ADMIN) == 0)
|  		cap_sys_admin = 1;
| -	return __vm_enough_memory(pages, cap_sys_admin);
| +	return __vm_enough_memory(mm, pages, cap_sys_admin);
|  }
|  
|  EXPORT_SYMBOL(cap_capable);
| diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.23rc1-mm1/security/dummy.c linux-2.6.23rc1-mm1/security/dummy.c
| --- linux.vanilla-2.6.23rc1-mm1/security/dummy.c	2007-07-26 15:02:59.000000000 +0100
| +++ linux-2.6.23rc1-mm1/security/dummy.c	2007-08-12 14:10:49.000000000 +0100
| @@ -107,13 +107,13 @@
|  	return 0;
|  }
|  
| -static int dummy_vm_enough_memory(long pages)
| +static int dummy_vm_enough_memory(struct mm_struct *mm, long pages)
|  {
|  	int cap_sys_admin = 0;
|  
|  	if (dummy_capable(current, CAP_SYS_ADMIN) == 0)
|  		cap_sys_admin = 1;
| -	return __vm_enough_memory(pages, cap_sys_admin);
| +	return __vm_enough_memory(mm, pages, cap_sys_admin);
|  }
|  
|  static int dummy_bprm_alloc_security (struct linux_binprm *bprm)
| diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.23rc1-mm1/security/security.c linux-2.6.23rc1-mm1/security/security.c
| --- linux.vanilla-2.6.23rc1-mm1/security/security.c	2007-07-26 15:02:59.000000000 +0100
| +++ linux-2.6.23rc1-mm1/security/security.c	2007-08-12 13:47:53.000000000 +0100
| @@ -237,10 +237,14 @@
|  	return security_ops->settime(ts, tz);
|  }
|  
| -
|  int security_vm_enough_memory(long pages)
|  {
| -	return security_ops->vm_enough_memory(pages);
| +	return security_ops->vm_enough_memory(current->mm, pages);
| +}
| +
| +int security_vm_enough_memory_mm(struct mm_struct *mm, long pages)
| +{
| +	return security_ops->vm_enough_memory(mm, pages);
|  }
|  
|  int security_bprm_alloc(struct linux_binprm *bprm)
| diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.23rc1-mm1/security/selinux/hooks.c linux-2.6.23rc1-mm1/security/selinux/hooks.c
| --- linux.vanilla-2.6.23rc1-mm1/security/selinux/hooks.c	2007-07-26 15:02:59.000000000 +0100
| +++ linux-2.6.23rc1-mm1/security/selinux/hooks.c	2007-08-12 14:11:21.000000000 +0100
| @@ -1584,7 +1584,7 @@
|   * Do not audit the selinux permission check, as this is applied to all
|   * processes that allocate mappings.
|   */
| -static int selinux_vm_enough_memory(long pages)
| +static int selinux_vm_enough_memory(struct mm_struct *mm, long pages)
|  {
|  	int rc, cap_sys_admin = 0;
|  	struct task_security_struct *tsec = current->security;
| @@ -1600,7 +1600,7 @@
|  	if (rc == 0)
|  		cap_sys_admin = 1;
|  
| -	return __vm_enough_memory(pages, cap_sys_admin);
| +	return __vm_enough_memory(mm, pages, cap_sys_admin);
|  }
|  
|  /* binprm security operations */

		Cyrill

