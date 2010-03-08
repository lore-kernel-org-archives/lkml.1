Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab0CHVOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 16:14:15 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:62249 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755927Ab0CHVOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 16:14:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=hi3FbUnIqpp86ebdJkiyL49mn74K3SIeGwCXGtHI8YWWPlKSWkukU3fy6kNeL7x4AM
         8CqCAenacpOtMaKu5iQRQKIuhgScqC2/Urkp0ytqjBh11Xg5LKhG8oW0/W+E6uBF7nvq
         YWkak+D/vx1pZwD4oaDlkJG0VsGwVwkyE+wc8=
From: mickib1@gmail.com
To: jkosina@suse.cz, rafi@seas.upenn.edu, chatty@enac.fr, peterhuewe@gmx.de,
       micki@n-trig.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] HID: N-trig MTM Driver fix And cleanup Patch 4
Date: Mon,  8 Mar 2010 23:13:44 +0200
Message-Id: <1268082827-2680-4-git-send-email-micki@n-trig.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1268082827-2680-3-git-send-email-micki@n-trig.com>
References: <1268082827-2680-1-git-send-email-micki@n-trig.com>
 <1268082827-2680-2-git-send-email-micki@n-trig.com>
 <1268082827-2680-3-git-send-email-micki@n-trig.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: micki <micki@micki-laptop.(none)>

Add ntrig_send_report - enable us to configure firmware.

N-trig is changing the way people interact with computers by providing a dual-mode pen and true multi-touch input device, specifically designed for today's advanced computing world.
N-trig DuoSense® solution provides a real Hands-on computing® experience, and sets the stage for OEMs and ISVs to introduce innovative computer products and applications for an intuitive, Hands-on® experience directly onscreen.
DuoSense digitizers are easily integrated into existing technologies, support all LCDs, keep devices slim and light, and can be implemented in a broad range of products, ranging from small notebooks to large LCDs.
N-trig has offices in Israel, the US, Taiwan and Japan.

Signed-off-by: Micki Balanga <micki@n-trig.com>
---
 drivers/hid/hid-ntrig.c |   50 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
index 8130c3c..8cdb3c2 100644
--- a/drivers/hid/hid-ntrig.c
+++ b/drivers/hid/hid-ntrig.c
@@ -17,6 +17,8 @@
  *		Add debug Paramater change Driver name in hid_driver structure
  *	1.2 - N-trig - Change ntrig_input_mapping
  *	1.3 - N-trig - Change ntrig_input_mapped
+ *	1.4 - N-trig - Add ntrig_send_report function
+ *		send set feature command to firmware
  */
 
 /*
@@ -361,6 +363,54 @@ static int ntrig_event(struct hid_device *hid, struct hid_field *field,
 	return 1;
 }
 
+/*
+ * This function used to configure N-trig firmware
+ * The first command we need to send to firmware is change
+ * to Multi-touch Mode we don't receive a reply
+ */
+static int ntrig_send_report(struct hid_device *hid)
+{
+	struct hid_report *report;
+	struct list_head *report_list =
+			&hid->report_enum[HID_FEATURE_REPORT].report_list;
+
+	if (list_empty(report_list)) {
+		ntrig_dbg("no feature reports found\n");
+		return -ENODEV;
+	}
+	report = list_first_entry(report_list, struct hid_report, list);
+	if (report->maxfield < 1)
+		return -ENODEV;
+
+	list_for_each_entry(report,
+			    report_list, list) {
+		if (report->maxfield < 1) {
+		      ntrig_dbg("no fields in the report\n");
+		      continue;
+		}
+		ntrig_dbg("Report ID %x\n", report->id);
+		switch (report->id) {
+		case REPORTID_DRIVER_ALIVE:
+		      usbhid_submit_report(hid, report, USB_DIR_OUT);
+		      break;
+		      /*
+		       * These command will implement later accroding to demand
+		       */
+		case REPORTID_GET_VERSION:	/* FALLTHRU */
+		case REPORTID_SET_MODE_DUAL:	/* FALLTHRU */
+		case REPORTID_CALIBRATION:	/* FALLTHRU */
+		case REPORTID_GET_MODE:		/* FALLTHRU */
+		case REPORTID_SET_MODE_PEN:	/* FALLTHRU */
+		case REPORTID_SET_MODE_TOUCH:	/* FALLTHRU */
+		case REPORTID_CALIBRATION_RESPOND:/* FALLTHRU */
+		case HID_CAPACITORS_CALIB:	/* FALLTHRU */
+		case HID_GET_CAPACITORS_CALIB_DONE:
+		      break;
+		}
+	}
+	return 0;
+}
+
 static int ntrig_probe(struct hid_device *hdev, const struct hid_device_id *id)
 {
 	int ret;
-- 
1.6.3.3

