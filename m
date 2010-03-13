Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935488Ab0CMAcA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:32:00 -0500
Received: from kroah.org ([198.145.64.141]:46755 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935381Ab0CMAbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:31:06 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:07 2010
Message-Id: <20100313002707.862379726@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:26:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Oliver Neukum <oliver@neukum.org>, David Fries <david@fries.net>,
       Jiri Kosina <jkosina@suse.cz>
Subject: [030/145] HID: usbhid: introduce timeout for stuck ctrl/out URBs
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Oliver Neukum <oliver@neukum.org>

commit 858155fbcc0cd713f6382c527bb1c3abc0ed6d00 upstream.

Some devices do not react to a control request (seen on APC UPS's) resulting in
a slow stream of messages, "generic-usb ... control queue full".  Therefore
request needs a timeout.

Signed-off-by: Oliver Neukum <oliver@neukum.org>
Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/usbhid/hid-core.c |   28 ++++++++++++++++++++++++++--
 drivers/hid/usbhid/usbhid.h   |    2 ++
 2 files changed, 28 insertions(+), 2 deletions(-)

--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -318,6 +318,7 @@ static int hid_submit_out(struct hid_dev
 			err_hid("usb_submit_urb(out) failed");
 			return -1;
 		}
+		usbhid->last_out = jiffies;
 	} else {
 		/*
 		 * queue work to wake up the device.
@@ -379,6 +380,7 @@ static int hid_submit_ctrl(struct hid_de
 			err_hid("usb_submit_urb(ctrl) failed");
 			return -1;
 		}
+		usbhid->last_ctrl = jiffies;
 	} else {
 		/*
 		 * queue work to wake up the device.
@@ -514,9 +516,20 @@ static void __usbhid_submit_report(struc
 		usbhid->out[usbhid->outhead].report = report;
 		usbhid->outhead = head;
 
-		if (!test_and_set_bit(HID_OUT_RUNNING, &usbhid->iofl))
+		if (!test_and_set_bit(HID_OUT_RUNNING, &usbhid->iofl)) {
 			if (hid_submit_out(hid))
 				clear_bit(HID_OUT_RUNNING, &usbhid->iofl);
+		} else {
+			/*
+			 * the queue is known to run
+			 * but an earlier request may be stuck
+			 * we may need to time out
+			 * no race because this is called under
+			 * spinlock
+			 */
+			if (time_after(jiffies, usbhid->last_out + HZ * 5))
+				usb_unlink_urb(usbhid->urbout);
+		}
 		return;
 	}
 
@@ -537,9 +550,20 @@ static void __usbhid_submit_report(struc
 	usbhid->ctrl[usbhid->ctrlhead].dir = dir;
 	usbhid->ctrlhead = head;
 
-	if (!test_and_set_bit(HID_CTRL_RUNNING, &usbhid->iofl))
+	if (!test_and_set_bit(HID_CTRL_RUNNING, &usbhid->iofl)) {
 		if (hid_submit_ctrl(hid))
 			clear_bit(HID_CTRL_RUNNING, &usbhid->iofl);
+	} else {
+		/*
+		 * the queue is known to run
+		 * but an earlier request may be stuck
+		 * we may need to time out
+		 * no race because this is called under
+		 * spinlock
+		 */
+		if (time_after(jiffies, usbhid->last_ctrl + HZ * 5))
+			usb_unlink_urb(usbhid->urbctrl);
+	}
 }
 
 void usbhid_submit_report(struct hid_device *hid, struct hid_report *report, unsigned char dir)
--- a/drivers/hid/usbhid/usbhid.h
+++ b/drivers/hid/usbhid/usbhid.h
@@ -80,12 +80,14 @@ struct usbhid_device {
 	unsigned char ctrlhead, ctrltail;                               /* Control fifo head & tail */
 	char *ctrlbuf;                                                  /* Control buffer */
 	dma_addr_t ctrlbuf_dma;                                         /* Control buffer dma */
+	unsigned long last_ctrl;						/* record of last output for timeouts */
 
 	struct urb *urbout;                                             /* Output URB */
 	struct hid_output_fifo out[HID_CONTROL_FIFO_SIZE];              /* Output pipe fifo */
 	unsigned char outhead, outtail;                                 /* Output pipe fifo head & tail */
 	char *outbuf;                                                   /* Output buffer */
 	dma_addr_t outbuf_dma;                                          /* Output buffer dma */
+	unsigned long last_out;							/* record of last output for timeouts */
 
 	spinlock_t lock;						/* fifo spinlock */
 	unsigned long iofl;                                             /* I/O flags (CTRL_RUNNING, OUT_RUNNING) */


