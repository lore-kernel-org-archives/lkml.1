Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936374Ab0CMBSX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:18:23 -0500
Received: from kroah.org ([198.145.64.141]:60974 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934985Ab0CMAUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:20:43 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:12 2010
Message-Id: <20100313001512.236109836@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:12:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: [patch 081/123] thinkpad-acpi: fix poll thread auto-start
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

commit b589ea4c44170d3f7a845684e2d1b3b9571663af upstream.

The driver was not starting the NVRAM polling thread if the input
device was bound immediately after registration.

This fixes:
http://bugzilla.kernel.org/show_bug.cgi?id=15118

Reported-by: Florian Zumbiehl <florz@florz.de>
Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/thinkpad_acpi.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -2607,16 +2607,11 @@ static int hotkey_inputdev_open(struct i
 {
 	switch (tpacpi_lifecycle) {
 	case TPACPI_LIFE_INIT:
-		/*
-		 * hotkey_init will call hotkey_poll_setup_safe
-		 * at the appropriate moment
-		 */
-		return 0;
-	case TPACPI_LIFE_EXITING:
-		return -EBUSY;
 	case TPACPI_LIFE_RUNNING:
 		hotkey_poll_setup_safe(false);
 		return 0;
+	case TPACPI_LIFE_EXITING:
+		return -EBUSY;
 	}
 
 	/* Should only happen if tpacpi_lifecycle is corrupt */
@@ -2627,7 +2622,7 @@ static int hotkey_inputdev_open(struct i
 static void hotkey_inputdev_close(struct input_dev *dev)
 {
 	/* disable hotkey polling when possible */
-	if (tpacpi_lifecycle == TPACPI_LIFE_RUNNING &&
+	if (tpacpi_lifecycle != TPACPI_LIFE_EXITING &&
 	    !(hotkey_source_mask & hotkey_driver_mask))
 		hotkey_poll_setup_safe(false);
 }
@@ -9051,6 +9046,9 @@ static int __init thinkpad_acpi_module_i
 			return ret;
 		}
 	}
+
+	tpacpi_lifecycle = TPACPI_LIFE_RUNNING;
+
 	ret = input_register_device(tpacpi_inputdev);
 	if (ret < 0) {
 		printk(TPACPI_ERR "unable to register input device\n");
@@ -9060,7 +9058,6 @@ static int __init thinkpad_acpi_module_i
 		tp_features.input_device_registered = 1;
 	}
 
-	tpacpi_lifecycle = TPACPI_LIFE_RUNNING;
 	return 0;
 }
 


