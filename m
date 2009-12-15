Return-Path: <linux-kernel-owner+w=401wt.eu-S1760071AbZLOMHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760071AbZLOMHR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 07:07:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760041AbZLOMHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 07:07:15 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:52067 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758245AbZLOMHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 07:07:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=V4bk6kWjYHjEOD7yvx5w3KjAG+MKHpfIobUHDJK01G7g/vsumarnMivb67wYMdY3J6
         P19nHeJEzXP7/WVS0G4U10nciCJC7jpaz4gGoiv6BYM5b67beiajV+8uskpX/KwrMIfn
         W1JHtjgSBkcn8Jul9ZEKuFlES4S+9qikWH8Vs=
From: Stefan Seyfried <stefan.seyfried@googlemail.com>
To: linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
       Stefan Seyfried <seife@sphairon.com>
Subject: [PATCH] move eject code from zd1211rw to usb-storage
Date: Tue, 15 Dec 2009 13:06:40 +0100
Message-Id: <1260878800-14691-1-git-send-email-stefan.seyfried@googlemail.com>
X-Mailer: git-send-email 1.6.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Seyfried <seife@sphairon.com>

The USB ID claimed by zd1211rw for the fake storage device is
also in use by other, non-zd1211rw devices (Sphairon Homelink
1202). Move the eject of these devices to where it belongs and
where all the needed infrastructure already exists: usb-storage.

Signed-off-by: Stefan Seyfried <seife@sphairon.com>
---
 drivers/net/wireless/zd1211rw/zd_usb.c |   57 +-------------------------------
 drivers/net/wireless/zd1211rw/zd_usb.h |    1 -
 drivers/usb/storage/initializers.c     |   28 +++++++++++++++
 drivers/usb/storage/initializers.h     |    3 ++
 drivers/usb/storage/unusual_devs.h     |   13 ++++---
 5 files changed, 39 insertions(+), 63 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index ac19ecd..983ebdb 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -90,9 +90,6 @@ static struct usb_device_id usb_ids[] = {
 	{ USB_DEVICE(0x157e, 0x300d), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x1582, 0x6003), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x2019, 0x5303), .driver_info = DEVICE_ZD1211B },
-	/* "Driverless" devices that need ejecting */
-	{ USB_DEVICE(0x0ace, 0x2011), .driver_info = DEVICE_INSTALLER },
-	{ USB_DEVICE(0x0ace, 0x20ff), .driver_info = DEVICE_INSTALLER },
 	{}
 };
 
@@ -1068,54 +1065,6 @@ static void print_id(struct usb_device *udev)
 #define print_id(udev) do { } while (0)
 #endif
 
-static int eject_installer(struct usb_interface *intf)
-{
-	struct usb_device *udev = interface_to_usbdev(intf);
-	struct usb_host_interface *iface_desc = &intf->altsetting[0];
-	struct usb_endpoint_descriptor *endpoint;
-	unsigned char *cmd;
-	u8 bulk_out_ep;
-	int r;
-
-	/* Find bulk out endpoint */
-	endpoint = &iface_desc->endpoint[1].desc;
-	if (usb_endpoint_dir_out(endpoint) &&
-	    usb_endpoint_xfer_bulk(endpoint)) {
-		bulk_out_ep = endpoint->bEndpointAddress;
-	} else {
-		dev_err(&udev->dev,
-			"zd1211rw: Could not find bulk out endpoint\n");
-		return -ENODEV;
-	}
-
-	cmd = kzalloc(31, GFP_KERNEL);
-	if (cmd == NULL)
-		return -ENODEV;
-
-	/* USB bulk command block */
-	cmd[0] = 0x55;	/* bulk command signature */
-	cmd[1] = 0x53;	/* bulk command signature */
-	cmd[2] = 0x42;	/* bulk command signature */
-	cmd[3] = 0x43;	/* bulk command signature */
-	cmd[14] = 6;	/* command length */
-
-	cmd[15] = 0x1b;	/* SCSI command: START STOP UNIT */
-	cmd[19] = 0x2;	/* eject disc */
-
-	dev_info(&udev->dev, "Ejecting virtual installer media...\n");
-	r = usb_bulk_msg(udev, usb_sndbulkpipe(udev, bulk_out_ep),
-		cmd, 31, NULL, 2000);
-	kfree(cmd);
-	if (r)
-		return r;
-
-	/* At this point, the device disconnects and reconnects with the real
-	 * ID numbers. */
-
-	usb_set_intfdata(intf, NULL);
-	return 0;
-}
-
 int zd_usb_init_hw(struct zd_usb *usb)
 {
 	int r;
@@ -1157,9 +1106,6 @@ static int probe(struct usb_interface *intf, const struct usb_device_id *id)
 
 	print_id(udev);
 
-	if (id->driver_info & DEVICE_INSTALLER)
-		return eject_installer(intf);
-
 	switch (udev->speed) {
 	case USB_SPEED_LOW:
 	case USB_SPEED_FULL:
@@ -1219,8 +1165,7 @@ static void disconnect(struct usb_interface *intf)
 	struct zd_mac *mac;
 	struct zd_usb *usb;
 
-	/* Either something really bad happened, or we're just dealing with
-	 * a DEVICE_INSTALLER. */
+	/* something really bad happened */
 	if (hw == NULL)
 		return;
 
diff --git a/drivers/net/wireless/zd1211rw/zd_usb.h b/drivers/net/wireless/zd1211rw/zd_usb.h
index 049f8b9..0bc96f2 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.h
+++ b/drivers/net/wireless/zd1211rw/zd_usb.h
@@ -35,7 +35,6 @@
 enum devicetype {
 	DEVICE_ZD1211  = 0,
 	DEVICE_ZD1211B = 1,
-	DEVICE_INSTALLER = 2,
 };
 
 enum endpoints {
diff --git a/drivers/usb/storage/initializers.c b/drivers/usb/storage/initializers.c
index 105d900..da28924 100644
--- a/drivers/usb/storage/initializers.c
+++ b/drivers/usb/storage/initializers.c
@@ -104,3 +104,31 @@ int usb_stor_huawei_e220_init(struct us_data *us)
 	US_DEBUGP("Huawei mode set result is %d\n", result);
 	return 0;
 }
+
+/* eject fake USB cdrom on zd1211rw and similar devices */
+int zd1211rw_eject_installer(struct us_data *us)
+{
+	unsigned char *cmd;
+	int r;
+
+	cmd = kzalloc(31, GFP_KERNEL);
+	if (cmd == NULL)
+		return -ENODEV;
+
+	/* USB bulk command block */
+	cmd[0] = 0x55;	/* bulk command signature */
+	cmd[1] = 0x53;	/* bulk command signature */
+	cmd[2] = 0x42;	/* bulk command signature */
+	cmd[3] = 0x43;	/* bulk command signature */
+	cmd[14] = 6;	/* command length */
+
+	cmd[15] = 0x1b;	/* SCSI command: START STOP UNIT */
+	cmd[19] = 0x2;	/* eject disc */
+
+	US_DEBUGP("Ejecting zd1211rw virtual installer media...\n");
+	r = usb_stor_bulk_transfer_buf(us, us->send_bulk_pipe,
+			cmd, 31, NULL);
+	kfree(cmd);
+
+	return r;
+}
diff --git a/drivers/usb/storage/initializers.h b/drivers/usb/storage/initializers.h
index 529327f..e7bec81 100644
--- a/drivers/usb/storage/initializers.h
+++ b/drivers/usb/storage/initializers.h
@@ -48,3 +48,6 @@ int usb_stor_ucr61s2b_init(struct us_data *us);
 
 /* This places the HUAWEI E220 devices in multi-port mode */
 int usb_stor_huawei_e220_init(struct us_data *us);
+
+/* eject fake USB cdrom on zd1211rw and similar devices */
+int zd1211rw_eject_installer(struct us_data *us);
diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index d4f034e..4f05e01 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1103,19 +1103,20 @@ UNUSUAL_DEV( 0x0a17, 0x0004, 0x1000, 0x1000,
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_FIX_INQUIRY ),
 
-/* These are virtual windows driver CDs, which the zd1211rw driver
- * automatically converts into WLAN devices. */
+/* These are virtual windows driver CDs, which the zd1211rw driver or
+ * ar9170usb handle after we switched them them out of storage mode
+ */
 UNUSUAL_DEV( 0x0ace, 0x2011, 0x0101, 0x0101,
 		"ZyXEL",
 		"G-220F USB-WLAN Install",
-		US_SC_DEVICE, US_PR_DEVICE, NULL,
-		US_FL_IGNORE_DEVICE ),
+		US_SC_DEVICE, US_PR_DEVICE, zd1211rw_eject_installer,
+		0),
 
 UNUSUAL_DEV( 0x0ace, 0x20ff, 0x0101, 0x0101,
 		"SiteCom",
 		"WL-117 USB-WLAN Install",
-		US_SC_DEVICE, US_PR_DEVICE, NULL,
-		US_FL_IGNORE_DEVICE ),
+		US_SC_DEVICE, US_PR_DEVICE, zd1211rw_eject_installer,
+		0),
 
 /* Reported by Dan Williams <dcbw@redhat.com>
  * Option N.V. mobile broadband modems
-- 
1.6.5.3

