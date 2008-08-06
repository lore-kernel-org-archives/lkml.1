Return-Path: <linux-kernel-owner+w=401wt.eu-S1755406AbYHFNaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbYHFNaZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 09:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753670AbYHFNaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 09:30:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:48143 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111AbYHFNaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 09:30:06 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de
From: Karsten Keil <kkeil@suse.de>
Subject: [PATCH 1/3] Cleanup hfc multiport driver
Message-Id: <20080806133003.ABD63BC11C@pingi.kke.suse.de>
Date: Wed,  6 Aug 2008 15:30:03 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from git://git.kernel.org/pub/scm/linux/kernel/git/kkeil/ISDN-2.6.git master

Remove references to external zaptel modules and some
cosmetic cleanups.

Signed-off-by: Karsten Keil <kkeil@suse.de>
---
 drivers/isdn/hardware/mISDN/hfc_multi.h |    4 -
 drivers/isdn/hardware/mISDN/hfcmulti.c  |  109 +++++++------------------------
 2 files changed, 24 insertions(+), 89 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfc_multi.h b/drivers/isdn/hardware/mISDN/hfc_multi.h
index a33d87a..2667e10 100644
--- a/drivers/isdn/hardware/mISDN/hfc_multi.h
+++ b/drivers/isdn/hardware/mISDN/hfc_multi.h
@@ -2,10 +2,6 @@
  * see notice in hfc_multi.c
  */
 
-extern void ztdummy_extern_interrupt(void);
-extern void ztdummy_register_interrupt(void);
-extern int ztdummy_unregister_interrupt(void);
-
 #define DEBUG_HFCMULTI_FIFO	0x00010000
 #define	DEBUG_HFCMULTI_CRC	0x00020000
 #define	DEBUG_HFCMULTI_INIT	0x00040000
diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
index 1eac03f..bdf24ce 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -140,7 +140,7 @@
  * #define HFC_REGISTER_DEBUG
  */
 
-static const char *hfcmulti_revision = "2.02";
+#define HFC_MULTI_VERSION	"2.03"
 
 #include <linux/module.h>
 #include <linux/pci.h>
@@ -165,10 +165,6 @@ static LIST_HEAD(HFClist);
 static spinlock_t HFClock; /* global hfc list lock */
 
 static void ph_state_change(struct dchannel *);
-static void (*hfc_interrupt)(void);
-static void (*register_interrupt)(void);
-static int (*unregister_interrupt)(void);
-static int interrupt_registered;
 
 static struct hfc_multi *syncmaster;
 int plxsd_master; /* if we have a master card (yet) */
@@ -210,6 +206,7 @@ static int	HFC_cnt, Port_cnt, PCM_cnt = 99;
 
 MODULE_AUTHOR("Andreas Eversberg");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(HFC_MULTI_VERSION);
 module_param(debug, uint, S_IRUGO | S_IWUSR);
 module_param(poll, uint, S_IRUGO | S_IWUSR);
 module_param(timer, uint, S_IRUGO | S_IWUSR);
@@ -1417,19 +1414,6 @@ controller_fail:
 	HFC_outb(hc, R_TI_WD, poll_timer);
 	hc->hw.r_irqmsk_misc |= V_TI_IRQMSK;
 
-	/*
-	 * set up 125us interrupt, only if function pointer is available
-	 * and module parameter timer is set
-	 */
-	if (timer && hfc_interrupt && register_interrupt) {
-		/* only one chip should use this interrupt */
-		timer = 0;
-		interrupt_registered = 1;
-		hc->hw.r_irqmsk_misc |= V_PROC_IRQMSK;
-		/* deactivate other interrupts in ztdummy */
-		register_interrupt();
-	}
-
 	/* set E1 state machine IRQ */
 	if (hc->type == 1)
 		hc->hw.r_irqmsk_misc |= V_STA_IRQMSK;
@@ -2581,7 +2565,6 @@ hfcmulti_interrupt(int intno, void *dev_id)
 	static int iq1 = 0, iq2 = 0, iq3 = 0, iq4 = 0,
 	    iq5 = 0, iq6 = 0, iqcnt = 0;
 #endif
-	static int		count;
 	struct hfc_multi	*hc = dev_id;
 	struct dchannel		*dch;
 	u_char			r_irq_statech, status, r_irq_misc, r_irq_oview;
@@ -2695,16 +2678,11 @@ hfcmulti_interrupt(int intno, void *dev_id)
 			/* -> DTMF IRQ */
 			hfcmulti_dtmf(hc);
 		}
-		/* TODO: REPLACE !!!! 125 us Interrupts are not acceptable  */
 		if (r_irq_misc & V_IRQ_PROC) {
-			/* IRQ every 125us */
-			count++;
-			/* generate 1kHz signal */
-			if (count == 8) {
-				if (hfc_interrupt)
-					hfc_interrupt();
-				count = 0;
-			}
+			static int irq_proc_cnt;
+			if (!irq_proc_cnt++)
+				printk(KERN_WARNING "%s: got V_IRQ_PROC -"
+				    " this should not happen\n", __func__);
 		}
 
 	}
@@ -4942,9 +4920,7 @@ hfcmulti_init(struct pci_dev *pdev, const struct pci_device_id *ent)
 	switch (m->dip_type) {
 	case DIP_4S:
 		/*
-		 * get DIP Setting for beroNet 1S/2S/4S cards
-		 *  check if Port Jumper config matches
-		 * module param 'protocol'
+		 * Get DIP setting for beroNet 1S/2S/4S cards
 		 * DIP Setting: (collect GPIO 13/14/15 (R_GPIO_IN1) +
 		 * GPI 19/23 (R_GPI_IN2))
 		 */
@@ -4963,9 +4939,8 @@ hfcmulti_init(struct pci_dev *pdev, const struct pci_device_id *ent)
 		break;
 	case DIP_8S:
 		/*
-		 * get DIP Setting for beroNet 8S0+ cards
-		 *
-		 * enable PCI auxbridge function
+		 * Get DIP Setting for beroNet 8S0+ cards
+		 * Enable PCI auxbridge function
 		 */
 		HFC_outb(hc, R_BRG_PCM_CFG, 1 | V_PCM_CLK);
 		/* prepare access to auxport */
@@ -5134,8 +5109,7 @@ static struct pci_device_id hfmultipci_ids[] __devinitdata = {
 	{ PCI_VENDOR_ID_CCD, PCI_DEVICE_ID_CCD_HFC8S, PCI_VENDOR_ID_CCD,
 	PCI_DEVICE_ID_CCD_HFC8S, 0, 0, H(14)}, /* old Eval */
 	{ PCI_VENDOR_ID_CCD, PCI_DEVICE_ID_CCD_HFC8S, PCI_VENDOR_ID_CCD,
-	PCI_SUBDEVICE_ID_CCD_IOB8STR, 0, 0, H(15)},
-	    /* IOB8ST Recording */
+	PCI_SUBDEVICE_ID_CCD_IOB8STR, 0, 0, H(15)}, /* IOB8ST Recording */
 	{ PCI_VENDOR_ID_CCD, PCI_DEVICE_ID_CCD_HFC8S, PCI_VENDOR_ID_CCD,
 		PCI_SUBDEVICE_ID_CCD_IOB8ST, 0, 0, H(16)}, /* IOB8ST  */
 	{ PCI_VENDOR_ID_CCD, PCI_DEVICE_ID_CCD_HFC8S, PCI_VENDOR_ID_CCD,
@@ -5185,18 +5159,16 @@ hfcmulti_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct hm_map	*m = (struct hm_map *)ent->driver_data;
 	int		ret;
 
-	if (m == NULL) {
-		if (ent->vendor == PCI_VENDOR_ID_CCD)
-			if (ent->device == PCI_DEVICE_ID_CCD_HFC4S ||
-			    ent->device == PCI_DEVICE_ID_CCD_HFC8S ||
-			    ent->device == PCI_DEVICE_ID_CCD_HFCE1)
-				printk(KERN_ERR
-				    "unknown HFC multiport controller "
-				    "(vendor:%x device:%x subvendor:%x "
-				    "subdevice:%x) Please contact the "
-				    "driver maintainer for support.\n",
-				    ent->vendor, ent->device,
-				    ent->subvendor, ent->subdevice);
+	if (m == NULL && ent->vendor == PCI_VENDOR_ID_CCD && (
+	    ent->device == PCI_DEVICE_ID_CCD_HFC4S ||
+	    ent->device == PCI_DEVICE_ID_CCD_HFC8S ||
+	    ent->device == PCI_DEVICE_ID_CCD_HFCE1)) {
+		printk(KERN_ERR
+		    "Unknown HFC multiport controller (vendor:%x device:%x "
+		    "subvendor:%x subdevice:%x)\n", ent->vendor, ent->device,
+		    ent->subvendor, ent->subdevice);
+		printk(KERN_ERR
+		    "Please contact the driver maintainer for support.\n");
 		return -ENODEV;
 	}
 	ret = hfcmulti_init(pdev, ent);
@@ -5219,22 +5191,9 @@ HFCmulti_cleanup(void)
 {
 	struct hfc_multi *card, *next;
 
-	/* unload interrupt function symbol */
-	if (hfc_interrupt)
-		symbol_put(ztdummy_extern_interrupt);
-	if (register_interrupt)
-		symbol_put(ztdummy_register_interrupt);
-	if (unregister_interrupt) {
-		if (interrupt_registered) {
-			interrupt_registered = 0;
-			unregister_interrupt();
-		}
-		symbol_put(ztdummy_unregister_interrupt);
-	}
-
+	/* get rid of all devices of this driver */
 	list_for_each_entry_safe(card, next, &HFClist, list)
 		release_card(card);
-	/* get rid of all devices of this driver */
 	pci_unregister_driver(&hfcmultipci_driver);
 }
 
@@ -5243,8 +5202,10 @@ HFCmulti_init(void)
 {
 	int err;
 
+	printk(KERN_INFO "mISDN: HFC-multi driver %s\n", HFC_MULTI_VERSION);
+
 #ifdef IRQ_DEBUG
-	printk(KERN_ERR "%s: IRQ_DEBUG IS ENABLED!\n", __func__);
+	printk(KERN_DEBUG "%s: IRQ_DEBUG IS ENABLED!\n", __func__);
 #endif
 
 	spin_lock_init(&HFClock);
@@ -5253,22 +5214,11 @@ HFCmulti_init(void)
 	if (debug & DEBUG_HFCMULTI_INIT)
 		printk(KERN_DEBUG "%s: init entered\n", __func__);
 
-	hfc_interrupt = symbol_get(ztdummy_extern_interrupt);
-	register_interrupt = symbol_get(ztdummy_register_interrupt);
-	unregister_interrupt = symbol_get(ztdummy_unregister_interrupt);
-	printk(KERN_INFO "mISDN: HFC-multi driver %s\n",
-	    hfcmulti_revision);
-
 	switch (poll) {
 	case 0:
 		poll_timer = 6;
 		poll = 128;
 		break;
-		/*
-		 * wenn dieses break nochmal verschwindet,
-		 * gibt es heisse ohren :-)
-		 * "without the break you will get hot ears ???"
-		 */
 	case 8:
 		poll_timer = 2;
 		break;
@@ -5298,17 +5248,6 @@ HFCmulti_init(void)
 	err = pci_register_driver(&hfcmultipci_driver);
 	if (err < 0) {
 		printk(KERN_ERR "error registering pci driver: %x\n", err);
-		if (hfc_interrupt)
-			symbol_put(ztdummy_extern_interrupt);
-		if (register_interrupt)
-			symbol_put(ztdummy_register_interrupt);
-		if (unregister_interrupt) {
-			if (interrupt_registered) {
-				interrupt_registered = 0;
-				unregister_interrupt();
-			}
-			symbol_put(ztdummy_unregister_interrupt);
-		}
 		return err;
 	}
 	return 0;
-- 
1.5.6.4

