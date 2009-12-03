Return-Path: <linux-kernel-owner+w=401wt.eu-S1755996AbZLCNXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbZLCNXw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 08:23:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755732AbZLCNXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 08:23:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:32908 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752290AbZLCNXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 08:23:50 -0500
Date: Thu, 3 Dec 2009 13:22:57 GMT
From: "tip-bot for Darrick J. Wong" <djwong@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       joerg.roedel@amd.com, fujita.tomonori@lab.ntt.co.jp, djwong@us.ibm.com,
       muli@il.ibm.com, coschult@us.ibm.com, yhlu.kernel@gmail.com,
       jdmason@kudzu.us, stable@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       joerg.roedel@amd.com, djwong@us.ibm.com, fujita.tomonori@lab.ntt.co.jp,
       muli@il.ibm.com, coschult@us.ibm.com, yhlu.kernel@gmail.com,
       jdmason@kudzu.us, stable@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091202230556.GG10295@tux1.beaverton.ibm.com>
References: <20091202230556.GG10295@tux1.beaverton.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/iommu] x86, Calgary IOMMU quirk: Find nearest matching Calgary while walking up the PCI tree
Message-ID: <tip-4528752f49c1f4025473d12bc5fa9181085c3f22@git.kernel.org>
Git-Commit-ID: 4528752f49c1f4025473d12bc5fa9181085c3f22
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4528752f49c1f4025473d12bc5fa9181085c3f22
Gitweb:     http://git.kernel.org/tip/4528752f49c1f4025473d12bc5fa9181085c3f22
Author:     Darrick J. Wong <djwong@us.ibm.com>
AuthorDate: Wed, 2 Dec 2009 15:05:56 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 3 Dec 2009 11:44:05 +0100

x86, Calgary IOMMU quirk: Find nearest matching Calgary while walking up the PCI tree

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
Cc: <stable@kernel.org>
LKML-Reference: <20091202230556.GG10295@tux1.beaverton.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/pci-calgary_64.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index 849a099..c563e4c 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -316,13 +316,15 @@ static inline struct iommu_table *find_iommu_table(struct device *dev)
 
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
 
