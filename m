Return-Path: <linux-kernel-owner+w=401wt.eu-S1756148AbXKFA31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148AbXKFA31 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 19:29:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754174AbXKFA3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 19:29:20 -0500
Received: from gir.skynet.ie ([193.1.99.77]:53467 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929AbXKFA3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 19:29:19 -0500
Date: Tue, 6 Nov 2007 00:29:17 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@osdl.org, Andrew Morton <akpm@osdl.org>
cc: linux-kernel@vger.kernel.org
Subject: [git pull] more drm bug fixes and cleanups
Message-ID: <alpine.DEB.0.82.0711060027410.13794@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Sorry these came up after I made yesterdays tree, two bugfixes, one 
one-line cleanup..

Please pull from 'drm-patches' branch of
master.kernel.org:/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-patches

to receive the following updates:

 drivers/char/drm/drmP.h         |    2 --
 drivers/char/drm/drm_ioctl.c    |    2 +-
 drivers/char/drm/drm_os_linux.h |    8 --------
 drivers/char/drm/savage_bci.c   |    3 ---
 4 files changed, 1 insertions(+), 14 deletions(-)

Dave Airlie (2):
      drm: remove second forward decleration of drm device struct.
      drm: remove remnants of DRM_COPY_FROM/TO_USER_IOCTL

Li Zefan (1):
      drm: DRM: fix memset size error

diff --git a/drivers/char/drm/drmP.h b/drivers/char/drm/drmP.h
index 9dd0760..dde02a1 100644
--- a/drivers/char/drm/drmP.h
+++ b/drivers/char/drm/drmP.h
@@ -559,8 +559,6 @@ struct drm_mm {
  * a family of cards. There will one drm_device for each card present
  * in this family
  */
-struct drm_device;
-
 struct drm_driver {
 	int (*load) (struct drm_device *, unsigned long flags);
 	int (*firstopen) (struct drm_device *);
diff --git a/drivers/char/drm/drm_ioctl.c b/drivers/char/drm/drm_ioctl.c
index d9be146..3cbebf8 100644
--- a/drivers/char/drm/drm_ioctl.c
+++ b/drivers/char/drm/drm_ioctl.c
@@ -272,7 +272,7 @@ int drm_getstats(struct drm_device *dev, void *data,
 	struct drm_stats *stats = data;
 	int i;
 
-	memset(stats, 0, sizeof(stats));
+	memset(stats, 0, sizeof(*stats));
 
 	mutex_lock(&dev->struct_mutex);
 
diff --git a/drivers/char/drm/drm_os_linux.h b/drivers/char/drm/drm_os_linux.h
index 76e44ac..daa69c9 100644
--- a/drivers/char/drm/drm_os_linux.h
+++ b/drivers/char/drm/drm_os_linux.h
@@ -62,14 +62,6 @@ static __inline__ int mtrr_del(int reg, unsigned long base, unsigned long size)
 
 #endif
 
-/** For data going into the kernel through the ioctl argument */
-#define DRM_COPY_FROM_USER_IOCTL(arg1, arg2, arg3)	\
-	if ( copy_from_user(&arg1, arg2, arg3) )	\
-		return -EFAULT
-/** For data going from the kernel through the ioctl argument */
-#define DRM_COPY_TO_USER_IOCTL(arg1, arg2, arg3)	\
-	if ( copy_to_user(arg1, &arg2, arg3) )		\
-		return -EFAULT
 /** Other copying of data to kernel space */
 #define DRM_COPY_FROM_USER(arg1, arg2, arg3)		\
 	copy_from_user(arg1, arg2, arg3)
diff --git a/drivers/char/drm/savage_bci.c b/drivers/char/drm/savage_bci.c
index 59484d5..d465b2f 100644
--- a/drivers/char/drm/savage_bci.c
+++ b/drivers/char/drm/savage_bci.c
@@ -968,9 +968,6 @@ static int savage_bci_event_wait(struct drm_device *dev, void *data, struct drm_
 
 	DRM_DEBUG("\n");
 
-	DRM_COPY_FROM_USER_IOCTL(event, (drm_savage_event_wait_t __user *) data,
-				 sizeof(event));
-
 	UPDATE_EVENT_COUNTER();
 	if (dev_priv->status_ptr)
 		hw_e = dev_priv->status_ptr[1] & 0xffff;
