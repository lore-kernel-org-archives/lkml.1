Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646Ab0CNH43 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 03:56:29 -0400
Received: from mail-yx0-f191.google.com ([209.85.210.191]:46476 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755091Ab0CNH41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 03:56:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=Wyta9noAIsvUtck3pF2a3IOq0DiGn8uhL57P4fkqzQDHQ6ltuyMAx0KqVi7Uq69ake
         FkspefeGG+ImEdoPGDovPy0DrEHK3wh5CYEwWR7QWR+ozUzWYMdmeW8zFzB59k6rO8iV
         WI3/wZA+wqM12y4nAPJK/hzPEvOz/yKU6U8dg=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 2/5] firmware loader: rely on driver core to create class
	attribute
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Date: Sat, 13 Mar 2010 23:49:13 -0800
Message-ID: <20100314074913.27035.39475.stgit@localhost.localdomain>
In-Reply-To: <20100314074330.27035.38765.stgit@localhost.localdomain>
References: <20100314074330.27035.38765.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not create 'timeout' attribute manually, let driver core do it for us.
This also ensures that attribute is cleaned up properly.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/base/firmware_class.c |   59 +++++++++++++++++------------------------
 1 files changed, 24 insertions(+), 35 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 3f50b2e..5f9d906 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -97,9 +97,26 @@ firmware_timeout_store(struct class *class,
 	return count;
 }
 
-static CLASS_ATTR(timeout, 0644, firmware_timeout_show, firmware_timeout_store);
+static struct class_attribute firmware_class_attrs[] = {
+	__ATTR(timeout, S_IWUSR | S_IRUGO,
+		firmware_timeout_show, firmware_timeout_store),
+	__ATTR_NULL
+};
 
-static void fw_dev_release(struct device *dev);
+static void fw_dev_release(struct device *dev)
+{
+	struct firmware_priv *fw_priv = dev_get_drvdata(dev);
+	int i;
+
+	for (i = 0; i < fw_priv->nr_pages; i++)
+		__free_page(fw_priv->pages[i]);
+	kfree(fw_priv->pages);
+	kfree(fw_priv->fw_id);
+	kfree(fw_priv);
+	kfree(dev);
+
+	module_put(THIS_MODULE);
+}
 
 static int firmware_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
@@ -115,6 +132,7 @@ static int firmware_uevent(struct device *dev, struct kobj_uevent_env *env)
 
 static struct class firmware_class = {
 	.name		= "firmware",
+	.class_attrs	= firmware_class_attrs,
 	.dev_uevent	= firmware_uevent,
 	.dev_release	= fw_dev_release,
 };
@@ -350,21 +368,6 @@ static struct bin_attribute firmware_attr_data = {
 	.write = firmware_data_write,
 };
 
-static void fw_dev_release(struct device *dev)
-{
-	struct firmware_priv *fw_priv = dev_get_drvdata(dev);
-	int i;
-
-	for (i = 0; i < fw_priv->nr_pages; i++)
-		__free_page(fw_priv->pages[i]);
-	kfree(fw_priv->pages);
-	kfree(fw_priv->fw_id);
-	kfree(fw_priv);
-	kfree(dev);
-
-	module_put(THIS_MODULE);
-}
-
 static void
 firmware_class_timeout(u_long data)
 {
@@ -665,26 +668,12 @@ request_firmware_nowait(
 	return 0;
 }
 
-static int __init
-firmware_class_init(void)
+static int __init firmware_class_init(void)
 {
-	int error;
-	error = class_register(&firmware_class);
-	if (error) {
-		printk(KERN_ERR "%s: class_register failed\n", __func__);
-		return error;
-	}
-	error = class_create_file(&firmware_class, &class_attr_timeout);
-	if (error) {
-		printk(KERN_ERR "%s: class_create_file failed\n",
-		       __func__);
-		class_unregister(&firmware_class);
-	}
-	return error;
-
+	return class_register(&firmware_class);
 }
-static void __exit
-firmware_class_exit(void)
+
+static void __exit firmware_class_exit(void)
 {
 	class_unregister(&firmware_class);
 }

