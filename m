Return-Path: <linux-kernel-owner+w=401wt.eu-S1757560AbYHASUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560AbYHASUm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 14:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbYHASUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 14:20:34 -0400
Received: from mail.queued.net ([207.210.101.209]:2666 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727AbYHASUd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 14:20:33 -0400
Date: Fri, 1 Aug 2008 14:20:04 -0400
From: Andres Salomon <dilinger@queued.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: dtor@mail.ru, linux-input@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] OLPC: psmouse: touchpad driver
Message-ID: <20080801142004.2d3d1349@fred>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This adds support for OLPC's touchpad.  It has lots of neat features,
none of which are enabled because the hardware is too buggy.  Instead,
we use it like a normal touchpad, but with a number of workarounds in
place to deal with the frequent hardware spasms.  Humidity changes,
sweat, tinfoil underwear, plugging in AC, drinks, evil felines.. All
tend to cause the touchpad to freak out.

Stuff like this keeps me from getting bored.

>From psmouse-base, we use psmouse_set_state quite a bit, as well
as piggy-backing off of kpsmoused_wq; so, this also makes those
available to protocol extensions.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/input/mouse/Kconfig        |    9 +
 drivers/input/mouse/Makefile       |    1 +
 drivers/input/mouse/olpc.c         |  492 ++++++++++++++++++++++++++++++++++++
 drivers/input/mouse/olpc.h         |   48 ++++
 drivers/input/mouse/psmouse-base.c |   27 ++-
 drivers/input/mouse/psmouse.h      |    3 +
 6 files changed, 577 insertions(+), 3 deletions(-)
 create mode 100644 drivers/input/mouse/olpc.c
 create mode 100644 drivers/input/mouse/olpc.h

diff --git a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
index 7bbea09..b34ca8e 100644
--- a/drivers/input/mouse/Kconfig
+++ b/drivers/input/mouse/Kconfig
@@ -96,6 +96,15 @@ config MOUSE_PS2_TOUCHKIT
 
 	  If unsure, say N.
 
+config MOUSE_PS2_OLPC
+	bool "OLPC PS/2 mouse protocol extension"
+	depends on MOUSE_PS2 && OLPC
+	help
+	  Say Y here if you have an OLPC XO-1 laptop (with built-in
+	  PS/2 touchpad/tablet device).
+
+	  If unsure, say N.
+
 config MOUSE_SERIAL
 	tristate "Serial mouse"
 	select SERIO
diff --git a/drivers/input/mouse/Makefile b/drivers/input/mouse/Makefile
index 9e6e363..f4654ce 100644
--- a/drivers/input/mouse/Makefile
+++ b/drivers/input/mouse/Makefile
@@ -24,3 +24,4 @@ psmouse-$(CONFIG_MOUSE_PS2_LOGIPS2PP)	+= logips2pp.o
 psmouse-$(CONFIG_MOUSE_PS2_LIFEBOOK)	+= lifebook.o
 psmouse-$(CONFIG_MOUSE_PS2_TRACKPOINT)	+= trackpoint.o
 psmouse-$(CONFIG_MOUSE_PS2_TOUCHKIT)	+= touchkit_ps2.o
+psmouse-$(CONFIG_MOUSE_PS2_OLPC)	+= olpc.o
diff --git a/drivers/input/mouse/olpc.c b/drivers/input/mouse/olpc.c
new file mode 100644
index 0000000..4ecd92a
--- /dev/null
+++ b/drivers/input/mouse/olpc.c
@@ -0,0 +1,492 @@
+/*
+ * OLPC XO-1 touchpad PS/2 mouse driver
+ *
+ * Copyright (c) 2006-2008 One Laptop Per Child
+ * Authors:
+ *   Zephaniah E. Hull
+ *   Andres Salomon <dilinger@debian.org>
+ *
+ * This driver is partly based on the ALPS driver, which is:
+ *
+ * Copyright (c) 2003 Neil Brown <neilb@cse.unsw.edu.au>
+ * Copyright (c) 2003-2005 Peter Osterlund <petero2@telia.com>
+ * Copyright (c) 2004 Dmitry Torokhov <dtor@mail.ru>
+ * Copyright (c) 2005 Vojtech Pavlik <vojtech@suse.cz>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/*
+ * The spec from ALPS is available from
+ * <http://wiki.laptop.org/go/Touch_Pad/Tablet>.  It refers to this
+ * device as HGPK (Hybrid GS, PT, and Keymatrix).
+ *
+ * The earliest versions of the device had simultaneous reporting; that
+ * was removed.  After that, the device used the Advanced Mode GS/PT streaming
+ * stuff.  That turned out to be too buggy to support, so we've finally
+ * switched to Mouse Mode (which utilizes only the center 1/3 of the touchpad).
+ */
+
+#define DEBUG
+#include <linux/input.h>
+#include <linux/serio.h>
+#include <linux/libps2.h>
+#include <linux/delay.h>
+#include <asm/olpc.h>
+
+#include "psmouse.h"
+#include "olpc.h"
+
+static int tpdebug;
+module_param(tpdebug, int, 0644);
+MODULE_PARM_DESC(tpdebug, "enable debugging, dumping packets to KERN_DEBUG.");
+
+static int recalib_delta = 100;
+module_param(recalib_delta, int, 0644);
+MODULE_PARM_DESC(recalib_delta,
+	"packets containing a delta this large will cause a recalibration.");
+
+/*
+ * When the touchpad gets ultra-sensitive, one can keep their finger 1/2"
+ * above the pad and still have it send packets.  This causes a jump cursor
+ * when one places their finger on the pad.  We can probably detect the
+ * jump as we see a large deltas (>= 100px).  In mouse mode, I've been
+ * unable to even come close to 100px deltas during normal usage, so I think
+ * this threshold is safe.  If a large delta occurs, trigger a recalibration.
+ */
+static void hgpk_jumpy_hack(struct psmouse *psmouse, int x, int y)
+{
+	struct hgpk_data *priv = psmouse->private;
+
+	if (abs(x) > recalib_delta || abs(y) > recalib_delta) {
+		hgpk_err(psmouse, ">%dpx jump detected (%d,%d)\n",
+				recalib_delta, x, y);
+		/* My car gets forty rods to the hogshead and that's the
+		 * way I likes it! */
+		queue_delayed_work(kpsmoused_wq, &priv->recalib_wq,
+				msecs_to_jiffies(1000));
+	}
+}
+
+/*
+ * We have no idea why this particular hardware bug occurs.  The touchpad
+ * will randomly start spewing packets without anything touching the
+ * pad.  This wouldn't necessarily be bad, but it's indicative of a
+ * severely miscalibrated pad; attempting to use the touchpad while it's
+ * spewing means the cursor will jump all over the place, and act "drunk".
+ *
+ * The packets that are spewed tend to all have deltas between -2 and 2, and
+ * the cursor will move around without really going very far.  It will
+ * tend to end up in the same location; if we tally up the changes over
+ * 100 packets, we end up w/ a final delta of close to 0.  This happens
+ * pretty regularly when the touchpad is spewing, and is pretty hard to
+ * manually trigger (at least for *my* fingers).  So, it makes a perfect
+ * scheme for detecting spews.
+ */
+static void hgpk_spewing_hack(struct psmouse *psmouse, int l, int r, int x,
+		int y)
+{
+	struct hgpk_data *priv = psmouse->private;
+	static int count;
+	static int x_tally;
+	static int y_tally;
+
+	/* ignore button press packets; many in a row could trigger
+	 * a false-positive! */
+	if (l || r)
+		return;
+
+	count++;
+	x_tally += x;
+	y_tally += y;
+	if (count > 100) {
+		if (abs(x_tally) < 3 && abs(y_tally) < 3) {
+			hgpk_dbg(psmouse, "packet spew detected (%d,%d). :(\n",
+					x_tally, y_tally);
+			queue_delayed_work(kpsmoused_wq, &priv->recalib_wq,
+					msecs_to_jiffies(1000));
+		}
+		/* reset every 100 packets */
+		count = 0;
+		x_tally = 0;
+		y_tally = 0;
+	}
+}
+
+/*
+ * HGPK Mouse Mode format (standard mouse format, sans middle button)
+ *
+ * byte 0:	y-over	x-over	y-neg	x-neg	1	0	swr	swl
+ * byte 1:	x7	x6	x5	x4	x3	x2	x1	x0
+ * byte 2:	y7	y6	y5	y4	y3	y2	y1	y0
+ *
+ * swr/swl are the left/right buttons.
+ * x-neg/y-neg are the x and y delta negative bits
+ * x-over/y-over are the x and y overflow bits
+ */
+static int hgpk_validate_byte(unsigned char *packet)
+{
+	if (!(packet[0] & (1<<3)) || (packet[0] & (1<<2)))
+		return -1;
+
+	return 0;
+}
+
+static void hgpk_process_packet(struct psmouse *psmouse)
+{
+	struct input_dev *dev = psmouse->dev;
+	unsigned char *packet = psmouse->packet;
+	int x, y, left, right;
+
+	left = packet[0] & 1;
+	right = (packet[0] >> 1) & 1;
+
+	x = packet[1] - ((packet[0] << 4) & 0x100);
+	y = ((packet[0] << 3) & 0x100) - packet[2];
+
+	hgpk_jumpy_hack(psmouse, x, y);
+	hgpk_spewing_hack(psmouse, left, right, x, y);
+
+	if (tpdebug)
+		hgpk_dbg(psmouse, "l=%d r=%d x=%d y=%d\n", left, right, x, y);
+
+	input_report_key(dev, BTN_LEFT, left);
+	input_report_key(dev, BTN_RIGHT, right);
+
+	input_report_rel(dev, REL_X, x);
+	input_report_rel(dev, REL_Y, y);
+
+	input_sync(dev);
+}
+
+static psmouse_ret_t hgpk_process_byte(struct psmouse *psmouse)
+{
+	struct hgpk_data *priv = psmouse->private;
+
+	if (hgpk_validate_byte(psmouse->packet)) {
+		hgpk_dbg(psmouse, "%s: (%d) %02x %02x %02x\n",
+				__func__, psmouse->pktcnt, psmouse->packet[0],
+				psmouse->packet[1], psmouse->packet[2]);
+		return PSMOUSE_BAD_DATA;
+	}
+
+	if (psmouse->pktcnt >= psmouse->pktsize) {
+		hgpk_process_packet(psmouse);
+		return PSMOUSE_FULL_PACKET;
+	}
+
+	if (priv->recalib_window) {
+		if (time_before(jiffies, priv->recalib_window)) {
+			/*
+			 * ugh, got a packet inside our recalibration
+			 * window, schedule another recalibration.
+			 */
+			hgpk_dbg(psmouse, "packet inside calibration window, queueing another recalibration\n");
+			queue_delayed_work(kpsmoused_wq, &priv->recalib_wq,
+					msecs_to_jiffies(1000));
+		}
+		priv->recalib_window = 0;
+	}
+
+	return PSMOUSE_GOOD_DATA;
+}
+
+static int hgpk_force_recalibrate(struct psmouse *psmouse)
+{
+	struct ps2dev *ps2dev = &psmouse->ps2dev;
+	struct hgpk_data *priv = psmouse->private;
+
+	/* C-series touchpads added the recalibrate command */
+	if (psmouse->model < HGPK_MODEL_C)
+		return 0;
+
+	/* we don't want to race with the irq handler, nor with resyncs */
+	psmouse_set_state(psmouse, PSMOUSE_INITIALIZING);
+
+	/* start by resetting the device */
+	psmouse_reset(psmouse);
+
+	/* send the recalibrate request */
+	if (ps2_command(ps2dev, NULL, 0xf5) ||
+			ps2_command(ps2dev, NULL, 0xf5) ||
+			ps2_command(ps2dev, NULL, 0xe6) ||
+			ps2_command(ps2dev, NULL, 0xf5))
+		return -1;
+
+
+	/* according to ALPS, 150mS is required for recalibration */
+	msleep(150);
+
+	/* XXX: If a finger is down during this delay, recalibration will
+	 * detect capacitance incorrectly.  This is a hardware bug, and
+	 * we don't have a good way to deal with it.  The 2s window stuff
+	 * (below) is our best option for now.
+	 */
+
+	if (ps2_command(ps2dev, NULL, PSMOUSE_CMD_ENABLE))
+		return -1;
+
+	psmouse_set_state(psmouse, PSMOUSE_ACTIVATED);
+
+	/* After we recalibrate, we shouldn't get any packets for 2s.  If
+	 * we do, it's likely that someone's finger was on the touchpad.
+	 * If someone's finger *was* on the touchpad, it's probably
+	 * miscalibrated.  So, we should schedule another recalibration
+	 */
+	priv->recalib_window = jiffies +  msecs_to_jiffies(2000);
+
+	return 0;
+}
+
+/*
+ * This kills power to the touchpad; according to ALPS, current consumption
+ * goes down to 50uA after running this.  To turn power back on, we drive
+ * MS-DAT low.
+ */
+static int hgpk_toggle_power(struct psmouse *psmouse, int enable)
+{
+	struct ps2dev *ps2dev = &psmouse->ps2dev;
+	int timeo;
+
+	/* Added on D-series touchpads */
+	if (psmouse->model < HGPK_MODEL_D)
+		return 0;
+
+	if (enable) {
+		psmouse_set_state(psmouse, PSMOUSE_INITIALIZING);
+
+		/*
+		 * Sending a byte will drive MS-DAT low; this will wake up
+		 * the controller.  Once we get an ACK back from it, it
+		 * means we can continue with the touchpad re-init.  ALPS
+		 * tells us that 1s should be long enough, so set that as
+		 * the upper bound.
+		 */
+		for (timeo = 20; timeo > 0; timeo--) {
+			if (!ps2_sendbyte(&psmouse->ps2dev,
+					PSMOUSE_CMD_DISABLE, 20))
+				break;
+			msleep(50);
+		}
+
+		psmouse_reset(psmouse);
+
+	} else {
+		hgpk_dbg(psmouse, "Powering off touchpad.\n");
+		psmouse_set_state(psmouse, PSMOUSE_IGNORE);
+
+		if (ps2_command(ps2dev, NULL, 0xec) ||
+				ps2_command(ps2dev, NULL, 0xec) ||
+				ps2_command(ps2dev, NULL, 0xea))
+			return -1;
+		/* probably won't see an ACK, the touchpad will be off */
+		ps2_sendbyte(&psmouse->ps2dev, 0xec, 20);
+	}
+
+	return 0;
+}
+
+static int hgpk_poll(struct psmouse *psmouse)
+{
+	/* We can't poll, so always return failure. */
+	return -1;
+}
+
+static int hgpk_reconnect(struct psmouse *psmouse)
+{
+	if (olpc_board_at_least(olpc_board(0xb2)))
+		if (psmouse->ps2dev.serio->dev.power.power_state.event !=
+				PM_EVENT_ON)
+			return 0;
+
+	psmouse_reset(psmouse);
+	return 0;
+}
+
+static ssize_t hgpk_show_powered(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct serio *serio = to_serio_port(dev);
+	struct psmouse *psmouse;
+	struct hgpk_data *priv;
+	int retval;
+
+	retval = serio_pin_driver(serio);
+	if (retval)
+		return retval;
+
+	psmouse = serio_get_drvdata(serio);
+	priv = psmouse->private;
+
+	retval = sprintf(buf, "%d\n", priv->powered);
+	serio_unpin_driver(serio);
+	return retval;
+}
+
+static ssize_t hgpk_set_powered(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct serio *serio = to_serio_port(dev);
+	struct psmouse *psmouse;
+	struct hgpk_data *priv;
+	unsigned long val;
+	int retval;
+
+	if (*buf == '1')
+		val = 1;
+	else if (*buf == '0')
+		val = 0;
+	else
+		return -EINVAL;
+
+	retval = serio_pin_driver(serio);
+	if (retval)
+		return retval;
+
+	psmouse = serio_get_drvdata(serio);
+	priv = psmouse->private;
+
+	if (val == priv->powered)
+		goto done;
+
+	/* hgpk_toggle_power will deal w/ state so we're not racing w/ irq */
+	retval = hgpk_toggle_power(psmouse, val);
+	if (!retval)
+		priv->powered = val;
+
+done:
+	serio_unpin_driver(serio);
+	return retval ? retval : count;
+}
+
+static DEVICE_ATTR(powered, S_IWUSR | S_IRUGO, hgpk_show_powered,
+		hgpk_set_powered);
+
+static void hgpk_disconnect(struct psmouse *psmouse)
+{
+	struct hgpk_data *priv = psmouse->private;
+
+	device_remove_file(&psmouse->ps2dev.serio->dev, &dev_attr_powered);
+	psmouse_reset(psmouse);
+	flush_scheduled_work();
+	kfree(priv);
+}
+
+static void hgpk_recalib_work(struct work_struct *work)
+{
+	struct delayed_work *w = container_of(work, struct delayed_work, work);
+	struct hgpk_data *priv = container_of(w, struct hgpk_data, recalib_wq);
+	struct psmouse *psmouse = priv->psmouse;
+
+	hgpk_dbg(psmouse, "recalibrating touchpad..\n");
+
+	if (hgpk_force_recalibrate(psmouse))
+		hgpk_err(psmouse, "recalibration failed!\n");
+}
+
+static int hgpk_init(struct psmouse *psmouse)
+{
+	struct input_dev *dev = psmouse->dev;
+	int err;
+
+	/* unset the things that psmouse-base sets which we don't have */
+	clear_bit(BTN_MIDDLE, dev->keybit);
+
+	/* set the things we do have */
+	set_bit(EV_KEY, dev->evbit);
+	set_bit(EV_REL, dev->evbit);
+
+	set_bit(REL_X, dev->relbit);
+	set_bit(REL_Y, dev->relbit);
+
+	set_bit(BTN_LEFT, dev->keybit);
+	set_bit(BTN_RIGHT, dev->keybit);
+
+	/* register handlers */
+	psmouse->protocol_handler = hgpk_process_byte;
+	psmouse->poll = hgpk_poll;
+	psmouse->disconnect = hgpk_disconnect;
+	psmouse->reconnect = hgpk_reconnect;
+	psmouse->pktsize = 3;
+
+	/* Disable the idle resync. */
+	psmouse->resync_time = 0;
+	/* Reset after a lot of bad bytes. */
+	psmouse->resetafter = 1024;
+
+	err = device_create_file(&psmouse->ps2dev.serio->dev,
+			&dev_attr_powered);
+	if (err)
+		hgpk_err(psmouse, "Failed to create sysfs attribute\n");
+
+	return err;
+}
+
+int olpc_init(struct psmouse *psmouse)
+{
+	struct hgpk_data *priv;
+	int err = -ENOMEM;
+
+	priv = kzalloc(sizeof(struct hgpk_data), GFP_KERNEL);
+	if (!priv)
+		goto alloc_fail;
+
+	psmouse->private = priv;
+	priv->psmouse = psmouse;
+	priv->powered = 1;
+	INIT_DELAYED_WORK(&priv->recalib_wq, hgpk_recalib_work);
+
+	err = psmouse_reset(psmouse);
+	if (err)
+		goto init_fail;
+	err = hgpk_init(psmouse);
+	if (err)
+		goto init_fail;
+
+	return 0;
+
+init_fail:
+	kfree(priv);
+alloc_fail:
+	return err;
+}
+
+static enum hgpk_model_t hgpk_get_model(struct psmouse *psmouse)
+{
+	struct ps2dev *ps2dev = &psmouse->ps2dev;
+	unsigned char param[3];
+
+	/* E7, E7, E7, E9 gets us a 3 byte identifier */
+	if (ps2_command(ps2dev,  NULL, PSMOUSE_CMD_SETSCALE21) ||
+			ps2_command(ps2dev,  NULL, PSMOUSE_CMD_SETSCALE21) ||
+			ps2_command(ps2dev,  NULL, PSMOUSE_CMD_SETSCALE21) ||
+			ps2_command(ps2dev, param, PSMOUSE_CMD_GETINFO))
+		return -EIO;
+
+	hgpk_dbg(psmouse, "ID: %02x %02x %02x", param[0], param[1], param[2]);
+
+	/* HGPK signature: 0x67, 0x00, 0x<model> */
+	if (param[0] != 0x67 || param[1] != 0x00)
+		return -ENODEV;
+
+	hgpk_info(psmouse, "OLPC touchpad revision 0x%x\n", param[2]);
+	return param[2];
+}
+
+int olpc_detect(struct psmouse *psmouse, int set_properties)
+{
+	int version;
+
+	version = hgpk_get_model(psmouse);
+	if (version < 0)
+		return version;
+
+	if (set_properties) {
+		psmouse->vendor = "ALPS";
+		psmouse->name = "HGPK";
+		psmouse->model = version;
+	}
+	return 0;
+}
diff --git a/drivers/input/mouse/olpc.h b/drivers/input/mouse/olpc.h
new file mode 100644
index 0000000..ab860f4
--- /dev/null
+++ b/drivers/input/mouse/olpc.h
@@ -0,0 +1,48 @@
+/*
+ * OLPC touchpad PS/2 mouse driver
+ */
+
+#ifndef _OLPC_H
+#define _OLPC_H
+
+enum hgpk_model_t {
+	HGPK_MODEL_PREA = 0x0a,	/* pre-B1s */
+	HGPK_MODEL_A = 0x14,	/* found on B1s, PT disabled in hardware */
+	HGPK_MODEL_B = 0x28,	/* B2s, has capacitance issues */
+	HGPK_MODEL_C = 0x3c,
+	HGPK_MODEL_D = 0x50,	/* C1, mass production */
+};
+
+struct hgpk_data {
+	struct psmouse *psmouse;
+	int powered;
+	unsigned long recalib_window;
+	struct delayed_work recalib_wq;
+};
+
+#define hgpk_dbg(psmouse, format, arg...)		\
+	dev_dbg(&(psmouse)->ps2dev.serio->dev, format, ## arg)
+#define hgpk_err(psmouse, format, arg...)		\
+	dev_err(&(psmouse)->ps2dev.serio->dev, format, ## arg)
+#define hgpk_info(psmouse, format, arg...)		\
+	dev_info(&(psmouse)->ps2dev.serio->dev, format, ## arg)
+#define hgpk_warn(psmouse, format, arg...)		\
+	dev_warn(&(psmouse)->ps2dev.serio->dev, format, ## arg)
+#define hgpk_notice(psmouse, format, arg...)		\
+	dev_notice(&(psmouse)->ps2dev.serio->dev, format, ## arg)
+
+#ifdef CONFIG_MOUSE_PS2_OLPC
+int olpc_detect(struct psmouse *psmouse, int set_properties);
+int olpc_init(struct psmouse *psmouse);
+#else
+static inline int olpc_detect(struct psmouse *psmouse, int set_properties)
+{
+	return -ENODEV;
+}
+static inline int olpc_init(struct psmouse *psmouse)
+{
+	return -ENODEV;
+}
+#endif
+
+#endif
diff --git a/drivers/input/mouse/psmouse-base.c b/drivers/input/mouse/psmouse-base.c
index f5a6be1..ab48e9a 100644
--- a/drivers/input/mouse/psmouse-base.c
+++ b/drivers/input/mouse/psmouse-base.c
@@ -25,6 +25,7 @@
 #include "synaptics.h"
 #include "logips2pp.h"
 #include "alps.h"
+#include "olpc.h"
 #include "lifebook.h"
 #include "trackpoint.h"
 #include "touchkit_ps2.h"
@@ -102,7 +103,7 @@ static struct attribute_group psmouse_attribute_group = {
  */
 static DEFINE_MUTEX(psmouse_mutex);
 
-static struct workqueue_struct *kpsmoused_wq;
+struct workqueue_struct *kpsmoused_wq;
 
 struct psmouse_protocol {
 	enum psmouse_type type;
@@ -220,7 +221,7 @@ static inline void __psmouse_set_state(struct psmouse *psmouse, enum psmouse_sta
  * is not a concern.
  */
 
-static void psmouse_set_state(struct psmouse *psmouse, enum psmouse_state new_state)
+void psmouse_set_state(struct psmouse *psmouse, enum psmouse_state new_state)
 {
 	serio_pause_rx(psmouse->ps2dev.serio);
 	__psmouse_set_state(psmouse, new_state);
@@ -630,8 +631,20 @@ static int psmouse_extensions(struct psmouse *psmouse,
 		}
 	}
 
-	if (max_proto > PSMOUSE_IMEX) {
+/*
+ * Try OLPC touchpad.
+ */
+	if (max_proto > PSMOUSE_IMEX &&
+			olpc_detect(psmouse, set_properties) == 0) {
+		if (!set_properties || olpc_init(psmouse) == 0)
+			return PSMOUSE_OLPC;
+/*
+ * Init failed, try basic relative protocols
+ */
+		max_proto = PSMOUSE_IMEX;
+	}
 
+	if (max_proto > PSMOUSE_IMEX) {
 		if (genius_detect(psmouse, set_properties) == 0)
 			return PSMOUSE_GENPS;
 
@@ -762,6 +775,14 @@ static const struct psmouse_protocol psmouse_protocols[] = {
 		.detect		= touchkit_ps2_detect,
 	},
 #endif
+#ifdef CONFIG_MOUSE_PS2_OLPC
+	{
+		.type		= PSMOUSE_OLPC,
+		.name		= "OLPC",
+		.alias		= "olpc",
+		.detect		= olpc_detect,
+	},
+#endif
 	{
 		.type		= PSMOUSE_CORTRON,
 		.name		= "CortronPS/2",
diff --git a/drivers/input/mouse/psmouse.h b/drivers/input/mouse/psmouse.h
index 1317bdd..67af5a5 100644
--- a/drivers/input/mouse/psmouse.h
+++ b/drivers/input/mouse/psmouse.h
@@ -89,13 +89,16 @@ enum psmouse_type {
 	PSMOUSE_TRACKPOINT,
 	PSMOUSE_TOUCHKIT_PS2,
 	PSMOUSE_CORTRON,
+	PSMOUSE_OLPC,
 	PSMOUSE_AUTO		/* This one should always be last */
 };
 
 int psmouse_sliced_command(struct psmouse *psmouse, unsigned char command);
 int psmouse_reset(struct psmouse *psmouse);
 void psmouse_set_resolution(struct psmouse *psmouse, unsigned int resolution);
+void psmouse_set_state(struct psmouse *psmouse, enum psmouse_state new_state);
 
+extern struct workqueue_struct *kpsmoused_wq;
 
 struct psmouse_attribute {
 	struct device_attribute dattr;
-- 
1.5.6.3

