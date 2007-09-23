Return-Path: <linux-kernel-owner+w=401wt.eu-S1756812AbXIWPck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812AbXIWPck (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 11:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754451AbXIWPcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 11:32:31 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:53991 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754471AbXIWPca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 11:32:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:X-Enigmail-Version:OpenPGP:Content-Type:Content-Transfer-Encoding;
	b=X0Rv9sVJKWqEo1MH3oQgHWLSzxVgfBEf5axA7rYnc9Ez4V5N2CCqhS469/ntNjOY2qEMZs19s2u4NqAyZ4qKRVLZtvWufoBfx5O8C7VPbLP+tXq87XTGcD33GxIRUYM8;
Message-ID: <46F68708.6070409@simon.arlott.org.uk>
Date: Sun, 23 Sep 2007 16:32:24 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/2] cxacru: Use appropriate logging for errors
X-Enigmail-Version: 0.95.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When an error occurs, existing logging uses dbg() so the cause of a 
problem is hard to determine. Error conditions shouldn't only be 
properly reported with debugging enabled.

A side effect of this change is that when an uninitialised device 
is started, a log message similar to the following is sent:
	cxacru 5-2:1.0: receive of cm 0x90 failed (-104)
This is normal - the device did not respond so firmware will be 
loaded.

Signed-Off-By: Simon Arlott <simon@fire.lp0.eu>
---
This could be added to 2.6.23 since it only makes error logging 
more verbose.

 drivers/usb/atm/cxacru.c |   29 ++++++++++++++++++-----------
 1 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
index a73e714..8d8a107 100644
--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -482,7 +482,8 @@ static int cxacru_cm(struct cxacru_data *instance, enum cxacru_cm_request cm,
 	int rbuflen = ((rsize - 1) / stride + 1) * CMD_PACKET_SIZE;
 
 	if (wbuflen > PAGE_SIZE || rbuflen > PAGE_SIZE) {
-		dbg("too big transfer requested");
+		usb_err(instance->usbatm, "requested transfer size too large (%d, %d)\n",
+			wbuflen, rbuflen);
 		ret = -ENOMEM;
 		goto fail;
 	}
@@ -493,7 +494,8 @@ static int cxacru_cm(struct cxacru_data *instance, enum cxacru_cm_request cm,
 	init_completion(&instance->rcv_done);
 	ret = usb_submit_urb(instance->rcv_urb, GFP_KERNEL);
 	if (ret < 0) {
-		dbg("submitting read urb for cm %#x failed", cm);
+		usb_err(instance->usbatm, "submit of read urb for cm %#x failed (%d)\n",
+			cm, ret);
 		ret = ret;
 		goto fail;
 	}
@@ -510,27 +512,28 @@ static int cxacru_cm(struct cxacru_data *instance, enum cxacru_cm_request cm,
 	init_completion(&instance->snd_done);
 	ret = usb_submit_urb(instance->snd_urb, GFP_KERNEL);
 	if (ret < 0) {
-		dbg("submitting write urb for cm %#x failed", cm);
+		usb_err(instance->usbatm, "submit of write urb for cm %#x failed (%d)\n",
+			cm, ret);
 		ret = ret;
 		goto fail;
 	}
 
 	ret = cxacru_start_wait_urb(instance->snd_urb, &instance->snd_done, NULL);
 	if (ret < 0) {
-		dbg("sending cm %#x failed", cm);
+		usb_err(instance->usbatm, "send of cm %#x failed (%d)\n", cm, ret);
 		ret = ret;
 		goto fail;
 	}
 
 	ret = cxacru_start_wait_urb(instance->rcv_urb, &instance->rcv_done, &actlen);
 	if (ret < 0) {
-		dbg("receiving cm %#x failed", cm);
+		usb_err(instance->usbatm, "receive of cm %#x failed (%d)\n", cm, ret);
 		ret = ret;
 		goto fail;
 	}
 	if (actlen % CMD_PACKET_SIZE || !actlen) {
-		dbg("response is not a positive multiple of %d: %#x",
-				CMD_PACKET_SIZE, actlen);
+		usb_err(instance->usbatm, "invalid response length to cm %#x: %d\n",
+			cm, actlen);
 		ret = -EIO;
 		goto fail;
 	}
@@ -538,12 +541,14 @@ static int cxacru_cm(struct cxacru_data *instance, enum cxacru_cm_request cm,
 	/* check the return status and copy the data to the output buffer, if needed */
 	for (offb = offd = 0; offd < rsize && offb < actlen; offb += CMD_PACKET_SIZE) {
 		if (rbuf[offb] != cm) {
-			dbg("wrong cm %#x in response", rbuf[offb]);
+			usb_err(instance->usbatm, "wrong cm %#x in response to cm %#x\n",
+				rbuf[offb], cm);
 			ret = -EIO;
 			goto fail;
 		}
 		if (rbuf[offb + 1] != CM_STATUS_SUCCESS) {
-			dbg("response failed: %#x", rbuf[offb + 1]);
+			usb_err(instance->usbatm, "response to cm %#x failed: %#x\n",
+				cm, rbuf[offb + 1]);
 			ret = -EIO;
 			goto fail;
 		}
@@ -582,14 +587,16 @@ static int cxacru_cm_get_array(struct cxacru_data *instance, enum cxacru_cm_requ
 	for (offb = 0; offb < len; ) {
 		int l = le32_to_cpu(buf[offb++]);
 		if (l > stride || l > (len - offb) / 2) {
-			dbg("wrong data length %#x in response", l);
+			usb_err(instance->usbatm, "invalid data length from cm %#x: %d\n",
+				cm, l);
 			ret = -EIO;
 			goto cleanup;
 		}
 		while (l--) {
 			offd = le32_to_cpu(buf[offb++]);
 			if (offd >= size) {
-				dbg("wrong index %#x in response", offd);
+				usb_err(instance->usbatm, "wrong index #%x in response to cm #%x\n",
+					offd, cm);
 				ret = -EIO;
 				goto cleanup;
 			}
-- 
1.5.0.1

-- 
Simon Arlott
