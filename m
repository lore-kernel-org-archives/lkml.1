Return-Path: <linux-kernel-owner+w=401wt.eu-S1754041AbYILJYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbYILJYp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 05:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbYILJYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 05:24:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42343 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810AbYILJYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 05:24:34 -0400
Date: Fri, 12 Sep 2008 11:24:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] sysfs: fix deadlock
Message-ID: <20080912092411.GB10305@elte.hu>
References: <20080910113717.GB16811@wotan.suse.de> <1221046892.30429.85.camel@twins.programming.kicks-ass.net> <20080910114755.GA9696@elte.hu> <20080910121217.GA16013@elte.hu> <20080910144812.GB18644@wotan.suse.de> <1221058864.30429.291.camel@twins.programming.kicks-ass.net> <20080910152651.GE18644@wotan.suse.de> <20080911082709.GA14378@elte.hu> <20080911104323.GB23775@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080911104323.GB23775@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ Greg, please see the sysfs fix further below. ]

* Nick Piggin <npiggin@suse.de> wrote:

> >  - moved the might_sleep() check outside the in_atomic() check,
> 
> Hmm... but then it has the same failure case again in the is_preempt() 
> code, does it not?
> 
> I guess we should just convert that guy to either use get_user_atomic, 
> (which would mean implementing that for x86), or use 
> copy_from_user_inatomic.

i've done the v3 patch below - that seems to have passed all my testing 
without any new bugs found. I've reinstated your the clear_user() 
might_fault() check, plus i removed it from __[get|put]_user_size, which 
the _inatomic() API variants use. That enabled me to utilize the 
_inatomic() API in probe_kernel_address().

we still have the checks in put_user()/get_user() and in all the 
copy_*_user() APIs, which should be strong enough. [ I havent fully 
checked whether __get_user_size() might be used by some less frequent 
API - if it is then that API should grow a might_fault() check. ]

> > i've attached the config.
> > 
> > at first sight it looks like a genuine bug in fs/sysfs/bin.c?
> 
> Yes, it is a real bug by the looks. bin.c takes bb->mutex under 
> mmap_sem when it is mmapped, and then does its copy_*_user under 
> bb->mutex too.

ok - second patch attached below, Greg, could you please apply? This is 
for v2.6.27 too i think.

> > i.e. your patches are working as expected and the extended 
> > validation mechanism is finding real bugs :-)
> 
> Yeah it's nice. I'm just hoping we don't come across one that is as 
> difficult to fix as prepare_write/commit_write were ;)
> 
> Here is a basic fix for the sysfs lor.

and that did the trick here - the patch with a tidied up changelog is 
attached further below. [ the second patch is standalone and does not 
need the first patch which is relative to tip/master ]

thanks Nick, i think this is a great addition to lockdep! It already 
found two real locking bugs within a day. If you can think of any other 
proactive methods to widen our lock hierarchy knowledge that would be 
great to add. I think what we want is to insert knowledge about other 
unlikely lock acquire events, for locks that have a historic pattern of 
producing regular locking bugs.

	Ingo

----------------->

>From 1d18ef489509314506328b9e464dd47c24c1d68f Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 11 Sep 2008 20:53:21 +0200
Subject: [PATCH] x86: some lock annotations for user copy paths, v3

- add annotation back to clear_user()
- change probe_kernel_address() to _inatomic*() method

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/lib/usercopy_32.c |    1 +
 include/asm-x86/uaccess.h  |    2 --
 include/linux/uaccess.h    |    2 +-
 3 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/lib/usercopy_32.c b/arch/x86/lib/usercopy_32.c
index 7393152..fab5fab 100644
--- a/arch/x86/lib/usercopy_32.c
+++ b/arch/x86/lib/usercopy_32.c
@@ -148,6 +148,7 @@ do {									\
 unsigned long
 clear_user(void __user *to, unsigned long n)
 {
+	might_fault();
 	if (access_ok(VERIFY_WRITE, to, n))
 		__do_clear_user(to, n);
 	return n;
diff --git a/include/asm-x86/uaccess.h b/include/asm-x86/uaccess.h
index 39f8420..dc8edb5 100644
--- a/include/asm-x86/uaccess.h
+++ b/include/asm-x86/uaccess.h
@@ -267,7 +267,6 @@ extern void __put_user_8(void);
 #define __put_user_size(x, ptr, size, retval, errret)			\
 do {									\
 	retval = 0;							\
-	might_fault();							\
 	__chk_user_ptr(ptr);						\
 	switch (size) {							\
 	case 1:								\
@@ -320,7 +319,6 @@ do {									\
 #define __get_user_size(x, ptr, size, retval, errret)			\
 do {									\
 	retval = 0;							\
-	might_fault();							\
 	__chk_user_ptr(ptr);						\
 	switch (size) {							\
 	case 1:								\
diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index fec6dec..2062293 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -78,7 +78,7 @@ static inline unsigned long __copy_from_user_nocache(void *to,
 							\
 		set_fs(KERNEL_DS);			\
 		pagefault_disable();			\
-		ret = __get_user(retval, (__force typeof(retval) __user *)(addr));		\
+		ret = __copy_from_user_inatomic((__force typeof(retval) __user *)(addr), &(retval), sizeof(retval));		\
 		pagefault_enable();			\
 		set_fs(old_fs);				\
 		ret;					\

------------------->

>From 13f37e1febb1990ae5cabc53eeee1e78198376ff Mon Sep 17 00:00:00 2001
From: Nick Piggin <npiggin@suse.de>
Date: Thu, 11 Sep 2008 12:43:23 +0200
Subject: [PATCH] sysfs: fix deadlock

On Thu, Sep 11, 2008 at 10:27:10AM +0200, Ingo Molnar wrote:

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

Here is a basic fix for the sysfs lor.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 fs/sysfs/bin.c |   42 +++++++++++++++++++++++++++++++-----------
 1 files changed, 31 insertions(+), 11 deletions(-)

diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
index 006fc64..66f6e58 100644
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -61,6 +61,7 @@ read(struct file *file, char __user *userbuf, size_t bytes, loff_t *off)
 	int size = dentry->d_inode->i_size;
 	loff_t offs = *off;
 	int count = min_t(size_t, bytes, PAGE_SIZE);
+	char *temp;
 
 	if (size) {
 		if (offs > size)
@@ -69,23 +70,33 @@ read(struct file *file, char __user *userbuf, size_t bytes, loff_t *off)
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
 
@@ -118,6 +129,7 @@ static ssize_t write(struct file *file, const char __user *userbuf,
 	int size = dentry->d_inode->i_size;
 	loff_t offs = *off;
 	int count = min_t(size_t, bytes, PAGE_SIZE);
+	char *temp;
 
 	if (size) {
 		if (offs > size)
@@ -126,19 +138,27 @@ static ssize_t write(struct file *file, const char __user *userbuf,
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
 

