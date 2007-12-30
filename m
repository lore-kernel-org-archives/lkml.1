Return-Path: <linux-kernel-owner+w=401wt.eu-S1756140AbXL3TKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbXL3TKe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 14:10:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbXL3TK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 14:10:26 -0500
Received: from [212.12.190.118] ([212.12.190.118]:54790 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750944AbXL3TKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 14:10:25 -0500
From: Al Boldi <a1426z@gawab.com>
To: Adrian Bunk <bunk@kernel.org>, David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] USB Kconfig: Reorganize USB Kconfig Menu
Date: Sun, 30 Dec 2007 22:09:16 +0300
User-Agent: KMail/1.5
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
References: <200712231449.00862.a1426z@gawab.com> <200712271418.59156.david-b@pacbell.net> <20071228233450.GC9105@does.not.exist>
In-Reply-To: <20071228233450.GC9105@does.not.exist>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200712302209.16743.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Thu, Dec 27, 2007 at 02:18:58PM -0800, David Brownell wrote:
> > Also, looking at this in xconfig shows some oddness.  That "core"
> > submenu holds stuff that would logically be part of the toplevel
> > menu for host side USB.  While that toplevel menu has the USS720
> > driver, which seems more like a "miscellany" thing...

This one probably belongs in its own sub-menu, but as it is only one option, 
it's not considered worthwhile, so we leave it as is.

> > The comment about SCSI shouldn't show when SCSI is defined; and
> > the comment aboue "SCSI disk support" belongs with the mass storage
> > menu, not at the top level.  The way that the mass storage menu
> > is presented also hides the fact that you can get fully functional
> > mass storage support without checking *any* of the drivers there,
> > since the core already handles standard devices.
> >...
>
> The SCSI dependency should be handled through select - there's no
> reason for bothering the kconfig user wih such implementation details.

Agreed, and while we are at it, also select ATM for DSL, like this:

--- 23.a/drivers/usb/atm/Kconfig
+++ 23.b/drivers/usb/atm/Kconfig
@@ -4,7 +4,8 @@
 
 menuconfig USB_ATM
 	tristate "USB DSL modem support"
-	depends on USB && ATM
+	depends on USB && NET
+	select ATM
 	select CRC32
 	default n
 	help
--- 23.a/drivers/usb/storage/Kconfig
+++ 23.b/drivers/usb/storage/Kconfig
@@ -2,14 +2,10 @@
 # USB Storage driver configuration
 #
 
-comment "NOTE: USB_STORAGE needs SCSI, and 'SCSI disk support' may"
-	depends on USB
-comment "also be needed; see USB_STORAGE Help for more information"
-	depends on USB
-
 menuconfig USB_STORAGE
 	tristate "USB Mass Storage support"
-	depends on USB && SCSI
+	depends on USB
+	select SCSI
 	---help---
 	  Say Y here if you want to connect USB mass storage devices to your
 	  computer's USB port. This is the driver you need for USB
@@ -18,13 +14,17 @@ menuconfig USB_STORAGE
 	  similar devices. This driver may also be used for some cameras
 	  and card readers.
 
-	  This option depends on 'SCSI' support being enabled, but you
-	  probably also need 'SCSI device support: SCSI disk support'
+	  This option selects 'SCSI' support , but you probably
+	  also need 'SCSI device support: SCSI disk support'
 	  (BLK_DEV_SD) for most USB storage devices.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called usb-storage.
 
+if USB_STORAGE
+comment "NOTE: USB_STORAGE selects SCSI, but 'SCSI disk support' may"
+comment "also be needed; see USB_STORAGE Help for more information"
+
 config USB_STORAGE_DEBUG
 	bool "USB Mass Storage verbose debug"
 	depends on USB_STORAGE
@@ -147,6 +147,8 @@ config USB_STORAGE_KARMA
 	  on the resulting scsi device node returns the Karma to normal
 	  operation.
 
+endif # USB_STORAGE
+
 config USB_LIBUSUAL
 	bool "The shared table of common (or usual) storage devices"
 	depends on USB


Thanks!

--
Al

