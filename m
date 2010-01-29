Return-Path: <linux-kernel-owner+w=401wt.eu-S932253Ab0A2OVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253Ab0A2OVF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 09:21:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932231Ab0A2OVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 09:21:00 -0500
Received: from cantor.suse.de ([195.135.220.2]:51995 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932227Ab0A2OU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 09:20:58 -0500
Date: Fri, 29 Jan 2010 15:20:56 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "Gunn, Brian" <bgunn@solekai.com>, Marcel Holtmann <marcel@holtmann.org>,
       Ping <pinglinux@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       BlueZ development <linux-bluetooth@vger.kernel.org>
Subject: [PATCH 2/3] HID: Implement Wacom quirk in the kernel
In-Reply-To: <alpine.LNX.2.00.1001291515560.356@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1001291519250.356@pobox.suse.cz>
References: <alpine.LNX.2.00.1001291515560.356@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bastien Nocera <hadess@hadess.net>

The hid-wacom driver required user-space to poke at the tablet
to make it send data about the cursor location.

This patch makes it do the same thing but in the kernel.

Signed-off-by: Bastien Nocera <hadess@hadess.net>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 drivers/hid/hid-wacom.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-wacom.c b/drivers/hid/hid-wacom.c
index 12dcda5..d7897b5 100644
--- a/drivers/hid/hid-wacom.c
+++ b/drivers/hid/hid-wacom.c
@@ -156,7 +156,9 @@ static int wacom_probe(struct hid_device *hdev,
 	struct hid_input *hidinput;
 	struct input_dev *input;
 	struct wacom_data *wdata;
+	char rep_data[2];
 	int ret;
+	int limit;
 
 	wdata = kzalloc(sizeof(*wdata), GFP_KERNEL);
 	if (wdata == NULL) {
@@ -166,6 +168,7 @@ static int wacom_probe(struct hid_device *hdev,
 
 	hid_set_drvdata(hdev, wdata);
 
+	/* Parse the HID report now */
 	ret = hid_parse(hdev);
 	if (ret) {
 		dev_err(&hdev->dev, "parse failed\n");
@@ -178,6 +181,30 @@ static int wacom_probe(struct hid_device *hdev,
 		goto err_free;
 	}
 
+	/* Set Wacom mode2 */
+	rep_data[0] = 0x03; rep_data[1] = 0x00;
+	limit =3;
+	do {
+		ret = hdev->hid_output_raw_report(hdev, rep_data, 2,
+				HID_FEATURE_REPORT);
+	} while (ret < 0 && limit-- > 0);
+	if (ret < 0) {
+		dev_err(&hdev->dev, "failed to poke device #1, %d\n", ret);
+		goto err_free;
+	}
+
+	/* 0x06 - high reporting speed, 0x05 - low speed */
+	rep_data[0] = 0x06; rep_data[1] = 0x00;
+	limit = 3;
+	do {
+		ret = hdev->hid_output_raw_report(hdev, rep_data, 2,
+				HID_FEATURE_REPORT);
+	} while (ret < 0 && limit-- > 0);
+	if (ret < 0) {
+		dev_err(&hdev->dev, "failed to poke device #2, %d\n", ret);
+		goto err_free;
+	}
+
 	hidinput = list_entry(hdev->inputs.next, struct hid_input, list);
 	input = hidinput->input;
 
-- 
1.6.4.2

