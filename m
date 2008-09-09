Return-Path: <linux-kernel-owner+w=401wt.eu-S1755423AbYIIEPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423AbYIIEPL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 00:15:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755834AbYIIEJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 00:09:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43811 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755760AbYIIEJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 00:09:38 -0400
From: Jarod Wilson <jwilson@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jarod Wilson <jwilson@redhat.com>, Jarod Wilson <jarod@redhat.com>,
       Janne Grunau <j@jannau.net>, Christoph Bartelmus <lirc@bartelmus.de>,
       Mike Krufky <mkrufky@linuxtv.org>, Steven Toth <stoth@hauppauge.com>,
       Mark Weaver <mark@npsl.co.uk>
Subject: [PATCH 18/18] lirc driver for the zilog/haupauge IR transceiver
Date: Tue,  9 Sep 2008 00:06:03 -0400
Message-Id: <1220933164-10160-19-git-send-email-jwilson@redhat.com>
In-Reply-To: <1220933164-10160-18-git-send-email-jwilson@redhat.com>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com>
 <1220933164-10160-2-git-send-email-jwilson@redhat.com>
 <1220933164-10160-3-git-send-email-jwilson@redhat.com>
 <1220933164-10160-4-git-send-email-jwilson@redhat.com>
 <1220933164-10160-5-git-send-email-jwilson@redhat.com>
 <1220933164-10160-6-git-send-email-jwilson@redhat.com>
 <1220933164-10160-7-git-send-email-jwilson@redhat.com>
 <1220933164-10160-8-git-send-email-jwilson@redhat.com>
 <1220933164-10160-9-git-send-email-jwilson@redhat.com>
 <1220933164-10160-10-git-send-email-jwilson@redhat.com>
 <1220933164-10160-11-git-send-email-jwilson@redhat.com>
 <1220933164-10160-12-git-send-email-jwilson@redhat.com>
 <1220933164-10160-13-git-send-email-jwilson@redhat.com>
 <1220933164-10160-14-git-send-email-jwilson@redhat.com>
 <1220933164-10160-15-git-send-email-jwilson@redhat.com>
 <1220933164-10160-16-git-send-email-jwilson@redhat.com>
 <1220933164-10160-17-git-send-email-jwilson@redhat.com>
 <1220933164-10160-18-git-send-email-jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hopefully, I get this summary more or less correct...

A number of Hauppauge devices contain both an IR receiver and an IR
transmitter. The RX side is rather similar to those handled by the
lirc_i2c driver, but the TX side is quite different. Devices with both
have to be handled a bit carefully...

The TX side is serviced by a zilog processor, running some zilog firmware,
but is interfaced with via a software db/table apparently written by a
Hauppauge sub-contractor. This is provided via a binary blob, loaded via
a request_firmware() call, and the binary blob was generated via i2c
sniffing, so general consensus between myself, Janne, Steve and Mike was
that there shouldn't be any reason it can't be redistributed, but Mark
(the original author) and Christoph had concerns about redistribution, so
this originally lived outside of lirc cvs as lirc_pvr150.c. Either way,
the "firmware" lives out of tree at the moment anyhow...

See http://www.blushingpenguin.com/mark/blog/?p=24 for more details.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
Signed-off-by: Janne Grunau <j@jannau.net>
CC: Christoph Bartelmus <lirc@bartelmus.de>
CC: Mike Krufky <mkrufky@linuxtv.org>
CC: Steven Toth <stoth@hauppauge.com>
CC: Mark Weaver <mark@npsl.co.uk>
---
 drivers/input/lirc/Kconfig      |    9 +
 drivers/input/lirc/Makefile     |    1 +
 drivers/input/lirc/lirc_zilog.c | 1395 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 1405 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/lirc/lirc_zilog.c

diff --git a/drivers/input/lirc/Kconfig b/drivers/input/lirc/Kconfig
index fb8ba38..47183ee 100644
--- a/drivers/input/lirc/Kconfig
+++ b/drivers/input/lirc/Kconfig
@@ -130,4 +130,13 @@ config LIRC_TTUSBIR
 	depends on LIRC_DEV
 	help
 	  Driver for the Technotrend USB IR Receiver
+
+config LIRC_ZILOG
+	tristate "Zilog/Hauppauge IR Transmitter"
+	default n
+	depends on LIRC_DEV
+	help
+	  Driver for the Zilog/Hauppauge IR Transmitter, found on
+	  PVR-150/500, HVR-1200/1250/1700/1800, HD-PVR and other cards
+
 endif
diff --git a/drivers/input/lirc/Makefile b/drivers/input/lirc/Makefile
index 3a1469c..411db5e 100644
--- a/drivers/input/lirc/Makefile
+++ b/drivers/input/lirc/Makefile
@@ -22,3 +22,4 @@ obj-$(CONFIG_LIRC_SERIAL)	+= lirc_serial.o
 obj-$(CONFIG_LIRC_SIR)		+= lirc_sir.o
 obj-$(CONFIG_LIRC_STREAMZAP)	+= lirc_streamzap.o
 obj-$(CONFIG_LIRC_TTUSBIR)	+= lirc_ttusbir.o
+obj-$(CONFIG_LIRC_ZILOG)	+= lirc_zilog.o
diff --git a/drivers/input/lirc/lirc_zilog.c b/drivers/input/lirc/lirc_zilog.c
new file mode 100644
index 0000000..20e6b27
--- /dev/null
+++ b/drivers/input/lirc/lirc_zilog.c
@@ -0,0 +1,1395 @@
+/*
+ * i2c IR lirc plugin for devices with zilog IR processors
+ *
+ * Copyright (c) 2000 Gerd Knorr <kraxel@goldbach.in-berlin.de>
+ * modified for PixelView (BT878P+W/FM) by
+ *      Michal Kochanowicz <mkochano@pld.org.pl>
+ *      Christoph Bartelmus <lirc@bartelmus.de>
+ * modified for KNC ONE TV Station/Anubis Typhoon TView Tuner by
+ *      Ulrich Mueller <ulrich.mueller42@web.de>
+ * modified for Asus TV-Box and Creative/VisionTek BreakOut-Box by
+ *      Stefan Jahn <stefan@lkcc.org>
+ * modified for inclusion into kernel sources by
+ *      Jerome Brock <jbrock@users.sourceforge.net>
+ * modified for Leadtek Winfast PVR2000 by
+ *      Thomas Reitmayr (treitmayr@yahoo.com)
+ * modified for Hauppauge PVR-150 IR TX device by
+ *      Mark Weaver <mark@npsl.co.uk>
+ * changed name from lirc_pvr150 to lirc_zilog, works on more than pvr-150
+ *	Jarod Wilson <jarod@redhat.com>
+ *
+ * parts are cut&pasted from the lirc_i2c.c driver
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+
+#include <linux/version.h>
+#include <linux/module.h>
+#include <linux/kmod.h>
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/fs.h>
+#include <linux/poll.h>
+#include <linux/string.h>
+#include <linux/timer.h>
+#include <linux/delay.h>
+#include <linux/completion.h>
+#include <linux/errno.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/i2c-algo-bit.h>
+#include <linux/firmware.h>
+#include <linux/vmalloc.h>
+
+#include <linux/mutex.h>
+#include <linux/kthread.h>
+
+#include "lirc_dev.h"
+#include "lirc.h"
+
+struct IR {
+	struct lirc_plugin l;
+
+	/* Device info */
+	struct mutex       lock;
+	int		   open;
+
+	/* RX device */
+	struct i2c_client  c_rx;
+
+	/* RX device buffer & lock */
+	struct lirc_buffer buf;
+	struct mutex       buf_lock;
+
+	/* RX polling thread data */
+	struct completion  *t_notify;
+	struct completion  *t_notify2;
+	int		   shutdown;
+	struct task_struct *task;
+
+	/* RX read data */
+	unsigned char      b[3];
+
+	/* TX device */
+	struct i2c_client  c_tx;
+	int		   need_boot;
+
+	/* # devices, for shutdown */
+	int		   devs;
+};
+
+/* Minor -> data mapping */
+static struct IR *ir_devices[MAX_IRCTL_DEVICES];
+
+/* Block size for IR transmitter */
+#define TX_BLOCK_SIZE	99
+
+/* Hauppuage IR transmitter data */
+struct tx_data_struct {
+	/* Boot block */
+	unsigned char *boot_data;
+
+	/* Start of binary data block */
+	unsigned char *datap;
+
+	/* End of binary data block */
+	unsigned char *endp;
+
+	/* Number of installed codesets */
+	unsigned int num_code_sets;
+
+	/* Pointers to codesets */
+	unsigned char **code_sets;
+
+	/* Global fixed data template */
+	int fixed[TX_BLOCK_SIZE];
+};
+
+static struct tx_data_struct *tx_data;
+struct mutex tx_data_lock;
+
+/* ----------------------------------------------------------------------- */
+
+#define DEVICE_NAME "lirc_zilog"
+#define zilog_notify(s, args...) printk(KERN_NOTICE KBUILD_MODNAME ": " s, \
+					## args)
+#define zilog_error(s, args...) printk(KERN_ERR KBUILD_MODNAME ": " s, ## args)
+
+/* ----------------------------------------------------------------------- */
+/* insmod parameters						       */
+
+static int debug;	/* debug output */
+static int disable_rx;	/* disable RX device */
+static int disable_tx;	/* disable TX device */
+static int minor = -1;	/* minor number */
+
+#define dprintk(fmt, args...)						\
+	do {								\
+		if (debug)						\
+			printk(KERN_DEBUG DEVICE_NAME ": " fmt,		\
+				 ## args);				\
+	} while (0)
+
+/* ----------------------------------------------------------------------- */
+
+static int add_to_buf(struct IR *ir)
+{
+	__u16 code;
+	unsigned char codes[2];
+	unsigned char keybuf[6];
+	int got_data = 0;
+	int ret;
+	int failures = 0;
+	unsigned char sendbuf[1] = { 0 };
+
+	if (lirc_buffer_full(&ir->buf)) {
+		dprintk("buffer overflow\n");
+		return -EOVERFLOW;
+	}
+
+	/* service the device as long as it is returning
+	 * data and we have space
+	 */
+	do {
+		/* Lock i2c bus for the duration.  RX/TX chips interfere so
+		   this is worth it
+		 */
+		mutex_lock(&ir->lock);
+
+		/* Send random "poll command" (?)  Windows driver does this
+		   and it  is a good point to detect chip failure.
+		 */
+		ret = i2c_master_send(&ir->c_rx, sendbuf, 1);
+		if (ret != 1) {
+			zilog_error("i2c_master_send failed with %d\n",	ret);
+			if (failures >= 3) {
+				mutex_unlock(&ir->lock);
+				zilog_error("unable to read from the IR chip "
+					    "after 3 resets, giving up\n");
+				return ret;
+			}
+
+			/* Looks like the chip crashed, reset it */
+			zilog_error("polling the IR receiver chip failed, "
+				    "trying reset\n");
+
+			set_current_state(TASK_UNINTERRUPTIBLE);
+			schedule_timeout((100 * HZ + 999) / 1000);
+			ir->need_boot = 1;
+
+			++failures;
+			mutex_unlock(&ir->lock);
+			continue;
+		}
+
+		ret = i2c_master_recv(&ir->c_rx, keybuf, sizeof(keybuf));
+		mutex_unlock(&ir->lock);
+		if (ret != sizeof(keybuf)) {
+			zilog_error("i2c_master_recv failed with %d -- "
+				    "keeping last read buffer\n", ret);
+		} else {
+			ir->b[0] = keybuf[3];
+			ir->b[1] = keybuf[4];
+			ir->b[2] = keybuf[5];
+			dprintk("key (0x%02x/0x%02x)\n", ir->b[0], ir->b[1]);
+		}
+
+		/* key pressed ? */
+		if ((ir->b[0] & 0x80) == 0)
+			return got_data ? 0 : -ENODATA;
+
+		/* look what we have */
+		code = (((__u16)ir->b[0]&0x7f)<<6) | (ir->b[1]>>2);
+
+		codes[0] = (code >> 8) & 0xff;
+		codes[1] = code & 0xff;
+
+		/* return it */
+		lirc_buffer_write_1(&ir->buf, codes);
+		++got_data;
+	} while (!lirc_buffer_full(&ir->buf));
+	return 0;
+}
+
+/* Main function of the polling thread -- from lirc_dev.
+ * We don't fit the LIRC model at all anymore.  This is horrible, but
+ * basically we have a single RX/TX device with a nasty failure mode
+ * that needs to be accounted for across the pair.  lirc lets us provide
+ * fops, but prevents us from using the internal polling, etc. if we do
+ * so.  Hence the replication.  Might be neater to extend the LIRC model
+ * to account for this but I'd think it's a very special case of seriously
+ * messed up hardware.
+ */
+static int lirc_thread(void *arg)
+{
+	struct IR *ir = arg;
+
+	if (ir->t_notify != NULL)
+		complete(ir->t_notify);
+
+	dprintk("poll thread started\n");
+
+	do {
+		if (ir->open) {
+			set_current_state(TASK_INTERRUPTIBLE);
+
+			/* This is ~113*2 + 24 + jitter (2*repeat gap +
+			   code length).  We use this interval as the chip
+			   resets every time you poll it (bad!).  This is
+			   therefore just sufficient to catch all of the
+			   button presses.  It makes the remote much more
+			   responsive.  You can see the difference by
+			   running irw and holding down a button.  With
+			   100ms, the old polling interval, you'll notice
+			   breaks in the repeat sequence corresponding to
+			   lost keypresses.
+			*/
+			schedule_timeout((260 * HZ) / 1000);
+			if (ir->shutdown)
+				break;
+			if (!add_to_buf(ir))
+				wake_up_interruptible(&ir->buf.wait_poll);
+		} else {
+			/* if device not opened so we can sleep half a second */
+			set_current_state(TASK_INTERRUPTIBLE);
+			schedule_timeout(HZ/2);
+		}
+	} while (!ir->shutdown);
+
+	if (ir->t_notify2 != NULL)
+		wait_for_completion(ir->t_notify2);
+
+	ir->task = NULL;
+	if (ir->t_notify != NULL)
+		complete(ir->t_notify);
+
+	dprintk("poll thread ended\n");
+	return 0;
+}
+
+static int set_use_inc(void *data)
+{
+	struct IR *ir = data;
+
+	if (ir->l.owner == NULL || try_module_get(ir->l.owner) == 0)
+		return -ENODEV;
+
+	/* lock bttv in memory while /dev/lirc is in use  */
+	/* this is completely broken code. lirc_unregister_plugin()
+	   must be possible even when the device is open */
+	if (ir->c_rx.addr)
+		i2c_use_client(&ir->c_rx);
+	if (ir->c_tx.addr)
+		i2c_use_client(&ir->c_tx);
+
+	return 0;
+}
+
+static void set_use_dec(void *data)
+{
+	struct IR *ir = data;
+
+	if (ir->c_rx.addr)
+		i2c_release_client(&ir->c_rx);
+	if (ir->c_tx.addr)
+		i2c_release_client(&ir->c_tx);
+	if (ir->l.owner != NULL)
+		module_put(ir->l.owner);
+}
+
+/* safe read of a uint32 (always network byte order) */
+static inline int read_uint32(unsigned char **data,
+				     unsigned char *endp, unsigned int *val)
+{
+	if (*data + 4 > endp)
+		return 0;
+	*val = ((*data)[0] << 24) | ((*data)[1] << 16) |
+	       ((*data)[2] << 8) | (*data)[3];
+	*data += 4;
+	return 1;
+}
+
+/* safe read of a uint8 */
+static inline int read_uint8(unsigned char **data,
+				    unsigned char *endp, unsigned char *val)
+{
+	if (*data + 1 > endp)
+		return 0;
+	*val = *((*data)++);
+	return 1;
+}
+
+/* safe skipping of N bytes */
+static inline int skip(unsigned char **data,
+			      unsigned char *endp, unsigned int distance)
+{
+	if (*data + distance > endp)
+		return 0;
+	*data += distance;
+	return 1;
+}
+
+/* decompress key data into the given buffer */
+static int get_key_data(unsigned char *buf,
+			     unsigned int codeset, unsigned int key)
+{
+	unsigned char *data, *endp, *diffs, *key_block;
+	unsigned char keys, ndiffs, id;
+	unsigned int base, lim, pos, i;
+
+	/* Binary search for the codeset */
+	for (base = 0, lim = tx_data->num_code_sets; lim; lim >>= 1) {
+		pos = base + (lim >> 1);
+		data = tx_data->code_sets[pos];
+
+		if (!read_uint32(&data, tx_data->endp, &i))
+			goto corrupt;
+
+		if (i == codeset)
+			break;
+		else if (codeset > i) {
+			base = pos + 1;
+			--lim;
+		}
+	}
+	/* Not found? */
+	if (!lim)
+		return -EPROTO;
+
+	/* Set end of data block */
+	endp = pos < tx_data->num_code_sets - 1 ?
+		tx_data->code_sets[pos + 1] : tx_data->endp;
+
+	/* Read the block header */
+	if (!read_uint8(&data, endp, &keys) ||
+	    !read_uint8(&data, endp, &ndiffs) ||
+	    ndiffs > TX_BLOCK_SIZE || keys == 0)
+		goto corrupt;
+
+	/* Save diffs & skip */
+	diffs = data;
+	if (!skip(&data, endp, ndiffs))
+		goto corrupt;
+
+	/* Read the id of the first key */
+	if (!read_uint8(&data, endp, &id))
+		goto corrupt;
+
+	/* Unpack the first key's data */
+	for (i = 0; i < TX_BLOCK_SIZE; ++i) {
+		if (tx_data->fixed[i] == -1) {
+			if (!read_uint8(&data, endp, &buf[i]))
+				goto corrupt;
+		} else {
+			buf[i] = (unsigned char)tx_data->fixed[i];
+		}
+	}
+
+	/* Early out key found/not found */
+	if (key == id)
+		return 0;
+	if (keys == 1)
+		return -EPROTO;
+
+	/* Sanity check */
+	key_block = data;
+	if (!skip(&data, endp, (keys - 1) * (ndiffs + 1)))
+		goto corrupt;
+
+	/* Binary search for the key */
+	for (base = 0, lim = keys - 1; lim; lim >>= 1) {
+		/* Seek to block */
+		unsigned char *key_data;
+		pos = base + (lim >> 1);
+		key_data = key_block + (ndiffs + 1) * pos;
+
+		if (*key_data == key) {
+			/* skip key id */
+			++key_data;
+
+			/* found, so unpack the diffs */
+			for (i = 0; i < ndiffs; ++i) {
+				unsigned char val;
+				if (!read_uint8(&key_data, endp, &val) ||
+				    diffs[i] >= TX_BLOCK_SIZE)
+					goto corrupt;
+				buf[diffs[i]] = val;
+			}
+
+			return 0;
+		} else if (key > *key_data) {
+			base = pos + 1;
+			--lim;
+		}
+	}
+	/* Key not found */
+	return -EPROTO;
+
+corrupt:
+	zilog_error("firmware is corrupt\n");
+	return -EFAULT;
+}
+
+/* send a block of data to the IR TX device */
+static int send_data_block(struct IR *ir, unsigned char *data_block)
+{
+	int i, j, ret;
+	unsigned char buf[5];
+
+	for (i = 0; i < TX_BLOCK_SIZE;) {
+		int tosend = TX_BLOCK_SIZE - i;
+		if (tosend > 4)
+			tosend = 4;
+		buf[0] = (unsigned char)(i + 1);
+		for (j = 0; j < tosend; ++j)
+			buf[1 + j] = data_block[i + j];
+		dprintk("%02x %02x %02x %02x %02x",
+			buf[0], buf[1], buf[2], buf[3], buf[4]);
+		ret = i2c_master_send(&ir->c_tx, buf, tosend + 1);
+		if (ret != tosend + 1) {
+			zilog_error("i2c_master_send failed with %d\n", ret);
+			return ret < 0 ? ret : -EFAULT;
+		}
+		i += tosend;
+	}
+	return 0;
+}
+
+/* send boot data to the IR TX device */
+static int send_boot_data(struct IR *ir)
+{
+	int ret;
+	unsigned char buf[4];
+
+	/* send the boot block */
+	ret = send_data_block(ir, tx_data->boot_data);
+	if (ret != 0)
+		return ret;
+
+	/* kick it off? */
+	buf[0] = 0x00;
+	buf[1] = 0x20;
+	ret = i2c_master_send(&ir->c_tx, buf, 2);
+	if (ret != 2) {
+		zilog_error("i2c_master_send failed with %d\n", ret);
+		return ret < 0 ? ret : -EFAULT;
+	}
+	ret = i2c_master_send(&ir->c_tx, buf, 1);
+	if (ret != 1) {
+		zilog_error("i2c_master_send failed with %d\n", ret);
+		return ret < 0 ? ret : -EFAULT;
+	}
+
+	/* Here comes the firmware version... (hopefully) */
+	ret = i2c_master_recv(&ir->c_tx, buf, 4);
+	if (ret != 4) {
+		zilog_error("i2c_master_recv failed with %d\n", ret);
+		return 0;
+	}
+	if (buf[0] != 0x80) {
+		zilog_error("unexpected IR TX response: %02x\n", buf[0]);
+		return 0;
+	}
+	zilog_notify("Zilog/Hauppauge IR blaster: firmware version "
+		     "%d.%d.%d\n", buf[1], buf[2], buf[3]);
+
+	return 0;
+}
+
+/* unload "firmware", lock held */
+static void fw_unload_locked(void)
+{
+	if (tx_data) {
+		if (tx_data->code_sets)
+			vfree(tx_data->code_sets);
+
+		if (tx_data->datap)
+			vfree(tx_data->datap);
+
+		vfree(tx_data);
+		tx_data = NULL;
+		dprintk("successfully unloaded IR blaster firmware\n");
+	}
+}
+
+/* unload "firmware" for the IR TX device */
+static void fw_unload(void)
+{
+	mutex_lock(&tx_data_lock);
+	fw_unload_locked();
+	mutex_unlock(&tx_data_lock);
+}
+
+/* load "firmware" for the IR TX device */
+static int fw_load(struct IR *ir)
+{
+	int ret;
+	unsigned int i;
+	unsigned char *data, version, num_global_fixed;
+	const struct firmware *fw_entry = NULL;
+
+	/* Already loaded? */
+	mutex_lock(&tx_data_lock);
+	if (tx_data) {
+		ret = 0;
+		goto out;
+	}
+
+	/* Request codeset data file */
+	ret = request_firmware(&fw_entry, "haup-ir-blaster.bin", &ir->c_tx.dev);
+	if (ret != 0) {
+		zilog_error("firmware haup-ir-blaster.bin not available "
+			    "(%d)\n", ret);
+		ret = ret < 0 ? ret : -EFAULT;
+		goto out;
+	}
+	zilog_notify("firmware of size %zu loaded\n", fw_entry->size);
+
+	/* Parse the file */
+	tx_data = vmalloc(sizeof(*tx_data));
+	if (tx_data == NULL) {
+		zilog_error("out of memory\n");
+		release_firmware(fw_entry);
+		ret = -ENOMEM;
+		goto out;
+	}
+	tx_data->code_sets = NULL;
+
+	/* Copy the data so hotplug doesn't get confused and timeout */
+	tx_data->datap = vmalloc(fw_entry->size);
+	if (tx_data->datap == NULL) {
+		zilog_error("out of memory\n");
+		release_firmware(fw_entry);
+		vfree(tx_data);
+		ret = -ENOMEM;
+		goto out;
+	}
+	memcpy(tx_data->datap, fw_entry->data, fw_entry->size);
+	tx_data->endp = tx_data->datap + fw_entry->size;
+	release_firmware(fw_entry); fw_entry = NULL;
+
+	/* Check version */
+	data = tx_data->datap;
+	if (!read_uint8(&data, tx_data->endp, &version))
+		goto corrupt;
+	if (version != 1) {
+		zilog_error("unsupported code set file version (%u, expected"
+			    "1) -- please upgrade to a newer driver",
+			    version);
+		fw_unload_locked();
+		ret = -EFAULT;
+		goto out;
+	}
+
+	/* Save boot block for later */
+	tx_data->boot_data = data;
+	if (!skip(&data, tx_data->endp, TX_BLOCK_SIZE))
+		goto corrupt;
+
+	if (!read_uint32(&data, tx_data->endp,
+			      &tx_data->num_code_sets))
+		goto corrupt;
+
+	zilog_notify("%u codesets loaded\n", tx_data->num_code_sets);
+
+	tx_data->code_sets = vmalloc(
+		tx_data->num_code_sets * sizeof(char *));
+	if (tx_data->code_sets == NULL) {
+		fw_unload_locked();
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	for (i = 0; i < TX_BLOCK_SIZE; ++i)
+		tx_data->fixed[i] = -1;
+
+	/* Read global fixed data template */
+	if (!read_uint8(&data, tx_data->endp, &num_global_fixed) ||
+	    num_global_fixed > TX_BLOCK_SIZE)
+		goto corrupt;
+	for (i = 0; i < num_global_fixed; ++i) {
+		unsigned char pos, val;
+		if (!read_uint8(&data, tx_data->endp, &pos) ||
+		    !read_uint8(&data, tx_data->endp, &val) ||
+		    pos >= TX_BLOCK_SIZE)
+			goto corrupt;
+		tx_data->fixed[pos] = (int)val;
+	}
+
+	/* Filch out the position of each code set */
+	for (i = 0; i < tx_data->num_code_sets; ++i) {
+		unsigned int id;
+		unsigned char keys;
+		unsigned char ndiffs;
+
+		/* Save the codeset position */
+		tx_data->code_sets[i] = data;
+
+		/* Read header */
+		if (!read_uint32(&data, tx_data->endp, &id) ||
+		    !read_uint8(&data, tx_data->endp, &keys) ||
+		    !read_uint8(&data, tx_data->endp, &ndiffs) ||
+		    ndiffs > TX_BLOCK_SIZE || keys == 0)
+			goto corrupt;
+
+		/* skip diff positions */
+		if (!skip(&data, tx_data->endp, ndiffs))
+			goto corrupt;
+
+		/* After the diffs we have the first key id + data -
+		   global fixed */
+		if (!skip(&data, tx_data->endp,
+			       1 + TX_BLOCK_SIZE - num_global_fixed))
+			goto corrupt;
+
+		/* Then we have keys-1 blocks of key id+diffs */
+		if (!skip(&data, tx_data->endp,
+			       (ndiffs + 1) * (keys - 1)))
+			goto corrupt;
+	}
+	ret = 0;
+	goto out;
+
+corrupt:
+	zilog_error("firmware is corrupt\n");
+	fw_unload_locked();
+	ret = -EFAULT;
+
+out:
+	mutex_unlock(&tx_data_lock);
+	return ret;
+}
+
+/* initialise the IR TX device */
+static int tx_init(struct IR *ir)
+{
+	int ret;
+
+	/* Load 'firmware' */
+	ret = fw_load(ir);
+	if (ret != 0)
+		return ret;
+
+	/* Send boot block */
+	ret = send_boot_data(ir);
+	if (ret != 0)
+		return ret;
+	ir->need_boot = 0;
+
+	/* Looks good */
+	return 0;
+}
+
+/* do nothing stub to make LIRC happy */
+static loff_t lseek(struct file *filep, loff_t offset, int orig)
+{
+	return -ESPIPE;
+}
+
+/* copied from lirc_dev */
+static ssize_t read(struct file *filep, char *outbuf, size_t n, loff_t *ppos)
+{
+	struct IR *ir = (struct IR *)filep->private_data;
+	unsigned char buf[ir->buf.chunk_size];
+	int ret = 0, written = 0;
+	DECLARE_WAITQUEUE(wait, current);
+
+	dprintk("read called\n");
+	if (ir->c_rx.addr == 0)
+		return -ENODEV;
+
+	if (mutex_lock_interruptible(&ir->buf_lock))
+		return -ERESTARTSYS;
+
+	if (n % ir->buf.chunk_size) {
+		dprintk("read result = -EINVAL\n");
+		mutex_unlock(&ir->buf_lock);
+		return -EINVAL;
+	}
+
+	/* we add ourselves to the task queue before buffer check
+	 * to avoid losing scan code (in case when queue is awaken somewhere
+	 * beetwen while condition checking and scheduling)
+	 */
+	add_wait_queue(&ir->buf.wait_poll, &wait);
+	set_current_state(TASK_INTERRUPTIBLE);
+
+	/* while we did't provide 'length' bytes, device is opened in blocking
+	 * mode and 'copy_to_user' is happy, wait for data.
+	 */
+	while (written < n && ret == 0) {
+		if (lirc_buffer_empty(&ir->buf)) {
+			/* According to the read(2) man page, 'written' can be
+			 * returned as less than 'n', instead of blocking
+			 * again, returning -EWOULDBLOCK, or returning
+			 * -ERESTARTSYS */
+			if (written)
+				break;
+			if (filep->f_flags & O_NONBLOCK) {
+				ret = -EWOULDBLOCK;
+				break;
+			}
+			if (signal_pending(current)) {
+				ret = -ERESTARTSYS;
+				break;
+			}
+			schedule();
+			set_current_state(TASK_INTERRUPTIBLE);
+		} else {
+			lirc_buffer_read_1(&ir->buf, buf);
+			ret = copy_to_user((void *)outbuf+written, buf,
+					   ir->buf.chunk_size);
+			written += ir->buf.chunk_size;
+		}
+	}
+
+	remove_wait_queue(&ir->buf.wait_poll, &wait);
+	set_current_state(TASK_RUNNING);
+	mutex_unlock(&ir->buf_lock);
+
+	dprintk("read result = %s (%d)\n",
+		ret ? "-EFAULT" : "OK", ret);
+
+	return ret ? ret : written;
+}
+
+/* send a keypress to the IR TX device */
+static int send_code(struct IR *ir, unsigned int code, unsigned int key)
+{
+	unsigned char data_block[TX_BLOCK_SIZE];
+	unsigned char buf[2];
+	int i, ret;
+
+	/* Get data for the codeset/key */
+	ret = get_key_data(data_block, code, key);
+
+	if (ret == -EPROTO) {
+		zilog_error("failed to get data for code %u, key %u -- check "
+			    "lircd.conf entries\n", code, key);
+		return ret;
+	} else if (ret != 0)
+		return ret;
+
+	/* Send the data block */
+	ret = send_data_block(ir, data_block);
+	if (ret != 0)
+		return ret;
+
+	/* Send data block length? */
+	buf[0] = 0x00;
+	buf[1] = 0x40;
+	ret = i2c_master_send(&ir->c_tx, buf, 2);
+	if (ret != 2) {
+		zilog_error("i2c_master_send failed with %d\n", ret);
+		return ret < 0 ? ret : -EFAULT;
+	}
+	ret = i2c_master_send(&ir->c_tx, buf, 1);
+	if (ret != 1) {
+		zilog_error("i2c_master_send failed with %d\n", ret);
+		return ret < 0 ? ret : -EFAULT;
+	}
+
+	/* Send finished download? */
+	ret = i2c_master_recv(&ir->c_tx, buf, 1);
+	if (ret != 1) {
+		zilog_error("i2c_master_recv failed with %d\n", ret);
+		return ret < 0 ? ret : -EFAULT;
+	}
+	if (buf[0] != 0xA0) {
+		zilog_error("unexpected IR TX response #1: %02x\n",
+			buf[0]);
+		return ret < 0 ? ret : -EFAULT;
+	}
+
+	/* Send prepare command? */
+	buf[0] = 0x00;
+	buf[1] = 0x80;
+	ret = i2c_master_send(&ir->c_tx, buf, 2);
+	if (ret != 2) {
+		zilog_error("i2c_master_send failed with %d\n", ret);
+		return ret < 0 ? ret : -EFAULT;
+	}
+
+	/* This bit NAKs until the device is ready, so we retry it
+	   sleeping a bit each time.  This seems to be what the windows
+	   driver does, approximately.
+	   Try for up to 1s.
+	*/
+	for (i = 0; i < 20; ++i) {
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule_timeout((50 * HZ + 999) / 1000);
+		ret = i2c_master_send(&ir->c_tx, buf, 1);
+		if (ret == 1)
+			break;
+		dprintk("NAK expected: i2c_master_send "
+			"failed with %d (try %d)\n", ret, i+1);
+	}
+	if (ret != 1) {
+		zilog_error("IR TX chip never got ready: last i2c_master_send "
+			    "failed with %d\n", ret);
+		return ret < 0 ? ret : -EFAULT;
+	}
+
+	/* Seems to be an 'ok' response */
+	i = i2c_master_recv(&ir->c_tx, buf, 1);
+	if (i != 1) {
+		zilog_error("i2c_master_recv failed with %d\n", ret);
+		return ret < 0 ? ret : -EFAULT;
+	}
+	if (buf[0] != 0x80) {
+		zilog_error("unexpected IR TX response #2: %02x\n", buf[0]);
+		return -EFAULT;
+	}
+
+	/* Oh good, it worked */
+	dprintk("sent code %u, key %u\n", code, key);
+	return 0;
+}
+
+/*
+ * Write a code to the device.  We take in a 32-bit number (an int) and then
+ * decode this to a codeset/key index.  The key data is then decompressed and
+ * sent to the device.  We have a spin lock as per i2c documentation to prevent
+ * multiple concurrent sends which would probably cause the device to explode.
+ */
+static ssize_t write(struct file *filep, const char *buf, size_t n,
+			  loff_t *ppos)
+{
+	struct IR *ir = (struct IR *)filep->private_data;
+	size_t i;
+	int failures = 0;
+
+	if (ir->c_tx.addr == 0)
+		return -ENODEV;
+
+	/* Validate user parameters */
+	if (n % sizeof(int))
+		return -EINVAL;
+
+	/* Lock i2c bus for the duration */
+	mutex_lock(&ir->lock);
+
+	/* Send each keypress */
+	for (i = 0; i < n;) {
+		int ret = 0;
+		int command;
+
+		if (copy_from_user(&command, buf + i, sizeof(command))) {
+			mutex_unlock(&ir->lock);
+			return -EFAULT;
+		}
+
+		/* Send boot data first if required */
+		if (ir->need_boot == 1) {
+			ret = send_boot_data(ir);
+			if (ret == 0)
+				ir->need_boot = 0;
+		}
+
+		/* Send the code */
+		if (ret == 0) {
+			ret = send_code(ir, (unsigned)command >> 16,
+					    (unsigned)command & 0xFFFF);
+			if (ret == -EPROTO) {
+				mutex_unlock(&ir->lock);
+				return ret;
+			}
+		}
+
+		/* Hmm, a failure.  If we've had a few then give up, otherwise
+		   try a reset
+		 */
+		if (ret != 0) {
+			/* Looks like the chip crashed, reset it */
+			zilog_error("sending to the IR transmitter chip "
+				    "failed, trying reset\n");
+
+			if (failures >= 3) {
+				zilog_error("unable to send to the IR chip "
+					    "after 3 resets, giving up\n");
+				mutex_unlock(&ir->lock);
+				return ret;
+			}
+			set_current_state(TASK_UNINTERRUPTIBLE);
+			schedule_timeout((100 * HZ + 999) / 1000);
+			ir->need_boot = 1;
+			++failures;
+		} else
+			i += sizeof(int);
+	}
+
+	/* Release i2c bus */
+	mutex_unlock(&ir->lock);
+
+	/* All looks good */
+	return n;
+}
+
+/* copied from lirc_dev */
+static unsigned int poll(struct file *filep, poll_table *wait)
+{
+	struct IR *ir = (struct IR *)filep->private_data;
+	unsigned int ret;
+
+	dprintk("poll called\n");
+	if (ir->c_rx.addr == 0)
+		return -ENODEV;
+
+	mutex_lock(&ir->buf_lock);
+
+	poll_wait(filep, &ir->buf.wait_poll, wait);
+
+	dprintk("poll result = %s\n",
+		lirc_buffer_empty(&ir->buf) ? "0" : "POLLIN|POLLRDNORM");
+
+	ret = lirc_buffer_empty(&ir->buf) ? 0 : (POLLIN|POLLRDNORM);
+
+	mutex_unlock(&ir->buf_lock);
+	return ret;
+}
+
+static int ioctl(struct inode *node, struct file *filep, unsigned int cmd,
+		      unsigned long arg)
+{
+	struct IR *ir = (struct IR *)filep->private_data;
+	int result;
+	unsigned long mode, features = 0;
+
+	if (ir->c_rx.addr != 0)
+		features |= LIRC_CAN_REC_LIRCCODE;
+	if (ir->c_tx.addr != 0)
+		features |= LIRC_CAN_SEND_PULSE;
+
+	switch (cmd) {
+	case LIRC_GET_LENGTH:
+		result = put_user((unsigned long)13,
+				  (unsigned long *)arg);
+		break;
+	case LIRC_GET_FEATURES:
+		result = put_user(features, (unsigned long *) arg);
+		if (result)
+			return result;
+		break;
+	case LIRC_GET_REC_MODE:
+		if (!(features&LIRC_CAN_REC_MASK))
+			return -ENOSYS;
+
+		result = put_user(LIRC_REC2MODE
+				  (features&LIRC_CAN_REC_MASK),
+				  (unsigned long *)arg);
+		break;
+	case LIRC_SET_REC_MODE:
+		if (!(features&LIRC_CAN_REC_MASK))
+			return -ENOSYS;
+
+		result = get_user(mode, (unsigned long *)arg);
+		if (!result && !(LIRC_MODE2REC(mode) & features))
+			result = -EINVAL;
+		break;
+	case LIRC_GET_SEND_MODE:
+		if (!(features&LIRC_CAN_SEND_MASK))
+			return -ENOSYS;
+
+		result = put_user(LIRC_MODE_PULSE, (unsigned long *) arg);
+		if (result)
+			return result;
+		break;
+	case LIRC_SET_SEND_MODE:
+		if (!(features&LIRC_CAN_SEND_MASK))
+			return -ENOSYS;
+
+		result = get_user(mode, (unsigned long *) arg);
+		if (result)
+			return result;
+		if (mode != LIRC_MODE_PULSE)
+			return -EINVAL;
+		break;
+	default:
+		return -ENOIOCTLCMD;
+	}
+	return 0;
+}
+
+/* Open the IR device.  Get hold of our IR structure and
+   stash it in private_data for the file */
+static int open(struct inode *node, struct file *filep)
+{
+	struct IR *ir;
+	int ret;
+
+	/* find our IR struct */
+	unsigned minor = MINOR(node->i_rdev);
+	if (minor >= MAX_IRCTL_DEVICES) {
+		dprintk("minor %d: open result = -ENODEV\n",
+			minor);
+		return -ENODEV;
+	}
+	ir = ir_devices[minor];
+
+	/* increment in use count */
+	mutex_lock(&ir->lock);
+	++ir->open;
+	ret = set_use_inc(ir);
+	if (ret != 0) {
+		--ir->open;
+		mutex_unlock(&ir->lock);
+		return ret;
+	}
+	mutex_unlock(&ir->lock);
+
+	/* stash our IR struct */
+	filep->private_data = ir;
+
+	return 0;
+}
+
+/* Close the IR device */
+static int close(struct inode *node, struct file *filep)
+{
+	/* find our IR struct */
+	struct IR *ir = (struct IR *)filep->private_data;
+	if (ir == NULL) {
+		zilog_error("close: no private_data attached to the file!\n");
+		return -ENODEV;
+	}
+
+	/* decrement in use count */
+	mutex_lock(&ir->lock);
+	--ir->open;
+	set_use_dec(ir);
+	mutex_unlock(&ir->lock);
+
+	return 0;
+}
+
+static struct lirc_plugin lirc_template = {
+	.name		= "lirc_zilog",
+	.set_use_inc	= set_use_inc,
+	.set_use_dec	= set_use_dec,
+	.owner		= THIS_MODULE
+};
+
+/* ----------------------------------------------------------------------- */
+
+static int ir_attach(struct i2c_adapter *adap, int have_rx, int have_tx);
+static int ir_detach(struct i2c_client *client);
+static int ir_probe(struct i2c_adapter *adap);
+static int ir_command(struct i2c_client *client, unsigned int cmd, void *arg);
+
+static struct i2c_driver driver = {
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= "i2c ir driver",
+	},
+	.attach_adapter	= ir_probe,
+	.detach_client	= ir_detach,
+	.command	= ir_command,
+};
+
+static struct i2c_client client_template = {
+	.name	= "unset",
+	.driver	= &driver
+};
+
+static struct file_operations lirc_fops = {
+	.llseek		= lseek,
+	.read		= read,
+	.write		= write,
+	.poll		= poll,
+	.ioctl		= ioctl,
+	.open		= open,
+	.release	= close
+};
+
+static int i2c_attach(struct i2c_client *client, struct IR *ir)
+{
+	int ret;
+
+	i2c_set_clientdata(client, ir);
+
+	ret = i2c_attach_client(client);
+	if (ret != 0) {
+		client->addr = 0;
+		return ret;
+	}
+	if (!i2c_use_client(client)) {
+		i2c_detach_client(client);
+		client->addr = 0;
+		return -EFAULT;
+	}
+	++ir->devs;
+	return 0;
+}
+
+static int ir_attach(struct i2c_adapter *adap, int have_rx, int have_tx)
+{
+	struct IR *ir;
+	int ret, i;
+
+	printk("lirc_zilog: chip found with %s\n",
+		have_rx && have_tx ? "RX and TX" :
+			have_rx ? "RX only" : "TX only");
+
+	ir = kmalloc(sizeof(struct IR), GFP_KERNEL);
+	if (ir == NULL)
+		return -ENOMEM;
+	if (lirc_buffer_init(&ir->buf, 2, BUFLEN/2) != 0) {
+		kfree(ir);
+		return -ENOMEM;
+	}
+	mutex_init(&ir->lock);
+	mutex_init(&ir->buf_lock);
+	ir->open = 0;
+	ir->devs = 0;
+	ir->task = NULL;
+	ir->need_boot = 1;
+	ir->shutdown = 0;
+	ir->t_notify = ir->t_notify2 = NULL;
+	for (i = 0; i < sizeof(ir->b); ++i)
+		ir->b[0] = 0;
+
+	memcpy(&ir->l, &lirc_template, sizeof(struct lirc_plugin));
+	ir->l.minor = -1;
+
+	/* initialise RX device */
+	client_template.adapter = adap;
+	memcpy(&ir->c_rx, &client_template, sizeof(struct i2c_client));
+	if (have_rx) {
+		DECLARE_COMPLETION(tn);
+
+		/* I2C attach to device */
+		ir->c_rx.addr = 0x71;
+		strncpy(ir->c_rx.name, "Zilog/Hauppauge RX", I2C_NAME_SIZE);
+		ret = i2c_attach(&ir->c_rx, ir);
+		if (ret != 0)
+			goto err;
+
+		/* try to fire up polling thread */
+		ir->t_notify = &tn;
+		ir->task = kthread_run(lirc_thread, ir, "lirc_zilog");
+		ret = PTR_ERR(ir->task);
+		if (ret <= 0) {
+			zilog_error("lirc_register_plugin: cannot run "
+				    "poll thread\n");
+			goto err;
+		}
+		wait_for_completion(&tn);
+		ir->t_notify = NULL;
+	}
+
+	/* initialise TX device */
+	memcpy(&ir->c_tx, &client_template, sizeof(struct i2c_client));
+	if (have_tx) {
+		/* I2C attach to device */
+		ir->c_tx.addr = 0x70;
+		strncpy(ir->c_tx.name, "Zilog/Hauppauge TX", I2C_NAME_SIZE);
+		ret = i2c_attach(&ir->c_tx, ir);
+		if (ret != 0)
+			goto err;
+	}
+
+	/* set lirc_dev stuff */
+	ir->l.code_length = 13;
+	ir->l.rbuf	  = &ir->buf;
+	ir->l.fops	= &lirc_fops;
+	ir->l.data	= ir;
+	ir->l.minor       = minor;
+	ir->l.sample_rate = 0;
+
+	/* register with lirc */
+	ir->l.minor = lirc_register_plugin(&ir->l);
+	if (ir->l.minor < 0 || ir->l.minor >= MAX_IRCTL_DEVICES) {
+		zilog_error("ir_attach: \"minor\" must be between 0 and %d "
+			    "(%d)!\n", MAX_IRCTL_DEVICES-1, ir->l.minor);
+		ret = -EBADRQC;
+		goto err;
+	}
+
+	/* store this for getting back in open() later on */
+	ir_devices[ir->l.minor] = ir;
+
+	/* if we have the tx device, load the 'firmware'.  We do this
+	   after registering with lirc as otherwise hotplug seems to take
+	   10s to create the lirc device.
+	 */
+	if (have_tx) {
+		/* Special TX init */
+		ret = tx_init(ir);
+		if (ret != 0)
+			goto err;
+	}
+	return 0;
+
+err:
+	/* undo everything, hopefully... */
+	if (ir->c_rx.addr)
+		ir_detach(&ir->c_rx);
+	if (ir->c_tx.addr)
+		ir_detach(&ir->c_tx);
+	return ret;
+}
+
+static int ir_detach(struct i2c_client *client)
+{
+	struct IR *ir = i2c_get_clientdata(client);
+	mutex_lock(&ir->lock);
+
+	if (client == &ir->c_rx) {
+		DECLARE_COMPLETION(tn);
+		DECLARE_COMPLETION(tn2);
+
+		/* end up polling thread */
+		if (ir->task && !IS_ERR(ir->task)) {
+			ir->t_notify = &tn;
+			ir->t_notify2 = &tn2;
+			ir->shutdown = 1;
+			wake_up_process(ir->task);
+			complete(&tn2);
+			wait_for_completion(&tn);
+			ir->t_notify = NULL;
+			ir->t_notify2 = NULL;
+		}
+
+		/* unregister device */
+		i2c_detach_client(&ir->c_rx);
+	} else if (client == &ir->c_tx) {
+		i2c_detach_client(&ir->c_tx);
+	} else {
+		mutex_unlock(&ir->lock);
+		zilog_error("ir_detach: detached from something we didn't "
+			    "attach to\n");
+		return -ENODEV;
+	}
+
+	--ir->devs;
+	if (ir->devs < 0) {
+		mutex_unlock(&ir->lock);
+		zilog_error("ir_detach: invalid device count\n");
+		return -ENODEV;
+	} else if (ir->devs == 0) {
+		/* unregister lirc plugin */
+		if (ir->l.minor >= 0 && ir->l.minor < MAX_IRCTL_DEVICES) {
+			lirc_unregister_plugin(ir->l.minor);
+			ir_devices[ir->l.minor] = NULL;
+		}
+
+		/* free memory */
+		lirc_buffer_free(&ir->buf);
+		mutex_unlock(&ir->lock);
+		kfree(ir);
+		return 0;
+	}
+	mutex_unlock(&ir->lock);
+	return 0;
+}
+
+static int ir_probe(struct i2c_adapter *adap)
+{
+	struct i2c_client c;
+	char buf;
+
+	if (adap->id == I2C_HW_B_BT848 ||
+	    adap->id == I2C_HW_B_CX2341X) {
+		int have_rx = 0, have_tx = 0;
+
+		/*
+		 * The external IR receiver is at i2c address 0x71.
+		 * The IR transmitter is at 0x70.
+		 */
+		memset(&c, 0, sizeof(c));
+		c.adapter = adap;
+		c.addr = 0x70;
+
+		if (!disable_rx) {
+			if (i2c_master_recv(&c, &buf, 1) == 1)
+				have_rx = 1;
+			dprintk("probe 0x70 @ %s: %s\n",
+				adap->name,
+				have_rx ? "yes" : "no");
+		}
+
+		if (!disable_tx) {
+			c.addr = 0x71;
+			if (i2c_master_recv(&c, &buf, 1) == 1)
+				have_tx = 1;
+			dprintk("probe 0x71 @ %s: %s\n",
+				adap->name,
+				have_tx ? "yes" : "no");
+		}
+
+		if (have_rx || have_tx)
+			return ir_attach(adap, have_rx, have_tx);
+		else
+			zilog_error("%s: no devices found\n", adap->name);
+	}
+
+	return 0;
+}
+
+static int ir_command(struct i2c_client *client, unsigned int cmd, void *arg)
+{
+	/* nothing */
+	return 0;
+}
+
+/* ----------------------------------------------------------------------- */
+#ifdef MODULE
+
+int init_module(void)
+{
+	mutex_init(&tx_data_lock);
+	request_module("ivtv");
+	request_module("firmware_class");
+	i2c_add_driver(&driver);
+	return 0;
+}
+
+void cleanup_module(void)
+{
+	i2c_del_driver(&driver);
+	/* if loaded */
+	fw_unload();
+}
+
+MODULE_DESCRIPTION("Zilog/Hauppauge infrared transmitter driver (i2c stack)");
+MODULE_AUTHOR("Gerd Knorr, Michal Kochanowicz, Christoph Bartelmus, "
+	      "Ulrich Mueller, Stefan Jahn, Jerome Brock, Mark Weaver");
+MODULE_LICENSE("GPL");
+/* for compat with old name, which isn't all that accurate anymore */
+MODULE_ALIAS("lirc_pvr150");
+
+module_param(minor, int, 0444);
+MODULE_PARM_DESC(minor, "Preferred minor device number");
+
+module_param(debug, bool, 0644);
+MODULE_PARM_DESC(debug, "Enable debugging messages");
+
+module_param(disable_rx, bool, 0644);
+MODULE_PARM_DESC(disable_rx, "Disable the IR receiver device");
+
+module_param(disable_tx, bool, 0644);
+MODULE_PARM_DESC(disable_tx, "Disable the IR transmitter device");
+
+#endif /* MODULE */
+
+/*
+ * Overrides for Emacs so that we follow Linus's tabbing style.
+ * ---------------------------------------------------------------------------
+ * Local variables:
+ * c-basic-offset: 8
+ * End:
+ */
-- 
1.6.0.1

