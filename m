Return-Path: <linux-kernel-owner+w=401wt.eu-S1754275AbZJMEzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275AbZJMEzt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 00:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbZJMEzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 00:55:48 -0400
Received: from gate.crashing.org ([63.228.1.57]:43219 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753244AbZJMEzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 00:55:47 -0400
Subject: Re: USB serial regression 2.6.31.1 -> 2.6.31.2 [PATCH]
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ben Efros <ben@pc-doctor.com>, Josua Dietze <digidietze@draisberghof.de>,
       fangxiaozhi <huananhu@huawei.com>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, Hugh Blemings <hugh@blemings.org>
In-Reply-To: <Pine.LNX.4.44L0.0910121052550.11420-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.0910121052550.11420-100000@netrider.rowland.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Oct 2009 15:53:47 +1100
Message-Id: <1255409627.2192.172.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---

This should also be applied to 2.6.31 stable

diff -urN linux-source-2.6.31-11-benh/drivers/usb/storage/transport.c linux-source-2.6.31-12-benh/drivers/usb/storage/transport.c
--- linux-source-2.6.31-11-benh/drivers/usb/storage/transport.c	2009-09-10 08:13:59.000000000 +1000
+++ linux-source-2.6.31-12-benh/drivers/usb/storage/transport.c	2009-10-13 15:44:57.117722653 +1100
@@ -696,7 +696,7 @@
 		/* device supports and needs bigger sense buffer */
 		if (us->fflags & US_FL_SANE_SENSE)
 			sense_size = ~0;
-
+Retry_Sense:
 		US_DEBUGP("Issuing auto-REQUEST_SENSE\n");
 
 		scsi_eh_prep_cmnd(srb, &ses, NULL, 0, sense_size);
@@ -720,6 +720,21 @@
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
 


