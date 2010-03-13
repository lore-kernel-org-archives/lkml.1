Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935078Ab0CMAV1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:21:27 -0500
Received: from kroah.org ([198.145.64.141]:60974 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934997Ab0CMAUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:20:46 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:12 2010
Message-Id: <20100313001512.583298811@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:13:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: [patch 085/123] thinkpad-acpi: fix bluetooth/wwan resume
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

commit 08fedfc903c78e380b0baa7b57c52d367794d0a5 upstream.

Studying the DSDTs of various thinkpads, it looks like bit 3 of the
argument to SBDC and SWAN is not "set radio to last state on resume".
Rather, it seems to be "if this bit is set, enable radio on resume,
otherwise disable it on resume".

So, the proper way to prepare the radios for S3 suspend is: disable
radio and clear bit 3 on the SBDC/SWAN call to to resume with radio
disabled, and enable radio and set bit 3 on the SBDC/SWAN call to
resume with the radio enabled.

Also, for persistent devices, the rfkill core does not restore state,
so we really need to get the firmware to do the right thing.

We don't sync the radio state on suspend, instead we trust the BIOS to
not do anything weird if we never touched the radio state since boot.
Time will tell if that's a wise way of doing things...

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/thinkpad_acpi.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -3878,7 +3878,7 @@ enum {
 	TP_ACPI_BLUETOOTH_HWPRESENT	= 0x01,	/* Bluetooth hw available */
 	TP_ACPI_BLUETOOTH_RADIOSSW	= 0x02,	/* Bluetooth radio enabled */
 	TP_ACPI_BLUETOOTH_RESUMECTRL	= 0x04,	/* Bluetooth state at resume:
-						   off / last state */
+						   0 = disable, 1 = enable */
 };
 
 enum {
@@ -3924,10 +3924,11 @@ static int bluetooth_set_status(enum tpa
 	}
 #endif
 
-	/* We make sure to keep TP_ACPI_BLUETOOTH_RESUMECTRL off */
-	status = TP_ACPI_BLUETOOTH_RESUMECTRL;
 	if (state == TPACPI_RFK_RADIO_ON)
-		status |= TP_ACPI_BLUETOOTH_RADIOSSW;
+		status = TP_ACPI_BLUETOOTH_RADIOSSW
+			  | TP_ACPI_BLUETOOTH_RESUMECTRL;
+	else
+		status = 0;
 
 	if (!acpi_evalf(hkey_handle, NULL, "SBDC", "vd", status))
 		return -EIO;
@@ -4078,7 +4079,7 @@ enum {
 	TP_ACPI_WANCARD_HWPRESENT	= 0x01,	/* Wan hw available */
 	TP_ACPI_WANCARD_RADIOSSW	= 0x02,	/* Wan radio enabled */
 	TP_ACPI_WANCARD_RESUMECTRL	= 0x04,	/* Wan state at resume:
-						   off / last state */
+						   0 = disable, 1 = enable */
 };
 
 #define TPACPI_RFK_WWAN_SW_NAME		"tpacpi_wwan_sw"
@@ -4115,10 +4116,11 @@ static int wan_set_status(enum tpacpi_rf
 	}
 #endif
 
-	/* We make sure to set TP_ACPI_WANCARD_RESUMECTRL */
-	status = TP_ACPI_WANCARD_RESUMECTRL;
 	if (state == TPACPI_RFK_RADIO_ON)
-		status |= TP_ACPI_WANCARD_RADIOSSW;
+		status = TP_ACPI_WANCARD_RADIOSSW
+			 | TP_ACPI_WANCARD_RESUMECTRL;
+	else
+		status = 0;
 
 	if (!acpi_evalf(hkey_handle, NULL, "SWAN", "vd", status))
 		return -EIO;


