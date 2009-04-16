Return-Path: <linux-kernel-owner+w=401wt.eu-S1753247AbZDPHAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbZDPHAY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 03:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509AbZDPHAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 03:00:11 -0400
Received: from mail.southpole.se ([193.12.106.18]:36858 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbZDPHAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 03:00:10 -0400
From: Jonas Bonn <jonas@southpole.se>
To: dri-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Jonas Bonn <jonas@southpole.se>
Subject: [PATCH] drm: set/clear is_master when master changed
Date: Thu, 16 Apr 2009 09:00:02 +0200
Message-Id: <1239865202-14292-1-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable is_master is being used to track the drm_file that is currently
master, so its value needs to be updated accordingly when the master is
changed.

Signed-off-by: Jonas Bonn <jonas@southpole.se>
---
 drivers/gpu/drm/drm_stub.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/drm_stub.c b/drivers/gpu/drm/drm_stub.c
index d009661..1b3e0ff 100644
--- a/drivers/gpu/drm/drm_stub.c
+++ b/drivers/gpu/drm/drm_stub.c
@@ -159,6 +159,9 @@ void drm_master_put(struct drm_master **master)
 int drm_setmaster_ioctl(struct drm_device *dev, void *data,
 			struct drm_file *file_priv)
 {
+	if (file_priv->is_master)
+		return 0;
+
 	if (file_priv->minor->master && file_priv->minor->master != file_priv->master)
 		return -EINVAL;
 
@@ -169,6 +172,7 @@ int drm_setmaster_ioctl(struct drm_device *dev, void *data,
 	    file_priv->minor->master != file_priv->master) {
 		mutex_lock(&dev->struct_mutex);
 		file_priv->minor->master = drm_master_get(file_priv->master);
+		file_priv->is_master = 1;
 		mutex_unlock(&dev->struct_mutex);
 	}
 
@@ -178,10 +182,12 @@ int drm_setmaster_ioctl(struct drm_device *dev, void *data,
 int drm_dropmaster_ioctl(struct drm_device *dev, void *data,
 			 struct drm_file *file_priv)
 {
-	if (!file_priv->master)
+	if (!file_priv->is_master)
 		return -EINVAL;
+
 	mutex_lock(&dev->struct_mutex);
 	drm_master_put(&file_priv->minor->master);
+	file_priv->is_master = 0;
 	mutex_unlock(&dev->struct_mutex);
 	return 0;
 }
-- 
1.6.0.4


