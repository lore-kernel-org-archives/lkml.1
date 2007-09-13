Return-Path: <linux-kernel-owner+w=401wt.eu-S1765732AbXIMGf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765732AbXIMGf7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 02:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754806AbXIMGfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 02:35:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:48873 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171AbXIMGfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 02:35:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,248,1186383600"; 
   d="scan'208";a="304705234"
Subject: [PATCH]PCI:disable resource decode in PCI BAR detection
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>
Content-Type: text/plain
Date: Thu, 13 Sep 2007 14:21:07 +0800
Message-Id: <1189664467.17835.1.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=8833
We write 0xffffffff to BARs to detect BAR size, this will change BAR
base to 0xfxxxxxx depends on BAR size. In the bug, PCI MCFG base address
is 0xf4000000. One PCI device (gfx) has a 256M BAR, the detection code
will temprarily change it to 0xf0000000, so conflict with MCFG decode
range. Later memory based config space read/write address is decoded by
both MCH and gfx and cause a hang. This patch disables resource decode
in BAR size detection to avoid resource conflict. 

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 drivers/pci/probe.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux/drivers/pci/probe.c
===================================================================
--- linux.orig/drivers/pci/probe.c	2007-09-12 10:44:19.000000000 +0800
+++ linux/drivers/pci/probe.c	2007-09-13 12:58:18.000000000 +0800
@@ -185,6 +185,11 @@ static void pci_read_bases(struct pci_de
 	unsigned int pos, reg, next;
 	u32 l, sz;
 	struct resource *res;
+	u16 command;
+
+	pci_read_config_word(dev, PCI_COMMAND, &command);
+	pci_write_config_word(dev, PCI_COMMAND,
+		command & (~(PCI_COMMAND_MEMORY|PCI_COMMAND_IO)));
 
 	for(pos=0; pos<howmany; pos = next) {
 		u64 l64;
@@ -283,6 +288,7 @@ static void pci_read_bases(struct pci_de
 			}
 		}
 	}
+	pci_write_config_word(dev, PCI_COMMAND, command);
 }
 
 void pci_read_bridge_bases(struct pci_bus *child)
