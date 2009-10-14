Return-Path: <linux-kernel-owner+w=401wt.eu-S934439AbZJNPQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934439AbZJNPQE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:16:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933517AbZJNPQC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:16:02 -0400
Received: from hera.kernel.org ([140.211.167.34]:45334 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933021AbZJNPQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:16:00 -0400
Date: Wed, 14 Oct 2009 15:15:05 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
In-Reply-To: <20091010153349.365236337@linutronix.de>
References: <20091010153349.365236337@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86: Remove BKL from apm_32
Message-ID: <tip-05d86412eab6a18cf57697474cc4f8fbfcd6936f@git.kernel.org>
Git-Commit-ID: 05d86412eab6a18cf57697474cc4f8fbfcd6936f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 15:15:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  05d86412eab6a18cf57697474cc4f8fbfcd6936f
Gitweb:     http://git.kernel.org/tip/05d86412eab6a18cf57697474cc4f8fbfcd6936f
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 9 Oct 2009 19:02:20 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 14 Oct 2009 17:04:48 +0200

x86: Remove BKL from apm_32

The lock/unlock kernel pair in do_open() got there with the BKL push
down and protects nothing. Remove it.

Replace the lock/unlock kernel in the ioctl code with a mutex to
protect standbys_pending and suspends_pending.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <20091010153349.365236337@linutronix.de>

---
 arch/x86/kernel/apm_32.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index 151ace6..b5b6b23 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -204,7 +204,6 @@
 #include <linux/module.h>
 
 #include <linux/poll.h>
-#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/stddef.h>
 #include <linux/timer.h>
@@ -403,6 +402,7 @@ static DECLARE_WAIT_QUEUE_HEAD(apm_waitqueue);
 static DECLARE_WAIT_QUEUE_HEAD(apm_suspend_waitqueue);
 static struct apm_user *user_list;
 static DEFINE_SPINLOCK(user_list_lock);
+static DEFINE_MUTEX(apm_mutex);
 
 /*
  * Set up a segment that references the real mode segment 0x40
@@ -1531,7 +1531,7 @@ static long do_ioctl(struct file *filp, u_int cmd, u_long arg)
 		return -EPERM;
 	switch (cmd) {
 	case APM_IOC_STANDBY:
-		lock_kernel();
+		mutex_lock(&apm_mutex);
 		if (as->standbys_read > 0) {
 			as->standbys_read--;
 			as->standbys_pending--;
@@ -1540,10 +1540,10 @@ static long do_ioctl(struct file *filp, u_int cmd, u_long arg)
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
@@ -1552,13 +1552,14 @@ static long do_ioctl(struct file *filp, u_int cmd, u_long arg)
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
@@ -1608,12 +1609,10 @@ static int do_open(struct inode *inode, struct file *filp)
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
@@ -1635,7 +1634,6 @@ static int do_open(struct inode *inode, struct file *filp)
 	user_list = as;
 	spin_unlock(&user_list_lock);
 	filp->private_data = as;
-	unlock_kernel();
 	return 0;
 }
 
