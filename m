Return-Path: <linux-kernel-owner+w=401wt.eu-S1755561AbXJXBeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561AbXJXBeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 21:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753014AbXJXBe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 21:34:29 -0400
Received: from havoc.gtf.org ([69.61.125.42]:52111 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958AbXJXBeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 21:34:25 -0400
Date: Tue, 23 Oct 2007 21:34:24 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] irq handler fixes and cleanups
Message-ID: <20071024013424.GA17113@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Ack'd by maintainers where possible, but older drivers like parport are
orphaned (according to both real life and MAINTAINERS).

Simple obvious cleanups (and/or fixes), generally resulting in a more
efficient irq handler.

Please pull from 'irq-upstream' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git irq-upstream

to receive the following updates:

 arch/sparc/kernel/irq.c              |    4 +-
 arch/x86/xen/events.c                |    4 +-
 drivers/atm/horizon.c                |    5 +-
 drivers/char/ip2/ip2main.c           |   69 +++--
 drivers/char/pcmcia/synclink_cs.c    |  706 +++++++++++++++++-----------------
 drivers/char/ppdev.c                 |    4 +-
 drivers/char/riscom8.c               |   16 +-
 drivers/char/tpm/tpm_tis.c           |    4 +-
 drivers/input/serio/parkbd.c         |    2 +-
 drivers/isdn/act2000/act2000_isa.c   |   12 +-
 drivers/isdn/sc/init.c               |    3 +-
 drivers/isdn/sc/interrupt.c          |   17 +-
 drivers/mtd/onenand/onenand_base.c   |    2 +-
 drivers/net/cxgb3/adapter.h          |    4 +-
 drivers/net/cxgb3/sge.c              |    2 +-
 drivers/net/hamradio/baycom_epp.c    |    8 +-
 drivers/net/hamradio/baycom_par.c    |    4 +-
 drivers/net/lib82596.c               |    8 +-
 drivers/net/netxen/netxen_nic_main.c |   11 +-
 drivers/net/plip.c                   |    6 +-
 drivers/net/typhoon.c                |    2 +-
 drivers/net/ucc_geth.c               |    2 +-
 drivers/net/wan/sbni.c               |    4 +-
 drivers/parport/daisy.c              |   13 +-
 drivers/parport/ieee1284.c           |    2 +-
 drivers/parport/parport_amiga.c      |    9 +-
 drivers/parport/parport_atari.c      |    9 +-
 drivers/parport/parport_ax88796.c    |   10 +-
 drivers/parport/parport_gsc.c        |    8 +-
 drivers/parport/parport_ip32.c       |    6 +-
 drivers/parport/parport_mfc3.c       |    2 +-
 drivers/parport/parport_pc.c         |    9 +-
 drivers/parport/parport_sunbpp.c     |    8 +-
 drivers/parport/probe.c              |    3 +-
 drivers/parport/share.c              |   12 +-
 drivers/usb/misc/uss720.c            |    4 +-
 include/linux/parport.h              |   22 +-
 sound/drivers/mts64.c                |    2 +-
 sound/drivers/portman2x4.c           |    2 +-
 39 files changed, 484 insertions(+), 536 deletions(-)

Jeff Garzik (12):
      [PARPORT] Consolidate code copies into a single generic irq handler
      [PARPORT] Kill useful 'irq' arg from parport_{generic_irq,ieee1284_interrupt}
      [PARPORT] Remove unused 'irq' argument from parport irq functions
      Eliminate pointless casts from void* in a few driver irq handlers.
      [NETDRVR] lib82596, netxen: delete pointless tests from irq handler
      drivers/char/ip2: split out irq core logic into separate function
      drivers/char/ip2: separate polling and irq-driven work entry points
      char/pcmcia/synclink_cs: trim trailing whitespace
      isdn/act2000: fix major bug. clean irq handler.
      isdn/sc: irq handler clean
      drivers/char/riscom8: clean up irq handling
      [SPARC, XEN, NET/CXGB3] use irq_handler_t where appropriate

diff --git a/arch/sparc/kernel/irq.c b/arch/sparc/kernel/irq.c
index 722d67d..e1e24f3 100644
--- a/arch/sparc/kernel/irq.c
+++ b/arch/sparc/kernel/irq.c
@@ -479,7 +479,7 @@ EXPORT_SYMBOL(pdma_areasize);
 
 extern void floppy_hardint(void);
 
-static irqreturn_t (*floppy_irq_handler)(int irq, void *dev_id);
+static irq_handler_t floppy_irq_handler;
 
 void sparc_floppy_irq(int irq, void *dev_id, struct pt_regs *regs)
 {
@@ -500,7 +500,7 @@ void sparc_floppy_irq(int irq, void *dev_id, struct pt_regs *regs)
 }
 
 int sparc_floppy_request_irq(int irq, unsigned long flags,
-			     irqreturn_t (*irq_handler)(int irq, void *))
+			     irq_handler_t irq_handler)
 {
 	floppy_irq_handler = irq_handler;
 	return request_fast_irq(irq, floppy_hardint, flags, "floppy");
diff --git a/arch/x86/xen/events.c b/arch/x86/xen/events.c
index da1b173..6d1da58 100644
--- a/arch/x86/xen/events.c
+++ b/arch/x86/xen/events.c
@@ -383,7 +383,7 @@ static void unbind_from_irq(unsigned int irq)
 }
 
 int bind_evtchn_to_irqhandler(unsigned int evtchn,
-			      irqreturn_t (*handler)(int, void *),
+			      irq_handler_t handler,
 			      unsigned long irqflags,
 			      const char *devname, void *dev_id)
 {
@@ -402,7 +402,7 @@ int bind_evtchn_to_irqhandler(unsigned int evtchn,
 EXPORT_SYMBOL_GPL(bind_evtchn_to_irqhandler);
 
 int bind_virq_to_irqhandler(unsigned int virq, unsigned int cpu,
-			    irqreturn_t (*handler)(int, void *),
+			    irq_handler_t handler,
 			    unsigned long irqflags, const char *devname, void *dev_id)
 {
 	unsigned int irq;
diff --git a/drivers/atm/horizon.c b/drivers/atm/horizon.c
index f96446c..9b2cf25 100644
--- a/drivers/atm/horizon.c
+++ b/drivers/atm/horizon.c
@@ -1382,8 +1382,9 @@ static inline void rx_data_av_handler (hrz_dev * dev) {
 
 /********** interrupt handler **********/
 
-static irqreturn_t interrupt_handler(int irq, void *dev_id) {
-  hrz_dev * dev = (hrz_dev *) dev_id;
+static irqreturn_t interrupt_handler(int irq, void *dev_id)
+{
+  hrz_dev *dev = dev_id;
   u32 int_source;
   unsigned int irq_ok;
   
diff --git a/drivers/char/ip2/ip2main.c b/drivers/char/ip2/ip2main.c
index 2124dce..e04e66c 100644
--- a/drivers/char/ip2/ip2main.c
+++ b/drivers/char/ip2/ip2main.c
@@ -752,7 +752,7 @@ retry:
 					continue;
 				rc = request_irq( ip2config.irq[i], ip2_interrupt,
 					IP2_SA_FLAGS | (ip2config.type[i] == PCI ? IRQF_SHARED : 0),
-					pcName, (void *)&pcName);
+					pcName, i2BoardPtrTable[i]);
 				if (rc) {
 					printk(KERN_ERR "IP2: an request_irq failed: error %d\n",rc);
 					ip2config.irq[i] = CIR_POLL;
@@ -1166,12 +1166,37 @@ ip2_interrupt_bh(struct work_struct *work)
 /*                                                                            */
 /*                                                                            */
 /******************************************************************************/
-static irqreturn_t
-ip2_interrupt(int irq, void *dev_id)
+static void
+ip2_irq_work(i2eBordStrPtr pB)
+{
+#ifdef USE_IQI
+	if (NO_MAIL_HERE != ( pB->i2eStartMail = iiGetMail(pB))) {
+//		Disable his interrupt (will be enabled when serviced)
+//		This is mostly to protect from reentrancy.
+		iiDisableMailIrq(pB);
+
+//		Park the board on the immediate queue for processing.
+		schedule_work(&pB->tqueue_interrupt);
+
+//		Make sure the immediate queue is flagged to fire.
+	}
+#else
+
+//	We are using immediate servicing here.  This sucks and can
+//	cause all sorts of havoc with ppp and others.  The failsafe
+//	check on iiSendPendingMail could also throw a hairball.
+
+	i2ServiceBoard( pB );
+
+#endif /* USE_IQI */
+}
+
+static void
+ip2_polled_interrupt(void)
 {
 	int i;
 	i2eBordStrPtr  pB;
-	int handled = 0;
+	const int irq = 0;
 
 	ip2trace (ITRC_NO_PORT, ITRC_INTR, 99, 1, irq );
 
@@ -1183,32 +1208,28 @@ ip2_interrupt(int irq, void *dev_id)
 //			IRQ = 0 for polled boards, we won't poll "IRQ" boards
 
 		if ( pB && (pB->i2eUsingIrq == irq) ) {
-			handled = 1;
-#ifdef USE_IQI
+			ip2_irq_work(pB);
+		}
+	}
 
-		    if (NO_MAIL_HERE != ( pB->i2eStartMail = iiGetMail(pB))) {
-//			Disable his interrupt (will be enabled when serviced)
-//			This is mostly to protect from reentrancy.
-			iiDisableMailIrq(pB);
+	++irq_counter;
 
-//			Park the board on the immediate queue for processing.
-			schedule_work(&pB->tqueue_interrupt);
+	ip2trace (ITRC_NO_PORT, ITRC_INTR, ITRC_RETURN, 0 );
+}
 
-//			Make sure the immediate queue is flagged to fire.
-		    }
-#else
-//		We are using immediate servicing here.  This sucks and can
-//		cause all sorts of havoc with ppp and others.  The failsafe
-//		check on iiSendPendingMail could also throw a hairball.
-			i2ServiceBoard( pB );
-#endif /* USE_IQI */
-		}
-	}
+static irqreturn_t
+ip2_interrupt(int irq, void *dev_id)
+{
+	i2eBordStrPtr pB = dev_id;
+
+	ip2trace (ITRC_NO_PORT, ITRC_INTR, 99, 1, pB->i2eUsingIrq );
+
+	ip2_irq_work(pB);
 
 	++irq_counter;
 
 	ip2trace (ITRC_NO_PORT, ITRC_INTR, ITRC_RETURN, 0 );
-	return IRQ_RETVAL(handled);
+	return IRQ_HANDLED;
 }
 
 /******************************************************************************/
@@ -1231,7 +1252,7 @@ ip2_poll(unsigned long arg)
 	// Just polled boards, IRQ = 0 will hit all non-interrupt boards.
 	// It will NOT poll boards handled by hard interrupts.
 	// The issue of queued BH interrups is handled in ip2_interrupt().
-	ip2_interrupt(0, NULL);
+	ip2_polled_interrupt();
 
 	PollTimer.expires = POLL_TIMEOUT;
 	add_timer( &PollTimer );
diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index 2b88931..8caff0c 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -123,7 +123,7 @@ typedef struct
 #define RELEVANT_IFLAG(iflag) (iflag & (IGNBRK|BRKINT|IGNPAR|PARMRK|INPCK))
 
 struct _input_signal_events {
-	int	ri_up;	
+	int	ri_up;
 	int	ri_down;
 	int	dsr_up;
 	int	dsr_down;
@@ -137,7 +137,7 @@ struct _input_signal_events {
 /*
  * Device instance data structure
  */
- 
+
 typedef struct _mgslpc_info {
 	void *if_ptr;	/* General purpose pointer (used by SPPP) */
 	int			magic;
@@ -146,15 +146,15 @@ typedef struct _mgslpc_info {
 	int			line;
 	unsigned short		close_delay;
 	unsigned short		closing_wait;	/* time to wait before closing */
-	
+
 	struct mgsl_icount	icount;
-	
+
 	struct tty_struct 	*tty;
 	int			timeout;
 	int			x_char;		/* xon/xoff character */
 	int			blocked_open;	/* # of blocked opens */
 	unsigned char		read_status_mask;
-	unsigned char		ignore_status_mask;	
+	unsigned char		ignore_status_mask;
 
 	unsigned char *tx_buf;
 	int            tx_put;
@@ -170,10 +170,10 @@ typedef struct _mgslpc_info {
 	int            rx_buf_size;    /* size in bytes of single rx buffer */
 	int            rx_buf_count;   /* total number of rx buffers */
 	int            rx_frame_count; /* number of full rx buffers */
-	
+
 	wait_queue_head_t	open_wait;
 	wait_queue_head_t	close_wait;
-	
+
 	wait_queue_head_t	status_event_wait_q;
 	wait_queue_head_t	event_wait_q;
 	struct timer_list	tx_timer;	/* HDLC transmit timeout timer */
@@ -192,7 +192,7 @@ typedef struct _mgslpc_info {
 
 	int bh_running;
 	int bh_requested;
-	
+
 	int dcd_chkcount; /* check counts to prevent */
 	int cts_chkcount; /* too many IRQs if a signal */
 	int dsr_chkcount; /* is floating */
@@ -212,7 +212,7 @@ typedef struct _mgslpc_info {
 
 	unsigned int io_base;	/* base I/O address of adapter */
 	unsigned int irq_level;
-	
+
 	MGSL_PARAMS params;		/* communications parameters */
 
 	unsigned char serial_signals;	/* current serial signal states */
@@ -249,7 +249,7 @@ typedef struct _mgslpc_info {
  */
 #define TXBUFSIZE 4096
 
-    
+
 #define CHA     0x00   /* channel A offset */
 #define CHB     0x40   /* channel B offset */
 
@@ -298,9 +298,9 @@ typedef struct _mgslpc_info {
 #define PIM     0x3d
 #define PCR     0x3e
 #define CCR4    0x3f
-    
+
 // IMR/ISR
-    
+
 #define IRQ_BREAK_ON    BIT15   // rx break detected
 #define IRQ_DATAOVERRUN BIT14	// receive data overflow
 #define IRQ_ALLSENT     BIT13	// all sent
@@ -315,13 +315,13 @@ typedef struct _mgslpc_info {
 #define IRQ_DCD         BIT2	// carrier detect status change
 #define IRQ_OVERRUN     BIT1	// receive frame overflow
 #define IRQ_RXFIFO      BIT0	// receive pool full
-    
+
 // STAR
-    
+
 #define XFW   BIT6		// transmit FIFO write enable
 #define CEC   BIT2		// command executing
 #define CTS   BIT1		// CTS state
-    
+
 #define PVR_DTR      BIT0
 #define PVR_DSR      BIT1
 #define PVR_RI       BIT2
@@ -329,25 +329,25 @@ typedef struct _mgslpc_info {
 #define PVR_RS232    0x20   /* 0010b */
 #define PVR_V35      0xe0   /* 1110b */
 #define PVR_RS422    0x40   /* 0100b */
-    
-/* Register access functions */ 
-    
+
+/* Register access functions */
+
 #define write_reg(info, reg, val) outb((val),(info)->io_base + (reg))
 #define read_reg(info, reg) inb((info)->io_base + (reg))
 
-#define read_reg16(info, reg) inw((info)->io_base + (reg))  
+#define read_reg16(info, reg) inw((info)->io_base + (reg))
 #define write_reg16(info, reg, val) outw((val), (info)->io_base + (reg))
-    
+
 #define set_reg_bits(info, reg, mask) \
     write_reg(info, (reg), \
-		 (unsigned char) (read_reg(info, (reg)) | (mask)))  
+		 (unsigned char) (read_reg(info, (reg)) | (mask)))
 #define clear_reg_bits(info, reg, mask) \
     write_reg(info, (reg), \
-		 (unsigned char) (read_reg(info, (reg)) & ~(mask)))  
+		 (unsigned char) (read_reg(info, (reg)) & ~(mask)))
 /*
  * interrupt enable/disable routines
- */ 
-static void irq_disable(MGSLPC_INFO *info, unsigned char channel, unsigned short mask) 
+ */
+static void irq_disable(MGSLPC_INFO *info, unsigned char channel, unsigned short mask)
 {
 	if (channel == CHA) {
 		info->imra_value |= mask;
@@ -357,7 +357,7 @@ static void irq_disable(MGSLPC_INFO *info, unsigned char channel, unsigned short
 		write_reg16(info, CHB + IMR, info->imrb_value);
 	}
 }
-static void irq_enable(MGSLPC_INFO *info, unsigned char channel, unsigned short mask) 
+static void irq_enable(MGSLPC_INFO *info, unsigned char channel, unsigned short mask)
 {
 	if (channel == CHA) {
 		info->imra_value &= ~mask;
@@ -558,7 +558,7 @@ static int mgslpc_probe(struct pcmcia_device *link)
     spin_lock_init(&info->lock);
     spin_lock_init(&info->netlock);
     memcpy(&info->params,&default_params,sizeof(MGSL_PARAMS));
-    info->idle_mode = HDLC_TXIDLE_FLAGS;		
+    info->idle_mode = HDLC_TXIDLE_FLAGS;
     info->imra_value = 0xffff;
     info->imrb_value = 0xffff;
     info->pim_value = 0xff;
@@ -600,7 +600,7 @@ static int mgslpc_config(struct pcmcia_device *link)
     u_char buf[64];
     cistpl_cftable_entry_t dflt = { 0 };
     cistpl_cftable_entry_t *cfg;
-    
+
     if (debug_level >= DEBUG_LEVEL_INFO)
 	    printk("mgslpc_config(0x%p)\n", link);
 
@@ -624,7 +624,7 @@ static int mgslpc_config(struct pcmcia_device *link)
 
     link->conf.ConfigIndex = cfg->index;
     link->conf.Attributes |= CONF_ENABLE_IRQ;
-	
+
     /* IO window settings */
     link->io.NumPorts1 = 0;
     if ((cfg->io.nwin > 0) || (dflt.io.nwin > 0)) {
@@ -644,7 +644,7 @@ static int mgslpc_config(struct pcmcia_device *link)
     link->conf.IntType = INT_MEMORY_AND_IO;
     link->conf.ConfigIndex = 8;
     link->conf.Present = PRESENT_OPTION;
-    
+
     link->irq.Attributes |= IRQ_HANDLE_PRESENT;
     link->irq.Handler     = mgslpc_isr;
     link->irq.Instance    = info;
@@ -753,10 +753,10 @@ static inline int mgslpc_paranoia_check(MGSLPC_INFO *info,
 #define CMD_TXEOM       BIT1	// transmit end message
 #define CMD_TXRESET     BIT0	// transmit reset
 
-static BOOLEAN wait_command_complete(MGSLPC_INFO *info, unsigned char channel) 
+static BOOLEAN wait_command_complete(MGSLPC_INFO *info, unsigned char channel)
 {
 	int i = 0;
-	/* wait for command completion */ 
+	/* wait for command completion */
 	while (read_reg(info, (unsigned char)(channel+STAR)) & BIT2) {
 		udelay(1);
 		if (i++ == 1000)
@@ -765,7 +765,7 @@ static BOOLEAN wait_command_complete(MGSLPC_INFO *info, unsigned char channel)
 	return TRUE;
 }
 
-static void issue_command(MGSLPC_INFO *info, unsigned char channel, unsigned char cmd) 
+static void issue_command(MGSLPC_INFO *info, unsigned char channel, unsigned char cmd)
 {
 	wait_command_complete(info, channel);
 	write_reg(info, (unsigned char) (channel + CMDR), cmd);
@@ -775,12 +775,12 @@ static void tx_pause(struct tty_struct *tty)
 {
 	MGSLPC_INFO *info = (MGSLPC_INFO *)tty->driver_data;
 	unsigned long flags;
-	
+
 	if (mgslpc_paranoia_check(info, tty->name, "tx_pause"))
 		return;
 	if (debug_level >= DEBUG_LEVEL_INFO)
-		printk("tx_pause(%s)\n",info->device_name);	
-		
+		printk("tx_pause(%s)\n",info->device_name);
+
 	spin_lock_irqsave(&info->lock,flags);
 	if (info->tx_enabled)
 	 	tx_stop(info);
@@ -791,12 +791,12 @@ static void tx_release(struct tty_struct *tty)
 {
 	MGSLPC_INFO *info = (MGSLPC_INFO *)tty->driver_data;
 	unsigned long flags;
-	
+
 	if (mgslpc_paranoia_check(info, tty->name, "tx_release"))
 		return;
 	if (debug_level >= DEBUG_LEVEL_INFO)
-		printk("tx_release(%s)\n",info->device_name);	
-		
+		printk("tx_release(%s)\n",info->device_name);
+
 	spin_lock_irqsave(&info->lock,flags);
 	if (!info->tx_enabled)
 	 	tx_start(info);
@@ -810,7 +810,7 @@ static int bh_action(MGSLPC_INFO *info)
 {
 	unsigned long flags;
 	int rc = 0;
-	
+
 	spin_lock_irqsave(&info->lock,flags);
 
 	if (info->pending_bh & BH_RECEIVE) {
@@ -829,9 +829,9 @@ static int bh_action(MGSLPC_INFO *info)
 		info->bh_running   = 0;
 		info->bh_requested = 0;
 	}
-	
+
 	spin_unlock_irqrestore(&info->lock,flags);
-	
+
 	return rc;
 }
 
@@ -842,22 +842,22 @@ static void bh_handler(struct work_struct *work)
 
 	if (!info)
 		return;
-		
+
 	if (debug_level >= DEBUG_LEVEL_BH)
 		printk( "%s(%d):bh_handler(%s) entry\n",
 			__FILE__,__LINE__,info->device_name);
-	
+
 	info->bh_running = 1;
 
 	while((action = bh_action(info)) != 0) {
-	
+
 		/* Process work item */
 		if ( debug_level >= DEBUG_LEVEL_BH )
 			printk( "%s(%d):bh_handler() work item action=%d\n",
 				__FILE__,__LINE__,action);
 
 		switch (action) {
-		
+
 		case BH_RECEIVE:
 			while(rx_get_frame(info));
 			break;
@@ -897,7 +897,7 @@ static void bh_status(MGSLPC_INFO *info)
 	info->cts_chkcount = 0;
 }
 
-/* eom: non-zero = end of frame */ 
+/* eom: non-zero = end of frame */
 static void rx_ready_hdlc(MGSLPC_INFO *info, int eom)
 {
 	unsigned char data[2];
@@ -906,7 +906,7 @@ static void rx_ready_hdlc(MGSLPC_INFO *info, int eom)
 
 	if (debug_level >= DEBUG_LEVEL_ISR)
 		printk("%s(%d):rx_ready_hdlc(eom=%d)\n",__FILE__,__LINE__,eom);
-	
+
 	if (!info->rx_enabled)
 		return;
 
@@ -920,12 +920,12 @@ static void rx_ready_hdlc(MGSLPC_INFO *info, int eom)
 	}
 
 	if (eom) {
-		/* end of frame, get FIFO count from RBCL register */ 
+		/* end of frame, get FIFO count from RBCL register */
 		if (!(fifo_count = (unsigned char)(read_reg(info, CHA+RBCL) & 0x1f)))
 			fifo_count = 32;
 	} else
 		fifo_count = 32;
-	
+
 	do {
 		if (fifo_count == 1) {
 			read_count = 1;
@@ -969,7 +969,7 @@ static void rx_ready_async(MGSLPC_INFO *info, int tcd)
  	struct mgsl_icount *icount = &info->icount;
 
 	if (tcd) {
-		/* early termination, get FIFO count from RBCL register */ 
+		/* early termination, get FIFO count from RBCL register */
 		fifo_count = (unsigned char)(read_reg(info, CHA+RBCL) & 0x1f);
 
 		/* Zero fifo count could mean 0 or 32 bytes available.
@@ -981,7 +981,7 @@ static void rx_ready_async(MGSLPC_INFO *info, int tcd)
 		fifo_count = 32;
 
 	tty_buffer_request_room(tty, fifo_count);
-	/* Flush received async data to receive data buffer. */ 
+	/* Flush received async data to receive data buffer. */
 	while (fifo_count) {
 		data   = read_reg(info, CHA + RXFIFO);
 		status = read_reg(info, CHA + RXFIFO);
@@ -995,7 +995,7 @@ static void rx_ready_async(MGSLPC_INFO *info, int tcd)
 		// BIT6:framing error
 
 		if (status & (BIT7 + BIT6)) {
-			if (status & BIT7) 
+			if (status & BIT7)
 				icount->parity++;
 			else
 				icount->frame++;
@@ -1003,7 +1003,7 @@ static void rx_ready_async(MGSLPC_INFO *info, int tcd)
 			/* discard char if tty control flags say so */
 			if (status & info->ignore_status_mask)
 				continue;
-				
+
 			status &= info->read_status_mask;
 
 			if (status & BIT7)
@@ -1022,7 +1022,7 @@ static void rx_ready_async(MGSLPC_INFO *info, int tcd)
 			__FILE__,__LINE__,icount->rx,icount->brk,
 			icount->parity,icount->frame,icount->overrun);
 	}
-			
+
 	if (work)
 		tty_flip_buffer_push(tty);
 }
@@ -1032,7 +1032,7 @@ static void tx_done(MGSLPC_INFO *info)
 {
 	if (!info->tx_active)
 		return;
-			
+
 	info->tx_active = 0;
 	info->tx_aborting = 0;
 
@@ -1040,8 +1040,8 @@ static void tx_done(MGSLPC_INFO *info)
 		return;
 
 	info->tx_count = info->tx_put = info->tx_get = 0;
-	del_timer(&info->tx_timer);	
-	
+	del_timer(&info->tx_timer);
+
 	if (info->drop_rts_on_tx_done) {
 		get_signals(info);
 		if (info->serial_signals & SerialSignal_RTS) {
@@ -1054,7 +1054,7 @@ static void tx_done(MGSLPC_INFO *info)
 #if SYNCLINK_GENERIC_HDLC
 	if (info->netcount)
 		hdlcdev_tx_done(info);
-	else 
+	else
 #endif
 	{
 		if (info->tty->stopped || info->tty->hw_stopped) {
@@ -1090,7 +1090,7 @@ static void tx_ready(MGSLPC_INFO *info)
 
 	while (info->tx_count && fifo_count) {
 		c = min(2, min_t(int, fifo_count, min(info->tx_count, TXBUFSIZE - info->tx_get)));
-		
+
 		if (c == 1) {
 			write_reg(info, CHA + TXFIFO, *(info->tx_buf + info->tx_get));
 		} else {
@@ -1220,9 +1220,9 @@ static void ri_change(MGSLPC_INFO *info)
 }
 
 /* Interrupt service routine entry point.
- * 	
+ *
  * Arguments:
- * 
+ *
  * irq     interrupt number that caused interrupt
  * dev_id  device ID supplied during interrupt registration
  */
@@ -1233,18 +1233,18 @@ static irqreturn_t mgslpc_isr(int irq, void *dev_id)
 	unsigned char gis, pis;
 	int count=0;
 
-	if (debug_level >= DEBUG_LEVEL_ISR)	
+	if (debug_level >= DEBUG_LEVEL_ISR)
 		printk("mgslpc_isr(%d) entry.\n", irq);
 	if (!info)
 		return IRQ_NONE;
-		
+
 	if (!(info->p_dev->_locked))
 		return IRQ_HANDLED;
 
 	spin_lock(&info->lock);
 
 	while ((gis = read_reg(info, CHA + GIS))) {
-		if (debug_level >= DEBUG_LEVEL_ISR)	
+		if (debug_level >= DEBUG_LEVEL_ISR)
 			printk("mgslpc_isr %s gis=%04X\n", info->device_name,gis);
 
 		if ((gis & 0x70) || count > 1000) {
@@ -1268,7 +1268,7 @@ static irqreturn_t mgslpc_isr(int irq, void *dev_id)
 				irq_disable(info, CHA, IRQ_TIMER);
 			}
 
-			/* receive IRQs */ 
+			/* receive IRQs */
 			if (isr & IRQ_EXITHUNT) {
 				info->icount.exithunt++;
 				wake_up_interruptible(&info->event_wait_q);
@@ -1283,12 +1283,12 @@ static irqreturn_t mgslpc_isr(int irq, void *dev_id)
 			}
 			if (isr & (IRQ_RXEOM + IRQ_RXFIFO)) {
 				if (info->params.mode == MGSL_MODE_HDLC)
-					rx_ready_hdlc(info, isr & IRQ_RXEOM); 
+					rx_ready_hdlc(info, isr & IRQ_RXEOM);
 				else
 					rx_ready_async(info, isr & IRQ_RXEOM);
 			}
 
-			/* transmit IRQs */ 
+			/* transmit IRQs */
 			if (isr & IRQ_UNDERRUN) {
 				if (info->tx_aborting)
 					info->icount.txabort++;
@@ -1311,13 +1311,13 @@ static irqreturn_t mgslpc_isr(int irq, void *dev_id)
 				ri_change(info);
 		}
 	}
-	
-	/* Request bottom half processing if there's something 
+
+	/* Request bottom half processing if there's something
 	 * for it to do and the bh is not already running
 	 */
 
 	if (info->pending_bh && !info->bh_running && !info->bh_requested) {
-		if ( debug_level >= DEBUG_LEVEL_ISR )	
+		if ( debug_level >= DEBUG_LEVEL_ISR )
 			printk("%s(%d):%s queueing bh task.\n",
 				__FILE__,__LINE__,info->device_name);
 		schedule_work(&info->task);
@@ -1325,8 +1325,8 @@ static irqreturn_t mgslpc_isr(int irq, void *dev_id)
 	}
 
 	spin_unlock(&info->lock);
-	
-	if (debug_level >= DEBUG_LEVEL_ISR)	
+
+	if (debug_level >= DEBUG_LEVEL_ISR)
 		printk("%s(%d):mgslpc_isr(%d)exit.\n",
 		       __FILE__,__LINE__,irq);
 
@@ -1338,13 +1338,13 @@ static irqreturn_t mgslpc_isr(int irq, void *dev_id)
 static int startup(MGSLPC_INFO * info)
 {
 	int retval = 0;
-	
+
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):startup(%s)\n",__FILE__,__LINE__,info->device_name);
-		
+
 	if (info->flags & ASYNC_INITIALIZED)
 		return 0;
-	
+
 	if (!info->tx_buf) {
 		/* allocate a page of memory for a transmit buffer */
 		info->tx_buf = (unsigned char *)get_zeroed_page(GFP_KERNEL);
@@ -1356,18 +1356,18 @@ static int startup(MGSLPC_INFO * info)
 	}
 
 	info->pending_bh = 0;
-	
+
 	memset(&info->icount, 0, sizeof(info->icount));
 
 	setup_timer(&info->tx_timer, tx_timeout, (unsigned long)info);
 
 	/* Allocate and claim adapter resources */
 	retval = claim_resources(info);
-	
+
 	/* perform existance check and diagnostics */
 	if ( !retval )
 		retval = adapter_test(info);
-		
+
 	if ( retval ) {
   		if (capable(CAP_SYS_ADMIN) && info->tty)
 			set_bit(TTY_IO_ERROR, &info->tty->flags);
@@ -1377,12 +1377,12 @@ static int startup(MGSLPC_INFO * info)
 
 	/* program hardware for current parameters */
 	mgslpc_change_params(info);
-	
+
 	if (info->tty)
 		clear_bit(TTY_IO_ERROR, &info->tty->flags);
 
 	info->flags |= ASYNC_INITIALIZED;
-	
+
 	return 0;
 }
 
@@ -1391,7 +1391,7 @@ static int startup(MGSLPC_INFO * info)
 static void shutdown(MGSLPC_INFO * info)
 {
 	unsigned long flags;
-	
+
 	if (!(info->flags & ASYNC_INITIALIZED))
 		return;
 
@@ -1418,16 +1418,16 @@ static void shutdown(MGSLPC_INFO * info)
 
 	/* TODO:disable interrupts instead of reset to preserve signal states */
 	reset_device(info);
-	
+
  	if (!info->tty || info->tty->termios->c_cflag & HUPCL) {
  		info->serial_signals &= ~(SerialSignal_DTR + SerialSignal_RTS);
 		set_signals(info);
 	}
-	
+
 	spin_unlock_irqrestore(&info->lock,flags);
 
-	release_resources(info);	
-	
+	release_resources(info);
+
 	if (info->tty)
 		set_bit(TTY_IO_ERROR, &info->tty->flags);
 
@@ -1439,18 +1439,18 @@ static void mgslpc_program_hw(MGSLPC_INFO *info)
 	unsigned long flags;
 
 	spin_lock_irqsave(&info->lock,flags);
-	
+
 	rx_stop(info);
 	tx_stop(info);
 	info->tx_count = info->tx_put = info->tx_get = 0;
-	
+
 	if (info->params.mode == MGSL_MODE_HDLC || info->netcount)
 		hdlc_mode(info);
 	else
 		async_mode(info);
-		
+
 	set_signals(info);
-	
+
 	info->dcd_chkcount = 0;
 	info->cts_chkcount = 0;
 	info->ri_chkcount = 0;
@@ -1459,10 +1459,10 @@ static void mgslpc_program_hw(MGSLPC_INFO *info)
 	irq_enable(info, CHB, IRQ_DCD | IRQ_CTS);
 	port_irq_enable(info, (unsigned char) PVR_DSR | PVR_RI);
 	get_signals(info);
-		
+
 	if (info->netcount || info->tty->termios->c_cflag & CREAD)
 		rx_start(info);
-		
+
 	spin_unlock_irqrestore(&info->lock,flags);
 }
 
@@ -1475,11 +1475,11 @@ static void mgslpc_change_params(MGSLPC_INFO *info)
 
 	if (!info->tty || !info->tty->termios)
 		return;
-		
+
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_change_params(%s)\n",
 			 __FILE__,__LINE__, info->device_name );
-			 
+
 	cflag = info->tty->termios->c_cflag;
 
 	/* if B0 rate (hangup) specified then negate DTR and RTS */
@@ -1488,9 +1488,9 @@ static void mgslpc_change_params(MGSLPC_INFO *info)
 		info->serial_signals |= SerialSignal_RTS + SerialSignal_DTR;
 	else
 		info->serial_signals &= ~(SerialSignal_RTS + SerialSignal_DTR);
-	
+
 	/* byte size and parity */
-	
+
 	switch (cflag & CSIZE) {
 	case CS5: info->params.data_bits = 5; break;
 	case CS6: info->params.data_bits = 6; break;
@@ -1498,7 +1498,7 @@ static void mgslpc_change_params(MGSLPC_INFO *info)
 	case CS8: info->params.data_bits = 8; break;
 	default:  info->params.data_bits = 7; break;
 	}
-	      
+
 	if (cflag & CSTOPB)
 		info->params.stop_bits = 2;
 	else
@@ -1519,7 +1519,7 @@ static void mgslpc_change_params(MGSLPC_INFO *info)
 	/* calculate number of jiffies to transmit a full
 	 * FIFO (32 bytes) at specified data rate
 	 */
-	bits_per_char = info->params.data_bits + 
+	bits_per_char = info->params.data_bits +
 			info->params.stop_bits + 1;
 
 	/* if port data rate is set to 460800 or less then
@@ -1529,9 +1529,9 @@ static void mgslpc_change_params(MGSLPC_INFO *info)
 	if (info->params.data_rate <= 460800) {
 		info->params.data_rate = tty_get_baud_rate(info->tty);
 	}
-	
+
 	if ( info->params.data_rate ) {
-		info->timeout = (32*HZ*bits_per_char) / 
+		info->timeout = (32*HZ*bits_per_char) /
 				info->params.data_rate;
 	}
 	info->timeout += HZ/50;		/* Add .02 seconds of slop */
@@ -1540,14 +1540,14 @@ static void mgslpc_change_params(MGSLPC_INFO *info)
 		info->flags |= ASYNC_CTS_FLOW;
 	else
 		info->flags &= ~ASYNC_CTS_FLOW;
-		
+
 	if (cflag & CLOCAL)
 		info->flags &= ~ASYNC_CHECK_CD;
 	else
 		info->flags |= ASYNC_CHECK_CD;
 
 	/* process tty input control flags */
-	
+
 	info->read_status_mask = 0;
 	if (I_INPCK(info->tty))
 		info->read_status_mask |= BIT7 | BIT6;
@@ -1576,7 +1576,7 @@ static void mgslpc_put_char(struct tty_struct *tty, unsigned char ch)
 		return;
 
 	spin_lock_irqsave(&info->lock,flags);
-	
+
 	if (info->params.mode == MGSL_MODE_ASYNC || !info->tx_active) {
 		if (info->tx_count < TXBUFSIZE - 1) {
 			info->tx_buf[info->tx_put++] = ch;
@@ -1584,7 +1584,7 @@ static void mgslpc_put_char(struct tty_struct *tty, unsigned char ch)
 			info->tx_count++;
 		}
 	}
-	
+
 	spin_unlock_irqrestore(&info->lock,flags);
 }
 
@@ -1595,11 +1595,11 @@ static void mgslpc_flush_chars(struct tty_struct *tty)
 {
 	MGSLPC_INFO *info = (MGSLPC_INFO *)tty->driver_data;
 	unsigned long flags;
-				
+
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk( "%s(%d):mgslpc_flush_chars() entry on %s tx_count=%d\n",
 			__FILE__,__LINE__,info->device_name,info->tx_count);
-	
+
 	if (mgslpc_paranoia_check(info, tty->name, "mgslpc_flush_chars"))
 		return;
 
@@ -1618,13 +1618,13 @@ static void mgslpc_flush_chars(struct tty_struct *tty)
 }
 
 /* Send a block of data
- * 	
+ *
  * Arguments:
- * 
+ *
  * tty        pointer to tty information structure
  * buf	      pointer to buffer containing send data
  * count      size of send data in bytes
- * 	
+ *
  * Returns: number of characters written
  */
 static int mgslpc_write(struct tty_struct * tty,
@@ -1633,11 +1633,11 @@ static int mgslpc_write(struct tty_struct * tty,
 	int c, ret = 0;
 	MGSLPC_INFO *info = (MGSLPC_INFO *)tty->driver_data;
 	unsigned long flags;
-	
+
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk( "%s(%d):mgslpc_write(%s) count=%d\n",
 			__FILE__,__LINE__,info->device_name,count);
-	
+
 	if (mgslpc_paranoia_check(info, tty->name, "mgslpc_write") ||
 		!info->tx_buf)
 		goto cleanup;
@@ -1659,7 +1659,7 @@ static int mgslpc_write(struct tty_struct * tty,
 			    TXBUFSIZE - info->tx_put));
 		if (c <= 0)
 			break;
-			
+
 		memcpy(info->tx_buf + info->tx_put, buf, c);
 
 		spin_lock_irqsave(&info->lock,flags);
@@ -1678,7 +1678,7 @@ start:
 		 	tx_start(info);
 		spin_unlock_irqrestore(&info->lock,flags);
  	}
-cleanup:	
+cleanup:
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk( "%s(%d):mgslpc_write(%s) returning=%d\n",
 			__FILE__,__LINE__,info->device_name,ret);
@@ -1691,7 +1691,7 @@ static int mgslpc_write_room(struct tty_struct *tty)
 {
 	MGSLPC_INFO *info = (MGSLPC_INFO *)tty->driver_data;
 	int ret;
-				
+
 	if (mgslpc_paranoia_check(info, tty->name, "mgslpc_write_room"))
 		return 0;
 
@@ -1706,7 +1706,7 @@ static int mgslpc_write_room(struct tty_struct *tty)
 		if (ret < 0)
 			ret = 0;
 	}
-	
+
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_write_room(%s)=%d\n",
 			 __FILE__,__LINE__, info->device_name, ret);
@@ -1719,14 +1719,14 @@ static int mgslpc_chars_in_buffer(struct tty_struct *tty)
 {
 	MGSLPC_INFO *info = (MGSLPC_INFO *)tty->driver_data;
 	int rc;
-		 
+
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_chars_in_buffer(%s)\n",
 			 __FILE__,__LINE__, info->device_name );
-			 
+
 	if (mgslpc_paranoia_check(info, tty->name, "mgslpc_chars_in_buffer"))
 		return 0;
-		
+
 	if (info->params.mode == MGSL_MODE_HDLC)
 		rc = info->tx_active ? info->max_frame_size : 0;
 	else
@@ -1735,7 +1735,7 @@ static int mgslpc_chars_in_buffer(struct tty_struct *tty)
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_chars_in_buffer(%s)=%d\n",
 			 __FILE__,__LINE__, info->device_name, rc);
-			 
+
 	return rc;
 }
 
@@ -1745,17 +1745,17 @@ static void mgslpc_flush_buffer(struct tty_struct *tty)
 {
 	MGSLPC_INFO *info = (MGSLPC_INFO *)tty->driver_data;
 	unsigned long flags;
-	
+
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_flush_buffer(%s) entry\n",
 			 __FILE__,__LINE__, info->device_name );
-	
+
 	if (mgslpc_paranoia_check(info, tty->name, "mgslpc_flush_buffer"))
 		return;
-		
-	spin_lock_irqsave(&info->lock,flags); 
+
+	spin_lock_irqsave(&info->lock,flags);
 	info->tx_count = info->tx_put = info->tx_get = 0;
-	del_timer(&info->tx_timer);	
+	del_timer(&info->tx_timer);
 	spin_unlock_irqrestore(&info->lock,flags);
 
 	wake_up_interruptible(&tty->write_wait);
@@ -1772,7 +1772,7 @@ static void mgslpc_send_xchar(struct tty_struct *tty, char ch)
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_send_xchar(%s,%d)\n",
 			 __FILE__,__LINE__, info->device_name, ch );
-			 
+
 	if (mgslpc_paranoia_check(info, tty->name, "mgslpc_send_xchar"))
 		return;
 
@@ -1791,17 +1791,17 @@ static void mgslpc_throttle(struct tty_struct * tty)
 {
 	MGSLPC_INFO *info = (MGSLPC_INFO *)tty->driver_data;
 	unsigned long flags;
-	
+
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_throttle(%s) entry\n",
 			 __FILE__,__LINE__, info->device_name );
 
 	if (mgslpc_paranoia_check(info, tty->name, "mgslpc_throttle"))
 		return;
-	
+
 	if (I_IXOFF(tty))
 		mgslpc_send_xchar(tty, STOP_CHAR(tty));
- 
+
  	if (tty->termios->c_cflag & CRTSCTS) {
 		spin_lock_irqsave(&info->lock,flags);
 		info->serial_signals &= ~SerialSignal_RTS;
@@ -1816,21 +1816,21 @@ static void mgslpc_unthrottle(struct tty_struct * tty)
 {
 	MGSLPC_INFO *info = (MGSLPC_INFO *)tty->driver_data;
 	unsigned long flags;
-	
+
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_unthrottle(%s) entry\n",
 			 __FILE__,__LINE__, info->device_name );
 
 	if (mgslpc_paranoia_check(info, tty->name, "mgslpc_unthrottle"))
 		return;
-	
+
 	if (I_IXOFF(tty)) {
 		if (info->x_char)
 			info->x_char = 0;
 		else
 			mgslpc_send_xchar(tty, START_CHAR(tty));
 	}
-	
+
  	if (tty->termios->c_cflag & CRTSCTS) {
 		spin_lock_irqsave(&info->lock,flags);
 		info->serial_signals |= SerialSignal_RTS;
@@ -1870,9 +1870,9 @@ static int get_params(MGSLPC_INFO * info, MGSL_PARAMS __user *user_params)
 }
 
 /* set the serial parameters
- * 	
+ *
  * Arguments:
- * 
+ *
  * 	info		pointer to device instance data
  * 	new_params	user buffer containing new serial params
  *
@@ -1883,7 +1883,7 @@ static int set_params(MGSLPC_INFO * info, MGSL_PARAMS __user *new_params)
  	unsigned long flags;
 	MGSL_PARAMS tmp_params;
 	int err;
- 
+
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):set_params %s\n", __FILE__,__LINE__,
 			info->device_name );
@@ -1894,13 +1894,13 @@ static int set_params(MGSLPC_INFO * info, MGSL_PARAMS __user *new_params)
 				__FILE__,__LINE__,info->device_name);
 		return -EFAULT;
 	}
-	
+
 	spin_lock_irqsave(&info->lock,flags);
 	memcpy(&info->params,&tmp_params,sizeof(MGSL_PARAMS));
 	spin_unlock_irqrestore(&info->lock,flags);
-	
+
  	mgslpc_change_params(info);
-	
+
 	return 0;
 }
 
@@ -1963,10 +1963,10 @@ static int set_interface(MGSLPC_INFO * info, int if_mode)
 static int set_txenable(MGSLPC_INFO * info, int enable)
 {
  	unsigned long flags;
- 
+
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("set_txenable(%s,%d)\n", info->device_name, enable);
-			
+
 	spin_lock_irqsave(&info->lock,flags);
 	if (enable) {
 		if (!info->tx_enabled)
@@ -1982,10 +1982,10 @@ static int set_txenable(MGSLPC_INFO * info, int enable)
 static int tx_abort(MGSLPC_INFO * info)
 {
  	unsigned long flags;
- 
+
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("tx_abort(%s)\n", info->device_name);
-			
+
 	spin_lock_irqsave(&info->lock,flags);
 	if (info->tx_active && info->tx_count &&
 	    info->params.mode == MGSL_MODE_HDLC) {
@@ -2002,10 +2002,10 @@ static int tx_abort(MGSLPC_INFO * info)
 static int set_rxenable(MGSLPC_INFO * info, int enable)
 {
  	unsigned long flags;
- 
+
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("set_rxenable(%s,%d)\n", info->device_name, enable);
-			
+
 	spin_lock_irqsave(&info->lock,flags);
 	if (enable) {
 		if (!info->rx_enabled)
@@ -2019,7 +2019,7 @@ static int set_rxenable(MGSLPC_INFO * info, int enable)
 }
 
 /* wait for specified event to occur
- * 	
+ *
  * Arguments:	 	info	pointer to device instance data
  * 			mask	pointer to bitmask of events to wait for
  * Return Value:	0 	if successful and bit mask updated with
@@ -2040,7 +2040,7 @@ static int wait_events(MGSLPC_INFO * info, int __user *mask_ptr)
 	COPY_FROM_USER(rc,&mask, mask_ptr, sizeof(int));
 	if (rc)
 		return  -EFAULT;
-		 
+
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("wait_events(%s,%d)\n", info->device_name, mask);
 
@@ -2062,24 +2062,24 @@ static int wait_events(MGSLPC_INFO * info, int __user *mask_ptr)
 	/* save current irq counts */
 	cprev = info->icount;
 	oldsigs = info->input_signal_events;
-	
+
 	if ((info->params.mode == MGSL_MODE_HDLC) &&
 	    (mask & MgslEvent_ExitHuntMode))
 		irq_enable(info, CHA, IRQ_EXITHUNT);
-	
+
 	set_current_state(TASK_INTERRUPTIBLE);
 	add_wait_queue(&info->event_wait_q, &wait);
-	
+
 	spin_unlock_irqrestore(&info->lock,flags);
-	
-	
+
+
 	for(;;) {
 		schedule();
 		if (signal_pending(current)) {
 			rc = -ERESTARTSYS;
 			break;
 		}
-			
+
 		/* get current irq counts */
 		spin_lock_irqsave(&info->lock,flags);
 		cnow = info->icount;
@@ -2115,11 +2115,11 @@ static int wait_events(MGSLPC_INFO * info, int __user *mask_ptr)
 			  (cnow.rxidle      != cprev.rxidle     ? MgslEvent_IdleReceived:0) );
 		if (events)
 			break;
-		
+
 		cprev = cnow;
 		oldsigs = newsigs;
 	}
-	
+
 	remove_wait_queue(&info->event_wait_q, &wait);
 	set_current_state(TASK_RUNNING);
 
@@ -2247,42 +2247,42 @@ static void mgslpc_break(struct tty_struct *tty, int break_state)
 {
 	MGSLPC_INFO * info = (MGSLPC_INFO *)tty->driver_data;
 	unsigned long flags;
-	
+
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_break(%s,%d)\n",
 			 __FILE__,__LINE__, info->device_name, break_state);
-			 
+
 	if (mgslpc_paranoia_check(info, tty->name, "mgslpc_break"))
 		return;
 
 	spin_lock_irqsave(&info->lock,flags);
  	if (break_state == -1)
 		set_reg_bits(info, CHA+DAFO, BIT6);
-	else 
+	else
 		clear_reg_bits(info, CHA+DAFO, BIT6);
 	spin_unlock_irqrestore(&info->lock,flags);
 }
 
 /* Service an IOCTL request
- * 	
+ *
  * Arguments:
- * 
+ *
  * 	tty	pointer to tty instance data
  * 	file	pointer to associated file object for device
  * 	cmd	IOCTL command code
  * 	arg	command argument/context
- * 	
+ *
  * Return Value:	0 if success, otherwise error code
  */
 static int mgslpc_ioctl(struct tty_struct *tty, struct file * file,
 			unsigned int cmd, unsigned long arg)
 {
 	MGSLPC_INFO * info = (MGSLPC_INFO *)tty->driver_data;
-	
+
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_ioctl %s cmd=%08X\n", __FILE__,__LINE__,
 			info->device_name, cmd );
-	
+
 	if (mgslpc_paranoia_check(info, tty->name, "mgslpc_ioctl"))
 		return -ENODEV;
 
@@ -2302,7 +2302,7 @@ static int ioctl_common(MGSLPC_INFO *info, unsigned int cmd, unsigned long arg)
 	struct serial_icounter_struct __user *p_cuser;	/* user space */
 	void __user *argp = (void __user *)arg;
 	unsigned long flags;
-	
+
 	switch (cmd) {
 	case MGSL_IOCGPARAMS:
 		return get_params(info, argp);
@@ -2363,9 +2363,9 @@ static int ioctl_common(MGSLPC_INFO *info, unsigned int cmd, unsigned long arg)
 }
 
 /* Set new termios settings
- * 	
+ *
  * Arguments:
- * 
+ *
  * 	tty		pointer to tty structure
  * 	termios		pointer to buffer to hold returned old termios
  */
@@ -2373,14 +2373,14 @@ static void mgslpc_set_termios(struct tty_struct *tty, struct ktermios *old_term
 {
 	MGSLPC_INFO *info = (MGSLPC_INFO *)tty->driver_data;
 	unsigned long flags;
-	
+
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_set_termios %s\n", __FILE__,__LINE__,
 			tty->driver->name );
-	
+
 	/* just return if nothing has changed */
 	if ((tty->termios->c_cflag == old_termios->c_cflag)
-	    && (RELEVANT_IFLAG(tty->termios->c_iflag) 
+	    && (RELEVANT_IFLAG(tty->termios->c_iflag)
 		== RELEVANT_IFLAG(old_termios->c_iflag)))
 	  return;
 
@@ -2394,12 +2394,12 @@ static void mgslpc_set_termios(struct tty_struct *tty, struct ktermios *old_term
 	 	set_signals(info);
 		spin_unlock_irqrestore(&info->lock,flags);
 	}
-	
+
 	/* Handle transition away from B0 status */
 	if (!(old_termios->c_cflag & CBAUD) &&
 	    tty->termios->c_cflag & CBAUD) {
 		info->serial_signals |= SerialSignal_DTR;
- 		if (!(tty->termios->c_cflag & CRTSCTS) || 
+ 		if (!(tty->termios->c_cflag & CRTSCTS) ||
  		    !test_bit(TTY_THROTTLED, &tty->flags)) {
 			info->serial_signals |= SerialSignal_RTS;
  		}
@@ -2407,7 +2407,7 @@ static void mgslpc_set_termios(struct tty_struct *tty, struct ktermios *old_term
 	 	set_signals(info);
 		spin_unlock_irqrestore(&info->lock,flags);
 	}
-	
+
 	/* Handle turning off CRTSCTS */
 	if (old_termios->c_cflag & CRTSCTS &&
 	    !(tty->termios->c_cflag & CRTSCTS)) {
@@ -2422,17 +2422,17 @@ static void mgslpc_close(struct tty_struct *tty, struct file * filp)
 
 	if (mgslpc_paranoia_check(info, tty->name, "mgslpc_close"))
 		return;
-	
+
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_close(%s) entry, count=%d\n",
 			 __FILE__,__LINE__, info->device_name, info->count);
-			 
+
 	if (!info->count)
 		return;
 
 	if (tty_hung_up_p(filp))
 		goto cleanup;
-			
+
 	if ((tty->count == 1) && (info->count != 1)) {
 		/*
 		 * tty->count is 1 and the tty structure will be freed.
@@ -2443,30 +2443,30 @@ static void mgslpc_close(struct tty_struct *tty, struct file * filp)
 		       "info->count is %d\n", info->count);
 		info->count = 1;
 	}
-	
+
 	info->count--;
-	
+
 	/* if at least one open remaining, leave hardware active */
 	if (info->count)
 		goto cleanup;
-	
+
 	info->flags |= ASYNC_CLOSING;
-	
-	/* set tty->closing to notify line discipline to 
+
+	/* set tty->closing to notify line discipline to
 	 * only process XON/XOFF characters. Only the N_TTY
 	 * discipline appears to use this (ppp does not).
 	 */
 	tty->closing = 1;
-	
+
 	/* wait for transmit data to clear all layers */
-	
+
 	if (info->closing_wait != ASYNC_CLOSING_WAIT_NONE) {
 		if (debug_level >= DEBUG_LEVEL_INFO)
 			printk("%s(%d):mgslpc_close(%s) calling tty_wait_until_sent\n",
 				 __FILE__,__LINE__, info->device_name );
 		tty_wait_until_sent(tty, info->closing_wait);
 	}
-		
+
  	if (info->flags & ASYNC_INITIALIZED)
  		mgslpc_wait_until_sent(tty, info->timeout);
 
@@ -2474,24 +2474,24 @@ static void mgslpc_close(struct tty_struct *tty, struct file * filp)
 		tty->driver->flush_buffer(tty);
 
 	ldisc_flush_buffer(tty);
-		
+
 	shutdown(info);
-	
+
 	tty->closing = 0;
 	info->tty = NULL;
-	
+
 	if (info->blocked_open) {
 		if (info->close_delay) {
 			msleep_interruptible(jiffies_to_msecs(info->close_delay));
 		}
 		wake_up_interruptible(&info->open_wait);
 	}
-	
+
 	info->flags &= ~(ASYNC_NORMAL_ACTIVE|ASYNC_CLOSING);
-			 
+
 	wake_up_interruptible(&info->close_wait);
-	
-cleanup:			
+
+cleanup:
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_close(%s) exit, count=%d\n", __FILE__,__LINE__,
 			tty->driver->name, info->count);
@@ -2510,31 +2510,31 @@ static void mgslpc_wait_until_sent(struct tty_struct *tty, int timeout)
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_wait_until_sent(%s) entry\n",
 			 __FILE__,__LINE__, info->device_name );
-      
+
 	if (mgslpc_paranoia_check(info, tty->name, "mgslpc_wait_until_sent"))
 		return;
 
 	if (!(info->flags & ASYNC_INITIALIZED))
 		goto exit;
-	 
+
 	orig_jiffies = jiffies;
-      
+
 	/* Set check interval to 1/5 of estimated time to
 	 * send a character, and make it at least 1. The check
 	 * interval should also be less than the timeout.
 	 * Note: use tight timings here to satisfy the NIST-PCTS.
-	 */ 
-       
+	 */
+
 	if ( info->params.data_rate ) {
 	       	char_time = info->timeout/(32 * 5);
 		if (!char_time)
 			char_time++;
 	} else
 		char_time = 1;
-		
+
 	if (timeout)
 		char_time = min_t(unsigned long, char_time, timeout);
-		
+
 	if (info->params.mode == MGSL_MODE_HDLC) {
 		while (info->tx_active) {
 			msleep_interruptible(jiffies_to_msecs(char_time));
@@ -2553,7 +2553,7 @@ static void mgslpc_wait_until_sent(struct tty_struct *tty, int timeout)
 				break;
 		}
 	}
-      
+
 exit:
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_wait_until_sent(%s) exit\n",
@@ -2566,18 +2566,18 @@ exit:
 static void mgslpc_hangup(struct tty_struct *tty)
 {
 	MGSLPC_INFO * info = (MGSLPC_INFO *)tty->driver_data;
-	
+
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_hangup(%s)\n",
 			 __FILE__,__LINE__, info->device_name );
-			 
+
 	if (mgslpc_paranoia_check(info, tty->name, "mgslpc_hangup"))
 		return;
 
 	mgslpc_flush_buffer(tty);
 	shutdown(info);
-	
-	info->count = 0;	
+
+	info->count = 0;
 	info->flags &= ~ASYNC_NORMAL_ACTIVE;
 	info->tty = NULL;
 
@@ -2594,7 +2594,7 @@ static int block_til_ready(struct tty_struct *tty, struct file *filp,
 	int		retval;
 	int		do_clocal = 0, extra_count = 0;
 	unsigned long	flags;
-	
+
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):block_til_ready on %s\n",
 			 __FILE__,__LINE__, tty->driver->name );
@@ -2615,10 +2615,10 @@ static int block_til_ready(struct tty_struct *tty, struct file *filp,
 	 * mgslpc_close() knows when to free things.  We restore it upon
 	 * exit, either normal or abnormal.
 	 */
-	 
+
 	retval = 0;
 	add_wait_queue(&info->open_wait, &wait);
-	
+
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):block_til_ready before block on %s count=%d\n",
 			 __FILE__,__LINE__, tty->driver->name, info->count );
@@ -2630,7 +2630,7 @@ static int block_til_ready(struct tty_struct *tty, struct file *filp,
 	}
 	spin_unlock_irqrestore(&info->lock, flags);
 	info->blocked_open++;
-	
+
 	while (1) {
 		if ((tty->termios->c_cflag & CBAUD)) {
 			spin_lock_irqsave(&info->lock,flags);
@@ -2638,50 +2638,50 @@ static int block_til_ready(struct tty_struct *tty, struct file *filp,
 		 	set_signals(info);
 			spin_unlock_irqrestore(&info->lock,flags);
 		}
-		
+
 		set_current_state(TASK_INTERRUPTIBLE);
-		
+
 		if (tty_hung_up_p(filp) || !(info->flags & ASYNC_INITIALIZED)){
 			retval = (info->flags & ASYNC_HUP_NOTIFY) ?
 					-EAGAIN : -ERESTARTSYS;
 			break;
 		}
-		
+
 		spin_lock_irqsave(&info->lock,flags);
 	 	get_signals(info);
 		spin_unlock_irqrestore(&info->lock,flags);
-		
+
  		if (!(info->flags & ASYNC_CLOSING) &&
  		    (do_clocal || (info->serial_signals & SerialSignal_DCD)) ) {
  			break;
 		}
-			
+
 		if (signal_pending(current)) {
 			retval = -ERESTARTSYS;
 			break;
 		}
-		
+
 		if (debug_level >= DEBUG_LEVEL_INFO)
 			printk("%s(%d):block_til_ready blocking on %s count=%d\n",
 				 __FILE__,__LINE__, tty->driver->name, info->count );
-				 
+
 		schedule();
 	}
-	
+
 	set_current_state(TASK_RUNNING);
 	remove_wait_queue(&info->open_wait, &wait);
-	
+
 	if (extra_count)
 		info->count++;
 	info->blocked_open--;
-	
+
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):block_til_ready after blocking on %s count=%d\n",
 			 __FILE__,__LINE__, tty->driver->name, info->count );
-			 
+
 	if (!retval)
 		info->flags |= ASYNC_NORMAL_ACTIVE;
-		
+
 	return retval;
 }
 
@@ -2691,7 +2691,7 @@ static int mgslpc_open(struct tty_struct *tty, struct file * filp)
 	int 			retval, line;
 	unsigned long flags;
 
-	/* verify range of specified line number */	
+	/* verify range of specified line number */
 	line = tty->index;
 	if ((line < 0) || (line >= mgslpc_device_count)) {
 		printk("%s(%d):mgslpc_open with invalid line #%d.\n",
@@ -2705,10 +2705,10 @@ static int mgslpc_open(struct tty_struct *tty, struct file * filp)
 		info = info->next_device;
 	if (mgslpc_paranoia_check(info, tty->name, "mgslpc_open"))
 		return -ENODEV;
-	
+
 	tty->driver_data = info;
 	info->tty = tty;
-		
+
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_open(%s), old ref count = %d\n",
 			 __FILE__,__LINE__,tty->driver->name, info->count);
@@ -2721,7 +2721,7 @@ static int mgslpc_open(struct tty_struct *tty, struct file * filp)
 			-EAGAIN : -ERESTARTSYS);
 		goto cleanup;
 	}
-	
+
 	info->tty->low_latency = (info->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 
 	spin_lock_irqsave(&info->netlock, flags);
@@ -2752,15 +2752,15 @@ static int mgslpc_open(struct tty_struct *tty, struct file * filp)
 		printk("%s(%d):mgslpc_open(%s) success\n",
 			 __FILE__,__LINE__, info->device_name);
 	retval = 0;
-	
-cleanup:			
+
+cleanup:
 	if (retval) {
 		if (tty->count == 1)
 			info->tty = NULL; /* tty layer will release tty struct */
 		if(info->count)
 			info->count--;
 	}
-	
+
 	return retval;
 }
 
@@ -2781,7 +2781,7 @@ static inline int line_info(char *buf, MGSLPC_INFO *info)
 	spin_lock_irqsave(&info->lock,flags);
  	get_signals(info);
 	spin_unlock_irqrestore(&info->lock,flags);
-	
+
 	stat_buf[0] = 0;
 	stat_buf[1] = 0;
 	if (info->serial_signals & SerialSignal_RTS)
@@ -2805,7 +2805,7 @@ static inline int line_info(char *buf, MGSLPC_INFO *info)
 		if (info->icount.txabort)
 			ret += sprintf(buf+ret, " txabort:%d", info->icount.txabort);
 		if (info->icount.rxshort)
-			ret += sprintf(buf+ret, " rxshort:%d", info->icount.rxshort);	
+			ret += sprintf(buf+ret, " rxshort:%d", info->icount.rxshort);
 		if (info->icount.rxlong)
 			ret += sprintf(buf+ret, " rxlong:%d", info->icount.rxlong);
 		if (info->icount.rxover)
@@ -2820,18 +2820,18 @@ static inline int line_info(char *buf, MGSLPC_INFO *info)
 		if (info->icount.parity)
 			ret += sprintf(buf+ret, " pe:%d", info->icount.parity);
 		if (info->icount.brk)
-			ret += sprintf(buf+ret, " brk:%d", info->icount.brk);	
+			ret += sprintf(buf+ret, " brk:%d", info->icount.brk);
 		if (info->icount.overrun)
 			ret += sprintf(buf+ret, " oe:%d", info->icount.overrun);
 	}
-	
+
 	/* Append serial signal status to end */
 	ret += sprintf(buf+ret, " %s\n", stat_buf+1);
-	
+
 	ret += sprintf(buf+ret, "txactive=%d bh_req=%d bh_run=%d pending_bh=%x\n",
 		       info->tx_active,info->bh_requested,info->bh_running,
 		       info->pending_bh);
-	
+
 	return ret;
 }
 
@@ -2843,9 +2843,9 @@ static int mgslpc_read_proc(char *page, char **start, off_t off, int count,
 	int len = 0, l;
 	off_t	begin = 0;
 	MGSLPC_INFO *info;
-	
+
 	len += sprintf(page, "synclink driver:%s\n", driver_version);
-	
+
 	info = mgslpc_device_list;
 	while( info ) {
 		l = line_info(page + len, info);
@@ -2902,7 +2902,7 @@ static int claim_resources(MGSLPC_INFO *info)
 		printk( "Cant allocate rx buffer %s\n", info->device_name);
 		release_resources(info);
 		return -ENODEV;
-	}	
+	}
 	return 0;
 }
 
@@ -2915,7 +2915,7 @@ static void release_resources(MGSLPC_INFO *info)
 
 /* Add the specified device instance data structure to the
  * global linked list of devices and increment the device count.
- * 	
+ *
  * Arguments:		info	pointer to device instance data
  */
 static void mgslpc_add_device(MGSLPC_INFO *info)
@@ -2923,7 +2923,7 @@ static void mgslpc_add_device(MGSLPC_INFO *info)
 	info->next_device = NULL;
 	info->line = mgslpc_device_count;
 	sprintf(info->device_name,"ttySLP%d",info->line);
-	
+
 	if (info->line < MAX_DEVICE_COUNT) {
 		if (maxframe[info->line])
 			info->max_frame_size = maxframe[info->line];
@@ -2931,21 +2931,21 @@ static void mgslpc_add_device(MGSLPC_INFO *info)
 	}
 
 	mgslpc_device_count++;
-	
+
 	if (!mgslpc_device_list)
 		mgslpc_device_list = info;
-	else {	
+	else {
 		MGSLPC_INFO *current_dev = mgslpc_device_list;
 		while( current_dev->next_device )
 			current_dev = current_dev->next_device;
 		current_dev->next_device = info;
 	}
-	
+
 	if (info->max_frame_size < 4096)
 		info->max_frame_size = 4096;
 	else if (info->max_frame_size > 65535)
 		info->max_frame_size = 65535;
-	
+
 	printk( "SyncLink PC Card %s:IO=%04X IRQ=%d\n",
 		info->device_name, info->io_base, info->irq_level);
 
@@ -3060,7 +3060,7 @@ static int __init synclink_cs_init(void)
     }
 
     /* Initialize the tty_driver structure */
-	
+
     serial_driver->owner = THIS_MODULE;
     serial_driver->driver_name = "synclink_cs";
     serial_driver->name = "ttySLP";
@@ -3081,11 +3081,11 @@ static int __init synclink_cs_init(void)
 	    serial_driver = NULL;
 	    goto error;
     }
-			
+
     printk("%s %s, tty major#%d\n",
 	   driver_name, driver_version,
 	   serial_driver->major);
-	
+
     return 0;
 
 error:
@@ -3093,7 +3093,7 @@ error:
     return rc;
 }
 
-static void __exit synclink_cs_exit(void) 
+static void __exit synclink_cs_exit(void)
 {
 	synclink_cs_cleanup();
 }
@@ -3106,8 +3106,8 @@ static void mgslpc_set_rate(MGSLPC_INFO *info, unsigned char channel, unsigned i
 	unsigned int M, N;
 	unsigned char val;
 
-	/* note:standard BRG mode is broken in V3.2 chip 
-	 * so enhanced mode is always used 
+	/* note:standard BRG mode is broken in V3.2 chip
+	 * so enhanced mode is always used
 	 */
 
 	if (rate) {
@@ -3126,7 +3126,7 @@ static void mgslpc_set_rate(MGSLPC_INFO *info, unsigned char channel, unsigned i
 		 * divisor = (N+1)*2^M
 		 *
 		 * Note: M *must* not be zero (causes asymetric duty cycle)
-		 */ 
+		 */
 		write_reg(info, (unsigned char) (channel + BGR),
 				  (unsigned char) ((M << 6) + N));
 		val = read_reg(info, (unsigned char) (channel + CCR2)) & 0x3f;
@@ -3140,7 +3140,7 @@ static void mgslpc_set_rate(MGSLPC_INFO *info, unsigned char channel, unsigned i
 static void enable_auxclk(MGSLPC_INFO *info)
 {
 	unsigned char val;
-	
+
 	/* MODE
 	 *
 	 * 07..06  MDS[1..0] 10 = transparent HDLC mode
@@ -3152,14 +3152,14 @@ static void enable_auxclk(MGSLPC_INFO *info)
 	 * 00      TLP Test Loop, 0 = no loop
 	 *
 	 * 1000 0010
-	 */ 
+	 */
 	val = 0x82;
-	
-	/* channel B RTS is used to enable AUXCLK driver on SP505 */ 
+
+	/* channel B RTS is used to enable AUXCLK driver on SP505 */
 	if (info->params.mode == MGSL_MODE_HDLC && info->params.clock_speed)
 		val |= BIT2;
 	write_reg(info, CHB + MODE, val);
-	
+
 	/* CCR0
 	 *
 	 * 07      PU Power Up, 1=active, 0=power down
@@ -3169,9 +3169,9 @@ static void enable_auxclk(MGSLPC_INFO *info)
 	 * 01..00  SM[1..0] Serial Mode, 00=HDLC
 	 *
 	 * 11000000
-	 */ 
+	 */
 	write_reg(info, CHB + CCR0, 0xc0);
-	
+
 	/* CCR1
 	 *
 	 * 07      SFLG Shared Flag, 0 = disable shared flags
@@ -3182,9 +3182,9 @@ static void enable_auxclk(MGSLPC_INFO *info)
 	 * 02..00  CM[2..0] Clock Mode
 	 *
 	 * 0001 0111
-	 */ 
+	 */
 	write_reg(info, CHB + CCR1, 0x17);
-	
+
 	/* CCR2 (Channel B)
 	 *
 	 * 07..06  BGR[9..8] Baud rate bits 9..8
@@ -3196,12 +3196,12 @@ static void enable_auxclk(MGSLPC_INFO *info)
 	 * 00      DIV, data inversion 0=disabled, 1=enabled
 	 *
 	 * 0011 1000
-	 */ 
+	 */
 	if (info->params.mode == MGSL_MODE_HDLC && info->params.clock_speed)
 		write_reg(info, CHB + CCR2, 0x38);
 	else
 		write_reg(info, CHB + CCR2, 0x30);
-	
+
 	/* CCR4
 	 *
 	 * 07      MCK4 Master Clock Divide by 4, 1=enabled
@@ -3212,37 +3212,37 @@ static void enable_auxclk(MGSLPC_INFO *info)
 	 * 01..00  RFT[1..0] RxFIFO Threshold 00=32 bytes
 	 *
 	 * 0101 0000
-	 */ 
+	 */
 	write_reg(info, CHB + CCR4, 0x50);
-	
+
 	/* if auxclk not enabled, set internal BRG so
 	 * CTS transitions can be detected (requires TxC)
-	 */ 
+	 */
 	if (info->params.mode == MGSL_MODE_HDLC && info->params.clock_speed)
 		mgslpc_set_rate(info, CHB, info->params.clock_speed);
 	else
 		mgslpc_set_rate(info, CHB, 921600);
 }
 
-static void loopback_enable(MGSLPC_INFO *info) 
+static void loopback_enable(MGSLPC_INFO *info)
 {
 	unsigned char val;
-	
-	/* CCR1:02..00  CM[2..0] Clock Mode = 111 (clock mode 7) */ 
+
+	/* CCR1:02..00  CM[2..0] Clock Mode = 111 (clock mode 7) */
 	val = read_reg(info, CHA + CCR1) | (BIT2 + BIT1 + BIT0);
 	write_reg(info, CHA + CCR1, val);
-	
-	/* CCR2:04 SSEL Clock source select, 1=submode b */ 
+
+	/* CCR2:04 SSEL Clock source select, 1=submode b */
 	val = read_reg(info, CHA + CCR2) | (BIT4 + BIT5);
 	write_reg(info, CHA + CCR2, val);
-	
-	/* set LinkSpeed if available, otherwise default to 2Mbps */ 
+
+	/* set LinkSpeed if available, otherwise default to 2Mbps */
 	if (info->params.clock_speed)
 		mgslpc_set_rate(info, CHA, info->params.clock_speed);
 	else
 		mgslpc_set_rate(info, CHA, 1843200);
-	
-	/* MODE:00 TLP Test Loop, 1=loopback enabled */ 
+
+	/* MODE:00 TLP Test Loop, 1=loopback enabled */
 	val = read_reg(info, CHA + MODE) | BIT0;
 	write_reg(info, CHA + MODE, val);
 }
@@ -3252,36 +3252,36 @@ static void hdlc_mode(MGSLPC_INFO *info)
 	unsigned char val;
 	unsigned char clkmode, clksubmode;
 
-	/* disable all interrupts */ 
+	/* disable all interrupts */
 	irq_disable(info, CHA, 0xffff);
 	irq_disable(info, CHB, 0xffff);
 	port_irq_disable(info, 0xff);
-	
-	/* assume clock mode 0a, rcv=RxC xmt=TxC */ 
+
+	/* assume clock mode 0a, rcv=RxC xmt=TxC */
 	clkmode = clksubmode = 0;
 	if (info->params.flags & HDLC_FLAG_RXC_DPLL
 	    && info->params.flags & HDLC_FLAG_TXC_DPLL) {
-		/* clock mode 7a, rcv = DPLL, xmt = DPLL */ 
+		/* clock mode 7a, rcv = DPLL, xmt = DPLL */
 		clkmode = 7;
 	} else if (info->params.flags & HDLC_FLAG_RXC_BRG
 		 && info->params.flags & HDLC_FLAG_TXC_BRG) {
-		/* clock mode 7b, rcv = BRG, xmt = BRG */ 
+		/* clock mode 7b, rcv = BRG, xmt = BRG */
 		clkmode = 7;
 		clksubmode = 1;
 	} else if (info->params.flags & HDLC_FLAG_RXC_DPLL) {
 		if (info->params.flags & HDLC_FLAG_TXC_BRG) {
-			/* clock mode 6b, rcv = DPLL, xmt = BRG/16 */ 
+			/* clock mode 6b, rcv = DPLL, xmt = BRG/16 */
 			clkmode = 6;
 			clksubmode = 1;
 		} else {
-			/* clock mode 6a, rcv = DPLL, xmt = TxC */ 
+			/* clock mode 6a, rcv = DPLL, xmt = TxC */
 			clkmode = 6;
 		}
 	} else if (info->params.flags & HDLC_FLAG_TXC_BRG) {
-		/* clock mode 0b, rcv = RxC, xmt = BRG */ 
+		/* clock mode 0b, rcv = RxC, xmt = BRG */
 		clksubmode = 1;
 	}
-	
+
 	/* MODE
 	 *
 	 * 07..06  MDS[1..0] 10 = transparent HDLC mode
@@ -3293,16 +3293,16 @@ static void hdlc_mode(MGSLPC_INFO *info)
 	 * 00      TLP Test Loop, 0 = no loop
 	 *
 	 * 1000 0010
-	 */ 
+	 */
 	val = 0x82;
 	if (info->params.loopback)
 		val |= BIT0;
-	
-	/* preserve RTS state */ 
+
+	/* preserve RTS state */
 	if (info->serial_signals & SerialSignal_RTS)
 		val |= BIT2;
 	write_reg(info, CHA + MODE, val);
-	
+
 	/* CCR0
 	 *
 	 * 07      PU Power Up, 1=active, 0=power down
@@ -3312,7 +3312,7 @@ static void hdlc_mode(MGSLPC_INFO *info)
 	 * 01..00  SM[1..0] Serial Mode, 00=HDLC
 	 *
 	 * 11000000
-	 */ 
+	 */
 	val = 0xc0;
 	switch (info->params.encoding)
 	{
@@ -3330,7 +3330,7 @@ static void hdlc_mode(MGSLPC_INFO *info)
 		break;		// Manchester
 	}
 	write_reg(info, CHA + CCR0, val);
-	
+
 	/* CCR1
 	 *
 	 * 07      SFLG Shared Flag, 0 = disable shared flags
@@ -3341,10 +3341,10 @@ static void hdlc_mode(MGSLPC_INFO *info)
 	 * 02..00  CM[2..0] Clock Mode
 	 *
 	 * 0001 0000
-	 */ 
+	 */
 	val = 0x10 + clkmode;
 	write_reg(info, CHA + CCR1, val);
-	
+
 	/* CCR2
 	 *
 	 * 07..06  BGR[9..8] Baud rate bits 9..8
@@ -3356,7 +3356,7 @@ static void hdlc_mode(MGSLPC_INFO *info)
 	 * 00      DIV, data inversion 0=disabled, 1=enabled
 	 *
 	 * 0000 0000
-	 */ 
+	 */
 	val = 0x00;
 	if (clkmode == 2 || clkmode == 3 || clkmode == 6
 	    || clkmode == 7 || (clkmode == 0 && clksubmode == 1))
@@ -3368,7 +3368,7 @@ static void hdlc_mode(MGSLPC_INFO *info)
 	if (info->params.encoding == HDLC_ENCODING_NRZB)
 		val |= BIT0;
 	write_reg(info, CHA + CCR2, val);
-	
+
 	/* CCR3
 	 *
 	 * 07..06  PRE[1..0] Preamble count 00=1, 01=2, 10=4, 11=8
@@ -3380,7 +3380,7 @@ static void hdlc_mode(MGSLPC_INFO *info)
 	 * 00      PSD DPLL Phase Shift Disable
 	 *
 	 * 0000 0000
-	 */ 
+	 */
 	val = 0x00;
 	if (info->params.crc_type == HDLC_CRC_NONE)
 		val |= BIT2 + BIT1;
@@ -3399,8 +3399,8 @@ static void hdlc_mode(MGSLPC_INFO *info)
 		break;
 	}
 	write_reg(info, CHA + CCR3, val);
-	
-	/* PRE - Preamble pattern */ 
+
+	/* PRE - Preamble pattern */
 	val = 0;
 	switch (info->params.preamble)
 	{
@@ -3410,7 +3410,7 @@ static void hdlc_mode(MGSLPC_INFO *info)
 	case HDLC_PREAMBLE_PATTERN_ONES:  val = 0xff; break;
 	}
 	write_reg(info, CHA + PRE, val);
-	
+
 	/* CCR4
 	 *
 	 * 07      MCK4 Master Clock Divide by 4, 1=enabled
@@ -3421,21 +3421,21 @@ static void hdlc_mode(MGSLPC_INFO *info)
 	 * 01..00  RFT[1..0] RxFIFO Threshold 00=32 bytes
 	 *
 	 * 0101 0000
-	 */ 
+	 */
 	val = 0x50;
 	write_reg(info, CHA + CCR4, val);
 	if (info->params.flags & HDLC_FLAG_RXC_DPLL)
 		mgslpc_set_rate(info, CHA, info->params.clock_speed * 16);
 	else
 		mgslpc_set_rate(info, CHA, info->params.clock_speed);
-	
+
 	/* RLCR Receive length check register
 	 *
 	 * 7     1=enable receive length check
 	 * 6..0  Max frame length = (RL + 1) * 32
-	 */ 
+	 */
 	write_reg(info, CHA + RLCR, 0);
-	
+
 	/* XBCH Transmit Byte Count High
 	 *
 	 * 07      DMA mode, 0 = interrupt driven
@@ -3445,7 +3445,7 @@ static void hdlc_mode(MGSLPC_INFO *info)
 	 * 03..00  XBC[10..8] Transmit byte count bits 10..8
 	 *
 	 * 0000 0000
-	 */ 
+	 */
 	val = 0x00;
 	if (info->params.flags & HDLC_FLAG_AUTO_DCD)
 		val |= BIT5;
@@ -3456,7 +3456,7 @@ static void hdlc_mode(MGSLPC_INFO *info)
 	if (info->params.flags & HDLC_FLAG_AUTO_CTS)
 	{
 		irq_enable(info, CHB, IRQ_CTS);
-		/* PVR[3] 1=AUTO CTS active */ 
+		/* PVR[3] 1=AUTO CTS active */
 		set_reg_bits(info, CHA + PVR, BIT3);
 	} else
 		clear_reg_bits(info, CHA + PVR, BIT3);
@@ -3467,7 +3467,7 @@ static void hdlc_mode(MGSLPC_INFO *info)
 	issue_command(info, CHA, CMD_TXRESET + CMD_RXRESET);
 	wait_command_complete(info, CHA);
 	read_reg16(info, CHA + ISR);	/* clear pending IRQs */
-	
+
 	/* Master clock mode enabled above to allow reset commands
 	 * to complete even if no data clocks are present.
 	 *
@@ -3477,7 +3477,7 @@ static void hdlc_mode(MGSLPC_INFO *info)
 	 *
 	 * Leave master clock mode enabled for IRQ test because the
 	 * timer IRQ used by the test can only happen in master clock mode.
-	 */ 
+	 */
 	if (!info->testing_irq)
 		clear_reg_bits(info, CHA + CCR0, BIT6);
 
@@ -3492,8 +3492,8 @@ static void rx_stop(MGSLPC_INFO *info)
 	if (debug_level >= DEBUG_LEVEL_ISR)
 		printk("%s(%d):rx_stop(%s)\n",
 			 __FILE__,__LINE__, info->device_name );
-			 
-	/* MODE:03 RAC Receiver Active, 0=inactive */ 
+
+	/* MODE:03 RAC Receiver Active, 0=inactive */
 	clear_reg_bits(info, CHA + MODE, BIT3);
 
 	info->rx_enabled = 0;
@@ -3510,7 +3510,7 @@ static void rx_start(MGSLPC_INFO *info)
 	info->rx_enabled = 0;
 	info->rx_overflow = 0;
 
-	/* MODE:03 RAC Receiver Active, 1=active */ 
+	/* MODE:03 RAC Receiver Active, 1=active */
 	set_reg_bits(info, CHA + MODE, BIT3);
 
 	info->rx_enabled = 1;
@@ -3521,7 +3521,7 @@ static void tx_start(MGSLPC_INFO *info)
 	if (debug_level >= DEBUG_LEVEL_ISR)
 		printk("%s(%d):tx_start(%s)\n",
 			 __FILE__,__LINE__, info->device_name );
-			 
+
 	if (info->tx_count) {
 		/* If auto RTS enabled and RTS is inactive, then assert */
 		/* RTS and set a flag indicating that the driver should */
@@ -3559,8 +3559,8 @@ static void tx_stop(MGSLPC_INFO *info)
 	if (debug_level >= DEBUG_LEVEL_ISR)
 		printk("%s(%d):tx_stop(%s)\n",
 			 __FILE__,__LINE__, info->device_name );
-			 
-	del_timer(&info->tx_timer);	
+
+	del_timer(&info->tx_timer);
 
 	info->tx_enabled = 0;
 	info->tx_active  = 0;
@@ -3570,17 +3570,17 @@ static void tx_stop(MGSLPC_INFO *info)
  */
 static void reset_device(MGSLPC_INFO *info)
 {
-	/* power up both channels (set BIT7) */ 
+	/* power up both channels (set BIT7) */
 	write_reg(info, CHA + CCR0, 0x80);
 	write_reg(info, CHB + CCR0, 0x80);
 	write_reg(info, CHA + MODE, 0);
 	write_reg(info, CHB + MODE, 0);
-	
-	/* disable all interrupts */ 
+
+	/* disable all interrupts */
 	irq_disable(info, CHA, 0xffff);
 	irq_disable(info, CHB, 0xffff);
 	port_irq_disable(info, 0xff);
-	
+
 	/* PCR Port Configuration Register
 	 *
 	 * 07..04  DEC[3..0] Serial I/F select outputs
@@ -3590,9 +3590,9 @@ static void reset_device(MGSLPC_INFO *info)
 	 * 00      DTR output 0=active
 	 *
 	 * 0000 0110
-	 */ 
+	 */
 	write_reg(info, PCR, 0x06);
-	
+
 	/* PVR Port Value Register
 	 *
 	 * 07..04  DEC[3..0] Serial I/F select (0000=disabled)
@@ -3604,7 +3604,7 @@ static void reset_device(MGSLPC_INFO *info)
 	 * 0000 0001
 	 */
 //	write_reg(info, PVR, PVR_DTR);
-	
+
 	/* IPC Interrupt Port Configuration
 	 *
 	 * 07      VIS 1=Masked interrupts visible
@@ -3614,7 +3614,7 @@ static void reset_device(MGSLPC_INFO *info)
 	 * 01..00  IC[1..0] Interrupt Config, 01=push-pull output, active low
 	 *
 	 * 0000 0101
-	 */ 
+	 */
 	write_reg(info, IPC, 0x05);
 }
 
@@ -3622,11 +3622,11 @@ static void async_mode(MGSLPC_INFO *info)
 {
 	unsigned char val;
 
-	/* disable all interrupts */ 
+	/* disable all interrupts */
 	irq_disable(info, CHA, 0xffff);
 	irq_disable(info, CHB, 0xffff);
 	port_irq_disable(info, 0xff);
-	
+
 	/* MODE
 	 *
 	 * 07      Reserved, 0
@@ -3639,16 +3639,16 @@ static void async_mode(MGSLPC_INFO *info)
 	 * 00      TLP Test Loop, 0 = no loop
 	 *
 	 * 0000 0110
-	 */ 
+	 */
 	val = 0x06;
 	if (info->params.loopback)
 		val |= BIT0;
-	
-	/* preserve RTS state */ 
+
+	/* preserve RTS state */
 	if (!(info->serial_signals & SerialSignal_RTS))
 		val |= BIT6;
 	write_reg(info, CHA + MODE, val);
-	
+
 	/* CCR0
 	 *
 	 * 07      PU Power Up, 1=active, 0=power down
@@ -3658,9 +3658,9 @@ static void async_mode(MGSLPC_INFO *info)
 	 * 01..00  SM[1..0] Serial Mode, 11=Async
 	 *
 	 * 1000 0011
-	 */ 
+	 */
 	write_reg(info, CHA + CCR0, 0x83);
-	
+
 	/* CCR1
 	 *
 	 * 07..05  Reserved, 0
@@ -3669,9 +3669,9 @@ static void async_mode(MGSLPC_INFO *info)
 	 * 02..00  CM[2..0] Clock Mode, 111=BRG
 	 *
 	 * 0001 1111
-	 */ 
+	 */
 	write_reg(info, CHA + CCR1, 0x1f);
-	
+
 	/* CCR2 (channel A)
 	 *
 	 * 07..06  BGR[9..8] Baud rate bits 9..8
@@ -3683,18 +3683,18 @@ static void async_mode(MGSLPC_INFO *info)
 	 * 00      DIV, data inversion 0=disabled, 1=enabled
 	 *
 	 * 0001 0000
-	 */ 
+	 */
 	write_reg(info, CHA + CCR2, 0x10);
-	
+
 	/* CCR3
 	 *
 	 * 07..01  Reserved, 0
 	 * 00      PSD DPLL Phase Shift Disable
 	 *
 	 * 0000 0000
-	 */ 
+	 */
 	write_reg(info, CHA + CCR3, 0);
-	
+
 	/* CCR4
 	 *
 	 * 07      MCK4 Master Clock Divide by 4, 1=enabled
@@ -3704,10 +3704,10 @@ static void async_mode(MGSLPC_INFO *info)
 	 * 03..00  Reserved, must be 0
 	 *
 	 * 0101 0000
-	 */ 
+	 */
 	write_reg(info, CHA + CCR4, 0x50);
 	mgslpc_set_rate(info, CHA, info->params.data_rate * 16);
-	
+
 	/* DAFO Data Format
 	 *
 	 * 07      Reserved, 0
@@ -3717,7 +3717,7 @@ static void async_mode(MGSLPC_INFO *info)
 	 * 02      PAREN Parity Enable
 	 * 01..00  CHL[1..0] Character Length (00=8, 01=7)
 	 *
-	 */ 
+	 */
 	val = 0x00;
 	if (info->params.data_bits != 8)
 		val |= BIT0;	/* 7 bits */
@@ -3732,7 +3732,7 @@ static void async_mode(MGSLPC_INFO *info)
 			val |= BIT4;
 	}
 	write_reg(info, CHA + DAFO, val);
-	
+
 	/* RFC Rx FIFO Control
 	 *
 	 * 07      Reserved, 0
@@ -3744,15 +3744,15 @@ static void async_mode(MGSLPC_INFO *info)
 	 * 00      TCDE Terminate Char Detect Enable, 0=disabled
 	 *
 	 * 0101 1100
-	 */ 
+	 */
 	write_reg(info, CHA + RFC, 0x5c);
-	
+
 	/* RLCR Receive length check register
 	 *
 	 * Max frame length = (RL + 1) * 32
-	 */ 
+	 */
 	write_reg(info, CHA + RLCR, 0);
-	
+
 	/* XBCH Transmit Byte Count High
 	 *
 	 * 07      DMA mode, 0 = interrupt driven
@@ -3762,20 +3762,20 @@ static void async_mode(MGSLPC_INFO *info)
 	 * 03..00  XBC[10..8] Transmit byte count bits 10..8
 	 *
 	 * 0000 0000
-	 */ 
+	 */
 	val = 0x00;
 	if (info->params.flags & HDLC_FLAG_AUTO_DCD)
 		val |= BIT5;
 	write_reg(info, CHA + XBCH, val);
 	if (info->params.flags & HDLC_FLAG_AUTO_CTS)
 		irq_enable(info, CHA, IRQ_CTS);
-	
-	/* MODE:03 RAC Receiver Active, 1=active */ 
+
+	/* MODE:03 RAC Receiver Active, 1=active */
 	set_reg_bits(info, CHA + MODE, BIT3);
 	enable_auxclk(info);
 	if (info->params.flags & HDLC_FLAG_AUTO_CTS) {
 		irq_enable(info, CHB, IRQ_CTS);
-		/* PVR[3] 1=AUTO CTS active */ 
+		/* PVR[3] 1=AUTO CTS active */
 		set_reg_bits(info, CHA + PVR, BIT3);
 	} else
 		clear_reg_bits(info, CHA + PVR, BIT3);
@@ -3791,7 +3791,7 @@ static void async_mode(MGSLPC_INFO *info)
  */
 static void tx_set_idle(MGSLPC_INFO *info)
 {
-	/* Note: ESCC2 only supports flags and one idle modes */ 
+	/* Note: ESCC2 only supports flags and one idle modes */
 	if (info->idle_mode == HDLC_TXIDLE_FLAGS)
 		set_reg_bits(info, CHA + CCR1, BIT3);
 	else
@@ -3803,8 +3803,8 @@ static void tx_set_idle(MGSLPC_INFO *info)
 static void get_signals(MGSLPC_INFO *info)
 {
 	unsigned char status = 0;
-	
-	/* preserve DTR and RTS */ 
+
+	/* preserve DTR and RTS */
 	info->serial_signals &= SerialSignal_DTR + SerialSignal_RTS;
 
 	if (read_reg(info, CHB + VSTR) & BIT7)
@@ -3873,7 +3873,7 @@ static int rx_get_frame(MGSLPC_INFO *info)
 	unsigned long flags;
 	struct tty_struct *tty = info->tty;
 	int return_frame = 0;
-	
+
 	if (info->rx_frame_count == 0)
 		return 0;
 
@@ -3913,10 +3913,10 @@ static int rx_get_frame(MGSLPC_INFO *info)
 	if (debug_level >= DEBUG_LEVEL_BH)
 		printk("%s(%d):rx_get_frame(%s) status=%04X size=%d\n",
 			__FILE__,__LINE__,info->device_name,status,framesize);
-			
+
 	if (debug_level >= DEBUG_LEVEL_DATA)
-		trace_block(info, buf->data, framesize, 0);	
-		
+		trace_block(info, buf->data, framesize, 0);
+
 	if (framesize) {
 		if ((info->params.crc_type & HDLC_CRC_RETURN_EX &&
 		      framesize+1 > info->max_frame_size) ||
@@ -3953,7 +3953,7 @@ static int rx_get_frame(MGSLPC_INFO *info)
 
 static BOOLEAN register_test(MGSLPC_INFO *info)
 {
-	static unsigned char patterns[] = 
+	static unsigned char patterns[] =
 	    { 0x00, 0xff, 0xaa, 0x55, 0x69, 0x96, 0x0f };
 	static unsigned int count = ARRAY_SIZE(patterns);
 	unsigned int i;
@@ -4002,13 +4002,13 @@ static BOOLEAN irq_test(MGSLPC_INFO *info)
 	while(end_time-- && !info->irq_occurred) {
 		msleep_interruptible(10);
 	}
-	
+
 	info->testing_irq = FALSE;
 
 	spin_lock_irqsave(&info->lock,flags);
 	reset_device(info);
 	spin_unlock_irqrestore(&info->lock,flags);
-	
+
 	return info->irq_occurred ? TRUE : FALSE;
 }
 
@@ -4042,13 +4042,13 @@ static void trace_block(MGSLPC_INFO *info,const char* data, int count, int xmit)
 		printk("%s tx data:\n",info->device_name);
 	else
 		printk("%s rx data:\n",info->device_name);
-		
+
 	while(count) {
 		if (count > 16)
 			linecount = 16;
 		else
 			linecount = count;
-			
+
 		for(i=0;i<linecount;i++)
 			printk("%02X ",(unsigned char)data[i]);
 		for(;i<17;i++)
@@ -4060,7 +4060,7 @@ static void trace_block(MGSLPC_INFO *info,const char* data, int count, int xmit)
 				printk(".");
 		}
 		printk("\n");
-		
+
 		data  += linecount;
 		count -= linecount;
 	}
@@ -4073,7 +4073,7 @@ static void tx_timeout(unsigned long context)
 {
 	MGSLPC_INFO *info = (MGSLPC_INFO*)context;
 	unsigned long flags;
-	
+
 	if ( debug_level >= DEBUG_LEVEL_INFO )
 		printk( "%s(%d):tx_timeout(%s)\n",
 			__FILE__,__LINE__,info->device_name);
@@ -4086,7 +4086,7 @@ static void tx_timeout(unsigned long context)
 	info->tx_count = info->tx_put = info->tx_get = 0;
 
 	spin_unlock_irqrestore(&info->lock,flags);
-	
+
 #if SYNCLINK_GENERIC_HDLC
 	if (info->netcount)
 		hdlcdev_tx_done(info);
diff --git a/drivers/char/ppdev.c b/drivers/char/ppdev.c
index efe2f5c..3aab837 100644
--- a/drivers/char/ppdev.c
+++ b/drivers/char/ppdev.c
@@ -267,9 +267,9 @@ static ssize_t pp_write (struct file * file, const char __user * buf,
 	return bytes_written;
 }
 
-static void pp_irq (int irq, void * private)
+static void pp_irq (void *private)
 {
-	struct pp_struct * pp = (struct pp_struct *) private;
+	struct pp_struct *pp = private;
 
 	if (pp->irqresponse) {
 		parport_write_control (pp->pdev->port, pp->irqctl);
diff --git a/drivers/char/riscom8.c b/drivers/char/riscom8.c
index b37e626..102ece4 100644
--- a/drivers/char/riscom8.c
+++ b/drivers/char/riscom8.c
@@ -79,7 +79,6 @@
 
 #define RS_EVENT_WRITE_WAKEUP	0
 
-static struct riscom_board * IRQ_to_board[16];
 static struct tty_driver *riscom_driver;
 
 static struct riscom_board rc_board[RC_NBOARD] =  {
@@ -537,16 +536,14 @@ static inline void rc_check_modem(struct riscom_board const * bp)
 }
 
 /* The main interrupt processing routine */
-static irqreturn_t rc_interrupt(int irq, void * dev_id)
+static irqreturn_t rc_interrupt(int dummy, void * dev_id)
 {
 	unsigned char status;
 	unsigned char ack;
-	struct riscom_board *bp;
+	struct riscom_board *bp = dev_id;
 	unsigned long loop = 0;
 	int handled = 0;
 
-	bp = IRQ_to_board[irq];
-
 	if (!(bp->flags & RC_BOARD_ACTIVE))
 		return IRQ_NONE;
 
@@ -603,7 +600,7 @@ static irqreturn_t rc_interrupt(int irq, void * dev_id)
  */
 
 /* Called with disabled interrupts */
-static inline int rc_setup_board(struct riscom_board * bp)
+static int rc_setup_board(struct riscom_board * bp)
 {
 	int error;
 
@@ -611,7 +608,7 @@ static inline int rc_setup_board(struct riscom_board * bp)
 		return 0;
 	
 	error = request_irq(bp->irq, rc_interrupt, IRQF_DISABLED,
-			    "RISCom/8", NULL);
+			    "RISCom/8", bp);
 	if (error) 
 		return error;
 	
@@ -619,14 +616,13 @@ static inline int rc_setup_board(struct riscom_board * bp)
 	bp->DTR = ~0;
 	rc_out(bp, RC_DTR, bp->DTR);	        /* Drop DTR on all ports */
 	
-	IRQ_to_board[bp->irq] = bp;
 	bp->flags |= RC_BOARD_ACTIVE;
 	
 	return 0;
 }
 
 /* Called with disabled interrupts */
-static inline void rc_shutdown_board(struct riscom_board *bp)
+static void rc_shutdown_board(struct riscom_board *bp)
 {
 	if (!(bp->flags & RC_BOARD_ACTIVE))
 		return;
@@ -634,7 +630,6 @@ static inline void rc_shutdown_board(struct riscom_board *bp)
 	bp->flags &= ~RC_BOARD_ACTIVE;
 	
 	free_irq(bp->irq, NULL);
-	IRQ_to_board[bp->irq] = NULL;
 	
 	bp->DTR = ~0;
 	rc_out(bp, RC_DTR, bp->DTR);	       /* Drop DTR on all ports */
@@ -1594,7 +1589,6 @@ static inline int rc_init_drivers(void)
 	if (!riscom_driver)	
 		return -ENOMEM;
 	
-	memset(IRQ_to_board, 0, sizeof(IRQ_to_board));
 	riscom_driver->owner = THIS_MODULE;
 	riscom_driver->name = "ttyL";
 	riscom_driver->major = RISCOM8_NORMAL_MAJOR;
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index a8e8084..fd771a4 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -381,7 +381,7 @@ static struct tpm_vendor_specific tpm_tis = {
 
 static irqreturn_t tis_int_probe(int irq, void *dev_id)
 {
-	struct tpm_chip *chip = (struct tpm_chip *) dev_id;
+	struct tpm_chip *chip = dev_id;
 	u32 interrupt;
 
 	interrupt = ioread32(chip->vendor.iobase +
@@ -401,7 +401,7 @@ static irqreturn_t tis_int_probe(int irq, void *dev_id)
 
 static irqreturn_t tis_int_handler(int irq, void *dev_id)
 {
-	struct tpm_chip *chip = (struct tpm_chip *) dev_id;
+	struct tpm_chip *chip = dev_id;
 	u32 interrupt;
 	int i;
 
diff --git a/drivers/input/serio/parkbd.c b/drivers/input/serio/parkbd.c
index 688610e..b089977 100644
--- a/drivers/input/serio/parkbd.c
+++ b/drivers/input/serio/parkbd.c
@@ -102,7 +102,7 @@ static int parkbd_write(struct serio *port, unsigned char c)
 	return 0;
 }
 
-static void parkbd_interrupt(int irq, void *dev_id)
+static void parkbd_interrupt(void *dev_id)
 {
 
 	if (parkbd_writing) {
diff --git a/drivers/isdn/act2000/act2000_isa.c b/drivers/isdn/act2000/act2000_isa.c
index 819ea85..1bd8960 100644
--- a/drivers/isdn/act2000/act2000_isa.c
+++ b/drivers/isdn/act2000/act2000_isa.c
@@ -61,7 +61,7 @@ act2000_isa_detect(unsigned short portbase)
 }
 
 static irqreturn_t
-act2000_isa_interrupt(int irq, void *dev_id)
+act2000_isa_interrupt(int dummy, void *dev_id)
 {
         act2000_card *card = dev_id;
         u_char istatus;
@@ -80,7 +80,7 @@ act2000_isa_interrupt(int irq, void *dev_id)
                 printk(KERN_WARNING "act2000: errIRQ\n");
         }
 	if (istatus)
-		printk(KERN_DEBUG "act2000: ?IRQ %d %02x\n", irq, istatus);
+		printk(KERN_DEBUG "act2000: ?IRQ %d %02x\n", card->irq, istatus);
 	return IRQ_HANDLED;
 }
 
@@ -131,6 +131,8 @@ act2000_isa_enable_irq(act2000_card * card)
 int
 act2000_isa_config_irq(act2000_card * card, short irq)
 {
+	int old_irq;
+
         if (card->flags & ACT2000_FLAGS_IVALID) {
                 free_irq(card->irq, card);
         }
@@ -139,8 +141,10 @@ act2000_isa_config_irq(act2000_card * card, short irq)
         if (!irq)
                 return 0;
 
-	if (!request_irq(irq, &act2000_isa_interrupt, 0, card->regname, card)) {
-		card->irq = irq;
+	old_irq = card->irq;
+	card->irq = irq;
+	if (request_irq(irq, &act2000_isa_interrupt, 0, card->regname, card)) {
+		card->irq = old_irq;
 		card->flags |= ACT2000_FLAGS_IVALID;
                 printk(KERN_WARNING
                        "act2000: Could not request irq %d\n",irq);
diff --git a/drivers/isdn/sc/init.c b/drivers/isdn/sc/init.c
index d09c854..dd0acd0 100644
--- a/drivers/isdn/sc/init.c
+++ b/drivers/isdn/sc/init.c
@@ -334,7 +334,8 @@ static int __init sc_init(void)
 		 */
 		sc_adapter[cinst]->interrupt = irq[b];
 		if (request_irq(sc_adapter[cinst]->interrupt, interrupt_handler,
-				IRQF_DISABLED, interface->id, NULL))
+				IRQF_DISABLED, interface->id,
+				(void *)(unsigned long) cinst))
 		{
 			kfree(sc_adapter[cinst]->channel);
 			indicate_status(cinst, ISDN_STAT_UNLOAD, 0, NULL);	/* Fix me */
diff --git a/drivers/isdn/sc/interrupt.c b/drivers/isdn/sc/interrupt.c
index bef7963..485be8b 100644
--- a/drivers/isdn/sc/interrupt.c
+++ b/drivers/isdn/sc/interrupt.c
@@ -21,28 +21,15 @@
 #include "card.h"
 #include <linux/interrupt.h>
 
-static int get_card_from_irq(int irq)
-{
-	int i;
-
-	for(i = 0 ; i < cinst ; i++) {
-		if(sc_adapter[i]->interrupt == irq)
-			return i;
-	}
-	return -1;
-}
-
 /*
  * 
  */
-irqreturn_t interrupt_handler(int interrupt, void *cardptr)
+irqreturn_t interrupt_handler(int dummy, void *card_inst)
 {
 
 	RspMessage rcvmsg;
 	int channel;
-	int card;
-
-	card = get_card_from_irq(interrupt);
+	int card = (int)(unsigned long) card_inst;
 
 	if(!IS_VALID_CARD(card)) {
 		pr_debug("Invalid param: %d is not a valid card id\n", card);
diff --git a/drivers/mtd/onenand/onenand_base.c b/drivers/mtd/onenand/onenand_base.c
index dd28355..1b0b320 100644
--- a/drivers/mtd/onenand/onenand_base.c
+++ b/drivers/mtd/onenand/onenand_base.c
@@ -359,7 +359,7 @@ static int onenand_wait(struct mtd_info *mtd, int state)
  */
 static irqreturn_t onenand_interrupt(int irq, void *data)
 {
-	struct onenand_chip *this = (struct onenand_chip *) data;
+	struct onenand_chip *this = data;
 
 	/* To handle shared interrupt */
 	if (!this->complete.done)
diff --git a/drivers/net/cxgb3/adapter.h b/drivers/net/cxgb3/adapter.h
index 2a3df14..60a62f5 100644
--- a/drivers/net/cxgb3/adapter.h
+++ b/drivers/net/cxgb3/adapter.h
@@ -46,8 +46,6 @@
 #include <asm/semaphore.h>
 #include <asm/io.h>
 
-typedef irqreturn_t(*intr_handler_t) (int, void *);
-
 struct vlan_group;
 struct adapter;
 struct sge_qset;
@@ -270,7 +268,7 @@ void t3_sge_start(struct adapter *adap);
 void t3_sge_stop(struct adapter *adap);
 void t3_free_sge_resources(struct adapter *adap);
 void t3_sge_err_intr_handler(struct adapter *adapter);
-intr_handler_t t3_intr_handler(struct adapter *adap, int polling);
+irq_handler_t t3_intr_handler(struct adapter *adap, int polling);
 int t3_eth_xmit(struct sk_buff *skb, struct net_device *dev);
 int t3_mgmt_tx(struct adapter *adap, struct sk_buff *skb);
 void t3_update_qset_coalesce(struct sge_qset *qs, const struct qset_params *p);
diff --git a/drivers/net/cxgb3/sge.c b/drivers/net/cxgb3/sge.c
index 994b5d6..c15e43a 100644
--- a/drivers/net/cxgb3/sge.c
+++ b/drivers/net/cxgb3/sge.c
@@ -2431,7 +2431,7 @@ static irqreturn_t t3b_intr_napi(int irq, void *cookie)
  *	(MSI-X, MSI, or legacy) and whether NAPI will be used to service the
  *	response queues.
  */
-intr_handler_t t3_intr_handler(struct adapter *adap, int polling)
+irq_handler_t t3_intr_handler(struct adapter *adap, int polling)
 {
 	if (adap->flags & USING_MSIX)
 		return polling ? t3_sge_intr_msix_napi : t3_sge_intr_msix;
diff --git a/drivers/net/hamradio/baycom_epp.c b/drivers/net/hamradio/baycom_epp.c
index 1a5a75a..dde9c7e 100644
--- a/drivers/net/hamradio/baycom_epp.c
+++ b/drivers/net/hamradio/baycom_epp.c
@@ -325,12 +325,6 @@ static int eppconfig(struct baycom_state *bc)
 
 /* ---------------------------------------------------------------------- */
 
-static void epp_interrupt(int irq, void *dev_id)
-{
-}
-
-/* ---------------------------------------------------------------------- */
-
 static inline void do_kiss_params(struct baycom_state *bc,
 				  unsigned char *data, unsigned long len)
 {
@@ -871,7 +865,7 @@ static int epp_open(struct net_device *dev)
 	}
 	memset(&bc->modem, 0, sizeof(bc->modem));
         bc->pdev = parport_register_device(pp, dev->name, NULL, epp_wakeup, 
-					epp_interrupt, PARPORT_DEV_EXCL, dev);
+					   NULL, PARPORT_DEV_EXCL, dev);
 	parport_put_port(pp);
         if (!bc->pdev) {
                 printk(KERN_ERR "%s: cannot register parport at 0x%lx\n", bc_drvname, pp->base);
diff --git a/drivers/net/hamradio/baycom_par.c b/drivers/net/hamradio/baycom_par.c
index 5930aeb..2e6fc4d 100644
--- a/drivers/net/hamradio/baycom_par.c
+++ b/drivers/net/hamradio/baycom_par.c
@@ -270,9 +270,9 @@ static __inline__ void par96_rx(struct net_device *dev, struct baycom_state *bc)
 
 /* --------------------------------------------------------------------- */
 
-static void par96_interrupt(int irq, void *dev_id)
+static void par96_interrupt(void *dev_id)
 {
-	struct net_device *dev = (struct net_device *)dev_id;
+	struct net_device *dev = dev_id;
 	struct baycom_state *bc = netdev_priv(dev);
 
 	baycom_int_freq(bc);
diff --git a/drivers/net/lib82596.c b/drivers/net/lib82596.c
index ffaa14f..9a855e5 100644
--- a/drivers/net/lib82596.c
+++ b/drivers/net/lib82596.c
@@ -1124,12 +1124,6 @@ static irqreturn_t i596_interrupt(int irq, void *dev_id)
 	struct i596_dma *dma;
 	unsigned short status, ack_cmd = 0;
 
-	if (dev == NULL) {
-		printk(KERN_WARNING "%s: irq %d for unknown device.\n",
-		       __FUNCTION__, irq);
-		return IRQ_NONE;
-	}
-
 	lp = netdev_priv(dev);
 	dma = lp->dma;
 
@@ -1140,7 +1134,7 @@ static irqreturn_t i596_interrupt(int irq, void *dev_id)
 
 	DEB(DEB_INTS, printk(KERN_DEBUG
 			     "%s: i596 interrupt, IRQ %d, status %4.4x.\n",
-			dev->name, irq, status));
+			dev->name, dev->irq, status));
 
 	ack_cmd = status & 0xf000;
 
diff --git a/drivers/net/netxen/netxen_nic_main.c b/drivers/net/netxen/netxen_nic_main.c
index 601051c..a80f0cd 100644
--- a/drivers/net/netxen/netxen_nic_main.c
+++ b/drivers/net/netxen/netxen_nic_main.c
@@ -1268,17 +1268,10 @@ netxen_handle_int(struct netxen_adapter *adapter, struct net_device *netdev)
  */
 irqreturn_t netxen_intr(int irq, void *data)
 {
-	struct netxen_adapter *adapter;
-	struct net_device *netdev;
+	struct netxen_adapter *adapter = data;
+	struct net_device *netdev = adapter->netdev;
 	u32 our_int = 0;
 
-	if (unlikely(!irq)) {
-		return IRQ_NONE;	/* Not our interrupt */
-	}
-
-	adapter = (struct netxen_adapter *)data;
-	netdev  = adapter->netdev;
-
 	if (!(adapter->flags & NETXEN_NIC_MSI_ENABLED)) {
 		our_int = readl(NETXEN_CRB_NORMALIZE(adapter, CRB_INT_VECTOR));
 		/* not our interrupt */
diff --git a/drivers/net/plip.c b/drivers/net/plip.c
index b5e9981..5071fcd 100644
--- a/drivers/net/plip.c
+++ b/drivers/net/plip.c
@@ -143,7 +143,7 @@ static void plip_bh(struct work_struct *work);
 static void plip_timer_bh(struct work_struct *work);
 
 /* Interrupt handler */
-static void plip_interrupt(int irq, void *dev_id);
+static void plip_interrupt(void *dev_id);
 
 /* Functions for DEV methods */
 static int plip_tx_packet(struct sk_buff *skb, struct net_device *dev);
@@ -380,7 +380,7 @@ plip_timer_bh(struct work_struct *work)
 		container_of(work, struct net_local, timer.work);
 
 	if (!(atomic_read (&nl->kill_timer))) {
-		plip_interrupt (-1, nl->dev);
+		plip_interrupt (nl->dev);
 
 		schedule_delayed_work(&nl->timer, 1);
 	}
@@ -897,7 +897,7 @@ plip_error(struct net_device *dev, struct net_local *nl,
 
 /* Handle the parallel port interrupts. */
 static void
-plip_interrupt(int irq, void *dev_id)
+plip_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct net_local *nl;
diff --git a/drivers/net/typhoon.c b/drivers/net/typhoon.c
index 72e5e9b..94ac586 100644
--- a/drivers/net/typhoon.c
+++ b/drivers/net/typhoon.c
@@ -1801,7 +1801,7 @@ typhoon_poll(struct napi_struct *napi, int budget)
 static irqreturn_t
 typhoon_interrupt(int irq, void *dev_instance)
 {
-	struct net_device *dev = (struct net_device *) dev_instance;
+	struct net_device *dev = dev_instance;
 	struct typhoon *tp = dev->priv;
 	void __iomem *ioaddr = tp->ioaddr;
 	u32 intr_status;
diff --git a/drivers/net/ucc_geth.c b/drivers/net/ucc_geth.c
index bec413b..9741d61 100644
--- a/drivers/net/ucc_geth.c
+++ b/drivers/net/ucc_geth.c
@@ -3607,7 +3607,7 @@ static int ucc_geth_poll(struct napi_struct *napi, int budget)
 
 static irqreturn_t ucc_geth_irq_handler(int irq, void *info)
 {
-	struct net_device *dev = (struct net_device *)info;
+	struct net_device *dev = info;
 	struct ucc_geth_private *ugeth = netdev_priv(dev);
 	struct ucc_fast_private *uccf;
 	struct ucc_geth_info *ug_info;
diff --git a/drivers/net/wan/sbni.c b/drivers/net/wan/sbni.c
index 76db40d..2e8b5c2 100644
--- a/drivers/net/wan/sbni.c
+++ b/drivers/net/wan/sbni.c
@@ -502,8 +502,8 @@ sbni_start_xmit( struct sk_buff  *skb,  struct net_device  *dev )
 static irqreturn_t
 sbni_interrupt( int  irq,  void  *dev_id )
 {
-	struct net_device	  *dev = (struct net_device *) dev_id;
-	struct net_local  *nl  = (struct net_local *) dev->priv;
+	struct net_device	  *dev = dev_id;
+	struct net_local  *nl  = dev->priv;
 	int	repeat;
 
 	spin_lock( &nl->lock );
diff --git a/drivers/parport/daisy.c b/drivers/parport/daisy.c
index 5bbff20..3c8f06c 100644
--- a/drivers/parport/daisy.c
+++ b/drivers/parport/daisy.c
@@ -199,11 +199,6 @@ void parport_daisy_fini(struct parport *port)
  *	parport_open - find a device by canonical device number
  *	@devnum: canonical device number
  *	@name: name to associate with the device
- *	@pf: preemption callback
- *	@kf: kick callback
- *	@irqf: interrupt handler
- *	@flags: registration flags
- *	@handle: driver data
  *
  *	This function is similar to parport_register_device(), except
  *	that it locates a device by its number rather than by the port
@@ -214,10 +209,7 @@ void parport_daisy_fini(struct parport *port)
  *	for parport_register_device().
  **/
 
-struct pardevice *parport_open(int devnum, const char *name,
-				int (*pf) (void *), void (*kf) (void *),
-				void (*irqf) (int, void *),
-				int flags, void *handle)
+struct pardevice *parport_open(int devnum, const char *name)
 {
 	struct daisydev *p = topology;
 	struct parport *port;
@@ -237,8 +229,7 @@ struct pardevice *parport_open(int devnum, const char *name,
 	port = parport_get_port(p->port);
 	spin_unlock(&topology_lock);
 
-	dev = parport_register_device(port, name, pf, kf,
-				       irqf, flags, handle);
+	dev = parport_register_device(port, name, NULL, NULL, NULL, 0, NULL);
 	parport_put_port(port);
 	if (!dev)
 		return NULL;
diff --git a/drivers/parport/ieee1284.c b/drivers/parport/ieee1284.c
index 5accaa7..54a6ef7 100644
--- a/drivers/parport/ieee1284.c
+++ b/drivers/parport/ieee1284.c
@@ -571,7 +571,7 @@ static int parport_ieee1284_ack_data_avail (struct parport *port)
 #endif /* IEEE1284 support */
 
 /* Handle an interrupt. */
-void parport_ieee1284_interrupt (int which, void *handle)
+void parport_ieee1284_interrupt (void *handle)
 {
 	struct parport *port = handle;
 	parport_ieee1284_wakeup (port);
diff --git a/drivers/parport/parport_amiga.c b/drivers/parport/parport_amiga.c
index a0afaee..1586e1c 100644
--- a/drivers/parport/parport_amiga.c
+++ b/drivers/parport/parport_amiga.c
@@ -137,13 +137,6 @@ static unsigned char amiga_read_status(struct parport *p)
 	return status;
 }
 
-/* as this ports irq handling is already done, we use a generic funktion */
-static irqreturn_t amiga_interrupt(int irq, void *dev_id)
-{
-	parport_generic_irq(irq, (struct parport *) dev_id);
-	return IRQ_HANDLED;
-}
-
 static void amiga_enable_irq(struct parport *p)
 {
 	enable_irq(IRQ_AMIGA_CIAA_FLG);
@@ -255,7 +248,7 @@ static int __init parport_amiga_init(void)
 	if (!p)
 		goto out_port;
 
-	err = request_irq(IRQ_AMIGA_CIAA_FLG, amiga_interrupt, 0, p->name, p);
+	err = request_irq(IRQ_AMIGA_CIAA_FLG, parport_irq_handler, 0, p->name, p);
 	if (err)
 		goto out_irq;
 
diff --git a/drivers/parport/parport_atari.c b/drivers/parport/parport_atari.c
index 6ea9929..ad4cdd2 100644
--- a/drivers/parport/parport_atari.c
+++ b/drivers/parport/parport_atari.c
@@ -103,13 +103,6 @@ parport_atari_restore_state(struct parport *p, struct parport_state *s)
 {
 }
 
-static irqreturn_t
-parport_atari_interrupt(int irq, void *dev_id)
-{
-	parport_generic_irq(irq, (struct parport *) dev_id);
-	return IRQ_HANDLED;
-}
-
 static void
 parport_atari_enable_irq(struct parport *p)
 {
@@ -208,7 +201,7 @@ static int __init parport_atari_init(void)
 					  &parport_atari_ops);
 		if (!p)
 			return -ENODEV;
-		if (request_irq(IRQ_MFP_BUSY, parport_atari_interrupt,
+		if (request_irq(IRQ_MFP_BUSY, parport_irq_handler,
 				IRQ_TYPE_SLOW, p->name, p)) {
 			parport_put_port (p);
 			return -ENODEV;
diff --git a/drivers/parport/parport_ax88796.c b/drivers/parport/parport_ax88796.c
index 74f4e97..4ec220b 100644
--- a/drivers/parport/parport_ax88796.c
+++ b/drivers/parport/parport_ax88796.c
@@ -232,14 +232,6 @@ parport_ax88796_restore_state(struct parport *p, struct parport_state *s)
 	writeb(s->u.ax88796.cpr, dd->spp_cpr);
 }
 
-static irqreturn_t
-parport_ax88796_interrupt(int irq, void *dev_id)
-{
-        parport_generic_irq(irq, dev_id);
-        return IRQ_HANDLED;
-}
-
-
 static struct parport_operations parport_ax88796_ops = {
 	.write_data	= parport_ax88796_write_data,
 	.read_data	= parport_ax88796_read_data,
@@ -344,7 +336,7 @@ static int parport_ax88796_probe(struct platform_device *pdev)
 
 	if (irq >= 0) {
 		/* request irq */
-		ret = request_irq(irq, parport_ax88796_interrupt,
+		ret = request_irq(irq, parport_irq_handler,
 				  IRQF_TRIGGER_FALLING, pdev->name, pp);
 
 		if (ret < 0)
diff --git a/drivers/parport/parport_gsc.c b/drivers/parport/parport_gsc.c
index 43652ba..0e77ae2 100644
--- a/drivers/parport/parport_gsc.c
+++ b/drivers/parport/parport_gsc.c
@@ -80,12 +80,6 @@ static int clear_epp_timeout(struct parport *pb)
  * of these are in parport_gsc.h.
  */
 
-static irqreturn_t parport_gsc_interrupt(int irq, void *dev_id)
-{
-	parport_generic_irq(irq, (struct parport *) dev_id);
-	return IRQ_HANDLED;
-}
-
 void parport_gsc_init_state(struct pardevice *dev, struct parport_state *s)
 {
 	s->u.pc.ctr = 0xc | (dev->irq_func ? 0x10 : 0x0);
@@ -324,7 +318,7 @@ struct parport *__devinit parport_gsc_probe_port (unsigned long base,
 	printk("]\n");
 
 	if (p->irq != PARPORT_IRQ_NONE) {
-		if (request_irq (p->irq, parport_gsc_interrupt,
+		if (request_irq (p->irq, parport_irq_handler,
 				 0, p->name, p)) {
 			printk (KERN_WARNING "%s: irq %d in use, "
 				"resorting to polled operation\n",
diff --git a/drivers/parport/parport_ip32.c b/drivers/parport/parport_ip32.c
index ec44efd..6d58bf8 100644
--- a/drivers/parport/parport_ip32.c
+++ b/drivers/parport/parport_ip32.c
@@ -778,14 +778,16 @@ static irqreturn_t parport_ip32_interrupt(int irq, void *dev_id)
 	struct parport * const p = dev_id;
 	struct parport_ip32_private * const priv = p->physport->private_data;
 	enum parport_ip32_irq_mode irq_mode = priv->irq_mode;
+
 	switch (irq_mode) {
 	case PARPORT_IP32_IRQ_FWD:
-		parport_generic_irq(irq, p);
-		break;
+		return parport_irq_handler(irq, dev_id);
+
 	case PARPORT_IP32_IRQ_HERE:
 		parport_ip32_wakeup(p);
 		break;
 	}
+
 	return IRQ_HANDLED;
 }
 
diff --git a/drivers/parport/parport_mfc3.c b/drivers/parport/parport_mfc3.c
index 77726fc..6dec9ba 100644
--- a/drivers/parport/parport_mfc3.c
+++ b/drivers/parport/parport_mfc3.c
@@ -219,7 +219,7 @@ static irqreturn_t mfc3_interrupt(int irq, void *dev_id)
 		if (this_port[i] != NULL)
 			if (pia(this_port[i])->crb & 128) { /* Board caused interrupt */
 				dummy = pia(this_port[i])->pprb; /* clear irq bit */
-				parport_generic_irq(irq, this_port[i]);
+				parport_generic_irq(this_port[i]);
 			}
 	return IRQ_HANDLED;
 }
diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
index e2be840..e9743d3 100644
--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -272,13 +272,6 @@ static int clear_epp_timeout(struct parport *pb)
  * of these are in parport_pc.h.
  */
 
-static irqreturn_t parport_pc_interrupt(int irq, void *dev_id)
-{
-	parport_generic_irq(irq, (struct parport *) dev_id);
-	/* FIXME! Was it really ours? */
-	return IRQ_HANDLED;
-}
-
 static void parport_pc_init_state(struct pardevice *dev, struct parport_state *s)
 {
 	s->u.pc.ctr = 0xc;
@@ -2301,7 +2294,7 @@ struct parport *parport_pc_probe_port (unsigned long int base,
 		EPP_res = NULL;
 	}
 	if (p->irq != PARPORT_IRQ_NONE) {
-		if (request_irq (p->irq, parport_pc_interrupt,
+		if (request_irq (p->irq, parport_irq_handler,
 				 0, p->name, p)) {
 			printk (KERN_WARNING "%s: irq %d in use, "
 				"resorting to polled operation\n",
diff --git a/drivers/parport/parport_sunbpp.c b/drivers/parport/parport_sunbpp.c
index d27019c..9d595aa 100644
--- a/drivers/parport/parport_sunbpp.c
+++ b/drivers/parport/parport_sunbpp.c
@@ -46,12 +46,6 @@
 #define dprintk(x)
 #endif
 
-static irqreturn_t parport_sunbpp_interrupt(int irq, void *dev_id)
-{
-	parport_generic_irq(irq, (struct parport *) dev_id);
-	return IRQ_HANDLED;
-}
-
 static void parport_sunbpp_disable_irq(struct parport *p)
 {
 	struct bpp_regs __iomem *regs = (struct bpp_regs __iomem *)p->base;
@@ -324,7 +318,7 @@ static int __devinit init_one_port(struct sbus_dev *sdev)
 	p->size = size;
 	p->dev = &sdev->ofdev.dev;
 
-	if ((err = request_irq(p->irq, parport_sunbpp_interrupt,
+	if ((err = request_irq(p->irq, parport_irq_handler,
 			       IRQF_SHARED, p->name, p)) != 0) {
 		goto out_put_port;
 	}
diff --git a/drivers/parport/probe.c b/drivers/parport/probe.c
index ea83b70..853a15f 100644
--- a/drivers/parport/probe.c
+++ b/drivers/parport/probe.c
@@ -255,8 +255,7 @@ static ssize_t parport_read_device_id (struct parport *port, char *buffer,
 ssize_t parport_device_id (int devnum, char *buffer, size_t count)
 {
 	ssize_t retval = -ENXIO;
-	struct pardevice *dev = parport_open (devnum, "Device ID probe",
-					      NULL, NULL, NULL, 0, NULL);
+	struct pardevice *dev = parport_open (devnum, "Device ID probe");
 	if (!dev)
 		return -ENXIO;
 
diff --git a/drivers/parport/share.c b/drivers/parport/share.c
index cd66442..a8a62bb 100644
--- a/drivers/parport/share.c
+++ b/drivers/parport/share.c
@@ -524,7 +524,7 @@ void parport_remove_port(struct parport *port)
 struct pardevice *
 parport_register_device(struct parport *port, const char *name,
 			int (*pf)(void *), void (*kf)(void *),
-			void (*irq_func)(int, void *), 
+			void (*irq_func)(void *), 
 			int flags, void *handle)
 {
 	struct pardevice *tmp;
@@ -995,6 +995,15 @@ void parport_release(struct pardevice *dev)
 	}
 }
 
+irqreturn_t parport_irq_handler(int irq, void *dev_id)
+{
+	struct parport *port = dev_id;
+
+	parport_generic_irq(port);
+
+	return IRQ_HANDLED;
+}
+
 /* Exported symbols for modules. */
 
 EXPORT_SYMBOL(parport_claim);
@@ -1011,5 +1020,6 @@ EXPORT_SYMBOL(parport_get_port);
 EXPORT_SYMBOL(parport_put_port);
 EXPORT_SYMBOL(parport_find_number);
 EXPORT_SYMBOL(parport_find_base);
+EXPORT_SYMBOL(parport_irq_handler);
 
 MODULE_LICENSE("GPL");
diff --git a/drivers/usb/misc/uss720.c b/drivers/usb/misc/uss720.c
index 2734fe2..f1255b0 100644
--- a/drivers/usb/misc/uss720.c
+++ b/drivers/usb/misc/uss720.c
@@ -128,7 +128,7 @@ static void async_complete(struct urb *urb)
 #endif
 		/* if nAck interrupts are enabled and we have an interrupt, call the interrupt procedure */
 		if (rq->reg[2] & rq->reg[1] & 0x10 && pp)
-			parport_generic_irq(0, pp);
+			parport_generic_irq(pp);
 	}
 	complete(&rq->compl);
 	kref_put(&rq->ref_count, destroy_async);
@@ -337,7 +337,7 @@ static int uss720_irq(int usbstatus, void *buffer, int len, void *dev_id)
 	memcpy(priv->reg, buffer, 4);
 	/* if nAck interrupts are enabled and we have an interrupt, call the interrupt procedure */
 	if (priv->reg[2] & priv->reg[1] & 0x10)
-		parport_generic_irq(0, pp);
+		parport_generic_irq(pp);
 	return 1;
 }
 #endif
diff --git a/include/linux/parport.h b/include/linux/parport.h
index ec3f765..d1ad546 100644
--- a/include/linux/parport.h
+++ b/include/linux/parport.h
@@ -100,6 +100,7 @@ typedef enum {
 #include <linux/proc_fs.h>
 #include <linux/spinlock.h>
 #include <linux/wait.h>
+#include <linux/irqreturn.h>
 #include <asm/system.h>
 #include <asm/ptrace.h>
 #include <asm/semaphore.h>
@@ -229,7 +230,7 @@ struct pardevice {
 	int (*preempt)(void *);
 	void (*wakeup)(void *);
 	void *private;
-	void (*irq_func)(int, void *);
+	void (*irq_func)(void *);
 	unsigned int flags;
 	struct pardevice *next;
 	struct pardevice *prev;
@@ -366,6 +367,9 @@ extern void parport_unregister_driver (struct parport_driver *);
 extern struct parport *parport_find_number (int);
 extern struct parport *parport_find_base (unsigned long);
 
+/* generic irq handler, if it suits your needs */
+extern irqreturn_t parport_irq_handler(int irq, void *dev_id);
+
 /* Reference counting for ports. */
 extern struct parport *parport_get_port (struct parport *);
 extern void parport_put_port (struct parport *);
@@ -379,7 +383,7 @@ extern void parport_put_port (struct parport *);
 struct pardevice *parport_register_device(struct parport *port, 
 			  const char *name,
 			  int (*pf)(void *), void (*kf)(void *),
-			  void (*irq_func)(int, void *), 
+			  void (*irq_func)(void *), 
 			  int flags, void *handle);
 
 /* parport_unregister unlinks a device from the chain. */
@@ -461,7 +465,7 @@ static __inline__ int parport_yield_blocking(struct pardevice *dev)
 #define PARPORT_FLAG_EXCL		(1<<1)	/* EXCL driver registered. */
 
 /* IEEE1284 functions */
-extern void parport_ieee1284_interrupt (int, void *);
+extern void parport_ieee1284_interrupt (void *);
 extern int parport_negotiate (struct parport *, int mode);
 extern ssize_t parport_write (struct parport *, const void *buf, size_t len);
 extern ssize_t parport_read (struct parport *, void *buf, size_t len);
@@ -503,23 +507,19 @@ extern size_t parport_ieee1284_epp_read_addr (struct parport *,
 /* IEEE1284.3 functions */
 extern int parport_daisy_init (struct parport *port);
 extern void parport_daisy_fini (struct parport *port);
-extern struct pardevice *parport_open (int devnum, const char *name,
-				       int (*pf) (void *),
-				       void (*kf) (void *),
-				       void (*irqf) (int, void *),
-				       int flags, void *handle);
+extern struct pardevice *parport_open (int devnum, const char *name);
 extern void parport_close (struct pardevice *dev);
 extern ssize_t parport_device_id (int devnum, char *buffer, size_t len);
 extern void parport_daisy_deselect_all (struct parport *port);
 extern int parport_daisy_select (struct parport *port, int daisy, int mode);
 
 /* Lowlevel drivers _can_ call this support function to handle irqs.  */
-static __inline__ void parport_generic_irq(int irq, struct parport *port)
+static inline void parport_generic_irq(struct parport *port)
 {
-	parport_ieee1284_interrupt (irq, port);
+	parport_ieee1284_interrupt (port);
 	read_lock(&port->cad_lock);
 	if (port->cad && port->cad->irq_func)
-		port->cad->irq_func(irq, port->cad->private);
+		port->cad->irq_func(port->cad->private);
 	read_unlock(&port->cad_lock);
 }
 
diff --git a/sound/drivers/mts64.c b/sound/drivers/mts64.c
index 911c159..dcc90f9 100644
--- a/sound/drivers/mts64.c
+++ b/sound/drivers/mts64.c
@@ -830,7 +830,7 @@ static int __devinit snd_mts64_rawmidi_create(struct snd_card *card)
 /*********************************************************************
  * parport stuff
  *********************************************************************/
-static void snd_mts64_interrupt(int irq, void *private)
+static void snd_mts64_interrupt(void *private)
 {
 	struct mts64 *mts = ((struct snd_card*)private)->private_data;
 	u16 ret;
diff --git a/sound/drivers/portman2x4.c b/sound/drivers/portman2x4.c
index 0eb9b5c..e065b2a 100644
--- a/sound/drivers/portman2x4.c
+++ b/sound/drivers/portman2x4.c
@@ -611,7 +611,7 @@ static int __devinit snd_portman_rawmidi_create(struct snd_card *card)
 /*********************************************************************
  * parport stuff
  *********************************************************************/
-static void snd_portman_interrupt(int irq, void *userdata)
+static void snd_portman_interrupt(void *userdata)
 {
 	unsigned char midivalue = 0;
 	struct portman *pm = ((struct snd_card*)userdata)->private_data;
