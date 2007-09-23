Return-Path: <linux-kernel-owner+w=401wt.eu-S1757617AbXIWPfD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757617AbXIWPfD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 11:35:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755100AbXIWPey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 11:34:54 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:55396 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753204AbXIWPex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 11:34:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:X-Enigmail-Version:OpenPGP:Content-Type:Content-Transfer-Encoding;
	b=CLd6ctqRQ3aoKTPEarMfMPK9uuj/T4seM4PfgZvuhab+O3LjwC+N6VFRKDILYfMkMwd4xX2472ZdS7NAOMBWChI82hJ264P9mKsdfBjfA9P7MPNGvu4I+n5/F6wJnCCw;
Message-ID: <46F6879A.8040408@simon.arlott.org.uk>
Date: Sun, 23 Sep 2007 16:34:50 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/3] cxacru: Reduce initialisation delay
References: <46F68708.6070409@simon.arlott.org.uk>
In-Reply-To: <46F68708.6070409@simon.arlott.org.uk>
X-Enigmail-Version: 0.95.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since card status updates appear to only occur every second, a delay
of 1000ms on startup may not be sufficient - change to 1500ms.

The long delay of 4000ms is likely to be related to the time required
for the ADSL line to come up - the driver should not need to do this.

Overall delay when loading firmware will change from 5000ms to 1500ms.

Signed-Off-By: Simon Arlott <simon@fire.lp0.eu>
---
 drivers/usb/atm/cxacru.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
index 8d8a107..35308a8 100644
--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -931,9 +931,10 @@ static void cxacru_upload_firmware(struct cxacru_data *instance,
 		usb_err(usbatm, "Passing control to firmware failed: %d\n", ret);
 		return;
 	}
+	usb_info(usbatm, "started firmware\n");
 
 	/* Delay to allow firmware to start up. */
-	msleep_interruptible(1000);
+	msleep(1500);
 
 	usb_clear_halt(usb_dev, usb_sndbulkpipe(usb_dev, CXACRU_EP_CMD));
 	usb_clear_halt(usb_dev, usb_rcvbulkpipe(usb_dev, CXACRU_EP_CMD));
@@ -947,7 +948,7 @@ static void cxacru_upload_firmware(struct cxacru_data *instance,
 	}
 
 	/* Load config data (le32), doing one packet at a time */
-	if (cf)
+	if (cf) {
 		for (off = 0; off < cf->size / 4; ) {
 			u32 buf[CMD_PACKET_SIZE / 4 - 1];
 			int i, len = min_t(int, cf->size / 4 - off, CMD_PACKET_SIZE / 4 / 2 - 1);
@@ -963,8 +964,8 @@ static void cxacru_upload_firmware(struct cxacru_data *instance,
 				return;
 			}
 		}
-
-	msleep_interruptible(4000);
+		usb_info(usbatm, "loaded config data\n");
+	}
 }
 
 static int cxacru_find_firmware(struct cxacru_data *instance,
-- 
1.5.0.1

-- 
Simon Arlott
