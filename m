Return-Path: <linux-kernel-owner+w=401wt.eu-S1757372AbXH0PYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372AbXH0PYp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 11:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755741AbXH0PYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 11:24:38 -0400
Received: from mail.atlantis.sk ([80.94.52.35]:48082 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754222AbXH0PYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 11:24:37 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Daniel Ritz <daniel.ritz-ml@swissonline.ch>
Subject: Re: [PATCH] IdealTEK URTC1000 support for usbtouchscreen
Date: Mon, 27 Aug 2007 17:25:10 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200708232355.28628.linux@rainbow-software.org> <200708251848.14866.daniel.ritz-ml@swissonline.ch>
In-Reply-To: <200708251848.14866.daniel.ritz-ml@swissonline.ch>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 7358
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200708271725.10593.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 25 August 2007 18:48:13 Daniel Ritz wrote:
> 	[ please don't send patches as attachment.. ]
>
> On Thursday 23 August 2007 23:55:28 Ondrej Zary wrote:
> > Hello,
> > this patch adds support for IdealTEK URTC1000 touchscreen controllers.
>
> looks good, just a few minor things...
>
> > Documentation can be downloaded at
> > http://projects.tbmn.org/cgi-bin/trac.cgi/wiki/urtc-1000
> >
> > I'm not sure that the code is correct, especially because the .rept_size
> > is set to 8 bytes. I've tried 5, 6, 7, 8, 12 and 16. Only 8 and 16 work.
> > Other values resulted in -EOVERFLOW in usbtouch_irq() and infinite
> > retries.
>
> 8 is fine.
>
> > Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
>
> +       if (pkt[0] == 1) {
> +               /* response string - ignore it */
> +               char *end = strchr(pkt, '\r');
> +               end[0] = 0;
> +               dbg("IdealTEK response: %s\n", &pkt[1]);
> +               return 0;
>
> just remove this block
>
> +       } else if ((pkt[0] & 0x98) == 0x88) {
> +               /* touch data in IdealTEK mode */
> +               dev->x = (pkt[1] << 5) | (pkt[2] >> 2);
> +               dev->y = (pkt[3] << 5) | (pkt[4] >> 2);
> +               dev->touch = (pkt[0] & 0x40) ? 1 : 0;
> +               return 1;
> +       } else if ((pkt[0] & 0x98) == 0x98) {
> +               /* touch data in MT emulation mode */
> +               dev->x = (pkt[2] << 5) | (pkt[1] >> 2);
> +               dev->y = (pkt[4] << 5) | (pkt[3] >> 2);
> +               dev->touch = (pkt[0] & 0x40) ? 1 : 0;
> +               return 1;
> +       } else {
> +               dbg("IdealTEK: invalid data\n");
> +               return 0;
> +       }
>
> and this one as well...and do a 'return 0;' as last statement
> outside the 'if'

done

>
> +               .process_pkt    = usbtouch_process_multi,
>
> so you're using the support for packets split across two
> URBs? is it required? if so, you have to ensure that the function
> is compiled in. ie. extend this statement in the driver with your
> config option:

Yes, it didn't work properly without that. The device sends touch data in 
5-byte packets but can also send replies of arbitrary length to commands. It 
also sends a "reply" (4-byte) after it's enabled. So the first packet is 4 
bytes and all subsequent are 5-byte. Maybe that's why this is needed.

>
> #if defined(CONFIG_TOUCHSCREEN_USB_EGALAX) ||
> defined(CONFIG_TOUCHSCREEN_USB_ETURBO) #define MULTI_PACKET
> #endif
>
> the rest looks fine.
>
> rgds
> -daniel

OK, so here's the new patch, inline this time:

This patch adds support for IdealTEK URTC1000 touchscreen controllers.

Documentation can be downloaded at 
http://projects.tbmn.org/cgi-bin/trac.cgi/wiki/urtc-1000

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>


diff -ur linux-2.6.23-rc3-orig/drivers/input/touchscreen/Kconfig linux-2.6.23-rc3/drivers/input/touchscreen/Kconfig
--- linux-2.6.23-rc3-orig/drivers/input/touchscreen/Kconfig	2007-08-21 15:32:50.000000000 +0200
+++ linux-2.6.23-rc3/drivers/input/touchscreen/Kconfig	2007-08-23 16:07:08.000000000 +0200
@@ -191,6 +191,7 @@
 	  - Gunze AHL61
 	  - DMC TSC-10/25
 	  - IRTOUCHSYSTEMS/UNITOP
+	  - IdealTEK URTC1000
 
 	  Have a look at <http://linux.chapter7.ch/touchkit/> for
 	  a usage description and the required user-space stuff.
@@ -238,4 +239,9 @@
 	bool "IRTOUCHSYSTEMS/UNITOP device support" if EMBEDDED
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
+config TOUCHSCREEN_USB_IDEALTEK
+	default y
+	bool "IdealTEK URTC1000 device support" if EMBEDDED
+	depends on TOUCHSCREEN_USB_COMPOSITE
+
 endif
diff -ur linux-2.6.23-rc3-orig/drivers/input/touchscreen/usbtouchscreen.c linux-2.6.23-rc3/drivers/input/touchscreen/usbtouchscreen.c
--- linux-2.6.23-rc3-orig/drivers/input/touchscreen/usbtouchscreen.c	2007-08-23 16:24:16.000000000 +0200
+++ linux-2.6.23-rc3/drivers/input/touchscreen/usbtouchscreen.c	2007-08-27 09:29:06.000000000 +0200
@@ -10,6 +10,7 @@
  *  - Gunze AHL61
  *  - DMC TSC-10/25
  *  - IRTOUCHSYSTEMS/UNITOP
+ *  - IdealTEK URTC1000
  *
  * Copyright (C) 2004-2006 by Daniel Ritz <daniel.ritz@gmx.ch>
  * Copyright (C) by Todd E. Johnson (mtouchusb.c)
@@ -92,7 +93,7 @@
 };
 
 
-#if defined(CONFIG_TOUCHSCREEN_USB_EGALAX) || defined(CONFIG_TOUCHSCREEN_USB_ETURBO)
+#if defined(CONFIG_TOUCHSCREEN_USB_EGALAX) || defined(CONFIG_TOUCHSCREEN_USB_ETURBO) || defined(CONFIG_TOUCHSCREEN_USB_IDEALTEK)
 #define MULTI_PACKET
 #endif
 
@@ -112,6 +113,7 @@
 	DEVTYPE_GUNZE,
 	DEVTYPE_DMC_TSC10,
 	DEVTYPE_IRTOUCH,
+	DEVTYPE_IDEALTEK,
 };
 
 static struct usb_device_id usbtouch_devices[] = {
@@ -157,6 +159,10 @@
 	{USB_DEVICE(0x6615, 0x0001), .driver_info = DEVTYPE_IRTOUCH},
 #endif
 
+#ifdef CONFIG_TOUCHSCREEN_USB_IDEALTEK
+	{USB_DEVICE(0x1391, 0x1000), .driver_info = DEVTYPE_IDEALTEK},
+#endif
+
 	{}
 };
 
@@ -438,6 +444,39 @@
 
 
 /*****************************************************************************
+ * IdealTEK URTC1000 Part
+ */
+#ifdef CONFIG_TOUCHSCREEN_USB_IDEALTEK
+static int idealtek_get_pkt_len(unsigned char *buf, int len)
+{
+	if (buf[0] & 0x80)
+		return 5;
+	if (buf[0] == 0x01)
+		return len;
+	return 0;
+}
+
+static int idealtek_read_data(struct usbtouch_usb *dev, unsigned char *pkt)
+{
+	if ((pkt[0] & 0x98) == 0x88) {
+		/* touch data in IdealTEK mode */
+		dev->x = (pkt[1] << 5) | (pkt[2] >> 2);
+		dev->y = (pkt[3] << 5) | (pkt[4] >> 2);
+		dev->touch = (pkt[0] & 0x40) ? 1 : 0;
+		return 1;
+	} else if ((pkt[0] & 0x98) == 0x98) {
+		/* touch data in MT emulation mode */
+		dev->x = (pkt[2] << 5) | (pkt[1] >> 2);
+		dev->y = (pkt[4] << 5) | (pkt[3] >> 2);
+		dev->touch = (pkt[0] & 0x40) ? 1 : 0;
+		return 1;
+	}
+	return 0;
+}
+#endif
+
+
+/*****************************************************************************
  * the different device descriptors
  */
 static struct usbtouch_device_info usbtouch_dev_info[] = {
@@ -537,6 +576,20 @@
 		.read_data	= irtouch_read_data,
 	},
 #endif
+
+#ifdef CONFIG_TOUCHSCREEN_USB_IDEALTEK
+	[DEVTYPE_IDEALTEK] = {
+		.min_xc		= 0x0,
+		.max_xc		= 0x0fff,
+		.min_yc		= 0x0,
+		.max_yc		= 0x0fff,
+		.rept_size	= 8,
+		.flags		= USBTOUCH_FLG_BUFFER,
+		.process_pkt	= usbtouch_process_multi,
+		.get_pkt_len	= idealtek_get_pkt_len,
+		.read_data	= idealtek_read_data,
+	},
+#endif
 };
 
 


-- 
Ondrej Zary
