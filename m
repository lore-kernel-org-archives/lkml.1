Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936297Ab0CMBK3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:10:29 -0500
Received: from kroah.org ([198.145.64.141]:46714 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935364Ab0CMAaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:30:55 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:07 2010
Message-Id: <20100313002707.428427242@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:25:58 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Theodore Kilgore <kilgota@auburn.edu>,
       Hans de Goede <hdegoede@redhat.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [025/145] V4L/DVB (13991): gspca_mr973010a: Fix cif type 1 cameras not streaming on UHCI controllers
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Theodore Kilgore <kilgota@auburn.edu>

commit 70136081fc67ea77d849f86fa323e5773c8e40ea upstream.

If you read the mail to Oliver Neukum on the linux-usb list, then you know
that I found a cure for the mysterious problem that the MR97310a CIF "type
1" cameras have been freezing up and refusing to stream if hooked up to a
machine with a UHCI controller.

Namely, the cure is that if the camera is an mr97310a CIF type 1 camera, you
have to send it 0xa0, 0x00. Somehow, this is a timing reset command, or
such. It un-blocks whatever was previously stopping the CIF type 1 cameras
from working on the UHCI-based machines.

Signed-off-by: Theodore Kilgore <kilgota@auburn.edu>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/gspca/mr97310a.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/media/video/gspca/mr97310a.c
+++ b/drivers/media/video/gspca/mr97310a.c
@@ -530,6 +530,12 @@ static int start_cif_cam(struct gspca_de
 			{0x13, 0x00, {0x01}, 1},
 			{0, 0, {0}, 0}
 		};
+		/* Without this command the cam won't work with USB-UHCI */
+		gspca_dev->usb_buf[0] = 0x0a;
+		gspca_dev->usb_buf[1] = 0x00;
+		err_code = mr_write(gspca_dev, 2);
+		if (err_code < 0)
+			return err_code;
 		err_code = sensor_write_regs(gspca_dev, cif_sensor1_init_data,
 					 ARRAY_SIZE(cif_sensor1_init_data));
 	}


