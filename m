Return-Path: <linux-kernel-owner+w=401wt.eu-S1752924AbZJSFhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924AbZJSFhM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 01:37:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbZJSFhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 01:37:12 -0400
Received: from bhuna.collabora.co.uk ([93.93.128.226]:60735 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbZJSFhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 01:37:11 -0400
Date: Mon, 19 Oct 2009 01:37:08 -0400
From: Andres Salomon <dilinger@collabora.co.uk>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.sourceforge.net,
       akpm@linux-foundation.org
Subject: [PATCH] drm: kill more unused DRM macros
Message-ID: <20091019013708.6ca3c7df@mycelium.queued.net>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There are a few more macros in drmP.h that are unused; DRM_GET_PRIV_SAREA,
DRM_ARRAY_SIZE, and DRM_WAITCOUNT can go away completely.

Unfortunately, DRM_COPY is still used in one place, but we can at least
move it to where it's used.  It's an awful looking macro..

Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
---
 drivers/gpu/drm/drm_drv.c |   12 ++++++++++++
 include/drm/drmP.h        |   25 -------------------------
 2 files changed, 12 insertions(+), 25 deletions(-)

diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
index a75ca63..43297ca 100644
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -366,6 +366,18 @@ module_init(drm_core_init);
 module_exit(drm_core_exit);
 
 /**
+ * Copy and IOCTL return string to user space
+ */
+#define DRM_COPY(name, value)                                         \
+	len = strlen(value);                                          \
+	if (len > name##_len) len = name##_len;                       \
+	name##_len = strlen(value);                                   \
+	if (len && name) {                                            \
+		if (copy_to_user(name, value, len))                   \
+			return -EFAULT;                               \
+	}
+
+/**
  * Get version information
  *
  * \param inode device inode.
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index af30da3..b2112f4 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -251,23 +251,10 @@ extern void drm_ut_debug_printk(unsigned int request_level,
 /** \name Internal types and structures */
 /*@{*/
 
-#define DRM_ARRAY_SIZE(x) ARRAY_SIZE(x)
-
 #define DRM_LEFTCOUNT(x) (((x)->rp + (x)->count - (x)->wp) % ((x)->count + 1))
 #define DRM_BUFCOUNT(x) ((x)->count - DRM_LEFTCOUNT(x))
-#define DRM_WAITCOUNT(dev,idx) DRM_BUFCOUNT(&dev->queuelist[idx]->waitlist)
 
 #define DRM_IF_VERSION(maj, min) (maj << 16 | min)
-/**
- * Get the private SAREA mapping.
- *
- * \param _dev DRM device.
- * \param _ctx context number.
- * \param _map output mapping.
- */
-#define DRM_GET_PRIV_SAREA(_dev, _ctx, _map) do {	\
-	(_map) = (_dev)->context_sareas[_ctx];		\
-} while(0)
 
 /**
  * Test that the hardware lock is held by the caller, returning otherwise.
@@ -287,18 +274,6 @@ do {										\
 } while (0)
 
 /**
- * Copy and IOCTL return string to user space
- */
-#define DRM_COPY( name, value )						\
-	len = strlen( value );						\
-	if ( len > name##_len ) len = name##_len;			\
-	name##_len = strlen( value );					\
-	if ( len && name ) {						\
-		if ( copy_to_user( name, value, len ) )			\
-			return -EFAULT;					\
-	}
-
-/**
  * Ioctl function type.
  *
  * \param inode device inode.
-- 
1.5.6.5

