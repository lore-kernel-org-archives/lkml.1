Return-Path: <linux-kernel-owner+w=401wt.eu-S1755190AbZESPAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbZESPAY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 11:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbZESPAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 11:00:13 -0400
Received: from d112a2.x-mailer.de ([212.162.53.4]:56840 "EHLO
	d112a2.x-mailer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbZESPAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 11:00:09 -0400
Message-Id: <81986b3e8ddbb4501dce5add2707d5dcec449a23.1242739648.git.kkeil@pingi.linux-pingi.de>
In-Reply-To: <cover.1242739648.git.kkeil@pingi.linux-pingi.de>
References: <cover.1242739648.git.kkeil@pingi.linux-pingi.de>
Subject: [PATCH 01/19] Add XHFC support for embedded Speech-Design board to hfcmulti
From: Karsten Keil <keil@b1-systems.de>
To: linux-kernel@vger.kernel.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       i4ldeveloper@listserv.isdn4linux.de
Date: Tue, 19 May 2009 15:58:22 +0200
X-Info: valid message
X-Info: original Date
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Eversberg <andreas@eversberg.eu>

Features like DTMF or hardware conference will not be available,
so I expanded DSP's feature flags.

Signed-off-by: Andreas Eversberg <andreas@eversberg.eu>
Signed-off-by: Karsten Keil <keil@b1-systems.de>
---
 drivers/isdn/hardware/mISDN/hfc_multi.h |   73 ++++-
 drivers/isdn/hardware/mISDN/hfcmulti.c  |  536 ++++++++++++++++++++++++-------
 drivers/isdn/mISDN/dsp_cmx.c            |    4 +
 include/linux/mISDNdsp.h                |    1 +
 4 files changed, 495 insertions(+), 119 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfc_multi.h b/drivers/isdn/hardware/mISDN/hfc_multi.h
index 663b77f..545b3f9 100644
--- a/drivers/isdn/hardware/mISDN/hfc_multi.h
+++ b/drivers/isdn/hardware/mISDN/hfc_multi.h
@@ -18,6 +18,46 @@
 #define	PCI_ENA_MEMIO	0x02
 
 /*
+ * Defines for the SDG embedded board using the XHFC-4SU chip
+ */
+#ifdef CONFIG_8xx
+#include <asm/8xx_immap.h>
+#else
+/*
+ * Dummy defines to make the compiler work for other architectures
+ */
+#define IMAP_ADDR	0xFFF00000
+
+struct io_port {
+	ushort	iop_padir;
+	ushort	iop_papar;
+	ushort	iop_paodr;
+	ushort	iop_padat;
+};
+
+struct comm_proc {
+	uint	cp_pbdir;
+	uint	cp_pbpar;
+	ushort	cp_pbodr;
+	uint	cp_pbdat;
+};
+
+struct immap {
+	struct io_port		im_ioport;
+	struct comm_proc	im_cpm;
+};
+#endif /* CONFIG_8xx */
+#define XHFC_IRQ	4		/* SIU_IRQ2 */
+#define XHFC_MEMBASE	0xFE000000
+#define XHFC_MEMSIZE    0x00001000
+#define XHFC_OFFSET	0x00001000
+#define PA_XHFC_A0	0x0020		/* PA10 */
+#define PB_XHFC_IRQ1	0x00000100	/* PB23 */
+#define PB_XHFC_IRQ2	0x00000200	/* PB22 */
+#define PB_XHFC_IRQ3	0x00000400	/* PB21 */
+#define PB_XHFC_IRQ4	0x00000800	/* PB20 */
+
+/*
  * NOTE: some registers are assigned multiple times due to different modes
  *       also registers are assigned differen for HFC-4s/8s and HFC-E1
  */
@@ -79,6 +119,11 @@ struct hfcm_hw {
 #define	HFC_CFG_CRC4		10 /* disable CRC-4 Multiframe mode, */
 					/* use double frame instead. */
 
+#define HFC_TYPE_E1		1 /* controller is HFC-E1 */
+#define HFC_TYPE_4S		4 /* controller is HFC-4S */
+#define HFC_TYPE_8S		8 /* controller is HFC-8S */
+#define HFC_TYPE_XHFC		5 /* controller is XHFC */
+
 #define	HFC_CHIP_EXRAM_128	0 /* external ram 128k */
 #define	HFC_CHIP_EXRAM_512	1 /* external ram 256k */
 #define	HFC_CHIP_REVISION0	2 /* old fifo handling */
@@ -86,19 +131,22 @@ struct hfcm_hw {
 #define	HFC_CHIP_PCM_MASTER	4 /* PCM is master */
 #define	HFC_CHIP_RX_SYNC	5 /* disable pll sync for pcm */
 #define	HFC_CHIP_DTMF		6 /* DTMF decoding is enabled */
-#define	HFC_CHIP_ULAW		7 /* ULAW mode */
-#define	HFC_CHIP_CLOCK2		8 /* double clock mode */
-#define	HFC_CHIP_E1CLOCK_GET	9 /* always get clock from E1 interface */
-#define	HFC_CHIP_E1CLOCK_PUT	10 /* always put clock from E1 interface */
-#define	HFC_CHIP_WATCHDOG	11 /* whether we should send signals */
+#define	HFC_CHIP_CONF		7 /* conference handling is enabled */
+#define	HFC_CHIP_ULAW		8 /* ULAW mode */
+#define	HFC_CHIP_CLOCK2		9 /* double clock mode */
+#define	HFC_CHIP_E1CLOCK_GET	10 /* always get clock from E1 interface */
+#define	HFC_CHIP_E1CLOCK_PUT	11 /* always put clock from E1 interface */
+#define	HFC_CHIP_WATCHDOG	12 /* whether we should send signals */
 					/* to the watchdog */
-#define	HFC_CHIP_B410P		12 /* whether we have a b410p with echocan in */
+#define	HFC_CHIP_B410P		13 /* whether we have a b410p with echocan in */
 					/* hw */
-#define	HFC_CHIP_PLXSD		13 /* whether we have a Speech-Design PLX */
+#define	HFC_CHIP_PLXSD		14 /* whether we have a Speech-Design PLX */
+#define	HFC_CHIP_EMBSD          15 /* whether we have a SD Embedded board */
 
 #define HFC_IO_MODE_PCIMEM	0x00 /* normal memory mapped IO */
 #define HFC_IO_MODE_REGIO	0x01 /* PCI io access */
 #define HFC_IO_MODE_PLXSD	0x02 /* access HFC via PLX9030 */
+#define HFC_IO_MODE_EMBSD	0x03 /* direct access */
 
 /* table entry in the PCI devices list */
 struct hm_map {
@@ -111,6 +159,7 @@ struct hm_map {
 	int opticalsupport;
 	int dip_type;
 	int io_mode;
+	int irq;
 };
 
 struct hfc_multi {
@@ -118,7 +167,7 @@ struct hfc_multi {
 	struct hm_map	*mtyp;
 	int		id;
 	int		pcm;	/* id of pcm bus */
-	int		type;
+	int		ctype;	/* controller type */
 	int		ports;
 
 	u_int		irq;	/* irq used by card */
@@ -158,10 +207,14 @@ struct hfc_multi {
 				int len);
 	void		(*write_fifo)(struct hfc_multi *hc, u_char *data,
 				int len);
-	u_long		pci_origmembase, plx_origmembase, dsp_origmembase;
+	u_long		pci_origmembase, plx_origmembase;
 	void __iomem	*pci_membase; /* PCI memory */
 	void __iomem	*plx_membase; /* PLX memory */
-	u_char		*dsp_membase; /* DSP on PLX */
+	u_long		xhfc_origmembase;
+	u_char		*xhfc_membase;
+	u_long		*xhfc_memaddr, *xhfc_memdata;
+	struct immap	*immap;
+	u_long		pb_irqmsk;	/* Portbit mask to check the IRQ line */
 	u_long		pci_iobase; /* PCI IO */
 	struct hfcm_hw	hw;	/* remember data of write-only-registers */
 
diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
index 0b28141..896fceb 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -139,6 +139,10 @@
  *	Selects interface with clock source for mISDN and applications.
  *	Set to card number starting with 1. Set to -1 to disable.
  *	By default, the first card is used as clock source.
+ *
+ * hwid:
+ *	NOTE: only one hwid value must be given once
+ * 	Enable special embedded devices with XHFC controllers.
  */
 
 /*
@@ -206,6 +210,11 @@ static int	clock;
 static uint	timer;
 static uint	clockdelay_te = CLKDEL_TE;
 static uint	clockdelay_nt = CLKDEL_NT;
+#define HWID_NONE	0
+#define HWID_MINIP4	1
+#define HWID_MINIP8	2
+#define HWID_MINIP16	3
+static uint	hwid = HWID_NONE;
 
 static int	HFC_cnt, Port_cnt, PCM_cnt = 99;
 
@@ -223,6 +232,7 @@ module_param_array(pcm, int, NULL, S_IRUGO | S_IWUSR);
 module_param_array(dslot, int, NULL, S_IRUGO | S_IWUSR);
 module_param_array(iomode, uint, NULL, S_IRUGO | S_IWUSR);
 module_param_array(port, uint, NULL, S_IRUGO | S_IWUSR);
+module_param(hwid, uint, S_IRUGO | S_IWUSR); /* The hardware ID */
 
 #ifdef HFC_REGISTER_DEBUG
 #define HFC_outb(hc, reg, val) \
@@ -252,6 +262,46 @@ module_param_array(port, uint, NULL, S_IRUGO | S_IWUSR);
 #define HFC_wait_nodebug(hc)		(hc->HFC_wait_nodebug(hc))
 #endif
 
+/* HFC_IO_MODE_EMBSD */
+static void
+#ifdef HFC_REGISTER_DEBUG
+HFC_outb_embsd(struct hfc_multi *hc, u_char reg, u_char val,
+		const char *function, int line)
+#else
+HFC_outb_embsd(struct hfc_multi *hc, u_char reg, u_char val)
+#endif
+{
+	hc->immap->im_ioport.iop_padat |= PA_XHFC_A0;
+	writeb(reg, hc->xhfc_memaddr);
+	hc->immap->im_ioport.iop_padat &= ~(PA_XHFC_A0);
+	writeb(val, hc->xhfc_memdata);
+}
+static u_char
+#ifdef HFC_REGISTER_DEBUG
+HFC_inb_embsd(struct hfc_multi *hc, u_char reg, const char *function, int line)
+#else
+HFC_inb_embsd(struct hfc_multi *hc, u_char reg)
+#endif
+{
+	hc->immap->im_ioport.iop_padat |= PA_XHFC_A0;
+	writeb(reg, hc->xhfc_memaddr);
+	hc->immap->im_ioport.iop_padat &= ~(PA_XHFC_A0);
+	return readb(hc->xhfc_memdata);
+}
+static void
+#ifdef HFC_REGISTER_DEBUG
+HFC_wait_embsd(struct hfc_multi *hc, const char *function, int line)
+#else
+HFC_wait_embsd(struct hfc_multi *hc)
+#endif
+{
+	hc->immap->im_ioport.iop_padat |= PA_XHFC_A0;
+	writeb(R_STATUS, hc->xhfc_memaddr);
+	hc->immap->im_ioport.iop_padat &= ~(PA_XHFC_A0);
+	while (readb(hc->xhfc_memdata) & V_BUSY)
+		cpu_relax();
+}
+
 /* HFC_IO_MODE_PCIMEM */
 static void
 #ifdef HFC_REGISTER_DEBUG
@@ -261,7 +311,7 @@ HFC_outb_pcimem(struct hfc_multi *hc, u_char reg, u_char val,
 HFC_outb_pcimem(struct hfc_multi *hc, u_char reg, u_char val)
 #endif
 {
-	writeb(val, (hc->pci_membase)+reg);
+	writeb(val, hc->pci_membase + reg);
 }
 static u_char
 #ifdef HFC_REGISTER_DEBUG
@@ -270,7 +320,7 @@ HFC_inb_pcimem(struct hfc_multi *hc, u_char reg, const char *function, int line)
 HFC_inb_pcimem(struct hfc_multi *hc, u_char reg)
 #endif
 {
-	return readb((hc->pci_membase)+reg);
+	return readb(hc->pci_membase + reg);
 }
 static u_short
 #ifdef HFC_REGISTER_DEBUG
@@ -279,7 +329,19 @@ HFC_inw_pcimem(struct hfc_multi *hc, u_char reg, const char *function, int line)
 HFC_inw_pcimem(struct hfc_multi *hc, u_char reg)
 #endif
 {
-	return readw((hc->pci_membase)+reg);
+	return readw(hc->pci_membase + reg);
+}
+static u_short
+#ifdef HFC_REGISTER_DEBUG
+HFC_inw_embsd(struct hfc_multi *hc, u_char reg, const char *function, int line)
+#else
+HFC_inw_embsd(struct hfc_multi *hc, u_char reg)
+#endif
+{
+	hc->immap->im_ioport.iop_padat |= PA_XHFC_A0;
+	writeb(reg, hc->xhfc_memaddr);
+	hc->immap->im_ioport.iop_padat &= ~(PA_XHFC_A0);
+	return readb(hc->xhfc_memdata);
 }
 static void
 #ifdef HFC_REGISTER_DEBUG
@@ -288,7 +350,8 @@ HFC_wait_pcimem(struct hfc_multi *hc, const char *function, int line)
 HFC_wait_pcimem(struct hfc_multi *hc)
 #endif
 {
-	while (readb((hc->pci_membase)+R_STATUS) & V_BUSY);
+	while (readb(hc->pci_membase + R_STATUS) & V_BUSY)
+		cpu_relax();
 }
 
 /* HFC_IO_MODE_REGIO */
@@ -300,7 +363,7 @@ HFC_outb_regio(struct hfc_multi *hc, u_char reg, u_char val,
 HFC_outb_regio(struct hfc_multi *hc, u_char reg, u_char val)
 #endif
 {
-	outb(reg, (hc->pci_iobase)+4);
+	outb(reg, hc->pci_iobase + 4);
 	outb(val, hc->pci_iobase);
 }
 static u_char
@@ -310,7 +373,7 @@ HFC_inb_regio(struct hfc_multi *hc, u_char reg, const char *function, int line)
 HFC_inb_regio(struct hfc_multi *hc, u_char reg)
 #endif
 {
-	outb(reg, (hc->pci_iobase)+4);
+	outb(reg, hc->pci_iobase + 4);
 	return inb(hc->pci_iobase);
 }
 static u_short
@@ -320,7 +383,7 @@ HFC_inw_regio(struct hfc_multi *hc, u_char reg, const char *function, int line)
 HFC_inw_regio(struct hfc_multi *hc, u_char reg)
 #endif
 {
-	outb(reg, (hc->pci_iobase)+4);
+	outb(reg, hc->pci_iobase + 4);
 	return inw(hc->pci_iobase);
 }
 static void
@@ -330,8 +393,9 @@ HFC_wait_regio(struct hfc_multi *hc, const char *function, int line)
 HFC_wait_regio(struct hfc_multi *hc)
 #endif
 {
-	outb(R_STATUS, (hc->pci_iobase)+4);
-	while (inb(hc->pci_iobase) & V_BUSY);
+	outb(R_STATUS, hc->pci_iobase + 4);
+	while (inb(hc->pci_iobase) & V_BUSY)
+		cpu_relax();
 }
 
 #ifdef HFC_REGISTER_DEBUG
@@ -467,6 +531,21 @@ write_fifo_pcimem(struct hfc_multi *hc, u_char *data, int len)
 		len--;
 	}
 }
+
+/* write fifo data (EMBSD) */
+void
+write_fifo_embsd(struct hfc_multi *hc, u_char *data, int len)
+{
+	hc->immap->im_ioport.iop_padat |= PA_XHFC_A0;
+	*hc->xhfc_memaddr = A_FIFO_DATA0;
+	hc->immap->im_ioport.iop_padat &= ~(PA_XHFC_A0);
+	while (len) {
+		*hc->xhfc_memdata = *data;
+		data++;
+		len--;
+	}
+}
+
 /* read fifo data (REGIO) */
 static void
 read_fifo_regio(struct hfc_multi *hc, u_char *data, int len)
@@ -512,6 +591,19 @@ read_fifo_pcimem(struct hfc_multi *hc, u_char *data, int len)
 	}
 }
 
+/* read fifo data (EMBSD) */
+void
+read_fifo_embsd(struct hfc_multi *hc, u_char *data, int len)
+{
+	hc->immap->im_ioport.iop_padat |= PA_XHFC_A0;
+	*hc->xhfc_memaddr = A_FIFO_DATA0;
+	hc->immap->im_ioport.iop_padat &= ~(PA_XHFC_A0);
+	while (len) {
+		*data = (u_char)(*hc->xhfc_memdata);
+		data++;
+		len--;
+	}
+}
 
 static void
 enable_hwirq(struct hfc_multi *hc)
@@ -928,7 +1020,7 @@ hfcmulti_resync(struct hfc_multi *locked, struct hfc_multi *newmaster, int rm)
 			writel(pv, plx_acc_32);
 			if (test_bit(HFC_CHIP_PCM_MASTER, &hc->chip)) {
 				pcmmaster = hc;
-				if (hc->type == 1) {
+				if (hc->ctype == HFC_TYPE_E1) {
 					if (debug & DEBUG_HFCMULTI_PLXSD)
 						printk(KERN_DEBUG
 							"Schedule SYNC_I\n");
@@ -949,7 +1041,8 @@ hfcmulti_resync(struct hfc_multi *locked, struct hfc_multi *newmaster, int rm)
 		pv |= PLX_SYNC_O_EN;
 		writel(pv, plx_acc_32);
 		/* switch to jatt PLL, if not disabled by RX_SYNC */
-		if (hc->type == 1 && !test_bit(HFC_CHIP_RX_SYNC, &hc->chip)) {
+		if (hc->ctype == HFC_TYPE_E1
+				&& !test_bit(HFC_CHIP_RX_SYNC, &hc->chip)) {
 			if (debug & DEBUG_HFCMULTI_PLXSD)
 				printk(KERN_DEBUG "Schedule jatt PLL\n");
 			hc->e1_resync |= 2; /* switch to jatt */
@@ -961,7 +1054,7 @@ hfcmulti_resync(struct hfc_multi *locked, struct hfc_multi *newmaster, int rm)
 				printk(KERN_DEBUG
 					"id=%d (0x%p) = PCM master syncronized "
 					"with QUARTZ\n", hc->id, hc);
-			if (hc->type == 1) {
+			if (hc->ctype == HFC_TYPE_E1) {
 				/* Use the crystal clock for the PCM
 				   master card */
 				if (debug & DEBUG_HFCMULTI_PLXSD)
@@ -972,7 +1065,7 @@ hfcmulti_resync(struct hfc_multi *locked, struct hfc_multi *newmaster, int rm)
 				if (debug & DEBUG_HFCMULTI_PLXSD)
 					printk(KERN_DEBUG
 					    "QUARTZ is automatically "
-					    "enabled by HFC-%dS\n", hc->type);
+					    "enabled by HFC-%dS\n", hc->ctype);
 			}
 			plx_acc_32 = hc->plx_membase + PLX_GPIOC;
 			pv = readl(plx_acc_32);
@@ -1060,13 +1153,16 @@ release_io_hfcmulti(struct hfc_multi *hc)
 
 	/* disable memory mapped ports / io ports */
 	test_and_clear_bit(HFC_CHIP_PLXSD, &hc->chip); /* prevent resync */
-	pci_write_config_word(hc->pci_dev, PCI_COMMAND, 0);
+	if (hc->pci_dev)
+		pci_write_config_word(hc->pci_dev, PCI_COMMAND, 0);
 	if (hc->pci_membase)
 		iounmap(hc->pci_membase);
 	if (hc->plx_membase)
 		iounmap(hc->plx_membase);
 	if (hc->pci_iobase)
 		release_region(hc->pci_iobase, 8);
+	if (hc->xhfc_membase)
+		iounmap((void *)hc->xhfc_membase);
 
 	if (hc->pci_dev) {
 		pci_disable_device(hc->pci_dev);
@@ -1100,8 +1196,9 @@ init_chip(struct hfc_multi *hc)
 	/* revision check */
 	if (debug & DEBUG_HFCMULTI_INIT)
 		printk(KERN_DEBUG "%s: entered\n", __func__);
-	val = HFC_inb(hc, R_CHIP_ID)>>4;
-	if (val != 0x8 && val != 0xc && val != 0xe) {
+	val = HFC_inb(hc, R_CHIP_ID);
+	if ((val>>4) != 0x8 && (val>>4) != 0xc && (val>>4) != 0xe
+			&& (val>>1) != 0x31) {
 		printk(KERN_INFO "HFC_multi: unknown CHIP_ID:%x\n", (u_int)val);
 		err = -EIO;
 		goto out;
@@ -1109,8 +1206,9 @@ init_chip(struct hfc_multi *hc)
 	rev = HFC_inb(hc, R_CHIP_RV);
 	printk(KERN_INFO
 	    "HFC_multi: detected HFC with chip ID=0x%lx revision=%ld%s\n",
-	    val, rev, (rev == 0) ? " (old FIFO handling)" : "");
-	if (rev == 0) {
+	    val, rev, (rev == 0 && (hc->ctype != HFC_TYPE_XHFC)) ?
+		" (old FIFO handling)" : "");
+	if (hc->ctype != HFC_TYPE_XHFC && rev == 0) {
 		test_and_set_bit(HFC_CHIP_REVISION0, &hc->chip);
 		printk(KERN_WARNING
 		    "HFC_multi: NOTE: Your chip is revision 0, "
@@ -1152,6 +1250,12 @@ init_chip(struct hfc_multi *hc)
 		hc->Zlen = 8000;
 		hc->DTMFbase = 0x2000;
 	}
+	if (hc->ctype == HFC_TYPE_XHFC) {
+		hc->Flen = 0x8;
+		hc->Zmin = 0x0;
+		hc->Zlen = 64;
+		hc->DTMFbase = 0x0;
+	}
 	hc->max_trans = poll << 1;
 	if (hc->max_trans > hc->Zlen)
 		hc->max_trans = hc->Zlen;
@@ -1211,6 +1315,9 @@ init_chip(struct hfc_multi *hc)
 		hc->hw.r_pcm_md0 = V_F0_LEN; /* shift clock for DSP */
 	}
 
+	if (test_bit(HFC_CHIP_EMBSD, &hc->chip))
+		hc->hw.r_pcm_md0 = V_F0_LEN; /* shift clock for DSP */
+
 	/* we only want the real Z2 read-pointer for revision > 0 */
 	if (!test_bit(HFC_CHIP_REVISION0, &hc->chip))
 		hc->hw.r_ram_sz |= V_FZ_MD;
@@ -1234,15 +1341,24 @@ init_chip(struct hfc_multi *hc)
 
 	/* soft reset */
 	HFC_outb(hc, R_CTRL, hc->hw.r_ctrl);
-	HFC_outb(hc, R_RAM_SZ, hc->hw.r_ram_sz);
+	if (hc->ctype == HFC_TYPE_XHFC)
+		HFC_outb(hc, 0x0C /* R_FIFO_THRES */,
+				0x11 /* 16 Bytes TX/RX */);
+	else
+		HFC_outb(hc, R_RAM_SZ, hc->hw.r_ram_sz);
 	HFC_outb(hc, R_FIFO_MD, 0);
-	hc->hw.r_cirm = V_SRES | V_HFCRES | V_PCMRES | V_STRES | V_RLD_EPR;
+	if (hc->ctype == HFC_TYPE_XHFC)
+		hc->hw.r_cirm = V_SRES | V_HFCRES | V_PCMRES | V_STRES;
+	else
+		hc->hw.r_cirm = V_SRES | V_HFCRES | V_PCMRES | V_STRES
+			| V_RLD_EPR;
 	HFC_outb(hc, R_CIRM, hc->hw.r_cirm);
 	udelay(100);
 	hc->hw.r_cirm = 0;
 	HFC_outb(hc, R_CIRM, hc->hw.r_cirm);
 	udelay(100);
-	HFC_outb(hc, R_RAM_SZ, hc->hw.r_ram_sz);
+	if (hc->ctype != HFC_TYPE_XHFC)
+		HFC_outb(hc, R_RAM_SZ, hc->hw.r_ram_sz);
 
 	/* Speech Design PLX bridge pcm and sync mode */
 	if (test_bit(HFC_CHIP_PLXSD, &hc->chip)) {
@@ -1278,13 +1394,16 @@ init_chip(struct hfc_multi *hc)
 	HFC_outb(hc, R_PCM_MD0, hc->hw.r_pcm_md0 | 0xa0);
 	if (test_bit(HFC_CHIP_PLXSD, &hc->chip))
 		HFC_outb(hc, R_PCM_MD2, V_SYNC_SRC); /* sync via SYNC_I / O */
+	else if (test_bit(HFC_CHIP_EMBSD, &hc->chip))
+		HFC_outb(hc, R_PCM_MD2, 0x10); /* V_C2O_EN */
 	else
 		HFC_outb(hc, R_PCM_MD2, 0x00); /* sync from interface */
 	HFC_outb(hc, R_PCM_MD0, hc->hw.r_pcm_md0 | 0x00);
 	for (i = 0; i < 256; i++) {
 		HFC_outb_nodebug(hc, R_SLOT, i);
 		HFC_outb_nodebug(hc, A_SL_CFG, 0);
-		HFC_outb_nodebug(hc, A_CONF, 0);
+		if (hc->ctype != HFC_TYPE_XHFC)
+			HFC_outb_nodebug(hc, A_CONF, 0);
 		hc->slot_owner[i] = -1;
 	}
 
@@ -1296,6 +1415,9 @@ init_chip(struct hfc_multi *hc)
 		HFC_outb(hc, R_BRG_PCM_CFG, V_PCM_CLK);
 	}
 
+	if (test_bit(HFC_CHIP_EMBSD, &hc->chip))
+		HFC_outb(hc, 0x02 /* R_CLK_CFG */, 0x40 /* V_CLKO_OFF */);
+
 	/* B410P GPIO */
 	if (test_bit(HFC_CHIP_B410P, &hc->chip)) {
 		printk(KERN_NOTICE "Setting GPIOs\n");
@@ -1424,7 +1546,7 @@ controller_fail:
 	hc->hw.r_irqmsk_misc |= V_TI_IRQMSK;
 
 	/* set E1 state machine IRQ */
-	if (hc->type == 1)
+	if (hc->ctype == HFC_TYPE_E1)
 		hc->hw.r_irqmsk_misc |= V_STA_IRQMSK;
 
 	/* set DTMF detection */
@@ -1444,7 +1566,8 @@ controller_fail:
 		r_conf_en = V_CONF_EN | V_ULAW;
 	else
 		r_conf_en = V_CONF_EN;
-	HFC_outb(hc, R_CONF_EN, r_conf_en);
+	if (hc->ctype != HFC_TYPE_XHFC)
+		HFC_outb(hc, R_CONF_EN, r_conf_en);
 
 	/* setting leds */
 	switch (hc->leds) {
@@ -1468,16 +1591,23 @@ controller_fail:
 		break;
 	}
 
+	if (test_bit(HFC_CHIP_EMBSD, &hc->chip)) {
+		hc->hw.r_st_sync = 0x10; /* V_AUTO_SYNCI */
+		HFC_outb(hc, R_ST_SYNC, hc->hw.r_st_sync);
+	}
+
 	/* set master clock */
 	if (hc->masterclk >= 0) {
 		if (debug & DEBUG_HFCMULTI_INIT)
 			printk(KERN_DEBUG "%s: setting ST master clock "
 			    "to port %d (0..%d)\n",
 			    __func__, hc->masterclk, hc->ports-1);
-		hc->hw.r_st_sync = hc->masterclk | V_AUTO_SYNC;
+		hc->hw.r_st_sync |= (hc->masterclk | V_AUTO_SYNC);
 		HFC_outb(hc, R_ST_SYNC, hc->hw.r_st_sync);
 	}
 
+
+
 	/* setting misc irq */
 	HFC_outb(hc, R_IRQMSK_MISC, hc->hw.r_irqmsk_misc);
 	if (debug & DEBUG_HFCMULTI_INIT)
@@ -1929,7 +2059,7 @@ next_frame:
 				Fspace = 1;
 		}
 		/* one frame only for ST D-channels, to allow resending */
-		if (hc->type != 1 && dch) {
+		if (hc->ctype != HFC_TYPE_E1 && dch) {
 			if (f1 != f2)
 				Fspace = 0;
 		}
@@ -1968,12 +2098,22 @@ next_frame:
 					    "slot_tx %d\n",
 					    __func__, ch, slot_tx);
 				/* connect slot */
-				HFC_outb(hc, A_CON_HDLC, 0xc0 | 0x00 |
-				    V_HDLC_TRP | V_IFF);
+				if (hc->ctype == HFC_TYPE_XHFC)
+					HFC_outb(hc, A_CON_HDLC, 0xc0
+					    | 0x07 << 2 | V_HDLC_TRP | V_IFF);
+						/* Enable FIFO, no interrupt */
+				else
+					HFC_outb(hc, A_CON_HDLC, 0xc0 | 0x00 |
+					    V_HDLC_TRP | V_IFF);
 				HFC_outb_nodebug(hc, R_FIFO, ch<<1 | 1);
 				HFC_wait_nodebug(hc);
-				HFC_outb(hc, A_CON_HDLC, 0xc0 | 0x00 |
-				    V_HDLC_TRP | V_IFF);
+				if (hc->ctype == HFC_TYPE_XHFC)
+					HFC_outb(hc, A_CON_HDLC, 0xc0
+					    | 0x07 << 2 | V_HDLC_TRP | V_IFF);
+						/* Enable FIFO, no interrupt */
+				else
+					HFC_outb(hc, A_CON_HDLC, 0xc0 | 0x00 |
+					    V_HDLC_TRP | V_IFF);
 				HFC_outb_nodebug(hc, R_FIFO, ch<<1);
 				HFC_wait_nodebug(hc);
 			}
@@ -2001,10 +2141,22 @@ next_frame:
 			    "FIFO data: channel %d slot_tx %d\n",
 			    __func__, ch, slot_tx);
 		/* disconnect slot */
-		HFC_outb(hc, A_CON_HDLC, 0x80 | 0x00 | V_HDLC_TRP | V_IFF);
+		if (hc->ctype == HFC_TYPE_XHFC)
+			HFC_outb(hc, A_CON_HDLC, 0x80
+			    | 0x07 << 2 | V_HDLC_TRP | V_IFF);
+				/* Enable FIFO, no interrupt */
+		else
+			HFC_outb(hc, A_CON_HDLC, 0x80 | 0x00 |
+			    V_HDLC_TRP | V_IFF);
 		HFC_outb_nodebug(hc, R_FIFO, ch<<1 | 1);
 		HFC_wait_nodebug(hc);
-		HFC_outb(hc, A_CON_HDLC, 0x80 | 0x00 | V_HDLC_TRP | V_IFF);
+		if (hc->ctype == HFC_TYPE_XHFC)
+			HFC_outb(hc, A_CON_HDLC, 0x80
+			    | 0x07 << 2 | V_HDLC_TRP | V_IFF);
+				/* Enable FIFO, no interrupt */
+		else
+			HFC_outb(hc, A_CON_HDLC, 0x80 | 0x00 |
+			    V_HDLC_TRP | V_IFF);
 		HFC_outb_nodebug(hc, R_FIFO, ch<<1);
 		HFC_wait_nodebug(hc);
 	}
@@ -2323,7 +2475,7 @@ handle_timer_irq(struct hfc_multi *hc)
 		spin_unlock_irqrestore(&HFClock, flags);
 	}
 
-	if (hc->type != 1 || hc->e1_state == 1)
+	if (hc->ctype != HFC_TYPE_E1 || hc->e1_state == 1)
 		for (ch = 0; ch <= 31; ch++) {
 			if (hc->created[hc->chan[ch].port]) {
 				hfcmulti_tx(hc, ch);
@@ -2346,7 +2498,7 @@ handle_timer_irq(struct hfc_multi *hc)
 				}
 			}
 		}
-	if (hc->type == 1 && hc->created[0]) {
+	if (hc->ctype == HFC_TYPE_E1 && hc->created[0]) {
 		dch = hc->chan[hc->dslot].dch;
 		if (test_bit(HFC_CFG_REPORT_LOS, &hc->chan[hc->dslot].cfg)) {
 			/* LOS */
@@ -2607,6 +2759,11 @@ hfcmulti_interrupt(int intno, void *dev_id)
 	irqsem = hc->id + 1;
 #endif
 
+	if (test_bit(HFC_CHIP_EMBSD, &hc->chip)) {
+		if (hc->immap->im_cpm.cp_pbdat & hc->pb_irqmsk)
+			goto irq_notforus;
+	}
+
 	if (test_bit(HFC_CHIP_PLXSD, &hc->chip)) {
 		spin_lock_irqsave(&plx_lock, flags);
 		plx_acc = hc->plx_membase + PLX_INTCSR;
@@ -2646,7 +2803,7 @@ hfcmulti_interrupt(int intno, void *dev_id)
 	}
 	hc->irqcnt++;
 	if (r_irq_statech) {
-		if (hc->type != 1)
+		if (hc->ctype != HFC_TYPE_E1)
 			ph_state_irq(hc, r_irq_statech);
 	}
 	if (status & V_EXT_IRQSTA)
@@ -2660,7 +2817,7 @@ hfcmulti_interrupt(int intno, void *dev_id)
 		r_irq_misc = HFC_inb_nodebug(hc, R_IRQ_MISC);
 		r_irq_misc &= hc->hw.r_irqmsk_misc; /* ignore disabled irqs */
 		if (r_irq_misc & V_STA_IRQ) {
-			if (hc->type == 1) {
+			if (hc->ctype == HFC_TYPE_E1) {
 				/* state machine */
 				dch = hc->chan[hc->dslot].dch;
 				e1_syncsta = HFC_inb_nodebug(hc, R_SYNC_STA);
@@ -2699,9 +2856,9 @@ hfcmulti_interrupt(int intno, void *dev_id)
 			handle_timer_irq(hc);
 		}
 
-		if (r_irq_misc & V_DTMF_IRQ) {
+		if (r_irq_misc & V_DTMF_IRQ)
 			hfcmulti_dtmf(hc);
-		}
+
 		if (r_irq_misc & V_IRQ_PROC) {
 			static int irq_proc_cnt;
 			if (!irq_proc_cnt++)
@@ -2782,7 +2939,8 @@ mode_hfcmulti(struct hfc_multi *hc, int ch, int protocol, int slot_tx,
 		if (hc->slot_owner[oslot_tx<<1] == ch) {
 			HFC_outb(hc, R_SLOT, oslot_tx << 1);
 			HFC_outb(hc, A_SL_CFG, 0);
-			HFC_outb(hc, A_CONF, 0);
+			if (hc->ctype != HFC_TYPE_XHFC)
+				HFC_outb(hc, A_CONF, 0);
 			hc->slot_owner[oslot_tx<<1] = -1;
 		} else {
 			if (debug & DEBUG_HFCMULTI_MODE)
@@ -2835,7 +2993,9 @@ mode_hfcmulti(struct hfc_multi *hc, int ch, int protocol, int slot_tx,
 			    flow_tx, routing, conf);
 		HFC_outb(hc, R_SLOT, slot_tx << 1);
 		HFC_outb(hc, A_SL_CFG, (ch<<1) | routing);
-		HFC_outb(hc, A_CONF, (conf < 0) ? 0 : (conf | V_CONF_SL));
+		if (hc->ctype != HFC_TYPE_XHFC)
+			HFC_outb(hc, A_CONF,
+				(conf < 0) ? 0 : (conf | V_CONF_SL));
 		hc->slot_owner[slot_tx << 1] = ch;
 		hc->chan[ch].slot_tx = slot_tx;
 		hc->chan[ch].bank_tx = bank_tx;
@@ -2885,7 +3045,7 @@ mode_hfcmulti(struct hfc_multi *hc, int ch, int protocol, int slot_tx,
 		HFC_outb(hc, A_IRQ_MSK, 0);
 		HFC_outb(hc, R_INC_RES_FIFO, V_RES_F);
 		HFC_wait(hc);
-		if (hc->chan[ch].bch && hc->type != 1) {
+		if (hc->chan[ch].bch && hc->ctype != HFC_TYPE_E1) {
 			hc->hw.a_st_ctrl0[hc->chan[ch].port] &=
 			    ((ch & 0x3) == 0)? ~V_B1_EN: ~V_B2_EN;
 			HFC_outb(hc, R_ST_SEL, hc->chan[ch].port);
@@ -2961,8 +3121,13 @@ mode_hfcmulti(struct hfc_multi *hc, int ch, int protocol, int slot_tx,
 			/* enable TX fifo */
 			HFC_outb(hc, R_FIFO, ch << 1);
 			HFC_wait(hc);
-			HFC_outb(hc, A_CON_HDLC, flow_tx | 0x00 |
-			    V_HDLC_TRP | V_IFF);
+			if (hc->ctype == HFC_TYPE_XHFC)
+				HFC_outb(hc, A_CON_HDLC, flow_tx | 0x07 << 2 |
+					V_HDLC_TRP | V_IFF);
+					/* Enable FIFO, no interrupt */
+			else
+				HFC_outb(hc, A_CON_HDLC, flow_tx | 0x00 |
+					V_HDLC_TRP | V_IFF);
 			HFC_outb(hc, A_SUBCH_CFG, 0);
 			HFC_outb(hc, A_IRQ_MSK, 0);
 			HFC_outb(hc, R_INC_RES_FIFO, V_RES_F);
@@ -2972,13 +3137,19 @@ mode_hfcmulti(struct hfc_multi *hc, int ch, int protocol, int slot_tx,
 			/* enable RX fifo */
 			HFC_outb(hc, R_FIFO, (ch<<1)|1);
 			HFC_wait(hc);
-			HFC_outb(hc, A_CON_HDLC, flow_rx | 0x00 | V_HDLC_TRP);
+			if (hc->ctype == HFC_TYPE_XHFC)
+				HFC_outb(hc, A_CON_HDLC, flow_rx | 0x07 << 2 |
+					V_HDLC_TRP);
+					/* Enable FIFO, no interrupt*/
+			else
+				HFC_outb(hc, A_CON_HDLC, flow_rx | 0x00 |
+						V_HDLC_TRP);
 			HFC_outb(hc, A_SUBCH_CFG, 0);
 			HFC_outb(hc, A_IRQ_MSK, 0);
 			HFC_outb(hc, R_INC_RES_FIFO, V_RES_F);
 			HFC_wait(hc);
 		}
-		if (hc->type != 1) {
+		if (hc->ctype != HFC_TYPE_E1) {
 			hc->hw.a_st_ctrl0[hc->chan[ch].port] |=
 			    ((ch & 0x3) == 0) ? V_B1_EN : V_B2_EN;
 			HFC_outb(hc, R_ST_SEL, hc->chan[ch].port);
@@ -2999,7 +3170,7 @@ mode_hfcmulti(struct hfc_multi *hc, int ch, int protocol, int slot_tx,
 		/* enable TX fifo */
 		HFC_outb(hc, R_FIFO, ch<<1);
 		HFC_wait(hc);
-		if (hc->type == 1 || hc->chan[ch].bch) {
+		if (hc->ctype == HFC_TYPE_E1 || hc->chan[ch].bch) {
 			/* E1 or B-channel */
 			HFC_outb(hc, A_CON_HDLC, flow_tx | 0x04);
 			HFC_outb(hc, A_SUBCH_CFG, 0);
@@ -3015,7 +3186,7 @@ mode_hfcmulti(struct hfc_multi *hc, int ch, int protocol, int slot_tx,
 		HFC_outb(hc, R_FIFO, (ch<<1)|1);
 		HFC_wait(hc);
 		HFC_outb(hc, A_CON_HDLC, flow_rx | 0x04);
-		if (hc->type == 1 || hc->chan[ch].bch)
+		if (hc->ctype == HFC_TYPE_E1 || hc->chan[ch].bch)
 			HFC_outb(hc, A_SUBCH_CFG, 0); /* full 8 bits */
 		else
 			HFC_outb(hc, A_SUBCH_CFG, 2); /* 2 bits dchannel */
@@ -3024,7 +3195,7 @@ mode_hfcmulti(struct hfc_multi *hc, int ch, int protocol, int slot_tx,
 		HFC_wait(hc);
 		if (hc->chan[ch].bch) {
 			test_and_set_bit(FLG_HDLC, &hc->chan[ch].bch->Flags);
-			if (hc->type != 1) {
+			if (hc->ctype != HFC_TYPE_E1) {
 				hc->hw.a_st_ctrl0[hc->chan[ch].port] |=
 				  ((ch&0x3) == 0) ? V_B1_EN : V_B2_EN;
 				HFC_outb(hc, R_ST_SEL, hc->chan[ch].port);
@@ -3104,7 +3275,7 @@ hfcm_l1callback(struct dchannel *dch, u_int cmd)
 	case HW_RESET_REQ:
 		/* start activation */
 		spin_lock_irqsave(&hc->lock, flags);
-		if (hc->type == 1) {
+		if (hc->ctype == HFC_TYPE_E1) {
 			if (debug & DEBUG_HFCMULTI_MSG)
 				printk(KERN_DEBUG
 				    "%s: HW_RESET_REQ no BRI\n",
@@ -3125,7 +3296,7 @@ hfcm_l1callback(struct dchannel *dch, u_int cmd)
 	case HW_DEACT_REQ:
 		/* start deactivation */
 		spin_lock_irqsave(&hc->lock, flags);
-		if (hc->type == 1) {
+		if (hc->ctype == HFC_TYPE_E1) {
 			if (debug & DEBUG_HFCMULTI_MSG)
 				printk(KERN_DEBUG
 				    "%s: HW_DEACT_REQ no BRI\n",
@@ -3159,7 +3330,7 @@ hfcm_l1callback(struct dchannel *dch, u_int cmd)
 		break;
 	case HW_POWERUP_REQ:
 		spin_lock_irqsave(&hc->lock, flags);
-		if (hc->type == 1) {
+		if (hc->ctype == HFC_TYPE_E1) {
 			if (debug & DEBUG_HFCMULTI_MSG)
 				printk(KERN_DEBUG
 				    "%s: HW_POWERUP_REQ no BRI\n",
@@ -3236,7 +3407,7 @@ handle_dmsg(struct mISDNchannel *ch, struct sk_buff *skb)
 				    __func__, hc->chan[dch->slot].port,
 				    hc->ports-1);
 			/* start activation */
-			if (hc->type == 1) {
+			if (hc->ctype == HFC_TYPE_E1) {
 				ph_state_change(dch);
 				if (debug & DEBUG_HFCMULTI_STATE)
 					printk(KERN_DEBUG
@@ -3269,7 +3440,7 @@ handle_dmsg(struct mISDNchannel *ch, struct sk_buff *skb)
 				    __func__, hc->chan[dch->slot].port,
 				    hc->ports-1);
 			/* start deactivation */
-			if (hc->type == 1) {
+			if (hc->ctype == HFC_TYPE_E1) {
 				if (debug & DEBUG_HFCMULTI_MSG)
 					printk(KERN_DEBUG
 					    "%s: PH_DEACTIVATE no BRI\n",
@@ -3489,6 +3660,8 @@ channel_bctrl(struct bchannel *bch, struct mISDN_ctrl_req *cq)
 		features->hfc_id = hc->id;
 		if (test_bit(HFC_CHIP_DTMF, &hc->chip))
 			features->hfc_dtmf = 1;
+		if (test_bit(HFC_CHIP_CONF, &hc->chip))
+			features->hfc_conf = 1;
 		features->hfc_loops = 0;
 		if (test_bit(HFC_CHIP_B410P, &hc->chip)) {
 			features->hfc_echocanhw = 1;
@@ -3626,7 +3799,7 @@ ph_state_change(struct dchannel *dch)
 	hc = dch->hw;
 	ch = dch->slot;
 
-	if (hc->type == 1) {
+	if (hc->ctype == HFC_TYPE_E1) {
 		if (dch->dev.D.protocol == ISDN_P_TE_E1) {
 			if (debug & DEBUG_HFCMULTI_STATE)
 				printk(KERN_DEBUG
@@ -3751,7 +3924,7 @@ hfcmulti_initmode(struct dchannel *dch)
 	if (debug & DEBUG_HFCMULTI_INIT)
 		printk(KERN_DEBUG "%s: entered\n", __func__);
 
-	if (hc->type == 1) {
+	if (hc->ctype == HFC_TYPE_E1) {
 		hc->chan[hc->dslot].slot_tx = -1;
 		hc->chan[hc->dslot].slot_rx = -1;
 		hc->chan[hc->dslot].conf = -1;
@@ -3900,6 +4073,11 @@ hfcmulti_initmode(struct dchannel *dch)
 		}
 		if (!test_bit(HFC_CFG_NONCAP_TX, &hc->chan[i].cfg))
 			hc->hw.a_st_ctrl0[pt] |= V_TX_LI;
+		if (hc->ctype == HFC_TYPE_XHFC) {
+			hc->hw.a_st_ctrl0[pt] |= 0x40 /* V_ST_PU_CTRL */;
+			HFC_outb(hc, 0x35 /* A_ST_CTRL3 */,
+				0x7c << 1 /* V_ST_PULSE */);
+		}
 		/* line setup */
 		HFC_outb(hc, A_ST_CTRL0,  hc->hw.a_st_ctrl0[pt]);
 		/* disable E-channel */
@@ -3986,7 +4164,7 @@ open_bchannel(struct hfc_multi *hc, struct dchannel *dch,
 		return -EINVAL;
 	if (rq->protocol == ISDN_P_NONE)
 		return -EINVAL;
-	if (hc->type == 1)
+	if (hc->ctype == HFC_TYPE_E1)
 		ch = rq->adr.channel;
 	else
 		ch = (rq->adr.channel - 1) + (dch->slot - 2);
@@ -4047,7 +4225,7 @@ hfcm_dctrl(struct mISDNchannel *ch, u_int cmd, void *arg)
 		switch (rq->protocol) {
 		case ISDN_P_TE_S0:
 		case ISDN_P_NT_S0:
-			if (hc->type == 1) {
+			if (hc->ctype == HFC_TYPE_E1) {
 				err = -EINVAL;
 				break;
 			}
@@ -4055,7 +4233,7 @@ hfcm_dctrl(struct mISDNchannel *ch, u_int cmd, void *arg)
 			break;
 		case ISDN_P_TE_E1:
 		case ISDN_P_NT_E1:
-			if (hc->type != 1) {
+			if (hc->ctype != HFC_TYPE_E1) {
 				err = -EINVAL;
 				break;
 			}
@@ -4122,13 +4300,13 @@ init_card(struct hfc_multi *hc)
 	disable_hwirq(hc);
 	spin_unlock_irqrestore(&hc->lock, flags);
 
-	if (request_irq(hc->pci_dev->irq, hfcmulti_interrupt, IRQF_SHARED,
+	if (request_irq(hc->irq, hfcmulti_interrupt, IRQF_SHARED,
 	    "HFC-multi", hc)) {
 		printk(KERN_WARNING "mISDN: Could not get interrupt %d.\n",
-		    hc->pci_dev->irq);
+		    hc->irq);
+		hc->irq = 0;
 		return -EIO;
 	}
-	hc->irq = hc->pci_dev->irq;
 
 	if (test_bit(HFC_CHIP_PLXSD, &hc->chip)) {
 		spin_lock_irqsave(&plx_lock, plx_flags);
@@ -4198,6 +4376,95 @@ error:
 	return err;
 }
 
+static int
+setup_embedded(struct hfc_multi *hc, struct hm_map *m)
+{
+	printk(KERN_INFO
+	    "HFC-multi: card manufacturer: '%s' card name: '%s' clock: %s\n",
+	    m->vendor_name, m->card_name, m->clock2 ? "double" : "normal");
+
+	hc->pci_dev = NULL;
+	if (m->clock2)
+		test_and_set_bit(HFC_CHIP_CLOCK2, &hc->chip);
+
+	hc->leds = m->leds;
+	hc->ledstate = 0xAFFEAFFE;
+	hc->opticalsupport = m->opticalsupport;
+
+	/* set memory access methods */
+	if (m->io_mode) /* use mode from card config */
+		hc->io_mode = m->io_mode;
+	switch (hc->io_mode) {
+	case HFC_IO_MODE_EMBSD:
+		test_and_set_bit(HFC_CHIP_EMBSD, &hc->chip);
+		hc->slots = 128; /* required */
+		/* fall through */
+		hc->HFC_outb = HFC_outb_embsd;
+		hc->HFC_inb = HFC_inb_embsd;
+		hc->HFC_inw = HFC_inw_embsd;
+		hc->HFC_wait = HFC_wait_embsd;
+		hc->read_fifo = read_fifo_embsd;
+		hc->write_fifo = write_fifo_embsd;
+		break;
+	default:
+		printk(KERN_WARNING "HFC-multi: Invalid IO mode.\n");
+		return -EIO;
+	}
+	hc->HFC_outb_nodebug = hc->HFC_outb;
+	hc->HFC_inb_nodebug = hc->HFC_inb;
+	hc->HFC_inw_nodebug = hc->HFC_inw;
+	hc->HFC_wait_nodebug = hc->HFC_wait;
+#ifdef HFC_REGISTER_DEBUG
+	hc->HFC_outb = HFC_outb_debug;
+	hc->HFC_inb = HFC_inb_debug;
+	hc->HFC_inw = HFC_inw_debug;
+	hc->HFC_wait = HFC_wait_debug;
+#endif
+	hc->pci_iobase = 0;
+	hc->pci_membase = NULL;
+	hc->plx_membase = NULL;
+	hc->xhfc_membase = NULL;
+	hc->xhfc_memaddr = NULL;
+	hc->xhfc_memdata = NULL;
+
+	switch (hc->io_mode) {
+	case HFC_IO_MODE_EMBSD:
+		hc->xhfc_origmembase = XHFC_MEMBASE + XHFC_OFFSET * hc->id;
+		hc->xhfc_membase = (u_char *)ioremap(hc->xhfc_origmembase,
+				XHFC_MEMSIZE);
+		if (!hc->xhfc_membase) {
+			printk(KERN_WARNING
+			    "HFC-multi: failed to remap xhfc address space. "
+			    "(internal error)\n");
+			return -EIO;
+		}
+		hc->xhfc_memaddr = (u_long *)(hc->xhfc_membase + 4);
+		hc->xhfc_memdata = (u_long *)(hc->xhfc_membase);
+		printk(KERN_INFO
+		    "HFC-multi: xhfc_membase:%#lx xhfc_origmembase:%#lx "
+		    "xhfc_memaddr:%#lx xhfc_memdata:%#lx\n",
+		    (u_long)hc->xhfc_membase, hc->xhfc_origmembase,
+		    (u_long)hc->xhfc_memaddr, (u_long)hc->xhfc_memdata);
+		break;
+	}
+
+	/* Prepare the MPC8XX PortA 10 as output (address/data selector) */
+	hc->immap = (struct immap *)(IMAP_ADDR);
+	hc->immap->im_ioport.iop_papar &= ~(PA_XHFC_A0);
+	hc->immap->im_ioport.iop_paodr &= ~(PA_XHFC_A0);
+	hc->immap->im_ioport.iop_padir |=   PA_XHFC_A0;
+
+	/* Prepare the MPC8xx PortB __X__ as input (ISDN__X__IRQ) */
+	hc->pb_irqmsk = (PB_XHFC_IRQ1 << hc->id);
+	hc->immap->im_cpm.cp_pbpar &= ~(hc->pb_irqmsk);
+	hc->immap->im_cpm.cp_pbodr &= ~(hc->pb_irqmsk);
+	hc->immap->im_cpm.cp_pbdir &= ~(hc->pb_irqmsk);
+
+	/* At this point the needed config is done */
+	/* fifos are still not enabled */
+	return 0;
+}
+
 /*
  * find pci device and set it up
  */
@@ -4343,8 +4610,8 @@ setup_pci(struct hfc_multi *hc, struct pci_dev *pdev,
 			pci_disable_device(hc->pci_dev);
 			return -EIO;
 		}
-		printk(KERN_INFO "card %d: defined at MEMBASE %#lx (%#lx) IRQ %d "
-		    "HZ %d leds-type %d\n", hc->id, (u_long)hc->pci_membase,
+		printk(KERN_INFO "card %d: defined at MEMBASE %#lx (%#lx) IRQ "
+		    "%d HZ %d leds-type %d\n", hc->id, (u_long)hc->pci_membase,
 		    hc->pci_origmembase, hc->pci_dev->irq, HZ, hc->leds);
 		pci_write_config_word(hc->pci_dev, PCI_COMMAND, PCI_ENA_MEMIO);
 		break;
@@ -4430,7 +4697,7 @@ release_port(struct hfc_multi *hc, struct dchannel *dch)
 		dch->timer.function = NULL;
 	}
 
-	if (hc->type == 1) { /* E1 */
+	if (hc->ctype == HFC_TYPE_E1) { /* E1 */
 		/* remove sync */
 		if (test_bit(HFC_CHIP_PLXSD, &hc->chip)) {
 			hc->syncronized = 0;
@@ -4829,8 +5096,12 @@ init_multi_port(struct hfc_multi *hc, int pt)
 		test_and_set_bit(HFC_CFG_DIS_ECHANNEL,
 		    &hc->chan[i + 2].cfg);
 	}
-	snprintf(name, MISDN_MAX_IDLEN - 1, "hfc-%ds.%d-%d",
-		hc->type, HFC_cnt + 1, pt + 1);
+	if (hc->ctype == HFC_TYPE_XHFC)
+		snprintf(name, MISDN_MAX_IDLEN - 1, "xhfc.%d-%d",
+			HFC_cnt + 1, pt + 1);
+	else
+		snprintf(name, MISDN_MAX_IDLEN - 1, "hfc-%ds.%d-%d",
+			hc->ctype, HFC_cnt + 1, pt + 1);
 	ret = mISDN_register_device(&dch->dev, &hc->pci_dev->dev, name);
 	if (ret)
 		goto free_chan;
@@ -4842,9 +5113,9 @@ free_chan:
 }
 
 static int
-hfcmulti_init(struct pci_dev *pdev, const struct pci_device_id *ent)
+hfcmulti_init(struct hm_map *m, struct pci_dev *pdev,
+    const struct pci_device_id *ent)
 {
-	struct hm_map	*m = (struct hm_map *)ent->driver_data;
 	int		ret_err = 0;
 	int		pt;
 	struct hfc_multi	*hc;
@@ -4879,16 +5150,18 @@ hfcmulti_init(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 	spin_lock_init(&hc->lock);
 	hc->mtyp = m;
-	hc->type =  m->type;
+	hc->ctype =  m->type;
 	hc->ports = m->ports;
 	hc->id = HFC_cnt;
 	hc->pcm = pcm[HFC_cnt];
 	hc->io_mode = iomode[HFC_cnt];
-	if (dslot[HFC_cnt] < 0 && hc->type == 1) {
+	if (dslot[HFC_cnt] < 0 && hc->ctype == HFC_TYPE_E1) {
 		hc->dslot = 0;
 		printk(KERN_INFO "HFC-E1 card has disabled D-channel, but "
 			"31 B-channels\n");
-	} if (dslot[HFC_cnt] > 0 && dslot[HFC_cnt] < 32 && hc->type == 1) {
+	}
+	if (dslot[HFC_cnt] > 0 && dslot[HFC_cnt] < 32
+	    && hc->ctype == HFC_TYPE_E1) {
 		hc->dslot = dslot[HFC_cnt];
 		printk(KERN_INFO "HFC-E1 card has alternating D-channel on "
 			"time slot %d\n", dslot[HFC_cnt]);
@@ -4910,8 +5183,11 @@ hfcmulti_init(struct pci_dev *pdev, const struct pci_device_id *ent)
 	for (i = 0; i < (poll >> 1); i++)
 		hc->silence_data[i] = hc->silence;
 
-	if (!(type[HFC_cnt] & 0x200))
-		test_and_set_bit(HFC_CHIP_DTMF, &hc->chip);
+	if (hc->ctype != HFC_TYPE_XHFC) {
+		if (!(type[HFC_cnt] & 0x200))
+			test_and_set_bit(HFC_CHIP_DTMF, &hc->chip);
+		test_and_set_bit(HFC_CHIP_CONF, &hc->chip);
+	}
 
 	if (type[HFC_cnt] & 0x800)
 		test_and_set_bit(HFC_CHIP_PCM_SLAVE, &hc->chip);
@@ -4935,8 +5211,12 @@ hfcmulti_init(struct pci_dev *pdev, const struct pci_device_id *ent)
 		printk(KERN_NOTICE "Watchdog enabled\n");
 	}
 
-	/* setup pci, hc->slots may change due to PLXSD */
-	ret_err = setup_pci(hc, pdev, ent);
+	if (pdev && ent) {
+		/* setup pci, hc->slots may change due to PLXSD */
+		ret_err = setup_pci(hc, pdev, ent);
+	} else {
+		ret_err = setup_embedded(hc, m);
+	}
 	if (ret_err) {
 		if (hc == syncmaster)
 			syncmaster = NULL;
@@ -4952,7 +5232,7 @@ hfcmulti_init(struct pci_dev *pdev, const struct pci_device_id *ent)
 			ret_err = -EINVAL;
 			goto free_card;
 		}
-		if (hc->type == 1)
+		if (hc->ctype == HFC_TYPE_E1)
 			ret_err = init_e1_port(hc, m);
 		else
 			ret_err = init_multi_port(hc, pt);
@@ -5036,6 +5316,7 @@ hfcmulti_init(struct pci_dev *pdev, const struct pci_device_id *ent)
 		hc->iclock = mISDN_register_clock("HFCMulti", 0, clockctl, hc);
 
 	/* initialize hardware */
+	hc->irq = m->irq;
 	ret_err = init_card(hc);
 	if (ret_err) {
 		printk(KERN_ERR "init card returns %d\n", ret_err);
@@ -5086,45 +5367,47 @@ static void __devexit hfc_remove_pci(struct pci_dev *pdev)
 #define VENDOR_PRIM	"PrimuX"
 
 static const struct hm_map hfcm_map[] = {
-/*0*/	{VENDOR_BN, "HFC-1S Card (mini PCI)", 4, 1, 1, 3, 0, DIP_4S, 0},
-/*1*/	{VENDOR_BN, "HFC-2S Card", 4, 2, 1, 3, 0, DIP_4S, 0},
-/*2*/	{VENDOR_BN, "HFC-2S Card (mini PCI)", 4, 2, 1, 3, 0, DIP_4S, 0},
-/*3*/	{VENDOR_BN, "HFC-4S Card", 4, 4, 1, 2, 0, DIP_4S, 0},
-/*4*/	{VENDOR_BN, "HFC-4S Card (mini PCI)", 4, 4, 1, 2, 0, 0, 0},
-/*5*/	{VENDOR_CCD, "HFC-4S Eval (old)", 4, 4, 0, 0, 0, 0, 0},
-/*6*/	{VENDOR_CCD, "HFC-4S IOB4ST", 4, 4, 1, 2, 0, DIP_4S, 0},
-/*7*/	{VENDOR_CCD, "HFC-4S", 4, 4, 1, 2, 0, 0, 0},
-/*8*/	{VENDOR_DIG, "HFC-4S Card", 4, 4, 0, 2, 0, 0, HFC_IO_MODE_REGIO},
-/*9*/	{VENDOR_CCD, "HFC-4S Swyx 4xS0 SX2 QuadBri", 4, 4, 1, 2, 0, 0, 0},
-/*10*/	{VENDOR_JH, "HFC-4S (junghanns 2.0)", 4, 4, 1, 2, 0, 0, 0},
-/*11*/	{VENDOR_PRIM, "HFC-2S Primux Card", 4, 2, 0, 0, 0, 0, 0},
-
-/*12*/	{VENDOR_BN, "HFC-8S Card", 8, 8, 1, 0, 0, 0, 0},
+/*0*/	{VENDOR_BN, "HFC-1S Card (mini PCI)", 4, 1, 1, 3, 0, DIP_4S, 0, 0},
+/*1*/	{VENDOR_BN, "HFC-2S Card", 4, 2, 1, 3, 0, DIP_4S, 0, 0},
+/*2*/	{VENDOR_BN, "HFC-2S Card (mini PCI)", 4, 2, 1, 3, 0, DIP_4S, 0, 0},
+/*3*/	{VENDOR_BN, "HFC-4S Card", 4, 4, 1, 2, 0, DIP_4S, 0, 0},
+/*4*/	{VENDOR_BN, "HFC-4S Card (mini PCI)", 4, 4, 1, 2, 0, 0, 0, 0},
+/*5*/	{VENDOR_CCD, "HFC-4S Eval (old)", 4, 4, 0, 0, 0, 0, 0, 0},
+/*6*/	{VENDOR_CCD, "HFC-4S IOB4ST", 4, 4, 1, 2, 0, DIP_4S, 0, 0},
+/*7*/	{VENDOR_CCD, "HFC-4S", 4, 4, 1, 2, 0, 0, 0, 0},
+/*8*/	{VENDOR_DIG, "HFC-4S Card", 4, 4, 0, 2, 0, 0, HFC_IO_MODE_REGIO, 0},
+/*9*/	{VENDOR_CCD, "HFC-4S Swyx 4xS0 SX2 QuadBri", 4, 4, 1, 2, 0, 0, 0, 0},
+/*10*/	{VENDOR_JH, "HFC-4S (junghanns 2.0)", 4, 4, 1, 2, 0, 0, 0, 0},
+/*11*/	{VENDOR_PRIM, "HFC-2S Primux Card", 4, 2, 0, 0, 0, 0, 0, 0},
+
+/*12*/	{VENDOR_BN, "HFC-8S Card", 8, 8, 1, 0, 0, 0, 0, 0},
 /*13*/	{VENDOR_BN, "HFC-8S Card (+)", 8, 8, 1, 8, 0, DIP_8S,
-		HFC_IO_MODE_REGIO},
-/*14*/	{VENDOR_CCD, "HFC-8S Eval (old)", 8, 8, 0, 0, 0, 0, 0},
-/*15*/	{VENDOR_CCD, "HFC-8S IOB4ST Recording", 8, 8, 1, 0, 0, 0, 0},
+		HFC_IO_MODE_REGIO, 0},
+/*14*/	{VENDOR_CCD, "HFC-8S Eval (old)", 8, 8, 0, 0, 0, 0, 0, 0},
+/*15*/	{VENDOR_CCD, "HFC-8S IOB4ST Recording", 8, 8, 1, 0, 0, 0, 0, 0},
 
-/*16*/	{VENDOR_CCD, "HFC-8S IOB8ST", 8, 8, 1, 0, 0, 0, 0},
-/*17*/	{VENDOR_CCD, "HFC-8S", 8, 8, 1, 0, 0, 0, 0},
-/*18*/	{VENDOR_CCD, "HFC-8S", 8, 8, 1, 0, 0, 0, 0},
+/*16*/	{VENDOR_CCD, "HFC-8S IOB8ST", 8, 8, 1, 0, 0, 0, 0, 0},
+/*17*/	{VENDOR_CCD, "HFC-8S", 8, 8, 1, 0, 0, 0, 0, 0},
+/*18*/	{VENDOR_CCD, "HFC-8S", 8, 8, 1, 0, 0, 0, 0, 0},
 
-/*19*/	{VENDOR_BN, "HFC-E1 Card", 1, 1, 0, 1, 0, DIP_E1, 0},
-/*20*/	{VENDOR_BN, "HFC-E1 Card (mini PCI)", 1, 1, 0, 1, 0, 0, 0},
-/*21*/	{VENDOR_BN, "HFC-E1+ Card (Dual)", 1, 1, 0, 1, 0, DIP_E1, 0},
-/*22*/	{VENDOR_BN, "HFC-E1 Card (Dual)", 1, 1, 0, 1, 0, DIP_E1, 0},
+/*19*/	{VENDOR_BN, "HFC-E1 Card", 1, 1, 0, 1, 0, DIP_E1, 0, 0},
+/*20*/	{VENDOR_BN, "HFC-E1 Card (mini PCI)", 1, 1, 0, 1, 0, 0, 0, 0},
+/*21*/	{VENDOR_BN, "HFC-E1+ Card (Dual)", 1, 1, 0, 1, 0, DIP_E1, 0, 0},
+/*22*/	{VENDOR_BN, "HFC-E1 Card (Dual)", 1, 1, 0, 1, 0, DIP_E1, 0, 0},
 
-/*23*/	{VENDOR_CCD, "HFC-E1 Eval (old)", 1, 1, 0, 0, 0, 0, 0},
-/*24*/	{VENDOR_CCD, "HFC-E1 IOB1E1", 1, 1, 0, 1, 0, 0, 0},
-/*25*/	{VENDOR_CCD, "HFC-E1", 1, 1, 0, 1, 0, 0, 0},
+/*23*/	{VENDOR_CCD, "HFC-E1 Eval (old)", 1, 1, 0, 0, 0, 0, 0, 0},
+/*24*/	{VENDOR_CCD, "HFC-E1 IOB1E1", 1, 1, 0, 1, 0, 0, 0, 0},
+/*25*/	{VENDOR_CCD, "HFC-E1", 1, 1, 0, 1, 0, 0, 0, 0},
 
 /*26*/	{VENDOR_CCD, "HFC-4S Speech Design", 4, 4, 0, 0, 0, 0,
-		HFC_IO_MODE_PLXSD},
+		HFC_IO_MODE_PLXSD, 0},
 /*27*/	{VENDOR_CCD, "HFC-E1 Speech Design", 1, 1, 0, 0, 0, 0,
-		HFC_IO_MODE_PLXSD},
-/*28*/	{VENDOR_CCD, "HFC-4S OpenVox", 4, 4, 1, 0, 0, 0, 0},
-/*29*/	{VENDOR_CCD, "HFC-2S OpenVox", 4, 2, 1, 0, 0, 0, 0},
-/*30*/	{VENDOR_CCD, "HFC-8S OpenVox", 8, 8, 1, 0, 0, 0, 0},
+		HFC_IO_MODE_PLXSD, 0},
+/*28*/	{VENDOR_CCD, "HFC-4S OpenVox", 4, 4, 1, 0, 0, 0, 0, 0},
+/*29*/	{VENDOR_CCD, "HFC-2S OpenVox", 4, 2, 1, 0, 0, 0, 0, 0},
+/*30*/	{VENDOR_CCD, "HFC-8S OpenVox", 8, 8, 1, 0, 0, 0, 0, 0},
+/*31*/	{VENDOR_CCD, "XHFC-4S Speech Design", 5, 4, 0, 0, 0, 0,
+		HFC_IO_MODE_EMBSD, XHFC_IRQ},
 };
 
 #undef H
@@ -5231,7 +5514,8 @@ hfcmulti_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		    "Please contact the driver maintainer for support.\n");
 		return -ENODEV;
 	}
-	ret = hfcmulti_init(pdev, ent);
+	m->irq = pdev->irq;
+	ret = hfcmulti_init(m, pdev, ent);
 	if (ret)
 		return ret;
 	HFC_cnt++;
@@ -5261,6 +5545,8 @@ static int __init
 HFCmulti_init(void)
 {
 	int err;
+	int i, xhfc = 0;
+	struct hm_map m;
 
 	printk(KERN_INFO "mISDN: HFC-multi driver %s\n", HFC_MULTI_VERSION);
 
@@ -5308,11 +5594,43 @@ HFCmulti_init(void)
 	if (!clock)
 		clock = 1;
 
+	/* Register the embedded devices.
+	 * This should be done before the PCI cards registration */
+	switch (hwid) {
+	case HWID_MINIP4:
+		xhfc = 1;
+		m = hfcm_map[31];
+		break;
+	case HWID_MINIP8:
+		xhfc = 2;
+		m = hfcm_map[31];
+		break;
+	case HWID_MINIP16:
+		xhfc = 4;
+		m = hfcm_map[31];
+		break;
+	default:
+		xhfc = 0;
+	}
+
+	for (i = 0; i < xhfc; ++i) {
+		err = hfcmulti_init(&m, NULL, NULL);
+		if (err) {
+			printk(KERN_ERR "error registering embedded driver: "
+				"%x\n", err);
+			return -err;
+		}
+		HFC_cnt++;
+		printk(KERN_INFO "%d devices registered\n", HFC_cnt);
+	}
+
+	/* Register the PCI cards */
 	err = pci_register_driver(&hfcmultipci_driver);
 	if (err < 0) {
 		printk(KERN_ERR "error registering pci driver: %x\n", err);
 		return err;
 	}
+
 	return 0;
 }
 
diff --git a/drivers/isdn/mISDN/dsp_cmx.c b/drivers/isdn/mISDN/dsp_cmx.c
index 58c43e4..5e1d947 100644
--- a/drivers/isdn/mISDN/dsp_cmx.c
+++ b/drivers/isdn/mISDN/dsp_cmx.c
@@ -937,6 +937,10 @@ conf_software:
 	if (current_conf >= 0) {
 join_members:
 		list_for_each_entry(member, &conf->mlist, list) {
+			/* if no conference engine on our chip, change to
+			 * software */
+			if (!member->dsp->features.hfc_conf)
+				goto conf_software;
 			/* in case of hdlc, change to software */
 			if (member->dsp->hdlc)
 				goto conf_software;
diff --git a/include/linux/mISDNdsp.h b/include/linux/mISDNdsp.h
index 6b71d2d..9c34061 100644
--- a/include/linux/mISDNdsp.h
+++ b/include/linux/mISDNdsp.h
@@ -24,6 +24,7 @@ extern void mISDN_dsp_element_unregister(struct mISDN_dsp_element *elem);
 struct dsp_features {
 	int	hfc_id; /* unique id to identify the chip (or -1) */
 	int	hfc_dtmf; /* set if HFCmulti card supports dtmf */
+	int	hfc_conf; /* set if HFCmulti card supports conferences */
 	int	hfc_loops; /* set if card supports tone loops */
 	int	hfc_echocanhw; /* set if card supports echocancelation*/
 	int	pcm_id; /* unique id to identify the pcm bus (or -1) */
-- 
1.6.0.2

