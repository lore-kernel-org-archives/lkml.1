Return-Path: <linux-kernel-owner+w=401wt.eu-S1756743AbZDLOTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743AbZDLOTT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 10:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753986AbZDLOSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 10:18:15 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:43175 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590AbZDLOSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 10:18:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=IZMnzrN85TjwEbp4VGMkP1r8SCiNsPeU3wIh0MvST8N/EKvYL1yKUcGd1yy+o+quHE
         H0eCfE/kV7xPJf8U3cf5Hu/CINM6eKdNrcQ3qkXxgoC4Rjf2WEWsXJsr1H1QH08gBdmn
         mUOgnq7o9omPdGc6QVdryah2SJKTj2567Ri/k=
From: Alessio Igor Bogani <abogani@texware.it>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: LNML <linux-next@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH -next 4/4] Staging: comedi: Remove useless code
Date: Sun, 12 Apr 2009 16:17:50 +0200
Message-Id: <1239545870-23779-4-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1239545870-23779-3-git-send-email-abogani@texware.it>
References: <1239545870-23779-1-git-send-email-abogani@texware.it>
 <1239545870-23779-2-git-send-email-abogani@texware.it>
 <1239545870-23779-3-git-send-email-abogani@texware.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove all code contained into CONFIG_COMEDI_RTAI, CONFIG_COMEDI_RTL,
CONFIG_COMEDI_RTL_V1, CONFIG_COMEDI_FUSION and CONFIG_COMEDI_RT
ifdef/endif preprocessor directives. Which all referred to
method called "dual kernel approach" (where both a micro kernel OS
and Linux running on same machine and IRQ dispatching is under the
control of the first one) for achieve real-time behavior.

I take notice that:

1) Those are all completely undocumented.
2) No one express interest in keep those in sync so are unsupported.
3) As far I know, and at least for CONFIG_COMEDI_FUSION, are obsolete
   (FUSION was replaced by Xenomai long time ago).
4) Should be  better to let respectively authors make a separate patch
   against Linux source and comedi drivers.
5) Removing those should do avoid confusion in Linux kernel developers.
6) Keep those in don't let us chance to break/change the interfaces.
7) Those aren't integrated with Kbuild so are useless in any case.
8) Removing those make the code more simple.

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 drivers/staging/comedi/Kconfig                     |    7 -
 drivers/staging/comedi/Makefile                    |    1 -
 drivers/staging/comedi/comedi_fops.c               |   18 --
 drivers/staging/comedi/comedi_ksyms.c              |    7 -
 drivers/staging/comedi/comedi_rt.h                 |   75 -------
 drivers/staging/comedi/drivers/comedi_rt_timer.c   |   61 ------
 .../staging/comedi/kcomedilib/kcomedilib_main.c    |    9 -
 drivers/staging/comedi/rt.c                        |  216 --------------------
 drivers/staging/comedi/rt_pend_tq.c                |   52 -----
 9 files changed, 0 insertions(+), 446 deletions(-)

diff --git a/drivers/staging/comedi/Kconfig b/drivers/staging/comedi/Kconfig
index 2d819d2..037ae4c 100644
--- a/drivers/staging/comedi/Kconfig
+++ b/drivers/staging/comedi/Kconfig
@@ -13,13 +13,6 @@ config COMEDI_DEBUG
 	  This is an option for use by developers; most people should
 	  say N here. This enables comedi core and driver debugging.
 
-config COMEDI_RT
-	tristate "Comedi Real-time support"
-	depends on COMEDI && RT
-	default N
-	---help---
-	  Enable Real time support for the Comedi core.
-
 config COMEDI_PCI_DRIVERS
 	tristate "Comedi PCI drivers"
 	depends on COMEDI && PCI
diff --git a/drivers/staging/comedi/Makefile b/drivers/staging/comedi/Makefile
index afd1a19..793cf8c 100644
--- a/drivers/staging/comedi/Makefile
+++ b/drivers/staging/comedi/Makefile
@@ -1,5 +1,4 @@
 obj-$(CONFIG_COMEDI) += comedi.o
-obj-$(CONFIG_COMEDI_RT) += comedi_rt.o
 
 obj-$(CONFIG_COMEDI)	+= kcomedilib/
 obj-$(CONFIG_COMEDI)	+= drivers/
diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index 19dce2e..5c86002 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -1097,13 +1097,6 @@ static int do_cmd_ioctl(struct comedi_device *dev, void *arg, void *file)
 
 	comedi_set_subdevice_runflags(s, ~0, SRF_USER | SRF_RUNNING);
 
-#ifdef CONFIG_COMEDI_RT
-	if (async->cmd.flags & TRIG_RT) {
-		if (comedi_switch_to_rt(dev) == 0)
-			comedi_set_subdevice_runflags(s, SRF_RT, SRF_RT);
-	}
-#endif
-
 	ret = s->do_cmd(dev, s);
 	if (ret == 0)
 		return 0;
@@ -1738,12 +1731,6 @@ void do_become_nonbusy(struct comedi_device *dev, struct comedi_subdevice *s)
 	struct comedi_async *async = s->async;
 
 	comedi_set_subdevice_runflags(s, SRF_RUNNING, 0);
-#ifdef CONFIG_COMEDI_RT
-	if (comedi_get_subdevice_runflags(s) & SRF_RT) {
-		comedi_switch_to_non_rt(dev);
-		comedi_set_subdevice_runflags(s, SRF_RT, 0);
-	}
-#endif
 	if (async) {
 		comedi_reset_async_buf(async);
 		async->inttrig = NULL;
@@ -2036,13 +2023,8 @@ void comedi_event(struct comedi_device *dev, struct comedi_subdevice *s)
 		if (comedi_get_subdevice_runflags(s) & SRF_USER) {
 
 			if (dev->rt) {
-#ifdef CONFIG_COMEDI_RT
-				/* pend wake up */
-				comedi_rt_pend_wakeup(&async->wait_head);
-#else
 				printk
 				    ("BUG: comedi_event() code unreachable\n");
-#endif
 			} else {
 				wake_up_interruptible(&async->wait_head);
 				if (s->subdev_flags & SDF_CMD_READ) {
diff --git a/drivers/staging/comedi/comedi_ksyms.c b/drivers/staging/comedi/comedi_ksyms.c
index 6e6fb97..a732e34 100644
--- a/drivers/staging/comedi/comedi_ksyms.c
+++ b/drivers/staging/comedi/comedi_ksyms.c
@@ -46,13 +46,6 @@ EXPORT_SYMBOL(range_bipolar2_5);
 EXPORT_SYMBOL(range_unipolar10);
 EXPORT_SYMBOL(range_unipolar5);
 EXPORT_SYMBOL(range_unknown);
-#ifdef CONFIG_COMEDI_RT
-EXPORT_SYMBOL(comedi_free_irq);
-EXPORT_SYMBOL(comedi_request_irq);
-EXPORT_SYMBOL(comedi_switch_to_rt);
-EXPORT_SYMBOL(comedi_switch_to_non_rt);
-EXPORT_SYMBOL(rt_pend_call);
-#endif
 #ifdef CONFIG_COMEDI_DEBUG
 EXPORT_SYMBOL(comedi_debug);
 #endif
diff --git a/drivers/staging/comedi/comedi_rt.h b/drivers/staging/comedi/comedi_rt.h
index 169ca96..ab16fca 100644
--- a/drivers/staging/comedi/comedi_rt.h
+++ b/drivers/staging/comedi/comedi_rt.h
@@ -34,42 +34,6 @@
 #include <linux/spinlock.h>
 #include <linux/delay.h>
 
-#ifdef CONFIG_COMEDI_RT
-
-#ifdef CONFIG_COMEDI_RTAI
-#include <rtai.h>
-#include <rtai_sched.h>
-#include <rtai_version.h>
-#endif
-#ifdef CONFIG_COMEDI_RTL
-#include <rtl_core.h>
-#include <rtl_time.h>
-/* #ifdef RTLINUX_VERSION_CODE */
-#include <rtl_sync.h>
-/* #endif */
-#define rt_printk rtl_printf
-#endif
-#ifdef CONFIG_COMEDI_FUSION
-#define rt_printk(format, args...) printk(format , ## args)
-#endif /* CONFIG_COMEDI_FUSION */
-#ifdef CONFIG_PRIORITY_IRQ
-#define rt_printk printk
-#endif
-
-int comedi_request_irq(unsigned int irq, irqreturn_t(*handler) (int,
-		void *PT_REGS_ARG), unsigned long flags, const char *device,
-		struct comedi_device *dev_id);
-void comedi_free_irq(unsigned int irq, struct comedi_device *dev_id);
-void comedi_rt_init(void);
-void comedi_rt_cleanup(void);
-int comedi_switch_to_rt(struct comedi_device *dev);
-void comedi_switch_to_non_rt(struct comedi_device *dev);
-void comedi_rt_pend_wakeup(wait_queue_head_t *q);
-extern int rt_pend_call(void (*func) (int arg1, void *arg2), int arg1,
-	void *arg2);
-
-#else
-
 #define comedi_request_irq(a, b, c, d, e) request_irq(a, b, c, d, e)
 #define comedi_free_irq(a, b) free_irq(a, b)
 #define comedi_rt_init() do {} while (0)
@@ -80,8 +44,6 @@ extern int rt_pend_call(void (*func) (int arg1, void *arg2), int arg1,
 
 #define rt_printk(format, args...)	printk(format, ##args)
 
-#endif
-
 /* Define a spin_lock_irqsave function that will work with rt or without.
  * Use inline functions instead of just macros to enforce some type checking.
  */
@@ -92,58 +54,21 @@ static inline unsigned long __comedi_spin_lock_irqsave(spinlock_t *lock_ptr)
 {
 	unsigned long flags;
 
-#if defined(CONFIG_COMEDI_RTAI)
-	flags = rt_spin_lock_irqsave(lock_ptr);
-
-#elif defined(CONFIG_COMEDI_RTL)
-	rtl_spin_lock_irqsave(lock_ptr, flags);
-
-#elif defined(CONFIG_COMEDI_RTL_V1)
-	rtl_spin_lock_irqsave(lock_ptr, flags);
-
-#elif defined(CONFIG_COMEDI_FUSION)
-	rthal_spin_lock_irqsave(lock_ptr, flags);
-#else
 	spin_lock_irqsave(lock_ptr, flags);
 
-#endif
-
 	return flags;
 }
 
 static inline void comedi_spin_unlock_irqrestore(spinlock_t *lock_ptr,
 	unsigned long flags)
 {
-
-#if defined(CONFIG_COMEDI_RTAI)
-	rt_spin_unlock_irqrestore(flags, lock_ptr);
-
-#elif defined(CONFIG_COMEDI_RTL)
-	rtl_spin_unlock_irqrestore(lock_ptr, flags);
-
-#elif defined(CONFIG_COMEDI_RTL_V1)
-	rtl_spin_unlock_irqrestore(lock_ptr, flags);
-#elif defined(CONFIG_COMEDI_FUSION)
-	rthal_spin_unlock_irqrestore(lock_ptr, flags);
-#else
 	spin_unlock_irqrestore(lock_ptr, flags);
-
-#endif
-
 }
 
 /* define a RT safe udelay */
 static inline void comedi_udelay(unsigned int usec)
 {
-#if defined(CONFIG_COMEDI_RTAI)
-	static const int nanosec_per_usec = 1000;
-	rt_busy_sleep(usec * nanosec_per_usec);
-#elif defined(CONFIG_COMEDI_RTL)
-	static const int nanosec_per_usec = 1000;
-	rtl_delay(usec * nanosec_per_usec);
-#else
 	udelay(usec);
-#endif
 }
 
 #endif
diff --git a/drivers/staging/comedi/drivers/comedi_rt_timer.c b/drivers/staging/comedi/drivers/comedi_rt_timer.c
index f40c8cf..83198c2 100644
--- a/drivers/staging/comedi/drivers/comedi_rt_timer.c
+++ b/drivers/staging/comedi/drivers/comedi_rt_timer.c
@@ -56,67 +56,6 @@ TODO:
 
 #include "comedi_fc.h"
 
-#ifdef CONFIG_COMEDI_RTL_V1
-#include <rtl_sched.h>
-#include <asm/rt_irq.h>
-#endif
-#ifdef CONFIG_COMEDI_RTL
-#include <rtl.h>
-#include <rtl_sched.h>
-#include <rtl_compat.h>
-#include <asm/div64.h>
-
-#ifndef RTLINUX_VERSION_CODE
-#define RTLINUX_VERSION_CODE 0
-#endif
-#ifndef RTLINUX_VERSION
-#define RTLINUX_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))
-#endif
-
-// begin hack to workaround broken HRT_TO_8254() function on rtlinux
-#if RTLINUX_VERSION_CODE <= RTLINUX_VERSION(3,0,100)
-// this function sole purpose is to divide a long long by 838
-static inline RTIME nano2count(long long ns)
-{
-	do_div(ns, 838);
-	return ns;
-}
-
-#ifdef rt_get_time()
-#undef rt_get_time()
-#endif
-#define rt_get_time() nano2count(gethrtime())
-
-#else
-
-#define nano2count(x) HRT_TO_8254(x)
-#endif
-// end hack
-
-// rtl-rtai compatibility
-#define rt_task_wait_period() rt_task_wait()
-#define rt_pend_linux_srq(irq) rtl_global_pend_irq(irq)
-#define rt_free_srq(irq) rtl_free_soft_irq(irq)
-#define rt_request_srq(x,y,z) rtl_get_soft_irq(y,"timer")
-#define rt_task_init(a,b,c,d,e,f,g) rt_task_init(a,b,c,d,(e)+1)
-#define rt_task_resume(x) rt_task_wakeup(x)
-#define rt_set_oneshot_mode()
-#define start_rt_timer(x)
-#define stop_rt_timer()
-
-#endif
-#ifdef CONFIG_COMEDI_RTAI
-#include <rtai.h>
-#include <rtai_sched.h>
-
-#if RTAI_VERSION_CODE < RTAI_MANGLE_VERSION(3,3,0)
-#define comedi_rt_task_context_t	int
-#else
-#define comedi_rt_task_context_t	long
-#endif
-
-#endif
-
 /* This defines the fastest speed we will emulate.  Note that
  * without a watchdog (like in RTAI), we could easily overrun our
  * task period because analog input tends to be slow. */
diff --git a/drivers/staging/comedi/kcomedilib/kcomedilib_main.c b/drivers/staging/comedi/kcomedilib/kcomedilib_main.c
index a4fa957..63e8b0d 100644
--- a/drivers/staging/comedi/kcomedilib/kcomedilib_main.c
+++ b/drivers/staging/comedi/kcomedilib/kcomedilib_main.c
@@ -150,10 +150,6 @@ int comedi_command(void *d, struct comedi_cmd *cmd)
 
 	runflags = SRF_RUNNING;
 
-#ifdef CONFIG_COMEDI_RT
-	if (comedi_switch_to_rt(dev) == 0)
-		runflags |= SRF_RT;
-#endif
 	comedi_set_subdevice_runflags(s, ~0, runflags);
 
 	comedi_reset_async_buf(async);
@@ -449,11 +445,6 @@ int comedi_cancel(void *d, unsigned int subdevice)
 	if (ret)
 		return ret;
 
-#ifdef CONFIG_COMEDI_RT
-	if (comedi_get_subdevice_runflags(s) & SRF_RT)
-		comedi_switch_to_non_rt(dev);
-
-#endif
 	comedi_set_subdevice_runflags(s, SRF_RUNNING | SRF_RT, 0);
 	s->async->inttrig = NULL;
 	s->busy = NULL;
diff --git a/drivers/staging/comedi/rt.c b/drivers/staging/comedi/rt.c
index e9f5777..14a21bf 100644
--- a/drivers/staging/comedi/rt.c
+++ b/drivers/staging/comedi/rt.c
@@ -38,19 +38,6 @@
 
 #include "rt_pend_tq.h"
 
-#ifdef CONFIG_COMEDI_RTAI
-#include <rtai.h>
-#endif
-
-#ifdef CONFIG_COMEDI_FUSION
-#include <nucleus/asm/hal.h>
-#endif
-
-#ifdef CONFIG_COMEDI_RTL
-#include <rtl_core.h>
-#include <rtl_sync.h>
-#endif
-
 struct comedi_irq_struct {
 	int rt;
 	int irq;
@@ -175,208 +162,6 @@ void comedi_rt_pend_wakeup(wait_queue_head_t *q)
 	rt_pend_call(wake_up_int_handler, 0, q);
 }
 
-/* RTAI section */
-#ifdef CONFIG_COMEDI_RTAI
-
-#ifndef HAVE_RT_REQUEST_IRQ_WITH_ARG
-#define DECLARE_VOID_IRQ(irq) \
-static void handle_void_irq_ ## irq (void){ handle_void_irq(irq); }
-
-static void handle_void_irq(int irq)
-{
-	struct comedi_irq_struct *it;
-
-	it = comedi_irqs[irq];
-	if (it == NULL) {
-		rt_printk("comedi: null irq struct?\n");
-		return;
-	}
-	it->handler(irq, it->dev_id PT_REGS_NULL);
-	rt_enable_irq(irq);	/* needed by rtai-adeos, seems like it shouldn't hurt earlier versions */
-}
-
-DECLARE_VOID_IRQ(0);
-DECLARE_VOID_IRQ(1);
-DECLARE_VOID_IRQ(2);
-DECLARE_VOID_IRQ(3);
-DECLARE_VOID_IRQ(4);
-DECLARE_VOID_IRQ(5);
-DECLARE_VOID_IRQ(6);
-DECLARE_VOID_IRQ(7);
-DECLARE_VOID_IRQ(8);
-DECLARE_VOID_IRQ(9);
-DECLARE_VOID_IRQ(10);
-DECLARE_VOID_IRQ(11);
-DECLARE_VOID_IRQ(12);
-DECLARE_VOID_IRQ(13);
-DECLARE_VOID_IRQ(14);
-DECLARE_VOID_IRQ(15);
-DECLARE_VOID_IRQ(16);
-DECLARE_VOID_IRQ(17);
-DECLARE_VOID_IRQ(18);
-DECLARE_VOID_IRQ(19);
-DECLARE_VOID_IRQ(20);
-DECLARE_VOID_IRQ(21);
-DECLARE_VOID_IRQ(22);
-DECLARE_VOID_IRQ(23);
-
-static void handle_void_irq_ptrs[] = {
-	handle_void_irq_0,
-	handle_void_irq_1,
-	handle_void_irq_2,
-	handle_void_irq_3,
-	handle_void_irq_4,
-	handle_void_irq_5,
-	handle_void_irq_6,
-	handle_void_irq_7,
-	handle_void_irq_8,
-	handle_void_irq_9,
-	handle_void_irq_10,
-	handle_void_irq_11,
-	handle_void_irq_12,
-	handle_void_irq_13,
-	handle_void_irq_14,
-	handle_void_irq_15,
-	handle_void_irq_16,
-	handle_void_irq_17,
-	handle_void_irq_18,
-	handle_void_irq_19,
-	handle_void_irq_20,
-	handle_void_irq_21,
-	handle_void_irq_22,
-	handle_void_irq_23,
-};
-
-static int comedi_rt_get_irq(struct comedi_irq_struct *it)
-{
-	rt_request_global_irq(it->irq, handle_void_irq_ptrs[it->irq]);
-	rt_startup_irq(it->irq);
-
-	return 0;
-}
-
-static int comedi_rt_release_irq(struct comedi_irq_struct *it)
-{
-	rt_shutdown_irq(it->irq);
-	rt_free_global_irq(it->irq);
-	return 0;
-}
-#else
-
-static int comedi_rt_get_irq(struct comedi_irq_struct *it)
-{
-	int ret;
-
-	ret = rt_request_global_irq_arg(it->irq, it->handler, it->flags,
-		it->device, it->dev_id);
-	if (ret < 0) {
-		rt_printk("rt_request_global_irq_arg() returned %d\n", ret);
-		return ret;
-	}
-	rt_startup_irq(it->irq);
-
-	return 0;
-}
-
-static int comedi_rt_release_irq(struct comedi_irq_struct *it)
-{
-	rt_shutdown_irq(it->irq);
-	rt_free_global_irq(it->irq);
-	return 0;
-}
-#endif
-
-void comedi_rt_init(void)
-{
-	rt_mount_rtai();
-	rt_pend_tq_init();
-}
-
-void comedi_rt_cleanup(void)
-{
-	rt_umount_rtai();
-	rt_pend_tq_cleanup();
-}
-
-#endif
-
-/* Fusion section */
-#ifdef CONFIG_COMEDI_FUSION
-
-static void fusion_handle_irq(unsigned int irq, void *cookie)
-{
-	struct comedi_irq_struct *it = cookie;
-
-	it->handler(irq, it->dev_id PT_REGS_NULL);
-	rthal_irq_enable(irq);
-}
-
-static int comedi_rt_get_irq(struct comedi_irq_struct *it)
-{
-	rthal_irq_request(it->irq, fusion_handle_irq, it);
-	rthal_irq_enable(it->irq);
-	return 0;
-}
-
-static int comedi_rt_release_irq(struct comedi_irq_struct *it)
-{
-	rthal_irq_disable(it->irq);
-	rthal_irq_release(it->irq);
-	return 0;
-}
-
-void comedi_rt_init(void)
-{
-	rt_pend_tq_init();
-}
-
-void comedi_rt_cleanup(void)
-{
-	rt_pend_tq_cleanup();
-}
-
-#endif /*CONFIG_COMEDI_FUSION */
-
-/* RTLinux section */
-#ifdef CONFIG_COMEDI_RTL
-
-static unsigned int handle_rtl_irq(unsigned int irq PT_REGS_ARG)
-{
-	struct comedi_irq_struct *it;
-
-	it = comedi_irqs[irq];
-	if (it == NULL)
-		return 0;
-	it->handler(irq, it->dev_id PT_REGS_NULL);
-	rtl_hard_enable_irq(irq);
-	return 0;
-}
-
-static int comedi_rt_get_irq(struct comedi_irq_struct *it)
-{
-	rtl_request_global_irq(it->irq, handle_rtl_irq);
-	return 0;
-}
-
-static int comedi_rt_release_irq(struct comedi_irq_struct *it)
-{
-	rtl_free_global_irq(it->irq);
-	return 0;
-}
-
-void comedi_rt_init(void)
-{
-	rt_pend_tq_init();
-}
-
-void comedi_rt_cleanup(void)
-{
-	rt_pend_tq_cleanup();
-}
-
-#endif
-
-#ifdef CONFIG_COMEDI_PIRQ
 static int comedi_rt_get_irq(struct comedi_irq_struct *it)
 {
 	int ret;
@@ -408,4 +193,3 @@ void comedi_rt_cleanup(void)
 {
 	/* rt_pend_tq_cleanup(); */
 }
-#endif
diff --git a/drivers/staging/comedi/rt_pend_tq.c b/drivers/staging/comedi/rt_pend_tq.c
index f9dfd9d..4f6d48e 100644
--- a/drivers/staging/comedi/rt_pend_tq.c
+++ b/drivers/staging/comedi/rt_pend_tq.c
@@ -5,15 +5,6 @@
 #include <linux/sched.h>
 #include "comedidev.h"	/* for rt spinlocks */
 #include "rt_pend_tq.h"
-#ifdef CONFIG_COMEDI_RTAI
-#include <rtai.h>
-#endif
-#ifdef CONFIG_COMEDI_FUSION
-#include <nucleus/asm/hal.h>
-#endif
-#ifdef CONFIG_COMEDI_RTL
-#include <rtl_core.h>
-#endif
 
 #ifdef standalone
 #include <linux/module.h>
@@ -51,46 +42,12 @@ int rt_pend_call(void (*func) (int arg1, void *arg2), int arg1, void *arg2)
 	rt_pend_head->arg1 = arg1;
 	rt_pend_head->arg2 = arg2;
 	comedi_spin_unlock_irqrestore(&rt_pend_tq_lock, flags);
-#ifdef CONFIG_COMEDI_RTAI
-	rt_pend_linux_srq(rt_pend_tq_irq);
-#endif
-#ifdef CONFIG_COMEDI_FUSION
-	rthal_apc_schedule(rt_pend_tq_irq);
-#endif
-#ifdef CONFIG_COMEDI_RTL
-	rtl_global_pend_irq(rt_pend_tq_irq);
-
-#endif
 	return 0;
 }
 
-#ifdef CONFIG_COMEDI_RTAI
-void rt_pend_irq_handler(void)
-#elif defined(CONFIG_COMEDI_FUSION)
-void rt_pend_irq_handler(void *cookie)
-#elif defined(CONFIG_COMEDI_RTL)
-void rt_pend_irq_handler(int irq, void *dev PT_REGS_ARG)
-#endif
-{
-	while (rt_pend_head != rt_pend_tail) {
-		INC_CIRCULAR_PTR(rt_pend_tail, rt_pend_tq, RT_PEND_TQ_SIZE);
-		rt_pend_tail->func(rt_pend_tail->arg1, rt_pend_tail->arg2);
-	}
-}
-
 int rt_pend_tq_init(void)
 {
 	rt_pend_head = rt_pend_tail = rt_pend_tq;
-#ifdef CONFIG_COMEDI_RTAI
-	rt_pend_tq_irq = rt_request_srq(0, rt_pend_irq_handler, NULL);
-#endif
-#ifdef CONFIG_COMEDI_FUSION
-	rt_pend_tq_irq =
-		rthal_apc_alloc("comedi APC", rt_pend_irq_handler, NULL);
-#endif
-#ifdef CONFIG_COMEDI_RTL
-	rt_pend_tq_irq = rtl_get_soft_irq(rt_pend_irq_handler, "rt_pend_irq");
-#endif
 	if (rt_pend_tq_irq > 0)
 		printk("rt_pend_tq: RT bottom half scheduler initialized OK\n");
 	else
@@ -101,13 +58,4 @@ int rt_pend_tq_init(void)
 void rt_pend_tq_cleanup(void)
 {
 	printk("rt_pend_tq: unloading\n");
-#ifdef CONFIG_COMEDI_RTAI
-	rt_free_srq(rt_pend_tq_irq);
-#endif
-#ifdef CONFIG_COMEDI_FUSION
-	rthal_apc_free(rt_pend_tq_irq);
-#endif
-#ifdef CONFIG_COMEDI_RTL
-	free_irq(rt_pend_tq_irq, NULL);
-#endif
 }
-- 
1.6.0.4

