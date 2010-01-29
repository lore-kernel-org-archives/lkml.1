Return-Path: <linux-kernel-owner+w=401wt.eu-S932329Ab0A2OVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329Ab0A2OVN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 09:21:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932231Ab0A2OVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 09:21:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57155 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932251Ab0A2OVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 09:21:04 -0500
Date: Fri, 29 Jan 2010 15:21:03 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "Gunn, Brian" <bgunn@solekai.com>, Marcel Holtmann <marcel@holtmann.org>,
       Ping <pinglinux@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       BlueZ development <linux-bluetooth@vger.kernel.org>
Subject: [PATCH 3/3] HID: Enable Sixaxis controller over Bluetooth
In-Reply-To: <alpine.LNX.2.00.1001291515560.356@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1001291519560.356@pobox.suse.cz>
References: <alpine.LNX.2.00.1001291515560.356@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bastien Nocera <hadess@hadess.net>

Now that hid_output_raw_report works, port the PS3 Sixaxis Bluetooth quirk 
from user-space, into kernel-space.

Signed-off-by: Bastien Nocera <hadess@hadess.net>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 drivers/hid/hid-core.c |    1 +
 drivers/hid/hid-sony.c |   15 ++++++++++++++-
 2 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index eabe5f8..f7f80e1 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1340,6 +1340,7 @@ static const struct hid_device_id hid_blacklist[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PETALYNX, USB_DEVICE_ID_PETALYNX_MAXTER_REMOTE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAMSUNG, USB_DEVICE_ID_SAMSUNG_IR_REMOTE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS3_CONTROLLER) },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS3_CONTROLLER) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_VAIO_VGX_MOUSE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SUNPLUS, USB_DEVICE_ID_SUNPLUS_WDESKTOP) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb300) },
diff --git a/drivers/hid/hid-sony.c b/drivers/hid/hid-sony.c
index 4e84502..08b7fa0 100644
--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -73,6 +73,12 @@ static int sony_set_operational(struct hid_device *hdev)
 	return ret;
 }
 
+static int sony_set_operational_bt(struct hid_device *hdev)
+{
+	unsigned char buf[] = { 0x53, 0xf4,  0x42, 0x03, 0x00, 0x00 };
+	return hdev->hid_output_raw_report(hdev, buf, sizeof(buf), HID_FEATURE_REPORT);
+}
+
 static int sony_probe(struct hid_device *hdev, const struct hid_device_id *id)
 {
 	int ret;
@@ -101,7 +107,13 @@ static int sony_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		goto err_free;
 	}
 
-	ret = sony_set_operational(hdev);
+	if (hdev->bus == BUS_USB)
+		ret = sony_set_operational(hdev);
+	else if (hdev->bus == BUS_BLUETOOTH)
+		ret = sony_set_operational_bt(hdev);
+	else
+		ret = 0;
+
 	if (ret < 0)
 		goto err_stop;
 
@@ -121,6 +133,7 @@ static void sony_remove(struct hid_device *hdev)
 
 static const struct hid_device_id sony_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS3_CONTROLLER) },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS3_CONTROLLER) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_VAIO_VGX_MOUSE),
 		.driver_data = VAIO_RDESC_CONSTANT },
 	{ }
-- 
1.6.4.2

