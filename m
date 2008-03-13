Return-Path: <linux-kernel-owner+w=401wt.eu-S1757248AbYCMUgH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248AbYCMUgH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 16:36:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754502AbYCMUfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 16:35:55 -0400
Received: from cnc.isely.net ([64.81.146.143]:37036 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654AbYCMUfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 16:35:53 -0400
X-Greylist: delayed 315 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Mar 2008 16:35:53 EDT
Date: Thu, 13 Mar 2008 15:30:35 -0500 (CDT)
From: Mike Isely <isely@isely.net>
Reply-To: Mike Isely <isely@pobox.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: David Airlie <airlied@linux.ie>, Mike Isely at pobox <isely@pobox.com>
Subject: [PATCH] drm: Fix race that can lockup the kernel
Message-ID: <Pine.LNX.4.64.0803131515120.1964@cnc.isely.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The i915_vblank_swap() function schedules an automatic buffer swap
upon receipt of the vertical sync interrupt.  Such an operation is
lengthy so it can't be allowed to happen in normal interrupt context,
thus the DRM implements this by scheduling the work in a kernel
softirq-scheduled tasklet.  In order for the buffer swap to work
safely, the DRM's central lock must be taken, via a call to
drm_lock_take() located in drivers/char/drm/drm_irq.c within the
function drm_locked_tasklet_func().  The lock-taking logic uses a
non-interrupt-blocking spinlock to implement the manipulations needed
to take the lock.  This semantic would be safe if all attempts to use
the spinlock only happen from process context.  However this buffer
swap happens from softirq context which is really a form of interrupt
context.  Thus we have an unsafe situation, in that
drm_locked_tasklet_func() can block on a spinlock already taken by a
thread in process context which will never get scheduled again because
of the blocked softirq tasklet.  This wedges the kernel hard.

To trigger this bug, run a dual-head cloned mode configuration which
uses the i915 drm, then execute an opengl application which
synchronizes buffer swaps against the vertical sync interrupt.  In my
testing, a lockup always results after running anywhere from 5 minutes
to an hour and a half.  I believe dual-head is needed to really
trigger the problem because then the vertical sync interrupt handling
is no longer predictable (due to being interrupt-sourced from two
different heads running at different speeds).  This raises the
probability of the tasklet trying to run while the userspace DRI is
doing things to the GPU (and manipulating the DRM lock).

The fix is to change the relevant spinlock semantics to be the
interrupt-blocking form.  After this change I am no longer able to
trigger the lockup; the longest test run so far was 20 hours (test
stopped after that point).

Note: I have examined the places where this spinlock is being
employed; all are reasonably short bounded sequences and should be
suitable for interrupts being blocked without impacting overall kernel
interrupt response latency.

Signed-off-by: Mike Isely <isely@pobox.com>

---

Additional (non-commit-comment) note: I had opened a report and placed
a fix in the bug tracker for the DRI developers (found at
bugzilla.freedesktop.org, bug ID 14937) but so far nobody there seems
to have noticed it.  Thus this post to LKML and cc: to the maintainer.
Also, the patch in the bugzilla entry has 2 trivial checkpatch
warnings; this patch is tweaked slightly to clean that up.

 drivers/char/drm/drm_fops.c |    7 ++++--
 drivers/char/drm/drm_lock.c |   35 +++++++++++++++++++---------------
 2 files changed, 25 insertions(+), 17 deletions(-)

diff -uprN -X linux-2.6.24.3/Documentation/dontdiff linux-2.6.24.3/drivers/char/drm/drm_fops.c linux-2.6.24.3-drm-spinlock-fix/drivers/char/drm/drm_fops.c
--- linux-2.6.24.3/drivers/char/drm/drm_fops.c	2008-02-25 18:20:20.000000000 -0600
+++ linux-2.6.24.3-drm-spinlock-fix/drivers/char/drm/drm_fops.c	2008-03-13 13:52:49.000000000 -0500
@@ -326,6 +326,7 @@ int drm_release(struct inode *inode, str
 	struct drm_file *file_priv = filp->private_data;
 	struct drm_device *dev = file_priv->head->dev;
 	int retcode = 0;
+	unsigned long irqflags;
 
 	lock_kernel();
 
@@ -357,9 +358,11 @@ int drm_release(struct inode *inode, str
 			 */
 
 			do{
-				spin_lock(&dev->lock.spinlock);
+				spin_lock_irqsave(&dev->lock.spinlock,
+						  irqflags);
 				locked = dev->lock.idle_has_lock;
-				spin_unlock(&dev->lock.spinlock);
+				spin_unlock_irqrestore(&dev->lock.spinlock,
+						       irqflags);
 				if (locked)
 					break;
 				schedule();
diff -uprN -X linux-2.6.24.3/Documentation/dontdiff linux-2.6.24.3/drivers/char/drm/drm_lock.c linux-2.6.24.3-drm-spinlock-fix/drivers/char/drm/drm_lock.c
--- linux-2.6.24.3/drivers/char/drm/drm_lock.c	2008-02-25 18:20:20.000000000 -0600
+++ linux-2.6.24.3-drm-spinlock-fix/drivers/char/drm/drm_lock.c	2008-03-06 15:23:34.000000000 -0600
@@ -53,6 +53,7 @@ int drm_lock(struct drm_device *dev, voi
 	DECLARE_WAITQUEUE(entry, current);
 	struct drm_lock *lock = data;
 	int ret = 0;
+	unsigned long irqflags;
 
 	++file_priv->lock_count;
 
@@ -71,9 +72,9 @@ int drm_lock(struct drm_device *dev, voi
 			return -EINVAL;
 
 	add_wait_queue(&dev->lock.lock_queue, &entry);
-	spin_lock(&dev->lock.spinlock);
+	spin_lock_irqsave(&dev->lock.spinlock, irqflags);
 	dev->lock.user_waiters++;
-	spin_unlock(&dev->lock.spinlock);
+	spin_unlock_irqrestore(&dev->lock.spinlock, irqflags);
 	for (;;) {
 		__set_current_state(TASK_INTERRUPTIBLE);
 		if (!dev->lock.hw_lock) {
@@ -95,9 +96,9 @@ int drm_lock(struct drm_device *dev, voi
 			break;
 		}
 	}
-	spin_lock(&dev->lock.spinlock);
+	spin_lock_irqsave(&dev->lock.spinlock, irqflags);
 	dev->lock.user_waiters--;
-	spin_unlock(&dev->lock.spinlock);
+	spin_unlock_irqrestore(&dev->lock.spinlock, irqflags);
 	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(&dev->lock.lock_queue, &entry);
 
@@ -198,8 +199,9 @@ int drm_lock_take(struct drm_lock_data *
 {
 	unsigned int old, new, prev;
 	volatile unsigned int *lock = &lock_data->hw_lock->lock;
+	unsigned long irqflags;
 
-	spin_lock(&lock_data->spinlock);
+	spin_lock_irqsave(&lock_data->spinlock, irqflags);
 	do {
 		old = *lock;
 		if (old & _DRM_LOCK_HELD)
@@ -211,7 +213,7 @@ int drm_lock_take(struct drm_lock_data *
 		}
 		prev = cmpxchg(lock, old, new);
 	} while (prev != old);
-	spin_unlock(&lock_data->spinlock);
+	spin_unlock_irqrestore(&lock_data->spinlock, irqflags);
 
 	if (_DRM_LOCKING_CONTEXT(old) == context) {
 		if (old & _DRM_LOCK_HELD) {
@@ -272,15 +274,16 @@ int drm_lock_free(struct drm_lock_data *
 {
 	unsigned int old, new, prev;
 	volatile unsigned int *lock = &lock_data->hw_lock->lock;
+	unsigned long irqflags;
 
-	spin_lock(&lock_data->spinlock);
+	spin_lock_irqsave(&lock_data->spinlock, irqflags);
 	if (lock_data->kernel_waiters != 0) {
 		drm_lock_transfer(lock_data, 0);
 		lock_data->idle_has_lock = 1;
-		spin_unlock(&lock_data->spinlock);
+		spin_unlock_irqrestore(&lock_data->spinlock, irqflags);
 		return 1;
 	}
-	spin_unlock(&lock_data->spinlock);
+	spin_unlock_irqrestore(&lock_data->spinlock, irqflags);
 
 	do {
 		old = *lock;
@@ -344,19 +347,20 @@ static int drm_notifier(void *priv)
 void drm_idlelock_take(struct drm_lock_data *lock_data)
 {
 	int ret = 0;
+	unsigned long irqflags;
 
-	spin_lock(&lock_data->spinlock);
+	spin_lock_irqsave(&lock_data->spinlock, irqflags);
 	lock_data->kernel_waiters++;
 	if (!lock_data->idle_has_lock) {
 
-		spin_unlock(&lock_data->spinlock);
+		spin_unlock_irqrestore(&lock_data->spinlock, irqflags);
 		ret = drm_lock_take(lock_data, DRM_KERNEL_CONTEXT);
-		spin_lock(&lock_data->spinlock);
+		spin_lock_irqsave(&lock_data->spinlock, irqflags);
 
 		if (ret == 1)
 			lock_data->idle_has_lock = 1;
 	}
-	spin_unlock(&lock_data->spinlock);
+	spin_unlock_irqrestore(&lock_data->spinlock, irqflags);
 }
 EXPORT_SYMBOL(drm_idlelock_take);
 
@@ -364,8 +368,9 @@ void drm_idlelock_release(struct drm_loc
 {
 	unsigned int old, prev;
 	volatile unsigned int *lock = &lock_data->hw_lock->lock;
+	unsigned long irqflags;
 
-	spin_lock(&lock_data->spinlock);
+	spin_lock_irqsave(&lock_data->spinlock, irqflags);
 	if (--lock_data->kernel_waiters == 0) {
 		if (lock_data->idle_has_lock) {
 			do {
@@ -376,7 +381,7 @@ void drm_idlelock_release(struct drm_loc
 			lock_data->idle_has_lock = 0;
 		}
 	}
-	spin_unlock(&lock_data->spinlock);
+	spin_unlock_irqrestore(&lock_data->spinlock, irqflags);
 }
 EXPORT_SYMBOL(drm_idlelock_release);
 
 
-- 

Mike Isely
isely @ pobox (dot) com
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
