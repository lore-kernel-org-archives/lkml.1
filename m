Return-Path: <linux-kernel-owner+w=401wt.eu-S1755643AbYDRXYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643AbYDRXYq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 19:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753771AbYDRXXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 19:23:03 -0400
Received: from havoc.gtf.org ([69.61.125.42]:46376 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752529AbYDRXWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 19:22:52 -0400
Message-Id: <e3b010fa8e3bc3a5e386759f01f69c80918923e7.1208559659.git.jgarzik@redhat.com>
In-Reply-To: <d7afbccda111e535bb14ad8082b208c7a2cd9833.1208559659.git.jgarzik@redhat.com>
References: <d7afbccda111e535bb14ad8082b208c7a2cd9833.1208559659.git.jgarzik@redhat.com>
To: alan@redhat.com, R.E.Wolff@BitWizard.nl
From: Jeff Garzik <jeff@garzik.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 05/15] drivers/char: minor irq handler cleanups
Date: Fri, 18 Apr 2008 19:22:51 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- remove always-false tests

- don't overload 'irq' argument, pass data properly via dev_id

- remove pointless casts from void*

- make polled uses of irq handling (where code calls irq handler
  directly) more plain, by splitting polled and non-polled irq handling
  work.  This quite often results in a more-efficient irq handler.

This change's main purpose is to prepare for the patchset in
jgarzik/misc-2.6.git#irq-remove, that explores removal of the
never-used 'irq' argument in each interrupt handler.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
 drivers/char/cyclades.c           |   17 +----------------
 drivers/char/mwave/tp3780i.c      |   14 ++++++++++----
 drivers/char/pcmcia/synclink_cs.c |   10 ++++------
 drivers/char/rio/rio_linux.c      |   23 +++++++++++++----------
 drivers/char/specialix.c          |   10 ++++------
 drivers/char/stallion.c           |    2 +-
 drivers/char/sx.c                 |   22 ++++++++++++++--------
 drivers/char/synclink.c           |   21 +++++++++------------
 drivers/char/synclink_gt.c        |   13 ++++---------
 drivers/char/synclinkmp.c         |   22 +++++++++-------------
 drivers/char/tpm/tpm_tis.c        |    2 +-
 11 files changed, 70 insertions(+), 86 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index e4f579c..823e169 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -1318,13 +1318,6 @@ static irqreturn_t cyy_interrupt(int irq, void *dev_id)
 	unsigned int chip, too_many, had_work;
 	int index;
 
-	if (unlikely(cinfo == NULL)) {
-#ifdef CY_DEBUG_INTERRUPTS
-		printk(KERN_DEBUG "cyy_interrupt: spurious interrupt %d\n",irq);
-#endif
-		return IRQ_NONE;	/* spurious interrupt */
-	}
-
 	card_base_addr = cinfo->base_addr;
 	index = cinfo->bus_index;
 
@@ -1730,17 +1723,9 @@ static irqreturn_t cyz_interrupt(int irq, void *dev_id)
 {
 	struct cyclades_card *cinfo = dev_id;
 
-	if (unlikely(cinfo == NULL)) {
-#ifdef CY_DEBUG_INTERRUPTS
-		printk(KERN_DEBUG "cyz_interrupt: spurious interrupt %d\n",irq);
-#endif
-		return IRQ_NONE;	/* spurious interrupt */
-	}
-
 	if (unlikely(!ISZLOADED(*cinfo))) {
 #ifdef CY_DEBUG_INTERRUPTS
-		printk(KERN_DEBUG "cyz_interrupt: board not yet loaded "
-				"(IRQ%d).\n", irq);
+		printk(KERN_DEBUG "cyz_interrupt: board not yet loaded\n");
 #endif
 		return IRQ_NONE;
 	}
diff --git a/drivers/char/mwave/tp3780i.c b/drivers/char/mwave/tp3780i.c
index f282976..37fe80d 100644
--- a/drivers/char/mwave/tp3780i.c
+++ b/drivers/char/mwave/tp3780i.c
@@ -97,20 +97,24 @@ static void EnableSRAM(THINKPAD_BD_DATA * pBDData)
 
 static irqreturn_t UartInterrupt(int irq, void *dev_id)
 {
+	int irqno = (int)(unsigned long) dev_id;
+
 	PRINTK_3(TRACE_TP3780I,
-		"tp3780i::UartInterrupt entry irq %x dev_id %p\n", irq, dev_id);
+		"tp3780i::UartInterrupt entry irq %x dev_id %p\n", irqno, dev_id);
 	return IRQ_HANDLED;
 }
 
 static irqreturn_t DspInterrupt(int irq, void *dev_id)
 {
+	int irqno = (int)(unsigned long) dev_id;
+
 	pMWAVE_DEVICE_DATA pDrvData = &mwave_s_mdd;
 	DSP_3780I_CONFIG_SETTINGS *pSettings = &pDrvData->rBDData.rDspSettings;
 	unsigned short usDspBaseIO = pSettings->usDspBaseIO;
 	unsigned short usIPCSource = 0, usIsolationMask, usPCNum;
 
 	PRINTK_3(TRACE_TP3780I,
-		"tp3780i::DspInterrupt entry irq %x dev_id %p\n", irq, dev_id);
+		"tp3780i::DspInterrupt entry irq %x dev_id %p\n", irqno, dev_id);
 
 	if (dsp3780I_GetIPCSource(usDspBaseIO, &usIPCSource) == 0) {
 		PRINTK_2(TRACE_TP3780I,
@@ -361,14 +365,16 @@ int tp3780I_EnableDSP(THINKPAD_BD_DATA * pBDData)
 	pSettings->bPllBypass = TP_CFG_PllBypass;
 	pSettings->usChipletEnable = TP_CFG_ChipletEnable;
 
-	if (request_irq(pSettings->usUartIrq, &UartInterrupt, 0, "mwave_uart", NULL)) {
+	if (request_irq(pSettings->usUartIrq, &UartInterrupt, 0, "mwave_uart",
+			(void *)(unsigned long) pSettings->usUartIrq)) {
 		PRINTK_ERROR(KERN_ERR_MWAVE "tp3780i::tp3780I_EnableDSP: Error: Could not get UART IRQ %x\n", pSettings->usUartIrq);
 		goto exit_cleanup;
 	} else {		/* no conflict just release */
 		free_irq(pSettings->usUartIrq, NULL);
 	}
 
-	if (request_irq(pSettings->usDspIrq, &DspInterrupt, 0, "mwave_3780i", NULL)) {
+	if (request_irq(pSettings->usDspIrq, &DspInterrupt, 0, "mwave_3780i",
+			(void *)(unsigned long) pSettings->usDspIrq)) {
 		PRINTK_ERROR("tp3780i::tp3780I_EnableDSP: Error: Could not get 3780i IRQ %x\n", pSettings->usDspIrq);
 		goto exit_cleanup;
 	} else {
diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index 279ff50..4e84d23 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -1225,17 +1225,15 @@ static void ri_change(MGSLPC_INFO *info)
  * irq     interrupt number that caused interrupt
  * dev_id  device ID supplied during interrupt registration
  */
-static irqreturn_t mgslpc_isr(int irq, void *dev_id)
+static irqreturn_t mgslpc_isr(int dummy, void *dev_id)
 {
-	MGSLPC_INFO * info = (MGSLPC_INFO *)dev_id;
+	MGSLPC_INFO *info = dev_id;
 	unsigned short isr;
 	unsigned char gis, pis;
 	int count=0;
 
 	if (debug_level >= DEBUG_LEVEL_ISR)
-		printk("mgslpc_isr(%d) entry.\n", irq);
-	if (!info)
-		return IRQ_NONE;
+		printk("mgslpc_isr(%d) entry.\n", info->irq_level);
 
 	if (!(info->p_dev->_locked))
 		return IRQ_HANDLED;
@@ -1327,7 +1325,7 @@ static irqreturn_t mgslpc_isr(int irq, void *dev_id)
 
 	if (debug_level >= DEBUG_LEVEL_ISR)
 		printk("%s(%d):mgslpc_isr(%d)exit.\n",
-		       __FILE__,__LINE__,irq);
+		       __FILE__, __LINE__, info->irq_level);
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/char/rio/rio_linux.c b/drivers/char/rio/rio_linux.c
index 0ce9667..fb06665 100644
--- a/drivers/char/rio/rio_linux.c
+++ b/drivers/char/rio/rio_linux.c
@@ -362,14 +362,11 @@ static void rio_reset_interrupt(struct Host *HostP)
 	func_exit();
 }
 
-
-static irqreturn_t rio_interrupt(int irq, void *ptr)
+static irqreturn_t __rio_interrupt(struct Host *HostP, bool polled)
 {
-	struct Host *HostP;
 	func_enter();
 
-	HostP = ptr;			/* &p->RIOHosts[(long)ptr]; */
-	rio_dprintk(RIO_DEBUG_IFLOW, "rio: enter rio_interrupt (%d/%d)\n", irq, HostP->Ivec);
+	rio_dprintk(RIO_DEBUG_IFLOW, "rio: enter rio_interrupt (%d)\n", HostP->Ivec);
 
 	/* AAargh! The order in which to do these things is essential and
 	   not trivial.
@@ -389,7 +386,7 @@ static irqreturn_t rio_interrupt(int irq, void *ptr)
 	 */
 
 	rio_dprintk(RIO_DEBUG_IFLOW, "rio: We've have noticed the interrupt\n");
-	if (HostP->Ivec == irq) {
+	if (!polled) {
 		/* Tell the card we've noticed the interrupt. */
 		rio_reset_interrupt(HostP);
 	}
@@ -398,26 +395,32 @@ static irqreturn_t rio_interrupt(int irq, void *ptr)
 		return IRQ_HANDLED;
 
 	if (test_and_set_bit(RIO_BOARD_INTR_LOCK, &HostP->locks)) {
-		printk(KERN_ERR "Recursive interrupt! (host %p/irq%d)\n", ptr, HostP->Ivec);
+		printk(KERN_ERR "Recursive interrupt! (host %p/irq%d)\n",
+		       HostP, HostP->Ivec);
 		return IRQ_HANDLED;
 	}
 
 	RIOServiceHost(p, HostP);
 
-	rio_dprintk(RIO_DEBUG_IFLOW, "riointr() doing host %p type %d\n", ptr, HostP->Type);
+	rio_dprintk(RIO_DEBUG_IFLOW, "riointr() doing host %p type %d\n",
+		    HostP, HostP->Type);
 
 	clear_bit(RIO_BOARD_INTR_LOCK, &HostP->locks);
-	rio_dprintk(RIO_DEBUG_IFLOW, "rio: exit rio_interrupt (%d/%d)\n", irq, HostP->Ivec);
+	rio_dprintk(RIO_DEBUG_IFLOW, "rio: exit rio_interrupt (%d)\n", HostP->Ivec);
 	func_exit();
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t rio_interrupt(int dummy, void *ptr)
+{
+	return __rio_interrupt(ptr, false);
+}
 
 static void rio_pollfunc(unsigned long data)
 {
 	func_enter();
 
-	rio_interrupt(0, &p->RIOHosts[data]);
+	__rio_interrupt(&p->RIOHosts[data], true);
 	mod_timer(&p->RIOHosts[data].timer, jiffies + rio_poll);
 
 	func_exit();
diff --git a/drivers/char/specialix.c b/drivers/char/specialix.c
index 5ff83df..4b5b5b7 100644
--- a/drivers/char/specialix.c
+++ b/drivers/char/specialix.c
@@ -443,8 +443,7 @@ void missed_irq (unsigned long data)
 	spin_unlock_irqrestore(&bp->lock, flags);
 	if (irq) {
 		printk (KERN_INFO "Missed interrupt... Calling int from timer. \n");
-		sx_interrupt (((struct specialix_board *)data)->irq,
-				(void*)data);
+		sx_interrupt (-1, bp);
 	}
 	mod_timer(&missed_irq_timer, jiffies + sx_poll);
 }
@@ -862,23 +861,22 @@ static inline void sx_check_modem(struct specialix_board * bp)
 
 
 /* The main interrupt processing routine */
-static irqreturn_t sx_interrupt(int irq, void *dev_id)
+static irqreturn_t sx_interrupt(int dummy, void *dev_id)
 {
 	unsigned char status;
 	unsigned char ack;
-	struct specialix_board *bp;
+	struct specialix_board *bp = dev_id;
 	unsigned long loop = 0;
 	int saved_reg;
 	unsigned long flags;
 
 	func_enter();
 
-	bp = dev_id;
 	spin_lock_irqsave(&bp->lock, flags);
 
 	dprintk (SX_DEBUG_FLOW, "enter %s port %d room: %ld\n", __FUNCTION__, port_No(sx_get_port(bp, "INT")), SERIAL_XMIT_SIZE - sx_get_port(bp, "ITN")->xmit_cnt - 1);
 	if (!(bp->flags & SX_BOARD_ACTIVE)) {
-		dprintk (SX_DEBUG_IRQ, "sx: False interrupt. irq %d.\n", irq);
+		dprintk (SX_DEBUG_IRQ, "sx: False interrupt. irq %d.\n", bp->irq);
 		spin_unlock_irqrestore(&bp->lock, flags);
 		func_exit();
 		return IRQ_NONE;
diff --git a/drivers/char/stallion.c b/drivers/char/stallion.c
index feac54e..874aaa0 100644
--- a/drivers/char/stallion.c
+++ b/drivers/char/stallion.c
@@ -1645,7 +1645,7 @@ static irqreturn_t stl_intr(int irq, void *dev_id)
 {
 	struct stlbrd *brdp = dev_id;
 
-	pr_debug("stl_intr(brdp=%p,irq=%d)\n", brdp, irq);
+	pr_debug("stl_intr(brdp=%p,irq=%d)\n", brdp, brdp->irq);
 
 	return IRQ_RETVAL((* brdp->isr)(brdp));
 }
diff --git a/drivers/char/sx.c b/drivers/char/sx.c
index a6e1c9b..ae9e973 100644
--- a/drivers/char/sx.c
+++ b/drivers/char/sx.c
@@ -1241,15 +1241,13 @@ static inline void sx_check_modem_signals(struct sx_port *port)
  * Small, elegant, clear.
  */
 
-static irqreturn_t sx_interrupt(int irq, void *ptr)
+static irqreturn_t __sx_interrupt(struct sx_board *board, bool polled)
 {
-	struct sx_board *board = ptr;
 	struct sx_port *port;
 	int i;
 
 	func_enter();
-	sx_dprintk(SX_DEBUG_FLOW, "sx: enter sx_interrupt (%d/%d)\n", irq,
-			board->irq);
+	sx_dprintk(SX_DEBUG_FLOW, "sx: enter sx_interrupt (%d)\n", board->irq);
 
 	/* AAargh! The order in which to do these things is essential and
 	   not trivial. 
@@ -1281,6 +1279,10 @@ static irqreturn_t sx_interrupt(int irq, void *ptr)
 
 		if (lastjif == jiffies) {
 			if (++nintr > IRQ_RATE_LIMIT) {
+				/*
+				 * FIXME: free_irq() inside irq handler
+				 * is unwise
+				 */
 				free_irq(board->irq, board);
 				printk(KERN_ERR "sx: Too many interrupts. "
 						"Turning off interrupt %d.\n",
@@ -1293,7 +1295,7 @@ static irqreturn_t sx_interrupt(int irq, void *ptr)
 	}
 #endif
 
-	if (board->irq == irq) {
+	if (!polled) {
 		/* Tell the card we've noticed the interrupt. */
 
 		sx_write_board_word(board, cc_int_pending, 0);
@@ -1339,19 +1341,23 @@ static irqreturn_t sx_interrupt(int irq, void *ptr)
 
 	clear_bit(SX_BOARD_INTR_LOCK, &board->locks);
 
-	sx_dprintk(SX_DEBUG_FLOW, "sx: exit sx_interrupt (%d/%d)\n", irq,
-			board->irq);
+	sx_dprintk(SX_DEBUG_FLOW, "sx: exit sx_interrupt (%d)\n", board->irq);
 	func_exit();
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t sx_interrupt(int dummy, void *data)
+{
+	return __sx_interrupt(data, false);
+}
+
 static void sx_pollfunc(unsigned long data)
 {
 	struct sx_board *board = (struct sx_board *)data;
 
 	func_enter();
 
-	sx_interrupt(0, board);
+	__sx_interrupt(board, true);
 
 	mod_timer(&board->timer, jiffies + sx_poll);
 	func_exit();
diff --git a/drivers/char/synclink.c b/drivers/char/synclink.c
index ddc74d1..a3237d4 100644
--- a/drivers/char/synclink.c
+++ b/drivers/char/synclink.c
@@ -1695,20 +1695,16 @@ static void mgsl_isr_transmit_dma( struct mgsl_struct *info )
  * 	
  * Return Value: None
  */
-static irqreturn_t mgsl_interrupt(int irq, void *dev_id)
+static irqreturn_t mgsl_interrupt(int dummy, void *dev_id)
 {
-	struct mgsl_struct * info;
+	struct mgsl_struct *info = dev_id;
 	u16 UscVector;
 	u16 DmaVector;
 
 	if ( debug_level >= DEBUG_LEVEL_ISR )	
-		printk("%s(%d):mgsl_interrupt(%d)entry.\n",
-			__FILE__,__LINE__,irq);
+		printk(KERN_DEBUG "%s(%d):mgsl_interrupt(%d)entry.\n",
+			__FILE__, __LINE__, info->irq_level);
 
-	info = (struct mgsl_struct *)dev_id;	
-	if (!info)
-		return IRQ_NONE;
-		
 	spin_lock(&info->irq_spinlock);
 
 	for(;;) {
@@ -1732,8 +1728,8 @@ static irqreturn_t mgsl_interrupt(int irq, void *dev_id)
 			mgsl_isr_receive_dma(info);
 
 		if ( info->isr_overflow ) {
-			printk(KERN_ERR"%s(%d):%s isr overflow irq=%d\n",
-				__FILE__,__LINE__,info->device_name, irq);
+			printk(KERN_ERR "%s(%d):%s isr overflow irq=%d\n",
+				__FILE__, __LINE__, info->device_name, info->irq_level);
 			usc_DisableMasterIrqBit(info);
 			usc_DisableDmaInterrupts(info,DICR_MASTER);
 			break;
@@ -1755,8 +1751,9 @@ static irqreturn_t mgsl_interrupt(int irq, void *dev_id)
 	spin_unlock(&info->irq_spinlock);
 	
 	if ( debug_level >= DEBUG_LEVEL_ISR )	
-		printk("%s(%d):mgsl_interrupt(%d)exit.\n",
-			__FILE__,__LINE__,irq);
+		printk(KERN_DEBUG "%s(%d):mgsl_interrupt(%d)exit.\n",
+			__FILE__, __LINE__, info->irq_level);
+
 	return IRQ_HANDLED;
 }	/* end of mgsl_interrupt() */
 
diff --git a/drivers/char/synclink_gt.c b/drivers/char/synclink_gt.c
index 1f954ac..3c89266 100644
--- a/drivers/char/synclink_gt.c
+++ b/drivers/char/synclink_gt.c
@@ -491,7 +491,6 @@ static void isr_serial(struct slgt_info *info);
 static void isr_rdma(struct slgt_info *info);
 static void isr_txeom(struct slgt_info *info, unsigned short status);
 static void isr_tdma(struct slgt_info *info);
-static irqreturn_t slgt_interrupt(int irq, void *dev_id);
 
 static int  alloc_dma_bufs(struct slgt_info *info);
 static void free_dma_bufs(struct slgt_info *info);
@@ -2326,17 +2325,13 @@ static void isr_gpio(struct slgt_info *info, unsigned int changed, unsigned int
  * 	irq	interrupt number
  * 	dev_id	device ID supplied during interrupt registration
  */
-static irqreturn_t slgt_interrupt(int irq, void *dev_id)
+static irqreturn_t slgt_interrupt(int dummy, void *dev_id)
 {
-	struct slgt_info *info;
+	struct slgt_info *info = dev_id;
 	unsigned int gsr;
 	unsigned int i;
 
-	DBGISR(("slgt_interrupt irq=%d entry\n", irq));
-
-	info = dev_id;
-	if (!info)
-		return IRQ_NONE;
+	DBGISR(("slgt_interrupt irq=%d entry\n", info->irq_level));
 
 	spin_lock(&info->lock);
 
@@ -2385,7 +2380,7 @@ static irqreturn_t slgt_interrupt(int irq, void *dev_id)
 
 	spin_unlock(&info->lock);
 
-	DBGISR(("slgt_interrupt irq=%d exit\n", irq));
+	DBGISR(("slgt_interrupt irq=%d exit\n", info->irq_level));
 	return IRQ_HANDLED;
 }
 
diff --git a/drivers/char/synclinkmp.c b/drivers/char/synclinkmp.c
index f3e7807..c96062e 100644
--- a/drivers/char/synclinkmp.c
+++ b/drivers/char/synclinkmp.c
@@ -2586,9 +2586,9 @@ void isr_io_pin( SLMP_INFO *info, u16 status )
  * 	dev_id		device ID supplied during interrupt registration
  * 	regs		interrupted processor context
  */
-static irqreturn_t synclinkmp_interrupt(int irq, void *dev_id)
+static irqreturn_t synclinkmp_interrupt(int dummy, void *dev_id)
 {
-	SLMP_INFO * info;
+	SLMP_INFO *info = dev_id;
 	unsigned char status, status0, status1=0;
 	unsigned char dmastatus, dmastatus0, dmastatus1=0;
 	unsigned char timerstatus0, timerstatus1=0;
@@ -2597,12 +2597,8 @@ static irqreturn_t synclinkmp_interrupt(int irq, void *dev_id)
 	unsigned short tmp;
 
 	if ( debug_level >= DEBUG_LEVEL_ISR )
-		printk("%s(%d): synclinkmp_interrupt(%d)entry.\n",
-			__FILE__,__LINE__,irq);
-
-	info = (SLMP_INFO *)dev_id;
-	if (!info)
-		return IRQ_NONE;
+		printk(KERN_DEBUG "%s(%d): synclinkmp_interrupt(%d)entry.\n",
+			__FILE__, __LINE__, info->irq_level);
 
 	spin_lock(&info->lock);
 
@@ -2615,9 +2611,9 @@ static irqreturn_t synclinkmp_interrupt(int irq, void *dev_id)
 		timerstatus0 = read_reg(info, ISR2);
 
 		if ( debug_level >= DEBUG_LEVEL_ISR )
-			printk("%s(%d):%s status0=%02x, dmastatus0=%02x, timerstatus0=%02x\n",
-				__FILE__,__LINE__,info->device_name,
-				status0,dmastatus0,timerstatus0);
+			printk(KERN_DEBUG "%s(%d):%s status0=%02x, dmastatus0=%02x, timerstatus0=%02x\n",
+				__FILE__, __LINE__, info->device_name,
+				status0, dmastatus0, timerstatus0);
 
 		if (info->port_count == 4) {
 			/* get status for SCA1 (ports 2-3) */
@@ -2702,8 +2698,8 @@ static irqreturn_t synclinkmp_interrupt(int irq, void *dev_id)
 	spin_unlock(&info->lock);
 
 	if ( debug_level >= DEBUG_LEVEL_ISR )
-		printk("%s(%d):synclinkmp_interrupt(%d)exit.\n",
-			__FILE__,__LINE__,irq);
+		printk(KERN_DEBUG "%s(%d):synclinkmp_interrupt(%d)exit.\n",
+			__FILE__, __LINE__, info->irq_level);
 	return IRQ_HANDLED;
 }
 
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 81503d9..13a4bdd 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -399,7 +399,7 @@ static irqreturn_t tis_int_probe(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t tis_int_handler(int irq, void *dev_id)
+static irqreturn_t tis_int_handler(int dummy, void *dev_id)
 {
 	struct tpm_chip *chip = dev_id;
 	u32 interrupt;
-- 
1.5.4.1

