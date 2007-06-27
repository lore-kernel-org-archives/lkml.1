Return-Path: <linux-kernel-owner+w=401wt.eu-S1763589AbXF0Tqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763589AbXF0Tqo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 15:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755669AbXF0Tnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 15:43:47 -0400
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:43360 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759101AbXF0Tnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 15:43:39 -0400
Message-Id: <20070627194328.225186152@goodmis.org>
References: <20070627193633.025544061@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 27 Jun 2007 15:36:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, kuznet@ms2.inr.ac.ru,
       Jonathan Corbet <corbet@lwn.net>,
       Arjan van de Ven <arjan@infradead.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [RFC PATCH 7/8] remove DECLARE_TASKLET API
Content-Disposition: inline; filename=remove-declare-tasklet.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces the DECLARE_TASKLET for tasklet_init.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


Index: linux-2.6-test/arch/cris/arch-v32/drivers/cryptocop.c
===================================================================
--- linux-2.6-test.orig/arch/cris/arch-v32/drivers/cryptocop.c
+++ linux-2.6-test/arch/cris/arch-v32/drivers/cryptocop.c
@@ -1849,7 +1849,7 @@ static int cryptocop_job_queue_insert(cr
 }
 
 static void cryptocop_do_tasklet(unsigned long unused);
-DECLARE_TASKLET (cryptocop_tasklet, cryptocop_do_tasklet, 0);
+struct tasklet_struct cryptocop_tasklet;
 
 static void cryptocop_do_tasklet(unsigned long unused)
 {
@@ -3467,6 +3467,8 @@ static int init_stream_coprocessor(void)
 
 	printk("ETRAX FS stream co-processor driver v0.01, (c) 2003 Axis Communications AB\n");
 
+	tasklet_init(&cryptocop_tasklet, cryptocop_do_tasklet, 0);
+
 	err = register_chrdev(CRYPTOCOP_MAJOR, cryptocop_name, &cryptocop_fops);
 	if (err < 0) {
 		printk(KERN_ERR "stream co-processor: could not get major number.\n");
Index: linux-2.6-test/arch/ia64/hp/sim/simscsi.c
===================================================================
--- linux-2.6-test.orig/arch/ia64/hp/sim/simscsi.c
+++ linux-2.6-test/arch/ia64/hp/sim/simscsi.c
@@ -47,7 +47,7 @@
 static struct Scsi_Host *host;
 
 static void simscsi_interrupt (unsigned long val);
-static DECLARE_TASKLET(simscsi_tasklet, simscsi_interrupt, 0);
+static struct tasklet_struct simscsi_tasklet;
 
 struct disk_req {
 	unsigned long addr;
@@ -404,6 +404,8 @@ simscsi_init(void)
 {
 	int error;
 
+	tasklet_init(&simscsi_tasklet, simscsi_interrupt, 0);
+
 	host = scsi_host_alloc(&driver_template, 0);
 	if (!host)
 		return -ENOMEM;
Index: linux-2.6-test/arch/mips/lasat/picvue_proc.c
===================================================================
--- linux-2.6-test.orig/arch/mips/lasat/picvue_proc.c
+++ linux-2.6-test/arch/mips/lasat/picvue_proc.c
@@ -33,7 +33,7 @@ static void pvc_display(unsigned long da
 		pvc_write_string(pvc_lines[i], 0, i);
 }
 
-static DECLARE_TASKLET(pvc_display_tasklet, &pvc_display, 0);
+static struct tasklet_struct pvc_display_tasklet;
 
 static int pvc_proc_read_line(char *page, char **start,
                              off_t off, int count,
@@ -172,6 +172,8 @@ static int __init pvc_proc_init(void)
 	proc_entry->write_proc = pvc_proc_write_scroll;
 	proc_entry->read_proc = pvc_proc_read_scroll;
 
+	tasklet_init(&pvc_display_tasklet, &pvc_display, 0);
+
 	init_timer(&timer);
 	timer.function = pvc_proc_timerfunc;
 
Index: linux-2.6-test/drivers/cdrom/cm206.c
===================================================================
--- linux-2.6-test.orig/drivers/cdrom/cm206.c
+++ linux-2.6-test/drivers/cdrom/cm206.c
@@ -740,8 +740,6 @@ static void cm206_tasklet_func(unsigned 
 	}
 }
 
-static DECLARE_TASKLET(cm206_tasklet, cm206_tasklet_func, 0);
-
 /* This command clears the dsb_possible_media_change flag, so we must 
  * retain it.
  */
@@ -1413,6 +1411,9 @@ int __init cm206_init(void)
 	struct gendisk *disk;
 
 	printk(KERN_INFO "cm206 cdrom driver " REVISION);
+
+	tasklet_init(&cm206_tasklet, cm206_tasklet_func, 0);
+
 	cm206_base = probe_base_port(auto_probe ? 0 : cm206_base);
 	if (!cm206_base) {
 		printk(" can't find adapter!\n");
Index: linux-2.6-test/drivers/char/drm/drm_irq.c
===================================================================
--- linux-2.6-test.orig/drivers/char/drm/drm_irq.c
+++ linux-2.6-test/drivers/char/drm/drm_irq.c
@@ -458,7 +458,13 @@ static void drm_locked_tasklet_func(unsi
 void drm_locked_tasklet(drm_device_t *dev, void (*func)(drm_device_t*))
 {
 	unsigned long irqflags;
-	static DECLARE_TASKLET(drm_tasklet, drm_locked_tasklet_func, 0);
+	static struct tasklet_struct drm_tasklet;
+	static int drm_tasklet_init;
+
+	if (!drm_tasklet_init) {
+		tasklet_init(&drm_tasklet, drm_locked_tasklet_func, 0);
+		drm_tasklet_init = 1;
+	}
 
 	if (!drm_core_check_feature(dev, DRIVER_HAVE_IRQ) ||
 	    tasklet_is_scheduled(&drm_tasklet))
Index: linux-2.6-test/drivers/char/snsc_event.c
===================================================================
--- linux-2.6-test.orig/drivers/char/snsc_event.c
+++ linux-2.6-test/drivers/char/snsc_event.c
@@ -25,7 +25,7 @@
 static struct subch_data_s *event_sd;
 
 void scdrv_event(unsigned long);
-DECLARE_TASKLET(sn_sysctl_event, scdrv_event, 0);
+struct tasklet_struct sn_sysctl_event;
 
 /*
  * scdrv_event_interrupt
@@ -285,6 +285,9 @@ scdrv_event_init(struct sysctl_data_s *s
 	event_sd->sd_nasid = scd->scd_nasid;
 	spin_lock_init(&event_sd->sd_rlock);
 
+
+	tasklet_init(&sn_sysctl_event, scdrv_event, 0);
+
 	/* ask the system controllers to send events to this node */
 	event_sd->sd_subch = ia64_sn_sysctl_event_init(scd->scd_nasid);
 
Index: linux-2.6-test/drivers/media/video/vino.c
===================================================================
--- linux-2.6-test.orig/drivers/media/video/vino.c
+++ linux-2.6-test/drivers/media/video/vino.c
@@ -355,8 +355,8 @@ static const char *vino_v4l_device_name_
 
 static void vino_capture_tasklet(unsigned long channel);
 
-DECLARE_TASKLET(vino_tasklet_a, vino_capture_tasklet, VINO_CHANNEL_A);
-DECLARE_TASKLET(vino_tasklet_b, vino_capture_tasklet, VINO_CHANNEL_B);
+struct tasklet_struct vino_tasklet_a;
+struct tasklet_struct vino_tasklet_b;
 
 static const struct vino_input vino_inputs[] = {
 	{
@@ -4605,6 +4605,9 @@ static int __init vino_module_init(void)
 
 	/* initialize data structures */
 
+	tasklet_init(&vino_tasklet_a, vino_capture_tasklet, VINO_CHANNEL_A);
+	tasklet_init(&vino_tasklet_b, vino_capture_tasklet, VINO_CHANNEL_B);
+
 	spin_lock_init(&vino_drvdata->vino_lock);
 	spin_lock_init(&vino_drvdata->input_lock);
 
Index: linux-2.6-test/drivers/net/wan/farsync.c
===================================================================
--- linux-2.6-test.orig/drivers/net/wan/farsync.c
+++ linux-2.6-test/drivers/net/wan/farsync.c
@@ -572,8 +572,8 @@ static void do_bottom_half_rx(struct fst
 static void fst_process_tx_work_q(unsigned long work_q);
 static void fst_process_int_work_q(unsigned long work_q);
 
-static DECLARE_TASKLET(fst_tx_task, fst_process_tx_work_q, 0);
-static DECLARE_TASKLET(fst_int_task, fst_process_int_work_q, 0);
+struct tasklet_struct fst_tx_task;
+struct tasklet_struct fst_int_task;
 
 static struct fst_card_info *fst_card_array[FST_MAX_CARDS];
 static spinlock_t fst_work_q_lock;
@@ -2697,6 +2697,8 @@ fst_init(void)
 	for (i = 0; i < FST_MAX_CARDS; i++)
 		fst_card_array[i] = NULL;
 	spin_lock_init(&fst_work_q_lock);
+	tasklet_init(&fst_tx_task, fst_process_tx_work_q, 0);
+	tasklet_init(&fst_int_task, fst_process_int_work_q, 0);
 	return pci_register_driver(&fst_driver);
 }
 
Index: linux-2.6-test/drivers/s390/cio/qdio.c
===================================================================
--- linux-2.6-test.orig/drivers/s390/cio/qdio.c
+++ linux-2.6-test/drivers/s390/cio/qdio.c
@@ -98,7 +98,7 @@ static volatile struct qdio_q *tiq_list=
 static DEFINE_SPINLOCK(ttiq_list_lock);
 static int register_thinint_result;
 static void tiqdio_tl(unsigned long);
-static DECLARE_TASKLET(tiqdio_tasklet,tiqdio_tl,0);
+static struct tasklet_struct tiqdio_tasklet;
 
 /* not a macro, as one of the arguments is atomic_read */
 static inline int 
@@ -3839,6 +3839,8 @@ init_QDIO(void)
 
 	printk("qdio: loading %s\n",version);
 
+	tasklet_init(&tiqdio_tasklet, tiqdio_tl, 0);
+
 	res=qdio_get_qdio_memory();
 	if (res)
 		return res;
Index: linux-2.6-test/drivers/s390/crypto/ap_bus.c
===================================================================
--- linux-2.6-test.orig/drivers/s390/crypto/ap_bus.c
+++ linux-2.6-test/drivers/s390/crypto/ap_bus.c
@@ -80,7 +80,7 @@ static DECLARE_WORK(ap_config_work, ap_s
  * Tasklet & timer for AP request polling.
  */
 static struct timer_list ap_poll_timer = TIMER_INITIALIZER(ap_poll_timeout,0,0);
-static DECLARE_TASKLET(ap_tasklet, ap_poll_all, 0);
+static struct tasklet_struct ap_tasklet;
 static atomic_t ap_poll_requests = ATOMIC_INIT(0);
 static DECLARE_WAIT_QUEUE_HEAD(ap_poll_wait);
 static struct task_struct *ap_poll_kthread = NULL;
@@ -1188,6 +1188,8 @@ int __init ap_module_init(void)
 	}
 	register_reset_call(&ap_reset_call);
 
+	tasklet_init(&ap_tasklet, ap_poll_all, 0);
+
 	/* Create /sys/bus/ap. */
 	rc = bus_register(&ap_bus_type);
 	if (rc)
Index: linux-2.6-test/drivers/usb/gadget/net2280.c
===================================================================
--- linux-2.6-test.orig/drivers/usb/gadget/net2280.c
+++ linux-2.6-test/drivers/usb/gadget/net2280.c
@@ -511,7 +511,7 @@ static void do_free(unsigned long ignore
 	spin_unlock_irq(&buflock);
 }
 
-static DECLARE_TASKLET(deferred_free, do_free, 0);
+static struct tasklet_struct deferred_free;
 
 static void
 net2280_free_buffer (
@@ -3051,6 +3051,9 @@ static int __init init (void)
 {
 	if (!use_dma)
 		use_dma_chaining = 0;
+
+	tasklet_init(&deferred_free, do_free, 0);
+
 	return pci_register_driver (&net2280_pci_driver);
 }
 module_init (init);
Index: linux-2.6-test/drivers/usb/gadget/omap_udc.c
===================================================================
--- linux-2.6-test.orig/drivers/usb/gadget/omap_udc.c
+++ linux-2.6-test/drivers/usb/gadget/omap_udc.c
@@ -365,7 +365,7 @@ static void do_free(unsigned long ignore
 	spin_unlock_irq(&buflock);
 }
 
-static DECLARE_TASKLET(deferred_free, do_free, 0);
+static struct tasklet_struct deferred_free;
 
 static void omap_free_buffer(
 	struct usb_ep	*_ep,
@@ -3182,6 +3182,9 @@ static int __init udc_init(void)
 #endif
 		"%s\n", driver_desc,
 		use_dma ?  " (dma)" : "");
+
+	tasklet_init(&deferred_free, do_free, 0);
+
 	return platform_driver_register(&udc_driver);
 }
 module_init(udc_init);
Index: linux-2.6-test/kernel/irq/resend.c
===================================================================
--- linux-2.6-test.orig/kernel/irq/resend.c
+++ linux-2.6-test/kernel/irq/resend.c
@@ -44,7 +44,7 @@ static void resend_irqs(unsigned long ar
 }
 
 /* Tasklet to handle resend: */
-static DECLARE_TASKLET(resend_tasklet, resend_irqs, 0);
+static struct tasklet_struct resend_tasklet;
 
 #endif
 
@@ -75,3 +75,12 @@ void check_irq_resend(struct irq_desc *d
 		}
 	}
 }
+
+#ifdef CONFIG_HARDIRQS_SW_RESEND
+static int __init irq_resend_init(void)
+{
+	tasklet_init(&resend_tasklet, resend_irqs, 0);
+}
+
+core_initcall(irq_resend_init);
+#endif
Index: linux-2.6-test/net/atm/pppoatm.c
===================================================================
--- linux-2.6-test.orig/net/atm/pppoatm.c
+++ linux-2.6-test/net/atm/pppoatm.c
@@ -281,7 +281,14 @@ static int pppoatm_assign_vcc(struct atm
 	 * Each PPPoATM instance has its own tasklet - this is just a
 	 * prototypical one used to initialize them
 	 */
-	static const DECLARE_TASKLET(tasklet_proto, pppoatm_wakeup_sender, 0);
+	static struct tasklet_struct tasklet_proto;
+	static int tasklet_proto_init;
+
+	if (!tasklet_proto_init) {
+		tasklet_init(&tasklet_proto, pppoatm_wakeup_sender, 0);
+		tasklet_proto_init = 1;
+	}
+
 	if (copy_from_user(&be, arg, sizeof be))
 		return -EFAULT;
 	if (be.encaps != PPPOATM_ENCAPS_AUTODETECT &&
Index: linux-2.6-test/net/iucv/iucv.c
===================================================================
--- linux-2.6-test.orig/net/iucv/iucv.c
+++ linux-2.6-test/net/iucv/iucv.c
@@ -103,7 +103,7 @@ static cpumask_t iucv_buffer_cpumask = C
 static cpumask_t iucv_irq_cpumask = CPU_MASK_NONE;
 
 static void iucv_tasklet_handler(unsigned long);
-static DECLARE_TASKLET(iucv_tasklet, iucv_tasklet_handler,0);
+static struct tasklet_struct iucv_tasklet;
 
 enum iucv_command_codes {
 	IUCV_QUERY = 0,
@@ -1525,6 +1525,7 @@ static int iucv_init(void)
 		rc = -EPROTONOSUPPORT;
 		goto out;
 	}
+	tasklet_init(&iucv_tasklet, iucv_tasklet_handler,0);
 	rc = iucv_query_maxconn();
 	if (rc)
 		goto out;
Index: linux-2.6-test/include/linux/tasklet.h
===================================================================
--- linux-2.6-test.orig/include/linux/tasklet.h
+++ linux-2.6-test/include/linux/tasklet.h
@@ -30,10 +30,6 @@ struct tasklet_struct
 	unsigned long data;
 };
 
-#define DECLARE_TASKLET(name, func, data) \
-struct tasklet_struct name = { NULL, 0, ATOMIC_INIT(0), func, data }
-
-
 enum
 {
 	TASKLET_STATE_SCHED,	/* Tasklet is scheduled for execution */

-- 
