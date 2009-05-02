Return-Path: <linux-kernel-owner+w=401wt.eu-S1757698AbZEBTnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757698AbZEBTnQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 15:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755804AbZEBTm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 15:42:59 -0400
Received: from senator.holtmann.net ([87.106.208.187]:57978 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755559AbZEBTm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 15:42:58 -0400
Subject: Re: [BUG] 2.6.30-rc4 hid bluetooth not working
From: Marcel Holtmann <marcel@holtmann.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Marc Pignat <Marc.Pignat@hevs.ch>, jkosina@suse.cz,
       ext-roger.quadros@nokia.com, linux-bluetooth@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <a8e1da0905020708j54cda260tac256469498f6ce3@mail.gmail.com>
References: <49FC2455020000BF000290DA@mailgw2.hevs.ch>
	 <a8e1da0905020708j54cda260tac256469498f6ce3@mail.gmail.com>
Content-Type: multipart/mixed; boundary="=-GeiDHAMEUiJg/qGNcrQQ"
Date: Sat, 02 May 2009 12:42:46 -0700
Message-Id: <1241293366.4412.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-GeiDHAMEUiJg/qGNcrQQ
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Dave,

> >>> > Subject: bluetooth: Fix serialization when adding/deleting connections in hci_sysfs
> >>> >
> >>> > add_conn and del_conn should be serialized, but flush_workqueue can't be used
> >>> > by the worker thread on it's own queue, so use flush_work to serialize add_conn
> >>> > and del_conn against each other.
> >>> >
> >>> > Signed-off-by: Marc Pignat <marc.pignat@hevs.ch>
> >>>
> >>> Acked-by: Jiri Kosina <jkosina@suse.cz>
> >>>
> >>> FWIW.
> >>
> >>nak from my side since I think it is the wrong fix. We really wanna wait
> >>for all works to finish here. This includes work from other connection
> >>attempts or terminations.
> >
> > IMHO, there is no need to wait for work currently running, since this is a
> > singlethread workqueue.
> 
> Yes, sounds right.
> 
> >
> > But it is perhaps simpler to use a lock (mutex or watherver locking primitive).
> 
> I'm here a little bit late. Marcel, I'm quite busy recently, I just
> see the commit and then this thread.
> 
> Let me explain why I add two workqueue originally,  because workqueue
> will be defered, so   we must guarantee "connection deletion" finished
> before "connection adding with same bt addr",  or the "connection
> adding" will fail.
> 
> On the other hand flush "adding" workqueue in "connection deletion"
> function is not necessary.
> 
> To fix this bug, I think we can just use the two work struct for
> add/del, at the same time keeping the original two workqueue.
> 
> Please see following patch for this, (building-test only, I have no
> bluetooth device at hand, I can test this the day after tommorrow)

so I spent the whole day figuring out what is going on here and we keep
making the wrong assumptions over and over again.

First of all, we only add the sysfs device when we have a successful
connection. And we identify it with the handle. This means that we can
NOT have any name clashes anymore since the controller has to make sure
a handle is only assigned once. Previously we did this on the BD_ADDR
value and that lead to it. That is no longer the case.

Second of all the two work queues introduces way too much complexity for
a really simple task of adding and removing a sysfs device entry.

The real problem we have right now are that we are not initializing the
sysfs device when creating the hci_conn. This is just wrong and can lead
to all kinds of weird invalid data access. And as a result the adding of
the sysfs device should only set the name and add it.

We also check device_registered before making sure that device_add has
been run. And instead of adding more locking or crazy work queue
dependencies, we should use the single thread work queue to ensure the
correct order of things.

The attached patch introduces a hci_conn_init_sysfs step to make sure we
setup the sysfs device correctly. I left the flush_work calls, but I
think they are not needed since a del_conn before add_conn is no longer
possible now.

Regards

Marcel


--=-GeiDHAMEUiJg/qGNcrQQ
Content-Disposition: attachment; filename="patch-bluetooth-fix-sysfs-workq"
Content-Type: text/x-patch; name="patch-bluetooth-fix-sysfs-workq"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index be5bd71..73aead2 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -457,6 +457,7 @@ int hci_recv_fragment(struct hci_dev *hdev, int type, void *data, int count);
 
 int hci_register_sysfs(struct hci_dev *hdev);
 void hci_unregister_sysfs(struct hci_dev *hdev);
+void hci_conn_init_sysfs(struct hci_conn *conn);
 void hci_conn_add_sysfs(struct hci_conn *conn);
 void hci_conn_del_sysfs(struct hci_conn *conn);
 
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 375f4b4..61309b2 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -248,6 +248,8 @@ struct hci_conn *hci_conn_add(struct hci_dev *hdev, int type, bdaddr_t *dst)
 	if (hdev->notify)
 		hdev->notify(hdev, HCI_NOTIFY_CONN_ADD);
 
+	hci_conn_init_sysfs(conn);
+
 	tasklet_enable(&hdev->tx_task);
 
 	return conn;
diff --git a/net/bluetooth/hci_sysfs.c b/net/bluetooth/hci_sysfs.c
index b7c5108..582d887 100644
--- a/net/bluetooth/hci_sysfs.c
+++ b/net/bluetooth/hci_sysfs.c
@@ -9,7 +9,7 @@
 struct class *bt_class = NULL;
 EXPORT_SYMBOL_GPL(bt_class);
 
-static struct workqueue_struct *bluetooth;
+static struct workqueue_struct *bt_workq;
 
 static inline char *link_typetostr(int type)
 {
@@ -89,8 +89,8 @@ static void add_conn(struct work_struct *work)
 {
 	struct hci_conn *conn = container_of(work, struct hci_conn, work_add);
 
-	/* ensure previous add/del is complete */
-	flush_workqueue(bluetooth);
+	/* ensure previous del is complete */
+	flush_work(&conn->work_del);
 
 	if (device_add(&conn->dev) < 0) {
 		BT_ERR("Failed to register connection device");
@@ -98,27 +98,6 @@ static void add_conn(struct work_struct *work)
 	}
 }
 
-void hci_conn_add_sysfs(struct hci_conn *conn)
-{
-	struct hci_dev *hdev = conn->hdev;
-
-	BT_DBG("conn %p", conn);
-
-	conn->dev.type = &bt_link;
-	conn->dev.class = bt_class;
-	conn->dev.parent = &hdev->dev;
-
-	dev_set_name(&conn->dev, "%s:%d", hdev->name, conn->handle);
-
-	dev_set_drvdata(&conn->dev, conn);
-
-	device_initialize(&conn->dev);
-
-	INIT_WORK(&conn->work_add, add_conn);
-
-	queue_work(bluetooth, &conn->work_add);
-}
-
 /*
  * The rfcomm tty device will possibly retain even when conn
  * is down, and sysfs doesn't support move zombie device,
@@ -134,8 +113,11 @@ static void del_conn(struct work_struct *work)
 	struct hci_conn *conn = container_of(work, struct hci_conn, work_del);
 	struct hci_dev *hdev = conn->hdev;
 
-	/* ensure previous add/del is complete */
-	flush_workqueue(bluetooth);
+	/* ensure previous add is complete */
+	flush_work(&conn->work_add);
+
+	if (!device_is_registered(&conn->dev))
+		return;
 
 	while (1) {
 		struct device *dev;
@@ -152,16 +134,40 @@ static void del_conn(struct work_struct *work)
 	hci_dev_put(hdev);
 }
 
-void hci_conn_del_sysfs(struct hci_conn *conn)
+void hci_conn_init_sysfs(struct hci_conn *conn)
 {
+	struct hci_dev *hdev = conn->hdev;
+
 	BT_DBG("conn %p", conn);
 
-	if (!device_is_registered(&conn->dev))
-		return;
+	conn->dev.type = &bt_link;
+	conn->dev.class = bt_class;
+	conn->dev.parent = &hdev->dev;
+
+	dev_set_drvdata(&conn->dev, conn);
 
+	device_initialize(&conn->dev);
+
+	INIT_WORK(&conn->work_add, add_conn);
 	INIT_WORK(&conn->work_del, del_conn);
+}
+
+void hci_conn_add_sysfs(struct hci_conn *conn)
+{
+	struct hci_dev *hdev = conn->hdev;
+
+	BT_DBG("conn %p", conn);
+
+	dev_set_name(&conn->dev, "%s:%d", hdev->name, conn->handle);
+
+	queue_work(bt_workq, &conn->work_add);
+}
+
+void hci_conn_del_sysfs(struct hci_conn *conn)
+{
+	BT_DBG("conn %p", conn);
 
-	queue_work(bluetooth, &conn->work_del);
+	queue_work(bt_workq, &conn->work_del);
 }
 
 static inline char *host_typetostr(int type)
@@ -438,13 +444,13 @@ void hci_unregister_sysfs(struct hci_dev *hdev)
 
 int __init bt_sysfs_init(void)
 {
-	bluetooth = create_singlethread_workqueue("bluetooth");
-	if (!bluetooth)
+	bt_workq = create_singlethread_workqueue("bluetooth");
+	if (!bt_workq)
 		return -ENOMEM;
 
 	bt_class = class_create(THIS_MODULE, "bluetooth");
 	if (IS_ERR(bt_class)) {
-		destroy_workqueue(bluetooth);
+		destroy_workqueue(bt_workq);
 		return PTR_ERR(bt_class);
 	}
 
@@ -453,7 +459,7 @@ int __init bt_sysfs_init(void)
 
 void bt_sysfs_cleanup(void)
 {
-	destroy_workqueue(bluetooth);
+	destroy_workqueue(bt_workq);
 
 	class_destroy(bt_class);
 }

--=-GeiDHAMEUiJg/qGNcrQQ--

