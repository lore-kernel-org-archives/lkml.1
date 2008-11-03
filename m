Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbYKCLQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbYKCLQU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 06:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755076AbYKCLQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 06:16:12 -0500
Received: from anchor-post-34.mail.demon.net ([194.217.242.92]:1767 "EHLO
	anchor-post-34.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754891AbYKCLQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 06:16:12 -0500
Subject: [PATCH 3/8] hfa384x_usb.c use newest version of 384x_drvr_start
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: gregkh <gregkh@suse.de>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1225710353.3113.5.camel@castor.localdomain>
References: <1225710353.3113.5.camel@castor.localdomain>
Content-Type: text/plain
Date: Mon, 03 Nov 2008 11:16:09 +0000
Message-Id: <1225710969.3113.19.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

include the needed fixes from Karl Relton
<karllinuxtest.relton@ntlworld.com>

see thread on linux-wlan-devel mailing list
"Possible cause of those pesky hfa384x_usbctlx_complete_sync errors"

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
---
 drivers/staging/wlan-ng/hfa384x_usb.c |   68 ++++++++++++++++++++++++++------
 1 files changed, 55 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
index 53c547d..4b1d24e 100644
--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -3140,19 +3140,38 @@ int hfa384x_drvr_setconfig(hfa384x_t *hw, UINT16 rid, void *buf, UINT16 len)
 * Call context:
 *	process
 ----------------------------------------------------------------*/
+
 int hfa384x_drvr_start(hfa384x_t *hw)
 {
-	int		result;
+	int		result, result1, result2;
+	u16		status;
 	DBFENTER;
 
 	might_sleep();
-
-	if (usb_clear_halt(hw->usb, hw->endp_in)) {
+    
+	/* Clear endpoint stalls - but only do this if the endpoint
+	 * is showing a stall status. Some prism2 cards seem to behave
+	 * badly if a clear_halt is called when the endpoint is already
+	 * ok
+	 */
+	result = usb_get_status(hw->usb, USB_RECIP_ENDPOINT, hw->endp_in, &status);
+	if (result < 0) {
+		WLAN_LOG_ERROR(
+			"Cannot get bulk in endpoint status.\n");
+		goto done;
+	}
+	if ((status == 1) && usb_clear_halt(hw->usb, hw->endp_in)) {
 		WLAN_LOG_ERROR(
 			"Failed to reset bulk in endpoint.\n");
 	}
 
-	if (usb_clear_halt(hw->usb, hw->endp_out)) {
+	result = usb_get_status(hw->usb, USB_RECIP_ENDPOINT, hw->endp_out, &status);
+	if (result < 0) {
+		WLAN_LOG_ERROR(
+			"Cannot get bulk out endpoint status.\n");
+		goto done;
+	}
+	if ((status == 1) && usb_clear_halt(hw->usb, hw->endp_out)) {
 		WLAN_LOG_ERROR(
 			"Failed to reset bulk out endpoint.\n");
 	}
@@ -3169,18 +3188,41 @@ int hfa384x_drvr_start(hfa384x_t *hw)
 		goto done;
 	}
 
-	/* call initialize */
-	result = hfa384x_cmd_initialize(hw);
-	if (result != 0) {
-		usb_kill_urb(&hw->rx_urb);
-		WLAN_LOG_ERROR(
-			"cmd_initialize() failed, result=%d\n",
-			result);
-		goto done;
+	/* Call initialize twice, with a 1 second sleep in between.
+	 * This is a nasty work-around since many prism2 cards seem to
+	 * need time to settle after an init from cold. The second
+	 * call to initialize in theory is not necessary - but we call
+	 * it anyway as a double insurance policy:
+	 * 1) If the first init should fail, the second may well succeed
+	 *    and the card can still be used
+	 * 2) It helps ensures all is well with the card after the first
+	 *    init and settle time.
+	 */
+	result1 = hfa384x_cmd_initialize(hw);
+	msleep(1000);
+	result = result2 = hfa384x_cmd_initialize(hw);
+	if (result1 != 0) {
+		if (result2 != 0) {
+			WLAN_LOG_ERROR(
+				"cmd_initialize() failed on two attempts, results %d and %d\n",
+				result1, result2);
+			usb_kill_urb(&hw->rx_urb);
+			goto done;
+		} else {
+			WLAN_LOG_DEBUG(0, "First cmd_initialize() failed (result %d),\n",
+				result1);
+			WLAN_LOG_DEBUG(0, "but second attempt succeeded. All should be ok\n");
+		}
+	} else if (result2 != 0) {
+		WLAN_LOG_WARNING(
+			"First cmd_initialize() succeeded, but second attempt failed (result=%d)\n",
+			result2);
+		WLAN_LOG_WARNING("Most likely the card will be functional\n");
+			goto done;
 	}
 
 	hw->state = HFA384x_STATE_RUNNING;
-
+	
 done:
 	DBFEXIT;
 	return result;
-- 
1.5.6.5



