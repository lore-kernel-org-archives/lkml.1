Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522Ab0BLBDs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 20:03:48 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:44438 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756543Ab0BLBDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 20:03:47 -0500
X-Greylist: delayed 867 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Feb 2010 20:03:47 EST
Date: Thu, 11 Feb 2010 18:49:10 -0600
From: David Fries <david@fries.net>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Oliver Neukum <oliver@neukum.org>, USB list <linux-usb@vger.kernel.org>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: usbhid control queue full, due to stuck control request
Message-ID: <20100212004910.GD22311@spacedout.fries.net>
References: <20100206172051.GA22311@spacedout.fries.net> <201002081256.01614.oliver@neukum.org> <20100209023508.GB22311@spacedout.fries.net> <20100211010450.GC22311@spacedout.fries.net> <alpine.LRH.2.00.1002111617290.16183@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1002111617290.16183@twin.jikos.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Thu, 11 Feb 2010 18:49:12 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oliver Neukum <oliver@neukum.org>

Some devices do not react to a control request (seen on APC UPS's)
resulting in a slow stream of messages,
"generic-usb ... control queue full".
Therefore request need a timeout.

Signed-off-by: Oliver Neukum <oliver@neukum.org>
Duplicated the change from last_out to last_ctrl and verified.
Signed-off-by: David Fries <david@fries.net>
---

Oliver Neukum, this is based on your patch, do you agree with the
changes?

One possible problem with this fix is it drops the stalled URB
transfer.  That might pose a problem for one shot messages, possibly
hid_ctrl and hid_irq_out could resubmit the same urb when -ECONNRESET
is received, assuming the message content wasn't the reason it
timedout in the first place.
David Fries <david@fries.net>

 drivers/hid/usbhid/hid-core.c |   28 ++++++++++++++++++++++++++--
 drivers/hid/usbhid/usbhid.h   |    2 ++
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 3c1fcb7..076a29a 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -318,6 +318,7 @@ static int hid_submit_out(struct hid_device *hid)
 			err_hid("usb_submit_urb(out) failed");
 			return -1;
 		}
+		usbhid->last_out = jiffies;
 	} else {
 		/*
 		 * queue work to wake up the device.
@@ -379,6 +380,7 @@ static int hid_submit_ctrl(struct hid_device *hid)
 			err_hid("usb_submit_urb(ctrl) failed");
 			return -1;
 		}
+		usbhid->last_ctrl = jiffies;
 	} else {
 		/*
 		 * queue work to wake up the device.
@@ -513,9 +515,20 @@ void __usbhid_submit_report(struct hid_device *hid, struct hid_report *report, u
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
 
@@ -536,9 +549,20 @@ void __usbhid_submit_report(struct hid_device *hid, struct hid_report *report, u
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
diff --git a/drivers/hid/usbhid/usbhid.h b/drivers/hid/usbhid/usbhid.h
index 08f505c..ec20400 100644
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
-- 
1.5.6.5

