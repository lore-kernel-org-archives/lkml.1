Return-Path: <linux-kernel-owner+w=401wt.eu-S1761829AbYDKUjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761829AbYDKUjX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 16:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760529AbYDKUhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 16:37:34 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:42473 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759989AbYDKUha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 16:37:30 -0400
X-Sasl-enc: mLAihEhifTOLEYSkk9hsQ+mVNrbJ8m5M0B4WrDgF0sim 1207946249
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel@vger.kernel.org
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Ivo van Doorn <IvDoorn@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: [PATCH 5/8] rfkill: add read-only rfkill switch support
Date: Fri, 11 Apr 2008 17:37:21 -0300
Message-Id: <1207946244-14525-6-git-send-email-hmh@hmh.eng.br>
X-Mailer: git-send-email 1.5.4.4
In-Reply-To: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some devices (notably laptops) have read-only rfkill switches.  Those
devices are slider or rocker switches that are *physically* manipulated by
the user, most of the time tied to hardware or firmware functions that
automatically rf-kill and/or hot-unplug radio devices when in the "radios
off" position.

Software must not (and in fact, cannot) attempt to change the state of any
such switch.  These switches exist because of international regulations
regarding radio emission devices on airplanes and other sensitive areas.
They must never be overriden.

While one can easily report the *change* of state of these switches using
the input layer EV_SW SW_RADIO event, typically userspace needs to have
immediate access of the current switch state.  It makes sense to have all
radio kill switches grouped under the rfkill sysfs interface instead of
every driver doing its own thing.

Make the toggle_radio() hook no longer be mandatory.  read-only rfkill
switches are those who have their toggle_radio() hook set to NULL.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
---
 include/linux/rfkill.h |    3 ++-
 net/rfkill/rfkill.c    |   18 +++++++++++++-----
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
index 844e961..931d32b 100644
--- a/include/linux/rfkill.h
+++ b/include/linux/rfkill.h
@@ -60,7 +60,8 @@ enum rfkill_state {
  * @mutex: Guards switch state transitions
  * @data: Pointer to the RF button drivers private data which will be
  *	passed along when toggling radio state.
- * @toggle_radio(): Mandatory handler to control state of the radio.
+ * @toggle_radio(): handler to control state of the radio. Must be
+ *	NULL for read-only switches.
  * @get_state(): handler to read current radio state from hardware,
  *      may be called from atomic context, should return 0 on success.
  * @led_trigger: A LED trigger for this button's LED.
diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index 88b0558..d149d94 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -81,7 +81,7 @@ static int rfkill_toggle_radio(struct rfkill *rfkill,
 	    !rfkill->get_state(rfkill->data, &newstate))
 		rfkill->state = newstate;
 
-	if (state != rfkill->state) {
+	if (rfkill->toggle_radio && state != rfkill->state) {
 		retval = rfkill->toggle_radio(rfkill->data, state);
 		if (!retval)
 			rfkill->state = state;
@@ -196,6 +196,9 @@ static ssize_t rfkill_state_store(struct device *dev,
 	unsigned int state = simple_strtoul(buf, NULL, 0);
 	int error;
 
+	if (!rfkill->toggle_radio)
+		return -EACCES;
+
 	if (!capable(CAP_NET_ADMIN))
 		return -EPERM;
 
@@ -278,7 +281,8 @@ static int rfkill_suspend(struct device *dev, pm_message_t state)
 		if (state.event & PM_EVENT_SLEEP) {
 			mutex_lock(&rfkill->mutex);
 
-			if (rfkill->state == RFKILL_STATE_ON)
+			if (rfkill->state == RFKILL_STATE_ON &&
+			    rfkill->toggle_radio)
 				rfkill->toggle_radio(rfkill->data,
 						     RFKILL_STATE_OFF);
 
@@ -298,7 +302,8 @@ static int rfkill_resume(struct device *dev)
 	if (dev->power.power_state.event != PM_EVENT_ON) {
 		mutex_lock(&rfkill->mutex);
 
-		if (rfkill->state == RFKILL_STATE_ON)
+		if (rfkill->state == RFKILL_STATE_ON &&
+		    rfkill->toggle_radio)
 			rfkill->toggle_radio(rfkill->data, RFKILL_STATE_ON);
 
 		mutex_unlock(&rfkill->mutex);
@@ -427,11 +432,14 @@ int rfkill_register(struct rfkill *rfkill)
 	struct device *dev = &rfkill->dev;
 	int error;
 
-	if (!rfkill->toggle_radio)
-		return -EINVAL;
 	if (rfkill->type >= RFKILL_TYPE_MAX)
 		return -EINVAL;
 
+	if (!rfkill->toggle_radio) {
+		rfkill->user_claim_unsupported = 1;
+		rfkill->user_claim = 0;
+	}
+
 	snprintf(dev->bus_id, sizeof(dev->bus_id),
 		 "rfkill%ld", (long)atomic_inc_return(&rfkill_no) - 1);
 
-- 
1.5.4.4

