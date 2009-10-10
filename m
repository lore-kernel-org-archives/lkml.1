Return-Path: <linux-kernel-owner+w=401wt.eu-S934437AbZJJPlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934437AbZJJPlt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 11:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761926AbZJJPhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 11:37:50 -0400
Received: from www.tglx.de ([62.245.132.106]:55384 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761819AbZJJPhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 11:37:47 -0400
Message-Id: <20091010153349.365236337@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sat, 10 Oct 2009 15:35:57 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, John Kacur <jkacur@redhat.com>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>
Subject: [patch 08/28] x86: Remove BKL from apm_32
References: <20091010153314.827301943@linutronix.de>
Content-Disposition: inline; filename=x86-remove-bkl-from-apm-32.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The lock/unlock kernel pair in do_open() got there with the BKL push
down and protects nothing. Remove it.

Replace the lock/unlock kernel in the ioctl code with a mutex to
protect standbys_pending and suspends_pending.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apm_32.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

Index: linux-2.6-tip/arch/x86/kernel/apm_32.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apm_32.c
+++ linux-2.6-tip/arch/x86/kernel/apm_32.c
@@ -204,7 +204,6 @@
 #include <linux/module.h>
 
 #include <linux/poll.h>
-#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/stddef.h>
 #include <linux/timer.h>
@@ -403,6 +402,7 @@ static DECLARE_WAIT_QUEUE_HEAD(apm_waitq
 static DECLARE_WAIT_QUEUE_HEAD(apm_suspend_waitqueue);
 static struct apm_user *user_list;
 static DEFINE_SPINLOCK(user_list_lock);
+static DEFINE_MUTEX(apm_mutex);
 
 /*
  * Set up a segment that references the real mode segment 0x40
@@ -1531,7 +1531,7 @@ static long do_ioctl(struct file *filp, 
 		return -EPERM;
 	switch (cmd) {
 	case APM_IOC_STANDBY:
-		lock_kernel();
+		mutex_lock(&apm_mutex);
 		if (as->standbys_read > 0) {
 			as->standbys_read--;
 			as->standbys_pending--;
@@ -1540,10 +1540,10 @@ static long do_ioctl(struct file *filp, 
 			queue_event(APM_USER_STANDBY, as);
 		if (standbys_pending <= 0)
 			standby();
-		unlock_kernel();
+		mutex_unlock(&apm_mutex);
 		break;
 	case APM_IOC_SUSPEND:
-		lock_kernel();
+		mutex_lock(&apm_mutex);
 		if (as->suspends_read > 0) {
 			as->suspends_read--;
 			as->suspends_pending--;
@@ -1552,13 +1552,14 @@ static long do_ioctl(struct file *filp, 
 			queue_event(APM_USER_SUSPEND, as);
 		if (suspends_pending <= 0) {
 			ret = suspend(1);
+			mutex_unlock(&apm_mutex);
 		} else {
 			as->suspend_wait = 1;
+			mutex_unlock(&apm_mutex);
 			wait_event_interruptible(apm_suspend_waitqueue,
 					as->suspend_wait == 0);
 			ret = as->suspend_result;
 		}
-		unlock_kernel();
 		return ret;
 	default:
 		return -ENOTTY;
@@ -1608,12 +1609,10 @@ static int do_open(struct inode *inode, 
 {
 	struct apm_user *as;
 
-	lock_kernel();
 	as = kmalloc(sizeof(*as), GFP_KERNEL);
 	if (as == NULL) {
 		printk(KERN_ERR "apm: cannot allocate struct of size %d bytes\n",
 		       sizeof(*as));
-		       unlock_kernel();
 		return -ENOMEM;
 	}
 	as->magic = APM_BIOS_MAGIC;
@@ -1635,7 +1634,6 @@ static int do_open(struct inode *inode, 
 	user_list = as;
 	spin_unlock(&user_list_lock);
 	filp->private_data = as;
-	unlock_kernel();
 	return 0;
 }
 


