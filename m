Return-Path: <linux-kernel-owner+w=401wt.eu-S1751674AbXDOASn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674AbXDOASn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 20:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbXDOASn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 20:18:43 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:39890 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674AbXDOASm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 20:18:42 -0400
Message-ID: <46216F5F.7070009@simon.arlott.org.uk>
Date: Sun, 15 Apr 2007 01:18:39 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] usbatm: Detect usb device shutdown and ignore failed urbs.
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Detect usb device shutdown and ignore failed urbs.
This happens when the driver is unloaded or the device is unplugged.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
Cc: Duncan Sands <duncan.sands@math.u-psud.fr>
---
I'm not sure what other urb statuses should be ignored,
and the warning message doesn't need to be shown when
the module is unloaded or the device is removed.

 drivers/usb/atm/usbatm.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/atm/usbatm.c b/drivers/usb/atm/usbatm.c
index d0f1976..6b31175 100644
--- a/drivers/usb/atm/usbatm.c
+++ b/drivers/usb/atm/usbatm.c
@@ -274,6 +274,9 @@ static void usbatm_complete(struct urb *urb)
 			(!(channel->usbatm->flags & UDSL_IGNORE_EILSEQ) ||
 			 urb->status != -EILSEQ ))
 	{
+		if (urb->status == -ESHUTDOWN)
+			return;
+
 		if (printk_ratelimit())
 			atm_warn(channel->usbatm, "%s: urb 0x%p failed (%d)!\n",
 				__func__, urb, urb->status);
-- 
1.5.0.1

-- 
Simon Arlott
