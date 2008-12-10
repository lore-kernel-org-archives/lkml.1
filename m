Return-Path: <linux-kernel-owner+w=401wt.eu-S1755522AbYLJQQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522AbYLJQQy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 11:16:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755858AbYLJQOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 11:14:00 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:58176 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755786AbYLJQN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 11:13:58 -0500
Message-ID: <493feac3.25e2660a.2824.6cb2@mx.google.com>
To: Karsten Keil <kkeil@suse.de>
Cc: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Date: Wed, 10 Dec 2008 16:43:30 +0100
Subject: [PATCH 9/9] mISDN: fix sparse warnings
From: Hannes Eder <hannes@hanneseder.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: make use of the __iomem address space modifier

Fix more than 30 sparse warnings of this or similar type:

  drivers/isdn/hardware/mISDN/hfcmulti.c:261:31: warning: incorrect type in argument 2 (different address spaces)
  drivers/isdn/hardware/mISDN/hfcmulti.c:261:31:    got unsigned char [usertype] *
  drivers/isdn/hardware/mISDN/hfcmulti.c:261:31:    expected void volatile [noderef] <asn:2>*addr

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/isdn/hardware/mISDN/hfc_multi.h |    4 +-
 drivers/isdn/hardware/mISDN/hfcmulti.c  |   42 +++++++++++++++++--------------
 2 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfc_multi.h b/drivers/isdn/hardware/mISDN/hfc_multi.h
index a33d87a..5ae25b6 100644
--- a/drivers/isdn/hardware/mISDN/hfc_multi.h
+++ b/drivers/isdn/hardware/mISDN/hfc_multi.h
@@ -162,8 +162,8 @@ struct hfc_multi {
 	void		(*write_fifo)(struct hfc_multi *hc, u_char *data,
 				int len);
 	u_long		pci_origmembase, plx_origmembase, dsp_origmembase;
-	u_char		*pci_membase; /* PCI memory (MUST BE BYTE POINTER) */
-	u_char		*plx_membase; /* PLX memory */
+	u_char __iomem	*pci_membase; /* PCI memory (MUST BE BYTE POINTER) */
+	u_char __iomem	*plx_membase; /* PLX memory */
 	u_char		*dsp_membase; /* DSP on PLX */
 	u_long		pci_iobase; /* PCI IO */
 	struct hfcm_hw	hw;	/* remember data of write-only-registers */
diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
index 2b0e5db..5b8d18d 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -890,7 +890,8 @@ static inline void
 hfcmulti_resync(struct hfc_multi *locked, struct hfc_multi *newmaster, int rm)
 {
 	struct hfc_multi *hc, *next, *pcmmaster = NULL;
-	u_int *plx_acc_32, pv;
+	u_int __iomem *plx_acc_32;
+	u_int pv;
 	u_long flags;
 
 	spin_lock_irqsave(&HFClock, flags);
@@ -918,7 +919,7 @@ hfcmulti_resync(struct hfc_multi *locked, struct hfc_multi *newmaster, int rm)
 	/* Disable sync of all cards */
 	list_for_each_entry_safe(hc, next, &HFClist, list) {
 		if (test_bit(HFC_CHIP_PLXSD, &hc->chip)) {
-			plx_acc_32 = (u_int *)(hc->plx_membase+PLX_GPIOC);
+			plx_acc_32 = (u_int __iomem *)(hc->plx_membase+PLX_GPIOC);
 			pv = readl(plx_acc_32);
 			pv &= ~PLX_SYNC_O_EN;
 			writel(pv, plx_acc_32);
@@ -940,7 +941,7 @@ hfcmulti_resync(struct hfc_multi *locked, struct hfc_multi *newmaster, int rm)
 			printk(KERN_DEBUG "id=%d (0x%p) = syncronized with "
 				"interface.\n", hc->id, hc);
 		/* Enable new sync master */
-		plx_acc_32 = (u_int *)(hc->plx_membase+PLX_GPIOC);
+		plx_acc_32 = (u_int __iomem *)(hc->plx_membase+PLX_GPIOC);
 		pv = readl(plx_acc_32);
 		pv |= PLX_SYNC_O_EN;
 		writel(pv, plx_acc_32);
@@ -970,7 +971,7 @@ hfcmulti_resync(struct hfc_multi *locked, struct hfc_multi *newmaster, int rm)
 					    "QUARTZ is automatically "
 					    "enabled by HFC-%dS\n", hc->type);
 			}
-			plx_acc_32 = (u_int *)(hc->plx_membase+PLX_GPIOC);
+			plx_acc_32 = (u_int __iomem *)(hc->plx_membase+PLX_GPIOC);
 			pv = readl(plx_acc_32);
 			pv |= PLX_SYNC_O_EN;
 			writel(pv, plx_acc_32);
@@ -1015,7 +1016,8 @@ plxsd_checksync(struct hfc_multi *hc, int rm)
 static void
 release_io_hfcmulti(struct hfc_multi *hc)
 {
-	u_int	*plx_acc_32, pv;
+	u_int __iomem *plx_acc_32;
+	u_int	pv;
 	u_long	plx_flags;
 
 	if (debug & DEBUG_HFCMULTI_INIT)
@@ -1035,7 +1037,7 @@ release_io_hfcmulti(struct hfc_multi *hc)
 			printk(KERN_DEBUG "%s: release PLXSD card %d\n",
 			    __func__, hc->id + 1);
 		spin_lock_irqsave(&plx_lock, plx_flags);
-		plx_acc_32 = (u_int *)(hc->plx_membase+PLX_GPIOC);
+		plx_acc_32 = (u_int __iomem *)(hc->plx_membase+PLX_GPIOC);
 		writel(PLX_GPIOC_INIT, plx_acc_32);
 		pv = readl(plx_acc_32);
 		/* Termination off */
@@ -1057,9 +1059,9 @@ release_io_hfcmulti(struct hfc_multi *hc)
 	test_and_clear_bit(HFC_CHIP_PLXSD, &hc->chip); /* prevent resync */
 	pci_write_config_word(hc->pci_dev, PCI_COMMAND, 0);
 	if (hc->pci_membase)
-		iounmap((void *)hc->pci_membase);
+		iounmap(hc->pci_membase);
 	if (hc->plx_membase)
-		iounmap((void *)hc->plx_membase);
+		iounmap(hc->plx_membase);
 	if (hc->pci_iobase)
 		release_region(hc->pci_iobase, 8);
 
@@ -1082,7 +1084,8 @@ init_chip(struct hfc_multi *hc)
 	u_long			flags, val, val2 = 0, rev;
 	int			i, err = 0;
 	u_char			r_conf_en, rval;
-	u_int			*plx_acc_32, pv;
+	u_int __iomem		*plx_acc_32;
+	u_int			pv;
 	u_long			plx_flags, hfc_flags;
 	int			plx_count;
 	struct hfc_multi	*pos, *next, *plx_last_hc;
@@ -1156,7 +1159,7 @@ init_chip(struct hfc_multi *hc)
 			printk(KERN_DEBUG "%s: initializing PLXSD card %d\n",
 			    __func__, hc->id + 1);
 		spin_lock_irqsave(&plx_lock, plx_flags);
-		plx_acc_32 = (u_int *)(hc->plx_membase+PLX_GPIOC);
+		plx_acc_32 = (u_int __iomem *)(hc->plx_membase+PLX_GPIOC);
 		writel(PLX_GPIOC_INIT, plx_acc_32);
 		pv = readl(plx_acc_32);
 		/* The first and the last cards are terminating the PCM bus */
@@ -1192,7 +1195,7 @@ init_chip(struct hfc_multi *hc)
 					"we disable termination\n",
 				    __func__, plx_last_hc->id + 1);
 			spin_lock_irqsave(&plx_lock, plx_flags);
-			plx_acc_32 = (u_int *)(plx_last_hc->plx_membase
+			plx_acc_32 = (u_int __iomem *)(plx_last_hc->plx_membase
 					+ PLX_GPIOC);
 			pv = readl(plx_acc_32);
 			pv &= ~PLX_TERM_ON;
@@ -1242,7 +1245,7 @@ init_chip(struct hfc_multi *hc)
 	/* Speech Design PLX bridge pcm and sync mode */
 	if (test_bit(HFC_CHIP_PLXSD, &hc->chip)) {
 		spin_lock_irqsave(&plx_lock, plx_flags);
-		plx_acc_32 = (u_int *)(hc->plx_membase+PLX_GPIOC);
+		plx_acc_32 = (u_int __iomem *)(hc->plx_membase+PLX_GPIOC);
 		pv = readl(plx_acc_32);
 		/* Connect PCM */
 		if (hc->hw.r_pcm_md0 & V_PCM_MD) {
@@ -1354,7 +1357,7 @@ controller_fail:
 			/* retry with master clock */
 			if (test_bit(HFC_CHIP_PLXSD, &hc->chip)) {
 				spin_lock_irqsave(&plx_lock, plx_flags);
-				plx_acc_32 = (u_int *)(hc->plx_membase +
+				plx_acc_32 = (u_int __iomem *)(hc->plx_membase +
 					PLX_GPIOC);
 				pv = readl(plx_acc_32);
 				pv |= PLX_MASTER_EN | PLX_SLAVE_EN_N;
@@ -1391,7 +1394,7 @@ controller_fail:
 		if (test_bit(HFC_CHIP_PCM_MASTER, &hc->chip))
 			plxsd_master = 1;
 		spin_lock_irqsave(&plx_lock, plx_flags);
-		plx_acc_32 = (u_int *)(hc->plx_membase+PLX_GPIOC);
+		plx_acc_32 = (u_int __iomem *)(hc->plx_membase+PLX_GPIOC);
 		pv = readl(plx_acc_32);
 		pv |=  PLX_DSP_RES_N;
 		writel(pv, plx_acc_32);
@@ -2588,7 +2591,8 @@ hfcmulti_interrupt(int intno, void *dev_id)
 	struct dchannel		*dch;
 	u_char			r_irq_statech, status, r_irq_misc, r_irq_oview;
 	int			i;
-	u_short			*plx_acc, wval;
+	u_short __iomem		*plx_acc;
+	u_short			wval;
 	u_char			e1_syncsta, temp;
 	u_long			flags;
 
@@ -2608,7 +2612,7 @@ hfcmulti_interrupt(int intno, void *dev_id)
 
 	if (test_bit(HFC_CHIP_PLXSD, &hc->chip)) {
 		spin_lock_irqsave(&plx_lock, flags);
-		plx_acc = (u_short *)(hc->plx_membase + PLX_INTCSR);
+		plx_acc = (u_short __iomem *)(hc->plx_membase + PLX_INTCSR);
 		wval = readw(plx_acc);
 		spin_unlock_irqrestore(&plx_lock, flags);
 		if (!(wval & PLX_INTCSR_LINTI1_STATUS))
@@ -4093,7 +4097,7 @@ init_card(struct hfc_multi *hc)
 {
 	int	err = -EIO;
 	u_long	flags;
-	u_short	*plx_acc;
+	u_short	__iomem *plx_acc;
 	u_long	plx_flags;
 
 	if (debug & DEBUG_HFCMULTI_INIT)
@@ -4115,7 +4119,7 @@ init_card(struct hfc_multi *hc)
 
 	if (test_bit(HFC_CHIP_PLXSD, &hc->chip)) {
 		spin_lock_irqsave(&plx_lock, plx_flags);
-		plx_acc = (u_short *)(hc->plx_membase+PLX_INTCSR);
+		plx_acc = (u_short __iomem *)(hc->plx_membase+PLX_INTCSR);
 		writew((PLX_INTCSR_PCIINT_ENABLE | PLX_INTCSR_LINTI1_ENABLE),
 			plx_acc); /* enable PCI & LINT1 irq */
 		spin_unlock_irqrestore(&plx_lock, plx_flags);
@@ -4164,7 +4168,7 @@ init_card(struct hfc_multi *hc)
 error:
 	if (test_bit(HFC_CHIP_PLXSD, &hc->chip)) {
 		spin_lock_irqsave(&plx_lock, plx_flags);
-		plx_acc = (u_short *)(hc->plx_membase+PLX_INTCSR);
+		plx_acc = (u_short __iomem *)(hc->plx_membase+PLX_INTCSR);
 		writew(0x00, plx_acc); /*disable IRQs*/
 		spin_unlock_irqrestore(&plx_lock, plx_flags);
 	}
-- 
1.5.6.3

