Return-Path: <linux-kernel-owner+w=401wt.eu-S1753383AbZKJKDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbZKJKDs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 05:03:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316AbZKJKDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 05:03:47 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:35039 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbZKJKDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 05:03:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=X/QJr37yPBUPyQydR4ZWFrB4bywIk7TNStSH9aP7c3sWDi4QKVWvmyVxMOUL0qnQaY
         MsCRdueQ6yHs24u354tG4Smjcs9uzCo7CTb0czSErYiOS06x4SBMr7bUXoc16Gx4X8gu
         SNusfXQSnha6Cmqzh8lG5/W3K1Zkhz/Ctbkg8=
Subject: [PATCH] ALPS: Add support for 4 directions button on Acer Aspire
 5720
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Vojtech Pavlik <vojtech@suse.cz>, Dmitry Torokhov <dtor@mail.ru>
In-Reply-To: <1257846940.4921.11.camel@maxim-laptop>
References: <1256955018.9681.23.camel@maxim-laptop>
	 <1257846940.4921.11.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Nov 2009 12:03:47 +0200
Message-ID: <1257847427.4921.13.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 4aefbe6c09df53881c4738c1a524be595a388e28 Mon Sep 17 00:00:00 2001
From: Maxim Levitsky <maximlevitsky@gmail.com>
Date: Tue, 10 Nov 2009 11:57:56 +0200
Subject: [PATCH] ALPS: Add support for 4 directions button on Acer Aspire 5720
 Implemented using DMI due to uncertainty about systems that have
 only the middle button

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/input/mouse/alps.c |   81 +++++++++++++++++++++++++++++++++++--------
 drivers/input/mouse/alps.h |    2 +-
 2 files changed, 67 insertions(+), 16 deletions(-)

diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
index f361106..06a5709 100644
--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -17,6 +17,7 @@
 #include <linux/input.h>
 #include <linux/serio.h>
 #include <linux/libps2.h>
+#include <linux/dmi.h>
 
 #include "psmouse.h"
 #include "alps.h"
@@ -28,13 +29,17 @@
 #define dbg(format, arg...) do {} while (0)
 #endif
 
-#define ALPS_DUALPOINT	0x01
-#define ALPS_WHEEL	0x02
-#define ALPS_FW_BK_1	0x04
-#define ALPS_4BTN	0x08
-#define ALPS_OLDPROTO	0x10
-#define ALPS_PASS	0x20
-#define ALPS_FW_BK_2	0x40
+
+#define ALPS_OLDPROTO	0x01	/* old style input */
+#define ALPS_DUALPOINT	0x02	/* touchpad has trackstick */
+#define ALPS_PASS	0x04	/* select which device to address each time */
+
+
+#define ALPS_WHEEL	0x08	/* hardware wheel present */
+#define ALPS_FW_BK_1	0x10	/* front & back buttons present */
+#define ALPS_FW_BK_2	0x20	/* front & back buttons present */
+#define ALPS_EXTRA	0x40	/* 4 direction button present */
+
 
 static const struct alps_model_info alps_model_data[] = {
 	{ { 0x32, 0x02, 0x14 },	0xf8, 0xf8, ALPS_PASS | ALPS_DUALPOINT }, /* Toshiba Salellite Pro M10 */
@@ -147,7 +152,13 @@ static void alps_process_packet(struct psmouse *psmouse)
 
 	input_report_key(dev, BTN_LEFT, left);
 	input_report_key(dev, BTN_RIGHT, right);
-	input_report_key(dev, BTN_MIDDLE, middle);
+
+
+	/* middle button serves as left scroll button */
+	if ((priv->i->flags & ALPS_EXTRA))
+		input_report_key(dev, BTN_2, middle);
+	else
+		input_report_key(dev, BTN_MIDDLE, middle);
 
 	/* Convert hardware tap to a reasonable Z value */
 	if (ges && !fin) z = 40;
@@ -181,10 +192,13 @@ static void alps_process_packet(struct psmouse *psmouse)
 		input_report_rel(dev, REL_WHEEL, ((packet[2] << 1) & 0x08) - ((packet[0] >> 4) & 0x07));
 
 	if (priv->i->flags & (ALPS_FW_BK_1 | ALPS_FW_BK_2)) {
-		input_report_key(dev, BTN_FORWARD, forward);
-		input_report_key(dev, BTN_BACK, back);
+		input_report_key(dev, BTN_0, forward);
+		input_report_key(dev, BTN_1, back);
 	}
 
+	if (priv->i->flags & ALPS_EXTRA)
+		input_report_key(dev, BTN_3, packet[0] & 0x20);
+
 	input_sync(dev);
 }
 
@@ -216,9 +230,10 @@ static psmouse_ret_t alps_process_byte(struct psmouse *psmouse)
 	return PSMOUSE_GOOD_DATA;
 }
 
-static const struct alps_model_info *alps_get_model(struct psmouse *psmouse, int *version)
+static struct alps_model_info *alps_get_model(struct psmouse *psmouse, int *version)
 {
 	struct ps2dev *ps2dev = &psmouse->ps2dev;
+	struct alps_model_info *model_info;
 	static const unsigned char rates[] = { 0, 10, 20, 40, 60, 80, 100, 200 };
 	unsigned char param[4];
 	int i;
@@ -268,9 +283,16 @@ static const struct alps_model_info *alps_get_model(struct psmouse *psmouse, int
 
 	for (i = 0; i < ARRAY_SIZE(alps_model_data); i++)
 		if (!memcmp(param, alps_model_data[i].signature,
-			    sizeof(alps_model_data[i].signature)))
-			return alps_model_data + i;
+			    sizeof(alps_model_data[i].signature))) {
+
+			model_info = kmalloc(sizeof(struct alps_model_info),
+				GFP_KERNEL);
 
+			memcpy(model_info, alps_model_data + i,
+				sizeof(struct alps_model_info));
+
+			return model_info;
+		}
 	return NULL;
 }
 
@@ -393,6 +415,25 @@ static int alps_poll(struct psmouse *psmouse)
 	return 0;
 }
 
+static int alps_dmi_flags;
+static int alps_acer_5720_flags(const struct dmi_system_id *d)
+{
+	alps_dmi_flags = ALPS_EXTRA | ALPS_FW_BK_1;
+	return 0;
+}
+
+static struct dmi_system_id alps_dmi_table[] = {
+	{
+	 .callback = alps_acer_5720_flags,
+	 .ident = "Acer Aspire 5720",
+	 .matches = {
+		DMI_MATCH(DMI_BOARD_VENDOR, "Acer"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5720"),
+		},
+	},
+	{}
+};
+
 static int alps_hw_init(struct psmouse *psmouse, int *version)
 {
 	struct alps_data *priv = psmouse->private;
@@ -401,6 +442,10 @@ static int alps_hw_init(struct psmouse *psmouse, int *version)
 	if (!priv->i)
 		return -1;
 
+	dmi_check_system(alps_dmi_table);
+	if (alps_dmi_flags)
+		priv->i->flags = alps_dmi_flags;
+
 	if ((priv->i->flags & ALPS_PASS) &&
 	    alps_passthrough_mode(psmouse, true)) {
 		return -1;
@@ -446,6 +491,7 @@ static void alps_disconnect(struct psmouse *psmouse)
 
 	psmouse_reset(psmouse);
 	input_unregister_device(priv->dev2);
+	kfree(priv->i);
 	kfree(priv);
 }
 
@@ -483,8 +529,13 @@ int alps_init(struct psmouse *psmouse)
 	}
 
 	if (priv->i->flags & (ALPS_FW_BK_1 | ALPS_FW_BK_2)) {
-		dev1->keybit[BIT_WORD(BTN_FORWARD)] |= BIT_MASK(BTN_FORWARD);
-		dev1->keybit[BIT_WORD(BTN_BACK)] |= BIT_MASK(BTN_BACK);
+		dev1->keybit[BIT_WORD(BTN_0)] |= BIT_MASK(BTN_0);
+		dev1->keybit[BIT_WORD(BTN_1)] |= BIT_MASK(BTN_1);
+	}
+
+	if (priv->i->flags & ALPS_EXTRA) {
+		dev1->keybit[BIT_WORD(BTN_2)] |= BIT_MASK(BTN_2);
+		dev1->keybit[BIT_WORD(BTN_3)] |= BIT_MASK(BTN_3);
 	}
 
 	snprintf(priv->phys, sizeof(priv->phys), "%s/input1", psmouse->ps2dev.serio->phys);
diff --git a/drivers/input/mouse/alps.h b/drivers/input/mouse/alps.h
index bc87936..92505d5 100644
--- a/drivers/input/mouse/alps.h
+++ b/drivers/input/mouse/alps.h
@@ -21,7 +21,7 @@ struct alps_model_info {
 struct alps_data {
 	struct input_dev *dev2;		/* Relative device */
 	char phys[32];			/* Phys */
-	const struct alps_model_info *i;/* Info */
+	struct alps_model_info *i;	/* Info */
 	int prev_fin;			/* Finger bit from previous packet */
 };
 
-- 
1.6.3.3



