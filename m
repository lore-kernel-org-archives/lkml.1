Return-Path: <linux-kernel-owner+w=401wt.eu-S1764728AbZEHV2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764728AbZEHV2t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 17:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760744AbZEHVXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 17:23:54 -0400
Received: from mail.windriver.com ([147.11.1.11]:44774 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760682AbZEHVXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 17:23:39 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, kdb@oss.sgi.com,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 13/13] RFC ONLY - usb,keyboard: uchi, echi, and ochi polling keyboard urbs
Date: Fri,  8 May 2009 16:23:20 -0500
Message-Id: <1241817800-9320-14-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
In-Reply-To: <1241817800-9320-13-git-send-email-jason.wessel@windriver.com>
References: <1241817800-9320-1-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-2-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-3-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-4-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-5-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-6-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-7-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-8-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-9-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-10-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-11-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-12-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-13-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 08 May 2009 21:23:34.0044 (UTC) FILETIME=[3E1005C0:01C9D023]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a RFC patch.  The work to possibly merge kdb and kgdb is being
evaluated and this patch is considered only a proof of concept or
prototype.

This is a direct port of the kdb usb polling code, with some clean up
for checkpatch.pl.  I would rate this particular patch in the "highly
experimental/controversial" classification.

Based on the ehci and ochi implementations from the kdb 4.4, I added a
uhci implementation, because that was the only usb keyboard type I had
at the time.  The uhci polling code "appears to work", but has
problems in that it does not seem to remove the urbs completely from
the queue on resume from debugging mode.  I am not actually certain if
the ehci and ochi drivers have the same problem because I was not able
to test them.

As I understand it from reading the original ehci and uhci polling
implementation, the concept is to poll the queue for a particular urb
and process only that urb from the driver queue.  At the same time,
the poll code attempts to leave everything else alone.  Assuming that
is the intent behind this code, that means only the usb keyboard(s)
stay alive while kdb is active.

Perhaps we can get further comments from the original authors at some
point down the road. :-)

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/char/kdb_keyboard.c   |  199 ++++++++++++++++++++++++++++++++++++
 drivers/hid/usbhid/hid-core.c |   26 +++++
 drivers/hid/usbhid/usbkbd.c   |   13 +++
 drivers/serial/kgdboc.c       |   12 ++
 drivers/usb/core/hcd.c        |   14 +++
 drivers/usb/core/hcd.h        |    4 +
 drivers/usb/host/ehci-hcd.c   |   42 ++++++++
 drivers/usb/host/ehci-pci.c   |    6 +
 drivers/usb/host/ehci-q.c     |  225 +++++++++++++++++++++++++++++++++++++++++
 drivers/usb/host/ohci-hcd.c   |   66 ++++++++++++
 drivers/usb/host/ohci-pci.c   |    6 +-
 drivers/usb/host/ohci-q.c     |   63 ++++++++++++
 drivers/usb/host/uhci-hcd.c   |   36 +++++++
 drivers/usb/host/uhci-q.c     |   51 +++++++++
 include/linux/kdb.h           |    1 +
 include/linux/kdbprivate.h    |    1 +
 lib/Kconfig.kgdb              |    7 ++
 17 files changed, 771 insertions(+), 1 deletions(-)

diff --git a/drivers/char/kdb_keyboard.c b/drivers/char/kdb_keyboard.c
index 6dcbb07..6cc4636 100644
--- a/drivers/char/kdb_keyboard.c
+++ b/drivers/char/kdb_keyboard.c
@@ -11,6 +11,7 @@
 
 #ifdef	CONFIG_VT_CONSOLE
 #include <linux/kdb.h>
+#include <linux/kdbprivate.h>
 #include <linux/keyboard.h>
 #include <linux/ctype.h>
 #include <linux/module.h>
@@ -20,6 +21,204 @@
 
 static int kbd_exists;
 
+#ifdef	CONFIG_KDB_USB
+
+/* support up to 8 USB keyboards (probably excessive, but...) */
+#define KDB_USB_NUM_KEYBOARDS   8
+struct kdb_usb_kbd_info kdb_usb_kbds[KDB_USB_NUM_KEYBOARDS];
+
+static unsigned char kdb_usb_keycode[256] = {
+	   0,   0,   0,   0,  30,  48,  46,  32,  18,  33,  34,  35,  23,
+	  36,  37,  38,	 50,  49,  24,  25,  16,  19,  31,  20,  22,  47,
+	  17,  45,  21,  44,   2,   3,   4,   5,   6,   7,   8,   9,  10,
+	  11,  28,   1,  14,  15,  57,  12,  13,  26,  27,  43,  84,  39,
+	  40,  41,  51,  52,  53,  58,  59,  60,  61,  62,  63,  64,  65,
+	  66,  67,  68,  87,  88,  99,  70, 119, 110, 102, 104, 111, 107,
+	 109, 106, 105, 108, 103,  69,  98,  55,  74,  78,  96,  79,  80,
+	  81,  75,  76,  77,  71,  72,  73,  82,  83,  86, 127, 116, 117,
+	  85,  89,  90,  91,  92,  93,  94,  95, 120, 121, 122, 123, 134,
+	 138, 130, 132, 128, 129, 131, 137, 133, 135, 136, 113,	115, 114,
+	   0,   0,   0, 124,   0, 181, 182, 183, 184, 185, 186, 187, 188,
+	 189, 190, 191, 192, 193, 194, 195, 196, 197, 198,   0,   0,   0,
+	   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
+	   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
+	   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
+	   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
+	   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
+	   0,   0,   0,  29,  42,  56, 125,  97,  54, 100, 126, 164, 166,
+	 165, 163, 161, 115, 114, 113, 150, 158, 159, 128, 136, 177, 178,
+	 176, 142, 152, 173, 140
+};
+
+/*
+ * kdb_usb_keyboard_attach()
+ * Attach a USB keyboard to kdb.
+ */
+int
+kdb_usb_keyboard_attach(struct urb *urb, unsigned char *buffer, void *poll_func)
+{
+	int     i;
+	int     rc = -1;
+
+	if (kdb_no_usb)
+		return 0;
+
+	/*
+	 * Search through the array of KDB USB keyboards (kdb_usb_kbds)
+	 * looking for a free index. If found, assign the keyboard to
+	 * the array index.
+	 */
+
+	for (i = 0; i < KDB_USB_NUM_KEYBOARDS; i++) {
+		if (kdb_usb_kbds[i].urb) /* index is already assigned */
+			continue;
+
+		/* found a free array index */
+		kdb_usb_kbds[i].urb = urb;
+		kdb_usb_kbds[i].buffer = buffer;
+		kdb_usb_kbds[i].poll_func = poll_func;
+
+		rc = 0; /* success */
+
+		break;
+	}
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(kdb_usb_keyboard_attach);
+
+/*
+ * kdb_usb_keyboard_detach()
+ * Detach a USB keyboard from kdb.
+ */
+int
+kdb_usb_keyboard_detach(struct urb *urb)
+{
+	int     i;
+	int     rc = -1;
+
+	if (kdb_no_usb)
+		return 0;
+
+	/*
+	 * Search through the array of KDB USB keyboards (kdb_usb_kbds)
+	 * looking for the index with the matching URB. If found,
+	 * clear the array index.
+	 */
+
+	for (i = 0; i < KDB_USB_NUM_KEYBOARDS; i++) {
+		if (kdb_usb_kbds[i].urb != urb)
+			continue;
+
+		/* found it, clear the index */
+		kdb_usb_kbds[i].urb = NULL;
+		kdb_usb_kbds[i].buffer = NULL;
+		kdb_usb_kbds[i].poll_func = NULL;
+		kdb_usb_kbds[i].caps_lock = 0;
+
+		rc = 0; /* success */
+
+		break;
+	}
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(kdb_usb_keyboard_detach);
+
+/*
+ * get_usb_char
+ * This function drives the USB attached keyboards.
+ * Fetch the USB scancode and decode it.
+ */
+int
+kdb_get_usb_char(void)
+{
+	int     i;
+	int     ret;
+	unsigned char keycode, spec;
+
+	if (kdb_no_usb)
+		return -1;
+
+	/*
+	 * Loop through all the USB keyboard(s) and return
+	 * the first character obtained from them.
+	 */
+
+	for (i = 0; i < KDB_USB_NUM_KEYBOARDS; i++) {
+		/* skip uninitialized keyboard array entries */
+		if (!kdb_usb_kbds[i].urb || !kdb_usb_kbds[i].buffer ||
+		    !kdb_usb_kbds[i].poll_func)
+			continue;
+
+		/* Transfer char */
+		ret = (*kdb_usb_kbds[i].poll_func)(kdb_usb_kbds[i].urb);
+		if (ret == -EBUSY && kdb_usb_kbds[i].poll_ret != -EBUSY)
+			kdb_printf("NOTICE: USB HD driver BUSY. "
+				   "USB keyboard has been disabled.\n");
+
+		kdb_usb_kbds[i].poll_ret = ret;
+
+		if (ret < 0) /* error or no characters, try the next kbd */
+			continue;
+
+		spec = kdb_usb_kbds[i].buffer[0];
+		keycode = kdb_usb_kbds[i].buffer[2];
+		kdb_usb_kbds[i].buffer[0] = (char)0;
+		kdb_usb_kbds[i].buffer[2] = (char)0;
+
+		if (kdb_usb_kbds[i].buffer[3]) {
+			kdb_usb_kbds[i].buffer[3] = (char)0;
+			continue;
+		}
+
+		/* A normal key is pressed, decode it */
+		if (keycode)
+			keycode = kdb_usb_keycode[keycode];
+
+		/* 2 Keys pressed at one time ? */
+		if (spec && keycode) {
+			switch (spec) {
+			case 0x2:
+			case 0x20: /* Shift */
+				return shift_map[keycode];
+			case 0x1:
+			case 0x10: /* Ctrl */
+				return ctrl_map[keycode];
+			case 0x4:
+			case 0x40: /* Alt */
+				break;
+			}
+		} else if (keycode) { /* If only one key pressed */
+			switch (keycode) {
+			case 0x1C: /* Enter */
+				return 13;
+
+			case 0x3A: /* Capslock */
+				kdb_usb_kbds[i].caps_lock =
+					!(kdb_usb_kbds[i].caps_lock);
+				break;
+			case 0x0E: /* Backspace */
+				return 8;
+			case 0x0F: /* TAB */
+				return 9;
+			case 0x77: /* Pause */
+				break;
+			default:
+				if (!kdb_usb_kbds[i].caps_lock)
+					return plain_map[keycode];
+				else
+					return shift_map[keycode];
+			}
+		}
+	}
+
+	/* no chars were returned from any of the USB keyboards */
+
+	return -1;
+}
+#endif	/* CONFIG_KDB_USB */
+
 /*
  * Check if the keyboard controller has a keypress for us.
  * Some parts (Enter Release, LED change) are still blocking polled here,
diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 900ce18..d82dfc8 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -36,6 +36,7 @@
 #include <linux/hiddev.h>
 #include <linux/hid-debug.h>
 #include <linux/hidraw.h>
+#include <linux/kdb.h>
 #include "usbhid.h"
 
 /*
@@ -47,6 +48,7 @@
 #define DRIVER_DESC "USB HID core driver"
 #define DRIVER_LICENSE "GPL"
 
+
 /*
  * Module parameters.
  */
@@ -1037,6 +1039,14 @@ static void usbhid_stop(struct hid_device *hid)
 
 	if (WARN_ON(!usbhid))
 		return;
+#ifdef CONFIG_KDB_USB
+	/*
+	 * If the URB was for a Keyboard, detach it from kdb.
+	 * If the URB was for another type of device, just
+	 * allow kdb_usb_keyboard_detach() to silently fail.
+	 */
+	kdb_usb_keyboard_detach(usbhid->urbin);
+#endif
 
 	clear_bit(HID_STARTED, &usbhid->iofl);
 	spin_lock_irq(&usbhid->lock);	/* Sync with error handler */
@@ -1176,6 +1186,22 @@ static int hid_probe(struct usb_interface *intf, const struct usb_device_id *id)
 		goto err_free;
 	}
 
+#ifdef CONFIG_KDB_USB
+	/* Attach USB keyboards to kdb */
+	if (intf->cur_altsetting->desc.bInterfaceProtocol ==
+	    USB_INTERFACE_PROTOCOL_KEYBOARD) {
+		int ret;
+		struct usbhid_device *usbhid = hid->driver_data;
+
+		ret = kdb_usb_keyboard_attach(usbhid->urbin, usbhid->inbuf,
+		    usb_hcd_get_kdb_poll_func(interface_to_usbdev(intf)));
+
+		if (ret == -1)
+			printk(KERN_ERR ": FAILED to register keyboard (%s) "
+				"with KDB\n", hid->phys);
+	}
+#endif /* CONFIG_KDB_USB */
+
 	return 0;
 err_free:
 	kfree(usbhid);
diff --git a/drivers/hid/usbhid/usbkbd.c b/drivers/hid/usbhid/usbkbd.c
index b342926..7ecbf6f 100644
--- a/drivers/hid/usbhid/usbkbd.c
+++ b/drivers/hid/usbhid/usbkbd.c
@@ -30,6 +30,7 @@
 #include <linux/init.h>
 #include <linux/usb/input.h>
 #include <linux/hid.h>
+#include <linux/kdb.h>
 
 /*
  * Version Information
@@ -292,6 +293,14 @@ static int usb_kbd_probe(struct usb_interface *iface,
 	usb_fill_int_urb(kbd->irq, dev, pipe,
 			 kbd->new, (maxp > 8 ? 8 : maxp),
 			 usb_kbd_irq, kbd, endpoint->bInterval);
+
+#ifdef CONFIG_KDB_USB
+	/* Attach keyboard to kdb */
+	kdb_usb_keyboard_attach(kbd->irq, kbd->new,
+				usb_hcd_get_kdb_poll_func(dev));
+
+#endif /* CONFIG_KDB_USB */
+
 	kbd->irq->transfer_dma = kbd->new_dma;
 	kbd->irq->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 
@@ -329,6 +338,10 @@ static void usb_kbd_disconnect(struct usb_interface *intf)
 
 	usb_set_intfdata(intf, NULL);
 	if (kbd) {
+#ifdef CONFIG_KDB_USB
+		/* Detach the keyboard from kdb */
+		kdb_usb_keyboard_detach(kbd->irq);
+#endif /* CONFIG_KDB_USB */
 		usb_kill_urb(kbd->irq);
 		input_unregister_device(kbd->dev);
 		usb_kbd_free_mem(interface_to_usbdev(intf), kbd);
diff --git a/drivers/serial/kgdboc.c b/drivers/serial/kgdboc.c
index cac8ae7..593a67a 100644
--- a/drivers/serial/kgdboc.c
+++ b/drivers/serial/kgdboc.c
@@ -54,7 +54,12 @@ static void cleanup_kgdboc(void)
 
 	/* Unregister the keyboard poll hook, if registered */
 	for (i = 0; i < kdb_poll_idx; i++) {
+#ifdef CONFIG_KDB_USB
+		if (kdb_poll_funcs[i] == kdb_get_kbd_char ||
+			kdb_poll_funcs[i] == kdb_get_usb_char) {
+#else /* ! CONFIG_KDB_USB */
 		if (kdb_poll_funcs[i] == kdb_get_kbd_char) {
+#endif /* CONFIG_KDB_USB */
 			kdb_poll_idx--;
 			kdb_poll_funcs[i] = kdb_poll_funcs[kdb_poll_idx];
 			kdb_poll_funcs[kdb_poll_idx] = NULL;
@@ -87,11 +92,18 @@ static int configure_kgdboc(void)
 		if (kdb_poll_idx < KDB_POLL_FUNC_MAX) {
 			kdb_poll_funcs[kdb_poll_idx] = kdb_get_kbd_char;
 			kdb_poll_idx++;
+#ifdef CONFIG_KDB_USB
+			if (kdb_poll_idx < KDB_POLL_FUNC_MAX) {
+				kdb_poll_funcs[kdb_poll_idx] = kdb_get_usb_char;
+				kdb_poll_idx++;
+			}
+#endif /* CONFIG_KDB_USB */
 			if (cptr[3] == ',')
 				cptr += 4;
 			else
 				goto do_register;
 		}
+		/* XXX must fix error handling XXX */
 	}
 #endif /* CONFIG_KDB_KEYBOARD */
 
diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 42b93da..6f1935e 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -2045,6 +2045,20 @@ usb_hcd_platform_shutdown(struct platform_device* dev)
 }
 EXPORT_SYMBOL_GPL(usb_hcd_platform_shutdown);
 
+#ifdef CONFIG_KDB_USB
+void *
+usb_hcd_get_kdb_poll_func(struct usb_device *udev)
+{
+	struct usb_hcd	*hcd = bus_to_hcd(udev->bus);
+
+	if (hcd && hcd->driver)
+		return (void *)(hcd->driver->kdb_poll_char);
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(usb_hcd_get_kdb_poll_func);
+#endif /* CONFIG_KDB_USB */
+
 /*-------------------------------------------------------------------------*/
 
 #if defined(CONFIG_USB_MON) || defined(CONFIG_USB_MON_MODULE)
diff --git a/drivers/usb/core/hcd.h b/drivers/usb/core/hcd.h
index e7d4479..a99689d 100644
--- a/drivers/usb/core/hcd.h
+++ b/drivers/usb/core/hcd.h
@@ -224,6 +224,10 @@ struct hc_driver {
 	void	(*relinquish_port)(struct usb_hcd *, int);
 		/* has a port been handed over to a companion? */
 	int	(*port_handed_over)(struct usb_hcd *, int);
+#ifdef CONFIG_KDB_USB
+	/* KDB poll function for this HC */
+	int	(*kdb_poll_char)(struct urb *urb);
+#endif /* CONFIG_KDB_USB */
 };
 
 extern int usb_hcd_link_urb_to_ep(struct usb_hcd *hcd, struct urb *urb);
diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index c637207..fd81238 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -1031,6 +1031,48 @@ static int ehci_get_frame (struct usb_hcd *hcd)
 		ehci->periodic_size;
 }
 
+#ifdef CONFIG_KDB_USB
+
+int
+ehci_kdb_poll_char(struct urb *urb)
+{
+	struct ehci_hcd *ehci;
+
+	/* just to make sure */
+	if (!urb || !urb->dev || !urb->dev->bus)
+		return -1;
+
+	ehci = (struct ehci_hcd *) hcd_to_ehci(bus_to_hcd(urb->dev->bus));
+
+	/* make sure */
+	if (!ehci)
+		return -1;
+
+	if (!HC_IS_RUNNING(ehci_to_hcd(ehci)->state))
+		return -1;
+
+	/*
+	 * If ehci->lock is held coming into this routine, it could
+	 * mean KDB was entered while the HC driver was in the midst
+	 * of processing URBs. Therefore it could be dangerous to
+	 * processes URBs from this poll routine. And, we can't wait on
+	 * the lock since we are in KDB and kernel threads (including the
+	 * one holding the lock) are suspended.
+	 * So, we punt and return an error. Keyboards attached to this
+	 * HC will not be useable from KDB at this time.
+	 */
+	if (spin_is_locked(&ehci->lock))
+		return -EBUSY;
+
+	/* processes the URB */
+	if (qh_completions_kdb(ehci, urb->hcpriv, urb))
+		return 0;
+
+	return -1;
+}
+
+#endif /* CONFIG_KDB_USB */
+
 /*-------------------------------------------------------------------------*/
 
 MODULE_DESCRIPTION(DRIVER_DESC);
diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
index 5aa8bce..65779fb 100644
--- a/drivers/usb/host/ehci-pci.c
+++ b/drivers/usb/host/ehci-pci.c
@@ -22,6 +22,8 @@
 #error "This file is PCI bus glue.  CONFIG_PCI must be defined."
 #endif
 
+#include <linux/kdb.h>
+
 /*-------------------------------------------------------------------------*/
 
 /* called after powerup, by probe or system-pm "wakeup" */
@@ -408,6 +410,10 @@ static const struct hc_driver ehci_pci_hc_driver = {
 	.bus_resume =		ehci_bus_resume,
 	.relinquish_port =	ehci_relinquish_port,
 	.port_handed_over =	ehci_port_handed_over,
+
+#ifdef CONFIG_KDB_USB
+	.kdb_poll_char = 	ehci_kdb_poll_char,
+#endif
 };
 
 /*-------------------------------------------------------------------------*/
diff --git a/drivers/usb/host/ehci-q.c b/drivers/usb/host/ehci-q.c
index 1976b1b..3c3d920 100644
--- a/drivers/usb/host/ehci-q.c
+++ b/drivers/usb/host/ehci-q.c
@@ -499,6 +499,231 @@ halt:
 	return count;
 }
 
+#ifdef CONFIG_KDB_USB
+/*
+ * This routine is basically a copy of qh_completions() for use by KDB.
+ * It is modified to only work on qtds which are associated
+ * with 'kdburb'. Also, there are some fixups related to locking.
+ */
+unsigned
+qh_completions_kdb(struct ehci_hcd *ehci, struct ehci_qh *qh,
+		   struct urb *kdburb)
+{
+	struct ehci_qtd		*last = NULL, *end = qh->dummy;
+	struct list_head	*entry, *tmp;
+	int			last_status = -EINPROGRESS;
+	int			stopped;
+	unsigned		count = 0;
+	int			do_status = 0;
+	u8			state;
+	u32			halt = HALT_BIT(ehci);
+
+	/* verify params are valid */
+	if (!qh || !kdburb)
+		return 0;
+
+	if (unlikely(list_empty(&qh->qtd_list)))
+		return count;
+
+	/* completions (or tasks on other cpus) must never clobber HALT
+	 * till we've gone through and cleaned everything up, even when
+	 * they add urbs to this qh's queue or mark them for unlinking.
+	 *
+	 * NOTE:  unlinking expects to be done in queue order.
+	 */
+	state = qh->qh_state;
+	qh->qh_state = QH_STATE_COMPLETING;
+	stopped = (state == QH_STATE_IDLE);
+
+	/* remove de-activated QTDs from front of queue.
+	 * after faults (including short reads), cleanup this urb
+	 * then let the queue advance.
+	 * if queue is stopped, handles unlinks.
+	 */
+	list_for_each_safe(entry, tmp, &qh->qtd_list) {
+		struct ehci_qtd	*qtd;
+		struct urb	*urb;
+		u32		token = 0;
+		int		qtd_status;
+
+		qtd = list_entry(entry, struct ehci_qtd, qtd_list);
+		urb = qtd->urb;
+
+		if (urb != kdburb)
+			continue;
+
+		/* clean up any state from previous QTD ...*/
+		if (last) {
+			if (likely(last->urb != urb)) {
+				/*
+				 * Lock hackery here...
+				 * ehci_urb_done() makes the assumption
+				 * that it's called with ehci->lock held.
+				 * So, lock it if it isn't already.
+				 */
+				if (!spin_is_locked(&ehci->lock))
+					spin_lock(&ehci->lock);
+
+				ehci_urb_done(ehci, last->urb, last_status);
+
+				/*
+				 * ehci_urb_done() releases and reacquires
+				 * ehci->lock, so release it here.
+				 */
+				if (spin_is_locked(&ehci->lock))
+					spin_unlock(&ehci->lock);
+
+				count++;
+			}
+			ehci_qtd_free(ehci, last);
+			last = NULL;
+			last_status = -EINPROGRESS;
+		}
+
+		/* ignore urbs submitted during completions we reported */
+		if (qtd == end)
+			break;
+
+		/* hardware copies qtd out of qh overlay */
+		rmb();
+		token = hc32_to_cpu(ehci, qtd->hw_token);
+
+		/* always clean up qtds the hc de-activated */
+		if ((token & QTD_STS_ACTIVE) == 0) {
+
+			if ((token & QTD_STS_HALT) != 0) {
+				stopped = 1;
+
+				/* magic dummy for some short reads;
+				 * qh won't advance.  that silicon
+				 * quirk can kick in with this dummy
+				 * too.
+				 */
+			} else if (IS_SHORT_READ(token)
+				   && !(qtd->hw_alt_next
+					& EHCI_LIST_END(ehci))) {
+				stopped = 1;
+				goto halt;
+			}
+
+			/* stop scanning when we reach qtds the hc is using */
+		} else if (likely(!stopped &&
+			  HC_IS_RUNNING(ehci_to_hcd(ehci)->state))) {
+			break;
+
+		} else {
+			stopped = 1;
+
+			if (unlikely(!HC_IS_RUNNING(ehci_to_hcd(ehci)->state)))
+				last_status = -ESHUTDOWN;
+
+			/* ignore active urbs unless some previous qtd
+			 * for the urb faulted (including short read) or
+			 * its urb was canceled.  we may patch qh or qtds.
+			 */
+			if (likely(last_status == -EINPROGRESS &&
+				   !urb->unlinked))
+				continue;
+
+			/* issue status after short control reads */
+			if (unlikely(do_status != 0)
+			    && QTD_PID(token) == 0 /* OUT */) {
+				do_status = 0;
+				continue;
+			}
+
+			/* token in overlay may be most current */
+			if (state == QH_STATE_IDLE
+			    && cpu_to_hc32(ehci, qtd->qtd_dma)
+			    == qh->hw_current)
+				token = hc32_to_cpu(ehci, qh->hw_token);
+
+			/* force halt for unlinked or blocked qh, so we'll
+			 * patch the qh later and so that completions can't
+			 * activate it while we "know" it's stopped.
+			 */
+			if ((halt & qh->hw_token) == 0) {
+halt:
+				qh->hw_token |= halt;
+				wmb();
+			}
+		}
+
+		/* remove it from the queue */
+		qtd_status = qtd_copy_status(ehci, urb, qtd->length, token);
+		if (unlikely(qtd_status == -EREMOTEIO)) {
+			do_status = (!urb->unlinked &&
+				     usb_pipecontrol(urb->pipe));
+			qtd_status = 0;
+		}
+		if (likely(last_status == -EINPROGRESS))
+			last_status = qtd_status;
+
+		if (stopped && qtd->qtd_list.prev != &qh->qtd_list) {
+			last = list_entry(qtd->qtd_list.prev,
+					   struct ehci_qtd, qtd_list);
+			last->hw_next = qtd->hw_next;
+		}
+		list_del(&qtd->qtd_list);
+		last = qtd;
+	}
+
+	/* last urb's completion might still need calling */
+	if (likely(last != NULL)) {
+		/*
+		 * Lock hackery here...
+		 * ehci_urb_done() makes the assumption
+		 * that it's called with ehci->lock held.
+		 * So, lock it if it isn't already.
+		 */
+		if (!spin_is_locked(&ehci->lock))
+			spin_lock(&ehci->lock);
+
+		ehci_urb_done(ehci, last->urb, last_status);
+
+		/*
+		 * ehci_urb_done() releases and reacquires
+		 * ehci->lock, so release it here.
+		 */
+		if (spin_is_locked(&ehci->lock))
+			spin_unlock(&ehci->lock);
+
+		count++;
+		ehci_qtd_free(ehci, last);
+	}
+
+	/* restore original state; caller must unlink or relink */
+	qh->qh_state = state;
+
+	/* be sure the hardware's done with the qh before refreshing
+	 * it after fault cleanup, or recovering from silicon wrongly
+	 * overlaying the dummy qtd (which reduces DMA chatter).
+	 */
+	if (stopped != 0 || qh->hw_qtd_next == EHCI_LIST_END(ehci)) {
+		switch (state) {
+		case QH_STATE_IDLE:
+			qh_refresh(ehci, qh);
+			break;
+		case QH_STATE_LINKED:
+			/* should be rare for periodic transfers,
+			 * except maybe high bandwidth ...
+			 */
+			if ((cpu_to_hc32(ehci, QH_SMASK)
+			     & qh->hw_info2) != 0) {
+				intr_deschedule(ehci, qh);
+				(void) qh_schedule(ehci, qh);
+			} else
+				unlink_async(ehci, qh);
+			break;
+			/* otherwise, unlink already started */
+		}
+	}
+
+	return count;
+}
+
+#endif /* CONFIG_KDB_USB */
+
 /*-------------------------------------------------------------------------*/
 
 // high bandwidth multiplier, as encoded in highspeed endpoint descriptors
diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
index 25db704..3732a31 100644
--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -983,6 +983,72 @@ static int ohci_restart (struct ohci_hcd *ohci)
 
 /*-------------------------------------------------------------------------*/
 
+#ifdef	CONFIG_KDB_USB
+
+int ohci_kdb_poll_char(struct urb *urb)
+{
+	struct ohci_hcd *ohci;
+	struct ohci_regs *regs;
+
+	/* just to make sure */
+	if (!urb || !urb->dev || !urb->dev->bus)
+		return -1;
+
+	ohci = (struct ohci_hcd *) hcd_to_ohci(bus_to_hcd(urb->dev->bus));
+
+	/* make sure */
+	if (!ohci || !ohci->hcca)
+		return -1;
+
+	if (!HC_IS_RUNNING(ohci_to_hcd(ohci)->state))
+		return -1;
+
+	/*
+	 * If ohci->lock is held coming into this routine, it could
+	 * mean KDB was entered while the HC driver was in the midst
+	 * of processing URBs. Therefore it could be dangerous to
+	 * processes URBs from this poll routine. And, we can't wait on
+	 * the lock since we are in KDB and kernel threads (including the
+	 * one holding the lock) are suspended.
+	 * So, we punt and return an error. Keyboards attached to this
+	 * HC will not be useable from KDB at this time.
+	 */
+	if (spin_is_locked(&ohci->lock))
+		return -EBUSY;
+
+	regs = ohci->regs;
+
+	/* if the urb is not currently in progress resubmit it */
+	if (urb->status != -EINPROGRESS) {
+
+		if (usb_submit_urb(urb, GFP_ATOMIC))
+			return -1;
+
+		/* make sure the HC registers are set correctly */
+		ohci_writel(ohci, OHCI_INTR_WDH, &regs->intrenable);
+		ohci_writel(ohci, OHCI_INTR_WDH, &regs->intrstatus);
+		ohci_writel(ohci, OHCI_INTR_MIE, &regs->intrenable);
+
+		/* flush those pci writes */
+		(void) ohci_readl(ohci, &ohci->regs->control);
+	}
+
+	if (ohci->hcca->done_head) {
+		dl_done_list_kdb(ohci, urb);
+		ohci_writel(ohci, OHCI_INTR_WDH, &regs->intrstatus);
+		/* flush the pci write */
+		(void) ohci_readl(ohci, &ohci->regs->control);
+
+		return 0;
+	}
+
+	return -1;
+}
+
+#endif /* CONFIG_KDB_USB */
+
+/*-------------------------------------------------------------------------*/
+
 MODULE_AUTHOR (DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE ("GPL");
diff --git a/drivers/usb/host/ohci-pci.c b/drivers/usb/host/ohci-pci.c
index f9961b4..8de9079 100644
--- a/drivers/usb/host/ohci-pci.c
+++ b/drivers/usb/host/ohci-pci.c
@@ -20,7 +20,7 @@
 
 #include <linux/pci.h>
 #include <linux/io.h>
-
+#include <linux/kdb.h>
 
 /* constants used to work around PM-related transfer
  * glitches in some AMD 700 series southbridges
@@ -367,6 +367,7 @@ static int __devinit ohci_pci_start (struct usb_hcd *hcd)
 		ohci_err (ohci, "can't start\n");
 		ohci_stop (hcd);
 	}
+
 	return ret;
 }
 
@@ -464,6 +465,9 @@ static const struct hc_driver ohci_pci_hc_driver = {
 	.bus_resume =		ohci_bus_resume,
 #endif
 	.start_port_reset =	ohci_start_port_reset,
+#ifdef CONFIG_KDB_USB
+	.kdb_poll_char =	ohci_kdb_poll_char,
+#endif
 };
 
 /*-------------------------------------------------------------------------*/
diff --git a/drivers/usb/host/ohci-q.c b/drivers/usb/host/ohci-q.c
index c2d80f8..06688e3 100644
--- a/drivers/usb/host/ohci-q.c
+++ b/drivers/usb/host/ohci-q.c
@@ -1127,3 +1127,66 @@ dl_done_list (struct ohci_hcd *ohci)
 		td = td_next;
 	}
 }
+
+
+/*-------------------------------------------------------------------------*/
+
+#ifdef	CONFIG_KDB_USB
+static void
+dl_done_list_kdb(struct ohci_hcd *ohci, struct urb *kdburb)
+{
+	struct td	*td = dl_reverse_done_list(ohci);
+
+	while (td) {
+		struct td	*td_next = td->next_dl_td;
+		struct urb	*urb = td->urb;
+		urb_priv_t	*urb_priv = urb->hcpriv;
+		struct ed	*ed = td->ed;
+
+		if (urb != kdburb) {
+			td = td_next;
+			continue;
+		}
+
+		/* update URB's length and status from TD */
+		td_done(ohci, urb, td);
+		urb_priv->td_cnt++;
+
+		/* If all this urb's TDs are done, just resubmit it */
+		if (urb_priv->td_cnt == urb_priv->length) {
+			urb->actual_length = 0;
+			urb->status = -EINPROGRESS;
+			td_submit_urb(ohci, urb);
+		}
+
+		/* clean schedule:  unlink EDs that are no longer busy */
+		if (list_empty(&ed->td_list)) {
+			if (ed->state == ED_OPER)
+				start_ed_unlink(ohci, ed);
+
+			/* ... reenabling halted EDs only after fault cleanup */
+		} else if ((ed->hwINFO & cpu_to_hc32(ohci,
+			     ED_SKIP | ED_DEQUEUE))
+			   == cpu_to_hc32(ohci, ED_SKIP)) {
+			td = list_entry(ed->td_list.next, struct td, td_list);
+			if (!(td->hwINFO & cpu_to_hc32(ohci, TD_DONE))) {
+				ed->hwINFO &= ~cpu_to_hc32(ohci, ED_SKIP);
+				/* ... hc may need waking-up */
+				switch (ed->type) {
+				case PIPE_CONTROL:
+					ohci_writel(ohci, OHCI_CLF,
+						    &ohci->regs->cmdstatus);
+					break;
+				case PIPE_BULK:
+					ohci_writel(ohci, OHCI_BLF,
+						    &ohci->regs->cmdstatus);
+					break;
+				}
+			}
+		}
+
+		td = td_next;
+	}
+}
+
+#endif /* CONFIG_KDB_USB */
diff --git a/drivers/usb/host/uhci-hcd.c b/drivers/usb/host/uhci-hcd.c
index cf5e4cf..8397f07 100644
--- a/drivers/usb/host/uhci-hcd.c
+++ b/drivers/usb/host/uhci-hcd.c
@@ -40,6 +40,7 @@
 #include <linux/usb.h>
 #include <linux/bitops.h>
 #include <linux/dmi.h>
+#include <linux/kdb.h>
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
@@ -891,6 +892,38 @@ static int uhci_hcd_get_frame_number(struct usb_hcd *hcd)
 	return frame_number + delta;
 }
 
+#ifdef CONFIG_KDB_USB
+int uhci_kdb_poll_char(struct urb *urb)
+{
+	struct uhci_hcd *uhci;
+	struct urb_priv *urbp;
+	struct uhci_qh *qh;
+
+	/* just to make sure */
+	if (!urb || !urb->dev || !urb->dev->bus || !urb->hcpriv)
+		return -1;
+
+	urbp = urb->hcpriv;
+	qh = urbp->qh;
+
+	uhci = (struct uhci_hcd *) hcd_to_uhci(bus_to_hcd(urb->dev->bus));
+
+	/* make sure */
+	if (!uhci)
+		return -1;
+
+	if (!HC_IS_RUNNING(uhci_to_hcd(uhci)->state))
+		return -1;
+
+	if (spin_is_locked(&uhci->lock))
+		return -EBUSY;
+
+	if (uhci_scan_qh_kdb(uhci, qh, urb))
+		return 0;
+	return -1;
+}
+#endif /* CONFIG_KDB_USB */
+
 static const char hcd_name[] = "uhci_hcd";
 
 static const struct hc_driver uhci_driver = {
@@ -921,6 +954,9 @@ static const struct hc_driver uhci_driver = {
 
 	.hub_status_data =	uhci_hub_status_data,
 	.hub_control =		uhci_hub_control,
+#ifdef CONFIG_KDB_USB
+	.kdb_poll_char =	uhci_kdb_poll_char,
+#endif
 };
 
 static const struct pci_device_id uhci_pci_ids[] = { {
diff --git a/drivers/usb/host/uhci-q.c b/drivers/usb/host/uhci-q.c
index 3e5807d..f0e6a4c 100644
--- a/drivers/usb/host/uhci-q.c
+++ b/drivers/usb/host/uhci-q.c
@@ -1760,3 +1760,54 @@ rescan:
 	else
 		uhci_set_next_interrupt(uhci);
 }
+
+#ifdef CONFIG_KDB_USB
+
+int uhci_scan_qh_kdb(struct uhci_hcd *uhci, struct uhci_qh *qh,
+					 struct urb *kdburb)
+{
+	struct urb_priv *urbp;
+	struct urb *urb;
+	int status;
+
+	if (!qh || !kdburb)
+		return 0;
+
+	while (!list_empty(&qh->queue)) {
+		urbp = list_entry(qh->queue.next, struct urb_priv, node);
+		urb = urbp->urb;
+
+		if (urb != kdburb)
+			continue;
+
+		if (qh->type == USB_ENDPOINT_XFER_ISOC)
+			status = uhci_result_isochronous(uhci, urb);
+		else
+			status = uhci_result_common(uhci, urb);
+		if (status == -EINPROGRESS)
+			break;
+
+		/* Dequeued but completed URBs can't be given back unless
+		 * the QH is stopped or has finished unlinking. */
+		if (urb->unlinked) {
+			if (QH_FINISHED_UNLINKING(qh))
+				qh->is_stopped = 1;
+			else if (!qh->is_stopped)
+				return 0;
+		}
+		urb->actual_length = 0;
+		urb->status = -EINPROGRESS;
+		/* Local lock hackery */
+		spin_lock(&uhci->lock);
+		uhci_giveback_urb(uhci, qh, urb, status);
+		spin_unlock(&uhci->lock);
+		if (status < 0)
+			break;
+	}
+
+	/* XXX probably need further clean up to get the urbs out of the
+	 * queuu XXX */
+	return 1;
+}
+
+#endif /* CONFIG_KDB_USB */
diff --git a/include/linux/kdb.h b/include/linux/kdb.h
index 200af81..9d89054 100644
--- a/include/linux/kdb.h
+++ b/include/linux/kdb.h
@@ -137,6 +137,7 @@ extern int kdb_no_usb;
 extern int kdb_usb_keyboard_attach(struct urb *urb,
 				   unsigned char *buffer, void *poll_func);
 extern int kdb_usb_keyboard_detach(struct urb *urb);
+extern void *usb_hcd_get_kdb_poll_func(struct usb_device *udev);
 
 #endif /* CONFIG_KDB_USB */
 
diff --git a/include/linux/kdbprivate.h b/include/linux/kdbprivate.h
index 8579e97..03f0004 100644
--- a/include/linux/kdbprivate.h
+++ b/include/linux/kdbprivate.h
@@ -333,6 +333,7 @@ typedef int (*get_char_func)(void);
 extern get_char_func kdb_poll_funcs[];
 extern int kdb_poll_idx;
 extern int kdb_get_kbd_char(void);
+extern int kdb_get_usb_char(void);
 
 #ifndef	CONFIG_IA64
 	/*
diff --git a/lib/Kconfig.kgdb b/lib/Kconfig.kgdb
index b5d3637..1c94a2b 100644
--- a/lib/Kconfig.kgdb
+++ b/lib/Kconfig.kgdb
@@ -87,4 +87,11 @@ config KDB_KEYBOARD
 	help
 	  KDB can use a PS/2 type keyboard for an input device
 
+config KDB_USB
+	bool "KGDB_KDB: Allow usb input device devices"
+	depends on VT && KGDB_KDB && KDB_KEYBOARD
+	default y
+	help
+	  KDB can use a USB keyboard for an input device
+
 endif # KGDB
-- 
1.6.3.rc0.1.gf800

