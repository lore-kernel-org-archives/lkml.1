Return-Path: <linux-kernel-owner+w=401wt.eu-S965805AbXBOKeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965805AbXBOKeg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 05:34:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965804AbXBOKeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 05:34:07 -0500
Received: from mail.queued.net ([207.210.101.209]:1466 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965803AbXBOKeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 05:34:01 -0500
Message-ID: <45D43232.2070100@debian.org>
Date: Thu, 15 Feb 2007 05:13:06 -0500
From: Andres Salomon <dilinger@debian.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [patch 3/3] Input: psmouse - allow disabling of synaptics protocol
 extension
Content-Type: multipart/mixed;
 boundary="------------060908090104070004010001"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060908090104070004010001
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Allow disabling of synaptics via CONFIG_MOUSE_PS2_SYNAPTICS;
we leave synaptic_detect and synaptic_reset (for synaptics hardware
that emulates other protocols), but get rid of synaptic_init.

Signed-off-by: Andres Salomon <dilinger@debian.org>

--------------060908090104070004010001
Content-Type: text/plain;
 name*0="0003-3-3-Input-psmouse-allow-disabling-of-synaptics-protocol-ext";
 name*1="ension.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0003-3-3-Input-psmouse-allow-disabling-of-synaptics-protocol";
 filename*1="-extension.txt"

diff --git a/drivers/input/mouse/psmouse-base.c b/drivers/input/mouse/psmouse-base.c
index 6b3ac9d..bfb47e1 100644
--- a/drivers/input/mouse/psmouse-base.c
+++ b/drivers/input/mouse/psmouse-base.c
@@ -583,8 +583,11 @@ static int psmouse_extensions(struct psmouse *psmouse,
 		synaptics_hardware = 1;
 
 		if (max_proto > PSMOUSE_IMEX) {
+#ifdef CONFIG_MOUSE_PS2_SYNAPTICS
 			if (!set_properties || synaptics_init(psmouse) == 0)
 				return PSMOUSE_SYNAPTICS;
+#endif
+
 /*
  * Some Synaptics touchpads can emulate extended protocols (like IMPS/2).
  * Unfortunately Logitech/Genius probes confuse some firmware versions so
@@ -702,6 +705,7 @@ static const struct psmouse_protocol psmouse_protocols[] = {
 		.maxproto	= 1,
 		.detect		= im_explorer_detect,
 	},
+#ifdef CONFIG_MOUSE_PS2_SYNAPTICS
 	{
 		.type		= PSMOUSE_SYNAPTICS,
 		.name		= "SynPS/2",
@@ -709,6 +713,7 @@ static const struct psmouse_protocol psmouse_protocols[] = {
 		.detect		= synaptics_detect,
 		.init		= synaptics_init,
 	},
+#endif
 #ifdef CONFIG_MOUSE_PS2_ALPS
 	{
 		.type		= PSMOUSE_ALPS,
diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 49ac696..5d69f52 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -45,28 +45,30 @@
  ****************************************************************************/
 
 /*
- * Send a command to the synpatics touchpad by special commands
+ * Set the synaptics touchpad mode byte by special commands
  */
-static int synaptics_send_cmd(struct psmouse *psmouse, unsigned char c, unsigned char *param)
+static int synaptics_mode_cmd(struct psmouse *psmouse, unsigned char mode)
 {
-	if (psmouse_sliced_command(psmouse, c))
+	unsigned char param[1];
+
+	if (psmouse_sliced_command(psmouse, mode))
 		return -1;
-	if (ps2_command(&psmouse->ps2dev, param, PSMOUSE_CMD_GETINFO))
+	param[0] = SYN_PS_SET_MODE2;
+	if (ps2_command(&psmouse->ps2dev, param, PSMOUSE_CMD_SETRATE))
 		return -1;
 	return 0;
 }
 
+#ifdef CONFIG_MOUSE_PS2_SYNAPTICS
+
 /*
- * Set the synaptics touchpad mode byte by special commands
+ * Send a command to the synpatics touchpad by special commands
  */
-static int synaptics_mode_cmd(struct psmouse *psmouse, unsigned char mode)
+static int synaptics_send_cmd(struct psmouse *psmouse, unsigned char c, unsigned char *param)
 {
-	unsigned char param[1];
-
-	if (psmouse_sliced_command(psmouse, mode))
+	if (psmouse_sliced_command(psmouse, c))
 		return -1;
-	param[0] = SYN_PS_SET_MODE2;
-	if (ps2_command(&psmouse->ps2dev, param, PSMOUSE_CMD_SETRATE))
+	if (ps2_command(&psmouse->ps2dev, param, PSMOUSE_CMD_GETINFO))
 		return -1;
 	return 0;
 }
@@ -529,12 +531,16 @@ static void set_input_params(struct input_dev *dev, struct synaptics_data *priv)
 	clear_bit(REL_Y, dev->relbit);
 }
 
+#endif /* CONFIG_MOUSE_PS2_SYNAPTICS */
+
 void synaptics_reset(struct psmouse *psmouse)
 {
 	/* reset touchpad back to relative mode, gestures enabled */
 	synaptics_mode_cmd(psmouse, 0);
 }
 
+#ifdef CONFIG_MOUSE_PS2_SYNAPTICS
+
 static void synaptics_disconnect(struct psmouse *psmouse)
 {
 	synaptics_reset(psmouse);
@@ -569,6 +575,8 @@ static int synaptics_reconnect(struct psmouse *psmouse)
 	return 0;
 }
 
+#endif /* CONFIG_MOUSE_PS2_SYNAPTICS */
+
 int synaptics_detect(struct psmouse *psmouse, int set_properties)
 {
 	struct ps2dev *ps2dev = &psmouse->ps2dev;
@@ -593,6 +601,8 @@ int synaptics_detect(struct psmouse *psmouse, int set_properties)
 	return 0;
 }
 
+#ifdef CONFIG_MOUSE_PS2_SYNAPTICS
+
 #if defined(__i386__)
 #include <linux/dmi.h>
 static struct dmi_system_id toshiba_dmi_table[] = {
@@ -679,4 +689,4 @@ int synaptics_init(struct psmouse *psmouse)
 	return -1;
 }
 
-
+#endif /* CONFIG_MOUSE_PS2_SYNAPTICS */
-- 
1.4.4.2


--------------060908090104070004010001--
