Return-Path: <linux-kernel-owner+w=401wt.eu-S1753764AbYH1HNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764AbYH1HNH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 03:13:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752796AbYH1HMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 03:12:54 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:50923 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802AbYH1HMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 03:12:52 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] 2.6.27-rc2 USB suspend regression
Date: Thu, 28 Aug 2008 09:14:04 +0200
User-Agent: KMail/1.9.9
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       USB list <linux-usb@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0808271729380.2137-100000@iolanthe.rowland.org> <48B5C8DE.9050304@goop.org>
In-Reply-To: <48B5C8DE.9050304@goop.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_9AltI/2nqGn7oXl"
Message-Id: <200808280914.05350.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_9AltI/2nqGn7oXl
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Mittwoch 27 August 2008 23:36:30 schrieb Jeremy Fitzhardinge:
> > Is this still a problem?
> > =A0=20
>=20
> I haven't seen it lately, but it was fairly erratic anyway. =A0It happened
> a few times in quick succession, and then it all worked fine. =A0The
> rawhide kernels are getting fairly old (I guess RH is still trying to
> pull its infrastructure together), so I'm running a fairly recent
> self-compiled kernel. =A0Will report anything I see.
>=20
> > Is this related to other Bluetooth suspend/resume regressions in=20
> > 2.6.27?
> > =A0=20
>=20
> I'm not sure if its BT or Sierra wireless related.

The attached patch is reported to make the problem go away for
a user of btusb. He might be able to use it for narrowing down causes.

	Regards
		Oliver


--Boundary-00=_9AltI/2nqGn7oXl
Content-Type: text/x-diff;
  charset="iso 8859-15";
  name="btusb_susp_res.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="btusb_susp_res.diff"

--- linux-2.6.27-rc4/drivers/usb/core/urb.c	2008-08-21 10:03:44.000000000 +0200
+++ linux-2.6.27-rc3/drivers/usb/core/urb.c	2008-08-22 17:25:49.000000000 +0200
@@ -601,15 +601,20 @@ EXPORT_SYMBOL_GPL(usb_kill_anchored_urbs
 void usb_unlink_anchored_urbs(struct usb_anchor *anchor)
 {
 	struct urb *victim;
+	unsigned long flags;
 
-	spin_lock_irq(&anchor->lock);
+	spin_lock_irqsave(&anchor->lock, flags);
 	while (!list_empty(&anchor->urb_list)) {
 		victim = list_entry(anchor->urb_list.prev, struct urb,
 				    anchor_list);
+		usb_get_urb(victim);
+		spin_unlock_irqrestore(&anchor->lock, flags);
 		/* this will unanchor the URB */
 		usb_unlink_urb(victim);
+		usb_put_urb(victim);
+		spin_lock_irqsave(&anchor->lock, flags);
 	}
-	spin_unlock_irq(&anchor->lock);
+	spin_unlock_irqrestore(&anchor->lock, flags);
 }
 EXPORT_SYMBOL_GPL(usb_unlink_anchored_urbs);
 
--- linux-2.6.27-rc4/drivers/bluetooth/btusb.c.alt	2008-08-25 15:02:14.000000000 +0200
+++ linux-2.6.27-rc4/drivers/bluetooth/btusb.c	2008-08-25 15:44:25.000000000 +0200
@@ -169,6 +169,7 @@ static struct usb_device_id blacklist_ta
 struct btusb_data {
 	struct hci_dev       *hdev;
 	struct usb_device    *udev;
+	struct usb_interface *acl;
 	struct usb_interface *isoc;
 
 	spinlock_t lock;
@@ -176,6 +177,7 @@ struct btusb_data {
 	unsigned long flags;
 
 	struct work_struct work;
+	struct work_struct waker;
 
 	struct usb_anchor tx_anchor;
 	struct usb_anchor intr_anchor;
@@ -189,6 +191,7 @@ struct btusb_data {
 	struct usb_endpoint_descriptor *isoc_rx_ep;
 
 	int isoc_altsetting;
+	int susp_count;
 };
 
 static void btusb_intr_complete(struct urb *urb)
@@ -227,7 +230,7 @@ static void btusb_intr_complete(struct u
 	}
 }
 
-static int btusb_submit_intr_urb(struct hci_dev *hdev)
+static int btusb_submit_intr_urb(struct hci_dev *hdev, gfp_t gfp)
 {
 	struct btusb_data *data = hdev->driver_data;
 	struct urb *urb;
@@ -240,13 +243,13 @@ static int btusb_submit_intr_urb(struct
 	if (!data->intr_ep)
 		return -ENODEV;
 
-	urb = usb_alloc_urb(0, GFP_ATOMIC);
+	urb = usb_alloc_urb(0, gfp);
 	if (!urb)
 		return -ENOMEM;
 
 	size = le16_to_cpu(data->intr_ep->wMaxPacketSize);
 
-	buf = kmalloc(size, GFP_ATOMIC);
+	buf = kmalloc(size, gfp);
 	if (!buf) {
 		usb_free_urb(urb);
 		return -ENOMEM;
@@ -262,7 +265,7 @@ static int btusb_submit_intr_urb(struct
 
 	usb_anchor_urb(urb, &data->intr_anchor);
 
-	err = usb_submit_urb(urb, GFP_ATOMIC);
+	err = usb_submit_urb(urb, gfp);
 	if (err < 0) {
 		BT_ERR("%s urb %p submission failed (%d)",
 						hdev->name, urb, -err);
@@ -311,7 +314,7 @@ static void btusb_bulk_complete(struct u
 	}
 }
 
-static int btusb_submit_bulk_urb(struct hci_dev *hdev)
+static int btusb_submit_bulk_urb(struct hci_dev *hdev, gfp_t gfp)
 {
 	struct btusb_data *data = hdev->driver_data;
 	struct urb *urb;
@@ -324,18 +327,19 @@ static int btusb_submit_bulk_urb(struct
 	if (!data->bulk_rx_ep)
 		return -ENODEV;
 
-	urb = usb_alloc_urb(0, GFP_KERNEL);
+	urb = usb_alloc_urb(0, gfp);
 	if (!urb)
 		return -ENOMEM;
 
 	size = le16_to_cpu(data->bulk_rx_ep->wMaxPacketSize);
 
-	buf = kmalloc(size, GFP_KERNEL);
+	buf = kmalloc(size, gfp);
 	if (!buf) {
 		usb_free_urb(urb);
 		return -ENOMEM;
 	}
 
+	usb_mark_last_busy(data->udev);
 	pipe = usb_rcvbulkpipe(data->udev, data->bulk_rx_ep->bEndpointAddress);
 
 	usb_fill_bulk_urb(urb, data->udev, pipe,
@@ -345,7 +349,7 @@ static int btusb_submit_bulk_urb(struct
 
 	usb_anchor_urb(urb, &data->bulk_anchor);
 
-	err = usb_submit_urb(urb, GFP_KERNEL);
+	err = usb_submit_urb(urb, gfp);
 	if (err < 0) {
 		BT_ERR("%s urb %p submission failed (%d)",
 						hdev->name, urb, -err);
@@ -514,7 +518,7 @@ static int btusb_open(struct hci_dev *hd
 	if (test_and_set_bit(BTUSB_INTR_RUNNING, &data->flags))
 		return 0;
 
-	err = btusb_submit_intr_urb(hdev);
+	err = btusb_submit_intr_urb(hdev, GFP_KERNEL);
 	if (err < 0) {
 		clear_bit(BTUSB_INTR_RUNNING, &hdev->flags);
 		clear_bit(HCI_RUNNING, &hdev->flags);
@@ -523,6 +527,13 @@ static int btusb_open(struct hci_dev *hd
 	return err;
 }
 
+static void btusb_stop_traffic(struct btusb_data *data)
+{
+	usb_kill_anchored_urbs(&data->intr_anchor);
+	usb_kill_anchored_urbs(&data->bulk_anchor);
+	usb_kill_anchored_urbs(&data->isoc_anchor);
+}
+
 static int btusb_close(struct hci_dev *hdev)
 {
 	struct btusb_data *data = hdev->driver_data;
@@ -532,14 +543,12 @@ static int btusb_close(struct hci_dev *h
 	if (!test_and_clear_bit(HCI_RUNNING, &hdev->flags))
 		return 0;
 
-	clear_bit(BTUSB_ISOC_RUNNING, &data->flags);
-	usb_kill_anchored_urbs(&data->intr_anchor);
+	flush_work(&data->work);
 
+	clear_bit(BTUSB_ISOC_RUNNING, &data->flags);
 	clear_bit(BTUSB_BULK_RUNNING, &data->flags);
-	usb_kill_anchored_urbs(&data->bulk_anchor);
-
 	clear_bit(BTUSB_INTR_RUNNING, &data->flags);
-	usb_kill_anchored_urbs(&data->intr_anchor);
+	btusb_stop_traffic(data);
 
 	return 0;
 }
@@ -672,8 +681,19 @@ static void btusb_notify(struct hci_dev
 
 	BT_DBG("%s evt %d", hdev->name, evt);
 
-	if (evt == HCI_NOTIFY_CONN_ADD || evt == HCI_NOTIFY_CONN_DEL)
-		schedule_work(&data->work);
+	if (hdev->conn_hash.acl_num > 0) {
+		if (!test_and_set_bit(BTUSB_BULK_RUNNING, &data->flags)) {
+			if (btusb_submit_bulk_urb(hdev, GFP_ATOMIC) < 0)
+				clear_bit(BTUSB_BULK_RUNNING, &data->flags);
+			else
+				btusb_submit_bulk_urb(hdev, GFP_ATOMIC);
+		}
+	} else {
+		clear_bit(BTUSB_BULK_RUNNING, &data->flags);
+		usb_unlink_anchored_urbs(&data->bulk_anchor);
+	}
+
+	schedule_work(&data->work);
 }
 
 static int inline __set_isoc_interface(struct hci_dev *hdev, int altsetting)
@@ -724,18 +744,6 @@ static void btusb_work(struct work_struc
 	struct btusb_data *data = container_of(work, struct btusb_data, work);
 	struct hci_dev *hdev = data->hdev;
 
-	if (hdev->conn_hash.acl_num > 0) {
-		if (!test_and_set_bit(BTUSB_BULK_RUNNING, &data->flags)) {
-			if (btusb_submit_bulk_urb(hdev) < 0)
-				clear_bit(BTUSB_BULK_RUNNING, &data->flags);
-			else
-				btusb_submit_bulk_urb(hdev);
-		}
-	} else {
-		clear_bit(BTUSB_BULK_RUNNING, &data->flags);
-		usb_kill_anchored_urbs(&data->bulk_anchor);
-	}
-
 	if (hdev->conn_hash.sco_num > 0) {
 		if (data->isoc_altsetting != 2) {
 			clear_bit(BTUSB_ISOC_RUNNING, &data->flags);
@@ -821,6 +829,7 @@ static int btusb_probe(struct usb_interf
 	}
 
 	data->udev = interface_to_usbdev(intf);
+	data->acl = intf;
 
 	spin_lock_init(&data->lock);
 
@@ -889,7 +898,7 @@ static int btusb_probe(struct usb_interf
 
 	if (data->isoc) {
 		err = usb_driver_claim_interface(&btusb_driver,
-							data->isoc, NULL);
+							data->isoc, data);
 		if (err < 0) {
 			hci_free_dev(hdev);
 			kfree(data);
@@ -921,20 +930,92 @@ static void btusb_disconnect(struct usb_
 
 	hdev = data->hdev;
 
-	if (data->isoc)
-		usb_driver_release_interface(&btusb_driver, data->isoc);
+	/* make sure we have a reference */
+	__hci_dev_hold(hdev);
 
-	usb_set_intfdata(intf, NULL);
+	usb_set_intfdata(data->acl, NULL);
+	if (data->isoc)
+		usb_set_intfdata(data->isoc, NULL);
 
+	/* unregister before releasing any interface */
 	hci_unregister_dev(hdev);
 
+	if (intf == data->isoc)
+		usb_driver_release_interface(&btusb_driver, data->acl);
+	else if (data->isoc)
+		usb_driver_release_interface(&btusb_driver, data->isoc);
+
+	/* release the reference */
+	__hci_dev_put(hdev);
 	hci_free_dev(hdev);
 }
 
+static int btusb_suspend(struct usb_interface *intf, pm_message_t message)
+{
+	struct btusb_data *data = usb_get_intfdata(intf);
+
+	BT_DBG("%s called\n", __func__);
+
+	if (data->susp_count++)
+		return 0;
+
+	cancel_work_sync(&data->work);
+	btusb_stop_traffic(data);
+	usb_kill_anchored_urbs(&data->tx_anchor);
+	return 0;
+}
+
+static int btusb_resume(struct usb_interface *intf)
+{
+	struct btusb_data *data = usb_get_intfdata(intf);
+	struct hci_dev *hdev = data->hdev;
+	int ret;
+
+	if (--data->susp_count)
+		return 0;
+	if (test_bit(HCI_RUNNING, &hdev->flags)) {
+		ret = btusb_submit_intr_urb(hdev, GFP_NOIO);
+		if (ret < 0) {
+			clear_bit(HCI_RUNNING, &hdev->flags);
+			return ret;
+		}
+	}
+
+	if (hdev->conn_hash.acl_num > 0) {
+		ret = btusb_submit_bulk_urb(hdev, GFP_NOIO);
+		if (ret < 0) {
+			clear_bit(BTUSB_BULK_RUNNING, &data->flags);
+			return ret;
+		} else {
+			ret = btusb_submit_bulk_urb(hdev, GFP_NOIO);
+			if (ret < 0) {
+				clear_bit(BTUSB_BULK_RUNNING, &data->flags);
+				usb_kill_anchored_urbs(&data->bulk_anchor);
+				return ret;
+			}
+		}
+	}
+
+	if (data->isoc) {
+		if (test_bit(BTUSB_ISOC_RUNNING, &data->flags)) {
+			ret = btusb_submit_isoc_urb(hdev);
+			if (ret < 0)
+				clear_bit(BTUSB_ISOC_RUNNING, &data->flags);
+			else
+				btusb_submit_isoc_urb(hdev);
+		}
+	}
+
+	schedule_work(&data->work);
+	return 0;
+}
+
 static struct usb_driver btusb_driver = {
 	.name		= "btusb",
 	.probe		= btusb_probe,
 	.disconnect	= btusb_disconnect,
+	.suspend	= btusb_suspend,
+	.resume		= btusb_resume,
 	.id_table	= btusb_table,
 };
 

--Boundary-00=_9AltI/2nqGn7oXl--
