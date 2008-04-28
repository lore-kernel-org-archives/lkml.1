Return-Path: <linux-kernel-owner+w=401wt.eu-S1758583AbYD1GAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583AbYD1GAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 02:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765489AbYD1F7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 01:59:38 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43510 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763178AbYD1F7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 01:59:37 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] q40ide breakage
Cc: linux-kernel@vger.kernel.org, sfr@canb.auug.org.au, bzolnier@gmail.com
Message-Id: <E1JqMOl-0004mG-Vg@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Mon, 28 Apr 2008 06:59:35 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


again, fallout from ide merge

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/ide/legacy/q40ide.c |   47 ++++++++++++------------------------------
 1 files changed, 14 insertions(+), 33 deletions(-)

diff --git a/drivers/ide/legacy/q40ide.c b/drivers/ide/legacy/q40ide.c
index a3573d4..f921045 100644
--- a/drivers/ide/legacy/q40ide.c
+++ b/drivers/ide/legacy/q40ide.c
@@ -36,23 +36,6 @@ static const unsigned long pcide_bases[Q40IDE_NUM_HWIFS] = {
     PCIDE_BASE6 */
 };
 
-
-    /*
-     *  Offsets from one of the above bases
-     */
-
-/* used to do addr translation here but it is easier to do in setup ports */
-/*#define IDE_OFF_B(x)	((unsigned long)Q40_ISA_IO_B((IDE_##x##_OFFSET)))*/
-
-#define IDE_OFF_B(x)	((unsigned long)((IDE_##x##_OFFSET)))
-#define IDE_OFF_W(x)	((unsigned long)((IDE_##x##_OFFSET)))
-
-static const int pcide_offsets[IDE_NR_PORTS] = {
-    IDE_OFF_W(DATA), IDE_OFF_B(ERROR), IDE_OFF_B(NSECTOR), IDE_OFF_B(SECTOR),
-    IDE_OFF_B(LCYL), IDE_OFF_B(HCYL), 6 /*IDE_OFF_B(CURRENT)*/, IDE_OFF_B(STATUS),
-    518/*IDE_OFF(CMD)*/
-};
-
 static int q40ide_default_irq(unsigned long base)
 {
            switch (base) {
@@ -68,23 +51,22 @@ static int q40ide_default_irq(unsigned long base)
 /*
  * Addresses are pretranslated for Q40 ISA access.
  */
-void q40_ide_setup_ports ( hw_regs_t *hw,
-			unsigned long base, int *offsets,
-			unsigned long ctrl, unsigned long intr,
+static void q40_ide_setup_ports(hw_regs_t *hw, unsigned long base,
 			ide_ack_intr_t *ack_intr,
 			int irq)
 {
-	int i;
-
 	memset(hw, 0, sizeof(hw_regs_t));
-	for (i = 0; i < IDE_NR_PORTS; i++) {
-		/* BIG FAT WARNING: 
-		   assumption: only DATA port is ever used in 16 bit mode */
-		if (i == 0)
-			hw->io_ports_array[i] = Q40_ISA_IO_W(base + offsets[i]);
-		else
-			hw->io_ports_array[i] = Q40_ISA_IO_B(base + offsets[i]);
-	}
+	/* BIG FAT WARNING: 
+	   assumption: only DATA port is ever used in 16 bit mode */
+	hw->io_ports.data_addr = Q40_ISA_IO_W(base);
+	hw->io_ports.error_addr = Q40_ISA_IO_B(base + 1);
+	hw->io_ports.nsect_addr = Q40_ISA_IO_B(base + 2);
+	hw->io_ports.lbal_addr = Q40_ISA_IO_B(base + 3);
+	hw->io_ports.lbam_addr = Q40_ISA_IO_B(base + 4);
+	hw->io_ports.lbah_addr = Q40_ISA_IO_B(base + 5);
+	hw->io_ports.device_addr = Q40_ISA_IO_B(base + 6);
+	hw->io_ports.status_addr = Q40_ISA_IO_B(base + 7);
+	hw->io_ports.ctl_addr = Q40_ISA_IO_B(base + 0x206);
 
 	hw->irq = irq;
 	hw->ack_intr = ack_intr;
@@ -131,9 +113,8 @@ static int __init q40ide_init(void)
 		release_region(pcide_bases[i], 8);
 		continue;
 	}
-	q40_ide_setup_ports(&hw,(unsigned long) pcide_bases[i], (int *)pcide_offsets, 
-			pcide_bases[i]+0x206, 
-			0, NULL,
+	q40_ide_setup_ports(&hw, pcide_bases[i],
+			NULL,
 //			m68kide_iops,
 			q40ide_default_irq(pcide_bases[i]));
 
-- 
1.5.3.GIT


