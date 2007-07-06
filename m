Return-Path: <linux-kernel-owner+w=401wt.eu-S1762742AbXGFCMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762742AbXGFCMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 22:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759597AbXGFCMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 22:12:14 -0400
Received: from mail.queued.net ([207.210.101.209]:4110 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759487AbXGFCMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 22:12:13 -0400
Date: Thu, 5 Jul 2007 22:13:51 -0400
From: Andres Salomon <dilinger@queued.net>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jordan Crouse <jordan.crouse@amd.com>, info-linux@geode.amd.com,
       gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz, tsylla@gmail.com
Subject: [PATCH] PCI: do not delay when changing power states on Geode
Message-Id: <20070705221351.97d14df0.dilinger@queued.net>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Geode hardware requires no delay when doing power transition for PCI;
the board doesn't even have a real PCI bus.  Thanks to Tom Sylla for
pointing this out.  We can save precious milliseconds when changing power
states to D3hot by getting rid of this delay.

We do this as a PCI quirk.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---

 drivers/pci/quirks.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 01d8f8a..b85fd5f 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1368,6 +1368,20 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	0x260a, quirk_intel_pcie_pm);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	0x260b, quirk_intel_pcie_pm);
 
 /*
+ * Geode hardware does not require any sort of delay when
+ * transitioning between PCI power states.  This allows us to shave
+ * off time when doing suspend/resume.
+ */
+static void __init quirk_geode_pci_pm(struct pci_dev *dev)
+{
+	pci_pm_d3_delay = 0;
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_CYRIX, PCI_DEVICE_ID_CYRIX_5530_LEGACY,
+		quirk_geode_pci_pm);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_ISA,
+		quirk_geode_pci_pm);
+
+/*
  * Toshiba TC86C001 IDE controller reports the standard 8-byte BAR0 size
  * but the PIO transfers won't work if BAR0 falls at the odd 8 bytes.
  * Re-allocate the region if needed...
