Return-Path: <linux-kernel-owner+w=401wt.eu-S1752455AbYHFJhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455AbYHFJhK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 05:37:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764720AbYHFJgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 05:36:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:34358 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764676AbYHFJgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 05:36:50 -0400
Subject: Re: [PATCH] firmware: avoiding multiple replication for same
	firmware file
From: Jaswinder Singh <jaswinder@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org
In-Reply-To: <20080805140327.16494fb0.akpm@linux-foundation.org>
References: <1217570459.2902.1.camel@jaswinder.satnam>
	 <20080805140327.16494fb0.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 06 Aug 2008 15:05:13 +0530
Message-Id: <1218015313.3044.6.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrew,

On Tue, 2008-08-05 at 14:03 -0700, Andrew Morton wrote:
> On Fri, 01 Aug 2008 11:30:59 +0530

> No, we shouldn't declare an entire static `struct firmware_list' just
> for storage of all the dynamically allocated ones. Instead simply do:
> 
> static LIST_HEAD(firmwarelist);
> 
> and use that.
> 
> Please also add a comment indicating which lock protects that global
> list.  If it is indeed protected.  If not, fix it.  If no fix is
> needed, add a comment explaining why this list doesn't need locking.
> 

Thanks for your feedbacks.

You can also check my other firmware patches from :
http://git.infradead.org/users/jaswinder/firm-jsr-2.6.git

Here is updated patch:

Subject: [PATCH] firmware: avoiding multiple replication for same firmware file

Now when request_firmware will be called it will check whether firmware
is already allocated or not. If already allocated then it provide handle
of old firmware and increase count of firmware.

release_firmware will decrease count of firmware, if count is one only then
firmware will be release.

Added release_firmware_all() can be called from driver cleanup or exit
to release firmware forcefully if count != 0.

release_firmware and release_firmware_all is safe
No need to check for fw for !NULL before calling them.

Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
---
 drivers/base/firmware_class.c |  154 +++++++++++++++++++++++++++++++++++------
 include/linux/firmware.h      |    5 ++
 2 files changed, 137 insertions(+), 22 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index c9c92b0..0ba8857 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -49,6 +49,18 @@ struct firmware_priv {
 	struct timer_list timeout;
 };
 
+/* Created firmware link list to avoiding multiple replication
+ * for same firmware file */
+struct firmware_list {
+	const struct firmware *fw;
+	char *name;
+	int count;
+	struct list_head list;
+};
+
+/* Protected by fw_lock */
+static LIST_HEAD(firmwarelist);
+
 #ifdef CONFIG_FW_LOADER
 extern struct builtin_fw __start_builtin_fw[];
 extern struct builtin_fw __end_builtin_fw[];
@@ -394,36 +406,63 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
 	struct firmware_priv *fw_priv;
 	struct firmware *firmware;
 	struct builtin_fw *builtin;
+	struct firmware_list *tmp;
 	int retval;
 
 	if (!firmware_p)
 		return -EINVAL;
 
+	/* Return firmware pointer from firmware list if already allocated */
+	list_for_each_entry(tmp, &firmwarelist, list)
+		if (strcmp(name, tmp->name) == 0) {
+			mutex_lock(&fw_lock);
+			tmp->count++;
+			*firmware_p = tmp->fw;
+			mutex_unlock(&fw_lock);
+			printk(KERN_INFO "firmware: requesting %s count %d\n",
+			       name, tmp->count);
+			return 0;
+		}
+
 	*firmware_p = firmware = kzalloc(sizeof(*firmware), GFP_KERNEL);
-	if (!firmware) {
-		printk(KERN_ERR "%s: kmalloc(struct firmware) failed\n",
-		       __func__);
+	if (!firmware)
+		return -ENOMEM;
+
+	mutex_lock(&fw_lock);
+	tmp = kzalloc(sizeof(struct firmware_list), GFP_KERNEL);
+	if (!tmp) {
 		retval = -ENOMEM;
-		goto out;
+		goto error_kfree_fw;
+	}
+	tmp->name = kstrdup(name, GFP_KERNEL);
+	if (!tmp->name) {
+		retval = -ENOMEM;
+		goto error_kfree_fw_list;
 	}
+	tmp->fw = *firmware_p;
+	tmp->count = 1;
+	list_add(&tmp->list, &firmwarelist);
+	mutex_unlock(&fw_lock);
 
 	for (builtin = __start_builtin_fw; builtin != __end_builtin_fw;
 	     builtin++) {
 		if (strcmp(name, builtin->name))
 			continue;
-		printk(KERN_INFO "firmware: using built-in firmware %s\n",
-		       name);
+		printk(KERN_INFO
+		       "firmware: using built-in firmware %s count %d\n",
+		       name, tmp->count);
 		firmware->size = builtin->size;
 		firmware->data = builtin->data;
 		return 0;
 	}
 
 	if (uevent)
-		printk(KERN_INFO "firmware: requesting %s\n", name);
+		printk(KERN_INFO "firmware: requesting %s count %d\n",
+		       name, tmp->count);
 
 	retval = fw_setup_device(firmware, &f_dev, name, device, uevent);
 	if (retval)
-		goto error_kfree_fw;
+		goto error_kfree_fw_llist;
 
 	fw_priv = dev_get_drvdata(f_dev);
 
@@ -445,12 +484,22 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
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
 
+error_kfree_fw_llist:
+	mutex_lock(&fw_lock);
+	list_del(&tmp->list);
+	kfree(tmp->name);
+error_kfree_fw_list:
+	kfree(tmp);
+	mutex_unlock(&fw_lock);
 error_kfree_fw:
 	kfree(firmware);
 	*firmware_p = NULL;
@@ -459,7 +508,10 @@ out:
 }
 
 /**
- * request_firmware: - send firmware request and wait for it
+ * request_firmware: - Checks whether firmware is already allocated or not.
+ * If already allocated then it provide handle of old firmware and
+ * increase count of firmware.
+ * If not allocated then send firmware request and wait for it.
  * @firmware_p: pointer to firmware image
  * @name: name of firmware file
  * @device: device for which firmware is being loaded
@@ -481,24 +533,80 @@ request_firmware(const struct firmware **firmware_p, const char *name,
         return _request_firmware(firmware_p, name, device, uevent);
 }
 
-/**
- * release_firmware: - release the resource associated with a firmware image
- * @fw: firmware resource to release
- **/
-void
-release_firmware(const struct firmware *fw)
+static void __release_firmware(const struct firmware *fw,
+			       struct firmware_list *tmp)
 {
 	struct builtin_fw *builtin;
 
+	for (builtin = __start_builtin_fw; builtin != __end_builtin_fw;
+	     builtin++) {
+		if (fw->data == builtin->data)
+			goto free_fw;
+	}
+	vfree(fw->data);
+free_fw:
+	kfree(fw);
+	mutex_lock(&fw_lock);
+	list_del(&tmp->list);
+	kfree(tmp->name);
+	kfree(tmp);
+	mutex_unlock(&fw_lock);
+}
+
+/*
+ * release_firmware: - decrease count of firmware, if count is one only then
+ * release the resource associated with a firmware image
+ * @fw: firmware resource to release
+ *
+ * release_firmware is safe you can call release_firmware(NULL) so
+ * no need to check for fw for !NULL before calling release_firmware
+ */
+void release_firmware(const struct firmware *fw)
+{
+	struct firmware_list *tmp;
+
+	if (fw)
+		list_for_each_entry(tmp, &firmwarelist, list)
+			if (fw == tmp->fw) {
+				printk(KERN_INFO
+				       "firmware: releasing %s count %d\n",
+				       tmp->name, tmp->count);
+				mutex_lock(&fw_lock);
+				tmp->count--;
+				mutex_unlock(&fw_lock);
+				if (tmp->count == 0)
+					__release_firmware(fw, tmp);
+				return;
+			}
+}
+
+/*
+ * release_firmware_all: - release the resource associated with a firmware
+ * image forcefully if count != 0
+ * @fw: firmware resource to release
+ *
+ * release_firmware_all is safe you can call release_firmware_all(NULL) so
+ * no need to check for fw for !NULL before calling release_firmware_all
+ *
+ *  release_firmware_all() can be called from driver cleanup or exit
+ *  to release firmware forcefully
+ */
+void release_firmware_all(const struct firmware *fw)
+{
+	struct firmware_list *tmp;
+
 	if (fw) {
-		for (builtin = __start_builtin_fw; builtin != __end_builtin_fw;
-		     builtin++) {
-			if (fw->data == builtin->data)
-				goto free_fw;
+		list_for_each_entry(tmp, &firmwarelist, list)
+			if (fw == tmp->fw)
+				break;
+		printk(KERN_INFO "firmware: releasing all %s count %d\n",
+		       tmp->name, tmp->count);
+		if (tmp->count) {
+			mutex_lock(&fw_lock);
+			tmp->count = 0;
+			mutex_unlock(&fw_lock);
+			__release_firmware(fw, tmp);
 		}
-		vfree(fw->data);
-	free_fw:
-		kfree(fw);
 	}
 }
 
@@ -604,6 +712,8 @@ firmware_class_init(void)
 		       __func__);
 		class_unregister(&firmware_class);
 	}
+
+	INIT_LIST_HEAD(&firmwarelist);
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



