Return-Path: <linux-kernel-owner+w=401wt.eu-S1753911AbYCPUOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbYCPUOU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 16:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbYCPUON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 16:14:13 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:45157 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752503AbYCPUON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 16:14:13 -0400
X-Sasl-enc: 2ZnFdetpG0Qfrg8Rmmq8e5H1aEPx7z1ZZv6WDEfUL5gy 1205698451
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel@vger.kernel.org
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Dmitry Torokhov <dtor@mail.ru>, Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH] Input: add flags bitfield
Date: Sun, 16 Mar 2008 17:14:11 -0300
Message-Id: <1205698451-1640-1-git-send-email-hmh@hmh.eng.br>
X-Mailer: git-send-email 1.5.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a flags bitfield to the input_dev structure, which can be used for
internal coordination among kernel input devices and input handlers without
the need to use ever-expanding blacklists on the input handlers.

Add initial flag bits which allows an input driver to request that joystick
emulation (joydev) or mouse emulation (mousedev) not be attached to an
input device.

This will be used by accelerometer drivers exporting a raw interface which
is not to be used as a joystick device (not to confuse this with the usual
fuzzed joystick interface these drivers export for enhanced Neverball
productivity), for example.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/input/joydev.c   |    3 +++
 drivers/input/mousedev.c |    3 +++
 include/linux/input.h    |   10 ++++++++++
 3 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/input/joydev.c b/drivers/input/joydev.c
index 22b2789..3837389 100644
--- a/drivers/input/joydev.c
+++ b/drivers/input/joydev.c
@@ -727,6 +727,9 @@ static int joydev_connect(struct input_handler *handler, struct input_dev *dev,
 	int i, j, t, minor;
 	int error;
 
+	if (dev->flags & EV_F_NOJOYSTICK)
+		return -ENODEV;
+
 	for (minor = 0; minor < JOYDEV_MINORS; minor++)
 		if (!joydev_table[minor])
 			break;
diff --git a/drivers/input/mousedev.c b/drivers/input/mousedev.c
index bbbe5e8..716975f 100644
--- a/drivers/input/mousedev.c
+++ b/drivers/input/mousedev.c
@@ -962,6 +962,9 @@ static int mousedev_connect(struct input_handler *handler,
 	int minor;
 	int error;
 
+	if (dev->flags & EV_F_NOMOUSE)
+		return -ENODEV;
+
 	for (minor = 0; minor < MOUSEDEV_MINORS; minor++)
 		if (!mousedev_table[minor])
 			break;
diff --git a/include/linux/input.h b/include/linux/input.h
index 1bdc39a..a5654fe 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -951,12 +951,20 @@ struct ff_effect {
 #include <linux/timer.h>
 #include <linux/mod_devicetable.h>
 
+/*
+ * input device special flags
+ */
+
+#define EV_F_NOMOUSE		0x0001	/* Do not attach mousedev */
+#define EV_F_NOJOYSTICK		0x0002	/* Do not attach joydev */
+
 /**
  * struct input_dev - represents an input device
  * @name: name of the device
  * @phys: physical path to the device in the system hierarchy
  * @uniq: unique identification code for the device (if device has it)
  * @id: id of the device (struct input_id)
+ * @flags: bitmap of special flags (EV_F_*)
  * @evbit: bitmap of types of events supported by the device (EV_KEY,
  *	EV_REL, etc.)
  * @keybit: bitmap of keys/buttons this device has
@@ -1034,6 +1042,8 @@ struct input_dev {
 	const char *uniq;
 	struct input_id id;
 
+	unsigned long flags;
+
 	unsigned long evbit[BITS_TO_LONGS(EV_CNT)];
 	unsigned long keybit[BITS_TO_LONGS(KEY_CNT)];
 	unsigned long relbit[BITS_TO_LONGS(REL_CNT)];
-- 
1.5.4.4

