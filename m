Return-Path: <linux-kernel-owner+w=401wt.eu-S1756055AbZDNRpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbZDNRpl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 13:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753634AbZDNRpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 13:45:30 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:33625 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbZDNRp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 13:45:28 -0400
Date: Tue, 14 Apr 2009 18:45:34 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: arjan@linux.intel.com, gregkh@suse.de, jmorris@namei.org,
       hooanon05@yahoo.co.jp, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: current->mm == NULL in security_vm_enough_memory().
In-Reply-To: <200904132127.FBG30222.OOFFtQLJFOHSMV@I-love.SAKURA.ne.jp>
Message-ID: <Pine.LNX.4.64.0904141812390.24679@blonde.anvils>
References: <200903260130.n2Q1U9EJ040448@www262.sakura.ne.jp>
 <alpine.LRH.2.00.0903261236580.30336@tundra.namei.org>
 <200904092105.HBG52601.MHFOtQOLSVFOFJ@I-love.SAKURA.ne.jp>
 <200904132127.FBG30222.OOFFtQLJFOHSMV@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Apr 2009, Tetsuo Handa wrote:
> 
> I'm experiencing
> 
>   WARNING: at security/security.c:217 security_vm_enough_memory+0xa0/0xb0()
> 
> messages.
> "git bisect" reported that commit f520360d93cdc37de5d972dac4bf3bdef6a7f6a7
> is the cause of this warning. May I ignore this warning?

I do believe you may ignore them.

Thanks for doing the bisection: perhaps that commit just changed timings.

> Tetsuo Handa wrote:
> > James Morris wrote:
> > > khelper is a kernel thread, so it should not have an ->mm, but I wonder
> > > why this hasn't shown up before.  Odd...

I don't see anything wrong with an mm-less kernel helper trying to
exec something, and thereby arriving at security_vm_enough_memory(),
so triggering those warnings. 

Easy enough for you to comment them out of security/security.c for now,
and see whether that has any effect on your "RCU detected CPU 1 stall".
I'd guess not (and probably not worth bothering): I suspect the mm-less-
ness is relevant to both issues, but the messages themselves not.

But the real fix would be to back out, not just the warnings,
but almost all of Alan's 731572d39fcd3498702eda4600db4c43d51e0b26
nfsd: fix vm overcommit crash, appended below.

Alan, you remark in that commit:
    We could simply check for NULL and skip the modifier but we've caught
    other real bugs in the past from mm being NULL here - cases where we did
    need a valid mm set up (eg the exec bug about a year ago).

Please could you remind us of that bug?  I just don't see what's so
bad about calling __vm_enough_memory with NULL mm, it's only use
there is to reduce the allowance for an already large process.

You'd be right to argue that actually exec should be arranging for
the bprm->mm to be passed down there, but I don't think that's worth
the effort of additional interfaces.

Hugh

> > 
> > I don't see this message for 2.6.29 and earlier.
> > As of 2.6.30-rc1, this problem is not solved yet.
> > I think something happened between 2.6.29 and 2.6.30-rc1.
> > 
> > http://I-love.SAKURA.ne.jp/tmp/dmesg-2.6.30-rc1.txt
> > http://I-love.SAKURA.ne.jp/tmp/config-2.6.30-rc1
>
> [bisection]
>  
> f520360d93cdc37de5d972dac4bf3bdef6a7f6a7 is first bad commit
> commit f520360d93cdc37de5d972dac4bf3bdef6a7f6a7
> Author: Arjan van de Ven <arjan@linux.intel.com>
> Date:   Thu Mar 19 09:09:05 2009 -0700
> 
>     kobject: don't block for each kobject_uevent
> 
>     Right now, the kobject_uevent code blocks for each uevent that's being
>     generated, due to using (for hystoric reasons) UHM_WAIT_EXEC as flag to
>     call_usermode_helper().  Specifically, the effect is that each uevent
>     that is being sent causes the code to wake up keventd, then block until
>     keventd has processed the work. Needless to say, this happens many times
>     during the system boot.
> 
>     This patches changes that to UHN_NO_WAIT (brilliant name for a constant
>     btw) so that we only schedule the work to fire the uevent message, but
>     do not wait for keventd to process the work.
> 
>     This removes one of the bottlenecks during boot; each one of them is
>     only a small effect, but the sum of them does add up.
> 
>     [Note, distros that need this are broken, they should be setting
>     CONFIG_UEVENT_HELPER_PATH to "", that way this code path will never be
>     excuted at all -- gregkh]
> 
>     Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

commit 731572d39fcd3498702eda4600db4c43d51e0b26
Author: Alan Cox <alan@redhat.com>
Date:   Wed Oct 29 14:01:20 2008 -0700

    nfsd: fix vm overcommit crash
    
    Junjiro R.  Okajima reported a problem where knfsd crashes if you are
    using it to export shmemfs objects and run strict overcommit.  In this
    situation the current->mm based modifier to the overcommit goes through a
    NULL pointer.
    
    We could simply check for NULL and skip the modifier but we've caught
    other real bugs in the past from mm being NULL here - cases where we did
    need a valid mm set up (eg the exec bug about a year ago).
    
    To preserve the checks and get the logic we want shuffle the checking
    around and add a new helper to the vm_ security wrappers
    
    Also fix a current->mm reference in nommu that should use the passed mm
    
    [akpm@linux-foundation.org: coding-style fixes]
    [akpm@linux-foundation.org: fix build]
    Reported-by: Junjiro R. Okajima <hooanon05@yahoo.co.jp>
    Acked-by: James Morris <jmorris@namei.org>
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/include/linux/security.h b/include/linux/security.h
index f5c4a51..c13f1ce 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1585,6 +1585,7 @@ int security_syslog(int type);
 int security_settime(struct timespec *ts, struct timezone *tz);
 int security_vm_enough_memory(long pages);
 int security_vm_enough_memory_mm(struct mm_struct *mm, long pages);
+int security_vm_enough_memory_kern(long pages);
 int security_bprm_alloc(struct linux_binprm *bprm);
 void security_bprm_free(struct linux_binprm *bprm);
 void security_bprm_apply_creds(struct linux_binprm *bprm, int unsafe);
@@ -1820,6 +1821,11 @@ static inline int security_vm_enough_memory(long pages)
 	return cap_vm_enough_memory(current->mm, pages);
 }
 
+static inline int security_vm_enough_memory_kern(long pages)
+{
+	return cap_vm_enough_memory(current->mm, pages);
+}
+
 static inline int security_vm_enough_memory_mm(struct mm_struct *mm, long pages)
 {
 	return cap_vm_enough_memory(mm, pages);
diff --git a/mm/mmap.c b/mm/mmap.c
index 74f4d15..de14ac2 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -175,7 +175,8 @@ int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
 
 	/* Don't let a single process grow too big:
 	   leave 3% of the size of this process for other processes */
-	allowed -= mm->total_vm / 32;
+	if (mm)
+		allowed -= mm->total_vm / 32;
 
 	/*
 	 * cast `allowed' as a signed long because vm_committed_space
diff --git a/mm/nommu.c b/mm/nommu.c
index 2696b24..7695dc8 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1454,7 +1454,8 @@ int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
 
 	/* Don't let a single process grow too big:
 	   leave 3% of the size of this process for other processes */
-	allowed -= current->mm->total_vm / 32;
+	if (mm)
+		allowed -= mm->total_vm / 32;
 
 	/*
 	 * cast `allowed' as a signed long because vm_committed_space
diff --git a/mm/shmem.c b/mm/shmem.c
index d38d7e6..0ed0752 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -161,8 +161,8 @@ static inline struct shmem_sb_info *SHMEM_SB(struct super_block *sb)
  */
 static inline int shmem_acct_size(unsigned long flags, loff_t size)
 {
-	return (flags & VM_ACCOUNT)?
-		security_vm_enough_memory(VM_ACCT(size)): 0;
+	return (flags & VM_ACCOUNT) ?
+		security_vm_enough_memory_kern(VM_ACCT(size)) : 0;
 }
 
 static inline void shmem_unacct_size(unsigned long flags, loff_t size)
@@ -179,8 +179,8 @@ static inline void shmem_unacct_size(unsigned long flags, loff_t size)
  */
 static inline int shmem_acct_block(unsigned long flags)
 {
-	return (flags & VM_ACCOUNT)?
-		0: security_vm_enough_memory(VM_ACCT(PAGE_CACHE_SIZE));
+	return (flags & VM_ACCOUNT) ?
+		0 : security_vm_enough_memory_kern(VM_ACCT(PAGE_CACHE_SIZE));
 }
 
 static inline void shmem_unacct_blocks(unsigned long flags, long pages)
diff --git a/security/security.c b/security/security.c
index 255b085..c0acfa7 100644
--- a/security/security.c
+++ b/security/security.c
@@ -198,14 +198,23 @@ int security_settime(struct timespec *ts, struct timezone *tz)
 
 int security_vm_enough_memory(long pages)
 {
+	WARN_ON(current->mm == NULL);
 	return security_ops->vm_enough_memory(current->mm, pages);
 }
 
 int security_vm_enough_memory_mm(struct mm_struct *mm, long pages)
 {
+	WARN_ON(mm == NULL);
 	return security_ops->vm_enough_memory(mm, pages);
 }
 
+int security_vm_enough_memory_kern(long pages)
+{
+	/* If current->mm is a kernel thread then we will pass NULL,
+	   for this specific case that is fine */
+	return security_ops->vm_enough_memory(current->mm, pages);
+}
+
 int security_bprm_alloc(struct linux_binprm *bprm)
 {
 	return security_ops->bprm_alloc_security(bprm);
