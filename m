Return-Path: <linux-kernel-owner+w=401wt.eu-S1755189AbYIKKnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbYIKKnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 06:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbYIKKn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 06:43:26 -0400
Received: from ns.suse.de ([195.135.220.2]:43871 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752357AbYIKKnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 06:43:25 -0400
Date: Thu, 11 Sep 2008 12:43:23 +0200
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86: some lock annotations for user copy paths
Message-ID: <20080911104323.GB23775@wotan.suse.de>
References: <20080910113717.GB16811@wotan.suse.de> <1221046892.30429.85.camel@twins.programming.kicks-ass.net> <20080910114755.GA9696@elte.hu> <20080910121217.GA16013@elte.hu> <20080910144812.GB18644@wotan.suse.de> <1221058864.30429.291.camel@twins.programming.kicks-ass.net> <20080910152651.GE18644@wotan.suse.de> <20080911082709.GA14378@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080911082709.GA14378@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2008 at 10:27:10AM +0200, Ingo Molnar wrote:
> 
> * Nick Piggin <npiggin@suse.de> wrote:
> 
> > On Wed, Sep 10, 2008 at 05:01:04PM +0200, Peter Zijlstra wrote:
> > > >  extern struct atomic_notifier_head panic_notifier_list;
> > > >  extern long (*panic_blink)(long time);
> > > >  NORET_TYPE void panic(const char * fmt, ...)
> > > 
> > > This forgets that in_atomic() again - possibly triggering might_sleep()
> > > where not appropriate.
> > > 
> > > I'm not sure its worth it to out-of-line the thing though (its only big
> > > on debug builds), and CONFIG_LOCKDEP is the wrong CONFIG_* variable, I
> > > think CONFIG_PROVE_LOCKING would be the appropriate one.
> > 
> > OK, last attempt. If this breaks, then I give up for the day :)
> 
> i've tidied it up a bit:
> 
>  - moved the might_sleep() check outside the in_atomic() check,

Hmm... but then it has the same failure case again in the is_preempt()
code, does it not?

I guess we should just convert that guy to either use get_user_atomic,
(which would mean implementing that for x86), or use copy_from_user_inatomic.


>  - fixed a spelling mistake
>  - fixed a build error on !LOCKDEP
>  - changed the CONFIG_LOCKDEP dependency to CONFIG_PROVE_LOCKING

Thanks.

 
> and it's working fine on most boxes. One testbox found this new locking 
> scenario:
> 
> PM: Adding info for No Bus:vcsa7
> EDAC DEBUG: MC0: i82860_check()
> 
> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.27-rc6-tip #1
> -------------------------------------------------------
> X/4873 is trying to acquire lock:
>  (&bb->mutex){--..}, at: [<c020ba20>] mmap+0x40/0xa0
> 
> but task is already holding lock:
>  (&mm->mmap_sem){----}, at: [<c0125a1e>] sys_mmap2+0x8e/0xc0
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #1 (&mm->mmap_sem){----}:
>        [<c017dc96>] validate_chain+0xa96/0xf50
>        [<c017ef2b>] __lock_acquire+0x2cb/0x5b0
>        [<c017f299>] lock_acquire+0x89/0xc0
>        [<c01aa8fb>] might_fault+0x6b/0x90
>        [<c040b618>] copy_to_user+0x38/0x60
>        [<c020bcfb>] read+0xfb/0x170
>        [<c01c09a5>] vfs_read+0x95/0x110
>        [<c01c1443>] sys_pread64+0x63/0x80
>        [<c012146f>] sysenter_do_call+0x12/0x43
>        [<ffffffff>] 0xffffffff
> 
> -> #0 (&bb->mutex){--..}:
>        [<c017d8b7>] validate_chain+0x6b7/0xf50
>        [<c017ef2b>] __lock_acquire+0x2cb/0x5b0
>        [<c017f299>] lock_acquire+0x89/0xc0
>        [<c0d6f2ab>] __mutex_lock_common+0xab/0x3c0
>        [<c0d6f698>] mutex_lock_nested+0x38/0x50
>        [<c020ba20>] mmap+0x40/0xa0
>        [<c01b111e>] mmap_region+0x14e/0x450
>        [<c01b170f>] do_mmap_pgoff+0x2ef/0x310
>        [<c0125a3d>] sys_mmap2+0xad/0xc0
>        [<c012146f>] sysenter_do_call+0x12/0x43
>        [<ffffffff>] 0xffffffff
> 
> other info that might help us debug this:
> 
> 1 lock held by X/4873:
>  #0:  (&mm->mmap_sem){----}, at: [<c0125a1e>] sys_mmap2+0x8e/0xc0
> 
> stack backtrace:
> Pid: 4873, comm: X Not tainted 2.6.27-rc6-tip #1
>  [<c017cd09>] print_circular_bug_tail+0x79/0xc0
>  [<c017d8b7>] validate_chain+0x6b7/0xf50
>  [<c017a5b5>] ? trace_hardirqs_off_caller+0x15/0xb0
>  [<c017ef2b>] __lock_acquire+0x2cb/0x5b0
>  [<c017f299>] lock_acquire+0x89/0xc0
>  [<c020ba20>] ? mmap+0x40/0xa0
>  [<c0d6f2ab>] __mutex_lock_common+0xab/0x3c0
>  [<c020ba20>] ? mmap+0x40/0xa0
>  [<c0d6f698>] mutex_lock_nested+0x38/0x50
>  [<c020ba20>] ? mmap+0x40/0xa0
>  [<c020ba20>] mmap+0x40/0xa0
>  [<c01b111e>] mmap_region+0x14e/0x450
>  [<c01afb88>] ? arch_get_unmapped_area_topdown+0xf8/0x160
>  [<c01b170f>] do_mmap_pgoff+0x2ef/0x310
>  [<c0125a3d>] sys_mmap2+0xad/0xc0
>  [<c012146f>] sysenter_do_call+0x12/0x43
>  [<c0120000>] ? __switch_to+0x130/0x220
>  =======================
> evbug.c: Event. Dev: input3, Type: 20, Code: 0, Value: 500
> warning: `sudo' uses deprecated v2 capabilities in a way that may be insecure.
> 
> i've attached the config.
> 
> at first sight it looks like a genuine bug in fs/sysfs/bin.c?

Yes, it is a real bug by the looks. bin.c takes bb->mutex under mmap_sem
when it is mmapped, and then does its copy_*_user under bb->mutex too.


> i.e. your patches are working as expected and the extended validation 
> mechanism is finding real bugs :-)

Yeah it's nice. I'm just hoping we don't come across one that is as
difficult to fix as prepare_write/commit_write were ;)

Here is a basic fix for the sysfs lor.
---

Index: linux-2.6/fs/sysfs/bin.c
===================================================================
--- linux-2.6.orig/fs/sysfs/bin.c
+++ linux-2.6/fs/sysfs/bin.c
@@ -61,6 +61,7 @@ read(struct file *file, char __user *use
 	int size = dentry->d_inode->i_size;
 	loff_t offs = *off;
 	int count = min_t(size_t, bytes, PAGE_SIZE);
+	char *temp;
 
 	if (size) {
 		if (offs > size)
@@ -69,23 +70,33 @@ read(struct file *file, char __user *use
 			count = size - offs;
 	}
 
+	temp = kmalloc(count, GFP_KERNEL);
+	if (!temp)
+		return -ENOMEM;
+
 	mutex_lock(&bb->mutex);
 
 	count = fill_read(dentry, bb->buffer, offs, count);
-	if (count < 0)
-		goto out_unlock;
+	if (count < 0) {
+		mutex_unlock(&bb->mutex);
+		goto out_free;
+	}
 
-	if (copy_to_user(userbuf, bb->buffer, count)) {
+	memcpy(temp, bb->buffer, count);
+
+	mutex_unlock(&bb->mutex);
+
+	if (copy_to_user(userbuf, temp, count)) {
 		count = -EFAULT;
-		goto out_unlock;
+		goto out_free;
 	}
 
 	pr_debug("offs = %lld, *off = %lld, count = %d\n", offs, *off, count);
 
 	*off = offs + count;
 
- out_unlock:
-	mutex_unlock(&bb->mutex);
+ out_free:
+	kfree(temp);
 	return count;
 }
 
@@ -118,6 +129,7 @@ static ssize_t write(struct file *file, 
 	int size = dentry->d_inode->i_size;
 	loff_t offs = *off;
 	int count = min_t(size_t, bytes, PAGE_SIZE);
+	char *temp;
 
 	if (size) {
 		if (offs > size)
@@ -126,19 +138,27 @@ static ssize_t write(struct file *file, 
 			count = size - offs;
 	}
 
-	mutex_lock(&bb->mutex);
+	temp = kmalloc(count, GFP_KERNEL);
+	if (!temp)
+		return -ENOMEM;
 
-	if (copy_from_user(bb->buffer, userbuf, count)) {
+	if (copy_from_user(temp, userbuf, count)) {
 		count = -EFAULT;
-		goto out_unlock;
+		goto out_free;
 	}
 
+	mutex_lock(&bb->mutex);
+
+	memcpy(bb->buffer, temp, count);
+
 	count = flush_write(dentry, bb->buffer, offs, count);
+	mutex_unlock(&bb->mutex);
+
 	if (count > 0)
 		*off = offs + count;
 
- out_unlock:
-	mutex_unlock(&bb->mutex);
+out_free:
+	kfree(temp);
 	return count;
 }
 
