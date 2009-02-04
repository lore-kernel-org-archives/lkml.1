Return-Path: <linux-kernel-owner+w=401wt.eu-S1759089AbZBDSjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759089AbZBDSjK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:39:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758247AbZBDShF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:37:05 -0500
Received: from kroah.org ([198.145.64.141]:50939 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758264AbZBDShC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:37:02 -0500
Date: Wed, 4 Feb 2009 10:34:24 -0800
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
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jike Song <albcamus@gmail.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [patch 05/33] PCI/MSI: bugfix/utilize for msi_capability_init()
Message-ID: <20090204183424.GF13936@kroah.com>
References: <20090204182823.831027530@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="pci-msi-bugfix-utilize-for-msi_capability_init.patch"
In-Reply-To: <20090204183403.GA13936@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

commit 0db29af1e767464d71b89410d61a1e5b668d0370 upstream.

This patch fix a following bug and does a cleanup.

bug:
	commit 5993760f7fc75b77e4701f1e56dc84c0d6cf18d5
	had a wrong change (since is_64 is boolean[0|1]):

-               pci_write_config_dword(dev,
-                       msi_mask_bits_reg(pos, is_64bit_address(control)),
-                       maskbits);
+               pci_write_config_dword(dev, entry->msi_attrib.is_64, maskbits);

utilize:
	Unify separated if (entry->msi_attrib.maskbit) statements.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Acked-by: "Jike Song" <albcamus@gmail.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/msi.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -378,21 +378,19 @@ static int msi_capability_init(struct pc
 	entry->msi_attrib.masked = 1;
 	entry->msi_attrib.default_irq = dev->irq;	/* Save IOAPIC IRQ */
 	entry->msi_attrib.pos = pos;
-	if (entry->msi_attrib.maskbit) {
-		entry->mask_base = (void __iomem *)(long)msi_mask_bits_reg(pos,
-				entry->msi_attrib.is_64);
-	}
 	entry->dev = dev;
 	if (entry->msi_attrib.maskbit) {
-		unsigned int maskbits, temp;
+		unsigned int base, maskbits, temp;
+
+		base = msi_mask_bits_reg(pos, entry->msi_attrib.is_64);
+		entry->mask_base = (void __iomem *)(long)base;
+
 		/* All MSIs are unmasked by default, Mask them all */
-		pci_read_config_dword(dev,
-			msi_mask_bits_reg(pos, entry->msi_attrib.is_64),
-			&maskbits);
+		pci_read_config_dword(dev, base, &maskbits);
 		temp = (1 << multi_msi_capable(control));
 		temp = ((temp - 1) & ~temp);
 		maskbits |= temp;
-		pci_write_config_dword(dev, entry->msi_attrib.is_64, maskbits);
+		pci_write_config_dword(dev, base, maskbits);
 		entry->msi_attrib.maskbits_mask = temp;
 	}
 	list_add_tail(&entry->list, &dev->msi_list);

