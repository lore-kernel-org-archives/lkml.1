Return-Path: <linux-kernel-owner+w=401wt.eu-S1762748AbZLQAy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762748AbZLQAy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 19:54:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761485AbZLQAyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 19:54:44 -0500
Received: from kroah.org ([198.145.64.141]:44517 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760714AbZLQAym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 19:54:42 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 16:47:08 2009
Message-Id: <20091217004708.549421595@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 16:46:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Darrick J. Wong" <djwong@us.ibm.com>,
       Muli Ben-Yehuda <muli@il.ibm.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Joerg Roedel <joerg.roedel@amd.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       "Jon D. Mason" <jdmason@kudzu.us>,
       Corinna Schultz <coschult@us.ibm.com>, Ingo Molnar <mingo@elte.hu>
Subject: [11/18] x86, Calgary IOMMU quirk: Find nearest matching Calgary while walking up the PCI tree
In-Reply-To: <20091217005306.GA6230@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Darrick J. Wong <djwong@us.ibm.com>

commit 4528752f49c1f4025473d12bc5fa9181085c3f22 upstream.

On a multi-node x3950M2 system, there's a slight oddity in the
PCI device tree for all secondary nodes:

 30:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev e1)
  \-33:00.0 PCI bridge: IBM CalIOC2 PCI-E Root Port (rev 01)
     \-34:00.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID SAS 1078 (rev 04)

...as compared to the primary node:

 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev e1)
  \-01:00.0 VGA compatible controller: ATI Technologies Inc ES1000 (rev 02)
 03:00.0 PCI bridge: IBM CalIOC2 PCI-E Root Port (rev 01)
  \-04:00.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID SAS 1078 (rev 04)

In both nodes, the LSI RAID controller hangs off a CalIOC2
device, but on the secondary nodes, the BIOS hides the VGA
device and substitutes the device tree ending with the disk
controller.

It would seem that Calgary devices don't necessarily appear at
the top of the PCI tree, which means that the current code to
find the Calgary IOMMU that goes with a particular device is
buggy.

Rather than walk all the way to the top of the PCI
device tree and try to match bus number with Calgary descriptor,
the code needs to examine each parent of the particular device;
if it encounters a Calgary with a matching bus number, simply
use that.

Otherwise, we BUG() when the bus number of the Calgary doesn't
match the bus number of whatever's at the top of the device tree.

Extra note: This patch appears to work correctly for the x3950
that came before the x3950 M2.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Jon D. Mason <jdmason@kudzu.us>
Cc: Corinna Schultz <coschult@us.ibm.com>
LKML-Reference: <20091202230556.GG10295@tux1.beaverton.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/pci-calgary_64.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -377,13 +377,15 @@ static inline struct iommu_table *find_i
 
 	pdev = to_pci_dev(dev);
 
+	/* search up the device tree for an iommu */
 	pbus = pdev->bus;
-
-	/* is the device behind a bridge? Look for the root bus */
-	while (pbus->parent)
+	do {
+		tbl = pci_iommu(pbus);
+		if (tbl && tbl->it_busno == pbus->number)
+			break;
+		tbl = NULL;
 		pbus = pbus->parent;
-
-	tbl = pci_iommu(pbus);
+	} while (pbus);
 
 	BUG_ON(tbl && (tbl->it_busno != pbus->number));
 


