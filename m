Return-Path: <linux-kernel-owner+w=401wt.eu-S1758609AbYGUKA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609AbYGUKA3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 06:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbYGUKAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 06:00:22 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:35713 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754647AbYGUKAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 06:00:21 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: airlied@linux.ie
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] DRM: don't enable irqs in locking
Date: Mon, 21 Jul 2008 11:58:04 +0200
Message-Id: <1216634284-13412-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.6.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drm_lock_take(); and drm_lock_free(); are called from
drm_locked_tasklet_func(); which disables interrupts when grabbing its
spinlock.

Don't allow these locking functions to re-enable interrupts when
the tasklet expects them disabled. I.e. use spin_lock_irqsave instead of
spin_lock_bh (with their unlock opposites).

We will get such a warnings otherwise:
------------[ cut here ]------------
WARNING: at kernel/softirq.c:136 local_bh_enable_ip+0x8b/0xb0()
Modules linked in: arc4 ecb crypto_blkcipher cryptomgr crypto_algapi ath5k usbhid mac80211 ohci1394 hid led_class floppy cfg80211 ff_memless ieee1394 rtc_cmos evdev [last unloaded: freq_table]
Pid: 0, comm: swapper Not tainted 2.6.26-rc8-mm1_64 #427

Call Trace:
 <IRQ>  [<ffffffff8023813f>] warn_on_slowpath+0x5f/0x90
[...]
 [<ffffffff8023e1fb>] local_bh_enable_ip+0x8b/0xb0
 [<ffffffff8055b2cf>] _spin_unlock_bh+0xf/0x20
 [<ffffffff803b0bd1>] drm_lock_take+0x81/0xe0
 [<ffffffff803b006b>] drm_locked_tasklet_func+0x4b/0xb0
 [<ffffffff8023daf9>] tasklet_hi_action+0x69/0xf0
 [<ffffffff8023e3e4>] __do_softirq+0x84/0xf0
[stack snipped]

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: David Airlie <airlied@linux.ie>
---
 drivers/gpu/drm/drm_lock.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/drm_lock.c b/drivers/gpu/drm/drm_lock.c
index 0998723..79943e4 100644
--- a/drivers/gpu/drm/drm_lock.c
+++ b/drivers/gpu/drm/drm_lock.c
@@ -196,10 +196,11 @@ int drm_unlock(struct drm_device *dev, void *data, struct drm_file *file_priv)
 int drm_lock_take(struct drm_lock_data *lock_data,
 		  unsigned int context)
 {
+	unsigned long flags;
 	unsigned int old, new, prev;
 	volatile unsigned int *lock = &lock_data->hw_lock->lock;
 
-	spin_lock_bh(&lock_data->spinlock);
+	spin_lock_irqsave(&lock_data->spinlock, flags);
 	do {
 		old = *lock;
 		if (old & _DRM_LOCK_HELD)
@@ -211,7 +212,7 @@ int drm_lock_take(struct drm_lock_data *lock_data,
 		}
 		prev = cmpxchg(lock, old, new);
 	} while (prev != old);
-	spin_unlock_bh(&lock_data->spinlock);
+	spin_unlock_irqrestore(&lock_data->spinlock, flags);
 
 	if (_DRM_LOCKING_CONTEXT(old) == context) {
 		if (old & _DRM_LOCK_HELD) {
@@ -270,17 +271,18 @@ static int drm_lock_transfer(struct drm_lock_data *lock_data,
  */
 int drm_lock_free(struct drm_lock_data *lock_data, unsigned int context)
 {
+	unsigned long flags;
 	unsigned int old, new, prev;
 	volatile unsigned int *lock = &lock_data->hw_lock->lock;
 
-	spin_lock_bh(&lock_data->spinlock);
+	spin_lock_irqsave(&lock_data->spinlock, flags);
 	if (lock_data->kernel_waiters != 0) {
 		drm_lock_transfer(lock_data, 0);
 		lock_data->idle_has_lock = 1;
-		spin_unlock_bh(&lock_data->spinlock);
+		spin_unlock_irqrestore(&lock_data->spinlock, flags);
 		return 1;
 	}
-	spin_unlock_bh(&lock_data->spinlock);
+	spin_unlock_irqrestore(&lock_data->spinlock, flags);
 
 	do {
 		old = *lock;
-- 
1.5.6.2

