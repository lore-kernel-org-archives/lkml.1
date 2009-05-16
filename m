Return-Path: <linux-kernel-owner+w=401wt.eu-S1758210AbZEPNyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210AbZEPNyv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 09:54:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755797AbZEPNyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 09:54:39 -0400
Received: from mail-pz0-f115.google.com ([209.85.222.115]:41438 "EHLO
	mail-pz0-f115.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758064AbZEPNyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 09:54:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=bcSg/y/dPzx8GFdq4U1EKbx8sWpTbv/j5RqNt3iLHP8nUeYCu280X3Io4ttxavx0HD
         ujSLy0+ZCHKJ+rDr+1V6+lpRDtcmn5GEyN6KngGcb85Qc5hoVvUf5dMTRDzrY1gD0a0a
         GS6P6rX6njeBSlHlDbe2htHfYQRAeRt9882gg=
From: tom.leiming@gmail.com
To: arjan@infradead.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cornelia.huck@de.ibm.com, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 2/2] driver core:firmware:fix request_firmware_nowait
Date: Sat, 16 May 2009 21:54:18 +0800
Message-Id: <1242482058-5203-2-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
In-Reply-To: <1242482058-5203-1-git-send-email-tom.leiming@gmail.com>
References: <1242482058-5203-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

request_firmware_nowait declares it can be called in non-sleep contexts,
but kthead_run called by request_firmware_nowait may sleep. So use
async_run_inatomic to start thread to request firmware.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/base/firmware_class.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index d186149..99cb21e 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -19,6 +19,7 @@
 #include <linux/kthread.h>
 #include <linux/highmem.h>
 #include <linux/firmware.h>
+#include <linux/async.h>
 #include "base.h"
 
 #define to_dev(obj) container_of(obj, struct device, kobj)
@@ -582,15 +583,15 @@ struct firmware_work {
 	int uevent;
 };
 
-static int
-request_firmware_work_func(void *arg)
+static void
+request_firmware_work_func(void *arg, async_cookie_t cookie)
 {
 	struct firmware_work *fw_work = arg;
 	const struct firmware *fw;
 	int ret;
 	if (!arg) {
 		WARN_ON(1);
-		return 0;
+		return;
 	}
 	ret = _request_firmware(&fw, fw_work->name, fw_work->device,
 		fw_work->uevent);
@@ -602,7 +603,6 @@ request_firmware_work_func(void *arg)
 	}
 	module_put(fw_work->module);
 	kfree(fw_work);
-	return ret;
 }
 
 /**
@@ -626,7 +626,7 @@ request_firmware_nowait(
 	const char *name, struct device *device, void *context,
 	void (*cont)(const struct firmware *fw, void *context))
 {
-	struct task_struct *task;
+	int ret;
 	struct firmware_work *fw_work = kmalloc(sizeof (struct firmware_work),
 						GFP_ATOMIC);
 
@@ -646,14 +646,12 @@ request_firmware_nowait(
 		.uevent = uevent,
 	};
 
-	task = kthread_run(request_firmware_work_func, fw_work,
-			    "firmware/%s", name);
-
-	if (IS_ERR(task)) {
+	ret = async_run_inatomic(request_firmware_work_func, fw_work);
+	if (ret) {
 		fw_work->cont(NULL, fw_work->context);
 		module_put(fw_work->module);
 		kfree(fw_work);
-		return PTR_ERR(task);
+		return ret;
 	}
 	return 0;
 }
-- 
1.6.0.GIT

