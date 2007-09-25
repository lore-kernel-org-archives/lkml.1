Return-Path: <linux-kernel-owner+w=401wt.eu-S1754852AbXIYTU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbXIYTU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 15:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbXIYTUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 15:20:18 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:34678 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647AbXIYTUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 15:20:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:X-Enigmail-Version:OpenPGP:Content-Type:Content-Transfer-Encoding;
	b=cE1ztmEQnpX48C/uo/Q2aR1DWiu5f0Syt2rxYIL8NTzQK7/iWnIgms1SRGjSFPDehwl7SXWd70ehEZtcnxvPjxmbvZL+pNefAyeyFVzOrHEgoVxYpiLZvFxp0+0eeYcv;
Message-ID: <46F95F6A.7020006@simon.arlott.org.uk>
Date: Tue, 25 Sep 2007 20:20:10 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Duncan Sands <duncan.sands@math.u-psud.fr>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] cxacru: Use appropriate logging for errors
References: <46F68708.6070409@simon.arlott.org.uk> <46F687E8.3010101@simon.arlott.org.uk> <200709231820.33086.duncan.sands@math.u-psud.fr> <46F6B215.3050500@simon.arlott.org.uk> <20070924183247.GA13796@suse.de>
In-Reply-To: <20070924183247.GA13796@suse.de>
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

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
Acked-by: Duncan Sands <baldrick@free.fr>
---
On 24/09/07 19:32, Greg KH wrote:
> On Sun, Sep 23, 2007 at 07:36:05PM +0100, Simon Arlott wrote:
>> I'm only going to create a merge conflict with myself with this :|
>> It'll be included with 1/3 shortly.
> 
> Ok, I'm totally confused :)
> 
> Can you resend the patches you want to have included here, that are
> acked by both you and Duncan?
> 
> thanks,
> 
> greg k-h

 drivers/usb/atm/cxacru.c |   43 ++++++++++++++++++++++++++++---------------
 1 files changed, 28 insertions(+), 15 deletions(-)

diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
index 1e5ee88..50249a5 100644
--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -482,7 +482,9 @@ static int cxacru_cm(struct cxacru_data *instance, enum cxacru_cm_request cm,
 	int rbuflen = ((rsize - 1) / stride + 1) * CMD_PACKET_SIZE;
 
 	if (wbuflen > PAGE_SIZE || rbuflen > PAGE_SIZE) {
-		dbg("too big transfer requested");
+		if (printk_ratelimit())
+			usb_err(instance->usbatm, "requested transfer size too large (%d, %d)\n",
+				wbuflen, rbuflen);
 		ret = -ENOMEM;
 		goto fail;
 	}
@@ -493,8 +495,9 @@ static int cxacru_cm(struct cxacru_data *instance, enum cxacru_cm_request cm,
 	init_completion(&instance->rcv_done);
 	ret = usb_submit_urb(instance->rcv_urb, GFP_KERNEL);
 	if (ret < 0) {
-		dbg("submitting read urb for cm %#x failed", cm);
-		ret = ret;
+		if (printk_ratelimit())
+			usb_err(instance->usbatm, "submit of read urb for cm %#x failed (%d)\n",
+				cm, ret);
 		goto fail;
 	}
 
@@ -510,27 +513,29 @@ static int cxacru_cm(struct cxacru_data *instance, enum cxacru_cm_request cm,
 	init_completion(&instance->snd_done);
 	ret = usb_submit_urb(instance->snd_urb, GFP_KERNEL);
 	if (ret < 0) {
-		dbg("submitting write urb for cm %#x failed", cm);
-		ret = ret;
+		if (printk_ratelimit())
+			usb_err(instance->usbatm, "submit of write urb for cm %#x failed (%d)\n",
+				cm, ret);
 		goto fail;
 	}
 
 	ret = cxacru_start_wait_urb(instance->snd_urb, &instance->snd_done, NULL);
 	if (ret < 0) {
-		dbg("sending cm %#x failed", cm);
-		ret = ret;
+		if (printk_ratelimit())
+			usb_err(instance->usbatm, "send of cm %#x failed (%d)\n", cm, ret);
 		goto fail;
 	}
 
 	ret = cxacru_start_wait_urb(instance->rcv_urb, &instance->rcv_done, &actlen);
 	if (ret < 0) {
-		dbg("receiving cm %#x failed", cm);
-		ret = ret;
+		if (printk_ratelimit())
+			usb_err(instance->usbatm, "receive of cm %#x failed (%d)\n", cm, ret);
 		goto fail;
 	}
 	if (actlen % CMD_PACKET_SIZE || !actlen) {
-		dbg("response is not a positive multiple of %d: %#x",
-				CMD_PACKET_SIZE, actlen);
+		if (printk_ratelimit())
+			usb_err(instance->usbatm, "invalid response length to cm %#x: %d\n",
+				cm, actlen);
 		ret = -EIO;
 		goto fail;
 	}
@@ -538,12 +543,16 @@ static int cxacru_cm(struct cxacru_data *instance, enum cxacru_cm_request cm,
 	/* check the return status and copy the data to the output buffer, if needed */
 	for (offb = offd = 0; offd < rsize && offb < actlen; offb += CMD_PACKET_SIZE) {
 		if (rbuf[offb] != cm) {
-			dbg("wrong cm %#x in response", rbuf[offb]);
+			if (printk_ratelimit())
+				usb_err(instance->usbatm, "wrong cm %#x in response to cm %#x\n",
+					rbuf[offb], cm);
 			ret = -EIO;
 			goto fail;
 		}
 		if (rbuf[offb + 1] != CM_STATUS_SUCCESS) {
-			dbg("response failed: %#x", rbuf[offb + 1]);
+			if (printk_ratelimit())
+				usb_err(instance->usbatm, "response to cm %#x failed: %#x\n",
+					cm, rbuf[offb + 1]);
 			ret = -EIO;
 			goto fail;
 		}
@@ -582,14 +591,18 @@ static int cxacru_cm_get_array(struct cxacru_data *instance, enum cxacru_cm_requ
 	for (offb = 0; offb < len; ) {
 		int l = le32_to_cpu(buf[offb++]);
 		if (l > stride || l > (len - offb) / 2) {
-			dbg("wrong data length %#x in response", l);
+			if (printk_ratelimit())
+				usb_err(instance->usbatm, "invalid data length from cm %#x: %d\n",
+					cm, l);
 			ret = -EIO;
 			goto cleanup;
 		}
 		while (l--) {
 			offd = le32_to_cpu(buf[offb++]);
 			if (offd >= size) {
-				dbg("wrong index %#x in response", offd);
+				if (printk_ratelimit())
+					usb_err(instance->usbatm, "wrong index #%x in response to cm #%x\n",
+						offd, cm);
 				ret = -EIO;
 				goto cleanup;
 			}
-- 
1.5.0.1

-- 
Simon Arlott
