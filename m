Return-Path: <linux-kernel-owner+w=401wt.eu-S1761618AbYDKUiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761618AbYDKUiP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 16:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760079AbYDKUha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 16:37:30 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:56111 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759273AbYDKUh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 16:37:28 -0400
X-Sasl-enc: MEXemaJFD8siy3Ucuuory1fs//EB/Yj5mgIxDJsVAYJR 1207946247
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel@vger.kernel.org
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Ivo van Doorn <IvDoorn@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: [PATCH 4/8] rfkill: add read-write rfkill switch support
Date: Fri, 11 Apr 2008 17:37:20 -0300
Message-Id: <1207946244-14525-5-git-send-email-hmh@hmh.eng.br>
X-Mailer: git-send-email 1.5.4.4
In-Reply-To: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, rfkill supports only write-only rfkill switches.  There is no
provision for querying the current switch state from the hardware/firmware.

This is bad on hardware where the switch state can change behind the
kernel's back (which is rather common).  There is no reason to keep kernel
state incorrect, when we have the possibility to match reality.

There is also the issue of read-only rfkill switches (support to be added
in a later patch), which absolutely requires support to read the current
state from the hardware in order to be implemented.

In order to implement the read/write functionality:

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

If the firmware is event driven, leave get_state() NULL in the driver, set
the initial state properly before registering the rfkill class, and use the
force_state() method in the driver to keep the class up-to-date.

get_state() can be called by the class from atomic context. It must not
sleep.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
Cc: John W. Linville <linville@tuxdriver.com>
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
index 1601e50..88b0558 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -57,19 +57,39 @@ static void rfkill_led_trigger(struct rfkill *rfkill,
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
 
@@ -100,6 +120,28 @@ void rfkill_switch_all(enum rfkill_type type, enum rfkill_state state)
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
@@ -142,6 +184,7 @@ static ssize_t rfkill_state_show(struct device *dev,
 {
 	struct rfkill *rfkill = to_rfkill(dev);
 
+	update_rfkill_state(rfkill);
 	return sprintf(buf, "%d\n", rfkill->state);
 }
 
-- 
1.5.4.4

