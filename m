Return-Path: <linux-kernel-owner+w=401wt.eu-S1758557AbYFTX50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557AbYFTX50 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 19:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755583AbYFTX4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 19:56:46 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:33943 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367AbYFTX4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 19:56:44 -0400
Date: Sat, 21 Jun 2008 03:28:54 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Richard Henderson <rth@twiddle.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] alpha: resurrect Cypress IDE quirk
Message-ID: <20080620232854.GD8061@jurassic.park.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Which was removed in the hope that generic legacy IDE quirk in
drivers/pci/probe.c is sufficient for Cypress IDE.
It isn't, as this controller has non-standard BAR layout:
secondary channel registers are in the BAR0-1 of the second
PCI function - not in the BAR2-3 of the same function, as the
generic quirk routine assumes.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
---
 arch/alpha/kernel/pci.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/arch/alpha/kernel/pci.c b/arch/alpha/kernel/pci.c
index 36ab22a..5cf45fc 100644
--- a/arch/alpha/kernel/pci.c
+++ b/arch/alpha/kernel/pci.c
@@ -71,6 +71,23 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82378, quirk_i
 static void __init
 quirk_cypress(struct pci_dev *dev)
 {
+	/* The Notorious Cy82C693 chip.  */
+
+	/* The generic legacy mode IDE fixup in drivers/pci/probe.c
+	   doesn't work correctly with the Cypress IDE controller as
+	   it has non-standard register layout.  Fix that.  */
+	if (dev->class >> 8 == PCI_CLASS_STORAGE_IDE) {
+		dev->resource[2].start = dev->resource[3].start = 0;
+		dev->resource[2].end = dev->resource[3].end = 0;
+		dev->resource[2].flags = dev->resource[3].flags = 0;
+		if (PCI_FUNC(dev->devfn) == 2) {
+			dev->resource[0].start = 0x170;
+			dev->resource[0].end = 0x177;
+			dev->resource[1].start = 0x376;
+			dev->resource[1].end = 0x376;
+		}
+	}
+
 	/* The Cypress bridge responds on the PCI bus in the address range
 	   0xffff0000-0xffffffff (conventional x86 BIOS ROM).  There is no
 	   way to turn this off.  The bridge also supports several extended
