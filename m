Return-Path: <linux-kernel-owner+w=401wt.eu-S1757984AbYDUBgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984AbYDUBgM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 21:36:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754000AbYDUBf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 21:35:58 -0400
Received: from havoc.gtf.org ([69.61.125.42]:34074 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753890AbYDUBf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 21:35:56 -0400
Date: Sun, 20 Apr 2008 21:35:51 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, rmk@arm.linux.org.uk,
       kernel@wantstofly.org, linux-arm-kernel@lists.arm.linux.org.uk,
       galak@kernel.crashing.org, David Miller <davem@davemloft.net>,
       kkeil@suse.de, isdn4linux@listserv.isdn4linux.de, cooloney@kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [git patches] minor irq handler cleanups
Message-ID: <20080421013551.GA25960@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In my review of every single interrupt handler in the Linux, while
working on another project (jgarzik/misc-2.6.git#irq-remove), I've
created quite a few minor cleanups and corrections to the various
interrupt handlers that need it.

Since the #irq-remove project involves removal of the 'irq' argument
from interrupt handlers (unused 99.8% of the time), I have been
explicitly noting the unused aspect of a handler's first argument
via s/irq/dummy/ naming changes to the function declaration.

Here are the bits that have either been ack'd explicitly (~60%), or are
straightforward and unlikely to create conflicts (of either the human or
patch(1) kind...).

Even if ultimately people dislike #irq-remove, these cleanups remain
useful, IMO.

Please pull from 'irq-cleanups-upstream' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git irq-cleanups-upstream

to receive the following updates:

 arch/arm/mach-integrator/time.c   |    2 +-
 arch/blackfin/kernel/time.c       |    5 ++---
 arch/ppc/8xx_io/fec.c             |    3 +--
 arch/ppc/platforms/sbc82xx.c      |    4 +++-
 arch/sparc/kernel/time.c          |    2 +-
 drivers/char/mwave/tp3780i.c      |   14 ++++++++++----
 drivers/char/pcmcia/synclink_cs.c |   10 ++++------
 drivers/char/specialix.c          |   10 ++++------
 drivers/char/stallion.c           |    2 +-
 drivers/char/synclink.c           |   21 +++++++++------------
 drivers/char/synclink_gt.c        |   13 ++++---------
 drivers/char/synclinkmp.c         |   22 +++++++++-------------
 drivers/char/tpm/tpm_tis.c        |    2 +-
 drivers/isdn/hisax/elsa.c         |    4 ++--
 drivers/isdn/hisax/elsa_ser.c     |    4 ++--
 drivers/isdn/hisax/hisax.h        |    2 +-
 include/asm-sparc/floppy.h        |    2 +-
 17 files changed, 56 insertions(+), 66 deletions(-)

Jeff Garzik (6):
      ARM minor irq handler cleanup: avoid passing unused info to irq
      [SPARC] minor irq handler cleanups
      [BLACKFIN] minor irq handler cleanups
      [PPC] minor irq handler cleanups
      drivers/char: minor irq handler cleanups
      [ISDN] minor irq handler cleanups

diff --git a/arch/arm/mach-integrator/time.c b/arch/arm/mach-integrator/time.c
index 5278f58..5235f64 100644
--- a/arch/arm/mach-integrator/time.c
+++ b/arch/arm/mach-integrator/time.c
@@ -125,7 +125,7 @@ static int rtc_probe(struct amba_device *dev, void *id)
 	xtime.tv_sec = __raw_readl(rtc_base + RTC_DR);
 
 	ret = request_irq(dev->irq[0], arm_rtc_interrupt, IRQF_DISABLED,
-			  "rtc-pl030", dev);
+			  "rtc-pl030", NULL);
 	if (ret)
 		goto map_out;
 
diff --git a/arch/blackfin/kernel/time.c b/arch/blackfin/kernel/time.c
index 9bdc8f9..715b394 100644
--- a/arch/blackfin/kernel/time.c
+++ b/arch/blackfin/kernel/time.c
@@ -39,8 +39,7 @@
 /* This is an NTP setting */
 #define	TICK_SIZE (tick_nsec / 1000)
 
-static void time_sched_init(irqreturn_t(*timer_routine)
-			(int, void *));
+static void time_sched_init(irq_handler_t timer_routine);
 static unsigned long gettimeoffset(void);
 
 static struct irqaction bfin_timer_irq = {
@@ -64,7 +63,7 @@ static struct irqaction bfin_timer_irq = {
 #define TIME_SCALE 1
 
 static void
-time_sched_init(irqreturn_t(*timer_routine) (int, void *))
+time_sched_init(irq_handler_t timer_routine)
 {
 	u32 tcount;
 
diff --git a/arch/ppc/8xx_io/fec.c b/arch/ppc/8xx_io/fec.c
index 11b0aa6..d7b7ba9 100644
--- a/arch/ppc/8xx_io/fec.c
+++ b/arch/ppc/8xx_io/fec.c
@@ -199,7 +199,6 @@ static int fec_enet_start_xmit(struct sk_buff *skb, struct net_device *dev);
 #ifdef	CONFIG_USE_MDIO
 static void fec_enet_mii(struct net_device *dev);
 #endif	/* CONFIG_USE_MDIO */
-static irqreturn_t fec_enet_interrupt(int irq, void * dev_id);
 #ifdef CONFIG_FEC_PACKETHOOK
 static void  fec_enet_tx(struct net_device *dev, __u32 regval);
 static void  fec_enet_rx(struct net_device *dev, __u32 regval);
@@ -472,7 +471,7 @@ fec_timeout(struct net_device *dev)
  * This is called from the MPC core interrupt.
  */
 static	irqreturn_t
-fec_enet_interrupt(int irq, void * dev_id)
+fec_enet_interrupt(int irq, void *dev_id)
 {
 	struct	net_device *dev = dev_id;
 	volatile fec_t	*fecp;
diff --git a/arch/ppc/platforms/sbc82xx.c b/arch/ppc/platforms/sbc82xx.c
index cc0935c..0df6aac 100644
--- a/arch/ppc/platforms/sbc82xx.c
+++ b/arch/ppc/platforms/sbc82xx.c
@@ -121,8 +121,10 @@ struct hw_interrupt_type sbc82xx_i8259_ic = {
 	.end = sbc82xx_i8259_end_irq,
 };
 
-static irqreturn_t sbc82xx_i8259_demux(int irq, void *dev_id)
+static irqreturn_t sbc82xx_i8259_demux(int dummy, void *dev_id)
 {
+	int irq;
+
 	spin_lock(&sbc82xx_i8259_lock);
 
 	sbc82xx_i8259_map[0] = 0x0c;	/* OCW3: Read IR register on RD# pulse */
diff --git a/arch/sparc/kernel/time.c b/arch/sparc/kernel/time.c
index cfaf22c..53caacb 100644
--- a/arch/sparc/kernel/time.c
+++ b/arch/sparc/kernel/time.c
@@ -105,7 +105,7 @@ __volatile__ unsigned int *master_l10_limit;
 
 #define TICK_SIZE (tick_nsec / 1000)
 
-irqreturn_t timer_interrupt(int irq, void *dev_id)
+static irqreturn_t timer_interrupt(int dummy, void *dev_id)
 {
 	/* last time the cmos clock got updated */
 	static long last_rtc_update;
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
diff --git a/drivers/isdn/hisax/elsa.c b/drivers/isdn/hisax/elsa.c
index d272d8c..2c3691f 100644
--- a/drivers/isdn/hisax/elsa.c
+++ b/drivers/isdn/hisax/elsa.c
@@ -299,7 +299,7 @@ elsa_interrupt(int intno, void *dev_id)
 		val = serial_inp(cs, UART_IIR);
 		if (!(val & UART_IIR_NO_INT)) {
 			debugl1(cs,"IIR %02x", val);
-			rs_interrupt_elsa(intno, cs);
+			rs_interrupt_elsa(cs);
 		}
 	}
 #endif
@@ -379,7 +379,7 @@ elsa_interrupt_ipac(int intno, void *dev_id)
 		val = serial_inp(cs, UART_IIR);
 		if (!(val & UART_IIR_NO_INT)) {
 			debugl1(cs,"IIR %02x", val);
-			rs_interrupt_elsa(intno, cs);
+			rs_interrupt_elsa(cs);
 		}
 	}
 #endif
diff --git a/drivers/isdn/hisax/elsa_ser.c b/drivers/isdn/hisax/elsa_ser.c
index 1642dca..f181db4 100644
--- a/drivers/isdn/hisax/elsa_ser.c
+++ b/drivers/isdn/hisax/elsa_ser.c
@@ -384,13 +384,13 @@ static inline void transmit_chars(struct IsdnCardState *cs, int *intr_done)
 }
 
 
-static void rs_interrupt_elsa(int irq, struct IsdnCardState *cs)
+static void rs_interrupt_elsa(struct IsdnCardState *cs)
 {
 	int status, iir, msr;
 	int pass_counter = 0;
 	
 #ifdef SERIAL_DEBUG_INTR
-	printk("rs_interrupt_single(%d)...", irq);
+	printk(KERN_DEBUG "rs_interrupt_single(%d)...", cs->irq);
 #endif
 
 	do {
diff --git a/drivers/isdn/hisax/hisax.h b/drivers/isdn/hisax/hisax.h
index 34733c9..e8d429f 100644
--- a/drivers/isdn/hisax/hisax.h
+++ b/drivers/isdn/hisax/hisax.h
@@ -925,7 +925,7 @@ struct IsdnCardState {
 	int		(*cardmsg) (struct IsdnCardState *, int, void *);
 	void		(*setstack_d) (struct PStack *, struct IsdnCardState *);
 	void		(*DC_Close) (struct IsdnCardState *);
-	int		(*irq_func) (int, void *);
+	irq_handler_t	irq_func;
 	int		(*auxcmd) (struct IsdnCardState *, isdn_ctrl *);
 	struct Channel	channel[2+MAX_WAITING_CALLS];
 	struct BCState	bcs[2+MAX_WAITING_CALLS];
diff --git a/include/asm-sparc/floppy.h b/include/asm-sparc/floppy.h
index dbe7a58..d3978e0 100644
--- a/include/asm-sparc/floppy.h
+++ b/include/asm-sparc/floppy.h
@@ -280,7 +280,7 @@ static inline void sun_fd_enable_dma(void)
 
 /* Our low-level entry point in arch/sparc/kernel/entry.S */
 extern int sparc_floppy_request_irq(int irq, unsigned long flags,
-				    irqreturn_t (*irq_handler)(int irq, void *));
+				    irq_handler_t irq_handler);
 
 static int sun_fd_request_irq(void)
 {
