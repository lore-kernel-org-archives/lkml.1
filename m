Return-Path: <linux-kernel-owner+w=401wt.eu-S1760829AbYDKUiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760829AbYDKUiq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 16:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760252AbYDKUhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 16:37:32 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:48261 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759622AbYDKUh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 16:37:29 -0400
X-Sasl-enc: MEXKnbVHAssjx3wcr+I3xUDk//EB/Yj5mgIxDJsVAYJR 1207946247
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel@vger.kernel.org
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Ivo van Doorn <IvDoorn@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: [PATCH 3/8] rfkill: handle KEY_RADIO and SW_RADIO events
Date: Fri, 11 Apr 2008 17:37:19 -0300
Message-Id: <1207946244-14525-4-git-send-email-hmh@hmh.eng.br>
X-Mailer: git-send-email 1.5.4.4
In-Reply-To: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The *_RADIO input events are related to all radios in a system.  There are
two: KEY_RADIO and SW_RADIO.

Teach rfkill-input how to handle them.  In particular, SW_RADIO is not a
toggle, but an absolute enable-or-disable command.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
---
 net/rfkill/rfkill-input.c |   57 +++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 55 insertions(+), 2 deletions(-)

diff --git a/net/rfkill/rfkill-input.c b/net/rfkill/rfkill-input.c
index e4b051d..7d1e520 100644
--- a/net/rfkill/rfkill-input.c
+++ b/net/rfkill/rfkill-input.c
@@ -55,6 +55,22 @@ static void rfkill_task_handler(struct work_struct *work)
 	mutex_unlock(&task->mutex);
 }
 
+static void rfkill_schedule_set(struct rfkill_task *task,
+				enum rfkill_state desired_state)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&task->lock, flags);
+
+	if (time_after(jiffies, task->last + msecs_to_jiffies(200))) {
+		task->desired_state = desired_state;
+		task->last = jiffies;
+		schedule_work(&task->work);
+	}
+
+	spin_unlock_irqrestore(&task->lock, flags);
+}
+
 static void rfkill_schedule_toggle(struct rfkill_task *task)
 {
 	unsigned long flags;
@@ -87,9 +103,9 @@ static DEFINE_RFKILL_TASK(rfkill_uwb, RFKILL_TYPE_UWB);
 static DEFINE_RFKILL_TASK(rfkill_wimax, RFKILL_TYPE_WIMAX);
 
 static void rfkill_event(struct input_handle *handle, unsigned int type,
-			unsigned int code, int down)
+			unsigned int code, int data)
 {
-	if (type == EV_KEY && down == 1) {
+	if (type == EV_KEY && data == 1) {
 		switch (code) {
 		case KEY_WLAN:
 			rfkill_schedule_toggle(&rfkill_wlan);
@@ -103,6 +119,33 @@ static void rfkill_event(struct input_handle *handle, unsigned int type,
 		case KEY_WIMAX:
 			rfkill_schedule_toggle(&rfkill_wimax);
 			break;
+		case KEY_RADIO:
+			/* EVERY radio type */
+			rfkill_schedule_toggle(&rfkill_wimax);
+			rfkill_schedule_toggle(&rfkill_uwb);
+			rfkill_schedule_toggle(&rfkill_bt);
+			rfkill_schedule_toggle(&rfkill_wlan);
+			break;
+		default:
+			break;
+		}
+	} else if (type == EV_SW) {
+		switch (code) {
+		case SW_RADIO:
+			/* EVERY radio type. data != 0 means radios ON */
+			rfkill_schedule_set(&rfkill_wimax,
+					    (data)? RFKILL_STATE_ON:
+						    RFKILL_STATE_OFF);
+			rfkill_schedule_set(&rfkill_uwb,
+					    (data)? RFKILL_STATE_ON:
+						    RFKILL_STATE_OFF);
+			rfkill_schedule_set(&rfkill_bt,
+					    (data)? RFKILL_STATE_ON:
+						    RFKILL_STATE_OFF);
+			rfkill_schedule_set(&rfkill_wlan,
+					    (data)? RFKILL_STATE_ON:
+						    RFKILL_STATE_OFF);
+			break;
 		default:
 			break;
 		}
@@ -168,6 +211,16 @@ static const struct input_device_id rfkill_ids[] = {
 		.evbit = { BIT_MASK(EV_KEY) },
 		.keybit = { [BIT_WORD(KEY_WIMAX)] = BIT_MASK(KEY_WIMAX) },
 	},
+	{
+		.flags = INPUT_DEVICE_ID_MATCH_EVBIT | INPUT_DEVICE_ID_MATCH_KEYBIT,
+		.evbit = { BIT(EV_KEY) },
+		.keybit = { [BIT_WORD(KEY_RADIO)] = BIT_MASK(KEY_RADIO) },
+	},
+	{
+		.flags = INPUT_DEVICE_ID_MATCH_EVBIT | INPUT_DEVICE_ID_MATCH_SWBIT,
+		.evbit = { BIT(EV_SW) },
+		.swbit = { [BIT_WORD(SW_RADIO)] = BIT_MASK(SW_RADIO) },
+	},
 	{ }
 };
 
-- 
1.5.4.4

