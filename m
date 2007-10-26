Return-Path: <linux-kernel-owner+w=401wt.eu-S1763590AbXJZCQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763590AbXJZCQy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 22:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761882AbXJZCQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 22:16:45 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:43602 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761939AbXJZCQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 22:16:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:MIME-Version:Content-Type:Message-Id;
  b=o2qmUvPKINIoE1Ef/wNuKcHT4iAdWXyy+2IDrC6wozqPY/xHOtmpdE4WHKJz6VqDycSINPHBjG8/LmJ1YrvUGa2b+lG//Z89Y9o27I7kdb7ljOsEa3dweMUKFMNbjMDNB7M8i+yf2RdZMybV22tBFPlpt8bM0ffkA1f8t1uqof4=  ;
X-YMail-OSG: lnAT8TUVM1lVPvogclrLbjnZUX2bwkoTAJGiD49DNiaU5efJDk9g7qY9kSGZtdpHSenzhABw2g--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, paulus@samba.org,
       benh@kernel.crashing.org, shaggy@austin.ibm.com, adaplas@gmail.com,
       "Morton, Andrew" <akpm@linux-foundation.org>, xfs-masters@oss.sgi.com
Subject: [interesting] smattering of possible memory ordering bugs
Date: Fri, 26 Oct 2007 12:09:58 +1000
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_2xUIHPC0H+wszvM"
Message-Id: <200710261209.58519.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_2xUIHPC0H+wszvM
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

Just out of interest, I did a grep for files containing test_and_set_bit
as well as clear_bit (excluding obvious ones like include/asm-*/bitops.h).

Quite a few interesting things. There is a lot of stuff in drivers/* that
could be suspect, WRT memory barriers, including lots I didn't touch. Lot
of work. But forget that...

Some surprises with more obvious bugs, which I have added some cc's for.
powerpc seems to have an mmu context allocation bug, (and possible
improvement in hpte locking with the new bitops).

floppy is using a crazy open coded bit mutex, convert to regular mutex.

vt has something strange too.

fs-writeback could be made a little safer by properly closing the "critical"
section (the existing sections aren't really critical, but you never know
what the future holds ;))

jfs seems to be missing an obvious smp_mb__before_clear_bit (and a less
obvious smp_mb__after_clear_bit)

xfs seems to be missing smp_mb__before

Lots of code that allocates things (eg. msi interrupts) is suspicious. I'm
not exactly sure if these allocation bitmaps are actually used to protect
data structures or not...

I'll have to get round to preparing proper patches for these things if I
don't hear nacks...

--Boundary-00=_2xUIHPC0H+wszvM
Content-Type: text/x-diff;
  charset="us-ascii";
  name="bitops-fixups.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="bitops-fixups.patch"

---
 arch/arm/mach-davinci/gpio.c      |    4 ++--
 arch/arm/mach-imx/generic.c       |    4 ++--
 arch/arm/mach-iop13xx/msi.c       |    4 ++--
 arch/arm/mach-ns9xxx/gpio.c       |    4 ++--
 arch/avr32/mach-at32ap/pio.c      |    1 +
 arch/powerpc/mm/hash_native_64.c  |    5 ++---
 arch/ppc/xmon/start.c             |   20 +++++++++-----------
 block/ll_rw_blk.c                 |   20 +++++++++++++-------
 drivers/block/cciss.c             |    4 ++--
 drivers/block/cpqarray.c          |    4 ++--
 drivers/block/floppy.c            |   36 ++++++++----------------------------
 drivers/char/vt.c                 |    4 ++--
 drivers/net/ibm_newemac/mal.c     |    5 ++---
 drivers/net/s2io.c                |    8 ++++----
 drivers/usb/misc/phidgetservo.c   |    6 +++---
 fs/fs-writeback.c                 |    4 ++--
 fs/jfs/jfs_metapage.c             |    5 +++--
 fs/xfs/xfs_mount.c                |    4 ++--
 include/asm-powerpc/mmu_context.h |    4 ++--
 include/asm-ppc/mmu_context.h     |    4 ++--
 include/linux/aio.h               |    5 -----
 include/linux/interrupt.h         |    3 ++-
 include/linux/netdevice.h         |    5 ++---
 net/bluetooth/cmtp/core.c         |    4 ++--
 net/core/dev.c                    |    5 ++---
 26 files changed, 75 insertions(+), 98 deletions(-)

Index: linux-2.6/arch/arm/mach-davinci/gpio.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-davinci/gpio.c
+++ linux-2.6/arch/arm/mach-davinci/gpio.c
@@ -34,7 +34,7 @@ int gpio_request(unsigned gpio, const ch
 	if (gpio >= DAVINCI_N_GPIO)
 		return -EINVAL;
 
-	if (test_and_set_bit(gpio, gpio_in_use))
+	if (test_and_set_bit_lock(gpio, gpio_in_use))
 		return -EBUSY;
 
 	return 0;
@@ -46,7 +46,7 @@ void gpio_free(unsigned gpio)
 	if (gpio >= DAVINCI_N_GPIO)
 		return;
 
-	clear_bit(gpio, gpio_in_use);
+	clear_bit_unlock(gpio, gpio_in_use);
 }
 EXPORT_SYMBOL(gpio_free);
 
Index: linux-2.6/arch/arm/mach-imx/generic.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-imx/generic.c
+++ linux-2.6/arch/arm/mach-imx/generic.c
@@ -107,7 +107,7 @@ int imx_gpio_request(unsigned gpio, cons
 		return -EINVAL;
 	}
 
-	if(test_and_set_bit(gpio, imx_gpio_alloc_map)) {
+	if(test_and_set_bit_lock(gpio, imx_gpio_alloc_map)) {
 		printk(KERN_ERR "imx_gpio: GPIO %d already used. Allocation for \"%s\" failed\n",
 			gpio, label ? label : "?");
 		return -EBUSY;
@@ -123,7 +123,7 @@ void imx_gpio_free(unsigned gpio)
 	if(gpio >= (GPIO_PORT_MAX + 1) * 32)
 		return;
 
-	clear_bit(gpio, imx_gpio_alloc_map);
+	clear_bit_unlock(gpio, imx_gpio_alloc_map);
 }
 
 EXPORT_SYMBOL(imx_gpio_free);
Index: linux-2.6/arch/arm/mach-iop13xx/msi.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-iop13xx/msi.c
+++ linux-2.6/arch/arm/mach-iop13xx/msi.c
@@ -135,7 +135,7 @@ again:
 	if (irq > NR_IRQS)
 		return -ENOSPC;
 	/* test_and_set_bit operates on 32-bits at a time */
-	if (test_and_set_bit(pos, msi_irq_in_use))
+	if (test_and_set_bit_lock(pos, msi_irq_in_use))
 		goto again;
 
 	dynamic_irq_init(irq);
@@ -149,7 +149,7 @@ void destroy_irq(unsigned int irq)
 
 	dynamic_irq_cleanup(irq);
 
-	clear_bit(pos, msi_irq_in_use);
+	clear_bit_unlock(pos, msi_irq_in_use);
 }
 
 void arch_teardown_msi_irq(unsigned int irq)
Index: linux-2.6/arch/arm/mach-ns9xxx/gpio.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ns9xxx/gpio.c
+++ linux-2.6/arch/arm/mach-ns9xxx/gpio.c
@@ -85,7 +85,7 @@ static inline void __iomem *ns9xxx_gpio_
 int gpio_request(unsigned gpio, const char *label)
 {
 	if (likely(ns9xxx_valid_gpio(gpio)))
-		return test_and_set_bit(gpio, gpiores) ? -EBUSY : 0;
+		return test_and_set_bit_lock(gpio, gpiores) ? -EBUSY : 0;
 	else
 		return -EINVAL;
 }
@@ -93,7 +93,7 @@ EXPORT_SYMBOL(gpio_request);
 
 void gpio_free(unsigned gpio)
 {
-	clear_bit(gpio, gpiores);
+	clear_bit_unlock(gpio, gpiores);
 	return;
 }
 EXPORT_SYMBOL(gpio_free);
Index: linux-2.6/arch/avr32/mach-at32ap/pio.c
===================================================================
--- linux-2.6.orig/arch/avr32/mach-at32ap/pio.c
+++ linux-2.6/arch/avr32/mach-at32ap/pio.c
@@ -131,6 +131,7 @@ void __init at32_select_gpio(unsigned in
 	pio_writel(pio, PER, mask);
 
 	/* gpio_request now allowed */
+	/* XXX: does this require memory barrier to close critical section? */
 	clear_bit(pin_index, &pio->gpio_mask);
 
 	return;
Index: linux-2.6/arch/powerpc/mm/hash_native_64.c
===================================================================
--- linux-2.6.orig/arch/powerpc/mm/hash_native_64.c
+++ linux-2.6/arch/powerpc/mm/hash_native_64.c
@@ -113,7 +113,7 @@ static inline void native_lock_hpte(stru
 	unsigned long *word = &hptep->v;
 
 	while (1) {
-		if (!test_and_set_bit(HPTE_LOCK_BIT, word))
+		if (!test_and_set_bit_lock(HPTE_LOCK_BIT, word))
 			break;
 		while(test_bit(HPTE_LOCK_BIT, word))
 			cpu_relax();
@@ -124,8 +124,7 @@ static inline void native_unlock_hpte(st
 {
 	unsigned long *word = &hptep->v;
 
-	asm volatile("lwsync":::"memory");
-	clear_bit(HPTE_LOCK_BIT, word);
+	clear_bit_unlock(HPTE_LOCK_BIT, word);
 }
 
 static long native_hpte_insert(unsigned long hpte_group, unsigned long va,
Index: linux-2.6/arch/ppc/xmon/start.c
===================================================================
--- linux-2.6.orig/arch/ppc/xmon/start.c
+++ linux-2.6/arch/ppc/xmon/start.c
@@ -92,16 +92,15 @@ xmon_write(void *handle, void *ptr, int 
 {
 	char *p = ptr;
 	int i, c, ct;
-
-#ifdef CONFIG_SMP
-	static unsigned long xmon_write_lock;
-	int lock_wait = 1000000;
+	static DEFINE_SPINLOCK(xmon_write_lock);
+	int lock_udelay = 10000;
 	int locked;
 
-	while ((locked = test_and_set_bit(0, &xmon_write_lock)) != 0)
-		if (--lock_wait == 0)
+	while (!(locked = spin_trylock(&xmon_write_lock))) {
+		udelay(1);
+		if (--lock_udelay == 0)
 			break;
-#endif
+	}
 
 	if (!scc_initialized)
 		xmon_init_scc();
@@ -122,10 +121,9 @@ xmon_write(void *handle, void *ptr, int 
 		eieio();
 	}
 
-#ifdef CONFIG_SMP
-	if (!locked)
-		clear_bit(0, &xmon_write_lock);
-#endif
+	if (locked)
+		spin_unlock(&xmon_write_lock);
+
 	return nb;
 }
 
Index: linux-2.6/block/ll_rw_blk.c
===================================================================
--- linux-2.6.orig/block/ll_rw_blk.c
+++ linux-2.6/block/ll_rw_blk.c
@@ -1574,10 +1574,12 @@ void blk_plug_device(struct request_queu
 	if (blk_queue_stopped(q))
 		return;
 
-	if (!test_and_set_bit(QUEUE_FLAG_PLUGGED, &q->queue_flags)) {
-		mod_timer(&q->unplug_timer, jiffies + q->unplug_delay);
-		blk_add_trace_generic(q, NULL, 0, BLK_TA_PLUG);
-	}
+	if (test_bit(QUEUE_FLAG_PLUGGED, &q->queue_flags))
+		return;
+
+	set_bit(QUEUE_FLAG_PLUGGED, &q->queue_flags);
+	mod_timer(&q->unplug_timer, jiffies + q->unplug_delay);
+	blk_add_trace_generic(q, NULL, 0, BLK_TA_PLUG);
 }
 
 EXPORT_SYMBOL(blk_plug_device);
@@ -1590,10 +1592,12 @@ int blk_remove_plug(struct request_queue
 {
 	WARN_ON(!irqs_disabled());
 
-	if (!test_and_clear_bit(QUEUE_FLAG_PLUGGED, &q->queue_flags))
+	if (!test_bit(QUEUE_FLAG_PLUGGED, &q->queue_flags))
 		return 0;
 
+	clear_bit(QUEUE_FLAG_PLUGGED, &q->queue_flags);
 	del_timer(&q->unplug_timer);
+
 	return 1;
 }
 
@@ -1689,7 +1693,8 @@ void blk_start_queue(struct request_queu
 	 * one level of recursion is ok and is much faster than kicking
 	 * the unplug handling
 	 */
-	if (!test_and_set_bit(QUEUE_FLAG_REENTER, &q->queue_flags)) {
+	if (!test_bit(QUEUE_FLAG_REENTER, &q->queue_flags)) {
+		set_bit(QUEUE_FLAG_REENTER, &q->queue_flags);
 		q->request_fn(q);
 		clear_bit(QUEUE_FLAG_REENTER, &q->queue_flags);
 	} else {
@@ -1757,7 +1762,8 @@ void blk_run_queue(struct request_queue 
 	 * handling reinvoke the handler shortly if we already got there.
 	 */
 	if (!elv_queue_empty(q)) {
-		if (!test_and_set_bit(QUEUE_FLAG_REENTER, &q->queue_flags)) {
+		if (!test_bit(QUEUE_FLAG_REENTER, &q->queue_flags)) {
+			set_bit(QUEUE_FLAG_REENTER, &q->queue_flags);
 			q->request_fn(q);
 			clear_bit(QUEUE_FLAG_REENTER, &q->queue_flags);
 		} else {
Index: linux-2.6/drivers/block/cciss.c
===================================================================
--- linux-2.6.orig/drivers/block/cciss.c
+++ linux-2.6/drivers/block/cciss.c
@@ -416,7 +416,7 @@ static CommandList_struct *cmd_alloc(ctl
 			i = find_first_zero_bit(h->cmd_pool_bits, h->nr_cmds);
 			if (i == h->nr_cmds)
 				return NULL;
-		} while (test_and_set_bit
+		} while (test_and_set_bit_lock
 			 (i & (BITS_PER_LONG - 1),
 			  h->cmd_pool_bits + (i / BITS_PER_LONG)) != 0);
 #ifdef CCISS_DEBUG
@@ -462,7 +462,7 @@ static void cmd_free(ctlr_info_t *h, Com
 				    c, (dma_addr_t) c->busaddr);
 	} else {
 		i = c - h->cmd_pool;
-		clear_bit(i & (BITS_PER_LONG - 1),
+		clear_bit_unlock(i & (BITS_PER_LONG - 1),
 			  h->cmd_pool_bits + (i / BITS_PER_LONG));
 		h->nr_frees++;
 	}
Index: linux-2.6/drivers/block/cpqarray.c
===================================================================
--- linux-2.6.orig/drivers/block/cpqarray.c
+++ linux-2.6/drivers/block/cpqarray.c
@@ -1378,7 +1378,7 @@ static cmdlist_t * cmd_alloc(ctlr_info_t
 			i = find_first_zero_bit(h->cmd_pool_bits, NR_CMDS);
 			if (i == NR_CMDS)
 				return NULL;
-		} while(test_and_set_bit(i&(BITS_PER_LONG-1), h->cmd_pool_bits+(i/BITS_PER_LONG)) != 0);
+		} while(test_and_set_bit_lock(i&(BITS_PER_LONG-1), h->cmd_pool_bits+(i/BITS_PER_LONG)) != 0);
 		c = h->cmd_pool + i;
 		cmd_dhandle = h->cmd_pool_dhandle + i*sizeof(cmdlist_t);
 		h->nr_allocs++;
@@ -1398,7 +1398,7 @@ static void cmd_free(ctlr_info_t *h, cmd
 			c->busaddr);
 	} else {
 		i = c - h->cmd_pool;
-		clear_bit(i&(BITS_PER_LONG-1), h->cmd_pool_bits+(i/BITS_PER_LONG));
+		clear_bit_unlock(i&(BITS_PER_LONG-1), h->cmd_pool_bits+(i/BITS_PER_LONG));
 		h->nr_frees++;
 	}
 }
Index: linux-2.6/drivers/block/floppy.c
===================================================================
--- linux-2.6.orig/drivers/block/floppy.c
+++ linux-2.6/drivers/block/floppy.c
@@ -503,8 +503,7 @@ static int probing;
 #define FD_COMMAND_OKAY 3
 
 static volatile int command_status = FD_COMMAND_NONE;
-static unsigned long fdc_busy;
-static DECLARE_WAIT_QUEUE_HEAD(fdc_wait);
+static DEFINE_MUTEX(fdc_busy);
 static DECLARE_WAIT_QUEUE_HEAD(command_done);
 
 #define NO_SIGNAL (!interruptible || !signal_pending(current))
@@ -631,7 +630,7 @@ static const char *timeout_message;
 static void is_alive(const char *message)
 {
 	/* this routine checks whether the floppy driver is "alive" */
-	if (test_bit(0, &fdc_busy) && command_status < 2
+	if (mutex_is_locked(&fdc_busy) && command_status < 2
 	    && !timer_pending(&fd_timeout)) {
 		DPRINT("timeout handler died: %s\n", message);
 	}
@@ -871,28 +870,10 @@ static int _lock_fdc(int drive, int inte
 		return -1;
 	}
 
-	if (test_and_set_bit(0, &fdc_busy)) {
-		DECLARE_WAITQUEUE(wait, current);
-		add_wait_queue(&fdc_wait, &wait);
-
-		for (;;) {
-			set_current_state(TASK_INTERRUPTIBLE);
-
-			if (!test_and_set_bit(0, &fdc_busy))
-				break;
-
-			schedule();
-
-			if (!NO_SIGNAL) {
-				remove_wait_queue(&fdc_wait, &wait);
-				return -EINTR;
-			}
-		}
+	if (mutex_lock_interruptible(&fdc_busy) == -EINTR)
+		return -EINTR;
+	flush_scheduled_work();
 
-		set_current_state(TASK_RUNNING);
-		remove_wait_queue(&fdc_wait, &wait);
-		flush_scheduled_work();
-	}
 	command_status = FD_COMMAND_NONE;
 
 	__reschedule_timeout(drive, "lock fdc", 0);
@@ -921,11 +902,10 @@ static inline void unlock_fdc(void)
 	spin_lock_irqsave(&floppy_lock, flags);
 	del_timer(&fd_timeout);
 	cont = NULL;
-	clear_bit(0, &fdc_busy);
+	mutex_unlock(&fdc_busy);
 	if (elv_next_request(floppy_queue))
 		do_fd_request(floppy_queue);
 	spin_unlock_irqrestore(&floppy_lock, flags);
-	wake_up(&fdc_wait);
 }
 
 /* switches the motor off after a given timeout */
@@ -1873,7 +1853,7 @@ static void show_floppy(void)
 #endif
 
 	printk("status=%x\n", fd_inb(FD_STATUS));
-	printk("fdc_busy=%lu\n", fdc_busy);
+	printk("fdc_busy=%lu\n", mutex_is_locked(&fdc_busy));
 	if (do_floppy)
 		printk("do_floppy=%p\n", do_floppy);
 	if (work_pending(&floppy_work))
@@ -2987,7 +2967,7 @@ static void do_fd_request(struct request
 		       current_req->cmd_type, current_req->cmd_flags);
 		return;
 	}
-	if (test_bit(0, &fdc_busy)) {
+	if (mutex_is_locked(&fdc_busy)) {
 		/* fdc busy, this new request will be treated when the
 		   current one is done */
 		is_alive("do fd request, old request running");
Index: linux-2.6/drivers/char/vt.c
===================================================================
--- linux-2.6.orig/drivers/char/vt.c
+++ linux-2.6/drivers/char/vt.c
@@ -2406,7 +2406,7 @@ static void vt_console_print(struct cons
 	ushort myx;
 
 	/* console busy or not yet initialized */
-	if (!printable || test_and_set_bit(0, &printing))
+	if (!printable || test_and_set_bit_lock(0, &printing))
 		return;
 
 	if (kmsg_redirect && vc_cons_allocated(kmsg_redirect - 1))
@@ -2481,7 +2481,7 @@ static void vt_console_print(struct cons
 	notify_update(vc);
 
 quit:
-	clear_bit(0, &printing);
+	clear_bit_unlock(0, &printing);
 }
 
 static struct tty_driver *vt_console_device(struct console *c, int *index)
Index: linux-2.6/drivers/net/ibm_newemac/mal.c
===================================================================
--- linux-2.6.orig/drivers/net/ibm_newemac/mal.c
+++ linux-2.6/drivers/net/ibm_newemac/mal.c
@@ -318,7 +318,7 @@ static irqreturn_t mal_rxde(int irq, voi
 void mal_poll_disable(struct mal_instance *mal, struct mal_commac *commac)
 {
 	/* Spinlock-type semantics: only one caller disable poll at a time */
-	while (test_and_set_bit(MAL_COMMAC_POLL_DISABLED, &commac->flags))
+	while (test_and_set_bit_lock(MAL_COMMAC_POLL_DISABLED, &commac->flags))
 		msleep(1);
 
 	/* Synchronize with the MAL NAPI poller */
@@ -327,8 +327,7 @@ void mal_poll_disable(struct mal_instanc
 
 void mal_poll_enable(struct mal_instance *mal, struct mal_commac *commac)
 {
-	smp_wmb();
-	clear_bit(MAL_COMMAC_POLL_DISABLED, &commac->flags);
+	clear_bit_unlock(MAL_COMMAC_POLL_DISABLED, &commac->flags);
 
 	/* Feels better to trigger a poll here to catch up with events that
 	 * may have happened on this channel while disabled. It will most
Index: linux-2.6/drivers/net/s2io.c
===================================================================
--- linux-2.6.orig/drivers/net/s2io.c
+++ linux-2.6/drivers/net/s2io.c
@@ -6429,7 +6429,7 @@ static void s2io_set_link(struct work_st
 	if (!netif_running(dev))
 		goto out_unlock;
 
-	if (test_and_set_bit(__S2IO_STATE_LINK_TASK, &(nic->state))) {
+	if (test_and_set_bit_lock(__S2IO_STATE_LINK_TASK, &(nic->state))) {
 		/* The card is being reset, no point doing anything */
 		goto out_unlock;
 	}
@@ -6485,7 +6485,7 @@ static void s2io_set_link(struct work_st
 		writeq(val64, &bar0->adapter_control);
 		s2io_link(nic, LINK_DOWN);
 	}
-	clear_bit(__S2IO_STATE_LINK_TASK, &(nic->state));
+	clear_bit_unlock(__S2IO_STATE_LINK_TASK, &(nic->state));
 
 out_unlock:
 	rtnl_unlock();
@@ -6787,7 +6787,7 @@ static void do_s2io_card_down(struct s2i
 
 	del_timer_sync(&sp->alarm_timer);
 	/* If s2io_set_link task is executing, wait till it completes. */
-	while (test_and_set_bit(__S2IO_STATE_LINK_TASK, &(sp->state))) {
+	while (test_and_set_bit_lock(__S2IO_STATE_LINK_TASK, &(sp->state))) {
 		msleep(50);
 	}
 	clear_bit(__S2IO_STATE_CARD_UP, &sp->state);
@@ -6841,7 +6841,7 @@ static void do_s2io_card_down(struct s2i
 	free_rx_buffers(sp);
 	spin_unlock_irqrestore(&sp->rx_lock, flags);
 
-	clear_bit(__S2IO_STATE_LINK_TASK, &(sp->state));
+	clear_bit_unlock(__S2IO_STATE_LINK_TASK, &(sp->state));
 }
 
 static void s2io_card_down(struct s2io_nic * sp)
Index: linux-2.6/drivers/usb/misc/phidgetservo.c
===================================================================
--- linux-2.6.orig/drivers/usb/misc/phidgetservo.c
+++ linux-2.6/drivers/usb/misc/phidgetservo.c
@@ -271,7 +271,7 @@ servo_probe(struct usb_interface *interf
 
         do {
                 bit = find_first_zero_bit(&device_no, sizeof(device_no));
-                value = test_and_set_bit(bit, &device_no);
+                value = test_and_set_bit_lock(bit, &device_no);
         } while (value);
 	dev->dev_no = bit;
 
@@ -308,7 +308,7 @@ out:
 		if (dev->dev)
 			device_unregister(dev->dev);
 		if (dev->dev_no >= 0)
-			clear_bit(dev->dev_no, &device_no);
+			clear_bit_unlock(dev->dev_no, &device_no);
 
 		kfree(dev);
 	}
@@ -339,7 +339,7 @@ servo_disconnect(struct usb_interface *i
 	dev_info(&interface->dev, "USB %d-Motor PhidgetServo v%d.0 detached\n",
 		servo_count, dev->type & SERVO_VERSION_30 ? 3 : 2);
 
-	clear_bit(dev->dev_no, &device_no);
+	clear_bit_unlock(dev->dev_no, &device_no);
 	kfree(dev);
 }
 
Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c
+++ linux-2.6/fs/fs-writeback.c
@@ -766,7 +766,7 @@ EXPORT_SYMBOL(generic_osync_inode);
  */
 int writeback_acquire(struct backing_dev_info *bdi)
 {
-	return !test_and_set_bit(BDI_pdflush, &bdi->state);
+	return !test_and_set_bit_lock(BDI_pdflush, &bdi->state);
 }
 
 /**
@@ -787,5 +787,5 @@ int writeback_in_progress(struct backing
 void writeback_release(struct backing_dev_info *bdi)
 {
 	BUG_ON(!writeback_in_progress(bdi));
-	clear_bit(BDI_pdflush, &bdi->state);
+	clear_bit_unlock(BDI_pdflush, &bdi->state);
 }
Index: linux-2.6/fs/jfs/jfs_metapage.c
===================================================================
--- linux-2.6.orig/fs/jfs/jfs_metapage.c
+++ linux-2.6/fs/jfs/jfs_metapage.c
@@ -39,11 +39,12 @@ static struct {
 #endif
 
 #define metapage_locked(mp) test_bit(META_locked, &(mp)->flag)
-#define trylock_metapage(mp) test_and_set_bit(META_locked, &(mp)->flag)
+#define trylock_metapage(mp) test_and_set_bit_lock(META_locked, &(mp)->flag)
 
 static inline void unlock_metapage(struct metapage *mp)
 {
-	clear_bit(META_locked, &mp->flag);
+	clear_bit_unlock(META_locked, &mp->flag);
+	smp_mb__after_clear_bit();
 	wake_up(&mp->wait);
 }
 
Index: linux-2.6/fs/xfs/xfs_mount.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_mount.c
+++ linux-2.6/fs/xfs/xfs_mount.c
@@ -2035,7 +2035,7 @@ STATIC_INLINE void
 xfs_icsb_lock_cntr(
 	xfs_icsb_cnts_t	*icsbp)
 {
-	while (test_and_set_bit(XFS_ICSB_FLAG_LOCK, &icsbp->icsb_flags)) {
+	while (test_and_set_bit_lock(XFS_ICSB_FLAG_LOCK, &icsbp->icsb_flags)) {
 		ndelay(1000);
 	}
 }
@@ -2044,7 +2044,7 @@ STATIC_INLINE void
 xfs_icsb_unlock_cntr(
 	xfs_icsb_cnts_t	*icsbp)
 {
-	clear_bit(XFS_ICSB_FLAG_LOCK, &icsbp->icsb_flags);
+	clear_bit_unlock(XFS_ICSB_FLAG_LOCK, &icsbp->icsb_flags);
 }
 
 
Index: linux-2.6/include/asm-powerpc/mmu_context.h
===================================================================
--- linux-2.6.orig/include/asm-powerpc/mmu_context.h
+++ linux-2.6/include/asm-powerpc/mmu_context.h
@@ -129,7 +129,7 @@ static inline void get_mmu_context(struc
 		steal_context();
 #endif
 	ctx = next_mmu_context;
-	while (test_and_set_bit(ctx, context_map)) {
+	while (test_and_set_bit_lock(ctx, context_map)) {
 		ctx = find_next_zero_bit(context_map, LAST_CONTEXT+1, ctx);
 		if (ctx > LAST_CONTEXT)
 			ctx = 0;
@@ -158,7 +158,7 @@ static inline void destroy_context(struc
 {
 	preempt_disable();
 	if (mm->context.id != NO_CONTEXT) {
-		clear_bit(mm->context.id, context_map);
+		clear_bit_unlock(mm->context.id, context_map);
 		mm->context.id = NO_CONTEXT;
 #ifdef FEW_CONTEXTS
 		atomic_inc(&nr_free_contexts);
Index: linux-2.6/include/asm-ppc/mmu_context.h
===================================================================
--- linux-2.6.orig/include/asm-ppc/mmu_context.h
+++ linux-2.6/include/asm-ppc/mmu_context.h
@@ -128,7 +128,7 @@ static inline void get_mmu_context(struc
 		steal_context();
 #endif
 	ctx = next_mmu_context;
-	while (test_and_set_bit(ctx, context_map)) {
+	while (test_and_set_bit_lock(ctx, context_map)) {
 		ctx = find_next_zero_bit(context_map, LAST_CONTEXT+1, ctx);
 		if (ctx > LAST_CONTEXT)
 			ctx = 0;
@@ -157,7 +157,7 @@ static inline void destroy_context(struc
 {
 	preempt_disable();
 	if (mm->context.id != NO_CONTEXT) {
-		clear_bit(mm->context.id, context_map);
+		clear_bit_unlock(mm->context.id, context_map);
 		mm->context.id = NO_CONTEXT;
 #ifdef FEW_CONTEXTS
 		atomic_inc(&nr_free_contexts);
Index: linux-2.6/include/linux/aio.h
===================================================================
--- linux-2.6.orig/include/linux/aio.h
+++ linux-2.6/include/linux/aio.h
@@ -31,22 +31,17 @@ struct kioctx;
  * for now it's unused and we probably don't want modules to even
  * think they can use it.
  */
-/* #define KIF_LOCKED		0 */
 #define KIF_KICKED		1
 #define KIF_CANCELLED		2
 
-#define kiocbTryLock(iocb)	test_and_set_bit(KIF_LOCKED, &(iocb)->ki_flags)
 #define kiocbTryKick(iocb)	test_and_set_bit(KIF_KICKED, &(iocb)->ki_flags)
 
-#define kiocbSetLocked(iocb)	set_bit(KIF_LOCKED, &(iocb)->ki_flags)
 #define kiocbSetKicked(iocb)	set_bit(KIF_KICKED, &(iocb)->ki_flags)
 #define kiocbSetCancelled(iocb)	set_bit(KIF_CANCELLED, &(iocb)->ki_flags)
 
-#define kiocbClearLocked(iocb)	clear_bit(KIF_LOCKED, &(iocb)->ki_flags)
 #define kiocbClearKicked(iocb)	clear_bit(KIF_KICKED, &(iocb)->ki_flags)
 #define kiocbClearCancelled(iocb)	clear_bit(KIF_CANCELLED, &(iocb)->ki_flags)
 
-#define kiocbIsLocked(iocb)	test_bit(KIF_LOCKED, &(iocb)->ki_flags)
 #define kiocbIsKicked(iocb)	test_bit(KIF_KICKED, &(iocb)->ki_flags)
 #define kiocbIsCancelled(iocb)	test_bit(KIF_CANCELLED, &(iocb)->ki_flags)
 
Index: linux-2.6/include/linux/interrupt.h
===================================================================
--- linux-2.6.orig/include/linux/interrupt.h
+++ linux-2.6/include/linux/interrupt.h
@@ -331,7 +331,8 @@ static inline void tasklet_unlock(struct
 
 static inline void tasklet_unlock_wait(struct tasklet_struct *t)
 {
-	while (test_bit(TASKLET_STATE_RUN, &(t)->state)) { barrier(); }
+	while (test_bit(TASKLET_STATE_RUN, &(t)->state))
+		cpu_relax();
 }
 #else
 #define tasklet_trylock(t) 1
Index: linux-2.6/include/linux/netdevice.h
===================================================================
--- linux-2.6.orig/include/linux/netdevice.h
+++ linux-2.6/include/linux/netdevice.h
@@ -389,7 +389,7 @@ static inline void napi_complete(struct 
  */
 static inline void napi_disable(struct napi_struct *n)
 {
-	while (test_and_set_bit(NAPI_STATE_SCHED, &n->state))
+	while (test_and_set_bit_lock(NAPI_STATE_SCHED, &n->state))
 		msleep_interruptible(1);
 }
 
@@ -403,8 +403,7 @@ static inline void napi_disable(struct n
 static inline void napi_enable(struct napi_struct *n)
 {
 	BUG_ON(!test_bit(NAPI_STATE_SCHED, &n->state));
-	smp_mb__before_clear_bit();
-	clear_bit(NAPI_STATE_SCHED, &n->state);
+	clear_bit_unlock(NAPI_STATE_SCHED, &n->state);
 }
 
 #ifdef CONFIG_SMP
Index: linux-2.6/net/bluetooth/cmtp/core.c
===================================================================
--- linux-2.6.orig/net/bluetooth/cmtp/core.c
+++ linux-2.6/net/bluetooth/cmtp/core.c
@@ -97,7 +97,7 @@ static inline int cmtp_alloc_block_id(st
 	int i, id = -1;
 
 	for (i = 0; i < 16; i++)
-		if (!test_and_set_bit(i, &session->blockids)) {
+		if (!test_and_set_bit_lock(i, &session->blockids)) {
 			id = i;
 			break;
 		}
@@ -107,7 +107,7 @@ static inline int cmtp_alloc_block_id(st
 
 static inline void cmtp_free_block_id(struct cmtp_session *session, int id)
 {
-	clear_bit(id, &session->blockids);
+	clear_bit_unlock(id, &session->blockids);
 }
 
 static inline void cmtp_add_msgpart(struct cmtp_session *session, int id, const unsigned char *buf, int count)
Index: linux-2.6/net/core/dev.c
===================================================================
--- linux-2.6.orig/net/core/dev.c
+++ linux-2.6/net/core/dev.c
@@ -1275,7 +1275,7 @@ static void dev_queue_xmit_nit(struct sk
 
 void __netif_schedule(struct net_device *dev)
 {
-	if (!test_and_set_bit(__LINK_STATE_SCHED, &dev->state)) {
+	if (!test_and_set_bit_lock(__LINK_STATE_SCHED, &dev->state)) {
 		unsigned long flags;
 		struct softnet_data *sd;
 
@@ -1859,8 +1859,7 @@ static void net_tx_action(struct softirq
 			struct net_device *dev = head;
 			head = head->next_sched;
 
-			smp_mb__before_clear_bit();
-			clear_bit(__LINK_STATE_SCHED, &dev->state);
+			clear_bit_unlock(__LINK_STATE_SCHED, &dev->state);
 
 			if (spin_trylock(&dev->queue_lock)) {
 				qdisc_run(dev);

--Boundary-00=_2xUIHPC0H+wszvM--
