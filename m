Return-Path: <linux-kernel-owner+w=401wt.eu-S1758069AbYKQHeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069AbYKQHeG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 02:34:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755887AbYKQHVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 02:21:40 -0500
Received: from kroah.org ([198.145.64.141]:38629 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755437AbYKQHVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 02:21:30 -0500
Date: Sun, 16 Nov 2008 23:16:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 34/46] USB: remove optional bus bindings in isp1760, fixing
	runtime warning
Message-ID: <20081117071623.GI29522@kroah.com>
References: <20081117070621.430169021@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-remove-optional-bus-bindings-in-isp1760-fixing-runtime-warning.patch"
In-Reply-To: <20081117071333.GA29522@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit ff30bf1ca4b548c0928dae6bfce89458b95e5bf4 upstream.

Roland Reported the following:
| kmem_cache_create: duplicate cache isp1760_qtd
| Pid: 461, comm: modprobe Tainted: G        W  2.6.28-rc2-git3-default #4
| Call Trace:
|  [<c017540e>] kmem_cache_create+0xc9/0x3a3
|  [<c0159a8d>] free_pages_bulk+0x16c/0x1c9
|  [<f165c05f>] isp1760_init+0x0/0xb [isp1760]
|  [<f165c018>] init_kmem_once+0x18/0x5f [isp1760]
|  [<f165c064>] isp1760_init+0x5/0xb [isp1760]
|  [<c010113d>] _stext+0x4d/0x148
|  [<c0142936>] load_module+0x12cd/0x142e
|  [<c01743c4>] kmem_cache_destroy+0x0/0xd7
|  [<c0142b1e>] sys_init_module+0x87/0x176
|  [<c01039eb>] sysenter_do_call+0x12/0x2f

The reason, is that ret is initialized with ENODEV instead of 0 _or_
the kmem cache is not freed in error case with no bus binding.

The difference between OF+PCI and OF only is
| 15148     804      32   15984    3e70 isp1760-of-pci.o
| 13748     676       8   14432    3860 isp1760-of.o

about 1.5 KiB.

Until there is a checkbox where the user *must* select atleast one item,
and may select multiple entries I don't make it selectable anymore.
Having a driver which can't be used under any circumstances is broken
anyway and I've seen distros shipping it that way.

Reported-by: Roland Kletzing <devzero@web.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/Kconfig      |   23 ++++++-----------------
 drivers/usb/host/isp1760-if.c |   22 +++++++++++-----------
 2 files changed, 17 insertions(+), 28 deletions(-)

--- a/drivers/usb/host/isp1760-if.c
+++ b/drivers/usb/host/isp1760-if.c
@@ -14,16 +14,16 @@
 #include "../core/hcd.h"
 #include "isp1760-hcd.h"
 
-#ifdef CONFIG_USB_ISP1760_OF
+#ifdef CONFIG_PPC_OF
 #include <linux/of.h>
 #include <linux/of_platform.h>
 #endif
 
-#ifdef CONFIG_USB_ISP1760_PCI
+#ifdef CONFIG_PCI
 #include <linux/pci.h>
 #endif
 
-#ifdef CONFIG_USB_ISP1760_OF
+#ifdef CONFIG_PPC_OF
 static int of_isp1760_probe(struct of_device *dev,
 		const struct of_device_id *match)
 {
@@ -128,7 +128,7 @@ static struct of_platform_driver isp1760
 };
 #endif
 
-#ifdef CONFIG_USB_ISP1760_PCI
+#ifdef CONFIG_PCI
 static u32 nxp_pci_io_base;
 static u32 iolength;
 static u32 pci_mem_phy0;
@@ -287,28 +287,28 @@ static struct pci_driver isp1761_pci_dri
 
 static int __init isp1760_init(void)
 {
-	int ret = -ENODEV;
+	int ret;
 
 	init_kmem_once();
 
-#ifdef CONFIG_USB_ISP1760_OF
+#ifdef CONFIG_PPC_OF
 	ret = of_register_platform_driver(&isp1760_of_driver);
 	if (ret) {
 		deinit_kmem_cache();
 		return ret;
 	}
 #endif
-#ifdef CONFIG_USB_ISP1760_PCI
+#ifdef CONFIG_PCI
 	ret = pci_register_driver(&isp1761_pci_driver);
 	if (ret)
 		goto unreg_of;
 #endif
 	return ret;
 
-#ifdef CONFIG_USB_ISP1760_PCI
+#ifdef CONFIG_PCI
 unreg_of:
 #endif
-#ifdef CONFIG_USB_ISP1760_OF
+#ifdef CONFIG_PPC_OF
 	of_unregister_platform_driver(&isp1760_of_driver);
 #endif
 	deinit_kmem_cache();
@@ -318,10 +318,10 @@ module_init(isp1760_init);
 
 static void __exit isp1760_exit(void)
 {
-#ifdef CONFIG_USB_ISP1760_OF
+#ifdef CONFIG_PPC_OF
 	of_unregister_platform_driver(&isp1760_of_driver);
 #endif
-#ifdef CONFIG_USB_ISP1760_PCI
+#ifdef CONFIG_PCI
 	pci_unregister_driver(&isp1761_pci_driver);
 #endif
 	deinit_kmem_cache();
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -110,29 +110,18 @@ config USB_ISP116X_HCD
 
 config USB_ISP1760_HCD
 	tristate "ISP 1760 HCD support"
-	depends on USB && EXPERIMENTAL
+	depends on USB && EXPERIMENTAL && (PCI || PPC_OF)
 	---help---
 	  The ISP1760 chip is a USB 2.0 host controller.
 
 	  This driver does not support isochronous transfers or OTG.
+	  This USB controller is usually attached to a non-DMA-Master
+	  capable bus. NXP's eval kit brings this chip on PCI card
+	  where the chip itself is behind a PLB to simulate such
+	  a bus.
 
 	  To compile this driver as a module, choose M here: the
-	  module will be called isp1760-hcd.
-
-config USB_ISP1760_PCI
-	bool "Support for the PCI bus"
-	depends on USB_ISP1760_HCD && PCI
-	---help---
-	  Enables support for the device present on the PCI bus.
-	  This should only be required if you happen to have the eval kit from
-	  NXP and you are going to test it.
-
-config USB_ISP1760_OF
-	bool "Support for the OF platform bus"
-	depends on USB_ISP1760_HCD && PPC_OF
-	---help---
-	  Enables support for the device present on the PowerPC
-	  OpenFirmware platform bus.
+	  module will be called isp1760.
 
 config USB_OHCI_HCD
 	tristate "OHCI HCD support"

-- 
