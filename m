Return-Path: <linux-kernel-owner+w=401wt.eu-S965480AbXC0Vac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965480AbXC0Vac (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 17:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965489AbXC0Vab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 17:30:31 -0400
Received: from mail.gmx.net ([213.165.64.20]:40490 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S965480AbXC0Vaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 17:30:30 -0400
X-Authenticated: #3035711
X-Provags-ID: V01U2FsdGVkX19s5rs7YwBsAq1VGfHGoVEHMIrpeosbMQl1M7fC66
	ilMxKHPBqqovJc
Message-ID: <46098CE4.5060907@gmx.de>
Date: Tue, 27 Mar 2007 23:30:12 +0200
From: Ingo van Lil <inguin@gmx.de>
User-Agent: Thunderbird 1.5.0.7 (X11/20060909)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] USB config selection for RNDIS devices
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

the USB configuration selection code in drivers/usb/core/generic.c will
refuse to use an RNDIS-only device if the RNDIS driver is compiled as a
module. The straightforward solution would be to change the #ifndef test
to include CONFIG_USB_NET_RNDIS_HOST_MODULE as well, but I'd rather
suggest to drop the entire check instead. That way the RNDIS-case will
be treated just like a vendor-specific configuration: It will be chosen
only if no better choice (e.g. CDC) can be found.

Cheers,
Ingo

Signed-off-by: Ingo van Lil <inguin@gmx.de>
---
--- drivers/usb/core/generic.c.orig	2007-03-27 23:03:17.000000000 +0200
+++ drivers/usb/core/generic.c	2007-03-27 23:06:18.000000000 +0200
@@ -88,17 +88,13 @@
 		}

 		/* If the first config's first interface is COMM/2/0xff
-		 * (MSFT RNDIS), rule it out unless Linux has host-side
-		 * RNDIS support. */
+		 * (MSFT RNDIS), select it but keep scanning something
+		 * better (ideally a CDC ethernet interface). */
 		if (i == 0 && desc
 				&& desc->bInterfaceClass == USB_CLASS_COMM
 				&& desc->bInterfaceSubClass == 2
 				&& desc->bInterfaceProtocol == 0xff) {
-#ifndef CONFIG_USB_NET_RNDIS_HOST
-			continue;
-#else
 			best = c;
-#endif
 		}

 		/* From the remaining configs, choose the first one whose
