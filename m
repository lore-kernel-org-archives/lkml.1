Return-Path: <linux-kernel-owner+w=401wt.eu-S933020AbYD2PbK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933020AbYD2PbK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 11:31:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757840AbYD2Pat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 11:30:49 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:11107 "EHLO
	dwalker1.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933013AbYD2Pas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 11:30:48 -0400
Message-Id: <20080429152728.897334323@mvista.com>
User-Agent: quilt/0.46-1
Date: Tue, 29 Apr 2008 08:27:28 -0700
From: Daniel Walker <dwalker@mvista.com>
To: akpm@linux-foundation.org
Cc: paulus@samba.org, benh@kernel.crashing.org, mingo@elte.hu, matthew@wil.cx,
       linux-kernel@vger.kernel.org
Subject: [PATCH] machintosh: ADB driver: adb_handler_sem semaphore to mutex
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Walker <dwalker@mvista.com>

---
 drivers/macintosh/adb.c |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

Index: linux-2.6.25/drivers/macintosh/adb.c
===================================================================
--- linux-2.6.25.orig/drivers/macintosh/adb.c
+++ linux-2.6.25/drivers/macintosh/adb.c
@@ -37,6 +37,7 @@
 #include <linux/device.h>
 #include <linux/kthread.h>
 #include <linux/platform_device.h>
+#include <linux/mutex.h>
 
 #include <asm/uaccess.h>
 #include <asm/semaphore.h>
@@ -102,7 +103,7 @@ static struct adb_handler {
 } adb_handler[16];
 
 /*
- * The adb_handler_sem mutex protects all accesses to the original_address
+ * The adb_handler_mutex mutex protects all accesses to the original_address
  * and handler_id fields of adb_handler[i] for all i, and changes to the
  * handler field.
  * Accesses to the handler field are protected by the adb_handler_lock
@@ -110,7 +111,7 @@ static struct adb_handler {
  * time adb_unregister returns, we know that the old handler isn't being
  * called.
  */
-static DECLARE_MUTEX(adb_handler_sem);
+static DEFINE_MUTEX(adb_handler_mutex);
 static DEFINE_RWLOCK(adb_handler_lock);
 
 #if 0
@@ -355,7 +356,7 @@ do_adb_reset_bus(void)
 		msleep(500);
 	}
 
-	down(&adb_handler_sem);
+	mutex_lock(&adb_handler_mutex);
 	write_lock_irq(&adb_handler_lock);
 	memset(adb_handler, 0, sizeof(adb_handler));
 	write_unlock_irq(&adb_handler_lock);
@@ -376,7 +377,7 @@ do_adb_reset_bus(void)
 		if (adb_controller->autopoll)
 			adb_controller->autopoll(autopoll_devs);
 	}
-	up(&adb_handler_sem);
+	mutex_unlock(&adb_handler_mutex);
 
 	blocking_notifier_call_chain(&adb_client_list,
 		ADB_MSG_POST_RESET, NULL);
@@ -454,7 +455,7 @@ adb_register(int default_id, int handler
 {
 	int i;
 
-	down(&adb_handler_sem);
+	mutex_lock(&adb_handler_mutex);
 	ids->nids = 0;
 	for (i = 1; i < 16; i++) {
 		if ((adb_handler[i].original_address == default_id) &&
@@ -472,7 +473,7 @@ adb_register(int default_id, int handler
 			ids->id[ids->nids++] = i;
 		}
 	}
-	up(&adb_handler_sem);
+	mutex_unlock(&adb_handler_mutex);
 	return ids->nids;
 }
 
@@ -481,7 +482,7 @@ adb_unregister(int index)
 {
 	int ret = -ENODEV;
 
-	down(&adb_handler_sem);
+	mutex_lock(&adb_handler_mutex);
 	write_lock_irq(&adb_handler_lock);
 	if (adb_handler[index].handler) {
 		while(adb_handler[index].busy) {
@@ -493,7 +494,7 @@ adb_unregister(int index)
 		adb_handler[index].handler = NULL;
 	}
 	write_unlock_irq(&adb_handler_lock);
-	up(&adb_handler_sem);
+	mutex_unlock(&adb_handler_mutex);
 	return ret;
 }
 
@@ -557,19 +558,19 @@ adb_try_handler_change(int address, int 
 {
 	int ret;
 
-	down(&adb_handler_sem);
+	mutex_lock(&adb_handler_mutex);
 	ret = try_handler_change(address, new_id);
-	up(&adb_handler_sem);
+	mutex_unlock(&adb_handler_mutex);
 	return ret;
 }
 
 int
 adb_get_infos(int address, int *original_address, int *handler_id)
 {
-	down(&adb_handler_sem);
+	mutex_lock(&adb_handler_mutex);
 	*original_address = adb_handler[address].original_address;
 	*handler_id = adb_handler[address].handler_id;
-	up(&adb_handler_sem);
+	mutex_unlock(&adb_handler_mutex);
 
 	return (*original_address != 0);
 }
@@ -628,10 +629,10 @@ do_adb_query(struct adb_request *req)
 	case ADB_QUERY_GETDEVINFO:
 		if (req->nbytes < 3)
 			break;
-		down(&adb_handler_sem);
+		mutex_lock(&adb_handler_mutex);
 		req->reply[0] = adb_handler[req->data[2]].original_address;
 		req->reply[1] = adb_handler[req->data[2]].handler_id;
-		up(&adb_handler_sem);
+		mutex_unlock(&adb_handler_mutex);
 		req->complete = 1;
 		req->reply_len = 2;
 		adb_write_done(req);
-- 

-- 
