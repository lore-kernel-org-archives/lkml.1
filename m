Return-Path: <linux-kernel-owner+w=401wt.eu-S1753625Ab0AHPGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab0AHPGp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 10:06:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753515Ab0AHPGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 10:06:44 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:33019 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499Ab0AHPGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 10:06:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HOeujXJoNNnfHAcpBeUr1bvINFIJ8DDmMapvb6dvYOFJOM3/sT1An/91cxVLv+M+aC
         CDLVwtjmqZ5pXtDGaDw13cefM8pRgJllYCkrX/l0iQJRJJo38cYFVrjK6fCyGltuCGm3
         7L/bOIbvety0NkRFIE26Kp0lfrXOQgD4zUQUE=
Subject: [PATCH 2/9] MTD: create lockless versions of {get,put}_mtd_device
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>, Alex Dubov <oakad@yahoo.com>,
       joern <joern@logfs.org>
In-Reply-To: <1262963092.12577.14.camel@maxim-laptop>
References: <1262963092.12577.14.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jan 2010 17:06:38 +0200
Message-ID: <1262963198.12577.16.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 1531249dd2c0e33d727ed8cbd0719eb4e9af2266 Mon Sep 17 00:00:00 2001
From: Maxim Levitsky <maximlevitsky@gmail.com>
Date: Fri, 8 Jan 2010 15:51:22 +0200
Subject: [PATCH 2/9] MTD: create lockless versions of {get,put}_mtd_device

This will be used to resolve deadlock in block translation layer.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/mtd/mtdcore.c   |   61 ++++++++++++++++++++++++++++++-----------------
 include/linux/mtd/mtd.h |    3 +-
 2 files changed, 41 insertions(+), 23 deletions(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 87ff83f..96b4a05 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -454,27 +454,38 @@ struct mtd_info *get_mtd_device(struct mtd_info *mtd, int num)
 			ret = NULL;
 	}
 
-	if (!ret)
-		goto out_unlock;
-
-	if (!try_module_get(ret->owner))
-		goto out_unlock;
-
-	if (ret->get_device) {
-		err = ret->get_device(ret);
-		if (err)
-			goto out_put;
+	if (!ret) {
+		ret = ERR_PTR(err);
+		goto out;
 	}
 
-	ret->usecount++;
+	err = __get_mtd_device(ret);
+	if (err)
+		ret = ERR_PTR(err);
+out:
 	mutex_unlock(&mtd_table_mutex);
 	return ret;
+}
 
-out_put:
-	module_put(ret->owner);
-out_unlock:
-	mutex_unlock(&mtd_table_mutex);
-	return ERR_PTR(err);
+
+int __get_mtd_device(struct mtd_info *mtd)
+{
+	int err;
+
+	if (!try_module_get(mtd->owner))
+		return -ENODEV;
+
+	if (mtd->get_device) {
+
+		err = mtd->get_device(mtd);
+
+		if (err) {
+			module_put(mtd->owner);
+			return err;
+		}
+	}
+	mtd->usecount++;
+	return 0;
 }
 
 /**
@@ -525,18 +536,22 @@ out_unlock:
 
 void put_mtd_device(struct mtd_info *mtd)
 {
-	int c;
-
 	mutex_lock(&mtd_table_mutex);
-	c = --mtd->usecount;
-	if (mtd->put_device)
-		mtd->put_device(mtd);
+	__put_mtd_device(mtd);
 	mutex_unlock(&mtd_table_mutex);
-	BUG_ON(c < 0);
 
 	module_put(mtd->owner);
 }
 
+void __put_mtd_device(struct mtd_info *mtd)
+{
+	--mtd->usecount;
+	BUG_ON(mtd->usecount < 0);
+
+	if (mtd->put_device)
+		mtd->put_device(mtd);
+}
+
 /* default_mtd_writev - default mtd writev method for MTD devices that
  *			don't implement their own
  */
@@ -570,7 +585,9 @@ EXPORT_SYMBOL_GPL(add_mtd_device);
 EXPORT_SYMBOL_GPL(del_mtd_device);
 EXPORT_SYMBOL_GPL(get_mtd_device);
 EXPORT_SYMBOL_GPL(get_mtd_device_nm);
+EXPORT_SYMBOL_GPL(__get_mtd_device);
 EXPORT_SYMBOL_GPL(put_mtd_device);
+EXPORT_SYMBOL_GPL(__put_mtd_device);
 EXPORT_SYMBOL_GPL(register_mtd_user);
 EXPORT_SYMBOL_GPL(unregister_mtd_user);
 EXPORT_SYMBOL_GPL(default_mtd_writev);
diff --git a/include/linux/mtd/mtd.h b/include/linux/mtd/mtd.h
index 0f32a9b..662d747 100644
--- a/include/linux/mtd/mtd.h
+++ b/include/linux/mtd/mtd.h
@@ -290,8 +290,9 @@ extern int add_mtd_device(struct mtd_info *mtd);
 extern int del_mtd_device (struct mtd_info *mtd);
 
 extern struct mtd_info *get_mtd_device(struct mtd_info *mtd, int num);
+extern int __get_mtd_device(struct mtd_info *mtd);
+extern void __put_mtd_device(struct mtd_info *mtd);
 extern struct mtd_info *get_mtd_device_nm(const char *name);
-
 extern void put_mtd_device(struct mtd_info *mtd);
 

-- 
1.6.3.3



