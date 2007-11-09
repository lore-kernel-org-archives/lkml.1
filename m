Return-Path: <linux-kernel-owner+w=401wt.eu-S1763393AbXKIXfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763393AbXKIXfg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 18:35:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759086AbXKIXf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 18:35:28 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:57118 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759153AbXKIXf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 18:35:27 -0500
Message-id: <25731202891966530041.slaby@pripojeni.net>
In-reply-to: <133622706419279219.slaby@pripojeni.net>
Subject: [PATCH 2/7] Char: rocket, printk cleanup
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Fri, 9 Nov 2007 18:35:27 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

rocket, printk cleanup

- add KERN_ level to each print
- change some levels appropriately
- add \n at the ends where missing
- change two complex printks into dev_info, where the original info is
  printed automatically

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit c0e0b8a247ca469f85e51867fb11b5dbc19dace7
tree cd0bea2e5da957ac4131e04b9c2c9dd7fcddf653
parent a9b06d9c7a580246dc328e96f31039d932bca47c
author Jiri Slaby <jirislaby@gmail.com> Sat, 20 Oct 2007 21:58:17 +0200
committer Jiri Slaby <jirislaby@gmail.com> Fri, 09 Nov 2007 22:25:15 +0100

 drivers/char/rocket.c     |   89 ++++++++++++++++++++++++---------------------
 drivers/char/rocket_int.h |    6 ++-
 2 files changed, 51 insertions(+), 44 deletions(-)

diff --git a/drivers/char/rocket.c b/drivers/char/rocket.c
index 7a63f57..ffb34c4 100644
--- a/drivers/char/rocket.c
+++ b/drivers/char/rocket.c
@@ -305,8 +305,8 @@ static inline int rocket_paranoia_check(struct r_port *info,
 	if (!info)
 		return 1;
 	if (info->magic != RPORT_MAGIC) {
-		printk(KERN_INFO "Warning: bad magic number for rocketport struct in %s\n",
-		     routine);
+		printk(KERN_WARNING "Warning: bad magic number for rocketport "
+				"struct in %s\n", routine);
 		return 1;
 	}
 #endif
@@ -328,7 +328,7 @@ static void rp_do_receive(struct r_port *info,
 
 	ToRecv = sGetRxCnt(cp);
 #ifdef ROCKET_DEBUG_INTR
-	printk(KERN_INFO "rp_do_receive(%d)...", ToRecv);
+	printk(KERN_INFO "rp_do_receive(%d)...\n", ToRecv);
 #endif
 	if (ToRecv == 0)
 		return;
@@ -341,7 +341,7 @@ static void rp_do_receive(struct r_port *info,
 	if (ChanStatus & (RXFOVERFL | RXBREAK | RXFRAME | RXPARITY)) {
 		if (!(ChanStatus & STATMODE)) {
 #ifdef ROCKET_DEBUG_RECEIVE
-			printk(KERN_INFO "Entering STATMODE...");
+			printk(KERN_INFO "Entering STATMODE...\n");
 #endif
 			ChanStatus |= STATMODE;
 			sEnRxStatusMode(cp);
@@ -355,15 +355,15 @@ static void rp_do_receive(struct r_port *info,
 	 */
 	if (ChanStatus & STATMODE) {
 #ifdef ROCKET_DEBUG_RECEIVE
-		printk(KERN_INFO "Ignore %x, read %x...", info->ignore_status_mask,
-		       info->read_status_mask);
+		printk(KERN_INFO "Ignore %x, read %x...\n",
+			info->ignore_status_mask, info->read_status_mask);
 #endif
 		while (ToRecv) {
 			char flag;
 
 			CharNStat = sInW(sGetTxRxDataIO(cp));
 #ifdef ROCKET_DEBUG_RECEIVE
-			printk(KERN_INFO "%x...", CharNStat);
+			printk(KERN_INFO "%x...\n", CharNStat);
 #endif
 			if (CharNStat & STMBREAKH)
 				CharNStat &= ~(STMFRAMEH | STMPARITYH);
@@ -435,12 +435,13 @@ static void rp_do_transmit(struct r_port *info)
 	unsigned long flags;
 
 #ifdef ROCKET_DEBUG_INTR
-	printk(KERN_INFO "rp_do_transmit ");
+	printk(KERN_DEBUG "%s\n", __func__);
 #endif
 	if (!info)
 		return;
 	if (!info->tty) {
-		printk(KERN_INFO  "rp: WARNING rp_do_transmit called with info->tty==NULL\n");
+		printk(KERN_WARNING "rp: WARNING %s called with "
+				"info->tty==NULL\n", __func__);
 		clear_bit((info->aiop * 8) + info->chan, (void *) &xmit_flags[info->board]);
 		return;
 	}
@@ -464,7 +465,7 @@ static void rp_do_transmit(struct r_port *info)
 		info->xmit_cnt -= c;
 		info->xmit_fifo_room -= c;
 #ifdef ROCKET_DEBUG_INTR
-		printk(KERN_INFO "tx %d chars...", c);
+		printk(KERN_INFO "tx %d chars...\n", c);
 #endif
 	}
 
@@ -481,7 +482,7 @@ static void rp_do_transmit(struct r_port *info)
 	spin_unlock_irqrestore(&info->slock, flags);
 
 #ifdef ROCKET_DEBUG_INTR
-	printk(KERN_INFO "(%d,%d,%d,%d)...", info->xmit_cnt, info->xmit_head,
+	printk(KERN_DEBUG "(%d,%d,%d,%d)...\n", info->xmit_cnt, info->xmit_head,
 	       info->xmit_tail, info->xmit_fifo_room);
 #endif
 }
@@ -501,11 +502,13 @@ static void rp_handle_port(struct r_port *info)
 		return;
 
 	if ((info->flags & ROCKET_INITIALIZED) == 0) {
-		printk(KERN_INFO "rp: WARNING: rp_handle_port called with info->flags & NOT_INIT\n");
+		printk(KERN_WARNING "rp: WARNING: rp_handle_port called with "
+				"info->flags & NOT_INIT\n");
 		return;
 	}
 	if (!info->tty) {
-		printk(KERN_INFO "rp: WARNING: rp_handle_port called with info->tty==NULL\n");
+		printk(KERN_WARNING "rp: WARNING: rp_handle_port called with "
+				"info->tty==NULL\n");
 		return;
 	}
 	cp = &info->channel;
@@ -513,7 +516,7 @@ static void rp_handle_port(struct r_port *info)
 
 	IntMask = sGetChanIntID(cp) & info->intmask;
 #ifdef ROCKET_DEBUG_INTR
-	printk(KERN_INFO "rp_interrupt %02x...", IntMask);
+	printk(KERN_INFO "rp_interrupt %02x...\n", IntMask);
 #endif
 	ChanStatus = sGetChanStatus(cp);
 	if (IntMask & RXF_TRIG) {	/* Rx FIFO trigger level */
@@ -521,7 +524,7 @@ static void rp_handle_port(struct r_port *info)
 	}
 	if (IntMask & DELTA_CD) {	/* CD change  */
 #if (defined(ROCKET_DEBUG_OPEN) || defined(ROCKET_DEBUG_INTR) || defined(ROCKET_DEBUG_HANGUP))
-		printk(KERN_INFO "ttyR%d CD now %s...", info->line,
+		printk(KERN_INFO "ttyR%d CD now %s...\n", info->line,
 		       (ChanStatus & CD_ACT) ? "on" : "off");
 #endif
 		if (!(ChanStatus & CD_ACT) && info->cd_status) {
@@ -638,7 +641,8 @@ static void init_r_port(int board, int aiop, int chan, struct pci_dev *pci_dev)
 	/*  Get a r_port struct for the port, fill it in and save it globally, indexed by line number */
 	info = kzalloc(sizeof (struct r_port), GFP_KERNEL);
 	if (!info) {
-		printk(KERN_INFO "Couldn't allocate info struct for line #%d\n", line);
+		printk(KERN_ERR "Couldn't allocate info struct for line #%d\n",
+				line);
 		return;
 	}
 
@@ -668,7 +672,8 @@ static void init_r_port(int board, int aiop, int chan, struct pci_dev *pci_dev)
 
 	info->intmask = RXF_TRIG | TXFIFO_MT | SRC_INT | DELTA_CD | DELTA_CTS | DELTA_DSR;
 	if (sInitChan(ctlp, &info->channel, aiop, chan) == 0) {
-		printk(KERN_INFO "RocketPort sInitChan(%d, %d, %d) failed!\n", board, aiop, chan);
+		printk(KERN_ERR "RocketPort sInitChan(%d, %d, %d) failed!\n",
+				board, aiop, chan);
 		kfree(info);
 		return;
 	}
@@ -1007,7 +1012,8 @@ static int rp_open(struct tty_struct *tty, struct file *filp)
 		atomic_inc(&rp_num_ports_open);
 
 #ifdef ROCKET_DEBUG_OPEN
-		printk(KERN_INFO "rocket mod++ = %d...", atomic_read(&rp_num_ports_open));
+		printk(KERN_INFO "rocket mod++ = %d...\n",
+				atomic_read(&rp_num_ports_open));
 #endif
 	}
 #ifdef ROCKET_DEBUG_OPEN
@@ -1103,13 +1109,13 @@ static void rp_close(struct tty_struct *tty, struct file *filp)
 		 * one, we've got real problems, since it means the
 		 * serial port won't be shutdown.
 		 */
-		printk(KERN_INFO "rp_close: bad serial port count; tty->count is 1, "
-		       "info->count is %d\n", info->count);
+		printk(KERN_WARNING "rp_close: bad serial port count; "
+			"tty->count is 1, info->count is %d\n", info->count);
 		info->count = 1;
 	}
 	if (--info->count < 0) {
-		printk(KERN_INFO "rp_close: bad serial port count for ttyR%d: %d\n",
-		       info->line, info->count);
+		printk(KERN_WARNING "rp_close: bad serial port count for "
+				"ttyR%d: %d\n", info->line, info->count);
 		info->count = 0;
 	}
 	if (info->count) {
@@ -1184,7 +1190,8 @@ static void rp_close(struct tty_struct *tty, struct file *filp)
 	atomic_dec(&rp_num_ports_open);
 
 #ifdef ROCKET_DEBUG_OPEN
-	printk(KERN_INFO "rocket mod-- = %d...", atomic_read(&rp_num_ports_open));
+	printk(KERN_INFO "rocket mod-- = %d...\n",
+			atomic_read(&rp_num_ports_open));
 	printk(KERN_INFO "rp_close ttyR%d complete shutdown\n", info->line);
 #endif
 
@@ -1569,9 +1576,9 @@ static void rp_wait_until_sent(struct tty_struct *tty, int timeout)
 
 	orig_jiffies = jiffies;
 #ifdef ROCKET_DEBUG_WAIT_UNTIL_SENT
-	printk(KERN_INFO "In RP_wait_until_sent(%d) (jiff=%lu)...", timeout,
+	printk(KERN_INFO "In RP_wait_until_sent(%d) (jiff=%lu)...\n", timeout,
 	       jiffies);
-	printk(KERN_INFO "cps=%d...", info->cps);
+	printk(KERN_INFO "cps=%d...\n", info->cps);
 #endif
 	while (1) {
 		txcnt = sGetTxCnt(cp);
@@ -1592,7 +1599,8 @@ static void rp_wait_until_sent(struct tty_struct *tty, int timeout)
 		if (check_time == 0)
 			check_time = 1;
 #ifdef ROCKET_DEBUG_WAIT_UNTIL_SENT
-		printk(KERN_INFO "txcnt = %d (jiff=%lu,check=%d)...", txcnt, jiffies, check_time);
+		printk(KERN_INFO "txcnt = %d (jiff=%lu,check=%d)...\n", txcnt,
+				jiffies, check_time);
 #endif
 		msleep_interruptible(jiffies_to_msecs(check_time));
 		if (signal_pending(current))
@@ -1616,7 +1624,7 @@ static void rp_hangup(struct tty_struct *tty)
 		return;
 
 #if (defined(ROCKET_DEBUG_OPEN) || defined(ROCKET_DEBUG_HANGUP))
-	printk(KERN_INFO "rp_hangup of ttyR%d...", info->line);
+	printk(KERN_INFO "rp_hangup of ttyR%d...\n", info->line);
 #endif
 	rp_flush_buffer(tty);
 	if (info->flags & ROCKET_CLOSING)
@@ -1664,7 +1672,7 @@ static void rp_put_char(struct tty_struct *tty, unsigned char ch)
 	mutex_lock(&info->write_mtx);
 
 #ifdef ROCKET_DEBUG_WRITE
-	printk(KERN_INFO "rp_put_char %c...", ch);
+	printk(KERN_INFO "rp_put_char %c...\n", ch);
 #endif
 
 	spin_lock_irqsave(&info->slock, flags);
@@ -1709,7 +1717,7 @@ static int rp_write(struct tty_struct *tty,
 		return -ERESTARTSYS;
 
 #ifdef ROCKET_DEBUG_WRITE
-	printk(KERN_INFO "rp_write %d chars...", count);
+	printk(KERN_INFO "rp_write %d chars...\n", count);
 #endif
 	cp = &info->channel;
 
@@ -1798,7 +1806,7 @@ static int rp_write_room(struct tty_struct *tty)
 	if (ret < 0)
 		ret = 0;
 #ifdef ROCKET_DEBUG_WRITE
-	printk(KERN_INFO "rp_write_room returns %d...", ret);
+	printk(KERN_INFO "rp_write_room returns %d...\n", ret);
 #endif
 	return ret;
 }
@@ -1818,7 +1826,7 @@ static int rp_chars_in_buffer(struct tty_struct *tty)
 	cp = &info->channel;
 
 #ifdef ROCKET_DEBUG_WRITE
-	printk(KERN_INFO "rp_chars_in_buffer returns %d...", info->xmit_cnt);
+	printk(KERN_INFO "rp_chars_in_buffer returns %d...\n", info->xmit_cnt);
 #endif
 	return info->xmit_cnt;
 }
@@ -2161,14 +2169,11 @@ static __init int register_PCI(int i, struct pci_dev *dev)
 	for (aiop = 0; aiop < max_num_aiops; aiop++)
 		ctlp->AiopNumChan[aiop] = ports_per_aiop;
 
-	printk("Comtrol PCI controller #%d ID 0x%x found in bus:slot:fn %s at address %04lx, "
-	     "%d AIOP(s) (%s)\n", i, dev->device, pci_name(dev),
-	     rcktpt_io_addr[i], num_aiops, rocketModel[i].modelString);
-	printk(KERN_INFO "Installing %s, creating /dev/ttyR%d - %ld\n",
-	       rocketModel[i].modelString,
-	       rocketModel[i].startingPortNumber,
-	       rocketModel[i].startingPortNumber +
-	       rocketModel[i].numPorts - 1);
+	dev_info(&dev->dev, "comtrol PCI controller #%d found at "
+		"address %04lx, %d AIOP(s) (%s), creating ttyR%d - %ld\n",
+		i, rcktpt_io_addr[i], num_aiops, rocketModel[i].modelString,
+		rocketModel[i].startingPortNumber,
+		rocketModel[i].startingPortNumber + rocketModel[i].numPorts-1);
 
 	if (num_aiops <= 0) {
 		rcktpt_io_addr[i] = 0;
@@ -2240,7 +2245,9 @@ static int __init init_ISA(int i)
 
 	/*  Reserve the IO region */
 	if (!request_region(rcktpt_io_addr[i], 64, "Comtrol RocketPort")) {
-		printk(KERN_INFO "Unable to reserve IO region for configured ISA RocketPort at address 0x%lx, board not installed...\n", rcktpt_io_addr[i]);
+		printk(KERN_ERR "Unable to reserve IO region for configured "
+				"ISA RocketPort at address 0x%lx, board not "
+				"installed...\n", rcktpt_io_addr[i]);
 		rcktpt_io_addr[i] = 0;
 		return (0);
 	}
@@ -2480,7 +2487,7 @@ static void rp_cleanup_module(void)
 
 	retval = tty_unregister_driver(rocket_driver);
 	if (retval)
-		printk(KERN_INFO "Error %d while trying to unregister "
+		printk(KERN_ERR "Error %d while trying to unregister "
 		       "rocketport driver\n", -retval);
 
 	for (i = 0; i < MAX_RP_PORTS; i++)
diff --git a/drivers/char/rocket_int.h b/drivers/char/rocket_int.h
index 55b8f2d..c3aab52 100644
--- a/drivers/char/rocket_int.h
+++ b/drivers/char/rocket_int.h
@@ -42,7 +42,7 @@ typedef unsigned int DWordIO_t;
 static inline void sOutB(unsigned short port, unsigned char value)
 {
 #ifdef ROCKET_DEBUG_IO
-	printk("sOutB(%x, %x)...", port, value);
+	printk(KERN_DEBUG "sOutB(%x, %x)...\n", port, value);
 #endif
 	outb_p(value, port);
 }
@@ -50,7 +50,7 @@ static inline void sOutB(unsigned short port, unsigned char value)
 static inline void sOutW(unsigned short port, unsigned short value)
 {
 #ifdef ROCKET_DEBUG_IO
-	printk("sOutW(%x, %x)...", port, value);
+	printk(KERN_DEBUG "sOutW(%x, %x)...\n", port, value);
 #endif
 	outw_p(value, port);
 }
@@ -58,7 +58,7 @@ static inline void sOutW(unsigned short port, unsigned short value)
 static inline void sOutDW(unsigned short port, unsigned long value)
 {
 #ifdef ROCKET_DEBUG_IO
-	printk("sOutDW(%x, %lx)...", port, value);
+	printk(KERN_DEBUG "sOutDW(%x, %lx)...\n", port, value);
 #endif
 	outl_p(cpu_to_le32(value), port);
 }
