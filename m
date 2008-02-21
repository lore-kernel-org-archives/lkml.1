Return-Path: <linux-kernel-owner+w=401wt.eu-S1764195AbYBUJoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764195AbYBUJoQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 04:44:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753004AbYBUJn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 04:43:56 -0500
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:39495 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758976AbYBUJnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 04:43:51 -0500
To: linux-kernel@vger.kernel.org
Cc: virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       linux-fbdev-devel@lists.sourceforge.net, adaplas@pol.net,
       linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
       akpm@linux-foundation.org, jayakumar.lkml@gmail.com
Subject: [PATCH 2/2] xen pvfb: Para-virtual framebuffer, keyboard and pointer driver
References: <871w76ejdg.fsf@pike.pond.sub.org>
From: Markus Armbruster <armbru@redhat.com>
Date: Thu, 21 Feb 2008 10:43:39 +0100
Message-ID: <87skzmd4qc.fsf@pike.pond.sub.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a pair of Xen para-virtual frontend device drivers:
drivers/video/xen-fbfront.c provides a framebuffer, and
drivers/input/xen-kbdfront provides keyboard and mouse.

The backends run in dom0 user space.

Signed-off-by: Markus Armbruster <armbru@redhat.com>

---

 drivers/input/Kconfig            |    9 
 drivers/input/Makefile           |    2 
 drivers/input/xen-kbdfront.c     |  337 +++++++++++++++++++++++
 drivers/video/Kconfig            |   14 
 drivers/video/Makefile           |    1 
 drivers/video/xen-fbfront.c      |  550 +++++++++++++++++++++++++++++++++++++++
 include/xen/interface/io/fbif.h  |  124 ++++++++
 include/xen/interface/io/kbdif.h |  114 ++++++++
 8 files changed, 1151 insertions(+)

diff --git a/drivers/input/Kconfig b/drivers/input/Kconfig
index 9dea14d..5f9d860 100644
--- a/drivers/input/Kconfig
+++ b/drivers/input/Kconfig
@@ -149,6 +149,15 @@ config INPUT_APMPOWER
 	  To compile this driver as a module, choose M here: the
 	  module will be called apm-power.
 
+config XEN_KBDDEV_FRONTEND
+	tristate "Xen virtual keyboard and mouse support"
+	depends on XEN_FBDEV_FRONTEND
+	default y
+	help
+	  This driver implements the front-end of the Xen virtual
+	  keyboard and mouse device driver.  It communicates with a back-end
+	  in another domain.
+
 comment "Input Device Drivers"
 
 source "drivers/input/keyboard/Kconfig"
diff --git a/drivers/input/Makefile b/drivers/input/Makefile
index 2ae87b1..98c4f9a 100644
--- a/drivers/input/Makefile
+++ b/drivers/input/Makefile
@@ -23,3 +23,5 @@ obj-$(CONFIG_INPUT_TOUCHSCREEN)	+= touchscreen/
 obj-$(CONFIG_INPUT_MISC)	+= misc/
 
 obj-$(CONFIG_INPUT_APMPOWER)	+= apm-power.o
+
+obj-$(CONFIG_XEN_KBDDEV_FRONTEND)	+= xen-kbdfront.o
diff --git a/drivers/input/xen-kbdfront.c b/drivers/input/xen-kbdfront.c
new file mode 100644
index 0000000..84f65cf
--- /dev/null
+++ b/drivers/input/xen-kbdfront.c
@@ -0,0 +1,337 @@
+/*
+ * Xen para-virtual input device
+ *
+ * Copyright (C) 2005 Anthony Liguori <aliguori@us.ibm.com>
+ * Copyright (C) 2006-2008 Red Hat, Inc., Markus Armbruster <armbru@redhat.com>
+ *
+ *  Based on linux/drivers/input/mouse/sermouse.c
+ *
+ *  This file is subject to the terms and conditions of the GNU General Public
+ *  License. See the file COPYING in the main directory of this archive for
+ *  more details.
+ */
+
+/*
+ * TODO:
+ *
+ * Switch to grant tables together with xen-fbfront.c.
+ */
+
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/module.h>
+#include <linux/input.h>
+#include <asm/xen/hypervisor.h>
+#include <xen/events.h>
+#include <xen/page.h>
+#include <xen/interface/io/fbif.h>
+#include <xen/interface/io/kbdif.h>
+#include <xen/xenbus.h>
+
+struct xenkbd_info {
+	struct input_dev *kbd;
+	struct input_dev *ptr;
+	struct xenkbd_page *page;
+	int evtchn, irq;
+	struct xenbus_device *xbdev;
+	char phys[32];
+};
+
+static int xenkbd_remove(struct xenbus_device *);
+static int xenkbd_connect_backend(struct xenbus_device *, struct xenkbd_info *);
+static void xenkbd_disconnect_backend(struct xenkbd_info *);
+
+/*
+ * Note: if you need to send out events, see xenfb_do_update() for how
+ * to do that.
+ */
+
+static irqreturn_t input_handler(int rq, void *dev_id)
+{
+	struct xenkbd_info *info = dev_id;
+	struct xenkbd_page *page = info->page;
+	__u32 cons, prod;
+
+	prod = page->in_prod;
+	if (prod == page->in_cons)
+		return IRQ_HANDLED;
+	rmb();			/* ensure we see ring contents up to prod */
+	for (cons = page->in_cons; cons != prod; cons++) {
+		union xenkbd_in_event *event;
+		struct input_dev *dev;
+		event = &XENKBD_IN_RING_REF(page, cons);
+
+		dev = info->ptr;
+		switch (event->type) {
+		case XENKBD_TYPE_MOTION:
+			input_report_rel(dev, REL_X, event->motion.rel_x);
+			input_report_rel(dev, REL_Y, event->motion.rel_y);
+			break;
+		case XENKBD_TYPE_KEY:
+			dev = NULL;
+			if (test_bit(event->key.keycode, info->kbd->keybit))
+				dev = info->kbd;
+			if (test_bit(event->key.keycode, info->ptr->keybit))
+				dev = info->ptr;
+			if (dev)
+				input_report_key(dev, event->key.keycode,
+						 event->key.pressed);
+			else
+				printk(KERN_WARNING
+				       "xenkbd: unhandled keycode 0x%x\n",
+				       event->key.keycode);
+			break;
+		case XENKBD_TYPE_POS:
+			input_report_abs(dev, ABS_X, event->pos.abs_x);
+			input_report_abs(dev, ABS_Y, event->pos.abs_y);
+			break;
+		}
+		if (dev)
+			input_sync(dev);
+	}
+	mb();			/* ensure we got ring contents */
+	page->in_cons = cons;
+	notify_remote_via_irq(info->irq);
+
+	return IRQ_HANDLED;
+}
+
+static int __devinit xenkbd_probe(struct xenbus_device *dev,
+				  const struct xenbus_device_id *id)
+{
+	int ret, i;
+	struct xenkbd_info *info;
+	struct input_dev *kbd, *ptr;
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info) {
+		xenbus_dev_fatal(dev, -ENOMEM, "allocating info structure");
+		return -ENOMEM;
+	}
+	dev->dev.driver_data = info;
+	info->xbdev = dev;
+	snprintf(info->phys, sizeof(info->phys), "xenbus/%s", dev->nodename);
+
+	info->page = (void *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
+	if (!info->page)
+		goto error_nomem;
+
+	/* keyboard */
+	kbd = input_allocate_device();
+	if (!kbd)
+		goto error_nomem;
+	kbd->name = "Xen Virtual Keyboard";
+	kbd->phys = info->phys;
+	kbd->id.bustype = BUS_PCI;
+	kbd->id.vendor = 0x5853;
+	kbd->id.product = 0xffff;
+	kbd->evbit[0] = BIT(EV_KEY);
+	for (i = KEY_ESC; i < KEY_UNKNOWN; i++)
+		set_bit(i, kbd->keybit);
+	for (i = KEY_OK; i < KEY_MAX; i++)
+		set_bit(i, kbd->keybit);
+
+	ret = input_register_device(kbd);
+	if (ret) {
+		input_free_device(kbd);
+		xenbus_dev_fatal(dev, ret, "input_register_device(kbd)");
+		goto error;
+	}
+	info->kbd = kbd;
+
+	/* pointing device */
+	ptr = input_allocate_device();
+	if (!ptr)
+		goto error_nomem;
+	ptr->name = "Xen Virtual Pointer";
+	ptr->phys = info->phys;
+	ptr->id.bustype = BUS_PCI;
+	ptr->id.vendor = 0x5853;
+	ptr->id.product = 0xfffe;
+	ptr->evbit[0] = BIT(EV_KEY) | BIT(EV_REL) | BIT(EV_ABS);
+	for (i = BTN_LEFT; i <= BTN_TASK; i++)
+		set_bit(i, ptr->keybit);
+	ptr->relbit[0] = BIT(REL_X) | BIT(REL_Y);
+	input_set_abs_params(ptr, ABS_X, 0, XENFB_WIDTH, 0, 0);
+	input_set_abs_params(ptr, ABS_Y, 0, XENFB_HEIGHT, 0, 0);
+
+	ret = input_register_device(ptr);
+	if (ret) {
+		input_free_device(ptr);
+		xenbus_dev_fatal(dev, ret, "input_register_device(ptr)");
+		goto error;
+	}
+	info->ptr = ptr;
+
+	ret = xenkbd_connect_backend(dev, info);
+	if (ret < 0)
+		goto error;
+
+	return 0;
+
+ error_nomem:
+	ret = -ENOMEM;
+	xenbus_dev_fatal(dev, ret, "allocating device memory");
+ error:
+	xenkbd_remove(dev);
+	return ret;
+}
+
+static int xenkbd_resume(struct xenbus_device *dev)
+{
+	struct xenkbd_info *info = dev->dev.driver_data;
+
+	xenkbd_disconnect_backend(info);
+	memset(info->page, 0, PAGE_SIZE);
+	return xenkbd_connect_backend(dev, info);
+}
+
+static int xenkbd_remove(struct xenbus_device *dev)
+{
+	struct xenkbd_info *info = dev->dev.driver_data;
+
+	xenkbd_disconnect_backend(info);
+	input_unregister_device(info->kbd);
+	input_unregister_device(info->ptr);
+	free_page((unsigned long)info->page);
+	kfree(info);
+	return 0;
+}
+
+static int xenkbd_connect_backend(struct xenbus_device *dev,
+				  struct xenkbd_info *info)
+{
+	int ret;
+	struct xenbus_transaction xbt;
+
+	ret = xenbus_alloc_evtchn(dev, &info->evtchn);
+	if (ret)
+		return ret;
+	ret = bind_evtchn_to_irqhandler(info->evtchn, input_handler,
+					0, dev->devicetype, info);
+	if (ret < 0) {
+		xenbus_free_evtchn(dev, info->evtchn);
+		xenbus_dev_fatal(dev, ret, "bind_evtchn_to_irqhandler");
+		return ret;
+	}
+	info->irq = ret;
+
+ again:
+	ret = xenbus_transaction_start(&xbt);
+	if (ret) {
+		xenbus_dev_fatal(dev, ret, "starting transaction");
+		return ret;
+	}
+	ret = xenbus_printf(xbt, dev->nodename, "page-ref", "%lu",
+			    virt_to_mfn(info->page));
+	if (ret)
+		goto error_xenbus;
+	ret = xenbus_printf(xbt, dev->nodename, "event-channel", "%u",
+			    info->evtchn);
+	if (ret)
+		goto error_xenbus;
+	ret = xenbus_transaction_end(xbt, 0);
+	if (ret) {
+		if (ret == -EAGAIN)
+			goto again;
+		xenbus_dev_fatal(dev, ret, "completing transaction");
+		return ret;
+	}
+
+	xenbus_switch_state(dev, XenbusStateInitialised);
+	return 0;
+
+ error_xenbus:
+	xenbus_transaction_end(xbt, 1);
+	xenbus_dev_fatal(dev, ret, "writing xenstore");
+	return ret;
+}
+
+static void xenkbd_disconnect_backend(struct xenkbd_info *info)
+{
+	if (info->irq >= 0)
+		unbind_from_irqhandler(info->irq, info);
+	info->evtchn = info->irq = -1;
+}
+
+static void xenkbd_backend_changed(struct xenbus_device *dev,
+				   enum xenbus_state backend_state)
+{
+	struct xenkbd_info *info = dev->dev.driver_data;
+	int ret, val;
+
+	switch (backend_state) {
+	case XenbusStateInitialising:
+	case XenbusStateInitialised:
+	case XenbusStateUnknown:
+	case XenbusStateClosed:
+		break;
+
+	case XenbusStateInitWait:
+InitWait:
+		ret = xenbus_scanf(XBT_NIL, info->xbdev->otherend,
+				   "feature-abs-pointer", "%d", &val);
+		if (ret < 0)
+			val = 0;
+		if (val) {
+			ret = xenbus_printf(XBT_NIL, info->xbdev->nodename,
+					    "request-abs-pointer", "1");
+			if (ret)
+				printk(KERN_WARNING
+				       "xenkbd: can't request abs-pointer");
+		}
+		xenbus_switch_state(dev, XenbusStateConnected);
+		break;
+
+	case XenbusStateConnected:
+		/*
+		 * Work around xenbus race condition: If backend goes
+		 * through InitWait to Connected fast enough, we can
+		 * get Connected twice here.
+		 */
+		if (dev->state != XenbusStateConnected)
+			goto InitWait; /* no InitWait seen yet, fudge it */
+		break;
+
+	case XenbusStateClosing:
+		xenbus_frontend_closed(dev);
+		break;
+	}
+}
+
+static struct xenbus_device_id xenkbd_ids[] = {
+	{ "vkbd" },
+	{ "" }
+};
+
+static struct xenbus_driver xenkbd = {
+	.name = "vkbd",
+	.owner = THIS_MODULE,
+	.ids = xenkbd_ids,
+	.probe = xenkbd_probe,
+	.remove = xenkbd_remove,
+	.resume = xenkbd_resume,
+	.otherend_changed = xenkbd_backend_changed,
+};
+
+static int __init xenkbd_init(void)
+{
+	if (!is_running_on_xen())
+		return -ENODEV;
+
+	/* Nothing to do if running in dom0. */
+	if (is_initial_xendomain())
+		return -ENODEV;
+
+	return xenbus_register_frontend(&xenkbd);
+}
+
+static void __exit xenkbd_cleanup(void)
+{
+	xenbus_unregister_driver(&xenkbd);
+}
+
+module_init(xenkbd_init);
+module_exit(xenkbd_cleanup);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 758435f..67de177 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -1903,6 +1903,20 @@ config FB_VIRTUAL
 
 	  If unsure, say N.
 
+config XEN_FBDEV_FRONTEND
+	tristate "Xen virtual frame buffer support"
+	depends on FB && XEN
+	select FB_SYS_FILLRECT
+	select FB_SYS_COPYAREA
+	select FB_SYS_IMAGEBLIT
+	select FB_SYS_FOPS
+	select FB_DEFERRED_IO
+	default y
+	help
+	  This driver implements the front-end of the Xen virtual
+	  frame buffer driver.  It communicates with a back-end
+	  in another domain.
+
 source "drivers/video/omap/Kconfig"
 
 source "drivers/video/backlight/Kconfig"
diff --git a/drivers/video/Makefile b/drivers/video/Makefile
index 83e02b3..d3ab9b2 100644
--- a/drivers/video/Makefile
+++ b/drivers/video/Makefile
@@ -113,6 +113,7 @@ obj-$(CONFIG_FB_PS3)		  += ps3fb.o
 obj-$(CONFIG_FB_SM501)            += sm501fb.o
 obj-$(CONFIG_FB_XILINX)           += xilinxfb.o
 obj-$(CONFIG_FB_OMAP)             += omap/
+obj-$(CONFIG_XEN_FBDEV_FRONTEND)  += xen-fbfront.o
 
 # Platform or fallback drivers go here
 obj-$(CONFIG_FB_UVESA)            += uvesafb.o
diff --git a/drivers/video/xen-fbfront.c b/drivers/video/xen-fbfront.c
new file mode 100644
index 0000000..bf8f900
--- /dev/null
+++ b/drivers/video/xen-fbfront.c
@@ -0,0 +1,550 @@
+/*
+ * Xen para-virtual frame buffer device
+ *
+ * Copyright (C) 2005-2006 Anthony Liguori <aliguori@us.ibm.com>
+ * Copyright (C) 2006-2008 Red Hat, Inc., Markus Armbruster <armbru@redhat.com>
+ *
+ *  Based on linux/drivers/video/q40fb.c
+ *
+ *  This file is subject to the terms and conditions of the GNU General Public
+ *  License. See the file COPYING in the main directory of this archive for
+ *  more details.
+ */
+
+/*
+ * TODO:
+ *
+ * Switch to grant tables when they become capable of dealing with the
+ * frame buffer.
+ */
+
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/fb.h>
+#include <linux/module.h>
+#include <linux/vmalloc.h>
+#include <linux/mm.h>
+#include <asm/xen/hypervisor.h>
+#include <xen/events.h>
+#include <xen/page.h>
+#include <xen/interface/io/fbif.h>
+#include <xen/interface/io/protocols.h>
+#include <xen/xenbus.h>
+
+struct xenfb_info {
+	unsigned char		*fb;
+	struct fb_info		*fb_info;
+	int			x1, y1, x2, y2;	/* dirty rectangle,
+						   protected by dirty_lock */
+	spinlock_t		dirty_lock;
+	int			nr_pages;
+	int			evtchn, irq;
+	struct xenfb_page	*page;
+	unsigned long 		*mfns;
+	int			update_wanted; /* XENFB_TYPE_UPDATE wanted */
+
+	struct xenbus_device	*xbdev;
+};
+
+static u32 xenfb_mem_len = XENFB_WIDTH * XENFB_HEIGHT * XENFB_DEPTH / 8;
+
+static int xenfb_remove(struct xenbus_device *);
+static void xenfb_init_shared_page(struct xenfb_info *);
+static int xenfb_connect_backend(struct xenbus_device *, struct xenfb_info *);
+static void xenfb_disconnect_backend(struct xenfb_info *);
+
+static void xenfb_do_update(struct xenfb_info *info,
+			    int x, int y, int w, int h)
+{
+	union xenfb_out_event event;
+	u32 prod;
+
+	event.type = XENFB_TYPE_UPDATE;
+	event.update.x = x;
+	event.update.y = y;
+	event.update.width = w;
+	event.update.height = h;
+
+	prod = info->page->out_prod;
+	/* caller ensures !xenfb_queue_full() */
+	mb();			/* ensure ring space available */
+	XENFB_OUT_RING_REF(info->page, prod) = event;
+	wmb();			/* ensure ring contents visible */
+	info->page->out_prod = prod + 1;
+
+	notify_remote_via_irq(info->irq);
+}
+
+static int xenfb_queue_full(struct xenfb_info *info)
+{
+	u32 cons, prod;
+
+	prod = info->page->out_prod;
+	cons = info->page->out_cons;
+	return prod - cons == XENFB_OUT_RING_LEN;
+}
+
+static void xenfb_refresh(struct xenfb_info *info,
+			  int x1, int y1, int w, int h)
+{
+	unsigned long flags;
+	int y2 = y1 + h - 1;
+	int x2 = x1 + w - 1;
+
+	if (!info->update_wanted)
+		return;
+
+	spin_lock_irqsave(&info->dirty_lock, flags);
+
+	/* Combine with dirty rectangle: */
+	if (info->y1 < y1)
+		y1 = info->y1;
+	if (info->y2 > y2)
+		y2 = info->y2;
+	if (info->x1 < x1)
+		x1 = info->x1;
+	if (info->x2 > x2)
+		x2 = info->x2;
+
+	if (xenfb_queue_full(info)) {
+		/* Can't send right now, stash it in the dirty rectangle */
+		info->x1 = x1;
+		info->x2 = x2;
+		info->y1 = y1;
+		info->y2 = y2;
+		spin_unlock_irqrestore(&info->dirty_lock, flags);
+		return;
+	}
+
+	/* Clear dirty rectangle: */
+	info->x1 = info->y1 = INT_MAX;
+	info->x2 = info->y2 = 0;
+
+	spin_unlock_irqrestore(&info->dirty_lock, flags);
+
+	if (x1 <= x2 && y1 <= y2)
+		xenfb_do_update(info, x1, y1, x2 - x1 + 1, y2 - y1 + 1);
+}
+
+static void xenfb_deferred_io(struct fb_info *fb_info,
+			      struct list_head *pagelist)
+{
+	struct xenfb_info *info = fb_info->par;
+	struct page *page;
+	unsigned long beg, end;
+	int y1, y2, miny, maxy;
+
+	miny = INT_MAX;
+	maxy = 0;
+	list_for_each_entry(page, pagelist, lru) {
+		beg = page->index << PAGE_SHIFT;
+		end = beg + PAGE_SIZE - 1;
+		y1 = beg / fb_info->fix.line_length;
+		y2 = end / fb_info->fix.line_length;
+		if (y2 >= fb_info->var.yres)
+			y2 = fb_info->var.yres - 1;
+		if (miny > y1)
+			miny = y1;
+		if (maxy < y2)
+			maxy = y2;
+	}
+	xenfb_refresh(info, 0, miny, fb_info->var.xres, maxy - miny + 1);
+}
+
+static struct fb_deferred_io xenfb_defio = {
+	.delay		= HZ / 20,
+	.deferred_io	= xenfb_deferred_io,
+};
+
+static int xenfb_setcolreg(unsigned regno, unsigned red, unsigned green,
+			   unsigned blue, unsigned transp,
+			   struct fb_info *info)
+{
+	u32 v;
+
+	if (regno > info->cmap.len)
+		return 1;
+
+#define CNVT_TOHW(val, width) ((((val)<<(width))+0x7FFF-(val))>>16)
+	red = CNVT_TOHW(red, info->var.red.length);
+	green = CNVT_TOHW(green, info->var.green.length);
+	blue = CNVT_TOHW(blue, info->var.blue.length);
+	transp = CNVT_TOHW(transp, info->var.transp.length);
+#undef CNVT_TOHW
+
+	v = (red << info->var.red.offset) |
+	    (green << info->var.green.offset) |
+	    (blue << info->var.blue.offset);
+
+	switch (info->var.bits_per_pixel) {
+	case 16:
+	case 24:
+	case 32:
+		((u32 *)info->pseudo_palette)[regno] = v;
+		break;
+	}
+
+	return 0;
+}
+
+static void xenfb_fillrect(struct fb_info *p, const struct fb_fillrect *rect)
+{
+	struct xenfb_info *info = p->par;
+
+	sys_fillrect(p, rect);
+	xenfb_refresh(info, rect->dx, rect->dy, rect->width, rect->height);
+}
+
+static void xenfb_imageblit(struct fb_info *p, const struct fb_image *image)
+{
+	struct xenfb_info *info = p->par;
+
+	sys_imageblit(p, image);
+	xenfb_refresh(info, image->dx, image->dy, image->width, image->height);
+}
+
+static void xenfb_copyarea(struct fb_info *p, const struct fb_copyarea *area)
+{
+	struct xenfb_info *info = p->par;
+
+	sys_copyarea(p, area);
+	xenfb_refresh(info, area->dx, area->dy, area->width, area->height);
+}
+
+static ssize_t xenfb_write(struct fb_info *p, const char __user *buf,
+			size_t count, loff_t *ppos)
+{
+	struct xenfb_info *info = p->par;
+	ssize_t res;
+
+	res = fb_sys_write(p, buf, count, ppos);
+	xenfb_refresh(info, 0, 0, info->page->width, info->page->height);
+	return res;
+}
+
+static struct fb_ops xenfb_fb_ops = {
+	.owner		= THIS_MODULE,
+	.fb_read	= fb_sys_read,
+	.fb_write	= xenfb_write,
+	.fb_setcolreg	= xenfb_setcolreg,
+	.fb_fillrect	= xenfb_fillrect,
+	.fb_copyarea	= xenfb_copyarea,
+	.fb_imageblit	= xenfb_imageblit,
+};
+
+static irqreturn_t xenfb_event_handler(int rq, void *dev_id)
+{
+	/*
+	 * No in events recognized, simply ignore them all.
+	 * If you need to recognize some, see xen-kbdfront's
+	 * input_handler() for how to do that.
+	 */
+	struct xenfb_info *info = dev_id;
+	struct xenfb_page *page = info->page;
+
+	if (page->in_cons != page->in_prod) {
+		info->page->in_cons = info->page->in_prod;
+		notify_remote_via_irq(info->irq);
+	}
+
+	/* Flush dirty rectangle: */
+	xenfb_refresh(info, INT_MAX, INT_MAX, -INT_MAX, -INT_MAX);
+
+	return IRQ_HANDLED;
+}
+
+static int __devinit xenfb_probe(struct xenbus_device *dev,
+				 const struct xenbus_device_id *id)
+{
+	struct xenfb_info *info;
+	struct fb_info *fb_info;
+	int ret;
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (info == NULL) {
+		xenbus_dev_fatal(dev, -ENOMEM, "allocating info structure");
+		return -ENOMEM;
+	}
+	dev->dev.driver_data = info;
+	info->xbdev = dev;
+	info->irq = -1;
+	info->x1 = info->y1 = INT_MAX;
+	spin_lock_init(&info->dirty_lock);
+
+	info->fb = vmalloc(xenfb_mem_len);
+	if (info->fb == NULL)
+		goto error_nomem;
+	memset(info->fb, 0, xenfb_mem_len);
+
+	info->nr_pages = (xenfb_mem_len + PAGE_SIZE - 1) >> PAGE_SHIFT;
+
+	info->mfns = vmalloc(sizeof(unsigned long) * info->nr_pages);
+	if (!info->mfns)
+		goto error_nomem;
+
+	/* set up shared page */
+	info->page = (void *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
+	if (!info->page)
+		goto error_nomem;
+
+	xenfb_init_shared_page(info);
+
+	/* abusing framebuffer_alloc() to allocate pseudo_palette */
+	fb_info = framebuffer_alloc(sizeof(u32) * 256, NULL);
+	if (fb_info == NULL)
+		goto error_nomem;
+
+	/* complete the abuse: */
+	fb_info->pseudo_palette = fb_info->par;
+	fb_info->par = info;
+
+	fb_info->screen_base = info->fb;
+
+	fb_info->fbops = &xenfb_fb_ops;
+	fb_info->var.xres_virtual = fb_info->var.xres = info->page->width;
+	fb_info->var.yres_virtual = fb_info->var.yres = info->page->height;
+	fb_info->var.bits_per_pixel = info->page->depth;
+
+	fb_info->var.red = (struct fb_bitfield){16, 8, 0};
+	fb_info->var.green = (struct fb_bitfield){8, 8, 0};
+	fb_info->var.blue = (struct fb_bitfield){0, 8, 0};
+
+	fb_info->var.activate = FB_ACTIVATE_NOW;
+	fb_info->var.height = -1;
+	fb_info->var.width = -1;
+	fb_info->var.vmode = FB_VMODE_NONINTERLACED;
+
+	fb_info->fix.visual = FB_VISUAL_TRUECOLOR;
+	fb_info->fix.line_length = info->page->line_length;
+	fb_info->fix.smem_start = 0;
+	fb_info->fix.smem_len = xenfb_mem_len;
+	strcpy(fb_info->fix.id, "xen");
+	fb_info->fix.type = FB_TYPE_PACKED_PIXELS;
+	fb_info->fix.accel = FB_ACCEL_NONE;
+
+	fb_info->flags = FBINFO_FLAG_DEFAULT;
+
+	ret = fb_alloc_cmap(&fb_info->cmap, 256, 0);
+	if (ret < 0) {
+		framebuffer_release(fb_info);
+		xenbus_dev_fatal(dev, ret, "fb_alloc_cmap");
+		goto error;
+	}
+
+	fb_info->fbdefio = &xenfb_defio;
+	fb_deferred_io_init(fb_info);
+
+	ret = register_framebuffer(fb_info);
+	if (ret) {
+		fb_dealloc_cmap(&fb_info->cmap);
+		fb_deferred_io_cleanup(fb_info);
+		framebuffer_release(fb_info);
+		xenbus_dev_fatal(dev, ret, "register_framebuffer");
+		goto error;
+	}
+	info->fb_info = fb_info;
+
+	ret = xenfb_connect_backend(dev, info);
+	if (ret < 0)
+		goto error;
+
+	return 0;
+
+ error_nomem:
+	ret = -ENOMEM;
+	xenbus_dev_fatal(dev, ret, "allocating device memory");
+ error:
+	xenfb_remove(dev);
+	return ret;
+}
+
+static int xenfb_resume(struct xenbus_device *dev)
+{
+	struct xenfb_info *info = dev->dev.driver_data;
+
+	xenfb_disconnect_backend(info);
+	xenfb_init_shared_page(info);
+	return xenfb_connect_backend(dev, info);
+}
+
+static int xenfb_remove(struct xenbus_device *dev)
+{
+	struct xenfb_info *info = dev->dev.driver_data;
+
+	xenfb_disconnect_backend(info);
+	if (info->fb_info) {
+		fb_deferred_io_cleanup(info->fb_info);
+		unregister_framebuffer(info->fb_info);
+		fb_dealloc_cmap(&info->fb_info->cmap);
+		framebuffer_release(info->fb_info);
+	}
+	free_page((unsigned long)info->page);
+	vfree(info->mfns);
+	vfree(info->fb);
+	kfree(info);
+
+	return 0;
+}
+
+static unsigned long vmalloc_to_mfn(void *address)
+{
+	return pfn_to_mfn(vmalloc_to_pfn(address));
+}
+
+static void xenfb_init_shared_page(struct xenfb_info *info)
+{
+	int i;
+
+	for (i = 0; i < info->nr_pages; i++)
+		info->mfns[i] = vmalloc_to_mfn(info->fb + i * PAGE_SIZE);
+
+	info->page->pd[0] = vmalloc_to_mfn(info->mfns);
+	info->page->pd[1] = 0;
+	info->page->width = XENFB_WIDTH;
+	info->page->height = XENFB_HEIGHT;
+	info->page->depth = XENFB_DEPTH;
+	info->page->line_length = (info->page->depth / 8) * info->page->width;
+	info->page->mem_length = xenfb_mem_len;
+	info->page->in_cons = info->page->in_prod = 0;
+	info->page->out_cons = info->page->out_prod = 0;
+}
+
+static int xenfb_connect_backend(struct xenbus_device *dev,
+				 struct xenfb_info *info)
+{
+	int ret;
+	struct xenbus_transaction xbt;
+
+	ret = xenbus_alloc_evtchn(dev, &info->evtchn);
+	if (ret)
+		return ret;
+	ret = bind_evtchn_to_irqhandler(info->evtchn, xenfb_event_handler,
+					0, dev->devicetype, info);
+	if (ret < 0) {
+		xenbus_free_evtchn(dev, info->evtchn);
+		xenbus_dev_fatal(dev, ret, "bind_evtchn_to_irqhandler");
+		return ret;
+	}
+	info->irq = ret;
+
+ again:
+	ret = xenbus_transaction_start(&xbt);
+	if (ret) {
+		xenbus_dev_fatal(dev, ret, "starting transaction");
+		return ret;
+	}
+	ret = xenbus_printf(xbt, dev->nodename, "page-ref", "%lu",
+			    virt_to_mfn(info->page));
+	if (ret)
+		goto error_xenbus;
+	ret = xenbus_printf(xbt, dev->nodename, "event-channel", "%u",
+			    info->evtchn);
+	if (ret)
+		goto error_xenbus;
+	ret = xenbus_printf(xbt, dev->nodename, "protocol", "%s",
+			    XEN_IO_PROTO_ABI_NATIVE);
+	if (ret)
+		goto error_xenbus;
+	ret = xenbus_printf(xbt, dev->nodename, "feature-update", "1");
+	if (ret)
+		goto error_xenbus;
+	ret = xenbus_transaction_end(xbt, 0);
+	if (ret) {
+		if (ret == -EAGAIN)
+			goto again;
+		xenbus_dev_fatal(dev, ret, "completing transaction");
+		return ret;
+	}
+
+	xenbus_switch_state(dev, XenbusStateInitialised);
+	return 0;
+
+ error_xenbus:
+	xenbus_transaction_end(xbt, 1);
+	xenbus_dev_fatal(dev, ret, "writing xenstore");
+	return ret;
+}
+
+static void xenfb_disconnect_backend(struct xenfb_info *info)
+{
+	if (info->irq >= 0)
+		unbind_from_irqhandler(info->irq, info);
+	info->irq = -1;
+}
+
+static void xenfb_backend_changed(struct xenbus_device *dev,
+				  enum xenbus_state backend_state)
+{
+	struct xenfb_info *info = dev->dev.driver_data;
+	int val;
+
+	switch (backend_state) {
+	case XenbusStateInitialising:
+	case XenbusStateInitialised:
+	case XenbusStateUnknown:
+	case XenbusStateClosed:
+		break;
+
+	case XenbusStateInitWait:
+InitWait:
+		xenbus_switch_state(dev, XenbusStateConnected);
+		break;
+
+	case XenbusStateConnected:
+		/*
+		 * Work around xenbus race condition: If backend goes
+		 * through InitWait to Connected fast enough, we can
+		 * get Connected twice here.
+		 */
+		if (dev->state != XenbusStateConnected)
+			goto InitWait; /* no InitWait seen yet, fudge it */
+
+		if (xenbus_scanf(XBT_NIL, info->xbdev->otherend,
+				 "request-update", "%d", &val) < 0)
+			val = 0;
+		if (val)
+			info->update_wanted = 1;
+		break;
+
+	case XenbusStateClosing:
+		xenbus_frontend_closed(dev);
+		break;
+	}
+}
+
+static struct xenbus_device_id xenfb_ids[] = {
+	{ "vfb" },
+	{ "" }
+};
+
+static struct xenbus_driver xenfb = {
+	.name = "vfb",
+	.owner = THIS_MODULE,
+	.ids = xenfb_ids,
+	.probe = xenfb_probe,
+	.remove = xenfb_remove,
+	.resume = xenfb_resume,
+	.otherend_changed = xenfb_backend_changed,
+};
+
+static int __init xenfb_init(void)
+{
+	if (!is_running_on_xen())
+		return -ENODEV;
+
+	/* Nothing to do if running in dom0. */
+	if (is_initial_xendomain())
+		return -ENODEV;
+
+	return xenbus_register_frontend(&xenfb);
+}
+
+static void __exit xenfb_cleanup(void)
+{
+	xenbus_unregister_driver(&xenfb);
+}
+
+module_init(xenfb_init);
+module_exit(xenfb_cleanup);
+
+MODULE_LICENSE("GPL");
diff --git a/include/xen/interface/io/fbif.h b/include/xen/interface/io/fbif.h
new file mode 100644
index 0000000..5a934dd
--- /dev/null
+++ b/include/xen/interface/io/fbif.h
@@ -0,0 +1,124 @@
+/*
+ * fbif.h -- Xen virtual frame buffer device
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this software and associated documentation files (the "Software"), to
+ * deal in the Software without restriction, including without limitation the
+ * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
+ * sell copies of the Software, and to permit persons to whom the Software is
+ * furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ * Copyright (C) 2005 Anthony Liguori <aliguori@us.ibm.com>
+ * Copyright (C) 2006 Red Hat, Inc., Markus Armbruster <armbru@redhat.com>
+ */
+
+#ifndef __XEN_PUBLIC_IO_FBIF_H__
+#define __XEN_PUBLIC_IO_FBIF_H__
+
+/* Out events (frontend -> backend) */
+
+/*
+ * Out events may be sent only when requested by backend, and receipt
+ * of an unknown out event is an error.
+ */
+
+/* Event type 1 currently not used */
+/*
+ * Framebuffer update notification event
+ * Capable frontend sets feature-update in xenstore.
+ * Backend requests it by setting request-update in xenstore.
+ */
+#define XENFB_TYPE_UPDATE 2
+
+struct xenfb_update {
+	uint8_t type;		/* XENFB_TYPE_UPDATE */
+	int32_t x;		/* source x */
+	int32_t y;		/* source y */
+	int32_t width;		/* rect width */
+	int32_t height;		/* rect height */
+};
+
+#define XENFB_OUT_EVENT_SIZE 40
+
+union xenfb_out_event {
+	uint8_t type;
+	struct xenfb_update update;
+	char pad[XENFB_OUT_EVENT_SIZE];
+};
+
+/* In events (backend -> frontend) */
+
+/*
+ * Frontends should ignore unknown in events.
+ * No in events currently defined.
+ */
+
+#define XENFB_IN_EVENT_SIZE 40
+
+union xenfb_in_event {
+	uint8_t type;
+	char pad[XENFB_IN_EVENT_SIZE];
+};
+
+/* shared page */
+
+#define XENFB_IN_RING_SIZE 1024
+#define XENFB_IN_RING_LEN (XENFB_IN_RING_SIZE / XENFB_IN_EVENT_SIZE)
+#define XENFB_IN_RING_OFFS 1024
+#define XENFB_IN_RING(page) \
+	((union xenfb_in_event *)((char *)(page) + XENFB_IN_RING_OFFS))
+#define XENFB_IN_RING_REF(page, idx) \
+	(XENFB_IN_RING((page))[(idx) % XENFB_IN_RING_LEN])
+
+#define XENFB_OUT_RING_SIZE 2048
+#define XENFB_OUT_RING_LEN (XENFB_OUT_RING_SIZE / XENFB_OUT_EVENT_SIZE)
+#define XENFB_OUT_RING_OFFS (XENFB_IN_RING_OFFS + XENFB_IN_RING_SIZE)
+#define XENFB_OUT_RING(page) \
+	((union xenfb_out_event *)((char *)(page) + XENFB_OUT_RING_OFFS))
+#define XENFB_OUT_RING_REF(page, idx) \
+	(XENFB_OUT_RING((page))[(idx) % XENFB_OUT_RING_LEN])
+
+struct xenfb_page {
+	uint32_t in_cons, in_prod;
+	uint32_t out_cons, out_prod;
+
+	int32_t width;          /* width of the framebuffer (in pixels) */
+	int32_t height;         /* height of the framebuffer (in pixels) */
+	uint32_t line_length;   /* length of a row of pixels (in bytes) */
+	uint32_t mem_length;    /* length of the framebuffer (in bytes) */
+	uint8_t depth;          /* depth of a pixel (in bits) */
+
+	/*
+	 * Framebuffer page directory
+	 *
+	 * Each directory page holds PAGE_SIZE / sizeof(*pd)
+	 * framebuffer pages, and can thus map up to PAGE_SIZE *
+	 * PAGE_SIZE / sizeof(*pd) bytes.  With PAGE_SIZE == 4096 and
+	 * sizeof(unsigned long) == 4, that's 4 Megs.  Two directory
+	 * pages should be enough for a while.
+	 */
+	unsigned long pd[2];
+};
+
+/*
+ * Wart: xenkbd needs to know resolution.  Put it here until a better
+ * solution is found, but don't leak it to the backend.
+ */
+#ifdef __KERNEL__
+#define XENFB_WIDTH 800
+#define XENFB_HEIGHT 600
+#define XENFB_DEPTH 32
+#endif
+
+#endif
diff --git a/include/xen/interface/io/kbdif.h b/include/xen/interface/io/kbdif.h
new file mode 100644
index 0000000..fb97f42
--- /dev/null
+++ b/include/xen/interface/io/kbdif.h
@@ -0,0 +1,114 @@
+/*
+ * kbdif.h -- Xen virtual keyboard/mouse
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this software and associated documentation files (the "Software"), to
+ * deal in the Software without restriction, including without limitation the
+ * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
+ * sell copies of the Software, and to permit persons to whom the Software is
+ * furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ * Copyright (C) 2005 Anthony Liguori <aliguori@us.ibm.com>
+ * Copyright (C) 2006 Red Hat, Inc., Markus Armbruster <armbru@redhat.com>
+ */
+
+#ifndef __XEN_PUBLIC_IO_KBDIF_H__
+#define __XEN_PUBLIC_IO_KBDIF_H__
+
+/* In events (backend -> frontend) */
+
+/*
+ * Frontends should ignore unknown in events.
+ */
+
+/* Pointer movement event */
+#define XENKBD_TYPE_MOTION  1
+/* Event type 2 currently not used */
+/* Key event (includes pointer buttons) */
+#define XENKBD_TYPE_KEY     3
+/*
+ * Pointer position event
+ * Capable backend sets feature-abs-pointer in xenstore.
+ * Frontend requests ot instead of XENKBD_TYPE_MOTION by setting
+ * request-abs-update in xenstore.
+ */
+#define XENKBD_TYPE_POS     4
+
+struct xenkbd_motion {
+	uint8_t type;		/* XENKBD_TYPE_MOTION */
+	int32_t rel_x;		/* relative X motion */
+	int32_t rel_y;		/* relative Y motion */
+};
+
+struct xenkbd_key {
+	uint8_t type;		/* XENKBD_TYPE_KEY */
+	uint8_t pressed;	/* 1 if pressed; 0 otherwise */
+	uint32_t keycode;	/* KEY_* from linux/input.h */
+};
+
+struct xenkbd_position {
+	uint8_t type;		/* XENKBD_TYPE_POS */
+	int32_t abs_x;		/* absolute X position (in FB pixels) */
+	int32_t abs_y;		/* absolute Y position (in FB pixels) */
+};
+
+#define XENKBD_IN_EVENT_SIZE 40
+
+union xenkbd_in_event {
+	uint8_t type;
+	struct xenkbd_motion motion;
+	struct xenkbd_key key;
+	struct xenkbd_position pos;
+	char pad[XENKBD_IN_EVENT_SIZE];
+};
+
+/* Out events (frontend -> backend) */
+
+/*
+ * Out events may be sent only when requested by backend, and receipt
+ * of an unknown out event is an error.
+ * No out events currently defined.
+ */
+
+#define XENKBD_OUT_EVENT_SIZE 40
+
+union xenkbd_out_event {
+	uint8_t type;
+	char pad[XENKBD_OUT_EVENT_SIZE];
+};
+
+/* shared page */
+
+#define XENKBD_IN_RING_SIZE 2048
+#define XENKBD_IN_RING_LEN (XENKBD_IN_RING_SIZE / XENKBD_IN_EVENT_SIZE)
+#define XENKBD_IN_RING_OFFS 1024
+#define XENKBD_IN_RING(page) \
+	((union xenkbd_in_event *)((char *)(page) + XENKBD_IN_RING_OFFS))
+#define XENKBD_IN_RING_REF(page, idx) \
+	(XENKBD_IN_RING((page))[(idx) % XENKBD_IN_RING_LEN])
+
+#define XENKBD_OUT_RING_SIZE 1024
+#define XENKBD_OUT_RING_LEN (XENKBD_OUT_RING_SIZE / XENKBD_OUT_EVENT_SIZE)
+#define XENKBD_OUT_RING_OFFS (XENKBD_IN_RING_OFFS + XENKBD_IN_RING_SIZE)
+#define XENKBD_OUT_RING(page) \
+	((union xenkbd_out_event *)((char *)(page) + XENKBD_OUT_RING_OFFS))
+#define XENKBD_OUT_RING_REF(page, idx) \
+	(XENKBD_OUT_RING((page))[(idx) % XENKBD_OUT_RING_LEN])
+
+struct xenkbd_page {
+	uint32_t in_cons, in_prod;
+	uint32_t out_cons, out_prod;
+};
+
+#endif
