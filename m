Return-Path: <linux-kernel-owner+w=401wt.eu-S935383AbYBVVst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935383AbYBVVst (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 16:48:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761978AbYBVVnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 16:43:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60443 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933471AbYBVVnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 16:43:32 -0500
Date: Fri, 22 Feb 2008 13:40:32 -0800
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
       Kees Cook <kees@ubuntu.com>, Corey Minyard <minyard@acm.org>,
       David Woodhouse <dwmw2@infradead.org>, Jeff Garzik <jeff@garzik.org>,
       Greg KH <greg@kroah.com>, Jeff Mahoney <jeffm@suse.com>,
       Oliver Pinter <oliver.pntr@gmail.com>
Subject: [patch 11/23] pci: fix unterminated pci_device_id lists
Message-ID: <20080222214032.GL8686@suse.de>
References: <20080222213114.583282464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="pci-fix-unterminated-pci_device_id-lists.patch"
In-Reply-To: <20080222213927.GA8686@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Kees Cook <kees@ubuntu.com>

mainline: 248bdd5efca5a113cbf443a993c69e53d370236b

Fix a couple drivers that do not correctly terminate their pci_device_id
lists.  This results in garbage being spewed into modules.pcimap when the
module happens to not have 28 NULL bytes following the table, and/or the
last PCI ID is actually truncated from the table when calculating the
modules.alias PCI aliases, cause those unfortunate device IDs to not
auto-load.

Signed-off-by: Kees Cook <kees@ubuntu.com>
Acked-by: Corey Minyard <minyard@acm.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Acked-by: Jeff Garzik <jeff@garzik.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Jeff Mahoney <jeffm@suse.com>
CC: Oliver Pinter <oliver.pntr@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/ipmi/ipmi_si_intf.c                |    3 ++-
 drivers/media/video/usbvision/usbvision-cards.c |    1 +
 drivers/mtd/nand/cafe_nand.c                    |    3 ++-
 3 files changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -2214,7 +2214,8 @@ static int ipmi_pci_resume(struct pci_de
 
 static struct pci_device_id ipmi_pci_devices[] = {
 	{ PCI_DEVICE(PCI_HP_VENDOR_ID, PCI_MMC_DEVICE_ID) },
-	{ PCI_DEVICE_CLASS(PCI_ERMC_CLASSCODE, PCI_ERMC_CLASSCODE_MASK) }
+	{ PCI_DEVICE_CLASS(PCI_ERMC_CLASSCODE, PCI_ERMC_CLASSCODE_MASK) },
+	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, ipmi_pci_devices);
 
--- a/drivers/media/video/usbvision/usbvision-cards.c
+++ b/drivers/media/video/usbvision/usbvision-cards.c
@@ -1081,6 +1081,7 @@ struct usb_device_id usbvision_table [] 
 	{ USB_DEVICE(0x2304, 0x0301), .driver_info=PINNA_LINX_VD_IN_CAB_PAL },
 	{ USB_DEVICE(0x2304, 0x0419), .driver_info=PINNA_PCTV_BUNGEE_PAL_FM },
 	{ USB_DEVICE(0x2400, 0x4200), .driver_info=HPG_WINTV },
+	{ },    /* terminate list */
 };
 
 MODULE_DEVICE_TABLE (usb, usbvision_table);
--- a/drivers/mtd/nand/cafe_nand.c
+++ b/drivers/mtd/nand/cafe_nand.c
@@ -816,7 +816,8 @@ static void __devexit cafe_nand_remove(s
 }
 
 static struct pci_device_id cafe_nand_tbl[] = {
-	{ 0x11ab, 0x4100, PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_MEMORY_FLASH << 8, 0xFFFF0 }
+	{ 0x11ab, 0x4100, PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_MEMORY_FLASH << 8, 0xFFFF0 },
+	{ 0, }
 };
 
 MODULE_DEVICE_TABLE(pci, cafe_nand_tbl);

-- 
