Return-Path: <linux-kernel-owner+w=401wt.eu-S1758168AbZJPRZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168AbZJPRZX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 13:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754124AbZJPRS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 13:18:27 -0400
Received: from kroah.org ([198.145.64.141]:48503 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753789AbZJPRSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 13:18:25 -0400
X-Mailbox-Line: From linux@linux.site Fri Oct 16 10:11:56 2009
Message-Id: <20091016171155.847930984@linux.site>
User-Agent: quilt/0.47-14.9
Date: Fri, 16 Oct 2009 10:10:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [18/46] USB: storage: When a device returns no sense data, call it a Hardware Error
References: <20091016170953.128828149@linux.site>
Content-Disposition: inline; filename=usb-storage-when-a-device-returns-no-sense-data-call-it-a-hardware-error.patch
In-Reply-To: <20091016171422.GA13339@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alan Stern <stern@rowland.harvard.edu>

commit f1a0743bc0e7a30c032b1eb78f6a2b0f805b4597 upstream.

This patch (as1294) fixes a problem that has plagued users for several
kernel releases.  Some USB mass-storage devices don't return any sense
data when they encounter certain kinds of errors.  The SCSI layer
interprets this to mean that the operation should be retried, and the
same thing happens -- over and over again with no limit.  In some
circumstances (such as when a bus reset occurs) that is the right
thing to do, but not here.

The patch checks for this condition (a transport failure with no sense
data) and changes the result code to DID_ERROR and the sense code to
Hardware Error.  This does get only a limited number of retries, and
so the command will fail relatively quickly instead of getting stuck
in an infinite loop.

This fixes a large part of Bugzilla #14118.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Mantas Mikulenas <grawity@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/transport.c |   29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

--- a/drivers/usb/storage/transport.c
+++ b/drivers/usb/storage/transport.c
@@ -768,17 +768,32 @@ void usb_stor_invoke_transport(struct sc
 		/* set the result so the higher layers expect this data */
 		srb->result = SAM_STAT_CHECK_CONDITION;
 
-		/* If things are really okay, then let's show that.  Zero
-		 * out the sense buffer so the higher layers won't realize
-		 * we did an unsolicited auto-sense. */
-		if (result == USB_STOR_TRANSPORT_GOOD &&
-			/* Filemark 0, ignore EOM, ILI 0, no sense */
+		/* We often get empty sense data.  This could indicate that
+		 * everything worked or that there was an unspecified
+		 * problem.  We have to decide which.
+		 */
+		if (	/* Filemark 0, ignore EOM, ILI 0, no sense */
 				(srb->sense_buffer[2] & 0xaf) == 0 &&
 			/* No ASC or ASCQ */
 				srb->sense_buffer[12] == 0 &&
 				srb->sense_buffer[13] == 0) {
-			srb->result = SAM_STAT_GOOD;
-			srb->sense_buffer[0] = 0x0;
+
+			/* If things are really okay, then let's show that.
+			 * Zero out the sense buffer so the higher layers
+			 * won't realize we did an unsolicited auto-sense.
+			 */
+			if (result == USB_STOR_TRANSPORT_GOOD) {
+				srb->result = SAM_STAT_GOOD;
+				srb->sense_buffer[0] = 0x0;
+
+			/* If there was a problem, report an unspecified
+			 * hardware error to prevent the higher layers from
+			 * entering an infinite retry loop.
+			 */
+			} else {
+				srb->result = DID_ERROR << 16;
+				srb->sense_buffer[2] = HARDWARE_ERROR;
+			}
 		}
 	}
 


