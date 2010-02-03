Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403Ab0BCMtz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 07:49:55 -0500
Received: from cantor.suse.de ([195.135.220.2]:60112 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757239Ab0BCMtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 07:49:53 -0500
Date: Wed, 3 Feb 2010 13:49:51 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Bastien Nocera <hadess@hadess.net>
Cc: Michael Poole <mdpoole@troilus.org>, "Gunn, Brian" <bgunn@solekai.com>,
       Ping <pinglinux@gmail.com>, linux-kernel@vger.kernel.org,
       BlueZ development <linux-bluetooth@vger.kernel.org>,
       Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 2/3] HID: Implement Wacom quirk in the kernel
In-Reply-To: <alpine.LNX.2.00.1002031343500.15395@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1002031349230.15395@pobox.suse.cz>
References: <alpine.LNX.2.00.1001291515560.356@pobox.suse.cz>  <1264783166.29532.5302.camel@localhost.localdomain>  <87iqakifm8.fsf@troilus.org>  <1264860663.29532.7887.camel@localhost.localdomain>  <87bpg7glf7.fsf@troilus.org> <1265190440.32444.8417.camel@localhost.localdomain>
 <alpine.LNX.2.00.1002031202040.15395@pobox.suse.cz> <alpine.LNX.2.00.1002031343500.15395@pobox.suse.cz>
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

