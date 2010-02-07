Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635Ab0BGShM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 13:37:12 -0500
Received: from liberdade.minaslivre.org ([72.232.254.139]:44291 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824Ab0BGShL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 13:37:11 -0500
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: linux-acpi@vger.kernel.org
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
       ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] thinkpad-acpi: setup hotkey polling after changing hotkey_driver_mask
Date: Sun,  7 Feb 2010 16:32:07 -0200
Message-Id: <1265567528-1180-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brightness notification does not work until the user writes to
hotkey_mask attribute. That's because the polling thread will only run
if hotkey_user_mask is set and someone is reading the input device or if
hotkey_driver_mask is set. In this second case, this condition is not
tested after the mask is changed, because the brightness and volume
drivers are started after the hotkey drivers.

This fix test for the polling condition that ends up starting the
polling thread after hotkey_driver_mask is set in brightness and volume
init functions.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 drivers/platform/x86/thinkpad_acpi.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index e67e4fe..d69749d 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -6272,6 +6272,11 @@ static int __init brightness_init(struct ibm_init_struct *iibm)
 	tpacpi_hotkey_driver_mask_set(hotkey_driver_mask
 				| TP_ACPI_HKEY_BRGHTUP_MASK
 				| TP_ACPI_HKEY_BRGHTDWN_MASK);;
+
+#ifdef CONFIG_THINKPAD_ACPI_HOTKEY_POLL
+	hotkey_poll_setup(true);
+#endif
+
 	return 0;
 }
 
@@ -6903,6 +6908,10 @@ static int __init volume_init(struct ibm_init_struct *iibm)
 			| TP_ACPI_HKEY_VOLDWN_MASK
 			| TP_ACPI_HKEY_MUTE_MASK);
 
+#ifdef CONFIG_THINKPAD_ACPI_HOTKEY_POLL
+	hotkey_poll_setup(true);
+#endif
+
 	return 0;
 }
 
-- 
1.6.6.1

