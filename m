Return-Path: <linux-kernel-owner+w=401wt.eu-S936345AbZLQEQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936345AbZLQEQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:16:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936167AbZLQEQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:16:42 -0500
Received: from kroah.org ([198.145.64.141]:55954 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936166AbZLQEFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:05:36 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:59 2009
Message-Id: <20091217035659.186337280@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:57:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Len Brown <len.brown@intel.com>
Subject: [125/151] thinkpad-acpi: preserve rfkill state across suspend/resume
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

commit 208b996b6c460285650d39b2330f8ef82c007d10 upstream.

Since the rfkill rework in 2.6.31, the driver is always resuming with
the radios disabled.

Change thinkpad-acpi to ask the firmware to resume with the radios in
the last state.  This fixes the Bluetooth and WWAN rfkill switches.

Note that it means we respect the firmware's oddities.  Should the
user toggle the hardware rfkill switch on and off, it might cause the
radios to resume enabled.

UWB is an unknown quantity since it has nowhere the same level of
firmware support (no control over state storage in NVRAM, for
example), and might need further fixing.  Testers welcome.

This change fixes a regression from 2.6.30.

Reported-by: Jerone Young <jerone.young@canonical.com>
Reported-by: Ian Molton <ian.molton@collabora.co.uk>
Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Tested-by: Ian Molton <ian.molton@collabora.co.uk>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/thinkpad_acpi.c |   32 +++++---------------------------
 1 file changed, 5 insertions(+), 27 deletions(-)

--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -3866,15 +3866,6 @@ enum {
 
 #define TPACPI_RFK_BLUETOOTH_SW_NAME	"tpacpi_bluetooth_sw"
 
-static void bluetooth_suspend(pm_message_t state)
-{
-	/* Try to make sure radio will resume powered off */
-	if (!acpi_evalf(NULL, NULL, "\\BLTH", "vd",
-		   TP_ACPI_BLTH_PWR_OFF_ON_RESUME))
-		vdbg_printk(TPACPI_DBG_RFKILL,
-			"bluetooth power down on resume request failed\n");
-}
-
 static int bluetooth_get_status(void)
 {
 	int status;
@@ -3908,10 +3899,9 @@ static int bluetooth_set_status(enum tpa
 #endif
 
 	/* We make sure to keep TP_ACPI_BLUETOOTH_RESUMECTRL off */
+	status = TP_ACPI_BLUETOOTH_RESUMECTRL;
 	if (state == TPACPI_RFK_RADIO_ON)
-		status = TP_ACPI_BLUETOOTH_RADIOSSW;
-	else
-		status = 0;
+		status |= TP_ACPI_BLUETOOTH_RADIOSSW;
 
 	if (!acpi_evalf(hkey_handle, NULL, "SBDC", "vd", status))
 		return -EIO;
@@ -4050,7 +4040,6 @@ static struct ibm_struct bluetooth_drive
 	.read = bluetooth_read,
 	.write = bluetooth_write,
 	.exit = bluetooth_exit,
-	.suspend = bluetooth_suspend,
 	.shutdown = bluetooth_shutdown,
 };
 
@@ -4068,15 +4057,6 @@ enum {
 
 #define TPACPI_RFK_WWAN_SW_NAME		"tpacpi_wwan_sw"
 
-static void wan_suspend(pm_message_t state)
-{
-	/* Try to make sure radio will resume powered off */
-	if (!acpi_evalf(NULL, NULL, "\\WGSV", "qvd",
-		   TP_ACPI_WGSV_PWR_OFF_ON_RESUME))
-		vdbg_printk(TPACPI_DBG_RFKILL,
-			"WWAN power down on resume request failed\n");
-}
-
 static int wan_get_status(void)
 {
 	int status;
@@ -4109,11 +4089,10 @@ static int wan_set_status(enum tpacpi_rf
 	}
 #endif
 
-	/* We make sure to keep TP_ACPI_WANCARD_RESUMECTRL off */
+	/* We make sure to set TP_ACPI_WANCARD_RESUMECTRL */
+	status = TP_ACPI_WANCARD_RESUMECTRL;
 	if (state == TPACPI_RFK_RADIO_ON)
-		status = TP_ACPI_WANCARD_RADIOSSW;
-	else
-		status = 0;
+		status |= TP_ACPI_WANCARD_RADIOSSW;
 
 	if (!acpi_evalf(hkey_handle, NULL, "SWAN", "vd", status))
 		return -EIO;
@@ -4251,7 +4230,6 @@ static struct ibm_struct wan_driver_data
 	.read = wan_read,
 	.write = wan_write,
 	.exit = wan_exit,
-	.suspend = wan_suspend,
 	.shutdown = wan_shutdown,
 };
 


