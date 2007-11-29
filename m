Return-Path: <linux-kernel-owner+w=401wt.eu-S1754838AbXLFMom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbXLFMom (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:44:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbXLFMmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:42:42 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:53687 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743AbXLFMmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:42:03 -0500
From: Jesper Nilsson <jesper.nilsson@axis.com>
Message-Id: <5e2a567995861daffb224c6cdd7d5f85f7da0936.1196848533.git.jesper.nilsson@axis.com>
In-Reply-To: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Date: Thu, 29 Nov 2007 17:30:24 +0100
Subject: [PATCH 09/47] Update CRISv32 synchronous serial driver.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now uses a DMA descriptor ring, which should avoid any unnecessary
pauses in the streams.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/arch-v32/drivers/sync_serial.c |  940 +++++++++++++++++++-----------
 1 files changed, 599 insertions(+), 341 deletions(-)

diff --git a/arch/cris/arch-v32/drivers/sync_serial.c b/arch/cris/arch-v32/drivers/sync_serial.c
index d581b0a..eddb987 100644
--- a/arch/cris/arch-v32/drivers/sync_serial.c
+++ b/arch/cris/arch-v32/drivers/sync_serial.c
@@ -1,5 +1,5 @@
 /*
- * Simple synchronous serial port driver for ETRAX FS.
+ * Simple synchronous serial port driver for ETRAX FS and Artpec-3.
  *
  * Copyright (c) 2005 Axis Communications AB
  *
@@ -21,17 +21,18 @@
 #include <linux/spinlock.h>
 
 #include <asm/io.h>
-#include <asm/arch/dma.h>
-#include <asm/arch/pinmux.h>
-#include <asm/arch/hwregs/reg_rdwr.h>
-#include <asm/arch/hwregs/sser_defs.h>
-#include <asm/arch/hwregs/dma_defs.h>
-#include <asm/arch/hwregs/dma.h>
-#include <asm/arch/hwregs/intr_vect_defs.h>
-#include <asm/arch/hwregs/intr_vect.h>
-#include <asm/arch/hwregs/reg_map.h>
+#include <dma.h>
+#include <pinmux.h>
+#include <hwregs/reg_rdwr.h>
+#include <hwregs/sser_defs.h>
+#include <hwregs/dma_defs.h>
+#include <hwregs/dma.h>
+#include <hwregs/intr_vect_defs.h>
+#include <hwregs/intr_vect.h>
+#include <hwregs/reg_map.h>
 #include <asm/sync_serial.h>
 
+
 /* The receiver is a bit tricky beacuse of the continuous stream of data.*/
 /*                                                                       */
 /* Three DMA descriptors are linked together. Each DMA descriptor is     */
@@ -63,8 +64,10 @@
 /* words can be handled */
 #define IN_BUFFER_SIZE 12288
 #define IN_DESCR_SIZE 256
-#define NUM_IN_DESCR (IN_BUFFER_SIZE/IN_DESCR_SIZE)
-#define OUT_BUFFER_SIZE 4096
+#define NBR_IN_DESCR (IN_BUFFER_SIZE/IN_DESCR_SIZE)
+
+#define OUT_BUFFER_SIZE 1024*8
+#define NBR_OUT_DESCR 8
 
 #define DEFAULT_FRAME_RATE 0
 #define DEFAULT_WORD_RATE 7
@@ -78,6 +81,8 @@
 #define DEBUGPOLL(x)
 #define DEBUGRXINT(x)
 #define DEBUGTXINT(x)
+#define DEBUGTRDMA(x)
+#define DEBUGOUTBUF(x)
 
 typedef struct sync_port
 {
@@ -97,10 +102,11 @@ typedef struct sync_port
 	int output;
 	int input;
 
-	volatile unsigned int out_count; /* Remaining bytes for current transfer */
-	unsigned char* outp; /* Current position in out_buffer */
-	volatile unsigned char* volatile readp;  /* Next byte to be read by application */
-	volatile unsigned char* volatile writep; /* Next byte to be written by etrax */
+	/* Next byte to be read by application */
+	volatile unsigned char *volatile readp;
+	/* Next byte to be written by etrax */
+	volatile unsigned char *volatile writep;
+
 	unsigned int in_buffer_size;
 	unsigned int inbufchunk;
 	unsigned char out_buffer[OUT_BUFFER_SIZE] __attribute__ ((aligned(32)));
@@ -108,11 +114,30 @@ typedef struct sync_port
 	unsigned char flip[IN_BUFFER_SIZE] __attribute__ ((aligned(32)));
 	struct dma_descr_data* next_rx_desc;
 	struct dma_descr_data* prev_rx_desc;
+
+	/* Pointer to the first available descriptor in the ring,
+	 * unless active_tr_descr == catch_tr_descr and a dma
+	 * transfer is active */
+	struct dma_descr_data *active_tr_descr;
+
+	/* Pointer to the first allocated descriptor in the ring */
+	struct dma_descr_data *catch_tr_descr;
+
+	/* Pointer to the descriptor with the current end-of-list */
+	struct dma_descr_data *prev_tr_descr;
 	int full;
 
-	dma_descr_data in_descr[NUM_IN_DESCR] __attribute__ ((__aligned__(16)));
+	/* Pointer to the first byte being read by DMA
+	 * or current position in out_buffer if not using DMA. */
+	unsigned char *out_rd_ptr;
+
+	/* Number of bytes currently locked for being read by DMA */
+	int out_buf_count;
+
+	dma_descr_data in_descr[NBR_IN_DESCR] __attribute__ ((__aligned__(16)));
 	dma_descr_context in_context __attribute__ ((__aligned__(32)));
-	dma_descr_data out_descr __attribute__ ((__aligned__(16)));
+	dma_descr_data out_descr[NBR_OUT_DESCR]
+		__attribute__ ((__aligned__(16)));
 	dma_descr_context out_context __attribute__ ((__aligned__(32)));
 	wait_queue_head_t out_wait_q;
 	wait_queue_head_t in_wait_q;
@@ -121,7 +146,9 @@ typedef struct sync_port
 } sync_port;
 
 static int etrax_sync_serial_init(void);
+#if defined(CONFIG_ETRAX_SYNCHRONOUS_SERIAL_PORT1)
 static void initialize_port(int portnbr);
+#endif
 static inline int sync_data_avail(struct sync_port *port);
 
 static int sync_serial_open(struct inode *, struct file*);
@@ -143,11 +170,11 @@ static ssize_t sync_serial_read(struct file *file, char *buf,
 #endif
 
 static void send_word(sync_port* port);
-static void start_dma(struct sync_port *port, const char* data, int count);
+static void start_dma_out(struct sync_port *port, const char *data, int count);
 static void start_dma_in(sync_port* port);
 #ifdef SYNC_SER_DMA
-static irqreturn_t tr_interrupt(int irq, void *dev_id, struct pt_regs * regs);
-static irqreturn_t rx_interrupt(int irq, void *dev_id, struct pt_regs * regs);
+static irqreturn_t tr_interrupt(int irq, void *dev_id);
+static irqreturn_t rx_interrupt(int irq, void *dev_id);
 #endif
 
 #if (defined(CONFIG_ETRAX_SYNCHRONOUS_SERIAL_PORT0) && \
@@ -157,22 +184,49 @@ static irqreturn_t rx_interrupt(int irq, void *dev_id, struct pt_regs * regs);
 #define SYNC_SER_MANUAL
 #endif
 #ifdef SYNC_SER_MANUAL
-static irqreturn_t manual_interrupt(int irq, void *dev_id, struct pt_regs * regs);
+static irqreturn_t manual_interrupt(int irq, void *dev_id);
+#endif
+
+#ifdef CONFIG_ETRAXFS	/* ETRAX FS */
+#define OUT_DMA_NBR 4
+#define IN_DMA_NBR 5
+#define PINMUX_SSER pinmux_sser0
+#define SYNCSER_INST regi_sser0
+#define SYNCSER_INTR_VECT SSER0_INTR_VECT
+#define OUT_DMA_INST regi_dma4
+#define IN_DMA_INST regi_dma5
+#define DMA_OUT_INTR_VECT DMA4_INTR_VECT
+#define DMA_IN_INTR_VECT DMA5_INTR_VECT
+#define REQ_DMA_SYNCSER dma_sser0
+#else			/* Artpec-3 */
+#define OUT_DMA_NBR 6
+#define IN_DMA_NBR 7
+#define PINMUX_SSER pinmux_sser
+#define SYNCSER_INST regi_sser
+#define SYNCSER_INTR_VECT SSER_INTR_VECT
+#define OUT_DMA_INST regi_dma6
+#define IN_DMA_INST regi_dma7
+#define DMA_OUT_INTR_VECT DMA6_INTR_VECT
+#define DMA_IN_INTR_VECT DMA7_INTR_VECT
+#define REQ_DMA_SYNCSER dma_sser
 #endif
 
 /* The ports */
 static struct sync_port ports[]=
 {
 	{
-		.regi_sser             = regi_sser0,
-		.regi_dmaout           = regi_dma4,
-		.regi_dmain            = regi_dma5,
+		.regi_sser             = SYNCSER_INST,
+		.regi_dmaout           = OUT_DMA_INST,
+		.regi_dmain            = IN_DMA_INST,
 #if defined(CONFIG_ETRAX_SYNCHRONOUS_SERIAL0_DMA)
                 .use_dma               = 1,
 #else
                 .use_dma               = 0,
 #endif
-	},
+	}
+#ifdef CONFIG_ETRAXFS
+	,
+
 	{
 		.regi_sser             = regi_sser1,
 		.regi_dmaout           = regi_dma6,
@@ -183,9 +237,10 @@ static struct sync_port ports[]=
                 .use_dma               = 0,
 #endif
 	}
+#endif
 };
 
-#define NUMBER_OF_PORTS ARRAY_SIZE(ports)
+#define NBR_PORTS ARRAY_SIZE(ports)
 
 static const struct file_operations sync_serial_fops = {
 	.owner   = THIS_MODULE,
@@ -200,19 +255,21 @@ static const struct file_operations sync_serial_fops = {
 static int __init etrax_sync_serial_init(void)
 {
 	ports[0].enabled = 0;
+#ifdef CONFIG_ETRAXFS
 	ports[1].enabled = 0;
-
-	if (register_chrdev(SYNC_SERIAL_MAJOR,"sync serial", &sync_serial_fops) <0 )
-	{
-		printk("unable to get major for synchronous serial port\n");
+#endif
+	if (register_chrdev(SYNC_SERIAL_MAJOR, "sync serial",
+			&sync_serial_fops) < 0) {
+		printk(KERN_WARNING
+			"Unable to get major for synchronous serial port\n");
 		return -EBUSY;
 	}
 
 	/* Initialize Ports */
 #if defined(CONFIG_ETRAX_SYNCHRONOUS_SERIAL_PORT0)
-	if (crisv32_pinmux_alloc_fixed(pinmux_sser0))
-	{
-		printk("Unable to allocate pins for syncrhronous serial port 0\n");
+	if (crisv32_pinmux_alloc_fixed(PINMUX_SSER)) {
+		printk(KERN_WARNING
+			"Unable to alloc pins for synchronous serial port 0\n");
 		return -EIO;
 	}
 	ports[0].enabled = 1;
@@ -220,33 +277,41 @@ static int __init etrax_sync_serial_init(void)
 #endif
 
 #if defined(CONFIG_ETRAX_SYNCHRONOUS_SERIAL_PORT1)
-	if (crisv32_pinmux_alloc_fixed(pinmux_sser1))
-	{
-		printk("Unable to allocate pins for syncrhronous serial port 0\n");
+	if (crisv32_pinmux_alloc_fixed(pinmux_sser1)) {
+		printk(KERN_WARNING
+			"Unable to alloc pins for synchronous serial port 0\n");
 		return -EIO;
 	}
 	ports[1].enabled = 1;
 	initialize_port(1);
 #endif
 
-	printk("ETRAX FS synchronous serial port driver\n");
+#ifdef CONFIG_ETRAXFS
+	printk(KERN_INFO "ETRAX FS synchronous serial port driver\n");
+#else
+	printk(KERN_INFO "Artpec-3 synchronous serial port driver\n");
+#endif
 	return 0;
 }
 
+#if defined(CONFIG_ETRAX_SYNCHRONOUS_SERIAL_PORT1)
 static void __init initialize_port(int portnbr)
 {
-	struct sync_port* port = &ports[portnbr];
+	int __attribute__((unused)) i;
+	struct sync_port *port = &ports[portnbr];
 	reg_sser_rw_cfg cfg = {0};
 	reg_sser_rw_frm_cfg frm_cfg = {0};
 	reg_sser_rw_tr_cfg tr_cfg = {0};
 	reg_sser_rw_rec_cfg rec_cfg = {0};
 
-	DEBUG(printk("Init sync serial port %d\n", portnbr));
+	DEBUG(printk(KERN_DEBUG "Init sync serial port %d\n", portnbr));
 
 	port->port_nbr = portnbr;
 	port->init_irqs = 1;
 
-	port->outp = port->out_buffer;
+	port->out_rd_ptr = port->out_buffer;
+	port->out_buf_count = 0;
+
 	port->output = 1;
 	port->input = 0;
 
@@ -255,7 +320,7 @@ static void __init initialize_port(int portnbr)
 	port->in_buffer_size = IN_BUFFER_SIZE;
 	port->inbufchunk = IN_DESCR_SIZE;
 	port->next_rx_desc = &port->in_descr[0];
-	port->prev_rx_desc = &port->in_descr[NUM_IN_DESCR-1];
+	port->prev_rx_desc = &port->in_descr[NBR_IN_DESCR-1];
 	port->prev_rx_desc->eol = 1;
 
 	init_waitqueue_head(&port->out_wait_q);
@@ -286,8 +351,13 @@ static void __init initialize_port(int portnbr)
 	tr_cfg.sample_size = 7;
 	tr_cfg.sh_dir = regk_sser_msbfirst;
 	tr_cfg.use_dma = port->use_dma ? regk_sser_yes : regk_sser_no;
+#if 0
 	tr_cfg.rate_ctrl = regk_sser_bulk;
 	tr_cfg.data_pin_use = regk_sser_dout;
+#else
+	tr_cfg.rate_ctrl = regk_sser_iso;
+	tr_cfg.data_pin_use = regk_sser_dout;
+#endif
 	tr_cfg.bulk_wspace = 1;
 	REG_WR(sser, port->regi_sser, rw_tr_cfg, tr_cfg);
 
@@ -296,7 +366,29 @@ static void __init initialize_port(int portnbr)
 	rec_cfg.use_dma = port->use_dma ? regk_sser_yes : regk_sser_no;
 	rec_cfg.fifo_thr = regk_sser_inf;
 	REG_WR(sser, port->regi_sser, rw_rec_cfg, rec_cfg);
+
+#ifdef SYNC_SER_DMA
+	/* Setup the descriptor ring for dma out/transmit. */
+	for (i = 0; i < NBR_OUT_DESCR; i++) {
+		port->out_descr[i].wait = 0;
+		port->out_descr[i].intr = 1;
+		port->out_descr[i].eol = 0;
+		port->out_descr[i].out_eop = 0;
+		port->out_descr[i].next =
+			(dma_descr_data *)virt_to_phys(&port->out_descr[i+1]);
+	}
+
+	/* Create a ring from the list. */
+	port->out_descr[NBR_OUT_DESCR-1].next =
+		(dma_descr_data *)virt_to_phys(&port->out_descr[0]);
+
+	/* Setup context for traversing the ring. */
+	port->active_tr_descr = &port->out_descr[0];
+	port->prev_tr_descr = &port->out_descr[NBR_OUT_DESCR-1];
+	port->catch_tr_descr = &port->out_descr[0];
+#endif
 }
+#endif
 
 static inline int sync_data_avail(struct sync_port *port)
 {
@@ -311,7 +403,7 @@ static inline int sync_data_avail(struct sync_port *port)
 	 *  ^rp  ^wp    ^wp ^rp
 	 */
 
-  	if (end >= start)
+	if (end >= start)
 		avail = end - start;
 	else
 		avail = port->in_buffer_size - (start - end);
@@ -331,7 +423,7 @@ static inline int sync_data_avail_to_end(struct sync_port *port)
 	 *  ^rp  ^wp    ^wp ^rp
 	 */
 
-  	if (end >= start)
+	if (end >= start)
 		avail = end - start;
 	else
 		avail = port->flip + port->in_buffer_size - start;
@@ -341,66 +433,69 @@ static inline int sync_data_avail_to_end(struct sync_port *port)
 static int sync_serial_open(struct inode *inode, struct file *file)
 {
 	int dev = iminor(inode);
-	sync_port* port;
+	sync_port *port;
 	reg_dma_rw_cfg cfg = {.en = regk_dma_yes};
 	reg_dma_rw_intr_mask intr_mask = {.data = regk_dma_yes};
 
-	DEBUG(printk("Open sync serial port %d\n", dev));
+	DEBUG(printk(KERN_DEBUG "Open sync serial port %d\n", dev));
 
-	if (dev < 0 || dev >= NUMBER_OF_PORTS || !ports[dev].enabled)
+	if (dev < 0 || dev >= NBR_PORTS || !ports[dev].enabled)
 	{
-		DEBUG(printk("Invalid minor %d\n", dev));
+		DEBUG(printk(KERN_DEBUG "Invalid minor %d\n", dev));
 		return -ENODEV;
 	}
 	port = &ports[dev];
 	/* Allow open this device twice (assuming one reader and one writer) */
 	if (port->busy == 2)
 	{
-		DEBUG(printk("Device is busy.. \n"));
+		DEBUG(printk(KERN_DEBUG "Device is busy.. \n"));
 		return -EBUSY;
 	}
+
+
 	if (port->init_irqs) {
 		if (port->use_dma) {
-			if (port == &ports[0]){
+			if (port == &ports[0]) {
 #ifdef SYNC_SER_DMA
-				if(request_irq(DMA4_INTR_VECT,
-					       tr_interrupt,
-					       0,
-					       "synchronous serial 0 dma tr",
-					       &ports[0])) {
+				if (request_irq(DMA_OUT_INTR_VECT,
+						tr_interrupt,
+						0,
+						"synchronous serial 0 dma tr",
+						&ports[0])) {
 					printk(KERN_CRIT "Can't allocate sync serial port 0 IRQ");
 					return -EBUSY;
-				} else if(request_irq(DMA5_INTR_VECT,
-						      rx_interrupt,
-						      0,
-						      "synchronous serial 1 dma rx",
-						      &ports[0])) {
-					free_irq(DMA4_INTR_VECT, &port[0]);
+				} else if (request_irq(DMA_IN_INTR_VECT,
+						rx_interrupt,
+						0,
+						"synchronous serial 1 dma rx",
+						&ports[0])) {
+					free_irq(DMA_OUT_INTR_VECT, &port[0]);
 					printk(KERN_CRIT "Can't allocate sync serial port 0 IRQ");
 					return -EBUSY;
-				} else if (crisv32_request_dma(SYNC_SER0_TX_DMA_NBR,
-                                                               "synchronous serial 0 dma tr",
-                                                               DMA_VERBOSE_ON_ERROR,
-                                                               0,
-                                                               dma_sser0)) {
-					free_irq(DMA4_INTR_VECT, &port[0]);
-					free_irq(DMA5_INTR_VECT, &port[0]);
+				} else if (crisv32_request_dma(OUT_DMA_NBR,
+						"synchronous serial 0 dma tr",
+						DMA_VERBOSE_ON_ERROR,
+						0,
+						REQ_DMA_SYNCSER)) {
+					free_irq(DMA_OUT_INTR_VECT, &port[0]);
+					free_irq(DMA_IN_INTR_VECT, &port[0]);
 					printk(KERN_CRIT "Can't allocate sync serial port 0 TX DMA channel");
 					return -EBUSY;
-				} else if (crisv32_request_dma(SYNC_SER0_RX_DMA_NBR,
-                                                               "synchronous serial 0 dma rec",
-                                                               DMA_VERBOSE_ON_ERROR,
-                                                               0,
-                                                               dma_sser0)) {
-					crisv32_free_dma(SYNC_SER0_TX_DMA_NBR);
-					free_irq(DMA4_INTR_VECT, &port[0]);
-					free_irq(DMA5_INTR_VECT, &port[0]);
+				} else if (crisv32_request_dma(IN_DMA_NBR,
+						"synchronous serial 0 dma rec",
+						DMA_VERBOSE_ON_ERROR,
+						0,
+						REQ_DMA_SYNCSER)) {
+					crisv32_free_dma(OUT_DMA_NBR);
+					free_irq(DMA_OUT_INTR_VECT, &port[0]);
+					free_irq(DMA_IN_INTR_VECT, &port[0]);
 					printk(KERN_CRIT "Can't allocate sync serial port 1 RX DMA channel");
 					return -EBUSY;
 				}
 #endif
 			}
-			else if (port == &ports[1]){
+#ifdef CONFIG_ETRAXFS
+			else if (port == &ports[1]) {
 #ifdef SYNC_SER_DMA
 				if (request_irq(DMA6_INTR_VECT,
 						tr_interrupt,
@@ -417,20 +512,22 @@ static int sync_serial_open(struct inode *inode, struct file *file)
 					free_irq(DMA6_INTR_VECT, &ports[1]);
 					printk(KERN_CRIT "Can't allocate sync serial port 3 IRQ");
 					return -EBUSY;
-				} else if (crisv32_request_dma(SYNC_SER1_TX_DMA_NBR,
-                                                               "synchronous serial 1 dma tr",
-                                                               DMA_VERBOSE_ON_ERROR,
-                                                               0,
-                                                               dma_sser1)) {
-					free_irq(21, &ports[1]);
-					free_irq(20, &ports[1]);
+				} else if (crisv32_request_dma(
+						SYNC_SER1_TX_DMA_NBR,
+						"synchronous serial 1 dma tr",
+						DMA_VERBOSE_ON_ERROR,
+						0,
+						dma_sser1)) {
+					free_irq(DMA6_INTR_VECT, &ports[1]);
+					free_irq(DMA7_INTR_VECT, &ports[1]);
 					printk(KERN_CRIT "Can't allocate sync serial port 3 TX DMA channel");
 					return -EBUSY;
-				} else if (crisv32_request_dma(SYNC_SER1_RX_DMA_NBR,
-							    "synchronous serial 3 dma rec",
-							    DMA_VERBOSE_ON_ERROR,
-							    0,
-							    dma_sser1)) {
+				} else if (crisv32_request_dma(
+						SYNC_SER1_RX_DMA_NBR,
+						"synchronous serial 3 dma rec",
+						DMA_VERBOSE_ON_ERROR,
+						0,
+						dma_sser1)) {
 					crisv32_free_dma(SYNC_SER1_TX_DMA_NBR);
 					free_irq(DMA6_INTR_VECT, &ports[1]);
 					free_irq(DMA7_INTR_VECT, &ports[1]);
@@ -439,14 +536,14 @@ static int sync_serial_open(struct inode *inode, struct file *file)
 				}
 #endif
 			}
-
+#endif
                         /* Enable DMAs */
 			REG_WR(dma, port->regi_dmain, rw_cfg, cfg);
 			REG_WR(dma, port->regi_dmaout, rw_cfg, cfg);
 			/* Enable DMA IRQs */
 			REG_WR(dma, port->regi_dmain, rw_intr_mask, intr_mask);
 			REG_WR(dma, port->regi_dmaout, rw_intr_mask, intr_mask);
-			/* Set up wordsize = 2 for DMAs. */
+			/* Set up wordsize = 1 for DMAs. */
 			DMA_WR_CMD (port->regi_dmain, regk_dma_set_w_size1);
 			DMA_WR_CMD (port->regi_dmaout, regk_dma_set_w_size1);
 
@@ -455,7 +552,7 @@ static int sync_serial_open(struct inode *inode, struct file *file)
 		} else { /* !port->use_dma */
 #ifdef SYNC_SER_MANUAL
 			if (port == &ports[0]) {
-				if (request_irq(SSER0_INTR_VECT,
+				if (request_irq(SYNCSER_INTR_VECT,
 						manual_interrupt,
 						0,
 						"synchronous serial manual irq",
@@ -463,7 +560,9 @@ static int sync_serial_open(struct inode *inode, struct file *file)
 					printk("Can't allocate sync serial manual irq");
 					return -EBUSY;
 				}
-			} else if (port == &ports[1]) {
+			}
+#ifdef CONFIG_ETRAXFS
+			else if (port == &ports[1]) {
 				if (request_irq(SSER1_INTR_VECT,
 						manual_interrupt,
 						0,
@@ -473,11 +572,13 @@ static int sync_serial_open(struct inode *inode, struct file *file)
 					return -EBUSY;
 				}
 			}
+#endif
 			port->init_irqs = 0;
 #else
 			panic("sync_serial: Manual mode not supported.\n");
 #endif /* SYNC_SER_MANUAL */
 		}
+
 	} /* port->init_irqs */
 
 	port->busy++;
@@ -487,9 +588,9 @@ static int sync_serial_open(struct inode *inode, struct file *file)
 static int sync_serial_release(struct inode *inode, struct file *file)
 {
 	int dev = iminor(inode);
-	sync_port* port;
+	sync_port *port;
 
-	if (dev < 0 || dev >= NUMBER_OF_PORTS || !ports[dev].enabled)
+	if (dev < 0 || dev >= NBR_PORTS || !ports[dev].enabled)
 	{
 		DEBUG(printk("Invalid minor %d\n", dev));
 		return -ENODEV;
@@ -506,17 +607,37 @@ static unsigned int sync_serial_poll(struct file *file, poll_table *wait)
 {
 	int dev = iminor(file->f_path.dentry->d_inode);
 	unsigned int mask = 0;
-	sync_port* port;
+	sync_port *port;
 	DEBUGPOLL( static unsigned int prev_mask = 0; );
 
 	port = &ports[dev];
+
+	if (!port->started) {
+		reg_sser_rw_cfg cfg = REG_RD(sser, port->regi_sser, rw_cfg);
+		reg_sser_rw_rec_cfg rec_cfg =
+			REG_RD(sser, port->regi_sser, rw_rec_cfg);
+		cfg.en = regk_sser_yes;
+		rec_cfg.rec_en = port->input;
+		REG_WR(sser, port->regi_sser, rw_cfg, cfg);
+		REG_WR(sser, port->regi_sser, rw_rec_cfg, rec_cfg);
+		port->started = 1;
+	}
+
 	poll_wait(file, &port->out_wait_q, wait);
 	poll_wait(file, &port->in_wait_q, wait);
-	/* Some room to write */
-	if (port->out_count < OUT_BUFFER_SIZE)
+
+	/* No active transfer, descriptors are available */
+	if (port->output && !port->tr_running)
+		mask |= POLLOUT | POLLWRNORM;
+
+	/* Descriptor and buffer space available. */
+	if (port->output &&
+	    port->active_tr_descr != port->catch_tr_descr &&
+	    port->out_buf_count < OUT_BUFFER_SIZE)
 		mask |=  POLLOUT | POLLWRNORM;
+
 	/* At least an inbufchunk of data */
-	if (sync_data_avail(port) >= port->inbufchunk)
+	if (port->input && sync_data_avail(port) >= port->inbufchunk)
 		mask |= POLLIN | POLLRDNORM;
 
 	DEBUGPOLL(if (mask != prev_mask)
@@ -531,15 +652,16 @@ static int sync_serial_ioctl(struct inode *inode, struct file *file,
 		  unsigned int cmd, unsigned long arg)
 {
 	int return_val = 0;
+	int dma_w_size = regk_dma_set_w_size1;
 	int dev = iminor(file->f_path.dentry->d_inode);
-	sync_port* port;
+	sync_port *port;
 	reg_sser_rw_tr_cfg tr_cfg;
 	reg_sser_rw_rec_cfg rec_cfg;
 	reg_sser_rw_frm_cfg frm_cfg;
 	reg_sser_rw_cfg gen_cfg;
 	reg_sser_rw_intr_mask intr_mask;
 
-	if (dev < 0 || dev >= NUMBER_OF_PORTS || !ports[dev].enabled)
+	if (dev < 0 || dev >= NBR_PORTS || !ports[dev].enabled)
 	{
 		DEBUG(printk("Invalid minor %d\n", dev));
 		return -1;
@@ -558,61 +680,81 @@ static int sync_serial_ioctl(struct inode *inode, struct file *file,
 	case SSP_SPEED:
 		if (GET_SPEED(arg) == CODEC)
 		{
+			unsigned int freq;
+
 			gen_cfg.base_freq = regk_sser_f32;
-			/* FREQ = 0 => 4 MHz => clk_div = 7*/
-			gen_cfg.clk_div = 6 + (1 << GET_FREQ(arg));
-		}
-		else
-		{
+
+			/* Clock divider will internally be
+			 * gen_cfg.clk_div + 1.
+			 */
+
+			freq = GET_FREQ(arg);
+			switch (freq) {
+			case FREQ_32kHz:
+			case FREQ_64kHz:
+			case FREQ_128kHz:
+			case FREQ_256kHz:
+				gen_cfg.clk_div = 125 *
+					(1 << (freq - FREQ_256kHz)) - 1;
+			break;
+			case FREQ_512kHz:
+				gen_cfg.clk_div = 62;
+			break;
+			case FREQ_1MHz:
+			case FREQ_2MHz:
+			case FREQ_4MHz:
+				gen_cfg.clk_div = 8 * (1 << freq) - 1;
+			break;
+			}
+		} else {
 			gen_cfg.base_freq = regk_sser_f29_493;
-			switch (GET_SPEED(arg))
-			{
-				case SSP150:
-					gen_cfg.clk_div = 29493000 / (150 * 8) - 1;
-					break;
-				case SSP300:
-					gen_cfg.clk_div = 29493000 / (300 * 8) - 1;
-					break;
-				case SSP600:
-					gen_cfg.clk_div = 29493000 / (600 * 8) - 1;
-					break;
-				case SSP1200:
-					gen_cfg.clk_div = 29493000 / (1200 * 8) - 1;
-					break;
-				case SSP2400:
-					gen_cfg.clk_div = 29493000 / (2400 * 8) - 1;
-					break;
-				case SSP4800:
-					gen_cfg.clk_div = 29493000 / (4800 * 8) - 1;
-					break;
-				case SSP9600:
-					gen_cfg.clk_div = 29493000 / (9600 * 8) - 1;
-					break;
-				case SSP19200:
-					gen_cfg.clk_div = 29493000 / (19200 * 8) - 1;
-					break;
-				case SSP28800:
-					gen_cfg.clk_div = 29493000 / (28800 * 8) - 1;
-					break;
-				case SSP57600:
-					gen_cfg.clk_div = 29493000 / (57600 * 8) - 1;
-					break;
-				case SSP115200:
-					gen_cfg.clk_div = 29493000 / (115200 * 8) - 1;
-					break;
-				case SSP230400:
-					gen_cfg.clk_div = 29493000 / (230400 * 8) - 1;
-					break;
-				case SSP460800:
-					gen_cfg.clk_div = 29493000 / (460800 * 8) - 1;
-					break;
-				case SSP921600:
-					gen_cfg.clk_div = 29493000 / (921600 * 8) - 1;
-					break;
-				case SSP3125000:
-					gen_cfg.base_freq = regk_sser_f100;
-					gen_cfg.clk_div = 100000000 / (3125000 * 8) - 1;
-					break;
+			switch (GET_SPEED(arg)) {
+			case SSP150:
+				gen_cfg.clk_div = 29493000 / (150 * 8) - 1;
+				break;
+			case SSP300:
+				gen_cfg.clk_div = 29493000 / (300 * 8) - 1;
+				break;
+			case SSP600:
+				gen_cfg.clk_div = 29493000 / (600 * 8) - 1;
+				break;
+			case SSP1200:
+				gen_cfg.clk_div = 29493000 / (1200 * 8) - 1;
+				break;
+			case SSP2400:
+				gen_cfg.clk_div = 29493000 / (2400 * 8) - 1;
+				break;
+			case SSP4800:
+				gen_cfg.clk_div = 29493000 / (4800 * 8) - 1;
+				break;
+			case SSP9600:
+				gen_cfg.clk_div = 29493000 / (9600 * 8) - 1;
+				break;
+			case SSP19200:
+				gen_cfg.clk_div = 29493000 / (19200 * 8) - 1;
+				break;
+			case SSP28800:
+				gen_cfg.clk_div = 29493000 / (28800 * 8) - 1;
+				break;
+			case SSP57600:
+				gen_cfg.clk_div = 29493000 / (57600 * 8) - 1;
+				break;
+			case SSP115200:
+				gen_cfg.clk_div = 29493000 / (115200 * 8) - 1;
+				break;
+			case SSP230400:
+				gen_cfg.clk_div = 29493000 / (230400 * 8) - 1;
+				break;
+			case SSP460800:
+				gen_cfg.clk_div = 29493000 / (460800 * 8) - 1;
+				break;
+			case SSP921600:
+				gen_cfg.clk_div = 29493000 / (921600 * 8) - 1;
+				break;
+			case SSP3125000:
+				gen_cfg.base_freq = regk_sser_f100;
+				gen_cfg.clk_div = 100000000 / (3125000 * 8) - 1;
+				break;
 
 			}
 		}
@@ -625,46 +767,60 @@ static int sync_serial_ioctl(struct inode *inode, struct file *file,
 			case MASTER_OUTPUT:
 				port->output = 1;
 				port->input = 0;
+				frm_cfg.out_on = regk_sser_tr;
+				frm_cfg.frame_pin_dir = regk_sser_out;
 				gen_cfg.clk_dir = regk_sser_out;
 				break;
 			case SLAVE_OUTPUT:
 				port->output = 1;
 				port->input = 0;
+				frm_cfg.frame_pin_dir = regk_sser_in;
 				gen_cfg.clk_dir = regk_sser_in;
 				break;
 			case MASTER_INPUT:
 				port->output = 0;
 				port->input = 1;
+				frm_cfg.frame_pin_dir = regk_sser_out;
+				frm_cfg.out_on = regk_sser_intern_tb;
 				gen_cfg.clk_dir = regk_sser_out;
 				break;
 			case SLAVE_INPUT:
 				port->output = 0;
 				port->input = 1;
+				frm_cfg.frame_pin_dir = regk_sser_in;
 				gen_cfg.clk_dir = regk_sser_in;
 				break;
 			case MASTER_BIDIR:
 				port->output = 1;
 				port->input = 1;
+				frm_cfg.frame_pin_dir = regk_sser_out;
+				frm_cfg.out_on = regk_sser_intern_tb;
 				gen_cfg.clk_dir = regk_sser_out;
 				break;
 			case SLAVE_BIDIR:
 				port->output = 1;
 				port->input = 1;
+				frm_cfg.frame_pin_dir = regk_sser_in;
 				gen_cfg.clk_dir = regk_sser_in;
 				break;
 			default:
 				spin_unlock_irq(&port->lock);
 				return -EINVAL;
-
 		}
 		if (!port->use_dma || (arg == MASTER_OUTPUT || arg == SLAVE_OUTPUT))
 			intr_mask.rdav = regk_sser_yes;
 		break;
 	case SSP_FRAME_SYNC:
-		if (arg & NORMAL_SYNC)
+		if (arg & NORMAL_SYNC) {
+			frm_cfg.rec_delay = 1;
 			frm_cfg.tr_delay = 1;
+		}
 		else if (arg & EARLY_SYNC)
-			frm_cfg.tr_delay = 0;
+			frm_cfg.rec_delay = frm_cfg.tr_delay = 0;
+		else if (arg & SECOND_WORD_SYNC) {
+			frm_cfg.rec_delay = 7;
+			frm_cfg.tr_delay = 1;
+		}
 
 		tr_cfg.bulk_wspace = frm_cfg.tr_delay;
 		frm_cfg.early_wend = regk_sser_yes;
@@ -680,9 +836,11 @@ static int sync_serial_ioctl(struct inode *inode, struct file *file,
 		else if (arg & SYNC_OFF)
 			frm_cfg.frame_pin_use = regk_sser_gio0;
 
-		if (arg & WORD_SIZE_8)
+		dma_w_size = regk_dma_set_w_size2;
+		if (arg & WORD_SIZE_8) {
 			rec_cfg.sample_size = tr_cfg.sample_size = 7;
-		else if (arg & WORD_SIZE_12)
+			dma_w_size = regk_dma_set_w_size1;
+		} else if (arg & WORD_SIZE_12)
 			rec_cfg.sample_size = tr_cfg.sample_size = 11;
 		else if (arg & WORD_SIZE_16)
 			rec_cfg.sample_size = tr_cfg.sample_size = 15;
@@ -696,10 +854,13 @@ static int sync_serial_ioctl(struct inode *inode, struct file *file,
 		else if (arg & BIT_ORDER_LSB)
 			rec_cfg.sh_dir = tr_cfg.sh_dir = regk_sser_lsbfirst;
 
-		if (arg & FLOW_CONTROL_ENABLE)
+		if (arg & FLOW_CONTROL_ENABLE) {
+			frm_cfg.status_pin_use = regk_sser_frm;
 			rec_cfg.fifo_thr = regk_sser_thr16;
-		else if (arg & FLOW_CONTROL_DISABLE)
+		} else if (arg & FLOW_CONTROL_DISABLE) {
+			frm_cfg.status_pin_use = regk_sser_gio0;
 			rec_cfg.fifo_thr = regk_sser_inf;
+		}
 
 		if (arg & CLOCK_NOT_GATED)
 			gen_cfg.gate_clk = regk_sser_no;
@@ -726,9 +887,9 @@ static int sync_serial_ioctl(struct inode *inode, struct file *file,
 		break;
 	case SSP_OPOLARITY:
 		if (arg & CLOCK_NORMAL)
-			gen_cfg.out_clk_pol = regk_sser_neg;
-		else if (arg & CLOCK_INVERT)
 			gen_cfg.out_clk_pol = regk_sser_pos;
+		else if (arg & CLOCK_INVERT)
+			gen_cfg.out_clk_pol = regk_sser_neg;
 
 		if (arg & FRAME_NORMAL)
 			frm_cfg.level = regk_sser_pos_hi;
@@ -770,10 +931,9 @@ static int sync_serial_ioctl(struct inode *inode, struct file *file,
 	}
 
 
-	if (port->started)
-	{
-		tr_cfg.tr_en = port->output;
+	if (port->started) {
 		rec_cfg.rec_en = port->input;
+		gen_cfg.en = (port->output | port->input);
 	}
 
 	REG_WR(sser, port->regi_sser, rw_tr_cfg, tr_cfg);
@@ -782,138 +942,145 @@ static int sync_serial_ioctl(struct inode *inode, struct file *file,
 	REG_WR(sser, port->regi_sser, rw_intr_mask, intr_mask);
 	REG_WR(sser, port->regi_sser, rw_cfg, gen_cfg);
 
+
+	if (cmd == SSP_FRAME_SYNC && (arg & (WORD_SIZE_8 | WORD_SIZE_12 |
+			WORD_SIZE_16 | WORD_SIZE_24 | WORD_SIZE_32))) {
+		int en = gen_cfg.en;
+		gen_cfg.en = 0;
+		REG_WR(sser, port->regi_sser, rw_cfg, gen_cfg);
+		/* ##### Should DMA be stoped before we change dma size? */
+		DMA_WR_CMD(port->regi_dmain, dma_w_size);
+		DMA_WR_CMD(port->regi_dmaout, dma_w_size);
+		gen_cfg.en = en;
+		REG_WR(sser, port->regi_sser, rw_cfg, gen_cfg);
+	}
+
 	spin_unlock_irq(&port->lock);
 	return return_val;
 }
 
-static ssize_t sync_serial_write(struct file * file, const char * buf,
-                                 size_t count, loff_t *ppos)
+/* NOTE: sync_serial_write does not support concurrency */
+static ssize_t sync_serial_write(struct file *file, const char *buf,
+				 size_t count, loff_t *ppos)
 {
 	int dev = iminor(file->f_path.dentry->d_inode);
 	DECLARE_WAITQUEUE(wait, current);
-	sync_port *port;
-	unsigned long c, c1;
-	unsigned long free_outp;
-	unsigned long outp;
-	unsigned long out_buffer;
+	struct sync_port *port;
+	int trunc_count;
 	unsigned long flags;
+	int bytes_free;
+	int out_buf_count;
 
-	if (dev < 0 || dev >= NUMBER_OF_PORTS || !ports[dev].enabled)
-	{
+	unsigned char *rd_ptr;       /* First allocated byte in the buffer */
+	unsigned char *wr_ptr;       /* First free byte in the buffer */
+	unsigned char *buf_stop_ptr; /* Last byte + 1 */
+
+	if (dev < 0 || dev >= NBR_PORTS || !ports[dev].enabled) {
 		DEBUG(printk("Invalid minor %d\n", dev));
 		return -ENODEV;
 	}
 	port = &ports[dev];
 
-	DEBUGWRITE(printk("W d%d c %lu (%d/%d)\n", port->port_nbr, count, port->out_count, OUT_BUFFER_SIZE));
-	/* Space to end of buffer */
-	/*
-	 * out_buffer <c1>012345<-   c    ->OUT_BUFFER_SIZE
-	 *            outp^    +out_count
-	                        ^free_outp
-	 * out_buffer 45<-     c      ->0123OUT_BUFFER_SIZE
-	 *             +out_count   outp^
-	 *              free_outp
-	 *
+	/* |<-         OUT_BUFFER_SIZE                          ->|
+	 *           |<- out_buf_count ->|
+	 *                               |<- trunc_count ->| ...->|
+	 *  ______________________________________________________
+	 * |  free   |   data            | free                   |
+	 * |_________|___________________|________________________|
+	 *           ^ rd_ptr            ^ wr_ptr
 	 */
+	DEBUGWRITE(printk(KERN_DEBUG "W d%d c %lu a: %p c: %p\n",
+			  port->port_nbr, count, port->active_tr_descr,
+			  port->catch_tr_descr));
 
 	/* Read variables that may be updated by interrupts */
 	spin_lock_irqsave(&port->lock, flags);
-	count = count > OUT_BUFFER_SIZE - port->out_count ? OUT_BUFFER_SIZE  - port->out_count : count;
-	outp = (unsigned long)port->outp;
-	free_outp = outp + port->out_count;
+	rd_ptr = port->out_rd_ptr;
+	out_buf_count = port->out_buf_count;
 	spin_unlock_irqrestore(&port->lock, flags);
-	out_buffer = (unsigned long)port->out_buffer;
 
-	/* Find out where and how much to write */
-	if (free_outp >= out_buffer + OUT_BUFFER_SIZE)
-		free_outp -= OUT_BUFFER_SIZE;
-	if (free_outp >= outp)
-		c = out_buffer + OUT_BUFFER_SIZE - free_outp;
-	else
-		c = outp - free_outp;
-	if (c > count)
-		c = count;
+	/* Check if resources are available */
+	if (port->tr_running &&
+	    ((port->use_dma && port->active_tr_descr == port->catch_tr_descr) ||
+	     out_buf_count >= OUT_BUFFER_SIZE)) {
+		DEBUGWRITE(printk(KERN_DEBUG "sser%d full\n", dev));
+		return -EAGAIN;
+	}
+
+	buf_stop_ptr = port->out_buffer + OUT_BUFFER_SIZE;
+
+	/* Determine pointer to the first free byte, before copying. */
+	wr_ptr = rd_ptr + out_buf_count;
+	if (wr_ptr >= buf_stop_ptr)
+		wr_ptr -= OUT_BUFFER_SIZE;
+
+	/* If we wrap the ring buffer, let the user space program handle it by
+	 * truncating the data. This could be more elegant, small buffer
+	 * fragments may occur.
+	 */
+	bytes_free = OUT_BUFFER_SIZE - out_buf_count;
+	if (wr_ptr + bytes_free > buf_stop_ptr)
+		bytes_free = buf_stop_ptr - wr_ptr;
+	trunc_count = (count < bytes_free) ? count : bytes_free;
 
-//	DEBUGWRITE(printk("w op %08lX fop %08lX c %lu\n", outp, free_outp, c));
-	if (copy_from_user((void*)free_outp, buf, c))
+	if (copy_from_user(wr_ptr, buf, trunc_count))
 		return -EFAULT;
 
-	if (c != count) {
-		buf += c;
-		c1 = count - c;
-		DEBUGWRITE(printk("w2 fi %lu c %lu c1 %lu\n", free_outp-out_buffer, c, c1));
-		if (copy_from_user((void*)out_buffer, buf, c1))
-			return -EFAULT;
-	}
-	spin_lock_irqsave(&port->lock, flags);
-	port->out_count += count;
-	spin_unlock_irqrestore(&port->lock, flags);
+	DEBUGOUTBUF(printk(KERN_DEBUG "%-4d + %-4d = %-4d     %p %p %p\n",
+			   out_buf_count, trunc_count,
+			   port->out_buf_count, port->out_buffer,
+			   wr_ptr, buf_stop_ptr));
 
 	/* Make sure transmitter/receiver is running */
-	if (!port->started)
-	{
+	if (!port->started) {
 		reg_sser_rw_cfg cfg = REG_RD(sser, port->regi_sser, rw_cfg);
-		reg_sser_rw_tr_cfg tr_cfg = REG_RD(sser, port->regi_sser, rw_tr_cfg);
 		reg_sser_rw_rec_cfg rec_cfg = REG_RD(sser, port->regi_sser, rw_rec_cfg);
 		cfg.en = regk_sser_yes;
-		tr_cfg.tr_en = port->output;
 		rec_cfg.rec_en = port->input;
 		REG_WR(sser, port->regi_sser, rw_cfg, cfg);
-		REG_WR(sser, port->regi_sser, rw_tr_cfg, tr_cfg);
 		REG_WR(sser, port->regi_sser, rw_rec_cfg, rec_cfg);
 		port->started = 1;
 	}
 
-	if (file->f_flags & O_NONBLOCK)	{
-		spin_lock_irqsave(&port->lock, flags);
-		if (!port->tr_running) {
-			if (!port->use_dma) {
-				reg_sser_rw_intr_mask intr_mask;
-				intr_mask = REG_RD(sser, port->regi_sser, rw_intr_mask);
-				/* Start sender by writing data */
-				send_word(port);
-				/* and enable transmitter ready IRQ */
-				intr_mask.trdy = 1;
-				REG_WR(sser, port->regi_sser, rw_intr_mask, intr_mask);
-			} else {
-				start_dma(port, (unsigned char* volatile )port->outp, c);
-			}
-		}
-		spin_unlock_irqrestore(&port->lock, flags);
-		DEBUGWRITE(printk("w d%d c %lu NB\n",
-				  port->port_nbr, count));
-		return count;
+	/* Setup wait if blocking */
+	if (!(file->f_flags & O_NONBLOCK)) {
+		add_wait_queue(&port->out_wait_q, &wait);
+		set_current_state(TASK_INTERRUPTIBLE);
 	}
 
-	/* Sleep until all sent */
-
-	add_wait_queue(&port->out_wait_q, &wait);
-	set_current_state(TASK_INTERRUPTIBLE);
 	spin_lock_irqsave(&port->lock, flags);
-	if (!port->tr_running) {
-		if (!port->use_dma) {
-			reg_sser_rw_intr_mask intr_mask;
-			intr_mask = REG_RD(sser, port->regi_sser, rw_intr_mask);
-			/* Start sender by writing data */
-			send_word(port);
-			/* and enable transmitter ready IRQ */
-			intr_mask.trdy = 1;
-			REG_WR(sser, port->regi_sser, rw_intr_mask, intr_mask);
-		} else {
-			start_dma(port, port->outp, c);
-		}
+	port->out_buf_count += trunc_count;
+	if (port->use_dma) {
+		start_dma_out(port, wr_ptr, trunc_count);
+	} else if (!port->tr_running) {
+		reg_sser_rw_intr_mask intr_mask;
+		intr_mask = REG_RD(sser, port->regi_sser, rw_intr_mask);
+		/* Start sender by writing data */
+		send_word(port);
+		/* and enable transmitter ready IRQ */
+		intr_mask.trdy = 1;
+		REG_WR(sser, port->regi_sser, rw_intr_mask, intr_mask);
 	}
 	spin_unlock_irqrestore(&port->lock, flags);
+
+	/* Exit if non blocking */
+	if (file->f_flags & O_NONBLOCK) {
+		DEBUGWRITE(printk(KERN_DEBUG "w d%d c %lu  %08x\n",
+				  port->port_nbr, trunc_count,
+				  REG_RD_INT(dma, port->regi_dmaout, r_intr)));
+		return trunc_count;
+	}
+
 	schedule();
 	set_current_state(TASK_RUNNING);
 	remove_wait_queue(&port->out_wait_q, &wait);
+
 	if (signal_pending(current))
-	{
 		return -EINTR;
 	}
-	DEBUGWRITE(printk("w d%d c %lu\n", port->port_nbr, count));
-	return count;
+	DEBUGWRITE(printk(KERN_DEBUG "w d%d c %lu\n",
+			  port->port_nbr, trunc_count));
+	return trunc_count;
 }
 
 static ssize_t sync_serial_read(struct file * file, char * buf,
@@ -926,7 +1093,7 @@ static ssize_t sync_serial_read(struct file * file, char * buf,
 	unsigned char* end;
 	unsigned long flags;
 
-	if (dev < 0 || dev >= NUMBER_OF_PORTS || !ports[dev].enabled)
+	if (dev < 0 || dev >= NBR_PORTS || !ports[dev].enabled)
 	{
 		DEBUG(printk("Invalid minor %d\n", dev));
 		return -ENODEV;
@@ -949,7 +1116,6 @@ static ssize_t sync_serial_read(struct file * file, char * buf,
 		port->started = 1;
 	}
 
-
 	/* Calculate number of available bytes */
 	/* Save pointers to avoid that they are modified by interrupt */
 	spin_lock_irqsave(&port->lock, flags);
@@ -958,16 +1124,14 @@ static ssize_t sync_serial_read(struct file * file, char * buf,
 	spin_unlock_irqrestore(&port->lock, flags);
 	while ((start == end) && !port->full) /* No data */
 	{
+		DEBUGREAD(printk(KERN_DEBUG "&"));
 		if (file->f_flags & O_NONBLOCK)
-		{
 			return -EAGAIN;
-		}
 
 		interruptible_sleep_on(&port->in_wait_q);
 		if (signal_pending(current))
-		{
 			return -EINTR;
-		}
+
 		spin_lock_irqsave(&port->lock, flags);
 		start = (unsigned char*)port->readp; /* cast away volatile */
 		end = (unsigned char*)port->writep;  /* cast away volatile */
@@ -1004,83 +1168,105 @@ static void send_word(sync_port* port)
 	switch(tr_cfg.sample_size)
 	{
 	 case 8:
-		 port->out_count--;
-		 tr_data.data = *port->outp++;
+		 port->out_buf_count--;
+		 tr_data.data = *port->out_rd_ptr++;
 		 REG_WR(sser, port->regi_sser, rw_tr_data, tr_data);
-		 if (port->outp >= port->out_buffer + OUT_BUFFER_SIZE)
-			 port->outp = port->out_buffer;
+		 if (port->out_rd_ptr >= port->out_buffer + OUT_BUFFER_SIZE)
+			 port->out_rd_ptr = port->out_buffer;
 		 break;
 	 case 12:
 	 {
-		int data = (*port->outp++) << 8;
-		data |= *port->outp++;
-		port->out_count-=2;
+		int data = (*port->out_rd_ptr++) << 8;
+		data |= *port->out_rd_ptr++;
+		port->out_buf_count -= 2;
 		tr_data.data = data;
 		REG_WR(sser, port->regi_sser, rw_tr_data, tr_data);
-		if (port->outp >= port->out_buffer + OUT_BUFFER_SIZE)
-			port->outp = port->out_buffer;
+		if (port->out_rd_ptr >= port->out_buffer + OUT_BUFFER_SIZE)
+			port->out_rd_ptr = port->out_buffer;
 	}
 	break;
 	case 16:
-		port->out_count-=2;
-		tr_data.data = *(unsigned short *)port->outp;
+		port->out_buf_count -= 2;
+		tr_data.data = *(unsigned short *)port->out_rd_ptr;
 		REG_WR(sser, port->regi_sser, rw_tr_data, tr_data);
-		port->outp+=2;
-		if (port->outp >= port->out_buffer + OUT_BUFFER_SIZE)
-			port->outp = port->out_buffer;
+		port->out_rd_ptr += 2;
+		if (port->out_rd_ptr >= port->out_buffer + OUT_BUFFER_SIZE)
+			port->out_rd_ptr = port->out_buffer;
 		break;
 	case 24:
-		port->out_count-=3;
-		tr_data.data = *(unsigned short *)port->outp;
+		port->out_buf_count -= 3;
+		tr_data.data = *(unsigned short *)port->out_rd_ptr;
 		REG_WR(sser, port->regi_sser, rw_tr_data, tr_data);
-		port->outp+=2;
-		tr_data.data = *port->outp++;
+		port->out_rd_ptr += 2;
+		tr_data.data = *port->out_rd_ptr++;
 		REG_WR(sser, port->regi_sser, rw_tr_data, tr_data);
-		if (port->outp >= port->out_buffer + OUT_BUFFER_SIZE)
-			port->outp = port->out_buffer;
+		if (port->out_rd_ptr >= port->out_buffer + OUT_BUFFER_SIZE)
+			port->out_rd_ptr = port->out_buffer;
 		break;
 	case 32:
-		port->out_count-=4;
-		tr_data.data = *(unsigned short *)port->outp;
+		port->out_buf_count -= 4;
+		tr_data.data = *(unsigned short *)port->out_rd_ptr;
 		REG_WR(sser, port->regi_sser, rw_tr_data, tr_data);
-		port->outp+=2;
-		tr_data.data = *(unsigned short *)port->outp;
+		port->out_rd_ptr += 2;
+		tr_data.data = *(unsigned short *)port->out_rd_ptr;
 		REG_WR(sser, port->regi_sser, rw_tr_data, tr_data);
-		port->outp+=2;
-		if (port->outp >= port->out_buffer + OUT_BUFFER_SIZE)
-			port->outp = port->out_buffer;
+		port->out_rd_ptr += 2;
+		if (port->out_rd_ptr >= port->out_buffer + OUT_BUFFER_SIZE)
+			port->out_rd_ptr = port->out_buffer;
 		break;
 	}
 }
 
-
-static void start_dma(struct sync_port* port, const char* data, int count)
+static void start_dma_out(struct sync_port *port,
+			  const char *data, int count)
 {
-	port->tr_running = 1;
-	port->out_descr.buf = (char*)virt_to_phys((char*)data);
-	port->out_descr.after = port->out_descr.buf + count;
-	port->out_descr.eol = port->out_descr.intr = 1;
+	port->active_tr_descr->buf = (char *) virt_to_phys((char *) data);
+	port->active_tr_descr->after = port->active_tr_descr->buf + count;
+	port->active_tr_descr->intr = 1;
+
+	port->active_tr_descr->eol = 1;
+	port->prev_tr_descr->eol = 0;
+
+	DEBUGTRDMA(printk(KERN_DEBUG "Inserting eolr:%p eol@:%p\n",
+		port->prev_tr_descr, port->active_tr_descr));
+	port->prev_tr_descr = port->active_tr_descr;
+	port->active_tr_descr = phys_to_virt((int) port->active_tr_descr->next);
+
+	if (!port->tr_running) {
+		reg_sser_rw_tr_cfg tr_cfg = REG_RD(sser, port->regi_sser,
+			rw_tr_cfg);
 
-	port->out_context.saved_data = (dma_descr_data*)virt_to_phys(&port->out_descr);
-	port->out_context.saved_data_buf = port->out_descr.buf;
+		port->out_context.next = 0;
+		port->out_context.saved_data =
+			(dma_descr_data *)virt_to_phys(port->prev_tr_descr);
+		port->out_context.saved_data_buf = port->prev_tr_descr->buf;
+
+		DMA_START_CONTEXT(port->regi_dmaout,
+			virt_to_phys((char *)&port->out_context));
+
+		tr_cfg.tr_en = regk_sser_yes;
+		REG_WR(sser, port->regi_sser, rw_tr_cfg, tr_cfg);
+		DEBUGTRDMA(printk(KERN_DEBUG "dma s\n"););
+	} else {
+		DMA_CONTINUE_DATA(port->regi_dmaout);
+		DEBUGTRDMA(printk(KERN_DEBUG "dma c\n"););
+	}
 
-	DMA_START_CONTEXT(port->regi_dmaout, virt_to_phys((char*)&port->out_context));
-	DEBUGTXINT(printk("dma %08lX c %d\n", (unsigned long)data, count));
+	port->tr_running = 1;
 }
 
-static void start_dma_in(sync_port* port)
+static void start_dma_in(sync_port *port)
 {
 	int i;
-	char* buf;
+	char *buf;
 	port->writep = port->flip;
 
-	if (port->writep > port->flip + port->in_buffer_size)
-	{
+	if (port->writep > port->flip + port->in_buffer_size) {
 		panic("Offset too large in sync serial driver\n");
 		return;
 	}
 	buf = (char*)virt_to_phys(port->in_buffer);
-	for (i = 0; i < NUM_IN_DESCR; i++) {
+	for (i = 0; i < NBR_IN_DESCR; i++) {
 		port->in_descr[i].buf = buf;
 		port->in_descr[i].after = buf + port->inbufchunk;
 		port->in_descr[i].intr = 1;
@@ -1092,59 +1278,126 @@ static void start_dma_in(sync_port* port)
 	port->in_descr[i-1].next = (dma_descr_data*)virt_to_phys(&port->in_descr[0]);
 	port->in_descr[i-1].eol = regk_sser_yes;
 	port->next_rx_desc = &port->in_descr[0];
-	port->prev_rx_desc = &port->in_descr[NUM_IN_DESCR - 1];
+	port->prev_rx_desc = &port->in_descr[NBR_IN_DESCR - 1];
 	port->in_context.saved_data = (dma_descr_data*)virt_to_phys(&port->in_descr[0]);
 	port->in_context.saved_data_buf = port->in_descr[0].buf;
 	DMA_START_CONTEXT(port->regi_dmain, virt_to_phys(&port->in_context));
 }
 
 #ifdef SYNC_SER_DMA
-static irqreturn_t tr_interrupt(int irq, void *dev_id, struct pt_regs * regs)
+static irqreturn_t tr_interrupt(int irq, void *dev_id)
 {
 	reg_dma_r_masked_intr masked;
 	reg_dma_rw_ack_intr ack_intr = {.data = regk_dma_yes};
+	reg_dma_rw_stat stat;
 	int i;
-	struct dma_descr_data *descr;
-	unsigned int sentl;
 	int found = 0;
+	int stop_sser = 0;
 
-	for (i = 0; i < NUMBER_OF_PORTS; i++)
-	{
+	for (i = 0; i < NBR_PORTS; i++) {
 		sync_port *port = &ports[i];
-		if (!port->enabled  || !port->use_dma )
+		if (!port->enabled  || !port->use_dma)
 			continue;
 
+		/* IRQ active for the port? */
 		masked = REG_RD(dma, port->regi_dmaout, r_masked_intr);
+		if (!masked.data)
+			continue;
 
-		if (masked.data) /* IRQ active for the port? */
-		{
-			found = 1;
-			/* Clear IRQ */
-			REG_WR(dma, port->regi_dmaout, rw_ack_intr, ack_intr);
-			descr = &port->out_descr;
-			sentl = descr->after - descr->buf;
-			port->out_count -= sentl;
-			port->outp += sentl;
-			if (port->outp >= port->out_buffer + OUT_BUFFER_SIZE)
-				port->outp = port->out_buffer;
-			if (port->out_count)  {
-				int c;
-				c = port->out_buffer + OUT_BUFFER_SIZE - port->outp;
-				if (c > port->out_count)
-					c = port->out_count;
-				DEBUGTXINT(printk("tx_int DMAWRITE %i %i\n", sentl, c));
-				start_dma(port, port->outp, c);
-			} else  {
-				DEBUGTXINT(printk("tx_int DMA stop %i\n", sentl));
-				port->tr_running = 0;
+		found = 1;
+
+		/* Check if we should stop the DMA transfer */
+		stat = REG_RD(dma, port->regi_dmaout, rw_stat);
+		if (stat.list_state == regk_dma_data_at_eol)
+			stop_sser = 1;
+
+		/* Clear IRQ */
+		REG_WR(dma, port->regi_dmaout, rw_ack_intr, ack_intr);
+
+		if (!stop_sser) {
+			/* The DMA has completed a descriptor, EOL was not
+			 * encountered, so step relevant descriptor and
+			 * datapointers forward. */
+			int sent;
+			sent = port->catch_tr_descr->after -
+				port->catch_tr_descr->buf;
+			DEBUGTXINT(printk(KERN_DEBUG "%-4d - %-4d = %-4d\t"
+					  "in descr %p (ac: %p)\n",
+					  port->out_buf_count, sent,
+					  port->out_buf_count - sent,
+					  port->catch_tr_descr,
+					  port->active_tr_descr););
+			port->out_buf_count -= sent;
+			port->catch_tr_descr =
+				phys_to_virt((int) port->catch_tr_descr->next);
+			port->out_rd_ptr =
+				phys_to_virt((int) port->catch_tr_descr->buf);
+		} else {
+			int i, sent;
+			/* EOL handler.
+			 * Note that if an EOL was encountered during the irq
+			 * locked section of sync_ser_write the DMA will be
+			 * restarted and the eol flag will be cleared.
+			 * The remaining descriptors will be traversed by
+			 * the descriptor interrupts as usual.
+			 */
+			i = 0;
+			while (!port->catch_tr_descr->eol) {
+				sent = port->catch_tr_descr->after -
+					port->catch_tr_descr->buf;
+				DEBUGOUTBUF(printk(KERN_DEBUG
+					"traversing descr %p -%d (%d)\n",
+					port->catch_tr_descr,
+					sent,
+					port->out_buf_count));
+				port->out_buf_count -= sent;
+				port->catch_tr_descr = phys_to_virt(
+					(int)port->catch_tr_descr->next);
+				i++;
+				if (i >= NBR_OUT_DESCR) {
+					/* TODO: Reset and recover */
+					panic("sync_serial: missing eol");
+				}
 			}
-			wake_up_interruptible(&port->out_wait_q); /* wake up the waiting process */
+			sent = port->catch_tr_descr->after -
+				port->catch_tr_descr->buf;
+			DEBUGOUTBUF(printk(KERN_DEBUG
+				"eol at descr %p -%d (%d)\n",
+				port->catch_tr_descr,
+				sent,
+				port->out_buf_count));
+
+			port->out_buf_count -= sent;
+
+			/* Update read pointer to first free byte, we
+			 * may already be writing data there. */
+			port->out_rd_ptr =
+				phys_to_virt((int) port->catch_tr_descr->after);
+			if (port->out_rd_ptr > port->out_buffer +
+					OUT_BUFFER_SIZE)
+				port->out_rd_ptr = port->out_buffer;
+
+			reg_sser_rw_tr_cfg tr_cfg =
+				REG_RD(sser, port->regi_sser, rw_tr_cfg);
+			DEBUGTXINT(printk(KERN_DEBUG
+				"tr_int DMA stop %d, set catch @ %p\n",
+				port->out_buf_count,
+				port->active_tr_descr));
+			if (port->out_buf_count != 0)
+				printk(KERN_CRIT "sync_ser: buffer not "
+					"empty after eol.\n");
+			port->catch_tr_descr = port->active_tr_descr;
+			port->tr_running = 0;
+			tr_cfg.tr_en = regk_sser_no;
+			REG_WR(sser, port->regi_sser, rw_tr_cfg, tr_cfg);
 		}
+		/* wake up the waiting process */
+		wake_up_interruptible(&port->out_wait_q);
 	}
 	return IRQ_RETVAL(found);
 } /* tr_interrupt */
 
-static irqreturn_t rx_interrupt(int irq, void *dev_id, struct pt_regs * regs)
+static irqreturn_t rx_interrupt(int irq, void *dev_id)
 {
 	reg_dma_r_masked_intr masked;
 	reg_dma_rw_ack_intr ack_intr = {.data = regk_dma_yes};
@@ -1152,7 +1405,7 @@ static irqreturn_t rx_interrupt(int irq, void *dev_id, struct pt_regs * regs)
 	int i;
 	int found = 0;
 
-	for (i = 0; i < NUMBER_OF_PORTS; i++)
+	for (i = 0; i < NBR_PORTS; i++)
 	{
 		sync_port *port = &ports[i];
 
@@ -1166,7 +1419,7 @@ static irqreturn_t rx_interrupt(int irq, void *dev_id, struct pt_regs * regs)
 			found = 1;
 			while (REG_RD(dma, port->regi_dmain, rw_data) !=
 			       virt_to_phys(port->next_rx_desc)) {
-
+				DEBUGRXINT(printk(KERN_DEBUG "!"));
 				if (port->writep + port->inbufchunk > port->flip + port->in_buffer_size) {
 					int first_size = port->flip + port->in_buffer_size - port->writep;
 					memcpy((char*)port->writep, phys_to_virt((unsigned)port->next_rx_desc->buf), first_size);
@@ -1185,11 +1438,16 @@ static irqreturn_t rx_interrupt(int irq, void *dev_id, struct pt_regs * regs)
 				  port->full = 1;
                                 }
 
-				port->next_rx_desc->eol = 0;
-				port->prev_rx_desc->eol = 1;
-				port->prev_rx_desc = phys_to_virt((unsigned)port->next_rx_desc);
+				port->next_rx_desc->eol = 1;
+				port->prev_rx_desc->eol = 0;
+				/* Cache bug workaround */
+				flush_dma_descr(port->prev_rx_desc, 0);
+				port->prev_rx_desc = port->next_rx_desc;
 				port->next_rx_desc = phys_to_virt((unsigned)port->next_rx_desc->next);
-				wake_up_interruptible(&port->in_wait_q); /* wake up the waiting process */
+				/* Cache bug workaround */
+				flush_dma_descr(port->prev_rx_desc, 1);
+				/* wake up the waiting process */
+				wake_up_interruptible(&port->in_wait_q);
 				DMA_CONTINUE(port->regi_dmain);
 				REG_WR(dma, port->regi_dmain, rw_ack_intr, ack_intr);
 
@@ -1201,15 +1459,15 @@ static irqreturn_t rx_interrupt(int irq, void *dev_id, struct pt_regs * regs)
 #endif /* SYNC_SER_DMA */
 
 #ifdef SYNC_SER_MANUAL
-static irqreturn_t manual_interrupt(int irq, void *dev_id, struct pt_regs * regs)
+static irqreturn_t manual_interrupt(int irq, void *dev_id)
 {
 	int i;
 	int found = 0;
 	reg_sser_r_masked_intr masked;
 
-	for (i = 0; i < NUMBER_OF_PORTS; i++)
+	for (i = 0; i < NBR_PORTS; i++)
 	{
-		sync_port* port = &ports[i];
+		sync_port *port = &ports[i];
 
 		if (!port->enabled || port->use_dma)
 		{
@@ -1263,7 +1521,7 @@ static irqreturn_t manual_interrupt(int irq, void *dev_id, struct pt_regs * regs
 		if (masked.trdy) /* Transmitter ready? */
 		{
 			found = 1;
-			if (port->out_count > 0) /* More data to send */
+			if (port->out_buf_count > 0) /* More data to send */
 				send_word(port);
 			else /* transmission finished */
 			{
-- 
1.5.3.6.970.gd25430

