Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611Ab0BCOuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 09:50:32 -0500
Received: from cantor.suse.de ([195.135.220.2]:36422 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755046Ab0BCOua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 09:50:30 -0500
Date: Wed, 3 Feb 2010 15:50:29 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Ping Cheng <pinglinux@gmail.com>
Cc: "Gunn, Brian" <bgunn@solekai.com>, Marcel Holtmann <marcel@holtmann.org>,
       linux-kernel@vger.kernel.org,
       BlueZ development <linux-bluetooth@vger.kernel.org>
Subject: Re: [PATCH 2/3] HID: Implement Wacom quirk in the kernel
In-Reply-To: <167e8a331001290914t578ffef7y16d52e40c8c54079@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1002031549560.15395@pobox.suse.cz>
References: <alpine.LNX.2.00.1001291515560.356@pobox.suse.cz>  <alpine.LNX.2.00.1001291519250.356@pobox.suse.cz> <167e8a331001290914t578ffef7y16d52e40c8c54079@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jan 2010, Ping Cheng wrote:

>       +       rep_data[0] = 0x03; rep_data[1] = 0x00;
>       +       limit =3;
>       +       do {
>       +               ret = hdev->hid_output_raw_report(hdev, rep_data, 2,
>       +                               HID_FEATURE_REPORT);
>       +       } while (ret < 0 && limit-- > 0);
> 
>  
> hdev->hid_output_raw_report error is not a hard failure, i.e., the following four lines are unnecessay. We can continue with the
> rest of the code.
>  
>       +       if (ret < 0) {
>       +               dev_err(&hdev->dev, "failed to poke device #1, %d\n", ret);
>       +               goto err_free;
>       +       }
>       +
>       +       /* 0x06 - high reporting speed, 0x05 - low speed */
>       +       rep_data[0] = 0x06; rep_data[1] = 0x00;
>       +       limit = 3;
>       +       do {
>       +               ret = hdev->hid_output_raw_report(hdev, rep_data, 2,
>       +                               HID_FEATURE_REPORT);
>       +       } while (ret < 0 && limit-- > 0);
> 
>  
> Same comments apply here. "/* Note that if query fails it is not a hard failure */" is the comments we use in the corresponding
> Wacom USB driver, wacom_sys.c

Thanks for the feedback. I have queued the patch below on top of all the 
other changes.


From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] HID: make Wacom modesetting failures non-fatal

With Wacom tablet mode-setting moved from userspace into kernel,
we don't have to consider failures of device queries through the
_raw callback as hard failure, as the driver can safely continue
anyway.

This is consistent with the current USB driver in wacom_sys.c

Reported-by: Ping Cheng <pinglinux@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 drivers/hid/hid-wacom.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/hid/hid-wacom.c b/drivers/hid/hid-wacom.c
index b8778db..8d3b46f 100644
--- a/drivers/hid/hid-wacom.c
+++ b/drivers/hid/hid-wacom.c
@@ -181,6 +181,11 @@ static int wacom_probe(struct hid_device *hdev,
 		goto err_free;
 	}
 
+	/*
+	 * Note that if the raw queries fail, it's not a hard failure and it
+	 * is safe to continue
+	 */
+
 	/* Set Wacom mode2 */
 	rep_data[0] = 0x03; rep_data[1] = 0x00;
 	limit = 3;
@@ -188,10 +193,8 @@ static int wacom_probe(struct hid_device *hdev,
 		ret = hdev->hid_output_raw_report(hdev, rep_data, 2,
 				HID_FEATURE_REPORT);
 	} while (ret < 0 && limit-- > 0);
-	if (ret < 0) {
-		dev_err(&hdev->dev, "failed to poke device #1, %d\n", ret);
-		goto err_free;
-	}
+	if (ret < 0)
+		dev_warn(&hdev->dev, "failed to poke device #1, %d\n", ret);
 
 	/* 0x06 - high reporting speed, 0x05 - low speed */
 	rep_data[0] = 0x06; rep_data[1] = 0x00;
@@ -200,10 +203,8 @@ static int wacom_probe(struct hid_device *hdev,
 		ret = hdev->hid_output_raw_report(hdev, rep_data, 2,
 				HID_FEATURE_REPORT);
 	} while (ret < 0 && limit-- > 0);
-	if (ret < 0) {
-		dev_err(&hdev->dev, "failed to poke device #2, %d\n", ret);
-		goto err_free;
-	}
+	if (ret < 0)
+		dev_warn(&hdev->dev, "failed to poke device #2, %d\n", ret);
 
 	hidinput = list_entry(hdev->inputs.next, struct hid_input, list);
 	input = hidinput->input;
-- 
1.6.4.2

