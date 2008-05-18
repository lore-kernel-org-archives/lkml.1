Return-Path: <linux-kernel-owner+w=401wt.eu-S1762709AbYERS5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762709AbYERS5s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760589AbYERSs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:48:27 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:41339 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759992AbYERSsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:48:16 -0400
X-Sasl-enc: //tGU2tUtUZMA3EWEWOCN8Uv3WEBGdL7XzQUwmjgscE9 1211136494
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel@vger.kernel.org
Cc: Ivo van Doorn <IvDoorn@gmail.com>, Thomas Renninger <trenn@suse.de>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: [PATCH 11/15] rfkill: add notifier chains support
Date: Sun, 18 May 2008 15:48:01 -0300
Message-Id: <1211136485-19878-12-git-send-email-hmh@hmh.eng.br>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br>
References: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a notifier chain for use by the rfkill class.  This notifier chain
signals the following events (more to be added when needed):

  1. rfkill: rfkill device state has changed

A pointer to the rfkill struct will be passed as a parameter.

The notifier message types have been added to include/linux/rfkill.h
instead of to include/linux/notifier.h in order to avoid the madness of
modifying a header used globally (and that triggers an almost full tree
rebuild every time it is touched) with information that is of interest only
to code that includes the rfkill.h header.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
---
 include/linux/rfkill.h |    7 +++++
 net/rfkill/rfkill.c    |   70 +++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 74 insertions(+), 3 deletions(-)

diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
index c0cab7d..98667be 100644
--- a/include/linux/rfkill.h
+++ b/include/linux/rfkill.h
@@ -117,4 +117,11 @@ static inline char *rfkill_get_led_name(struct rfkill *rfkill)
 #endif
 }
 
+/* rfkill notification chain */
+#define RFKILL_STATE_CHANGED		0x0001	/* state of a normal rfkill
+						   switch has changed */
+
+int register_rfkill_notifier(struct notifier_block *nb);
+int unregister_rfkill_notifier(struct notifier_block *nb);
+
 #endif /* RFKILL_H */
diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index f11220b..251defe 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -46,6 +46,49 @@ MODULE_PARM_DESC(default_state,
 
 static enum rfkill_state rfkill_states[RFKILL_TYPE_MAX];
 
+static BLOCKING_NOTIFIER_HEAD(rfkill_notifier_list);
+
+
+/**
+ * register_rfkill_notifier - Add notifier to rfkill notifier chain
+ * @nb: pointer to the new entry to add to the chain
+ *
+ * See blocking_notifier_chain_register() for return value and further
+ * observations.
+ *
+ * Adds a notifier to the rfkill notifier chain.  The chain will be
+ * called with a pointer to the relevant rfkill structure as a parameter,
+ * refer to include/linux/rfkill.h for the possible events.
+ *
+ * Notifiers added to this chain are to always return NOTIFY_DONE.  This
+ * chain is a blocking notifier chain: notifiers can sleep.
+ *
+ * Calls to this chain may have been done through a workqueue.  One must
+ * one must assume unordered assynchronous behaviour, there is no way to
+ * know if actions related to the event that generated the notification
+ * have been carried out already.
+ */
+int register_rfkill_notifier(struct notifier_block *nb)
+{
+	return blocking_notifier_chain_register(&rfkill_notifier_list, nb);
+}
+EXPORT_SYMBOL_GPL(register_rfkill_notifier);
+
+/**
+ * unregister_rfkill_notifier - remove notifier from rfkill notifier chain
+ * @nb: pointer to the entry to remove from the chain
+ *
+ * See blocking_notifier_chain_unregister() for return value and further
+ * observations.
+ *
+ * Removes a notifier from the rfkill notifier chain.
+ */
+int unregister_rfkill_notifier(struct notifier_block *nb)
+{
+	return blocking_notifier_chain_unregister(&rfkill_notifier_list, nb);
+}
+EXPORT_SYMBOL_GPL(unregister_rfkill_notifier);
+
 
 static void rfkill_led_trigger(struct rfkill *rfkill,
 			       enum rfkill_state state)
@@ -62,14 +105,25 @@ static void rfkill_led_trigger(struct rfkill *rfkill,
 #endif /* CONFIG_RFKILL_LEDS */
 }
 
+static void notify_rfkill_state_change(struct rfkill *rfkill)
+{
+	blocking_notifier_call_chain(&rfkill_notifier_list,
+			RFKILL_STATE_CHANGED,
+			rfkill);
+}
+
 static void update_rfkill_state(struct rfkill *rfkill)
 {
-	enum rfkill_state newstate;
+	enum rfkill_state newstate, oldstate;
 
 	if (rfkill->get_state) {
 		mutex_lock(&rfkill->mutex);
-		if (!rfkill->get_state(rfkill->data, &newstate))
+		if (!rfkill->get_state(rfkill->data, &newstate)) {
+			oldstate = rfkill->state;
 			rfkill->state = newstate;
+			if (oldstate != newstate)
+				notify_rfkill_state_change(rfkill);
+		}
 		mutex_unlock(&rfkill->mutex);
 	}
 }
@@ -93,8 +147,10 @@ static int rfkill_toggle_radio(struct rfkill *rfkill,
 			rfkill->state = state;
 	}
 
-	if (force || rfkill->state != oldstate)
+	if (force || rfkill->state != oldstate) {
 		rfkill_led_trigger(rfkill, rfkill->state);
+		notify_rfkill_state_change(rfkill);
+	}
 
 	return retval;
 }
@@ -139,8 +195,16 @@ EXPORT_SYMBOL(rfkill_switch_all);
  */
 int rfkill_force_state(struct rfkill *rfkill, enum rfkill_state state)
 {
+	enum rfkill_state oldstate;
+
 	mutex_lock(&rfkill->mutex);
+
+	oldstate = rfkill->state;
 	rfkill->state = state;
+
+	if (state != oldstate)
+		notify_rfkill_state_change(rfkill);
+
 	mutex_unlock(&rfkill->mutex);
 
 	return 0;
-- 
1.5.5.1

