Return-Path: <linux-kernel-owner+w=401wt.eu-S1765544AbXHWRta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765544AbXHWRta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 13:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759388AbXHWRtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 13:49:22 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:58555 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbXHWRtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 13:49:21 -0400
Date: Thu, 23 Aug 2007 18:49:17 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz
Subject: [PCI]
Message-ID: <20070823174917.GA19000@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On MIPS with PCI && !HOTPLUG, I'm currently getting the following modpost
warning:

  MODPOST vmlinux.o
WARNING: vmlinux.o(.text+0x1ce128): Section mismatch: reference to .init.text:pci_read_bridge_bases (between 'pcibios_fixup_bus' and 'pcibios_enable_device')

On MIPS I have the call chains pci_scan_child_bus -> pcibios_fixup_bus ->
pci_read_bridge_bases.  pci_scan_child_bus can't be __devinit because it
it is an exported symbol, thus pcibios_fixup_bus and pci_read_bridge_bases
can't be either.

For some reason I don't see this issue on x86; I blame compiler differences.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 34b8dae..1c8087f 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -285,7 +285,7 @@ static void pci_read_bases(struct pci_dev *dev, unsigned int howmany, int rom)
 	}
 }
 
-void __devinit pci_read_bridge_bases(struct pci_bus *child)
+void pci_read_bridge_bases(struct pci_bus *child)
 {
 	struct pci_dev *dev = child->self;
 	u8 io_base_lo, io_limit_lo;
