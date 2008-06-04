Return-Path: <linux-kernel-owner+w=401wt.eu-S1762104AbYFDMOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762104AbYFDMOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 08:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760833AbYFDMKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 08:10:45 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:43163 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760495AbYFDMKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 08:10:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject
         :content-disposition;
        b=WTLhrDA4TokSOLLdfi49VnU73jV2zgAPCpmPu/xeYpvmIyfg21vMsExkmrHI8Y+K+7
         gMJio4uUNUdeyhQUGZnHq5BYdlmlx2CjcW5yRGj0PI5otLWqkzm21j6uxK/IzavnS3wN
         9MS7zPQRvf5jmyLKpsGRlwf8ek0KRY+CO+etw=
Message-Id: <20080604115818.071671710@gmail.com>
References: <20080604115633.116832712@gmail.com>
User-Agent: quilt/0.46-1
Date: Wed, 04 Jun 2008 20:56:48 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Greg Kroah-Hartman <greg@kroah.com>
Subject: [patch -v3 15/22] firmware: use memory_read_from_buffer
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
