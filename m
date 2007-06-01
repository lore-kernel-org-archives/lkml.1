Return-Path: <linux-kernel-owner+w=401wt.eu-S1761369AbXFABQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761369AbXFABQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 21:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758773AbXFABQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 21:16:00 -0400
Received: from mail.kroah.org ([69.55.234.183]:46579 "EHLO perch.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758300AbXFABP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 21:15:59 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-pci@atrey.karlin.mff.cuni.cz
Cc: linux-kernel@vger.kernel.org, Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Wolfgang Erig <Wolfgang.Erig@gmx.de>, Chuck Ebbert <cebbert@redhat.com>,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 4/5] PCI: i386: fixup for Siemens Nixdorf AG FSC Multiprocessor Interrupt Controllers
Date: Thu, 31 May 2007 18:16:56 -0700
Message-Id: <11806606173283-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2
In-Reply-To: <11806606172411-git-send-email-gregkh@suse.de>
References: <20070601011612.GA28262@kroah.com>
 <11806606172653-git-send-email-gregkh@suse.de>
 <11806606172891-git-send-email-gregkh@suse.de>
 <11806606172411-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

Wolfgang gets:

 PCI: Cannot allocate resource region 0 of device 0000:00:04.0
 PCI: Error while updating region 0000:00:04.0/0 (a8008000 != fec08000)

Note that the BAR seems to have high address bits hardwired to fec00000.
And device 0000:00:04.0 is

 00:04.0 System peripheral: Siemens Nixdorf AG FSC Multiprocessor Interrupt Controller (rev 02)

I'd guess that when we try to reassign this resource, PCI interrupts might
just stop working. This could explain SCSI timeouts and other weird things.

Cc: Wolfgang Erig <Wolfgang.Erig@gmx.de>
Cc: Chuck Ebbert <cebbert@redhat.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/i386/pci/fixup.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/i386/pci/fixup.c b/arch/i386/pci/fixup.c
index b62eafb..b95b429 100644
--- a/arch/i386/pci/fixup.c
+++ b/arch/i386/pci/fixup.c
@@ -436,3 +436,14 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_CYRIX, PCI_DEVICE_ID_CYRIX_5530_LEGACY,
 			pci_early_fixup_cyrix_5530);
 DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_CYRIX, PCI_DEVICE_ID_CYRIX_5530_LEGACY,
 			pci_early_fixup_cyrix_5530);
+
+/*
+ * Siemens Nixdorf AG FSC Multiprocessor Interrupt Controller:
+ * prevent update of the BAR0, which doesn't look like a normal BAR.
+ */
+static void __devinit pci_siemens_interrupt_controller(struct pci_dev *dev)
+{
+	dev->resource[0].flags |= IORESOURCE_PCI_FIXED;
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SIEMENS, 0x0015,
+			  pci_siemens_interrupt_controller);
-- 
1.5.2

