Return-Path: <linux-kernel-owner+w=401wt.eu-S1031428AbXEDRDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031428AbXEDRDy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 13:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031432AbXEDRDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 13:03:54 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:43691 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031428AbXEDRDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 13:03:52 -0400
Message-ID: <463B6774.5000003@simon.arlott.org.uk>
Date: Fri, 04 May 2007 18:03:48 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Duncan Sands <duncan.sands@math.u-psud.fr>,
       Andrew Morton <akpm@linux-foundation.org>,
       Krzysztof Lichota <krzysiek@lichota.net>
Subject: [PATCH 2/2] cxacru: Ignore error trying to start ADSL in atm_start
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The sysfs adsl_status attribute ignores (aside from returning -EIO to the 
user) any error sending a START/STOP command to the device and there is 
at least one firmware which never sends a response but appears to work 
regardless. Therefore atm_start should also continue if an error is 
received so that such firmware is usable.

The official Conexant driver doesn't expect a reply either but this is 
for another device (E2 router) and a commonly used firmware does respond.

Also, there is no point in changing -ECONNRESET to -ETIMEDOUT since 
nothing ever checks for either of these values.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
Cc: Duncan Sands <duncan.sands@math.u-psud.fr>
---
 drivers/usb/atm/cxacru.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
index 4ecb4c7..32f85a6 100644
--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -465,8 +465,6 @@ static int cxacru_start_wait_urb(struct urb *urb, struct completion *done,
 	add_timer(&timer);
 	wait_for_completion(done);
 	status = urb->status;
-	if (status == -ECONNRESET)
-		status = -ETIMEDOUT;
 	del_timer_sync(&timer);
 
 	if (actual_length)
@@ -660,11 +658,8 @@ static int cxacru_atm_start(struct usbatm_data *usbatm_instance,
 	/* start ADSL */
 	mutex_lock(&instance->adsl_state_serialize);
 	ret = cxacru_cm(instance, CM_REQUEST_CHIP_ADSL_LINE_START, NULL, 0, NULL, 0);
-	if (ret < 0) {
+	if (ret < 0)
 		atm_err(usbatm_instance, "cxacru_atm_start: CHIP_ADSL_LINE_START returned %d\n", ret);
-		mutex_unlock(&instance->adsl_state_serialize);
-		return ret;
-	}
 
 	/* Start status polling */
 	mutex_lock(&instance->poll_state_serialize);
-- 
1.5.0.1

-- 
Simon Arlott
