Return-Path: <linux-kernel-owner+w=401wt.eu-S1757994AbYFAXdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994AbYFAXdA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 19:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753676AbYFAX2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 19:28:35 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:2864 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756664AbYFAX2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 19:28:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
        b=tJR7dZymsMmBGUbBS3FioQDDHuRHWmNzYf5Yd96YbYJPQ0+zc8oFWHZyIihnFGMPGOoAus+MAchVNM+d5xWRnx43jTN0MdTbRlOvdpa/AGIcmfHOOhOMpkirEUv/E72dx8VSjUK4nLfa8VQJ9ESIOBFoszthYGcB+QZxqAC3V4A=
Message-Id: <20080601231619.352275646@gmail.com>
References: <20080601231329.223608711@gmail.com>
User-Agent: quilt/0.46-1
Date: Mon, 02 Jun 2008 08:13:45 +0900
From: akinobu.mita@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <greg@kroah.com>
Subject: [patch -v2 16/23] firmware: use memory_read_from_buffer
Content-Disposition: inline; filename=firmware-use-memory-read-from-buffer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>
---
 drivers/base/firmware_class.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

Index: 2.6-git/drivers/base/firmware_class.c
===================================================================
--- 2.6-git.orig/drivers/base/firmware_class.c
+++ 2.6-git/drivers/base/firmware_class.c
@@ -17,6 +17,7 @@
 #include <linux/bitops.h>
 #include <linux/mutex.h>
 #include <linux/kthread.h>
+#include <linux/fs.h>
 
 #include <linux/firmware.h>
 #include "base.h"
@@ -176,7 +177,7 @@ firmware_data_read(struct kobject *kobj,
 	struct device *dev = to_dev(kobj);
 	struct firmware_priv *fw_priv = dev_get_drvdata(dev);
 	struct firmware *fw;
-	ssize_t ret_count = count;
+	ssize_t ret_count;
 
 	mutex_lock(&fw_lock);
 	fw = fw_priv->fw;
@@ -184,14 +185,8 @@ firmware_data_read(struct kobject *kobj,
 		ret_count = -ENODEV;
 		goto out;
 	}
-	if (offset > fw->size) {
-		ret_count = 0;
-		goto out;
-	}
-	if (offset + ret_count > fw->size)
-		ret_count = fw->size - offset;
-
-	memcpy(buffer, fw->data + offset, ret_count);
+	ret_count = memory_read_from_buffer(buffer, count, &offset,
+						fw->data, fw->size);
 out:
 	mutex_unlock(&fw_lock);
 	return ret_count;

-- 
