Return-Path: <linux-kernel-owner+w=401wt.eu-S1761137AbYERSzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761137AbYERSzu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759894AbYERSsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:48:22 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:46908 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759218AbYERSsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:48:13 -0400
X-Sasl-enc: NeW8POLGuwmuuLSLgn9ffiKAeRl/FmHfKhJTsavd4/J4 1211136492
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel@vger.kernel.org
Cc: Ivo van Doorn <IvDoorn@gmail.com>, Thomas Renninger <trenn@suse.de>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: [PATCH 06/15] rfkill: handle SW_RFKILL_ALL events
Date: Sun, 18 May 2008 15:47:56 -0300
Message-Id: <1211136485-19878-7-git-send-email-hmh@hmh.eng.br>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br>
References: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Teach rfkill-input how to handle SW_RFKILL_ALL events (new name for the
SW_RADIO event).

SW_RFKILL_ALL is an absolute enable-or-disable command that is tied to all
radios in a system.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
---
 net/rfkill/rfkill-input.c |   45 +++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/net/rfkill/rfkill-input.c b/net/rfkill/rfkill-input.c
index e4b051d..9d6c925 100644
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
@@ -106,6 +122,26 @@ static void rfkill_event(struct input_handle *handle, unsigned int type,
 		default:
 			break;
 		}
+	} else if (type == EV_SW) {
+		switch (code) {
+		case SW_RFKILL_ALL:
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
+		default:
+			break;
+		}
 	}
 }
 
@@ -168,6 +204,11 @@ static const struct input_device_id rfkill_ids[] = {
 		.evbit = { BIT_MASK(EV_KEY) },
 		.keybit = { [BIT_WORD(KEY_WIMAX)] = BIT_MASK(KEY_WIMAX) },
 	},
+	{
+		.flags = INPUT_DEVICE_ID_MATCH_EVBIT | INPUT_DEVICE_ID_MATCH_SWBIT,
+		.evbit = { BIT(EV_SW) },
+		.swbit = { [BIT_WORD(SW_RFKILL_ALL)] = BIT_MASK(SW_RFKILL_ALL) },
+	},
 	{ }
 };
 
-- 
1.5.5.1

