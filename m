Return-Path: <linux-kernel-owner+w=401wt.eu-S1762853AbYERS6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762853AbYERS6r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760058AbYERSsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:48:30 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:46908 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757114AbYERSsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:48:16 -0400
X-Sasl-enc: 4i0OhKOsORIRv1ql528gsNcVgN85ow1gskU+vi26huap 1211136495
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel@vger.kernel.org
Cc: Ivo van Doorn <IvDoorn@gmail.com>, Thomas Renninger <trenn@suse.de>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: [PATCH 08/15] rfkill: add read-write rfkill switch support
Date: Sun, 18 May 2008 15:47:58 -0300
Message-Id: <1211136485-19878-9-git-send-email-hmh@hmh.eng.br>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br>
References: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, rfkill support for read/write rfkill switches is hacked through
a round-trip over the input layer and rfkill-input to let a driver sync
rfkill->state to hardware changes.

This is buggy and sub-optimal.  It causes real problems.  It is best to
think of the rfkill class as supporting only write-only switches at the
moment.

In order to implement the read/write functionality properly:

Add a get_state() hook that is called by the class every time it needs to
fetch the current state of the switch.  Add a call to this hook every time
the *current* state of the radio plays a role in a decision.

Also add a force_state() method that can be used to forcefully syncronize
the class' idea of the current state of the switch.  This allows for a
faster implementation of the read/write functionality, as a driver which
get events on switch changes can avoid the need for a get_state() hook.

If the get_state() hook is left as NULL, current behaviour is maintained,
so this change is fully backwards compatible with the current rfkill
drivers.

For hardware that issues events when the rfkill state changes, leave
get_state() NULL in the rfkill struct, set the initial state properly
before registering with the rfkill class, and use the force_state() method
in the driver to keep the rfkill interface up-to-date.

get_state() can be called by the class from atomic context. It must not
sleep.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
---
 include/linux/rfkill.h |    5 ++++
 net/rfkill/rfkill.c    |   49 +++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 51 insertions(+), 3 deletions(-)

diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
index ca89ae1..844e961 100644
--- a/include/linux/rfkill.h
+++ b/include/linux/rfkill.h
@@ -61,6 +61,8 @@ enum rfkill_state {
  * @data: Pointer to the RF button drivers private data which will be
  *	passed along when toggling radio state.
  * @toggle_radio(): Mandatory handler to control state of the radio.
+ * @get_state(): handler to read current radio state from hardware,
+ *      may be called from atomic context, should return 0 on success.
  * @led_trigger: A LED trigger for this button's LED.
  * @dev: Device structure integrating the switch into device tree.
  * @node: Used to place switch into list of all switches known to the
@@ -80,6 +82,7 @@ struct rfkill {
 
 	void *data;
 	int (*toggle_radio)(void *data, enum rfkill_state state);
+	int (*get_state)(void *data, enum rfkill_state *state);
 
 #ifdef CONFIG_RFKILL_LEDS
 	struct led_trigger led_trigger;
@@ -95,6 +98,8 @@ void rfkill_free(struct rfkill *rfkill);
 int rfkill_register(struct rfkill *rfkill);
 void rfkill_unregister(struct rfkill *rfkill);
 
+int rfkill_force_state(struct rfkill *rfkill, enum rfkill_state state);
+
 /**
  * rfkill_get_led_name - Get the LED trigger name for the button's LED.
  * This function might return a NULL pointer if registering of the
diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index 3edc585..2e19b68 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -62,19 +62,39 @@ static void rfkill_led_trigger(struct rfkill *rfkill,
 #endif /* CONFIG_RFKILL_LEDS */
 }
 
+static void update_rfkill_state(struct rfkill *rfkill)
+{
+	enum rfkill_state newstate;
+
+	if (rfkill->get_state) {
+		mutex_lock(&rfkill->mutex);
+		if (!rfkill->get_state(rfkill->data, &newstate))
+			rfkill->state = newstate;
+		mutex_unlock(&rfkill->mutex);
+	}
+}
+
 static int rfkill_toggle_radio(struct rfkill *rfkill,
 				enum rfkill_state state)
 {
 	int retval = 0;
+	enum rfkill_state oldstate, newstate;
+
+	oldstate = rfkill->state;
+
+	if (rfkill->get_state &&
+	    !rfkill->get_state(rfkill->data, &newstate))
+		rfkill->state = newstate;
 
 	if (state != rfkill->state) {
 		retval = rfkill->toggle_radio(rfkill->data, state);
-		if (!retval) {
+		if (!retval)
 			rfkill->state = state;
-			rfkill_led_trigger(rfkill, state);
-		}
 	}
 
+	if (rfkill->state != oldstate)
+		rfkill_led_trigger(rfkill, rfkill->state);
+
 	return retval;
 }
 
@@ -105,6 +125,28 @@ void rfkill_switch_all(enum rfkill_type type, enum rfkill_state state)
 }
 EXPORT_SYMBOL(rfkill_switch_all);
 
+/**
+ * rfkill_force_state - Force the internal rfkill radio state
+ * @rfkill: pointer to the rfkill class to modify.
+ * @state: the current radio state the class should be forced to.
+ *
+ * This function updates the internal state of the radio cached
+ * by the rfkill class.  It should be used when the driver gets
+ * a notification by the firmware/hardware of the current *real*
+ * state of the radio rfkill switch.
+ *
+ * It may not be called from an atomic context.
+ */
+int rfkill_force_state(struct rfkill *rfkill, enum rfkill_state state)
+{
+	mutex_lock(&rfkill->mutex);
+	rfkill->state = state;
+	mutex_unlock(&rfkill->mutex);
+
+	return 0;
+}
+EXPORT_SYMBOL(rfkill_force_state);
+
 static ssize_t rfkill_name_show(struct device *dev,
 				struct device_attribute *attr,
 				char *buf)
@@ -147,6 +189,7 @@ static ssize_t rfkill_state_show(struct device *dev,
 {
 	struct rfkill *rfkill = to_rfkill(dev);
 
+	update_rfkill_state(rfkill);
 	return sprintf(buf, "%d\n", rfkill->state);
 }
 
-- 
1.5.5.1

