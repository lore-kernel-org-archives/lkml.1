Return-Path: <linux-kernel-owner+w=401wt.eu-S1762088AbXIXQgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762088AbXIXQgD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:36:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760767AbXIXQ05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:26:57 -0400
Received: from canuck.infradead.org ([209.217.80.40]:47561 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760536AbXIXQ04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:26:56 -0400
Date: Mon, 24 Sep 2007 09:21:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Willy Tarreau <w@1wt.eu>, Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [30/50] ieee1394: ohci1394: fix initialization if built non-modular
Message-ID: <20070924162142.GE13510@kroah.com>
References: <20070924161246.983665021@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ieee1394-ohci1394-fix-initialization-if-built-non-modular.patch"
In-Reply-To: <20070924161733.GA13510@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Richter <stefanr@s5r6.in-berlin.de>

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

--- a/drivers/ieee1394/ieee1394_core.c
+++ b/drivers/ieee1394/ieee1394_core.c
@@ -1279,7 +1279,7 @@ static void __exit ieee1394_cleanup(void
 	unregister_chrdev_region(IEEE1394_CORE_DEV, 256);
 }
 
-fs_initcall(ieee1394_init); /* same as ohci1394 */
+module_init(ieee1394_init);
 module_exit(ieee1394_cleanup);
 
 /* Exported symbols */
--- a/drivers/ieee1394/ohci1394.c
+++ b/drivers/ieee1394/ohci1394.c
@@ -3773,7 +3773,5 @@ static int __init ohci1394_init(void)
 	return pci_register_driver(&ohci1394_pci_driver);
 }
 
-/* Register before most other device drivers.
- * Useful for remote debugging via physical DMA, e.g. using firescope. */
-fs_initcall(ohci1394_init);
+module_init(ohci1394_init);
 module_exit(ohci1394_cleanup);

-- 
