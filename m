Return-Path: <linux-kernel-owner+w=401wt.eu-S934687AbYCDX2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934687AbYCDX2N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 18:28:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935038AbYCDXTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 18:19:22 -0500
Received: from ns1.suse.de ([195.135.220.2]:49231 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934974AbYCDXTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 18:19:20 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 7/8] Driver core: Fix cleanup when failing device_add().
Date: Tue,  4 Mar 2008 15:18:51 -0800
Message-Id: <1204672732-3127-7-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <20080304231519.GC3073@suse.de>
References: <20080304231519.GC3073@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

Driver core: Fix cleanup when failing device_add().

 - Don't call cleanup_device_parent() if we didn't call setup_parent().
 - dev->kobj.parent may be NULL when cleanup_device_parent() is called,
   so we need to handle glue_dir == NULL in cleanup_glue_dir().

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 7f59c2f..7de543d 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -621,7 +621,8 @@ static struct kobject *get_device_parent(struct device *dev,
 static void cleanup_glue_dir(struct device *dev, struct kobject *glue_dir)
 {
 	/* see if we live in a "glue" directory */
-	if (!dev->class || glue_dir->kset != &dev->class->class_dirs)
+	if (!glue_dir || !dev->class ||
+	    glue_dir->kset != &dev->class->class_dirs)
 		return;
 
 	kobject_put(glue_dir);
@@ -773,7 +774,7 @@ int device_add(struct device *dev)
 	dev = get_device(dev);
 	if (!dev || !strlen(dev->bus_id)) {
 		error = -EINVAL;
-		goto Error;
+		goto Done;
 	}
 
 	pr_debug("device: '%s': %s\n", dev->bus_id, __FUNCTION__);
-- 
1.5.4.3

