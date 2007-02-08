Return-Path: <linux-kernel-owner+w=401wt.eu-S1423283AbXBHTs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423283AbXBHTs3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 14:48:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423289AbXBHTs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 14:48:29 -0500
Received: from cacti.profiwh.com ([85.93.165.66]:37235 "EHLO cacti.profiwh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423283AbXBHTsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 14:48:25 -0500
Message-id: <398523843890216659@wsc.cz>
In-reply-to: <156451408997831024@wsc.cz>
Subject: [PATCH 2/2] Char: timers cleanup
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@osdl.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: <R.E.Wolff@BitWizard.nl>
Cc: <jrv@vanzandt.mv.com>
Cc: <alex@linuxhacker.org>
Cc: <support.linux@omnikey.com>
Cc: <a.zummo@towertech.it>
Cc: <tpmdd_devel@lists.sourceforge.net>
Cc: <steve@navaho.co.uk>
Cc: <hero@ihg.uni-duisburg.de>
Cc: <wim@iguana.be>
Cc: <fuganti@conectiva.com.br>
Cc: <gorgo@itc.hu>
Cc: <khollis@bitgate.com>
Cc: <lethal@linux-sh.org>
Date: Thu,  8 Feb 2007 20:48:29 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

timers cleanup

- Use timer macros to set function and data members and to modify
  expiration time.
- Use DEFINE_TIMER for global timers and do not init them at run-time in
  these cases.
- del_timer_sync is common in most cases -- we want to wait for timer
  function if it's still running.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit e86725ac92c5a0902a63b1ebdf5a98643c71fa14
tree da8734ea3eefe8c4095e3a8bccbda1e715a86676
parent fc1cfd05e494252ac71a223e0cdd35cff7dd9844
author Jiri Slaby <jirislaby@gmail.com> Thu, 08 Feb 2007 18:39:36 +0100
committer Jiri Slaby <jirislaby@gmail.com> Thu, 08 Feb 2007 18:39:36 +0100

 drivers/char/drm/via_dmablit.c               |   14 ++++--------
 drivers/char/dtlk.c                          |    8 +++----
 drivers/char/ip2/i2lib.c                     |   30 +++++++++++++++-----------
 drivers/char/n_r3964.c                       |    4 +--
 drivers/char/nwbutton.c                      |   13 ++++-------
 drivers/char/pcmcia/cm4000_cs.c              |   10 +++------
 drivers/char/pcmcia/cm4040_cs.c              |    3 +--
 drivers/char/pcmcia/ipwireless_cs_hardware.c |    9 +++-----
 drivers/char/pcmcia/synclink_cs.c            |   10 +++------
 drivers/char/rio/rio_linux.c                 |   12 +++-------
 drivers/char/rocket.c                        |   10 +++------
 drivers/char/rtc.c                           |   12 ++++------
 drivers/char/scan_keyb.c                     |   14 +++---------
 drivers/char/specialix.c                     |   12 +++-------
 drivers/char/synclink.c                      |   10 +++------
 drivers/char/synclink_gt.c                   |   19 +++++-----------
 drivers/char/synclinkmp.c                    |   22 ++++++-------------
 drivers/char/tpm/tpm.c                       |    5 ++--
 drivers/char/vt.c                            |    4 +--
 drivers/char/watchdog/alim7101_wdt.c         |   13 +++--------
 drivers/char/watchdog/cpu5wdt.c              |   13 +++--------
 drivers/char/watchdog/machzwd.c              |   16 ++++----------
 drivers/char/watchdog/mixcomwd.c             |   14 +++++-------
 drivers/char/watchdog/pcwd.c                 |    4 +--
 drivers/char/watchdog/sbc60xxwdt.c           |   12 +++-------
 drivers/char/watchdog/sc520_wdt.c            |   12 +++-------
 drivers/char/watchdog/shwdt.c                |    8 +++----
 drivers/char/watchdog/w83877f_wdt.c          |   12 +++-------
 28 files changed, 112 insertions(+), 213 deletions(-)

diff --git a/drivers/char/drm/via_dmablit.c b/drivers/char/drm/via_dmablit.c
index 2054d57..2881a06 100644
--- a/drivers/char/drm/via_dmablit.c
+++ b/drivers/char/drm/via_dmablit.c
@@ -376,10 +376,8 @@ via_dmablit_handler(drm_device_t *dev, int engine, int from_irq)
 			blitq->cur = cur;
 			blitq->num_outstanding--;
 			blitq->end = jiffies + DRM_HZ;
-			if (!timer_pending(&blitq->poll_timer)) {
-				blitq->poll_timer.expires = jiffies+1;
-				add_timer(&blitq->poll_timer);
-			}
+			if (!timer_pending(&blitq->poll_timer))
+				mod_timer(&blitq->poll_timer, jiffies + 1);
 		} else {
 			if (timer_pending(&blitq->poll_timer)) {
 				del_timer(&blitq->poll_timer);
@@ -478,8 +476,7 @@ via_dmablit_timer(unsigned long data)
 	via_dmablit_handler(dev, engine, 0);
 	
 	if (!timer_pending(&blitq->poll_timer)) {
-		blitq->poll_timer.expires = jiffies+1;
-		add_timer(&blitq->poll_timer);
+		mod_timer(&blitq->poll_timer, jiffies + 1);
 
 	       /*
 		* Rerun handler to delete timer if engines are off, and
@@ -574,9 +571,8 @@ via_init_dmablit(drm_device_t *dev)
 		}
 		DRM_INIT_WAITQUEUE(&blitq->busy_queue);
 		INIT_WORK(&blitq->wq, via_dmablit_workqueue);
-		init_timer(&blitq->poll_timer);
-		blitq->poll_timer.function = &via_dmablit_timer;
-		blitq->poll_timer.data = (unsigned long) blitq;
+		setup_timer(&blitq->poll_timer, via_dmablit_timer,
+				(unsigned long)blitq);
 	}	
 }
 
diff --git a/drivers/char/dtlk.c b/drivers/char/dtlk.c
index d4005e9..d8dbdb9 100644
--- a/drivers/char/dtlk.c
+++ b/drivers/char/dtlk.c
@@ -72,6 +72,7 @@
 #define TRACE_RET ((void) 0)
 #endif				/* TRACING */
 
+static void dtlk_timer_tick(unsigned long data);
 
 static int dtlk_major;
 static int dtlk_port_lpc;
@@ -81,7 +82,7 @@ static int dtlk_has_indexing;
 static unsigned int dtlk_portlist[] =
 {0x25e, 0x29e, 0x2de, 0x31e, 0x35e, 0x39e, 0};
 static wait_queue_head_t dtlk_process_list;
-static struct timer_list dtlk_timer;
+static DEFINE_TIMER(dtlk_timer, dtlk_timer_tick, 0, 0);
 
 /* prototypes for file_operations struct */
 static ssize_t dtlk_read(struct file *, char __user *,
@@ -117,7 +118,6 @@ static char dtlk_write_tts(char);
 /*
    static void dtlk_handle_error(char, char, unsigned int);
  */
-static void dtlk_timer_tick(unsigned long data);
 
 static ssize_t dtlk_read(struct file *file, char __user *buf,
 			 size_t count, loff_t * ppos)
@@ -318,7 +318,7 @@ static int dtlk_release(struct inode *inode, struct file *file)
 	}
 	TRACE_RET;
 	
-	del_timer(&dtlk_timer);
+	del_timer_sync(&dtlk_timer);
 
 	return 0;
 }
@@ -336,8 +336,6 @@ static int __init dtlk_init(void)
 	if (dtlk_dev_probe() == 0)
 		printk(", MAJOR %d\n", dtlk_major);
 
-	init_timer(&dtlk_timer);
-	dtlk_timer.function = dtlk_timer_tick;
 	init_waitqueue_head(&dtlk_process_list);
 
 	return 0;
diff --git a/drivers/char/ip2/i2lib.c b/drivers/char/ip2/i2lib.c
index 88b9d33..f86fa0c 100644
--- a/drivers/char/ip2/i2lib.c
+++ b/drivers/char/ip2/i2lib.c
@@ -80,7 +80,7 @@ static int i2RetryFlushOutput(i2ChanStrPtr);
 // Not a documented part of the library routines (careful...) but the Diagnostic
 // i2diag.c finds them useful to help the throughput in certain limited
 // single-threaded operations.
-static void iiSendPendingMail(i2eBordStrPtr);
+static inline void iiSendPendingMail(i2eBordStrPtr);
 static void serviceOutgoingFifo(i2eBordStrPtr);
 
 // Functions defined in ip2.c as part of interrupt handling
@@ -150,6 +150,13 @@ i2Validate ( i2ChanStrPtr pCh )
 			  == (CHANNEL_MAGIC | CHANNEL_SUPPORT));
 }
 
+static void iiSendPendingMail_t(unsigned long data)
+{
+	i2eBordStrPtr pB = (i2eBordStrPtr)data;
+
+	iiSendPendingMail(pB);
+}
+
 //******************************************************************************
 // Function:   iiSendPendingMail(pB)
 // Parameters: Pointer to a board structure
@@ -184,12 +191,9 @@ iiSendPendingMail(i2eBordStrPtr pB)
 			/\/\|=mhw=|\/\/				*/
 
 			if( ++pB->SendPendingRetry < 16 ) {
-
-				init_timer( &(pB->SendPendingTimer) );
-				pB->SendPendingTimer.expires  = jiffies + 1;
-				pB->SendPendingTimer.function = (void*)(unsigned long)iiSendPendingMail;
-				pB->SendPendingTimer.data     = (unsigned long)pB;
-				add_timer( &(pB->SendPendingTimer) );
+				setup_timer(&pB->SendPendingTimer,
+					iiSendPendingMail_t, (unsigned long)pB);
+				mod_timer(&pB->SendPendingTimer, jiffies + 1);
 			} else {
 				printk( KERN_ERR "IP2: iiSendPendingMail unable to queue outbound mail\n" );
 			}
@@ -1265,8 +1269,10 @@ i2RetryFlushOutput(i2ChanStrPtr pCh)
 // soon as all the data is completely sent.
 //******************************************************************************
 static void
-i2DrainWakeup(i2ChanStrPtr pCh)
+i2DrainWakeup(unsigned long d)
 {
+	i2ChanStrPtr pCh = (i2ChanStrPtr)d;
+
 	ip2trace (CHANN, ITRC_DRAIN, 10, 1, pCh->BookmarkTimer.expires );
 
 	pCh->BookmarkTimer.expires = 0;
@@ -1292,14 +1298,12 @@ i2DrainOutput(i2ChanStrPtr pCh, int timeout)
 	}
 	if ((timeout > 0) && (pCh->BookmarkTimer.expires == 0 )) {
 		// One per customer (channel)
-		init_timer( &(pCh->BookmarkTimer) );
-		pCh->BookmarkTimer.expires  = jiffies + timeout;
-		pCh->BookmarkTimer.function = (void*)(unsigned long)i2DrainWakeup;
-		pCh->BookmarkTimer.data     = (unsigned long)pCh;
+		setup_timer(&pCh->BookmarkTimer, i2DrainWakeup,
+				(unsigned long)pCh);
 
 		ip2trace (CHANN, ITRC_DRAIN, 1, 1, pCh->BookmarkTimer.expires );
 
-		add_timer( &(pCh->BookmarkTimer) );
+		mod_timer(&pCh->BookmarkTimer, jiffies + timeout);
 	}
 	
 	i2QueueCommands( PTYPE_INLINE, pCh, -1, 1, CMD_BMARK_REQ );
diff --git a/drivers/char/n_r3964.c b/drivers/char/n_r3964.c
index fab1b7d..65f2d3a 100644
--- a/drivers/char/n_r3964.c
+++ b/drivers/char/n_r3964.c
@@ -1005,9 +1005,7 @@ static int r3964_open(struct tty_struct *tty)
 	tty->disc_data = pInfo;
 	tty->receive_room = 65536;
 
-	init_timer(&pInfo->tmr);
-	pInfo->tmr.data = (unsigned long)pInfo;
-	pInfo->tmr.function = on_timeout;
+	setup_timer(&pInfo->tmr, on_timeout, (unsigned long)pInfo);
 
 	return 0;
 }
diff --git a/drivers/char/nwbutton.c b/drivers/char/nwbutton.c
index 2d26497..dc4b13c 100644
--- a/drivers/char/nwbutton.c
+++ b/drivers/char/nwbutton.c
@@ -23,8 +23,11 @@
 #define __NWBUTTON_C		/* Tell the header file who we are */
 #include "nwbutton.h"
 
+static void button_sequence_finished (unsigned long parameters);
+
 static int button_press_count;		/* The count of button presses */
-static struct timer_list button_timer;	/* Times for the end of a sequence */ 
+/* Times for the end of a sequence */ 
+static DEFINE_TIMER(button_timer, button_sequence_finished, 0, 0);
 static DECLARE_WAIT_QUEUE_HEAD(button_wait_queue); /* Used for blocking read */
 static char button_output_buffer[32];	/* Stores data to write out of device */
 static int bcount;			/* The number of bytes in the buffer */
@@ -146,14 +149,8 @@ static void button_sequence_finished (unsigned long parameters)
 
 static irqreturn_t button_handler (int irq, void *dev_id)
 {
-	if (button_press_count) {
-		del_timer (&button_timer);
-	}
 	button_press_count++;
-	init_timer (&button_timer);
-	button_timer.function = button_sequence_finished;
-	button_timer.expires = (jiffies + bdelay);
-	add_timer (&button_timer);
+	mod_timer(&button_timer, jiffies + bdelay);
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/char/pcmcia/cm4000_cs.c b/drivers/char/pcmcia/cm4000_cs.c
index 211c93f..e91b43a 100644
--- a/drivers/char/pcmcia/cm4000_cs.c
+++ b/drivers/char/pcmcia/cm4000_cs.c
@@ -946,8 +946,7 @@ release_io:
 
 return_with_timer:
 	DEBUGP(7, dev, "<- monitor_card (returns with timer)\n");
-	dev->timer.expires = jiffies + dev->mdelay;
-	add_timer(&dev->timer);
+	mod_timer(&dev->timer, jiffies + dev->mdelay);
 	clear_bit(LOCK_MONITOR, &dev->flags);
 }
 
@@ -1406,12 +1405,9 @@ static void start_monitor(struct cm4000_dev *dev)
 	DEBUGP(3, dev, "-> start_monitor\n");
 	if (!dev->monitor_running) {
 		DEBUGP(5, dev, "create, init and add timer\n");
-		init_timer(&dev->timer);
+		setup_timer(&dev->timer, monitor_card, (unsigned long)dev);
 		dev->monitor_running = 1;
-		dev->timer.expires = jiffies;
-		dev->timer.data = (unsigned long) dev;
-		dev->timer.function = monitor_card;
-		add_timer(&dev->timer);
+		mod_timer(&dev->timer, jiffies);
 	} else
 		DEBUGP(5, dev, "monitor already running\n");
 	DEBUGP(3, dev, "<- start_monitor\n");
diff --git a/drivers/char/pcmcia/cm4040_cs.c b/drivers/char/pcmcia/cm4040_cs.c
index 9b1ff7e..0e82968 100644
--- a/drivers/char/pcmcia/cm4040_cs.c
+++ b/drivers/char/pcmcia/cm4040_cs.c
@@ -632,8 +632,7 @@ static int reader_probe(struct pcmcia_device *link)
 	init_waitqueue_head(&dev->poll_wait);
 	init_waitqueue_head(&dev->read_wait);
 	init_waitqueue_head(&dev->write_wait);
-	init_timer(&dev->poll_timer);
-	dev->poll_timer.function = &cm4040_do_poll;
+	setup_timer(&dev->poll_timer, cm4040_do_poll, 0);
 
 	ret = reader_config(link, i);
 	if (ret)
diff --git a/drivers/char/pcmcia/ipwireless_cs_hardware.c b/drivers/char/pcmcia/ipwireless_cs_hardware.c
index e29d067..421e5ee 100644
--- a/drivers/char/pcmcia/ipwireless_cs_hardware.c
+++ b/drivers/char/pcmcia/ipwireless_cs_hardware.c
@@ -1460,9 +1460,7 @@ ipw_hardware_t *ipwireless_hardware_create(struct ipw_config_t *config)
 	tasklet_init(&hw->tasklet, ipwireless_do_tasklet,
 		     (unsigned long) hw);
 
-	init_timer(&hw->setup_timer);
-	hw->setup_timer.function = ipwireless_setup_timer;
-	hw->setup_timer.data = (unsigned long) hw;
+	setup_timer(&hw->setup_timer, ipwireless_setup_timer,(unsigned long)hw);
 
 	INIT_WORK(&hw->work_rx, do_receive_data_work);
 
@@ -1531,9 +1529,8 @@ static void ipwireless_setup_timer(unsigned long data)
 			spin_unlock_irqrestore(&hw->spinlock, flags);
 		}
 
-		hw->setup_timer.expires =
-		    jiffies + (unsigned long) TL_SETUP_VERSION_QRY_TMO *HZ / 1000UL;
-		add_timer(&hw->setup_timer);
+		mod_timer(&hw->setup_timer, jiffies +
+				msecs_to_jiffies(TL_SETUP_VERSION_QRY_TMO));
 	}
 }
 
diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index 4ab2c98..6a8d173 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -1361,9 +1361,7 @@ static int startup(MGSLPC_INFO * info)
 	
 	memset(&info->icount, 0, sizeof(info->icount));
 
-	init_timer(&info->tx_timer);
-	info->tx_timer.data = (unsigned long)info;
-	info->tx_timer.function = tx_timeout;
+	setup_timer(&info->tx_timer, tx_timeout, (unsigned long)info);
 
 	/* Allocate and claim adapter resources */
 	retval = claim_resources(info);
@@ -1408,7 +1406,7 @@ static void shutdown(MGSLPC_INFO * info)
 	wake_up_interruptible(&info->status_event_wait_q);
 	wake_up_interruptible(&info->event_wait_q);
 
-	del_timer(&info->tx_timer);	
+	del_timer_sync(&info->tx_timer);	
 
 	if (info->tx_buf) {
 		free_page((unsigned long) info->tx_buf);
@@ -3549,8 +3547,8 @@ static void tx_start(MGSLPC_INFO *info)
 		} else {
 			info->tx_active = 1;
 			tx_ready(info);
-			info->tx_timer.expires = jiffies + msecs_to_jiffies(5000);
-			add_timer(&info->tx_timer);	
+			mod_timer(&info->tx_timer, jiffies +
+					msecs_to_jiffies(5000));	
 		}
 	}
 
diff --git a/drivers/char/rio/rio_linux.c b/drivers/char/rio/rio_linux.c
index e79b2ed..85c1618 100644
--- a/drivers/char/rio/rio_linux.c
+++ b/drivers/char/rio/rio_linux.c
@@ -418,8 +418,7 @@ static void rio_pollfunc(unsigned long data)
 	func_enter();
 
 	rio_interrupt(0, &p->RIOHosts[data]);
-	p->RIOHosts[data].timer.expires = jiffies + rio_poll;
-	add_timer(&p->RIOHosts[data].timer);
+	mod_timer(&p->RIOHosts[data].timer, jiffies + rio_poll);
 
 	func_exit();
 }
@@ -1154,13 +1153,10 @@ static int __init rio_init(void)
 		/* Init the timer "always" to make sure that it can safely be
 		   deleted when we unload... */
 
-		init_timer(&hp->timer);
+		setup_timer(&hp->timer, rio_pollfunc, i);
 		if (!hp->Ivec) {
 			rio_dprintk(RIO_DEBUG_INIT, "Starting polling at %dj intervals.\n", rio_poll);
-			hp->timer.data = i;
-			hp->timer.function = rio_pollfunc;
-			hp->timer.expires = jiffies + rio_poll;
-			add_timer(&hp->timer);
+			mod_timer(&hp->timer, jiffies + rio_poll);
 		}
 	}
 
@@ -1191,7 +1187,7 @@ static void __exit rio_exit(void)
 			rio_dprintk(RIO_DEBUG_INIT, "freed irq %d.\n", hp->Ivec);
 		}
 		/* It is safe/allowed to del_timer a non-active timer */
-		del_timer(&hp->timer);
+		del_timer_sync(&hp->timer);
 		if (hp->Caddr)
 			iounmap(hp->Caddr);
 		if (hp->Type == RIO_PCI)
diff --git a/drivers/char/rocket.c b/drivers/char/rocket.c
index 106f225..76357c8 100644
--- a/drivers/char/rocket.c
+++ b/drivers/char/rocket.c
@@ -106,6 +106,8 @@
 
 /****** RocketPort Local Variables ******/
 
+static void rp_do_poll(unsigned long dummy);
+
 static struct tty_driver *rocket_driver;
 
 static struct rocket_version driver_version = {	
@@ -116,7 +118,7 @@ static struct r_port *rp_table[MAX_RP_PORTS];	       /*  The main repository of
 static unsigned int xmit_flags[NUM_BOARDS];	       /*  Bit significant, indicates port had data to transmit. */
 						       /*  eg.  Bit 0 indicates port 0 has xmit data, ...        */
 static atomic_t rp_num_ports_open;	               /*  Number of serial ports open                           */
-static struct timer_list rocket_timer;
+static DEFINE_TIMER(rocket_timer, rp_do_poll, 0, 0);
 
 static unsigned long board1;	                       /* ISA addresses, retrieved from rocketport.conf          */
 static unsigned long board2;
@@ -2368,12 +2370,6 @@ static int __init rp_init(void)
 		return -ENOMEM;
 
 	/*
-	 * Set up the timer channel.
-	 */
-	init_timer(&rocket_timer);
-	rocket_timer.function = rp_do_poll;
-
-	/*
 	 * Initialize the array of pointers to our own internal state
 	 * structures.
 	 */
diff --git a/drivers/char/rtc.c b/drivers/char/rtc.c
index 98a2f5e..c7dac9b 100644
--- a/drivers/char/rtc.c
+++ b/drivers/char/rtc.c
@@ -135,7 +135,9 @@ static struct fasync_struct *rtc_async_queue;
 static DECLARE_WAIT_QUEUE_HEAD(rtc_wait);
 
 #ifdef RTC_IRQ
-static struct timer_list rtc_irq_timer;
+static void rtc_dropped_irq(unsigned long data);
+
+static DEFINE_TIMER(rtc_irq_timer, rtc_dropped_irq, 0, 0);
 #endif
 
 static ssize_t rtc_read(struct file *file, char __user *buf,
@@ -150,8 +152,6 @@ static unsigned int rtc_poll(struct file *file, poll_table *wait);
 
 static void get_rtc_alm_time (struct rtc_time *alm_tm);
 #ifdef RTC_IRQ
-static void rtc_dropped_irq(unsigned long data);
-
 static void set_rtc_irq_bit_locked(unsigned char bit);
 static void mask_rtc_irq_bit_locked(unsigned char bit);
 
@@ -452,8 +452,8 @@ static int rtc_do_ioctl(unsigned int cmd, unsigned long arg, int kernel)
 
 		spin_lock_irqsave (&rtc_lock, flags);
 		if (!(rtc_status & RTC_TIMER_ON)) {
-			rtc_irq_timer.expires = jiffies + HZ/rtc_freq + 2*HZ/100;
-			add_timer(&rtc_irq_timer);
+			mod_timer(&rtc_irq_timer, jiffies + HZ/rtc_freq +
+					2*HZ/100);
 			rtc_status |= RTC_TIMER_ON;
 		}
 		set_rtc_irq_bit_locked(RTC_PIE);
@@ -1082,8 +1082,6 @@ no_irq:
 	if (rtc_has_irq == 0)
 		goto no_irq2;
 
-	init_timer(&rtc_irq_timer);
-	rtc_irq_timer.function = rtc_dropped_irq;
 	spin_lock_irq(&rtc_lock);
 	rtc_freq = 1024;
 	if (!hpet_set_periodic_freq(rtc_freq)) {
diff --git a/drivers/char/scan_keyb.c b/drivers/char/scan_keyb.c
index 6bf551d..1c3d67c 100644
--- a/drivers/char/scan_keyb.c
+++ b/drivers/char/scan_keyb.c
@@ -31,7 +31,7 @@ struct scan_keyboard {
 
 static int scan_jiffies=0;
 static struct scan_keyboard *keyboards=NULL;
-struct timer_list scan_timer;
+static DEFINE_TIMER(scan_timer, scan_kbd, 0, 0);
 
 static void check_kbd(const unsigned char *table,
 		      unsigned char *new, unsigned char *old, int length)
@@ -87,11 +87,7 @@ static void scan_kbd(unsigned long dummy)
 		
 	}
 
-	init_timer(&scan_timer);
-	scan_timer.expires = jiffies + SCANHZ;
-	scan_timer.data = 0;
-	scan_timer.function = scan_kbd;
-	add_timer(&scan_timer);
+	mod_timer(&scan_timer, jiffies + SCANHZ);
 }
 
 
@@ -138,11 +134,7 @@ int register_scan_keyboard(int (*scan)(unsigned char *buffer),
 			      
 void __init scan_kbd_init(void)
 {
-	init_timer(&scan_timer);
-	scan_timer.expires = jiffies + SCANHZ;
-	scan_timer.data = 0;
-	scan_timer.function = scan_kbd;
-	add_timer(&scan_timer);
+	mod_timer(&scan_timer, jiffies + SCANHZ);
 
 	printk(KERN_INFO "Generic scan keyboard driver initialized\n");
 }
diff --git a/drivers/char/specialix.c b/drivers/char/specialix.c
index f1688fe..baf7234 100644
--- a/drivers/char/specialix.c
+++ b/drivers/char/specialix.c
@@ -461,8 +461,7 @@ void missed_irq (unsigned long data)
 		sx_interrupt (((struct specialix_board *)data)->irq,
 				(void*)data);
 	}
-	missed_irq_timer.expires = jiffies + sx_poll;
-	add_timer (&missed_irq_timer);
+	mod_timer(&missed_irq_timer, jiffies + sx_poll);
 }
 #endif
 
@@ -597,11 +596,8 @@ static int sx_probe(struct specialix_board *bp)
 	dprintk (SX_DEBUG_INIT, " GFCR = 0x%02x\n", sx_in_off(bp, CD186x_GFRCR) );
 
 #ifdef SPECIALIX_TIMER
-	init_timer (&missed_irq_timer);
-	missed_irq_timer.function = missed_irq;
-	missed_irq_timer.data = (unsigned long) bp;
-	missed_irq_timer.expires = jiffies + sx_poll;
-	add_timer (&missed_irq_timer);
+	setup_timer(&missed_irq_timer, missed_irq, (unsigned long)bp);
+	mod_timer(&missed_irq_timer, jiffies + sx_poll);
 #endif
 
 	printk(KERN_INFO"sx%d: specialix IO8+ board detected at 0x%03x, IRQ %d, CD%d Rev. %c.\n",
@@ -2559,7 +2555,7 @@ static void __exit specialix_exit_module(void)
 		if (sx_board[i].flags & SX_BOARD_PRESENT)
 			sx_release_io_range(&sx_board[i]);
 #ifdef SPECIALIX_TIMER
-	del_timer (&missed_irq_timer);
+	del_timer_sync(&missed_irq_timer);
 #endif
 
 	func_exit();
diff --git a/drivers/char/synclink.c b/drivers/char/synclink.c
index d9db31c..97e2abe 100644
--- a/drivers/char/synclink.c
+++ b/drivers/char/synclink.c
@@ -1798,9 +1798,7 @@ static int startup(struct mgsl_struct * info)
 	
 	memset(&info->icount, 0, sizeof(info->icount));
 
-	init_timer(&info->tx_timer);
-	info->tx_timer.data = (unsigned long)info;
-	info->tx_timer.function = mgsl_tx_timeout;
+	setup_timer(&info->tx_timer, mgsl_tx_timeout, (unsigned long)info);
 	
 	/* Allocate and claim adapter resources */
 	retval = mgsl_claim_resources(info);
@@ -1851,7 +1849,7 @@ static void shutdown(struct mgsl_struct * info)
 	wake_up_interruptible(&info->status_event_wait_q);
 	wake_up_interruptible(&info->event_wait_q);
 
-	del_timer(&info->tx_timer);	
+	del_timer_sync(&info->tx_timer);	
 
 	if (info->xmit_buf) {
 		free_page((unsigned long) info->xmit_buf);
@@ -5710,8 +5708,8 @@ static void usc_start_transmitter( struct mgsl_struct *info )
 			
 			usc_TCmd( info, TCmd_SendFrame );
 			
-			info->tx_timer.expires = jiffies + msecs_to_jiffies(5000);
-			add_timer(&info->tx_timer);	
+			mod_timer(&info->tx_timer, jiffies +
+					msecs_to_jiffies(5000));	
 		}
 		info->tx_active = 1;
 	}
diff --git a/drivers/char/synclink_gt.c b/drivers/char/synclink_gt.c
index 52e3f69..d81c8fb 100644
--- a/drivers/char/synclink_gt.c
+++ b/drivers/char/synclink_gt.c
@@ -1825,8 +1825,7 @@ static void rx_async(struct slgt_info *info)
 		if (i < count) {
 			/* receive buffer not completed */
 			info->rbuf_index += i;
-			info->rx_timer.expires = jiffies + 1;
-			add_timer(&info->rx_timer);
+			mod_timer(&info->rx_timer, jiffies + 1);
 			break;
 		}
 
@@ -3340,13 +3339,8 @@ static struct slgt_info *alloc_dev(int adapter_num, int port_num, struct pci_dev
 		info->adapter_num = adapter_num;
 		info->port_num = port_num;
 
-		init_timer(&info->tx_timer);
-		info->tx_timer.data = (unsigned long)info;
-		info->tx_timer.function = tx_timeout;
-
-		init_timer(&info->rx_timer);
-		info->rx_timer.data = (unsigned long)info;
-		info->rx_timer.function = rx_timeout;
+		setup_timer(&info->tx_timer, tx_timeout, (unsigned long)info);
+		setup_timer(&info->rx_timer, rx_timeout, (unsigned long)info);
 
 		/* Copy configuration info to device instance data */
 		info->pdev = pdev;
@@ -3794,10 +3788,9 @@ static void tx_start(struct slgt_info *info)
 				}
 			}
 
-			if (info->params.mode == MGSL_MODE_HDLC) {
-				info->tx_timer.expires = jiffies + msecs_to_jiffies(5000);
-				add_timer(&info->tx_timer);
-			}
+			if (info->params.mode == MGSL_MODE_HDLC)
+				mod_timer(&info->tx_timer, jiffies +
+						msecs_to_jiffies(5000));
 		} else {
 			tdma_reset(info);
 			/* set 1st descriptor address */
diff --git a/drivers/char/synclinkmp.c b/drivers/char/synclinkmp.c
index c5ebfc0..29c0f85 100644
--- a/drivers/char/synclinkmp.c
+++ b/drivers/char/synclinkmp.c
@@ -2744,8 +2744,7 @@ static int startup(SLMP_INFO * info)
 
 	change_params(info);
 
-	info->status_timer.expires = jiffies + msecs_to_jiffies(10);
-	add_timer(&info->status_timer);
+	mod_timer(&info->status_timer, jiffies + msecs_to_jiffies(10));
 
 	if (info->tty)
 		clear_bit(TTY_IO_ERROR, &info->tty->flags);
@@ -3841,13 +3840,9 @@ static SLMP_INFO *alloc_dev(int adapter_num, int port_num, struct pci_dev *pdev)
 		info->bus_type = MGSL_BUS_TYPE_PCI;
 		info->irq_flags = IRQF_SHARED;
 
-		init_timer(&info->tx_timer);
-		info->tx_timer.data = (unsigned long)info;
-		info->tx_timer.function = tx_timeout;
-
-		init_timer(&info->status_timer);
-		info->status_timer.data = (unsigned long)info;
-		info->status_timer.function = status_timeout;
+		setup_timer(&info->tx_timer, tx_timeout, (unsigned long)info);
+		setup_timer(&info->status_timer, status_timeout,
+				(unsigned long)info);
 
 		/* Store the PCI9050 misc control register value because a flaw
 		 * in the PCI9050 prevents LCR registers from being read if
@@ -4291,8 +4286,8 @@ void tx_start(SLMP_INFO *info)
 			write_reg(info, TXDMA + DIR, 0x40);		/* enable Tx DMA interrupts (EOM) */
 			write_reg(info, TXDMA + DSR, 0xf2);		/* clear Tx DMA IRQs, enable Tx DMA */
 	
-			info->tx_timer.expires = jiffies + msecs_to_jiffies(5000);
-			add_timer(&info->tx_timer);
+			mod_timer(&info->tx_timer, jiffies +
+					msecs_to_jiffies(5000));
 		}
 		else {
 			tx_load_fifo(info);
@@ -5574,10 +5569,7 @@ void status_timeout(unsigned long context)
 	if (status)
 		isr_io_pin(info,status);
 
-	info->status_timer.data = (unsigned long)info;
-	info->status_timer.function = status_timeout;
-	info->status_timer.expires = jiffies + msecs_to_jiffies(10);
-	add_timer(&info->status_timer);
+	mod_timer(&info->status_timer, jiffies + msecs_to_jiffies(10));
 }
 
 
diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index 2564d4a..e5a254a 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -1106,9 +1106,8 @@ struct tpm_chip *tpm_register_hardware(struct device *dev, const struct tpm_vend
 
 	INIT_WORK(&chip->work, timeout_work);
 
-	init_timer(&chip->user_read_timer);
-	chip->user_read_timer.function = user_reader_timeout;
-	chip->user_read_timer.data = (unsigned long) chip;
+	setup_timer(&chip->user_read_timer, user_reader_timeout,
+			(unsigned long)chip);
 
 	memcpy(&chip->vendor, entry, sizeof(struct tpm_vendor_specific));
 
diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 77e9bfd..94ce3e7 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -210,7 +210,7 @@ static int scrollback_delta;
  */
 int (*console_blank_hook)(int);
 
-static struct timer_list console_timer;
+static DEFINE_TIMER(console_timer, blank_screen_t, 0, 0);
 static int blank_state;
 static int blank_timer_expired;
 enum {
@@ -2625,8 +2625,6 @@ static int __init con_init(void)
 	for (i = 0; i < MAX_NR_CONSOLES; i++)
 		con_driver_map[i] = conswitchp;
 
-	init_timer(&console_timer);
-	console_timer.function = blank_screen_t;
 	if (blankinterval) {
 		blank_state = blank_normal_wait;
 		mod_timer(&console_timer, jiffies + blankinterval);
diff --git a/drivers/char/watchdog/alim7101_wdt.c b/drivers/char/watchdog/alim7101_wdt.c
index e4644dc..67aed9f 100644
--- a/drivers/char/watchdog/alim7101_wdt.c
+++ b/drivers/char/watchdog/alim7101_wdt.c
@@ -69,7 +69,7 @@ module_param(use_gpio, int, 0);
 MODULE_PARM_DESC(use_gpio, "Use the gpio watchdog.  (required by old cobalt boards)");
 
 static void wdt_timer_ping(unsigned long);
-static struct timer_list timer;
+static DEFINE_TIMER(timer, wdt_timer_ping, 0, 1);
 static unsigned long next_heartbeat;
 static unsigned long wdt_is_open;
 static char wdt_expect_close;
@@ -108,8 +108,7 @@ static void wdt_timer_ping(unsigned long data)
 		printk(KERN_WARNING PFX "Heartbeat lost! Will not ping the watchdog\n");
 	}
 	/* Re-set the timer interval */
-	timer.expires = jiffies + WDT_INTERVAL;
-	add_timer(&timer);
+	mod_timer(&timer, jiffies + WDT_INTERVAL);
 }
 
 /*
@@ -147,9 +146,7 @@ static void wdt_startup(void)
 	wdt_change(WDT_ENABLE);
 
 	/* Start the timer */
-	timer.expires = jiffies + WDT_INTERVAL;
-	add_timer(&timer);
-
+	mod_timer(&timer, jiffies + WDT_INTERVAL);
 
 	printk(KERN_INFO PFX "Watchdog timer is now enabled.\n");
 }
@@ -380,10 +377,6 @@ static int __init alim7101_wdt_init(void)
 			timeout);
 	}
 
-	init_timer(&timer);
-	timer.function = wdt_timer_ping;
-	timer.data = 1;
-
 	rc = misc_register(&wdt_miscdev);
 	if (rc) {
 		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
diff --git a/drivers/char/watchdog/cpu5wdt.c b/drivers/char/watchdog/cpu5wdt.c
index 00bdabb..bcd7e36 100644
--- a/drivers/char/watchdog/cpu5wdt.c
+++ b/drivers/char/watchdog/cpu5wdt.c
@@ -80,10 +80,8 @@ static void cpu5wdt_trigger(unsigned long unused)
 	outb(1, port + CPU5WDT_TRIGGER_REG);
 
 	/* requeue?? */
-	if( cpu5wdt_device.queue && ticks ) {
-		cpu5wdt_device.timer.expires = jiffies + CPU5WDT_INTERVAL;
-		add_timer(&cpu5wdt_device.timer);
-	}
+	if (cpu5wdt_device.queue && ticks)
+		mod_timer(&cpu5wdt_device.timer, jiffies + CPU5WDT_INTERVAL);
 	else {
 		/* ticks doesn't matter anyway */
 		complete(&cpu5wdt_device.stop);
@@ -109,8 +107,7 @@ static void cpu5wdt_start(void)
 		outb(1, port + CPU5WDT_MODE_REG);
 		outb(0, port + CPU5WDT_RESET_REG);
 		outb(0, port + CPU5WDT_ENABLE_REG);
-		cpu5wdt_device.timer.expires = jiffies + CPU5WDT_INTERVAL;
-		add_timer(&cpu5wdt_device.timer);
+		mod_timer(&cpu5wdt_device.timer, jiffies + CPU5WDT_INTERVAL);
 	}
 	/* if process dies, counter is not decremented */
 	cpu5wdt_device.running++;
@@ -245,9 +242,7 @@ static int __devinit cpu5wdt_init(void)
 
 	clear_bit(0, &cpu5wdt_device.inuse);
 
-	init_timer(&cpu5wdt_device.timer);
-	cpu5wdt_device.timer.function = cpu5wdt_trigger;
-	cpu5wdt_device.timer.data = 0;
+	setup_timer(&cpu5wdt_device.timer, cpu5wdt_trigger, 0);
 
 	cpu5wdt_device.default_ticks = ticks;
 
diff --git a/drivers/char/watchdog/machzwd.c b/drivers/char/watchdog/machzwd.c
index 391998d..4a328ba 100644
--- a/drivers/char/watchdog/machzwd.c
+++ b/drivers/char/watchdog/machzwd.c
@@ -118,12 +118,14 @@ static int action = 0;
 module_param(action, int, 0);
 MODULE_PARM_DESC(action, "after watchdog resets, generate: 0 = RESET(*)  1 = SMI  2 = NMI  3 = SCI");
 
+static void zf_ping(unsigned long data);
+
 static int zf_action = GEN_RESET;
 static unsigned long zf_is_open;
 static char zf_expect_close;
 static spinlock_t zf_lock;
 static spinlock_t zf_port_lock;
-static struct timer_list zf_timer;
+static DEFINE_TIMER(zf_timer, zf_ping, 0, 0);
 static unsigned long next_heartbeat = 0;
 
 
@@ -220,9 +222,7 @@ static void zf_timer_on(void)
 	next_heartbeat = jiffies + ZF_USER_TIMEO;
 
 	/* start the timer for internal ping */
-	zf_timer.expires = jiffies + ZF_HW_TIMEO;
-
-	add_timer(&zf_timer);
+	mod_timer(&zf_timer, jiffies + ZF_HW_TIMEO);
 
 	/* start watchdog timer */
 	ctrl_reg = zf_get_control();
@@ -260,8 +260,7 @@ static void zf_ping(unsigned long data)
 		zf_set_control(ctrl_reg);
 		spin_unlock_irqrestore(&zf_port_lock, flags);
 
-		zf_timer.expires = jiffies + ZF_HW_TIMEO;
-		add_timer(&zf_timer);
+		mod_timer(&zf_timer, jiffies + ZF_HW_TIMEO);
 	}else{
 		printk(KERN_CRIT PFX ": I will reset your machine\n");
 	}
@@ -465,11 +464,6 @@ static int __init zf_init(void)
 	zf_set_status(0);
 	zf_set_control(0);
 
-	/* this is the timer that will do the hard work */
-	init_timer(&zf_timer);
-	zf_timer.function = zf_ping;
-	zf_timer.data = 0;
-
 	return 0;
 
 no_reboot:
diff --git a/drivers/char/watchdog/mixcomwd.c b/drivers/char/watchdog/mixcomwd.c
index 7e3308a..f35e284 100644
--- a/drivers/char/watchdog/mixcomwd.c
+++ b/drivers/char/watchdog/mixcomwd.c
@@ -56,11 +56,13 @@ static int mixcomwd_ioports[] = { 0x180, 0x280, 0x380, 0x000 };
 #define FLASHCOM_WATCHDOG_OFFSET 0x4
 #define FLASHCOM_ID 0x18
 
+static void mixcomwd_timerfun(unsigned long d);
+
 static unsigned long mixcomwd_opened; /* long req'd for setbit --RR */
 
 static int watchdog_port;
 static int mixcomwd_timer_alive;
-static DEFINE_TIMER(mixcomwd_timer, NULL, 0, 0);
+static DEFINE_TIMER(mixcomwd_timer, mixcomwd_timerfun, 0, 0);
 static char expect_close;
 
 static int nowayout = WATCHDOG_NOWAYOUT;
@@ -77,7 +79,7 @@ static void mixcomwd_timerfun(unsigned long d)
 {
 	mixcomwd_ping();
 
-	mod_timer(&mixcomwd_timer,jiffies+ 5*HZ);
+	mod_timer(&mixcomwd_timer, jiffies + 5 * HZ);
 }
 
 /*
@@ -114,12 +116,8 @@ static int mixcomwd_release(struct inode *inode, struct file *file)
 			printk(KERN_ERR "mixcomwd: release called while internal timer alive");
 			return -EBUSY;
 		}
-		init_timer(&mixcomwd_timer);
-		mixcomwd_timer.expires=jiffies + 5 * HZ;
-		mixcomwd_timer.function=mixcomwd_timerfun;
-		mixcomwd_timer.data=0;
 		mixcomwd_timer_alive=1;
-		add_timer(&mixcomwd_timer);
+		mod_timer(&mixcomwd_timer, jiffies + 5 * HZ);
 	} else {
 		printk(KERN_CRIT "mixcomwd: WDT device closed unexpectedly.  WDT will not stop!\n");
 	}
@@ -285,7 +283,7 @@ static void __exit mixcomwd_exit(void)
 		if(mixcomwd_timer_alive) {
 			printk(KERN_WARNING "mixcomwd: I quit now, hardware will"
 			       " probably reboot!\n");
-			del_timer(&mixcomwd_timer);
+			del_timer_sync(&mixcomwd_timer);
 			mixcomwd_timer_alive=0;
 		}
 	}
diff --git a/drivers/char/watchdog/pcwd.c b/drivers/char/watchdog/pcwd.c
index b056c3c..6e8b570 100644
--- a/drivers/char/watchdog/pcwd.c
+++ b/drivers/char/watchdog/pcwd.c
@@ -843,9 +843,7 @@ static int __devinit pcwatchdog_init(int base_addr)
 	/* clear the "card caused reboot" flag */
 	pcwd_clear_status();
 
-	init_timer(&pcwd_private.timer);
-	pcwd_private.timer.function = pcwd_timer_ping;
-	pcwd_private.timer.data = 0;
+	setup_timer(&pcwd_private.timer, pcwd_timer_ping, 0);
 
 	/*  Disable the board  */
 	pcwd_stop();
diff --git a/drivers/char/watchdog/sbc60xxwdt.c b/drivers/char/watchdog/sbc60xxwdt.c
index f5fb8cc..b628203 100644
--- a/drivers/char/watchdog/sbc60xxwdt.c
+++ b/drivers/char/watchdog/sbc60xxwdt.c
@@ -103,7 +103,7 @@ module_param(nowayout, int, 0);
 MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 static void wdt_timer_ping(unsigned long);
-static struct timer_list timer;
+static DEFINE_TIMER(timer, wdt_timer_ping, 0, 0);
 static unsigned long next_heartbeat;
 static unsigned long wdt_is_open;
 static char wdt_expect_close;
@@ -122,8 +122,7 @@ static void wdt_timer_ping(unsigned long data)
 		/* Ping the WDT by reading from wdt_start */
 		inb_p(wdt_start);
 		/* Re-set the timer interval */
-		timer.expires = jiffies + WDT_INTERVAL;
-		add_timer(&timer);
+		mod_timer(&timer, jiffies + WDT_INTERVAL);
 	} else {
 		printk(KERN_WARNING PFX "Heartbeat lost! Will not ping the watchdog\n");
 	}
@@ -138,8 +137,7 @@ static void wdt_startup(void)
 	next_heartbeat = jiffies + (timeout * HZ);
 
 	/* Start the timer */
-	timer.expires = jiffies + WDT_INTERVAL;
-	add_timer(&timer);
+	mod_timer(&timer, jiffies + WDT_INTERVAL);
 	printk(KERN_INFO PFX "Watchdog timer is now enabled.\n");
 }
 
@@ -363,10 +361,6 @@ static int __init sbc60xxwdt_init(void)
 		}
 	}
 
-	init_timer(&timer);
-	timer.function = wdt_timer_ping;
-	timer.data = 0;
-
 	rc = misc_register(&wdt_miscdev);
 	if (rc)
 	{
diff --git a/drivers/char/watchdog/sc520_wdt.c b/drivers/char/watchdog/sc520_wdt.c
index ecc7305..2676a43 100644
--- a/drivers/char/watchdog/sc520_wdt.c
+++ b/drivers/char/watchdog/sc520_wdt.c
@@ -121,7 +121,7 @@ MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" _
 static __u16 __iomem *wdtmrctl;
 
 static void wdt_timer_ping(unsigned long);
-static struct timer_list timer;
+static DEFINE_TIMER(timer, wdt_timer_ping, 0, 0);
 static unsigned long next_heartbeat;
 static unsigned long wdt_is_open;
 static char wdt_expect_close;
@@ -145,8 +145,7 @@ static void wdt_timer_ping(unsigned long data)
 		spin_unlock(&wdt_spinlock);
 
 		/* Re-set the timer interval */
-		timer.expires = jiffies + WDT_INTERVAL;
-		add_timer(&timer);
+		mod_timer(&timer, jiffies + WDT_INTERVAL);
 	} else {
 		printk(KERN_WARNING PFX "Heartbeat lost! Will not ping the watchdog\n");
 	}
@@ -179,8 +178,7 @@ static int wdt_startup(void)
 	next_heartbeat = jiffies + (timeout * HZ);
 
 	/* Start the timer */
-	timer.expires = jiffies + WDT_INTERVAL;
-	add_timer(&timer);
+	mod_timer(&timer, jiffies + WDT_INTERVAL);
 
 	/* Start the watchdog */
 	wdt_config(WDT_ENB | WDT_WRST_ENB | WDT_EXP_SEL_04);
@@ -389,10 +387,6 @@ static int __init sc520_wdt_init(void)
 
 	spin_lock_init(&wdt_spinlock);
 
-	init_timer(&timer);
-	timer.function = wdt_timer_ping;
-	timer.data = 0;
-
 	/* Check that the timeout value is within it's range ; if not reset to the default */
 	if (wdt_set_heartbeat(timeout)) {
 		wdt_set_heartbeat(WATCHDOG_TIMEOUT);
diff --git a/drivers/char/watchdog/shwdt.c b/drivers/char/watchdog/shwdt.c
index dc40362..cecbedd 100644
--- a/drivers/char/watchdog/shwdt.c
+++ b/drivers/char/watchdog/shwdt.c
@@ -65,10 +65,12 @@ static int clock_division_ratio = WTCSR_CKS_4096;
 
 #define next_ping_period(cks)	msecs_to_jiffies(cks - 4)
 
+static void sh_wdt_ping(unsigned long data);
+
 static unsigned long shwdt_is_open;
 static struct watchdog_info sh_wdt_info;
 static char shwdt_expect_close;
-static struct timer_list timer;
+static DEFINE_TIMER(timer, sh_wdt_ping, 0, 0);
 static unsigned long next_heartbeat;
 
 #define WATCHDOG_HEARTBEAT 30			/* 30 sec default heartbeat */
@@ -433,10 +435,6 @@ static int __init sh_wdt_init(void)
 		       "be 1<=x<=3600, using %d\n", heartbeat);
 	}
 
-	init_timer(&timer);
-	timer.function = sh_wdt_ping;
-	timer.data = 0;
-
 	rc = register_reboot_notifier(&sh_wdt_notifier);
 	if (unlikely(rc)) {
 		printk(KERN_ERR PFX "Can't register reboot notifier (err=%d)\n",
diff --git a/drivers/char/watchdog/w83877f_wdt.c b/drivers/char/watchdog/w83877f_wdt.c
index 7dcd80a..3c88fe1 100644
--- a/drivers/char/watchdog/w83877f_wdt.c
+++ b/drivers/char/watchdog/w83877f_wdt.c
@@ -90,7 +90,7 @@ module_param(nowayout, int, 0);
 MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 static void wdt_timer_ping(unsigned long);
-static struct timer_list timer;
+static DEFINE_TIMER(timer, wdt_timer_ping, 0, 0);
 static unsigned long next_heartbeat;
 static unsigned long wdt_is_open;
 static char wdt_expect_close;
@@ -114,8 +114,7 @@ static void wdt_timer_ping(unsigned long data)
 		inb_p(WDT_PING);
 
 		/* Re-set the timer interval */
-		timer.expires = jiffies + WDT_INTERVAL;
-		add_timer(&timer);
+		mod_timer(&timer, jiffies + WDT_INTERVAL);
 
 		spin_unlock(&wdt_spinlock);
 
@@ -155,8 +154,7 @@ static void wdt_startup(void)
 	next_heartbeat = jiffies + (timeout * HZ);
 
 	/* Start the timer */
-	timer.expires = jiffies + WDT_INTERVAL;
-	add_timer(&timer);
+	mod_timer(&timer, jiffies + WDT_INTERVAL);
 
 	wdt_change(WDT_ENABLE);
 
@@ -377,10 +375,6 @@ static int __init w83877f_wdt_init(void)
 		goto err_out_region1;
 	}
 
-	init_timer(&timer);
-	timer.function = wdt_timer_ping;
-	timer.data = 0;
-
 	rc = misc_register(&wdt_miscdev);
 	if (rc)
 	{
