Return-Path: <linux-kernel-owner+w=401wt.eu-S1755406AbXIUGM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbXIUGM2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 02:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910AbXIUGMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 02:12:19 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:46600 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093AbXIUGMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 02:12:18 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 21 Sep 2007 08:11:08 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2.6.22.y, 2.6.20.y] ieee1394: ohci1394: fix initialization if
 built non-modular
To: stable@kernel.org
cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org
Message-ID: <tkrat.e46434c80b622f2b@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Initialization of ohci1394 was broken according to one reporter if the
driver was statically linked, i.e. not built as loadable module.  Dmesg:

  PCI: Device 0000:02:07.0 not available because of resource collisions
  ohci1394: Failed to enable OHCI hardware.

This was reported for a Toshiba Satellite 5100-503.  The cause is commit
8df4083c5291b3647e0381d3c69ab2196f5dd3b7 in Linux 2.6.19-rc1 which only
served purposes of early remote debugging via FireWire.  This
functionality is better provided by the currently out-of-tree driver
ohci1394_earlyinit.  Reversal of the commit was OK'd by Andi Kleen.

Same as pre-2.6.23 commit be7963b7e7f08a149e247c0bf29a4abd174e0929.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/ieee1394_core.c |    2 +-
 drivers/ieee1394/ohci1394.c      |    4 +---
 2 files changed, 2 insertions(+), 4 deletions(-)

Index: linux/drivers/ieee1394/ieee1394_core.c
===================================================================
--- linux.orig/drivers/ieee1394/ieee1394_core.c
+++ linux/drivers/ieee1394/ieee1394_core.c
@@ -1273,7 +1273,7 @@ static void __exit ieee1394_cleanup(void
 	unregister_chrdev_region(IEEE1394_CORE_DEV, 256);
 }
 
-fs_initcall(ieee1394_init); /* same as ohci1394 */
+module_init(ieee1394_init);
 module_exit(ieee1394_cleanup);
 
 /* Exported symbols */
Index: linux/drivers/ieee1394/ohci1394.c
===================================================================
--- linux.orig/drivers/ieee1394/ohci1394.c
+++ linux/drivers/ieee1394/ohci1394.c
@@ -3537,7 +3537,5 @@ static int __init ohci1394_init(void)
 	return pci_register_driver(&ohci1394_pci_driver);
 }
 
-/* Register before most other device drivers.
- * Useful for remote debugging via physical DMA, e.g. using firescope. */
-fs_initcall(ohci1394_init);
+module_init(ohci1394_init);
 module_exit(ohci1394_cleanup);

-- 
Stefan Richter
-=====-=-=== =--= =-=-=
http://arcgraph.de/sr/

