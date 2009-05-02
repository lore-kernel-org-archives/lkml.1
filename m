Return-Path: <linux-kernel-owner+w=401wt.eu-S1756859AbZEBOJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859AbZEBOJB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 10:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112AbZEBOIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 10:08:51 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:12094 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920AbZEBOIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 10:08:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=b9wOOhBpplifWtsXRm44//upX87MOnfP4txQMt0DRHS9YI1NEU54YaMtHjeCAMAWUm
         vaeVmVn7v+tQP4e0Y5JLrXpd/Nab3r9sKfKNDWJF0fTuOwYrwtEmG+qdOV+czGzS5M+a
         nmWNLjCBPFUOdYwaUov8ur+RPztNKVl13eUV4=
MIME-Version: 1.0
In-Reply-To: <49FC2455020000BF000290DA@mailgw2.hevs.ch>
References: <49FC2455020000BF000290DA@mailgw2.hevs.ch>
Date: Sat, 2 May 2009 22:08:50 +0800
Message-ID: <a8e1da0905020708j54cda260tac256469498f6ce3@mail.gmail.com>
Subject: Re: [BUG] 2.6.30-rc4 hid bluetooth not working
From: Dave Young <hidave.darkstar@gmail.com>
To: Marc Pignat <Marc.Pignat@hevs.ch>
Cc: marcel@holtmann.org, jkosina@suse.cz, ext-roger.quadros@nokia.com,
       linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 2, 2009 at 4:45 PM, Marc Pignat <Marc.Pignat@hevs.ch> wrote:
>>>> Marcel Holtmann <marcel@holtmann.org> 05/02/09 12:57 AM >>>
>>Hi Jiri,
>>
>>> > Subject: bluetooth: Fix serialization when adding/deleting connections in hci_sysfs
>>> >
>>> > add_conn and del_conn should be serialized, but flush_workqueue can't be used
>>> > by the worker thread on it's own queue, so use flush_work to serialize add_conn
>>> > and del_conn against each other.
>>> >
>>> > Signed-off-by: Marc Pignat <marc.pignat@hevs.ch>
>>>
>>> Acked-by: Jiri Kosina <jkosina@suse.cz>
>>>
>>> FWIW.
>>
>>nak from my side since I think it is the wrong fix. We really wanna wait
>>for all works to finish here. This includes work from other connection
>>attempts or terminations.
>
> IMHO, there is no need to wait for work currently running, since this is a
> singlethread workqueue.

Yes, sounds right.

>
> But it is perhaps simpler to use a lock (mutex or watherver locking primitive).

I'm here a little bit late. Marcel, I'm quite busy recently, I just
see the commit and then this thread.

Let me explain why I add two workqueue originally,  because workqueue
will be defered, so   we must guarantee "connection deletion" finished
before "connection adding with same bt addr",  or the "connection
adding" will fail.

On the other hand flush "adding" workqueue in "connection deletion"
function is not necessary.

To fix this bug, I think we can just use the two work struct for
add/del, at the same time keeping the original two workqueue.

Please see following patch for this, (building-test only, I have no
bluetooth device at hand, I can test this the day after tommorrow)

--- linux-2.6.orig/net/bluetooth/hci_sysfs.c	2009-04-30 11:35:54.000000000 +0800
+++ linux-2.6/net/bluetooth/hci_sysfs.c	2009-05-02 21:54:40.000000000 +0800
@@ -9,7 +9,8 @@
 struct class *bt_class = NULL;
 EXPORT_SYMBOL_GPL(bt_class);

-static struct workqueue_struct *bluetooth;
+static struct workqueue_struct *btaddconn;
+static struct workqueue_struct *btdelconn;

 static inline char *link_typetostr(int type)
 {
@@ -89,8 +90,7 @@
 {
 	struct hci_conn *conn = container_of(work, struct hci_conn, work_add);

-	/* ensure previous add/del is complete */
-	flush_workqueue(bluetooth);
+	flush_workqueue(btdelconn);

 	if (device_add(&conn->dev) < 0) {
 		BT_ERR("Failed to register connection device");
@@ -116,7 +116,7 @@

 	INIT_WORK(&conn->work_add, add_conn);

-	queue_work(bluetooth, &conn->work_add);
+	queue_work(btaddconn, &conn->work_add);
 }

 /*
@@ -134,9 +134,6 @@
 	struct hci_conn *conn = container_of(work, struct hci_conn, work_del);
 	struct hci_dev *hdev = conn->hdev;

-	/* ensure previous add/del is complete */
-	flush_workqueue(bluetooth);
-
 	while (1) {
 		struct device *dev;

@@ -161,7 +158,7 @@

 	INIT_WORK(&conn->work_del, del_conn);

-	queue_work(bluetooth, &conn->work_del);
+	queue_work(btdelconn, &conn->work_del);
 }

 static inline char *host_typetostr(int type)
@@ -438,13 +435,20 @@

 int __init bt_sysfs_init(void)
 {
-	bluetooth = create_singlethread_workqueue("bluetooth");
-	if (!bluetooth)
+	btaddconn = create_singlethread_workqueue("btaddconn");
+	if (!btaddconn)
+		return -ENOMEM;
+
+	btdelconn = create_singlethread_workqueue("btdelconn");
+	if (!btdelconn) {
+		destroy_workqueue(btaddconn);
 		return -ENOMEM;
+	}

 	bt_class = class_create(THIS_MODULE, "bluetooth");
 	if (IS_ERR(bt_class)) {
-		destroy_workqueue(bluetooth);
+		destroy_workqueue(btdelconn);
+		destroy_workqueue(btaddconn);
 		return PTR_ERR(bt_class);
 	}

@@ -453,7 +457,8 @@

 void bt_sysfs_cleanup(void)
 {
-	destroy_workqueue(bluetooth);
+	destroy_workqueue(btaddconn);
+	destroy_workqueue(btdelconn);

 	class_destroy(bt_class);
 }
