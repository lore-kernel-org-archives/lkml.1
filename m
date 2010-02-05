Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247Ab0BEMYE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 07:24:04 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:54411 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754927Ab0BEMYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 07:24:00 -0500
Date: Fri, 5 Feb 2010 13:24:12 +0100
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
       linux-usb@vger.kernel.org, vamos@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH] obsolete config in kernel source (USB_GADGET_*)
Message-ID: <20100205122412.GA6540@faui49.informatik.uni-erlangen.de>
References: <20100115134833.GD3321@faui49.informatik.uni-erlangen.de>
 <Pine.LNX.4.44L0.1001150945230.5010-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1001150945230.5010-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 15, 2010 at 09:46:00AM -0500, Alan Stern wrote:
> On Fri, 15 Jan 2010, Christoph Egger wrote:
> > 	The linux tree contains USB-Id assignment snippets for some
> > USB Gadget drivers, which, as far as I can tell, never worked on
> > mainline linux2.6 but either originate from seemingly long-dead
> > third-party trees or were never ported from linux2.4.
> > 
> > 	As there has also seemingly never existed a way to select
> > these configs in the KConfig system it might be time to get rid of
> > them which would be done by the attached patch.
> 
> Have you tried building g_file_storage and the other gadget drivers 
> after applying your patch?

	You're right. I ony checked whether the first few were still
needed somewhere in code and assumed equal status for all of
them. SHould have at least build-tested all that stuff before sending
(and doing so now).

	Below is a updated patch that should be more correct and does
also build (tested against mainline git).

Regards

	Christoph

----
>From 3c741386902e521ab80fb4fdb2dce18433a922e7 Mon Sep 17 00:00:00 2001
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
Date: Fri, 5 Feb 2010 13:02:46 +0100
Subject: [PATCH] Remove unsupported usb gadget drivers

A bunch of USB gadget drivers where never ported from the linux 2.4
series to 2.6 kernels. However there's some code still in the tree for
them which isn't used and is probably untested for ages.

As the chance of these drivers being forward ported is probably quite
small now it might be time to get rid of them.

Signed-off-by: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
---
 drivers/usb/gadget/epautoconf.c     |   10 ------
 drivers/usb/gadget/f_acm.c          |    8 -----
 drivers/usb/gadget/f_ecm.c          |    7 +---
 drivers/usb/gadget/f_mass_storage.c |    8 +---
 drivers/usb/gadget/f_rndis.c        |    4 --
 drivers/usb/gadget/file_storage.c   |    8 +---
 drivers/usb/gadget/gadget_chips.h   |   59 -----------------------------------
 drivers/usb/gadget/gmidi.c          |    5 ---
 drivers/usb/gadget/printer.c        |   18 ----------
 drivers/usb/gadget/u_ether.h        |    7 ----
 drivers/usb/gadget/zero.c           |    6 +--
 11 files changed, 8 insertions(+), 132 deletions(-)

diff --git a/drivers/usb/gadget/epautoconf.c b/drivers/usb/gadget/epautoconf.c
index cd0914e..1d42b1c 100644
--- a/drivers/usb/gadget/epautoconf.c
+++ b/drivers/usb/gadget/epautoconf.c
@@ -265,16 +265,6 @@ struct usb_ep * __init usb_ep_autoconfig (
 				return ep;
 		}
 
-	} else if (gadget_is_sh (gadget) && USB_ENDPOINT_XFER_INT == type) {
-		/* single buffering is enough; maybe 8 byte fifo is too */
-		ep = find_ep (gadget, "ep3in-bulk");
-		if (ep && ep_matches (gadget, ep, desc))
-			return ep;
-
-	} else if (gadget_is_mq11xx (gadget) && USB_ENDPOINT_XFER_INT == type) {
-		ep = find_ep (gadget, "ep1-bulk");
-		if (ep && ep_matches (gadget, ep, desc))
-			return ep;
 	}
 
 	/* Second, look at endpoints until an unclaimed one looks usable */
diff --git a/drivers/usb/gadget/f_acm.c b/drivers/usb/gadget/f_acm.c
index d10353d..e49c732 100644
--- a/drivers/usb/gadget/f_acm.c
+++ b/drivers/usb/gadget/f_acm.c
@@ -702,14 +702,6 @@ acm_unbind(struct usb_configuration *c, struct usb_function *f)
 /* Some controllers can't support CDC ACM ... */
 static inline bool can_support_cdc(struct usb_configuration *c)
 {
-	/* SH3 doesn't support multiple interfaces */
-	if (gadget_is_sh(c->cdev->gadget))
-		return false;
-
-	/* sa1100 doesn't have a third interrupt endpoint */
-	if (gadget_is_sa1100(c->cdev->gadget))
-		return false;
-
 	/* everything else is *probably* fine ... */
 	return true;
 }
diff --git a/drivers/usb/gadget/f_ecm.c b/drivers/usb/gadget/f_ecm.c
index ecf5bdd..2fff530 100644
--- a/drivers/usb/gadget/f_ecm.c
+++ b/drivers/usb/gadget/f_ecm.c
@@ -497,12 +497,9 @@ static int ecm_set_alt(struct usb_function *f, unsigned intf, unsigned alt)
 			struct net_device	*net;
 
 			/* Enable zlps by default for ECM conformance;
-			 * override for musb_hdrc (avoids txdma ovhead)
-			 * and sa1100 (can't).
+			 * override for musb_hdrc (avoids txdma ovhead).
 			 */
-			ecm->port.is_zlp_ok = !(
-				   gadget_is_sa1100(cdev->gadget)
-				|| gadget_is_musbhdrc(cdev->gadget)
+			ecm->port.is_zlp_ok = !(gadget_is_musbhdrc(cdev->gadget)
 				);
 			ecm->port.cdc_filter = DEFAULT_FILTER;
 			DBG(cdev, "activate ecm\n");
diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index a37640e..ae4b048 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -2763,10 +2763,7 @@ static struct fsg_common *fsg_common_init(struct fsg_common *common,
 	if (cfg->release != 0xffff) {
 		i = cfg->release;
 	} else {
-		/* The sa1100 controller is not supported */
-		i = gadget_is_sa1100(gadget)
-			? -1
-			: usb_gadget_controller_number(gadget);
+		i = usb_gadget_controller_number(gadget);
 		if (i >= 0) {
 			i = 0x0300 + i;
 		} else {
@@ -2791,8 +2788,7 @@ static struct fsg_common *fsg_common_init(struct fsg_common *common,
 	 * disable stalls.
 	 */
 	common->can_stall = cfg->can_stall &&
-		!(gadget_is_sh(common->gadget) ||
-		  gadget_is_at91(common->gadget));
+		!(gadget_is_at91(common->gadget));
 
 
 	spin_lock_init(&common->lock);
diff --git a/drivers/usb/gadget/f_rndis.c b/drivers/usb/gadget/f_rndis.c
index 95dae4c..a30e60c 100644
--- a/drivers/usb/gadget/f_rndis.c
+++ b/drivers/usb/gadget/f_rndis.c
@@ -769,10 +769,6 @@ rndis_unbind(struct usb_configuration *c, struct usb_function *f)
 /* Some controllers can't support RNDIS ... */
 static inline bool can_support_rndis(struct usb_configuration *c)
 {
-	/* only two endpoints on sa1100 */
-	if (gadget_is_sa1100(c->cdev->gadget))
-		return false;
-
 	/* everything else is *presumably* fine */
 	return true;
 }
diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
index 29dfb02..a90dd2d 100644
--- a/drivers/usb/gadget/file_storage.c
+++ b/drivers/usb/gadget/file_storage.c
@@ -3208,15 +3208,11 @@ static int __init check_parameters(struct fsg_dev *fsg)
 	 * halt bulk endpoints correctly.  If one of them is present,
 	 * disable stalls.
 	 */
-	if (gadget_is_sh(fsg->gadget) || gadget_is_at91(fsg->gadget))
+	if (gadget_is_at91(fsg->gadget))
 		mod_data.can_stall = 0;
 
 	if (mod_data.release == 0xffff) {	// Parameter wasn't set
-		/* The sa1100 controller is not supported */
-		if (gadget_is_sa1100(fsg->gadget))
-			gcnum = -1;
-		else
-			gcnum = usb_gadget_controller_number(fsg->gadget);
+		gcnum = usb_gadget_controller_number(fsg->gadget);
 		if (gcnum >= 0)
 			mod_data.release = 0x0300 + gcnum;
 		else {
diff --git a/drivers/usb/gadget/gadget_chips.h b/drivers/usb/gadget/gadget_chips.h
index f2d270b..1edbc12 100644
--- a/drivers/usb/gadget/gadget_chips.h
+++ b/drivers/usb/gadget/gadget_chips.h
@@ -45,46 +45,18 @@
 #define	gadget_is_goku(g)	0
 #endif
 
-/* SH3 UDC -- not yet ported 2.4 --> 2.6 */
-#ifdef CONFIG_USB_GADGET_SUPERH
-#define	gadget_is_sh(g)		!strcmp("sh_udc", (g)->name)
-#else
-#define	gadget_is_sh(g)		0
-#endif
-
-/* not yet stable on 2.6 (would help "original Zaurus") */
-#ifdef CONFIG_USB_GADGET_SA1100
-#define	gadget_is_sa1100(g)	!strcmp("sa1100_udc", (g)->name)
-#else
-#define	gadget_is_sa1100(g)	0
-#endif
-
 #ifdef CONFIG_USB_GADGET_LH7A40X
 #define	gadget_is_lh7a40x(g)	!strcmp("lh7a40x_udc", (g)->name)
 #else
 #define	gadget_is_lh7a40x(g)	0
 #endif
 
-/* handhelds.org tree (?) */
-#ifdef CONFIG_USB_GADGET_MQ11XX
-#define	gadget_is_mq11xx(g)	!strcmp("mq11xx_udc", (g)->name)
-#else
-#define	gadget_is_mq11xx(g)	0
-#endif
-
 #ifdef CONFIG_USB_GADGET_OMAP
 #define	gadget_is_omap(g)	!strcmp("omap_udc", (g)->name)
 #else
 #define	gadget_is_omap(g)	0
 #endif
 
-/* not yet ported 2.4 --> 2.6 */
-#ifdef CONFIG_USB_GADGET_N9604
-#define	gadget_is_n9604(g)	!strcmp("n9604_udc", (g)->name)
-#else
-#define	gadget_is_n9604(g)	0
-#endif
-
 /* various unstable versions available */
 #ifdef CONFIG_USB_GADGET_PXA27X
 #define	gadget_is_pxa27x(g)	!strcmp("pxa27x_udc", (g)->name)
@@ -122,14 +94,6 @@
 #define gadget_is_fsl_usb2(g)	0
 #endif
 
-/* Mentor high speed function controller */
-/* from Montavista kernel (?) */
-#ifdef CONFIG_USB_GADGET_MUSBHSFC
-#define gadget_is_musbhsfc(g)	!strcmp("musbhsfc_udc", (g)->name)
-#else
-#define gadget_is_musbhsfc(g)	0
-#endif
-
 /* Mentor high speed "dual role" controller, in peripheral role */
 #ifdef CONFIG_USB_GADGET_MUSB_HDRC
 #define gadget_is_musbhdrc(g)	!strcmp("musb_hdrc", (g)->name)
@@ -143,13 +107,6 @@
 #define gadget_is_langwell(g)	0
 #endif
 
-/* from Montavista kernel (?) */
-#ifdef CONFIG_USB_GADGET_MPC8272
-#define gadget_is_mpc8272(g)	!strcmp("mpc8272_udc", (g)->name)
-#else
-#define gadget_is_mpc8272(g)	0
-#endif
-
 #ifdef CONFIG_USB_GADGET_M66592
 #define	gadget_is_m66592(g)	!strcmp("m66592_udc", (g)->name)
 #else
@@ -203,20 +160,12 @@ static inline int usb_gadget_controller_number(struct usb_gadget *gadget)
 		return 0x02;
 	else if (gadget_is_pxa(gadget))
 		return 0x03;
-	else if (gadget_is_sh(gadget))
-		return 0x04;
-	else if (gadget_is_sa1100(gadget))
-		return 0x05;
 	else if (gadget_is_goku(gadget))
 		return 0x06;
-	else if (gadget_is_mq11xx(gadget))
-		return 0x07;
 	else if (gadget_is_omap(gadget))
 		return 0x08;
 	else if (gadget_is_lh7a40x(gadget))
 		return 0x09;
-	else if (gadget_is_n9604(gadget))
-		return 0x10;
 	else if (gadget_is_pxa27x(gadget))
 		return 0x11;
 	else if (gadget_is_s3c2410(gadget))
@@ -225,12 +174,8 @@ static inline int usb_gadget_controller_number(struct usb_gadget *gadget)
 		return 0x13;
 	else if (gadget_is_imx(gadget))
 		return 0x14;
-	else if (gadget_is_musbhsfc(gadget))
-		return 0x15;
 	else if (gadget_is_musbhdrc(gadget))
 		return 0x16;
-	else if (gadget_is_mpc8272(gadget))
-		return 0x17;
 	else if (gadget_is_atmel_usba(gadget))
 		return 0x18;
 	else if (gadget_is_fsl_usb2(gadget))
@@ -265,10 +210,6 @@ static inline bool gadget_supports_altsettings(struct usb_gadget *gadget)
 	if (gadget_is_pxa27x(gadget))
 		return false;
 
-	/* SH3 hardware just doesn't do altsettings */
-	if (gadget_is_sh(gadget))
-		return false;
-
 	/* Everything else is *presumably* fine ... */
 	return true;
 }
diff --git a/drivers/usb/gadget/gmidi.c b/drivers/usb/gadget/gmidi.c
index d0b1e83..a1e68d1 100644
--- a/drivers/usb/gadget/gmidi.c
+++ b/drivers/usb/gadget/gmidi.c
@@ -618,11 +618,6 @@ gmidi_set_config(struct gmidi_device *dev, unsigned number, gfp_t gfp_flags)
 	}
 #endif
 
-	if (gadget_is_sa1100(gadget) && dev->config) {
-		/* tx fifo is full, but we can't clear it...*/
-		ERROR(dev, "can't change configurations\n");
-		return -ESPIPE;
-	}
 	gmidi_reset_config(dev);
 
 	switch (number) {
diff --git a/drivers/usb/gadget/printer.c b/drivers/usb/gadget/printer.c
index 2d867fd..6b8bf8c 100644
--- a/drivers/usb/gadget/printer.c
+++ b/drivers/usb/gadget/printer.c
@@ -949,12 +949,6 @@ printer_set_config(struct printer_dev *dev, unsigned number)
 	int			result = 0;
 	struct usb_gadget	*gadget = dev->gadget;
 
-	if (gadget_is_sa1100(gadget) && dev->config) {
-		/* tx fifo is full, but we can't clear it...*/
-		INFO(dev, "can't change configurations\n");
-		return -ESPIPE;
-	}
-
 	switch (number) {
 	case DEV_CONFIG_VALUE:
 		result = 0;
@@ -1033,12 +1027,6 @@ set_interface(struct printer_dev *dev, unsigned number)
 {
 	int			result = 0;
 
-	if (gadget_is_sa1100(dev->gadget) && dev->interface < 0) {
-		/* tx fifo is full, but we can't clear it...*/
-		INFO(dev, "can't change interfaces\n");
-		return -ESPIPE;
-	}
-
 	/* Free the current interface */
 	switch (dev->interface) {
 	case PRINTER_INTERFACE:
@@ -1392,12 +1380,6 @@ printer_bind(struct usb_gadget *gadget)
 		goto fail;
 	}
 
-	if (gadget_is_sa1100(gadget)) {
-		/* hardware can't write zero length packets. */
-		ERROR(dev, "SA1100 controller is unsupport by this driver\n");
-		goto fail;
-	}
-
 	gcnum = usb_gadget_controller_number(gadget);
 	if (gcnum >= 0) {
 		device_desc.bcdDevice = cpu_to_le16(0x0200 + gcnum);
diff --git a/drivers/usb/gadget/u_ether.h b/drivers/usb/gadget/u_ether.h
index fd55f45..3c8c0c9 100644
--- a/drivers/usb/gadget/u_ether.h
+++ b/drivers/usb/gadget/u_ether.h
@@ -93,13 +93,6 @@ static inline bool can_support_ecm(struct usb_gadget *gadget)
 	if (!gadget_supports_altsettings(gadget))
 		return false;
 
-	/* SA1100 can do ECM, *without* status endpoint ... but we'll
-	 * only use it in non-ECM mode for backwards compatibility
-	 * (and since we currently require a status endpoint)
-	 */
-	if (gadget_is_sa1100(gadget))
-		return false;
-
 	/* Everything else is *presumably* fine ... but this is a bit
 	 * chancy, so be **CERTAIN** there are no hardware issues with
 	 * your controller.  Add it above if it can't handle CDC.
diff --git a/drivers/usb/gadget/zero.c b/drivers/usb/gadget/zero.c
index 2d77240..fac81ee 100644
--- a/drivers/usb/gadget/zero.c
+++ b/drivers/usb/gadget/zero.c
@@ -297,12 +297,10 @@ static int __init zero_bind(struct usb_composite_dev *cdev)
 	 */
 	if (loopdefault) {
 		loopback_add(cdev, autoresume != 0);
-		if (!gadget_is_sh(gadget))
-			sourcesink_add(cdev, autoresume != 0);
+		sourcesink_add(cdev, autoresume != 0);
 	} else {
 		sourcesink_add(cdev, autoresume != 0);
-		if (!gadget_is_sh(gadget))
-			loopback_add(cdev, autoresume != 0);
+		loopback_add(cdev, autoresume != 0);
 	}
 
 	gcnum = usb_gadget_controller_number(gadget);
-- 
1.6.3.3


