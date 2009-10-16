Return-Path: <linux-kernel-owner+w=401wt.eu-S1756890AbZJPRT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890AbZJPRT1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 13:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755950AbZJPRSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 13:18:49 -0400
Received: from kroah.org ([198.145.64.141]:48687 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755203AbZJPRSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 13:18:47 -0400
X-Mailbox-Line: From linux@linux.site Fri Oct 16 10:12:09 2009
Message-Id: <20091016171209.422018881@linux.site>
User-Agent: quilt/0.47-14.9
Date: Fri, 16 Oct 2009 10:10:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [43/46] usb-storage: Workaround devices with bogus sense size
References: <20091016170953.128828149@linux.site>
Content-Disposition: inline; filename=usb-storage-workaround-devices-with-bogus-sense-size.patch
In-Reply-To: <20091016171422.GA13339@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit b8430e1b82b7e514d76a88eb70a7d8831d50df1e upstream.

usb-storage: Workaround devices with bogus sense size

Some devices, such as Huawei E169, advertise more than the standard
amount of sense data, causing us to set US_FL_SANE_SENSE, assuming
they support it. However, they subsequently fail the request sense
with that size.

This works around it generically. When a sense request fails due to
a device returning an error, US_FL_SANE_SENSE was set, and that sense
request used a larger sense size, we retry with a smaller size before
giving up.

Based on an original patch by Ben Efros <ben@pc-doctor.com>

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/transport.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/drivers/usb/storage/transport.c
+++ b/drivers/usb/storage/transport.c
@@ -696,7 +696,7 @@ void usb_stor_invoke_transport(struct sc
 		/* device supports and needs bigger sense buffer */
 		if (us->fflags & US_FL_SANE_SENSE)
 			sense_size = ~0;
-
+Retry_Sense:
 		US_DEBUGP("Issuing auto-REQUEST_SENSE\n");
 
 		scsi_eh_prep_cmnd(srb, &ses, NULL, 0, sense_size);
@@ -720,6 +720,21 @@ void usb_stor_invoke_transport(struct sc
 			srb->result = DID_ABORT << 16;
 			goto Handle_Errors;
 		}
+
+		/* Some devices claim to support larger sense but fail when
+		 * trying to request it. When a transport failure happens
+		 * using US_FS_SANE_SENSE, we always retry with a standard
+		 * (small) sense request. This fixes some USB GSM modems
+		 */
+		if (temp_result == USB_STOR_TRANSPORT_FAILED &&
+		    (us->fflags & US_FL_SANE_SENSE) &&
+		    sense_size != US_SENSE_SIZE) {
+			US_DEBUGP("-- auto-sense failure, retry small sense\n");
+			sense_size = US_SENSE_SIZE;
+			goto Retry_Sense;
+		}
+
+		/* Other failures */
 		if (temp_result != USB_STOR_TRANSPORT_GOOD) {
 			US_DEBUGP("-- auto-sense failure\n");
 


