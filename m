Return-Path: <linux-kernel-owner+w=401wt.eu-S1752227AbZIKOAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbZIKOAa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 10:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751679AbZIKOA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 10:00:29 -0400
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:62865 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751418AbZIKOA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 10:00:28 -0400
Subject: Re: UWB Kconfig: cannot set UWB to N in gconfig
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: David Vrabel <david.vrabel@csr.com>, Roman Zippel <zippel@linux-m68k.org>,
       linux-usb <linux-usb@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20090910090806.e8db2300.randy.dunlap@oracle.com>
References: <1252577154.2340.12.camel@castor>
	 <20090910090806.e8db2300.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Fri, 11 Sep 2009 15:00:30 +0100
Message-Id: <1252677630.2282.11.camel@castor>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-10 at 09:08 -0700, Randy Dunlap wrote:
> On Thu, 10 Sep 2009 11:05:54 +0100 Richard Kennedy wrote:
> 
> > I sometimes use 'make gconfig' and I noticed that I cannot disable the
> > UWB option -- it just won't let me set it to N.
> 
> Not specific to 'gconfig'.
> 
> > AFAICT this is because the CONFIG USB_WUSB selects UWB which forces it
> > on.
> 
> Yes.
> 
> > applying this patch fixes the issue but I'm not sure if this is the
> > right way to go about it.
> > 
> > any thoughts?
> 
> UWB can be disabled by disabling both of these options that are several
> entries below it in the same menu:
> 
> USB_WHCI_HCD and USB_HWA_HCD
> 
> and then returning to UWB and disabling it.
> 
> Should users have to figure that out?  no.
> 
thanks,
although it's not easy to figure out how to disable this in gconfig.
USB_WHCI_HCD & USB_HWA_HCD end up under a different menu
(drivers/usb/host). 
If you don't know that they exist, all you see is the options under UWB
set to M and gconfig doesn't let you turn them off.  

Here's another version of the patch that changes them all to 'depends
on'. This lets gconfig do the right thing :)

regards
Richard

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 1a920c7..5b6924b 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -347,8 +347,8 @@ config USB_WHCI_HCD
 	tristate "Wireless USB Host Controller Interface (WHCI) driver (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
 	depends on PCI && USB
-	select USB_WUSB
-	select UWB_WHCI
+	depends on  USB_WUSB
+	depends on UWB_WHCI
 	help
 	  A driver for PCI-based Wireless USB Host Controllers that are
 	  compliant with the WHCI specification.
@@ -360,8 +360,8 @@ config USB_HWA_HCD
 	tristate "Host Wire Adapter (HWA) driver (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
 	depends on USB
-	select USB_WUSB
-	select UWB_HWA
+	depends on USB_WUSB
+	depends on UWB_HWA
 	help
 	  This driver enables you to connect Wireless USB devices to
 	  your system using a Host Wire Adaptor USB dongle. This is an
diff --git a/drivers/usb/wusbcore/Kconfig b/drivers/usb/wusbcore/Kconfig
index eb09a0a..8209da9 100644
--- a/drivers/usb/wusbcore/Kconfig
+++ b/drivers/usb/wusbcore/Kconfig
@@ -5,7 +5,7 @@ config USB_WUSB
 	tristate "Enable Wireless USB extensions (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
 	depends on USB
-        select UWB
+	depends on UWB
         select CRYPTO
         select CRYPTO_BLKCIPHER
         select CRYPTO_CBC



