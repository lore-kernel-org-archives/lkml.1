Return-Path: <linux-kernel-owner+w=401wt.eu-S965786AbXBOKeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965786AbXBOKeE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 05:34:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965804AbXBOKeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 05:34:03 -0500
Received: from mail.queued.net ([207.210.101.209]:1464 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965786AbXBOKeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 05:34:01 -0500
X-Greylist: delayed 1550 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Feb 2007 05:34:01 EST
Message-ID: <45D431AF.1040607@debian.org>
Date: Thu, 15 Feb 2007 05:10:55 -0500
From: Andres Salomon <dilinger@debian.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [patch 2/3] Input: psmouse - wrap protocol extensions (except synaptics)
 with ifdefs
Content-Type: multipart/mixed;
 boundary="------------090705070406060900000308"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090705070406060900000308
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Allow ALPS, LOGIPS2PP, LIFEBOOK, and TRACKPOINT protocol extensions (in
the psmouse driver) to be disabled during compilation.  The synaptics
stuff is left alone for now, since it needs special handling for
synaptic pass-through ports.

Signed-off-by: Andres Salomon <dilinger@debian.org>

--------------090705070406060900000308
Content-Type: text/plain;
 name*0="0002-2-3-Input-psmouse-wrap-protocol-extensions-except-synaptics";
 name*1="-with-ifdefs.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0002-2-3-Input-psmouse-wrap-protocol-extensions-except-synap";
 filename*1="tics-with-ifdefs.txt"

diff --git a/drivers/input/mouse/psmouse-base.c b/drivers/input/mouse/psmouse-base.c
index a0e4a03..6b3ac9d 100644
--- a/drivers/input/mouse/psmouse-base.c
+++ b/drivers/input/mouse/psmouse-base.c
@@ -555,6 +555,7 @@ static int psmouse_extensions(struct psmouse *psmouse,
 {
 	int synaptics_hardware = 0;
 
+#ifdef CONFIG_MOUSE_PS2_LIFEBOOK
 /*
  * We always check for lifebook because it does not disturb mouse
  * (it only checks DMI information).
@@ -565,6 +566,7 @@ static int psmouse_extensions(struct psmouse *psmouse,
 				return PSMOUSE_LIFEBOOK;
 		}
 	}
+#endif
 
 /*
  * Try Kensington ThinkingMouse (we try first, because synaptics probe
@@ -596,6 +598,7 @@ static int psmouse_extensions(struct psmouse *psmouse,
 		synaptics_reset(psmouse);
 	}
 
+#ifdef CONFIG_MOUSE_PS2_ALPS
 /*
  * Try ALPS TouchPad
  */
@@ -610,15 +613,20 @@ static int psmouse_extensions(struct psmouse *psmouse,
 			max_proto = PSMOUSE_IMEX;
 		}
 	}
+#endif
 
 	if (max_proto > PSMOUSE_IMEX && genius_detect(psmouse, set_properties) == 0)
 		return PSMOUSE_GENPS;
 
+#ifdef CONFIG_MOUSE_PS2_LOGIPS2PP
 	if (max_proto > PSMOUSE_IMEX && ps2pp_init(psmouse, set_properties) == 0)
 		return PSMOUSE_PS2PP;
+#endif
 
+#ifdef CONFIG_MOUSE_PS2_TRACKPOINT
 	if (max_proto > PSMOUSE_IMEX && trackpoint_detect(psmouse, set_properties) == 0)
 		return PSMOUSE_TRACKPOINT;
+#endif
 
 /*
  * Reset to defaults in case the device got confused by extended
@@ -660,12 +668,14 @@ static const struct psmouse_protocol psmouse_protocols[] = {
 		.maxproto	= 1,
 		.detect		= ps2bare_detect,
 	},
+#ifdef CONFIG_MOUSE_PS2_LOGIPS2PP
 	{
 		.type		= PSMOUSE_PS2PP,
 		.name		= "PS2++",
 		.alias		= "logitech",
 		.detect		= ps2pp_init,
 	},
+#endif
 	{
 		.type		= PSMOUSE_THINKPS,
 		.name		= "ThinkPS/2",
@@ -699,6 +709,7 @@ static const struct psmouse_protocol psmouse_protocols[] = {
 		.detect		= synaptics_detect,
 		.init		= synaptics_init,
 	},
+#ifdef CONFIG_MOUSE_PS2_ALPS
 	{
 		.type		= PSMOUSE_ALPS,
 		.name		= "AlpsPS/2",
@@ -706,18 +717,23 @@ static const struct psmouse_protocol psmouse_protocols[] = {
 		.detect		= alps_detect,
 		.init		= alps_init,
 	},
+#endif
+#ifdef CONFIG_MOUSE_PS2_LIFEBOOK
 	{
 		.type		= PSMOUSE_LIFEBOOK,
 		.name		= "LBPS/2",
 		.alias		= "lifebook",
 		.init		= lifebook_init,
 	},
+#endif
+#ifdef CONFIG_MOUSE_PS2_TRACKPOINT
 	{
 		.type		= PSMOUSE_TRACKPOINT,
 		.name		= "TPPS/2",
 		.alias		= "trackpoint",
 		.detect		= trackpoint_detect,
 	},
+#endif
 	{
 		.type		= PSMOUSE_AUTO,
 		.name		= "auto",
-- 
1.4.4.2


--------------090705070406060900000308--
