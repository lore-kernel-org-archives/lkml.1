Return-Path: <linux-kernel-owner+w=401wt.eu-S1758024AbZEVPGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024AbZEVPGz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 11:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757334AbZEVPGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 11:06:47 -0400
Received: from mail-pz0-f177.google.com ([209.85.222.177]:46389 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757308AbZEVPGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 11:06:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=LupeOAzL2QBNL4LEvVgO/VAPBT0CTZGLvkqdudyi6SxWpppWw4L2ZHNMAioATblyPC
         DLSbhKztRctWGaJFeC3eujohw5FEashQsPGqgEuu9zRtBw/qM4tCB0k9C+uRL8R57/8U
         XSjsKBRKPtcAS4PvDjouNxtg4ydiQmkSswD3k=
From: tom.leiming@gmail.com
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH] driver core : fix request_firmware_nowait
Date: Fri, 22 May 2009 23:06:27 +0800
Message-Id: <1243004787-5362-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

request_firmware_nowait declares it can be called in non-sleep contexts,
but kthead_run which is called by request_firmware_nowait may sleep.
So fix it by starting thread in workqueue to request firmware asynchronously.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/base/firmware_class.c |   66 ++++++++++++++++++++++++++++++++++------
 1 files changed, 56 insertions(+), 10 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 2d296b7..0388cf7 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -573,15 +573,25 @@ release_firmware(const struct firmware *fw)
 
 /* Async support */
 struct firmware_work {
-	struct work_struct work;
 	struct module *module;
 	const char *name;
 	struct device *device;
 	void *context;
 	void (*cont)(const struct firmware *fw, void *context);
 	int uevent;
+	struct list_head list;
+	struct task_struct *task;
+};
+
+struct firmware_schedule{
+	spinlock_t	lock;
+	struct list_head head;
+	struct work_struct work;
 };
 
+static struct firmware_schedule fw_schedule;
+
+
 static int
 request_firmware_work_func(void *arg)
 {
@@ -605,6 +615,35 @@ request_firmware_work_func(void *arg)
 	return ret;
 }
 
+static void fw_schedule_fun(struct work_struct *work)
+{
+	struct firmware_schedule	*fs =
+		container_of(work, struct firmware_schedule, work);
+	unsigned long		flags;
+
+	spin_lock_irqsave(&fs->lock, flags);
+	while (!list_empty(&fs->head)) {
+		struct firmware_work    *fw_work;
+
+		fw_work = list_entry(fs->head.next, struct firmware_work, list);
+		list_del(&fw_work->list);
+
+		spin_unlock_irqrestore(&fs->lock, flags);
+		fw_work->task = kthread_run(request_firmware_work_func, fw_work,
+			    "firmware/%s", fw_work->name);
+		spin_lock_irqsave(&fs->lock, flags);
+
+		if (IS_ERR(fw_work->task)) {
+			fw_work->cont(NULL, fw_work->context);
+			module_put(fw_work->module);
+			kfree(fw_work);
+			dev_err(fw_work->device, "%s: kthread_run failed\n",
+				__func__);
+		}
+	}
+	spin_unlock_irqrestore(&fs->lock, flags);
+}
+
 /**
  * request_firmware_nowait: asynchronous version of request_firmware
  * @module: module requesting the firmware
@@ -626,7 +665,8 @@ request_firmware_nowait(
 	const char *name, struct device *device, void *context,
 	void (*cont)(const struct firmware *fw, void *context))
 {
-	struct task_struct *task;
+	unsigned long		flags;
+	struct firmware_schedule	*fs = &fw_schedule;
 	struct firmware_work *fw_work = kmalloc(sizeof (struct firmware_work),
 						GFP_ATOMIC);
 
@@ -646,15 +686,14 @@ request_firmware_nowait(
 		.uevent = uevent,
 	};
 
-	task = kthread_run(request_firmware_work_func, fw_work,
-			    "firmware/%s", name);
+	INIT_LIST_HEAD(&fw_work->list);
+
+	spin_lock_irqsave(&fs->lock, flags);
+	list_add_tail(&fw_work->list, &fs->head);
+	spin_unlock_irqrestore(&fs->lock, flags);
+
+	schedule_work(&fs->work);
 
-	if (IS_ERR(task)) {
-		fw_work->cont(NULL, fw_work->context);
-		module_put(fw_work->module);
-		kfree(fw_work);
-		return PTR_ERR(task);
-	}
 	return 0;
 }
 
@@ -662,6 +701,13 @@ static int __init
 firmware_class_init(void)
 {
 	int error;
+	struct firmware_schedule	*fs = &fw_schedule;
+
+	memset(fs, 0, sizeof(*fs));
+	spin_lock_init(&fs->lock);
+	INIT_LIST_HEAD(&fs->head);
+	INIT_WORK(&fs->work, fw_schedule_fun);
+
 	error = class_register(&firmware_class);
 	if (error) {
 		printk(KERN_ERR "%s: class_register failed\n", __func__);
-- 
1.6.0.GIT

