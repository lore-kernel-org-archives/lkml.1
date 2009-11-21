Return-Path: <linux-kernel-owner+w=401wt.eu-S1756516AbZKUP0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516AbZKUP0A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 10:26:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756479AbZKUPZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 10:25:59 -0500
Received: from proxima.lp0.eu ([81.2.80.65]:39194 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647AbZKUPRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 10:17:25 -0500
Message-ID: <4B080378.20903@simon.arlott.org.uk>
Date: Sat, 21 Nov 2009 15:12:56 +0000
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.23 (X11/20090927)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 5/8] cxacru: firmware writes on OHCI are slow, log progress
References: <4B08013B.90403@simon.arlott.org.uk>
In-Reply-To: <4B08013B.90403@simon.arlott.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Firmware writing takes 256ms per 4KB with OHCI, which
is very slow compared to 7ms per 4KB with UHCI.

Until I have access to a hardware USB analyser it may
not be possible to determine why this happens.

Instead of appearing to do nothing, log progress when
writing firmware and then log the ATM device information
when finished. Remove an unnecessary 4 second delay.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 drivers/usb/atm/cxacru.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
index 41568b1..c6ec10e 100644
--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -724,6 +724,9 @@ static int cxacru_atm_start(struct usbatm_data *usbatm_instance,
 	mutex_unlock(&instance->poll_state_serialize);
 	mutex_unlock(&instance->adsl_state_serialize);
 
+	printk(KERN_INFO "%s%d: %s %pM\n", atm_dev->type, atm_dev->number,
+			usbatm_instance->description, atm_dev->esi);
+
 	if (start_polling)
 		cxacru_poll_status(&instance->poll_work.work);
 	return 0;
@@ -938,6 +941,7 @@ static void cxacru_upload_firmware(struct cxacru_data *instance,
 	}
 
 	/* Firmware */
+	usb_info(usbatm, "loading firmware\n");
 	ret = cxacru_fw(usb_dev, FW_WRITE_MEM, 0x2, 0x0, FW_ADDR, fw->data, fw->size);
 	if (ret) {
 		usb_err(usbatm, "Firmware upload failed: %d\n", ret);
@@ -946,6 +950,7 @@ static void cxacru_upload_firmware(struct cxacru_data *instance,
 
 	/* Boot ROM patch */
 	if (instance->modem_type->boot_rom_patch) {
+		usb_info(usbatm, "loading boot ROM patch\n");
 		ret = cxacru_fw(usb_dev, FW_WRITE_MEM, 0x2, 0x0, BR_ADDR, bp->data, bp->size);
 		if (ret) {
 			usb_err(usbatm, "Boot ROM patching failed: %d\n", ret);
@@ -960,6 +965,7 @@ static void cxacru_upload_firmware(struct cxacru_data *instance,
 		return;
 	}
 
+	usb_info(usbatm, "starting device\n");
 	if (instance->modem_type->boot_rom_patch) {
 		val = cpu_to_le32(BR_ADDR);
 		ret = cxacru_fw(usb_dev, FW_WRITE_MEM, 0x2, 0x0, BR_STACK_ADDR, (u8 *) &val, 4);
@@ -1003,8 +1009,6 @@ static void cxacru_upload_firmware(struct cxacru_data *instance,
 				return;
 			}
 		}
-
-	msleep_interruptible(4000);
 }
 
 static int cxacru_find_firmware(struct cxacru_data *instance,
-- 
1.6.3.3

-- 
Simon Arlott

