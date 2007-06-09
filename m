Return-Path: <linux-kernel-owner+w=401wt.eu-S1032566AbXFIAGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032566AbXFIAGZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 20:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966336AbXFIAEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 20:04:43 -0400
Received: from mail.suse.de ([195.135.220.2]:33753 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S969555AbXFIAEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 20:04:41 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-usb-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Simon Arlott <simon@fire.lp0.eu>,
       Duncan Sands <duncan.sands@math.u-psud.fr>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 7/9] USB: cxacru: ignore error trying to start ADSL in atm_start
Date: Fri,  8 Jun 2007 17:03:52 -0700
Message-Id: <11813474852263-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.1
In-Reply-To: <11813474771075-git-send-email-gregkh@suse.de>
References: <20070609000312.GA17574@kroah.com>
 <11813474343815-git-send-email-gregkh@suse.de>
 <1181347441440-git-send-email-gregkh@suse.de>
 <11813474492376-git-send-email-gregkh@suse.de>
 <118134746039-git-send-email-gregkh@suse.de>
 <11813474672336-git-send-email-gregkh@suse.de>
 <11813474771075-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Simon Arlott <simon@fire.lp0.eu>

The sysfs adsl_status attribute ignores (aside from returning -EIO to the
user) any error sending a START/STOP command to the device and there is at
least one firmware which never sends a response but appears to work
regardless.  Therefore atm_start should also continue if an error is received
so that such firmware is usable.

The official Conexant driver doesn't expect a reply either but this is for
another device (E2 router) and a commonly used firmware does respond.

Also, there is no point in changing -ECONNRESET to -ETIMEDOUT since nothing
ever checks for either of these values.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
Cc: Duncan Sands <duncan.sands@math.u-psud.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/atm/cxacru.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
index 68cf582..8bcf7fe 100644
--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -476,8 +476,6 @@ static int cxacru_start_wait_urb(struct urb *urb, struct completion *done,
 	add_timer(&timer);
 	wait_for_completion(done);
 	status = urb->status;
-	if (status == -ECONNRESET)
-		status = -ETIMEDOUT;
 	del_timer_sync(&timer);
 
 	if (actual_length)
@@ -671,11 +669,8 @@ static int cxacru_atm_start(struct usbatm_data *usbatm_instance,
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
1.5.2.1

