Return-Path: <linux-kernel-owner+w=401wt.eu-S1751581AbXB0Nnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581AbXB0Nnn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 08:43:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbXB0Nnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 08:43:43 -0500
Received: from twin.jikos.cz ([213.151.79.26]:55722 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581AbXB0Nnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 08:43:42 -0500
Date: Tue, 27 Feb 2007 14:43:26 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Marcel Holtmann <marcel@holtmann.org>
cc: bluez-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [RFC] [PATCH] bluetooth hid quirks - mightymouse quirk
Message-ID: <Pine.LNX.4.64.0702271416140.10496@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a bugreport that scrollwheel of bluetooth version of apple 
mightymouse doesn't work. The USB version of mightymouse works, as there 
is a quirk for handling scrollwheel in hid/usbhid for it.

Now that bluetooth git tree is hooked to generic hid layer, it could 
easily use the quirks which are already present in generic hid parser, 
hid-input, etc.

Below is a simple patch against bluetooth git tree, which adds quirk 
handling to current bluetooth hidp code, and sets quirk flags for device 
0x05ac/0x030c, which is the bluetooth version of the apple mightymouse.

Is this the right thing to do?

Also, it would be great if anyone who actually owns the hardware could 
test that this makes the scrollwheel work.

Thanks.


From: Jiri Kosina <jkosina@suse.cz>

[PATCH] [Bluetooth] hid quirks - mightymouse quirk

This patch allows bluetooth hid devices to use quirks which are
already present in generic hid layer. It also adds quirk for
bluetooth version of apple mightymouse.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 net/bluetooth/hidp/core.c |   13 +++++++++++++
 net/bluetooth/hidp/hidp.h |   17 +++++++++++++++++
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
index 4c914df..bdd4fd8 100644
--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -679,6 +679,17 @@ static void hidp_close(struct hid_device *hid)
 {
 }
 
+static void hidp_setup_quirks(struct hid_device *hid)
+{
+	unsigned int n;
+
+	for (n = 0; hid_blacklist[n].idVendor; n++)
+		if ((hid_blacklist[n].idVendor == le16_to_cpu(hid->vendor)) &&
+				(hid_blacklist[n].idProduct == le16_to_cpu(hid->product)))
+			hid->quirks = hid_blacklist[n].quirks;
+
+}
+
 static inline void hidp_setup_hid(struct hidp_session *session, struct hidp_connadd_req *req)
 {
 	struct hid_device *hid = session->hid;
@@ -708,6 +719,8 @@ static inline void hidp_setup_hid(struct hidp_session *session, struct hidp_conn
 
 	hid->hidinput_input_event = hidp_hidinput_event;
 
+	hidp_setup_quirks(hid);
+
 	list_for_each_entry(report, &hid->report_enum[HID_INPUT_REPORT].report_list, list)
 		hidp_send_report(session, report);
 
diff --git a/net/bluetooth/hidp/hidp.h b/net/bluetooth/hidp/hidp.h
index 343fb05..a262081 100644
--- a/net/bluetooth/hidp/hidp.h
+++ b/net/bluetooth/hidp/hidp.h
@@ -23,6 +23,7 @@
 #ifndef __HIDP_H
 #define __HIDP_H
 
+#include <linux/hid.h>
 #include <linux/types.h>
 #include <net/bluetooth/bluetooth.h>
 
@@ -166,4 +167,20 @@ static inline void hidp_schedule(struct hidp_session *session)
 extern int __init hidp_init_sockets(void);
 extern void __exit hidp_cleanup_sockets(void);
 
+/* HID blacklist and quirk entries */
+
+#define BT_VENDOR_ID_APPLE		0x05ac
+#define BT_DEVICE_ID_APPLE_MIGHTYMOUSE	0x030c
+
+static const struct hid_blacklist {
+	__u16 idVendor;
+	__u16 idProduct;
+	unsigned quirks;
+} hid_blacklist[] = {
+
+	{ BT_VENDOR_ID_APPLE, BT_DEVICE_ID_APPLE_MIGHTYMOUSE, HID_QUIRK_MIGHTYMOUSE | HID_QUIRK_INVERT_HWHEEL },
+
+	{ 0, 0 }
+};
+
 #endif /* __HIDP_H */

