Return-Path: <linux-kernel-owner+w=401wt.eu-S1762472AbYERS4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762472AbYERS4u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759978AbYERSsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:48:24 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:34744 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760577AbYERSsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:48:14 -0400
X-Sasl-enc: 12az9F+YfwKYZj0TLSeDbwCHhuckX9Rr+cWe1Q2OC4q+ 1211136493
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel@vger.kernel.org
Cc: Ivo van Doorn <IvDoorn@gmail.com>, Thomas Renninger <trenn@suse.de>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: [PATCH 13/15] rfkill: add uevent notifications
Date: Sun, 18 May 2008 15:48:03 -0300
Message-Id: <1211136485-19878-14-git-send-email-hmh@hmh.eng.br>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br>
References: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the notification chains to also send uevents, so that userspace can be
notified of state changes of every rfkill switch.

Userspace should use these events for OSD/status report applications and
rfkill GUI frontends.  HAL might want to broadcast them over DBUS, for
example.  It might be also useful for userspace implementations of
rfkill-input, or to use HAL as the platform driver which promotes rfkill
switch change events into input events (to synchronize all other switches)
when necessary for platforms that lack a convenient platform-specific
kernel module to do it.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
---
 net/rfkill/rfkill.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index 4ed8d19..ba25bde 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -382,12 +382,51 @@ static int rfkill_resume(struct device *dev)
 #define rfkill_resume NULL
 #endif
 
+static int rfkill_blocking_uevent_notifier(struct notifier_block *nb,
+					unsigned long eventid,
+					void *data)
+{
+	struct rfkill *rfkill = (struct rfkill *)data;
+
+	switch (eventid) {
+	case RFKILL_STATE_CHANGED:
+		kobject_uevent(&rfkill->dev.kobj, KOBJ_CHANGE);
+		break;
+	default:
+		break;
+	}
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block rfkill_blocking_uevent_nb = {
+	.notifier_call	= rfkill_blocking_uevent_notifier,
+	.priority	= 0,
+};
+
+static int rfkill_dev_uevent(struct device *dev, struct kobj_uevent_env *env)
+{
+	struct rfkill *rfkill = to_rfkill(dev);
+	int error;
+
+	error = add_uevent_var(env, "RFKILL_NAME=%s", rfkill->name);
+	if (error)
+		return error;
+	error = add_uevent_var(env, "RFKILL_TYPE=%s",
+				rfkill_get_type_str(rfkill->type));
+	if (error)
+		return error;
+	error = add_uevent_var(env, "RFKILL_STATE=%u", rfkill->state);
+	return error;
+}
+
 static struct class rfkill_class = {
 	.name		= "rfkill",
 	.dev_release	= rfkill_release,
 	.dev_attrs	= rfkill_dev_attrs,
 	.suspend	= rfkill_suspend,
 	.resume		= rfkill_resume,
+	.dev_uevent	= rfkill_dev_uevent,
 };
 
 static int rfkill_add_switch(struct rfkill *rfkill)
@@ -562,11 +601,14 @@ static int __init rfkill_init(void)
 		return error;
 	}
 
+	register_rfkill_notifier(&rfkill_blocking_uevent_nb);
+
 	return 0;
 }
 
 static void __exit rfkill_exit(void)
 {
+	unregister_rfkill_notifier(&rfkill_blocking_uevent_nb);
 	class_unregister(&rfkill_class);
 }
 
-- 
1.5.5.1

