Return-Path: <linux-kernel-owner+w=401wt.eu-S1757637AbZCZJ4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757637AbZCZJ4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 05:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753798AbZCZJ4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 05:56:11 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33157 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666AbZCZJ4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 05:56:10 -0400
Date: Thu, 26 Mar 2009 10:58:56 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Marcel Holtmann <marcel@holtmann.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <greg@kroah.com>, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.29-rc5+: usb bluetooth crashes system
Message-ID: <20090326095856.GA22641@elf.ucw.cz>
References: <20090310112307.GD1337@ucw.cz> <20090314034852.GA3417@kroah.com> <20090316114441.GF2405@elf.ucw.cz> <3DA733C2-2755-4D42-9512-7E7110B39526@holtmann.org> <20090319225011.GB6314@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090319225011.GB6314@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>>> Since switch to 2.6.29-rc, bluetooth crashes system... usually on
> >>>> disconnect or killall pppd.
> >>>
> >>> Do we have a trace?
> >>
> >> We have "bad magic" message, see bugzilla. I guess it is use of
> >> spinlock after free?
> >
> > can you double check with the net-next-2.6 or bluetooth-next-2.6 tree  
> > and see if that issue is still present.
> 
> Well, I took btusb.c from 2.6.28 and that fixed the issue; so we know
> the regression is in btusb.c file between 28 and 29-rc7. If you have
> specific version of btusb.c you want me to test, please mail it to me.

This smaller patch (partial revert of btusb.c to 2.6.28 state) seems
to help, too....

									Pavel
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index b5fbda6..75f9fc0 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -655,19 +680,8 @@ static void btusb_notify(struct hci_dev *hdev, unsigned int evt)
 
 	BT_DBG("%s evt %d", hdev->name, evt);
 
-	if (hdev->conn_hash.acl_num > 0) {
-		if (!test_and_set_bit(BTUSB_BULK_RUNNING, &data->flags)) {
-			if (btusb_submit_bulk_urb(hdev, GFP_ATOMIC) < 0)
-				clear_bit(BTUSB_BULK_RUNNING, &data->flags);
-			else
-				btusb_submit_bulk_urb(hdev, GFP_ATOMIC);
-		}
-	} else {
-		clear_bit(BTUSB_BULK_RUNNING, &data->flags);
-		usb_unlink_anchored_urbs(&data->bulk_anchor);
-	}
-
-	schedule_work(&data->work);
+	if (evt == HCI_NOTIFY_CONN_ADD || evt == HCI_NOTIFY_CONN_DEL)
+		schedule_work(&data->work);
 }
 
 static int inline __set_isoc_interface(struct hci_dev *hdev, int altsetting)
@@ -718,6 +732,18 @@ static void btusb_work(struct work_struct *work)
 	struct btusb_data *data = container_of(work, struct btusb_data, work);
 	struct hci_dev *hdev = data->hdev;
 
+	if (hdev->conn_hash.acl_num > 0) {
+		if (!test_and_set_bit(BTUSB_BULK_RUNNING, &data->flags)) {
+			if (btusb_submit_bulk_urb(hdev) < 0)
+				clear_bit(BTUSB_BULK_RUNNING, &data->flags);
+			else
+				btusb_submit_bulk_urb(hdev);
+		}
+	} else {
+		clear_bit(BTUSB_BULK_RUNNING, &data->flags);
+		usb_kill_anchored_urbs(&data->bulk_anchor);
+	}
+
 	if (hdev->conn_hash.sco_num > 0) {
 		if (data->isoc_altsetting != 2) {
 			clear_bit(BTUSB_ISOC_RUNNING, &data->flags);
@@ -852,23 +876,9 @@ static int btusb_probe(struct usb_interface *intf,
 	if (id->driver_info & BTUSB_BROKEN_ISOC)
 		data->isoc = NULL;
 
-	if (id->driver_info & BTUSB_DIGIANSWER) {
-		data->cmdreq_type = USB_TYPE_VENDOR;
-		set_bit(HCI_QUIRK_NO_RESET, &hdev->quirks);
-	}
-
-	if (id->driver_info & BTUSB_CSR) {
-		struct usb_device *udev = data->udev;
-
-		/* Old firmware would otherwise execute USB reset */
-		if (le16_to_cpu(udev->descriptor.bcdDevice) < 0x117)
-			set_bit(HCI_QUIRK_NO_RESET, &hdev->quirks);
-	}
-
 	if (id->driver_info & BTUSB_SNIFFER) {
 		struct usb_device *udev = data->udev;
 
-		/* New sniffer firmware has crippled HCI interface */
 		if (le16_to_cpu(udev->descriptor.bcdDevice) > 0x997)
 			set_bit(HCI_QUIRK_RAW_DEVICE, &hdev->quirks);
 


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
