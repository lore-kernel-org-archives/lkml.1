Return-Path: <linux-kernel-owner+w=401wt.eu-S1762107AbYDKUjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762107AbYDKUjk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 16:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760593AbYDKUhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 16:37:34 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:38955 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760077AbYDKUha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 16:37:30 -0400
X-Sasl-enc: mLAuhUhkZzmRBJCyntd4UvyKNrbJ8m5M0B4WrDgF0sim 1207946249
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel@vger.kernel.org
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Ivo van Doorn <IvDoorn@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: [PATCH 8/8] rfkill: add parameter to disable radios by default
Date: Fri, 11 Apr 2008 17:37:24 -0300
Message-Id: <1207946244-14525-9-git-send-email-hmh@hmh.eng.br>
X-Mailer: git-send-email 1.5.4.4
In-Reply-To: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, radios are always enabled when their rfkill interface is
registered.  This is not optimal, the safest state for a radio is to be
offline unless the user turns it on.

Add a module parameter that causes all radios to be disabled when their
rfkill interface is registered.  Add override parameters for each rfkill
switch type as well, just in case the user wants the defaults to be
different for a given radio type.

We don't change the module default, but I'd really recommed doing so in a
future patch.

The parameters are called "default_state" (global), and
"default_<type>_state", where <type> is: "wlan", "bluetooth", "uwb",
"wimax", or "any".  Note that "any" realy is a type and does not mean every
radio type (use the global "default_state" parameter for that.

The precedence order is "most specific first".

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
---
 net/rfkill/rfkill.c |   59 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 58 insertions(+), 1 deletions(-)

diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index 9d3bffb..421de8c 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -39,6 +39,34 @@ MODULE_LICENSE("GPL");
 static LIST_HEAD(rfkill_list);	/* list of registered rf switches */
 static DEFINE_MUTEX(rfkill_mutex);
 
+static unsigned int rfkill_default_state = RFKILL_STATE_ON;
+static unsigned int rfkill_default_state_wlan = UINT_MAX;
+static unsigned int rfkill_default_state_bluetooth = UINT_MAX;
+static unsigned int rfkill_default_state_uwb = UINT_MAX;
+static unsigned int rfkill_default_state_wimax = UINT_MAX;
+static unsigned int rfkill_default_state_wwan = UINT_MAX;
+static unsigned int rfkill_default_state_any = UINT_MAX;
+
+module_param_named(default_state, rfkill_default_state, uint, 0444);
+MODULE_PARM_DESC(default_state,
+		 "Default initial state for all radio types, 0 = radio off");
+
+#define RFKILL_RADIO_DEFAULT(__type) \
+	module_param_named(default_##__type##_state, \
+			   rfkill_default_state_##__type, uint, 0444); \
+	MODULE_PARM_DESC(default_##__type##_state, \
+			 "Override initial state for radios of type " \
+			 #__type ", 0 = radio off");
+
+RFKILL_RADIO_DEFAULT(wlan)
+RFKILL_RADIO_DEFAULT(bluetooth)
+RFKILL_RADIO_DEFAULT(uwb)
+RFKILL_RADIO_DEFAULT(wimax)
+RFKILL_RADIO_DEFAULT(wwan)
+RFKILL_RADIO_DEFAULT(any)
+
+#undef RFKILL_RADIO_DEFAULT
+
 static enum rfkill_state rfkill_states[RFKILL_TYPE_MAX];
 
 
@@ -485,6 +513,17 @@ void rfkill_unregister(struct rfkill *rfkill)
 }
 EXPORT_SYMBOL(rfkill_unregister);
 
+static int __init rfkill_init_states(unsigned int state, enum rfkill_type type)
+{
+	if (state == UINT_MAX)
+		return 0;
+	else if (state == RFKILL_STATE_OFF || state == RFKILL_STATE_ON) {
+		rfkill_states[type] = state;
+		return 0;
+	}
+	return 1;
+}
+
 /*
  * Rfkill module initialization/deinitialization.
  */
@@ -493,8 +532,26 @@ static int __init rfkill_init(void)
 	int error;
 	int i;
 
+	if (rfkill_default_state != RFKILL_STATE_OFF &&
+	    rfkill_default_state != RFKILL_STATE_ON)
+		return -EINVAL;
+
 	for (i = 0; i < ARRAY_SIZE(rfkill_states); i++)
-		rfkill_states[i] = RFKILL_STATE_ON;
+		rfkill_states[i] = rfkill_default_state;
+
+	if (rfkill_init_states(rfkill_default_state_wlan,
+				  RFKILL_TYPE_WLAN)
+	    || rfkill_init_states(rfkill_default_state_bluetooth,
+				  RFKILL_TYPE_BLUETOOTH)
+	    || rfkill_init_states(rfkill_default_state_uwb,
+				  RFKILL_TYPE_UWB)
+	    || rfkill_init_states(rfkill_default_state_wimax,
+				  RFKILL_TYPE_WIMAX)
+	    || rfkill_init_states(rfkill_default_state_wwan,
+				  RFKILL_TYPE_WWAN)
+	    || rfkill_init_states(rfkill_default_state_any,
+				  RFKILL_TYPE_ANY))
+		return -EINVAL;
 
 	error = class_register(&rfkill_class);
 	if (error) {
-- 
1.5.4.4

