Return-Path: <linux-kernel-owner+w=401wt.eu-S1760181AbYDNOQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760181AbYDNOQI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 10:16:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756040AbYDNOPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 10:15:55 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:57445 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755443AbYDNOPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 10:15:54 -0400
X-Sasl-enc: KsnG8D6SU3HMTwrn2WqYDY5HYhrp0dNgN0qOvoNRll/h 1208182553
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel@vger.kernel.org
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Dmitry Torokhov <dtor@mail.ru>, Ivo van Doorn <IvDoorn@gmail.com>
Subject: Input: rename SW_RADIO to SW_RFKILL_ALL (v2)
Date: Mon, 14 Apr 2008 11:15:51 -0300
Message-Id: <1208182551-31336-1-git-send-email-hmh@hmh.eng.br>
X-Mailer: git-send-email 1.5.4.4
In-Reply-To: <20080414041659.GA655@anvil.corenet.prv>
References: <20080414041659.GA655@anvil.corenet.prv>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SW_RADIO code for EV_SW events has a name that is not descriptive
enough of its intended function, and could induce someone to think
KEY_RADIO is its EV_KEY counterpart, which is false.

Rename it to SW_RFKILL_ALL, and document what this event is for.  Keep
the old name around, to avoid userspace ABI breaks.

The SW_RFKILL_ALL event is meant to be used by rfkill master switches.  It
is not bound to a particular radio switch type, and usually applies to all
types.  It is semantically tied to master rfkill switches that enable or
disable every radio in a system.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
---
 Documentation/laptops/thinkpad-acpi.txt |    2 +-
 drivers/misc/thinkpad_acpi.c            |    4 ++--
 include/linux/input.h                   |    4 +++-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/Documentation/laptops/thinkpad-acpi.txt b/Documentation/laptops/thinkpad-acpi.txt
index 76cb428..3c65b05 100644
--- a/Documentation/laptops/thinkpad-acpi.txt
+++ b/Documentation/laptops/thinkpad-acpi.txt
@@ -498,7 +498,7 @@ generate input device EV_KEY events.
 In addition to the EV_KEY events, thinkpad-acpi may also issue EV_SW
 events for switches:
 
-SW_RADIO	T60 and later hardare rfkill rocker switch
+SW_RFKILL_ALL	T60 and later hardare rfkill rocker switch
 SW_TABLET_MODE	Tablet ThinkPads HKEY events 0x5009 and 0x500A
 
 Non hot-key ACPI HKEY event map:
diff --git a/drivers/misc/thinkpad_acpi.c b/drivers/misc/thinkpad_acpi.c
index 6cb7812..84b2db3 100644
--- a/drivers/misc/thinkpad_acpi.c
+++ b/drivers/misc/thinkpad_acpi.c
@@ -1180,7 +1180,7 @@ static void tpacpi_input_send_radiosw(void)
 		mutex_lock(&tpacpi_inputdev_send_mutex);
 
 		input_report_switch(tpacpi_inputdev,
-				    SW_RADIO, !!wlsw);
+				    SW_RFKILL_ALL, !!wlsw);
 		input_sync(tpacpi_inputdev);
 
 		mutex_unlock(&tpacpi_inputdev_send_mutex);
@@ -2084,7 +2084,7 @@ static int __init hotkey_init(struct ibm_init_struct *iibm)
 
 		if (tp_features.hotkey_wlsw) {
 			set_bit(EV_SW, tpacpi_inputdev->evbit);
-			set_bit(SW_RADIO, tpacpi_inputdev->swbit);
+			set_bit(SW_RFKILL_ALL, tpacpi_inputdev->swbit);
 		}
 		if (tp_features.hotkey_tablet) {
 			set_bit(EV_SW, tpacpi_inputdev->evbit);
diff --git a/include/linux/input.h b/include/linux/input.h
index cae2c35..0c32f69 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -637,7 +637,9 @@ struct input_absinfo {
 #define SW_LID			0x00  /* set = lid shut */
 #define SW_TABLET_MODE		0x01  /* set = tablet mode */
 #define SW_HEADPHONE_INSERT	0x02  /* set = inserted */
-#define SW_RADIO		0x03  /* set = radio enabled */
+#define SW_RFKILL_ALL		0x03  /* rfkill master switch, type "any"
+					 set = radio enabled */
+#define SW_RADIO		SW_RFKILL_ALL	/* deprecated */
 #define SW_MAX			0x0f
 #define SW_CNT			(SW_MAX+1)
 
-- 
1.5.4.4

