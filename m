Return-Path: <linux-kernel-owner+w=401wt.eu-S1757651AbYHFSsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757651AbYHFSsX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 14:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754458AbYHFSla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 14:41:30 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:53680 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753938AbYHFSl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 14:41:29 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	b=WgFnOJHm9eGRTQdLO/DFMHPHGVZc7FPNV+sF2UB2fqSwDOVGGTWQwCDrVHCbPWdXEtoiDlcJ+Z926JDuB3ahqg4pmibxE4geFM/h70QEI+aSeMT35frY86pHsLEId+RE;
Message-ID: <4899F035.9040003@simon.arlott.org.uk>
Date: Wed, 06 Aug 2008 19:40:53 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.16 (X11/20080726)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Rene Herman <rene.herman@keyaccess.nl>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, Daniel Walker <dwalker@mvista.com>,
       USB list <linux-usb@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH RFC] USB: Add HCD fastboot
References: <Pine.LNX.4.44L0.0807311510220.5019-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0807311510220.5019-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/07/08 20:16, Alan Stern wrote:
>> > It's not entirely clear why usblp is blocking at all.  Probably because
>> > it is waiting on the device semaphores for devices that are currently
>> > being probed -- the driver core won't allow two threads to probe the
>> > same device concurrently.
>> 
>> Ok - so there could be some big improvements to be had by making the hcd 
>> init happen as early as possible and the device initcalls later?
> 
> Maybe.  Perhaps a better approach would be to make the device driver 
> initcalls before there are any devices for their probe routines to 
> block on.

What about this?

The Makefiles become a bit messy, but by moving things around I get the 
desired effect without splitting their initcalls.

[    7.941890] Write protecting the kernel read-only data: 5656k
[    5.437709] Write protecting the kernel read-only data: 5656k

2.5s faster, which is almost half the boot time.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>

---
 drivers/Makefile         |   13 ++++++++++---
 drivers/usb/Makefile     |   30 ++++++++++++++++++++----------
 drivers/usb/core/Kconfig |   17 +++++++++++++++++
 3 files changed, 47 insertions(+), 13 deletions(-)

diff --git a/drivers/Makefile b/drivers/Makefile
index a280ab3..d68151f 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -33,7 +33,12 @@ obj-$(CONFIG_FB_INTEL)          += video/intelfb/
 
 obj-y				+= serial/
 obj-$(CONFIG_PARPORT)		+= parport/
-obj-y				+= base/ block/ misc/ mfd/ net/ media/
+obj-y				+= base/ block/
+ifdef CONFIG_USB_FASTBOOT
+  obj-$(CONFIG_USB)		+= usb/
+  obj-$(CONFIG_PCI)		+= usb/
+endif
+obj-y				+= net/ media/
 obj-$(CONFIG_NUBUS)		+= nubus/
 obj-$(CONFIG_ATM)		+= atm/
 obj-y				+= macintosh/
@@ -56,8 +61,10 @@ obj-$(CONFIG_MAC)		+= macintosh/
 obj-$(CONFIG_ATA_OVER_ETH)	+= block/aoe/
 obj-$(CONFIG_PARIDE) 		+= block/paride/
 obj-$(CONFIG_TC)		+= tc/
-obj-$(CONFIG_USB)		+= usb/
-obj-$(CONFIG_PCI)		+= usb/
+ifndef CONFIG_USB_FASTBOOT
+  obj-$(CONFIG_USB)		+= usb/
+  obj-$(CONFIG_PCI)		+= usb/
+endif
 obj-$(CONFIG_USB_GADGET)	+= usb/gadget/
 obj-$(CONFIG_SERIO)		+= input/serio/
 obj-$(CONFIG_GAMEPORT)		+= input/gameport/
diff --git a/drivers/usb/Makefile b/drivers/usb/Makefile
index a419c42..35766a1 100644
--- a/drivers/usb/Makefile
+++ b/drivers/usb/Makefile
@@ -8,16 +8,22 @@ obj-$(CONFIG_USB)		+= core/
 
 obj-$(CONFIG_USB_MON)		+= mon/
 
-obj-$(CONFIG_PCI)		+= host/
-obj-$(CONFIG_USB_EHCI_HCD)	+= host/
-obj-$(CONFIG_USB_ISP116X_HCD)	+= host/
-obj-$(CONFIG_USB_OHCI_HCD)	+= host/
-obj-$(CONFIG_USB_UHCI_HCD)	+= host/
-obj-$(CONFIG_USB_SL811_HCD)	+= host/
-obj-$(CONFIG_USB_U132_HCD)	+= host/
-obj-$(CONFIG_USB_R8A66597_HCD)	+= host/
-
-obj-$(CONFIG_USB_C67X00_HCD)	+= c67x00/
+tmp-y				:=
+tmp-m				:=
+tmp-$(CONFIG_PCI)		+= host/
+tmp-$(CONFIG_USB_EHCI_HCD)	+= host/
+tmp-$(CONFIG_USB_ISP116X_HCD)	+= host/
+tmp-$(CONFIG_USB_OHCI_HCD)	+= host/
+tmp-$(CONFIG_USB_UHCI_HCD)	+= host/
+tmp-$(CONFIG_USB_SL811_HCD)	+= host/
+tmp-$(CONFIG_USB_U132_HCD)	+= host/
+tmp-$(CONFIG_USB_R8A66597_HCD)	+= host/
+tmp-$(CONFIG_USB_C67X00_HCD)	+= c67x00/
+obj-m				+= $(tmp-m)
+
+ifndef CONFIG_USB_FASTBOOT
+  obj-y				+= $(tmp-y)
+endif
 
 obj-$(CONFIG_USB_ACM)		+= class/
 obj-$(CONFIG_USB_PRINTER)	+= class/
@@ -34,3 +40,7 @@ obj-$(CONFIG_USB)		+= misc/
 
 obj-$(CONFIG_USB_ATM)		+= atm/
 obj-$(CONFIG_USB_SPEEDTOUCH)	+= atm/
+
+ifdef CONFIG_USB_FASTBOOT
+  obj-y				+= $(tmp-y)
+endif
diff --git a/drivers/usb/core/Kconfig b/drivers/usb/core/Kconfig
index cc9f397..ea04a02 100644
--- a/drivers/usb/core/Kconfig
+++ b/drivers/usb/core/Kconfig
@@ -136,3 +136,20 @@ config USB_OTG_BLACKLIST_HUB
 	  and software costs by not supporting external hubs.  So
 	  are "Emedded Hosts" that don't offer OTG support.
 
+
+config USB_FASTBOOT
+	bool "USB Fastboot (EXPERIMENTAL)"
+	depends on USB && EXPERIMENTAL
+	default n
+	help
+	  If you say Y here, USB device driver initialisation will be
+	  performed much earlier on boot followed by HCD initialisation.
+	  Devices will then be initialised in the background USB hub
+	  thread during the rest of the boot process.
+
+	  Side effects of enabling this include IRQ assignments being
+	  different from a normal bootup and the potential for USB and
+	  non-USB devices to be ordered differently on each startup.
+	  (i.e. usb sda, sata sdb vs. sata sda, usb sdb)
+
+	  If you are unsure about this, say N here.
-- 
1.5.6.3

-- 
Simon Arlott
