Return-Path: <linux-kernel-owner+w=401wt.eu-S1754850AbYHMIPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbYHMIPY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 04:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbYHMIPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 04:15:06 -0400
Received: from relay.gothnet.se ([82.193.160.251]:1097 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751802AbYHMIPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 04:15:03 -0400
Message-ID: <48A2984E.5050202@tungstengraphics.com>
Date: Wed, 13 Aug 2008 10:16:14 +0200
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@tungstengraphics.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080725)
MIME-Version: 1.0
To: Johannes Engel <jcnengel@googlemail.com>
CC: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1 repost #1] DRM: don't enable irqs in locking
References: <1216975369-6749-1-git-send-email-jirislaby@gmail.com>	<21d7e9970807250154q4a1958f5k45f62408e97ae3c7@mail.gmail.com> <488E2CED.1040207@tungstengraphics.com> <48A18EAB.40808@googlemail.com>
In-Reply-To: <48A18EAB.40808@googlemail.com>
Content-Type: multipart/mixed;
 boundary="------------020204030500010809080405"
X-BitDefender-Scanner: Mail not scanned due to license constraints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020204030500010809080405
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Johannes Engel wrote:
> Thomas Hellstr=F6m wrote:
>> Yes, this bug could occur, but the remedy is not to use=20
>> spin_lock_irqsave() for lock_data::spinlock but to avoid calling=20
>> drm_lock_take with the drm_device::tasklet_lock held with irqs disable=
d.
>> I'll see if I can come up with a patch.
> Hi Thomas,
>
> any news on that so far?
>
> Cheers, Johannes
Hi!
Been on vacation.

Pls try the attached patch.

/Thomas


--------------020204030500010809080405
Content-Type: text/plain;
 name="0001-Don-t-call-the-vblank-tasklet-with-irqs-disabled.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-Don-t-call-the-vblank-tasklet-with-irqs-disabled.patch"

>From af12ef4f6b4ca111d9a2ef45263ad89610498724 Mon Sep 17 00:00:00 2001
From: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
Date: Wed, 13 Aug 2008 10:04:21 +0200
Subject: [PATCH] Don't call the vblank tasklet with irqs disabled.
 If a specific tasklet shares data with irq context,
 it needs to take a private irq-blocking spinlock within
 the tasklet itself.


Signed-off-by: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
---
 linux-core/drm_irq.c  |   20 ++++++++++++--------
 linux-core/drm_lock.c |   12 +++++-------
 2 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/linux-core/drm_irq.c b/linux-core/drm_irq.c
index 5b9f474..57419ca 100644
--- a/linux-core/drm_irq.c
+++ b/linux-core/drm_irq.c
@@ -705,27 +705,31 @@ static void drm_locked_tasklet_func(unsigned long data)
 {
 	struct drm_device *dev = (struct drm_device *)data;
 	unsigned long irqflags;
-
+	void (*tasklet_func)(struct drm_device *);
+	
 	spin_lock_irqsave(&dev->tasklet_lock, irqflags);
+	tasklet_func = dev->locked_tasklet_func;
+	spin_unlock_irqrestore(&dev->tasklet_lock, irqflags);
 
-	if (!dev->locked_tasklet_func ||
+	if (!tasklet_func ||
 	    !drm_lock_take(&dev->lock,
 			   DRM_KERNEL_CONTEXT)) {
-		spin_unlock_irqrestore(&dev->tasklet_lock, irqflags);
 		return;
 	}
 
 	dev->lock.lock_time = jiffies;
 	atomic_inc(&dev->counts[_DRM_STAT_LOCKS]);
 
-	dev->locked_tasklet_func(dev);
+	spin_lock_irqsave(&dev->tasklet_lock, irqflags);
+	tasklet_func = dev->locked_tasklet_func;
+	dev->locked_tasklet_func = NULL;
+	spin_unlock_irqrestore(&dev->tasklet_lock, irqflags);
+	
+	if (tasklet_func != NULL)
+		tasklet_func(dev);
 
 	drm_lock_free(&dev->lock,
 		      DRM_KERNEL_CONTEXT);
-
-	dev->locked_tasklet_func = NULL;
-
-	spin_unlock_irqrestore(&dev->tasklet_lock, irqflags);
 }
 
 /**
diff --git a/linux-core/drm_lock.c b/linux-core/drm_lock.c
index a2966ef..cad2e44 100644
--- a/linux-core/drm_lock.c
+++ b/linux-core/drm_lock.c
@@ -155,6 +155,7 @@ int drm_unlock(struct drm_device *dev, void *data, struct drm_file *file_priv)
 {
 	struct drm_lock *lock = data;
 	unsigned long irqflags;
+	void (*tasklet_func)(struct drm_device *);
 
 	if (lock->context == DRM_KERNEL_CONTEXT) {
 		DRM_ERROR("Process %d using kernel context %d\n",
@@ -163,14 +164,11 @@ int drm_unlock(struct drm_device *dev, void *data, struct drm_file *file_priv)
 	}
 
 	spin_lock_irqsave(&dev->tasklet_lock, irqflags);
-
-	if (dev->locked_tasklet_func) {
-		dev->locked_tasklet_func(dev);
-
-		dev->locked_tasklet_func = NULL;
-	}
-
+	tasklet_func = dev->locked_tasklet_func;
+	dev->locked_tasklet_func = NULL;
 	spin_unlock_irqrestore(&dev->tasklet_lock, irqflags);
+	if (tasklet_func != NULL)
+		tasklet_func(dev);
 
 	atomic_inc(&dev->counts[_DRM_STAT_UNLOCKS]);
 
-- 
1.5.4.3


--------------020204030500010809080405--



