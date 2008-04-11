Return-Path: <linux-kernel-owner+w=401wt.eu-S1761686AbYDKUjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761686AbYDKUjF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 16:39:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760341AbYDKUhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 16:37:33 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:35653 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759967AbYDKUha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 16:37:30 -0400
X-Sasl-enc: mLAgh1BmYSyVBoymldp7We+FNrbJ8m5M0B4WrDgF0sim 1207946249
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel@vger.kernel.org
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Ivo van Doorn <IvDoorn@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: [PATCH 7/8] rfkill: add an "any radio" switch type and functionality
Date: Fri, 11 Apr 2008 17:37:23 -0300
Message-Id: <1207946244-14525-8-git-send-email-hmh@hmh.eng.br>
X-Mailer: git-send-email 1.5.4.4
In-Reply-To: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a RFKILL_TYPE_ANY switch.  This switch can control more than one type
of radio, and it is always subject to toggling by any type of rfkill-input
event.  It is suitable to implement kill-all-radios functionality when
coupled with input event EV_SW SW_RADIO.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
---
 include/linux/rfkill.h    |    2 ++
 net/rfkill/rfkill-input.c |    9 +++++++++
 net/rfkill/rfkill.c       |    3 +++
 3 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
index 7650517..ba8a7e1 100644
--- a/include/linux/rfkill.h
+++ b/include/linux/rfkill.h
@@ -35,6 +35,7 @@
  * RFKILL_TYPE_UWB: switch is on a ultra wideband device.
  * RFKILL_TYPE_WIMAX: switch is on a WiMAX device.
  * RFKILL_TYPE_WWAN: switch is on a wireless WAN device.
+ * RFKILL_TYPE_ANY: switch kills radios regardless of type.
  */
 enum rfkill_type {
 	RFKILL_TYPE_WLAN ,
@@ -42,6 +43,7 @@ enum rfkill_type {
 	RFKILL_TYPE_UWB,
 	RFKILL_TYPE_WIMAX,
 	RFKILL_TYPE_WWAN,
+	RFKILL_TYPE_ANY,
 	RFKILL_TYPE_MAX,
 };
 
diff --git a/net/rfkill/rfkill-input.c b/net/rfkill/rfkill-input.c
index 675651b..ec9112c 100644
--- a/net/rfkill/rfkill-input.c
+++ b/net/rfkill/rfkill-input.c
@@ -102,6 +102,7 @@ static DEFINE_RFKILL_TASK(rfkill_bt, RFKILL_TYPE_BLUETOOTH);
 static DEFINE_RFKILL_TASK(rfkill_uwb, RFKILL_TYPE_UWB);
 static DEFINE_RFKILL_TASK(rfkill_wimax, RFKILL_TYPE_WIMAX);
 static DEFINE_RFKILL_TASK(rfkill_wwan, RFKILL_TYPE_WIMAX);
+static DEFINE_RFKILL_TASK(rfkill_any, RFKILL_TYPE_ANY);
 
 static void rfkill_event(struct input_handle *handle, unsigned int type,
 			unsigned int code, int data)
@@ -110,18 +111,23 @@ static void rfkill_event(struct input_handle *handle, unsigned int type,
 		switch (code) {
 		case KEY_WLAN:
 			rfkill_schedule_toggle(&rfkill_wlan);
+			rfkill_schedule_toggle(&rfkill_any);
 			break;
 		case KEY_BLUETOOTH:
 			rfkill_schedule_toggle(&rfkill_bt);
+			rfkill_schedule_toggle(&rfkill_any);
 			break;
 		case KEY_UWB:
 			rfkill_schedule_toggle(&rfkill_uwb);
+			rfkill_schedule_toggle(&rfkill_any);
 			break;
 		case KEY_WIMAX:
 			rfkill_schedule_toggle(&rfkill_wimax);
+			rfkill_schedule_toggle(&rfkill_any);
 			break;
 		case KEY_RADIO:
 			/* EVERY radio type */
+			rfkill_schedule_toggle(&rfkill_any);
 			rfkill_schedule_toggle(&rfkill_wwan);
 			rfkill_schedule_toggle(&rfkill_wimax);
 			rfkill_schedule_toggle(&rfkill_uwb);
@@ -135,6 +141,9 @@ static void rfkill_event(struct input_handle *handle, unsigned int type,
 		switch (code) {
 		case SW_RADIO:
 			/* EVERY radio type. data != 0 means radios ON */
+			rfkill_schedule_set(&rfkill_any,
+					    (data)? RFKILL_STATE_ON:
+						    RFKILL_STATE_OFF);
 			rfkill_schedule_set(&rfkill_wwan,
 					    (data)? RFKILL_STATE_ON:
 						    RFKILL_STATE_OFF);
diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index 56241a4..9d3bffb 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -174,6 +174,9 @@ static ssize_t rfkill_type_show(struct device *dev,
 	case RFKILL_TYPE_WWAN:
 		type = "wwan";
 		break;
+	case RFKILL_TYPE_ANY:
+		type = "any";
+		break;
 	default:
 		BUG();
 	}
-- 
1.5.4.4

