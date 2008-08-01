Return-Path: <linux-kernel-owner+w=401wt.eu-S1754562AbYHAGCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562AbYHAGCl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 02:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbYHAGCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 02:02:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:37370 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbYHAGCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 02:02:33 -0400
Subject: [PATCH] firmware: avoiding multiple replication for same firmware
	file
From: Jaswinder Singh <jaswinder@infradead.org>
To: LKML <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain
Date: Fri, 01 Aug 2008 11:30:59 +0530
Message-Id: <1217570459.2902.1.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now when request_firmware will be called it will check whether firmware
is already allocated or not. If already allocated then it provide handle
of old firmware handle and increase count of firmware.

release_firmware will decrease count of firmware, if count is one only then
firmware will be release.

Added release_firmware_all() can be called from driver cleanup or exit
to release firmware forcefully.

Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
---
 drivers/base/firmware_class.c |  112 ++++++++++++++++++++++++++++++++++++-----
 include/linux/firmware.h      |    5 ++
 2 files changed, 104 insertions(+), 13 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index b0be1d1..9743a3d 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -49,6 +49,15 @@ struct firmware_priv {
 	struct timer_list timeout;
 };
 
+struct firmware_list {
+	const struct firmware *fw;
+	char *name;
+	int count;
+	struct list_head list;
+};
+
+static struct firmware_list firmwarelist;
+
 #ifdef CONFIG_FW_LOADER
 extern struct builtin_fw __start_builtin_fw[];
 extern struct builtin_fw __end_builtin_fw[];
@@ -400,11 +409,21 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
 	struct firmware_priv *fw_priv;
 	struct firmware *firmware;
 	struct builtin_fw *builtin;
+	struct firmware_list *tmp;
 	int retval;
 
 	if (!firmware_p)
 		return -EINVAL;
 
+	/* Return firmware pointer from firmware list if already allocated */
+	list_for_each_entry(tmp, &firmwarelist.list, list) {
+		if (strcmp(name, tmp->name) == 0) {
+			tmp->count++;
+			*firmware_p = tmp->fw;
+			break;
+		}
+	}
+
 	*firmware_p = firmware = kzalloc(sizeof(*firmware), GFP_KERNEL);
 	if (!firmware) {
 		printk(KERN_ERR "%s: kmalloc(struct firmware) failed\n",
@@ -413,6 +432,27 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
 		goto out;
 	}
 
+	tmp = kzalloc(sizeof(struct firmware_list), GFP_KERNEL);
+	if (!tmp) {
+		printk(KERN_ERR "%s: kmalloc(struct firmware_list) failed\n",
+		       __func__);
+		retval = -ENOMEM;
+		goto error_kfree_fw;
+	}
+
+	tmp->name = kzalloc(strlen(name), GFP_KERNEL);
+	if (!tmp->name) {
+		printk(KERN_ERR "%s: kmalloc firmware_list->name failed\n",
+		       __func__);
+		retval = -ENOMEM;
+		goto error_kfree_fw_list;
+	}
+
+	tmp->fw = *firmware_p;
+	tmp->count = 1;
+	strcpy(tmp->name, name);
+	list_add(&(tmp->list), &(firmwarelist.list));
+
 	for (builtin = __start_builtin_fw; builtin != __end_builtin_fw;
 	     builtin++) {
 		if (strcmp(name, builtin->name))
@@ -429,7 +469,7 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
 
 	retval = fw_setup_device(firmware, &f_dev, name, device, uevent);
 	if (retval)
-		goto error_kfree_fw;
+		goto error_kfree_fw_name;
 
 	fw_priv = dev_get_drvdata(f_dev);
 
@@ -451,12 +491,20 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
 		retval = -ENOENT;
 		release_firmware(fw_priv->fw);
 		*firmware_p = NULL;
+		list_del(&tmp->list);
+		kfree(tmp->name);
+		kfree(tmp);
 	}
 	fw_priv->fw = NULL;
 	mutex_unlock(&fw_lock);
 	device_unregister(f_dev);
 	goto out;
 
+error_kfree_fw_name:
+	list_del(&tmp->list);
+	kfree(tmp->name);
+error_kfree_fw_list:
+	kfree(tmp);
 error_kfree_fw:
 	kfree(firmware);
 	*firmware_p = NULL;
@@ -487,24 +535,60 @@ request_firmware(const struct firmware **firmware_p, const char *name,
         return _request_firmware(firmware_p, name, device, uevent);
 }
 
-/**
+static void __release_firmware(const struct firmware *fw,
+			       struct firmware_list *tmp)
+{
+	struct builtin_fw *builtin;
+
+	for (builtin = __start_builtin_fw; builtin != __end_builtin_fw;
+	     builtin++) {
+		if (fw->data == builtin->data)
+			goto free_fw;
+	}
+	vfree(fw->data);
+free_fw:
+	kfree(fw);
+	list_del(&tmp->list);
+	kfree(tmp->name);
+	kfree(tmp);
+}
+
+/*
  * release_firmware: - release the resource associated with a firmware image
  * @fw: firmware resource to release
- **/
-void
-release_firmware(const struct firmware *fw)
+ */
+void release_firmware(const struct firmware *fw)
 {
-	struct builtin_fw *builtin;
+	struct firmware_list *tmp;
 
 	if (fw) {
-		for (builtin = __start_builtin_fw; builtin != __end_builtin_fw;
-		     builtin++) {
-			if (fw->data == builtin->data)
-				goto free_fw;
+		list_for_each_entry(tmp, &firmwarelist.list, list) {
+			if (fw == tmp->fw) {
+				if (tmp->count > 1) {
+					tmp->count--;
+					return;
+				} else
+					break;
+			}
 		}
-		vfree(fw->data);
-	free_fw:
-		kfree(fw);
+		__release_firmware(fw, tmp);
+	}
+}
+
+/*
+ * release_firmware_all: - release the resource associated with a firmware
+ * image forcefully
+ * @fw: firmware resource to release
+ */
+void release_firmware_all(const struct firmware *fw)
+{
+	struct firmware_list *tmp;
+
+	if (fw) {
+		list_for_each_entry(tmp, &firmwarelist.list, list)
+			if (fw == tmp->fw)
+				break;
+		__release_firmware(fw, tmp);
 	}
 }
 
@@ -610,6 +694,8 @@ firmware_class_init(void)
 		       __func__);
 		class_unregister(&firmware_class);
 	}
+
+	INIT_LIST_HEAD(&firmwarelist.list);
 	return error;
 
 }
diff --git a/include/linux/firmware.h b/include/linux/firmware.h
index c8ecf5b..238f1e4 100644
--- a/include/linux/firmware.h
+++ b/include/linux/firmware.h
@@ -43,6 +43,7 @@ int request_firmware_nowait(
 	void (*cont)(const struct firmware *fw, void *context));
 
 void release_firmware(const struct firmware *fw);
+void release_firmware_all(const struct firmware *fw);
 #else
 static inline int request_firmware(const struct firmware **fw,
 				   const char *name,
@@ -61,6 +62,10 @@ static inline int request_firmware_nowait(
 static inline void release_firmware(const struct firmware *fw)
 {
 }
+
+static inline void release_firmware_all(const struct firmware *fw)
+{
+}
 #endif
 
 #endif
-- 
1.5.5.1



