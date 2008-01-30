Return-Path: <linux-kernel-owner+w=401wt.eu-S1754827AbYA3CXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbYA3CXV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 21:23:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbYA3CXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 21:23:08 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:31496 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877AbYA3CXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 21:23:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=pBtMvRMl+6E8DdQ3UV7yJRWfFHgVsz2IVYuX0u/Dcm0r3ltfu4ErgaFtkxyfIUFlFkzO22dTXW/nb5NX0sp7doku5x+jVh0LNDlrLtWVw623FQs/ucpSg5lb9cN2wa1AWq3I7Ls1Keay9trdkZ04HJGAFrUQ2ZG8yAzwlxkaYp0=
Date: Wed, 30 Jan 2008 10:23:54 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: marcel@holtmann.org
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH retry] bluetooth : add conn add/del workqueues to avoid
	connection fail
Message-ID: <20080130022354.GA3132@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The bluetooth hci_conn sysfs add/del executed in the default workqueue.
If the del_conn is executed after the new add_conn with same target,
add_conn will failed with warning of "same kobject name".

Here add btaddconn & btdelconn workqueues,
flush the btdelconn workqueue in the add_conn function to avoid the issue.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
diff -upr a/net/bluetooth/hci_sysfs.c b/net/bluetooth/hci_sysfs.c
--- a/net/bluetooth/hci_sysfs.c	2008-01-30 10:14:27.000000000 +0800
+++ b/net/bluetooth/hci_sysfs.c	2008-01-30 10:14:14.000000000 +0800
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
 
@@ -349,6 +353,7 @@ void hci_conn_del_sysfs(struct hci_conn 
 
 	INIT_WORK(&conn->work, del_conn);
 
+	queue_work(btdelconn, &conn->work);
 	schedule_work(&conn->work);
 }
 
@@ -398,31 +403,52 @@ int __init bt_sysfs_init(void)
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
