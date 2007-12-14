Return-Path: <linux-kernel-owner+w=401wt.eu-S1764802AbXLNBl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764802AbXLNBl3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 20:41:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758543AbXLNBlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 20:41:20 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:36872 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757157AbXLNBlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 20:41:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=g04f7wSnIBFNucM2Vk87EgF1tgNDRDIf2givxY8p062iIH6YkDoLQvqVLzr2af78lbDJtf9wML+iQkGJIa3midBKivuzxiam0Fu3yvOWzVqGsfRyJ1Ve0zbOxEoH6s7IrQp/hO72gg0Kwd6DiXdaK9QQnWnA5a8CsFdaP0GyXtU=
Date: Fri, 14 Dec 2007 09:45:56 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: marcel@holtmann.org
Cc: linux-kernel@vger.kernel.org, bluez-devel@lists.sourceforge.net
Subject: [PATCH][rewrite with goto error handling] Bluetooth: hci_sysfs
	connection add/del workqueue bug fix
Message-ID: <20071214014556.GA3090@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bluetooth hci conn sysfs add/del executed in the default workqueue. If the conn del function is executed after the new conn add function with same bluetooth target address, the connection add will failed and warning about same kobject name.

Here add a btconn workqueue, and flush the workqueue in the add_conn function to avoid the above issue. 

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
net/bluetooth/hci_sysfs.c |   48 +++++++++++++++++++++++++++++++++++-----------
1 file changed, 37 insertions(+), 11 deletions(-)

diff -upr linux/net/bluetooth/hci_sysfs.c linux.new/net/bluetooth/hci_sysfs.c
--- linux/net/bluetooth/hci_sysfs.c	2007-12-14 09:24:44.000000000 +0800
+++ linux.new/net/bluetooth/hci_sysfs.c	2007-12-14 09:36:50.000000000 +0800
@@ -12,6 +12,8 @@
 #undef  BT_DBG
 #define BT_DBG(D...)
 #endif
+static struct workqueue_struct *btaddconn;
+static struct workqueue_struct *btdelconn;
 
 static inline char *typetostr(int type)
 {
@@ -279,6 +281,7 @@ static void add_conn(struct work_struct 
 	struct hci_conn *conn = container_of(work, struct hci_conn, work);
 	int i;
 
+	flush_workqueue(btdelconn);
 	if (device_add(&conn->dev) < 0) {
 		BT_ERR("Failed to register connection device");
 		return;
@@ -313,6 +316,7 @@ void hci_conn_add_sysfs(struct hci_conn 
 
 	INIT_WORK(&conn->work, add_conn);
 
+	queue_work(btaddconn, &conn->work);
 	schedule_work(&conn->work);
 }
 
@@ -331,6 +335,7 @@ void hci_conn_del_sysfs(struct hci_conn 
 
 	INIT_WORK(&conn->work, del_conn);
 
+	queue_work(btdelconn, &conn->work);
 	schedule_work(&conn->work);
 }
 
@@ -380,31 +385,52 @@ int __init bt_sysfs_init(void)
 {
 	int err;
 
+	btaddconn = create_singlethread_workqueue("btaddconn");
+	if (!btaddconn) {
+		err = -ENOMEM;
+		goto out;
+	}
+	btdelconn = create_singlethread_workqueue("btdelconn");
+	if (!btdelconn) {
+		err = -ENOMEM;
+		goto out_del;
+	}
+
 	bt_platform = platform_device_register_simple("bluetooth", -1, NULL, 0);
-	if (IS_ERR(bt_platform))
-		return PTR_ERR(bt_platform);
+	if (IS_ERR(bt_platform)) {
+		err = PTR_ERR(bt_platform);
+		goto out_platform;
+	}
 
 	err = bus_register(&bt_bus);
-	if (err < 0) {
-		platform_device_unregister(bt_platform);
-		return err;
-	}
+	if (err < 0)
+		goto out_bus;
 
 	bt_class = class_create(THIS_MODULE, "bluetooth");
 	if (IS_ERR(bt_class)) {
-		bus_unregister(&bt_bus);
-		platform_device_unregister(bt_platform);
-		return PTR_ERR(bt_class);
+		err = PTR_ERR(bt_class);
+		goto out_class;
 	}
 
 	return 0;
+
+out_class:
+	bus_unregister(&bt_bus);
+out_bus:
+	platform_device_unregister(bt_platform);
+out_platform:
+	destroy_workqueue(btdelconn);
+out_del:
+	destroy_workqueue(btaddconn);
+out:
+	return err;
 }
 
 void bt_sysfs_cleanup(void)
 {
+	destroy_workqueue(btaddconn);
+	destroy_workqueue(btdelconn);
 	class_destroy(bt_class);
-
 	bus_unregister(&bt_bus);
-
 	platform_device_unregister(bt_platform);
 }
