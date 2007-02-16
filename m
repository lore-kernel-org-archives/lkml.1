Return-Path: <linux-kernel-owner+w=401wt.eu-S1423282AbXBPF2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423282AbXBPF2N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 00:28:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423277AbXBPF2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 00:28:13 -0500
Received: from gateway.insightbb.com ([74.128.0.19]:14773 "EHLO
	asav02.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423282AbXBPF2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 00:28:12 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aj0KAK7P1EVKhRO4UGdsb2JhbACOaAEBKpJ7AQEB
From: Dmitry Torokhov <dtor@insightbb.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/3] Input: psmouse - create PS/2 protocol options for Kconfig
Date: Fri, 16 Feb 2007 00:28:08 -0500
User-Agent: KMail/1.9.3
Cc: Andres Salomon <dilinger@debian.org>, linux-kernel@vger.kernel.org
References: <45D43115.6060806@debian.org> <45D50101.60802@debian.org> <20070215173024.adc54d6c.akpm@linux-foundation.org>
In-Reply-To: <20070215173024.adc54d6c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702160028.09251.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 February 2007 20:30, Andrew Morton wrote:
> On Thu, 15 Feb 2007 19:55:29 -0500
> Andres Salomon <dilinger@debian.org> wrote:
> 
> > Andrew Morton wrote:
> > > On Thu, 15 Feb 2007 05:08:21 -0500
> > > Andres Salomon <dilinger@debian.org> wrote:
> > > 
> > >> Initial framework for disabling PS/2 protocol extensions.  The current
> > >> protocols can only be disabled if CONFIG_EMBEDDED is selected.  No
> > >> source files are changed, merely build stuff.
> > > 
> > > ugleee.  What benefit do we get for all this additional maintenance burden?
> > 
> > On any platform where you know exactly what ps/2 device you'll have
> > plugged in, you can cut the size of psmouse.ko in half by disabling
> > protocol extensions that are not in use.
> 
> hm, saving 4k or so.
> 
> Oh well, let's leave that up to Dmitry.

Yes I do want it. There are some protocols that are unlikely be in common
boxes (OLPC driver, eGalax touchscreen, I also have one driver for a touchpad
from a Chinise manufacturer) that I'd like see in mainline. However I want
to be able to compile them out so psmouse stays manageable size-wise. And
I am not sure where 4K fugure came from - it is more like 40K.

> 
> > For future protocol extension additions, we can add them without making
> > the psmouse driver even larger.  We have one queued up for OLPC's
> > touchpad which we'd like to get included in mainline, and it was made
> > clear that being able to disable protocol extensions was a prerequisite
> > for getting it included.  The OLPC ps/2 protocol extension would be
> > disabled unless CONFIG_EMBEDDED and CONFIG_MOUSE_PS2_OLPC were both enabled.
> > 
> > See http://lkml.org/lkml/2006/9/11/200
> 
> Perhaps a nicer implementation would be to have a separate .c file for each
> variant.
> 

Having completely separate sub-drivers is very hard because of very delicate
PS/2 protocol probing....

What do you think about patch below? It somewhat reduces #ifdef clutter in main
module moving it in .h files...
 
-- 
Dmitry

From: Andres Salomon <dilinger@debian.org>

Input: psmouse - allow disabing certain protocol extensions

Allow ALPS, LOGIPS2PP, LIFEBOOK, TRACKPOINT and TOUCHKIT protocol
extensions the psmouse to be disabled during compilation. This will
allow users save some memory when they certain that they will only
use a certain type of mice.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/mouse/Kconfig        |   61 ++++++++++++++++++++++++
 drivers/input/mouse/Makefile       |    9 ++-
 drivers/input/mouse/alps.h         |   17 +++++-
 drivers/input/mouse/logips2pp.h    |    7 ++
 drivers/input/mouse/psmouse-base.c |   12 ++++
 drivers/input/mouse/synaptics.c    |   92 ++++++++++++++++++++-----------------
 drivers/input/mouse/synaptics.h    |   26 ++++++----
 drivers/input/mouse/touchkit_ps2.h |    7 ++
 drivers/input/mouse/trackpoint.h   |    9 +++
 9 files changed, 182 insertions(+), 58 deletions(-)

Index: work/drivers/input/mouse/Kconfig
===================================================================
--- work.orig/drivers/input/mouse/Kconfig
+++ work/drivers/input/mouse/Kconfig
@@ -37,6 +37,65 @@ config MOUSE_PS2
 	  To compile this driver as a module, choose M here: the
 	  module will be called psmouse.
 
+config MOUSE_PS2_ALPS
+	bool "ALPS PS/2 mouse protocol extension" if EMBEDDED
+	default y
+	depends on MOUSE_PS2
+	---help---
+	  Say Y here if you have an ALPS PS/2 touchpad connected to
+	  your system.
+
+	  If unsure, say Y.
+
+config MOUSE_PS2_LOGIPS2PP
+	bool "Logictech PS/2++ mouse protocol extension" if EMBEDDED
+	default y
+	depends on MOUSE_PS2
+	---help---
+	  Say Y here if you have a Logictech PS/2++ mouse connected to
+	  your system.
+
+	  If unsure, say Y.
+
+config MOUSE_PS2_SYNAPTICS
+	bool "Synaptics PS/2 mouse protocol extension" if EMBEDDED
+	default y
+	depends on MOUSE_PS2
+	---help---
+	  Say Y here if you have a Synaptics PS/2 TouchPad connected to
+	  your system.
+
+	  If unsure, say Y.
+
+config MOUSE_PS2_LIFEBOOK
+	bool "Fujitsu Lifebook PS/2 mouse protocol extension" if EMBEDDED
+	default y
+	depends on MOUSE_PS2
+	---help---
+	  Say Y here if you have a Fujitsu B-series Lifebook PS/2
+	  TouchScreen connected to your system.
+
+	  If unsure, say Y.
+
+config MOUSE_PS2_TRACKPOINT
+	bool "IBM Trackpoint PS/2 mouse protocol extension" if EMBEDDED
+	default y
+	depends on MOUSE_PS2
+	---help---
+	  Say Y here if you have an IBM Trackpoint PS/2 mouse connected
+	  to your system.
+
+	  If unsure, say Y.
+
+config MOUSE_PS2_TOUCHKIT
+	bool "eGalax TouchKit PS/2 protocol extension"
+	depends on MOUSE_PS2
+	---help---
+	  Say Y here if you have an eGalax TouchKit PS/2 touchscreen
+	  connected to your system.
+
+	  If unsure, say N.
+
 config MOUSE_SERIAL
 	tristate "Serial mouse"
 	select SERIO
@@ -118,7 +177,7 @@ config MOUSE_VSXXXAA
 	  digitizer (VSXXX-AB) DEC produced.
 
 config MOUSE_HIL
-	tristate "HIL pointers (mice etc)."     
+	tristate "HIL pointers (mice etc)."
 	depends on GSC || HP300
 	select HP_SDC
 	select HIL_MLC
Index: work/drivers/input/mouse/Makefile
===================================================================
--- work.orig/drivers/input/mouse/Makefile
+++ work/drivers/input/mouse/Makefile
@@ -14,5 +14,10 @@ obj-$(CONFIG_MOUSE_SERIAL)	+= sermouse.o
 obj-$(CONFIG_MOUSE_HIL)		+= hil_ptr.o
 obj-$(CONFIG_MOUSE_VSXXXAA)	+= vsxxxaa.o
 
-psmouse-objs  := psmouse-base.o alps.o logips2pp.o synaptics.o lifebook.o \
-		trackpoint.o touchkit_ps2.o
+psmouse-objs := psmouse-base.o synaptics.o
+
+psmouse-$(CONFIG_MOUSE_PS2_ALPS)	+= alps.o
+psmouse-$(CONFIG_MOUSE_PS2_LOGIPS2PP)	+= logips2pp.o
+psmouse-$(CONFIG_MOUSE_PS2_LIFEBOOK)	+= lifebook.o
+psmouse-$(CONFIG_MOUSE_PS2_TRACKPOINT)	+= trackpoint.o
+psmouse-$(CONFIG_MOUSE_PS2_TOUCHKIT)	+= touchkit_ps2.o
Index: work/drivers/input/mouse/psmouse-base.c
===================================================================
--- work.orig/drivers/input/mouse/psmouse-base.c
+++ work/drivers/input/mouse/psmouse-base.c
@@ -667,12 +667,14 @@ static const struct psmouse_protocol psm
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
@@ -699,6 +701,7 @@ static const struct psmouse_protocol psm
 		.maxproto	= 1,
 		.detect		= im_explorer_detect,
 	},
+#ifdef CONFIG_MOUSE_PS2_SYNAPTICS
 	{
 		.type		= PSMOUSE_SYNAPTICS,
 		.name		= "SynPS/2",
@@ -706,6 +709,8 @@ static const struct psmouse_protocol psm
 		.detect		= synaptics_detect,
 		.init		= synaptics_init,
 	},
+#endif
+#ifdef CONFIG_MOUSE_PS2_ALPS
 	{
 		.type		= PSMOUSE_ALPS,
 		.name		= "AlpsPS/2",
@@ -713,24 +718,31 @@ static const struct psmouse_protocol psm
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
+#ifdef CONFIG_MOUSE_PS2_TOUCHKIT
 	{
 		.type		= PSMOUSE_TOUCHKIT_PS2,
 		.name		= "touchkitPS/2",
 		.alias		= "touchkit",
 		.detect		= touchkit_ps2_detect,
 	},
+#endif
 	{
 		.type		= PSMOUSE_AUTO,
 		.name		= "auto",
Index: work/drivers/input/mouse/alps.h
===================================================================
--- work.orig/drivers/input/mouse/alps.h
+++ work/drivers/input/mouse/alps.h
@@ -12,9 +12,6 @@
 #ifndef _ALPS_H
 #define _ALPS_H
 
-int alps_detect(struct psmouse *psmouse, int set_properties);
-int alps_init(struct psmouse *psmouse);
-
 struct alps_model_info {
         unsigned char signature[3];
         unsigned char byte0, mask0;
@@ -29,4 +26,18 @@ struct alps_data {
 	int prev_fin;			/* Finger bit from previous packet */
 };
 
+#ifdef CONFIG_MOUSE_PS2_ALPS
+int alps_detect(struct psmouse *psmouse, int set_properties);
+int alps_init(struct psmouse *psmouse);
+#else
+inline int alps_detect(struct psmouse *psmouse, int set_properties)
+{
+	return -ENOSYS;
+}
+inline int alps_init(struct psmouse *psmouse);
+{
+	return -ENOSYS;
+}
+#endif /* CONFIG_MOUSE_PS2_ALPS */
+
 #endif
Index: work/drivers/input/mouse/touchkit_ps2.h
===================================================================
--- work.orig/drivers/input/mouse/touchkit_ps2.h
+++ work/drivers/input/mouse/touchkit_ps2.h
@@ -12,6 +12,13 @@
 #ifndef _TOUCHKIT_PS2_H
 #define _TOUCHKIT_PS2_H
 
+#if CONFIG_MOUSE_PS2_TOUCHKIT
 int touchkit_ps2_detect(struct psmouse *psmouse, int set_properties);
+#else
+inline int touchkit_ps2_detect(struct psmouse *psmouse, int set_properties)
+{
+	return -ENOSYS;
+}
+#endif /* CONFIG_MOUSE_PS2_TOUCHKIT */
 
 #endif
Index: work/drivers/input/mouse/trackpoint.h
===================================================================
--- work.orig/drivers/input/mouse/trackpoint.h
+++ work/drivers/input/mouse/trackpoint.h
@@ -142,6 +142,13 @@ struct trackpoint_data
 	unsigned char ext_dev;
 };
 
-extern int trackpoint_detect(struct psmouse *psmouse, int set_properties);
+#if CONFIG_MOUSE_PS2_TRACKPOINT
+int trackpoint_detect(struct psmouse *psmouse, int set_properties);
+#else
+inline int trackpoint_detect(struct psmouse *psmouse, int set_properties)
+{
+	return -ENOSYS;
+}
+#endif /* CONFIG_MOUSE_PS2_TRACKPOINT */
 
 #endif /* _TRACKPOINT_H */
Index: work/drivers/input/mouse/logips2pp.h
===================================================================
--- work.orig/drivers/input/mouse/logips2pp.h
+++ work/drivers/input/mouse/logips2pp.h
@@ -11,6 +11,13 @@
 #ifndef _LOGIPS2PP_H
 #define _LOGIPS2PP_H
 
+#if CONFIG_MOUSE_PS2_LOGIPS2PP
 int ps2pp_init(struct psmouse *psmouse, int set_properties);
+#else
+inline int ps2pp_init(struct psmouse *psmouse, int set_properties)
+{
+	return -ENOSYS;
+}
+#endif /* CONFIG_MOUSE_PS2_LOGIPS2PP */
 
 #endif
Index: work/drivers/input/mouse/synaptics.c
===================================================================
--- work.orig/drivers/input/mouse/synaptics.c
+++ work/drivers/input/mouse/synaptics.c
@@ -40,33 +40,70 @@
 #define YMIN_NOMINAL 1408
 #define YMAX_NOMINAL 4448
 
+
 /*****************************************************************************
- *	Synaptics communications functions
+ *	Stuff we need even when we do not want native Synaptics support
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
 
+int synaptics_detect(struct psmouse *psmouse, int set_properties)
+{
+	struct ps2dev *ps2dev = &psmouse->ps2dev;
+	unsigned char param[4];
+
+	param[0] = 0;
+
+	ps2_command(ps2dev, param, PSMOUSE_CMD_SETRES);
+	ps2_command(ps2dev, param, PSMOUSE_CMD_SETRES);
+	ps2_command(ps2dev, param, PSMOUSE_CMD_SETRES);
+	ps2_command(ps2dev, param, PSMOUSE_CMD_SETRES);
+	ps2_command(ps2dev, param, PSMOUSE_CMD_GETINFO);
+
+	if (param[1] != 0x47)
+		return -ENODEV;
+
+	if (set_properties) {
+		psmouse->vendor = "Synaptics";
+		psmouse->name = "TouchPad";
+	}
+
+	return 0;
+}
+
+void synaptics_reset(struct psmouse *psmouse)
+{
+	/* reset touchpad back to relative mode, gestures enabled */
+	synaptics_mode_cmd(psmouse, 0);
+}
+
+#ifdef CONFIG_MOUSE_PS2_SYNAPTICS
+
+/*****************************************************************************
+ *	Synaptics communications functions
+ ****************************************************************************/
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
@@ -529,12 +566,6 @@ static void set_input_params(struct inpu
 	clear_bit(REL_Y, dev->relbit);
 }
 
-void synaptics_reset(struct psmouse *psmouse)
-{
-	/* reset touchpad back to relative mode, gestures enabled */
-	synaptics_mode_cmd(psmouse, 0);
-}
-
 static void synaptics_disconnect(struct psmouse *psmouse)
 {
 	synaptics_reset(psmouse);
@@ -569,30 +600,6 @@ static int synaptics_reconnect(struct ps
 	return 0;
 }
 
-int synaptics_detect(struct psmouse *psmouse, int set_properties)
-{
-	struct ps2dev *ps2dev = &psmouse->ps2dev;
-	unsigned char param[4];
-
-	param[0] = 0;
-
-	ps2_command(ps2dev, param, PSMOUSE_CMD_SETRES);
-	ps2_command(ps2dev, param, PSMOUSE_CMD_SETRES);
-	ps2_command(ps2dev, param, PSMOUSE_CMD_SETRES);
-	ps2_command(ps2dev, param, PSMOUSE_CMD_SETRES);
-	ps2_command(ps2dev, param, PSMOUSE_CMD_GETINFO);
-
-	if (param[1] != 0x47)
-		return -1;
-
-	if (set_properties) {
-		psmouse->vendor = "Synaptics";
-		psmouse->name = "TouchPad";
-	}
-
-	return 0;
-}
-
 #if defined(__i386__)
 #include <linux/dmi.h>
 static struct dmi_system_id toshiba_dmi_table[] = {
@@ -680,4 +687,5 @@ int synaptics_init(struct psmouse *psmou
 	return -1;
 }
 
+#endif /* CONFIG_MOUSE_PS2_SYNAPTICS */
 
Index: work/drivers/input/mouse/synaptics.h
===================================================================
--- work.orig/drivers/input/mouse/synaptics.h
+++ work/drivers/input/mouse/synaptics.h
@@ -9,10 +9,6 @@
 #ifndef _SYNAPTICS_H
 #define _SYNAPTICS_H
 
-extern int synaptics_detect(struct psmouse *psmouse, int set_properties);
-extern int synaptics_init(struct psmouse *psmouse);
-extern void synaptics_reset(struct psmouse *psmouse);
-
 /* synaptics queries */
 #define SYN_QUE_IDENTIFY		0x00
 #define SYN_QUE_MODES			0x01
@@ -62,9 +58,9 @@ extern void synaptics_reset(struct psmou
 #define SYN_MODE_WMODE(m)		((m) & (1 << 0))
 
 /* synaptics identify query bits */
-#define SYN_ID_MODEL(i) 		(((i) >> 4) & 0x0f)
-#define SYN_ID_MAJOR(i) 		((i) & 0x0f)
-#define SYN_ID_MINOR(i) 		(((i) >> 16) & 0xff)
+#define SYN_ID_MODEL(i)			(((i) >> 4) & 0x0f)
+#define SYN_ID_MAJOR(i)			((i) & 0x0f)
+#define SYN_ID_MINOR(i)			(((i) >> 16) & 0xff)
 #define SYN_ID_IS_SYNAPTICS(i)		((((i) >> 8) & 0xff) == 0x47)
 
 /* synaptics special commands */
@@ -98,8 +94,8 @@ struct synaptics_hw_state {
 struct synaptics_data {
 	/* Data read from the touchpad */
 	unsigned long int model_id;		/* Model-ID */
-	unsigned long int capabilities; 	/* Capabilities */
-	unsigned long int ext_cap; 		/* Extended Capabilities */
+	unsigned long int capabilities;		/* Capabilities */
+	unsigned long int ext_cap;		/* Extended Capabilities */
 	unsigned long int identity;		/* Identification */
 
 	unsigned char pkt_type;			/* packet type - old, new, etc */
@@ -107,4 +103,16 @@ struct synaptics_data {
 	int scroll;
 };
 
+int synaptics_detect(struct psmouse *psmouse, int set_properties);
+void synaptics_reset(struct psmouse *psmouse);
+
+#ifdef CONFIG_MOUSE_PS2_SYNAPTICS
+int synaptics_init(struct psmouse *psmouse);
+#else
+int synaptics_init(struct psmouse *psmouse)
+{
+	return -ENOSYS;
+}
+#endif /* CONFIG_MOUSE_PS2_SYNAPTICS */
+
 #endif /* _SYNAPTICS_H */
