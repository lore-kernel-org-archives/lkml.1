Return-Path: <linux-kernel-owner+w=401wt.eu-S1763170AbXJMOvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763170AbXJMOvq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 10:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761279AbXJMOmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 10:42:46 -0400
Received: from 1wt.eu ([62.212.114.60]:3014 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761260AbXJMOmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 10:42:45 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20071013143507.%N@1wt.eu>
References: <20071013142822.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 13 Oct 2007 17:28:49 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.21 review 27/35] ieee1394: ohci1394: fix initialization if built non-modular
Content-Disposition: inline; filename=0083-ieee1394-ohci1394-fix-initialization-if-built-non.patch
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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/ieee1394/ieee1394_core.c |    2 +-
 drivers/ieee1394/ohci1394.c      |    4 +---
 2 files changed, 2 insertions(+), 4 deletions(-)

Index: 2.6/drivers/ieee1394/ieee1394_core.c
===================================================================
--- 2.6.orig/drivers/ieee1394/ieee1394_core.c
+++ 2.6/drivers/ieee1394/ieee1394_core.c
@@ -1170,7 +1170,7 @@ static void __exit ieee1394_cleanup(void
 	unregister_chrdev_region(IEEE1394_CORE_DEV, 256);
 }
 
-fs_initcall(ieee1394_init); /* same as ohci1394 */
+module_init(ieee1394_init);
 module_exit(ieee1394_cleanup);
 
 /* Exported symbols */
Index: 2.6/drivers/ieee1394/ohci1394.c
===================================================================
--- 2.6.orig/drivers/ieee1394/ohci1394.c
+++ 2.6/drivers/ieee1394/ohci1394.c
@@ -3785,7 +3785,5 @@ static int __init ohci1394_init(void)
 	return pci_register_driver(&ohci1394_pci_driver);
 }
 
-/* Register before most other device drivers.
- * Useful for remote debugging via physical DMA, e.g. using firescope. */
-fs_initcall(ohci1394_init);
+module_init(ohci1394_init);
 module_exit(ohci1394_cleanup);

-- 
