Return-Path: <linux-kernel-owner+w=401wt.eu-S1757512AbYAUD21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512AbYAUD21 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 22:28:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755233AbYAUD2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 22:28:19 -0500
Received: from mailhost.igel.co.jp ([219.106.231.130]:56649 "EHLO
	mailhost.igel.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbYAUD2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 22:28:18 -0500
X-Greylist: delayed 1372 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Jan 2008 22:28:17 EST
Date: Mon, 21 Jan 2008 12:05:08 +0900 (JST)
Message-Id: <20080121.120508.143310092.matsu@igel.co.jp>
To: lethal@linux-sh.org
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sh: pci - fix the start address of IO ports area in
 RTS7751R2D.
From: Katsuya MATSUBARA <matsu@igel.co.jp>
X-Mailer: Mew version 5.2.52 on Emacs 21.3.50 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sh: pci - fix the start address of IO ports area in RTS7751R2D.

This patch replaces the start address in 'sh7751_io_resource'
in arch/sh/drivers/pci/ops-rts7751r2d.c. The value must be
used for any PCI IO port access such as in*()/out*().

I drew upon the following patch:

[PATCH] [RFC] Support PCI IO access of SH7780 base boards
http://www.spinics.net/lists/linux-sh/msg00006.html

Signed-off-by: Katsuya Matsubara <matsu@igel.co.jp>
---
 ops-rts7751r2d.c |    4 ++--
 pci-sh7751.c     |    9 ---------
 2 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/arch/sh/drivers/pci/ops-rts7751r2d.c b/arch/sh/drivers/pci/ops-rts7751r2d.c
index ec8430c..692bea4 100644
--- a/arch/sh/drivers/pci/ops-rts7751r2d.c
+++ b/arch/sh/drivers/pci/ops-rts7751r2d.c
@@ -32,8 +32,8 @@ int __init pcibios_map_platform_irq(struct pci_dev *pdev, u8 slot, u8 pin)
 
 static struct resource sh7751_io_resource = {
 	.name	= "SH7751_IO",
-	.start	= 0x4000,
-	.end	= 0x4000 + SH7751_PCI_IO_SIZE - 1,
+	.start	= SH7751_PCI_IO_BASE,
+	.end	= SH7751_PCI_IO_BASE + SH7751_PCI_IO_SIZE - 1,
 	.flags	= IORESOURCE_IO
 };
 
diff --git a/arch/sh/drivers/pci/pci-sh7751.c b/arch/sh/drivers/pci/pci-sh7751.c
index 1aca7fe..cd47dc6 100644
--- a/arch/sh/drivers/pci/pci-sh7751.c
+++ b/arch/sh/drivers/pci/pci-sh7751.c
@@ -147,15 +147,6 @@ int __init sh7751_pcic_init(struct sh4_pci_address_map *map)
 	pr_debug("PCI: Setting upper bits of Memory window to 0x%x\n", word);
 	pci_write_reg(word , SH4_PCIMBR);
 
-	/* Map IO space into PCI IO window
-	 * The IO window is 64K-PCIBIOS_MIN_IO in size
-	 * IO addresses will be translated to the
-	 * PCI IO window base address
-	 */
-	pr_debug("PCI: Mapping IO address 0x%x - 0x%x to base 0x%x\n",
-		 PCIBIOS_MIN_IO, (64 << 10),
-		 SH7751_PCI_IO_BASE + PCIBIOS_MIN_IO);
-
 	/* Make sure the MSB's of IO window are set to access PCI space
 	 * correctly */
 	word = PCIBIOS_MIN_IO & SH4_PCIIOBR_MASK;
