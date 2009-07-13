Return-Path: <linux-kernel-owner+w=401wt.eu-S932084AbZGMV2I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084AbZGMV2I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 17:28:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757311AbZGMV2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 17:28:07 -0400
Received: from server1.wserver.cz ([82.113.45.157]:50008 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757319AbZGMV2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 17:28:05 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: airlied@linux.ie
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 2/2] GPU: drm_gem, check kzalloc retval
Date: Mon, 13 Jul 2009 23:20:21 +0200
Message-Id: <1247520021-31684-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1247520021-31684-1-git-send-email-jirislaby@gmail.com>
References: <1247520021-31684-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check kzalloc retval against NULL in drm_gem_object_alloc and bail out
appropriately.

While at it merge the fail paths and jump to them by gotos at the end
of the function.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/gpu/drm/drm_gem.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index 8104eca..ffe8f43 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -134,26 +134,29 @@ drm_gem_object_alloc(struct drm_device *dev, size_t size)
 	BUG_ON((size & (PAGE_SIZE - 1)) != 0);
 
 	obj = kzalloc(sizeof(*obj), GFP_KERNEL);
+	if (!obj)
+		goto free;
 
 	obj->dev = dev;
 	obj->filp = shmem_file_setup("drm mm object", size, VM_NORESERVE);
-	if (IS_ERR(obj->filp)) {
-		kfree(obj);
-		return NULL;
-	}
+	if (IS_ERR(obj->filp))
+		goto free;
 
 	kref_init(&obj->refcount);
 	kref_init(&obj->handlecount);
 	obj->size = size;
 	if (dev->driver->gem_init_object != NULL &&
 	    dev->driver->gem_init_object(obj) != 0) {
-		fput(obj->filp);
-		kfree(obj);
-		return NULL;
+		goto fput;
 	}
 	atomic_inc(&dev->object_count);
 	atomic_add(obj->size, &dev->object_memory);
 	return obj;
+fput:
+	fput(obj->filp);
+free:
+	kfree(obj);
+	return NULL;
 }
 EXPORT_SYMBOL(drm_gem_object_alloc);
 
-- 
1.6.3.2

