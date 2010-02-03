Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271Ab0BCMtX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 07:49:23 -0500
Received: from cantor.suse.de ([195.135.220.2]:60098 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757251Ab0BCMtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 07:49:21 -0500
Date: Wed, 3 Feb 2010 13:49:19 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Bastien Nocera <hadess@hadess.net>, Marcel Holtmann <marcel@holtmann.org>
Cc: Michael Poole <mdpoole@troilus.org>, "Gunn, Brian" <bgunn@solekai.com>,
       Ping <pinglinux@gmail.com>, linux-kernel@vger.kernel.org,
       BlueZ development <linux-bluetooth@vger.kernel.org>
Subject: [PATCH 1/3] HID: make raw reports possible for both feature and
 output reports
In-Reply-To: <alpine.LNX.2.00.1002031343500.15395@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1002031348450.15395@pobox.suse.cz>
References: <alpine.LNX.2.00.1001291515560.356@pobox.suse.cz>  <1264783166.29532.5302.camel@localhost.localdomain>  <87iqakifm8.fsf@troilus.org>  <1264860663.29532.7887.camel@localhost.localdomain>  <87bpg7glf7.fsf@troilus.org> <1265190440.32444.8417.camel@localhost.localdomain>
 <alpine.LNX.2.00.1002031202040.15395@pobox.suse.cz> <alpine.LNX.2.00.1002031343500.15395@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit 2da31939a42 ("Bluetooth: Implement raw output support for HIDP
layer"), support for Bluetooth hid_output_raw_report was added, but it
pushes the data to the intr socket instead of the ctrl one. This has been
fixed by 6bf8268f9a91f1 ("Bluetooth: Use the control channel for raw HID reports")

Still, it is necessary to distinguish whether the report in question should be
either FEATURE or OUTPUT. For this, we have to extend the generic HID API,
so that hid_output_raw_report() callback provides means to specify this
value so that it can be passed down to lower level hardware drivers (currently
Bluetooth and USB).

Based on original patch by Bastien Nocera <hadess@hadess.net>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 drivers/hid/hidraw.c          |    2 +-
 drivers/hid/usbhid/hid-core.c |    5 +++--
 include/linux/hid.h           |    2 +-
 net/bluetooth/hidp/core.c     |   13 ++++++++++---
 4 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index cdd1369..d044767 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -134,7 +134,7 @@ static ssize_t hidraw_write(struct file *file, const char __user *buffer, size_t
 		goto out;
 	}
 
-	ret = dev->hid_output_raw_report(dev, buf, count);
+	ret = dev->hid_output_raw_report(dev, buf, count, HID_OUTPUT_REPORT);
 out:
 	kfree(buf);
 	return ret;
diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index e2997a8..caa16c0 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -774,7 +774,8 @@ static int hid_alloc_buffers(struct usb_device *dev, struct hid_device *hid)
 	return 0;
 }
 
-static int usbhid_output_raw_report(struct hid_device *hid, __u8 *buf, size_t count)
+static int usbhid_output_raw_report(struct hid_device *hid, __u8 *buf, size_t count,
+		unsigned char report_type)
 {
 	struct usbhid_device *usbhid = hid->driver_data;
 	struct usb_device *dev = hid_to_usb_dev(hid);
@@ -785,7 +786,7 @@ static int usbhid_output_raw_report(struct hid_device *hid, __u8 *buf, size_t co
 	ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
 		HID_REQ_SET_REPORT,
 		USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
-		((HID_OUTPUT_REPORT + 1) << 8) | *buf,
+		((report_type + 1) << 8) | *buf,
 		interface->desc.bInterfaceNumber, buf + 1, count - 1,
 		USB_CTRL_SET_TIMEOUT);
 
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 8709365..3661a62 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -501,7 +501,7 @@ struct hid_device {							/* device report descriptor */
 	void (*hiddev_report_event) (struct hid_device *, struct hid_report *);
 
 	/* handler for raw output data, used by hidraw */
-	int (*hid_output_raw_report) (struct hid_device *, __u8 *, size_t);
+	int (*hid_output_raw_report) (struct hid_device *, __u8 *, size_t, unsigned char);
 
 	/* debugging support via debugfs */
 	unsigned short debug;
diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
index 6cf526d..9c88750 100644
--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -313,10 +313,17 @@ static int hidp_send_report(struct hidp_session *session, struct hid_report *rep
 	return hidp_queue_report(session, buf, rsize);
 }
 
-static int hidp_output_raw_report(struct hid_device *hid, unsigned char *data, size_t count)
+static int hidp_output_raw_report(struct hid_device *hid, unsigned char *data, size_t count,
+		unsigned char report_type)
 {
-	if (hidp_send_ctrl_message(hid->driver_data,
-			HIDP_TRANS_SET_REPORT | HIDP_DATA_RTYPE_FEATURE,
+	if (report_type == HID_FEATURE_REPORT)
+		report_type = HIDP_TRANS_SET_REPORT | HIDP_DATA_RTYPE_FEATURE;
+	else if (report_type == HID_OUTPUT_REPORT)
+		report_type = HIDP_TRANS_DATA | HIDP_DATA_RTYPE_OUPUT;
+	else
+		return -EINVAL;
+
+	if (hidp_send_ctrl_message(hid->driver_data, report_type,
 			data, count))
 		return -ENOMEM;
 	return count;
-- 
1.6.4.2

