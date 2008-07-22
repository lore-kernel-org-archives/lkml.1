Return-Path: <linux-kernel-owner+w=401wt.eu-S1754781AbYGVWJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbYGVWJR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 18:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbYGVWJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 18:09:00 -0400
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:22599 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751797AbYGVWI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 18:08:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Q9e9T88zV75a3bk0QgxiT0InkfdVJnVaE8Ww4fzjgnbz/Ip8Tefma3vzjdRWHTQRiCrEqsctmy4oug031owBphN+UWuBwl/EFW7Xoo6XnU+yO7uKe9mNv0Y/ankdIZrpk0m2TgY9s3RtsmnX/CmrcgiAiQVwxfDLO8HClKafwEw=  ;
X-YMail-OSG: .MOj.7kVM1l6u.JZ5P3QqKI_uGRHpVjVWdSiAGSlCtungmNPwoMo94wXbsgGcpW8y9FVwxlXXeUZCR_RqBy9F4YaslO49YoF20i8xx45K79mBK9xZKNcWhUy_krAHR5Am58GT1q7ehEh_VvTKtOkT4SRXwYbSpa5lDZYAFCr9GUFURU-
X-Yahoo-Newman-Property: ymail-5
From: David Brownell <david-b@pacbell.net>
To: lkml <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.26] /dev/hpet - fixes and cleanup
Date: Tue, 22 Jul 2008 15:08:56 -0700
User-Agent: KMail/1.9.9
Cc: bob.picco@hp.com, venkatesh.pallipadi@intel.com,
       Vojtech Pavlik <vojtech@suse.cz>, clemens@ladisch.de,
       the arch/x86 maintainers <x86@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807221508.56672.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Minor /dev/hpet updates and bugfixes:

  * Remove dead code, mostly remnants of an incomplete/unusable
    kernel interface ... noted when addressing "sparse" warnings:
      + hpet_unregister() and a routine it calls
      + hpet_task and all references, including hpet_task_lock
      + hpet_data.hd_flags (and HPET_DATA_PLATFORM)

  * Correct and improve boot message:
      + displays *counter* (shared between comparators) bitwidth,
        not *timer* bitwidths (which are often mixed)
      + relabel "timers" as "comparators"; this is less confusing,
        they are not independent like normal timers are (sigh)
      + display MHz not Hz; it's never less than 10 MHz.

  * Tighten and correct the userspace interface code
      + don't accidentally program comparators in 64-bit mode using
        32-bit values ... always force comparators into 32-bit mode
      + only open comparators that have an interrupt, and can thus
        perform "real work"
      + provide the correct bit definition flagging comparators with
        periodic capability ... the ABI is unchanged

  * Update Documentation/hpet.txt
      + be more correct and current
      + expand description a bit
      + don't mention that now-gone kernel interface

Plus, add a FIXME comment for something that could cause big trouble
on systems with more capable HPETs than at least Intel seems to ship. 

I get the feeling few folk use this userspace interface, else those
nonfunctional IRQs would be causing more trouble.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
I CC'd everyone who MAINTAINERS says maintains HPET.  Odd to have
four entries!!

And re that kernel interface:  IMO, worth having a relatively
generic interface for hardware timers instead of inventing a new
interface for each new bit of hardware.  Embedded systems tend to
have at least half a dozen SOC timers available...

 Documentation/hpet.txt |   43 ++++++++++++-------------
 arch/x86/kernel/hpet.c |    6 ++-
 drivers/char/hpet.c    |   82 +++++++++++--------------------------------------
 include/linux/hpet.h   |   16 ++-------
 4 files changed, 50 insertions(+), 97 deletions(-)

--- a/Documentation/hpet.txt	2008-07-21 15:38:28.000000000 -0700
+++ b/Documentation/hpet.txt	2008-07-21 21:40:58.000000000 -0700
@@ -1,21 +1,32 @@
 		High Precision Event Timer Driver for Linux
 
-The High Precision Event Timer (HPET) hardware is the future replacement
-for the 8254 and Real Time Clock (RTC) periodic timer functionality.
-Each HPET can have up to 32 timers.  It is possible to configure the
-first two timers as legacy replacements for 8254 and RTC periodic timers.
-A specification done by Intel and Microsoft can be found at
-<http://www.intel.com/technology/architecture/hpetspec.htm>.
+The High Precision Event Timer (HPET) hardware follows a specification
+by Intel and Microsoft which can be found at
+
+	http://www.intel.com/technology/architecture/hpetspec.htm
+
+Each HPET has one fixed-rate counter (at 10+ MHz, hence "High Precision")
+and up to 32 comparators.  Normally three or more comparators are provided,
+each of which can generate oneshot interupts and at least one of which has
+additional hardware to support periodic interrupts.  The comparators are
+also called "timers", which can be misleading since usually timers are
+independent of each other ... these share a counter, complicating resets.
+
+HPET devices can support two interrupt routing modes.  In one mode, the
+comparators are additional interrupt sources with no particular system
+role.  Many x86 BIOS writers don't route HPET interrupts at all, which
+prevents use of that mode.  They support the other "legacy replacement"
+mode where the first two comparators block interrupts from 8254 timers
+and from the RTC.
 
 The driver supports detection of HPET driver allocation and initialization
 of the HPET before the driver module_init routine is called.  This enables
 platform code which uses timer 0 or 1 as the main timer to intercept HPET
 initialization.  An example of this initialization can be found in
-arch/i386/kernel/time_hpet.c.
+arch/x86/kernel/hpet.c.
 
-The driver provides two APIs which are very similar to the API found in
-the rtc.c driver.  There is a user space API and a kernel space API.
-An example user space program is provided below.
+The driver provides a userspace API which resembles the API found in the
+RTC driver framework.  An example user space program is provided below.
 
 #include <stdio.h>
 #include <stdlib.h>
@@ -286,15 +297,3 @@ out:
 
 	return;
 }
-
-The kernel API has three interfaces exported from the driver:
-
-	hpet_register(struct hpet_task *tp, int periodic)
-	hpet_unregister(struct hpet_task *tp)
-	hpet_control(struct hpet_task *tp, unsigned int cmd, unsigned long arg)
-
-The kernel module using this interface fills in the ht_func and ht_data
-members of the hpet_task structure before calling hpet_register.
-hpet_control simply vectors to the hpet_ioctl routine and has the same
-commands and respective arguments as the user API.  hpet_unregister
-is used to terminate usage of the HPET timer reserved by hpet_register.
--- a/arch/x86/kernel/hpet.c	2008-07-21 18:59:49.000000000 -0700
+++ b/arch/x86/kernel/hpet.c	2008-07-21 19:43:04.000000000 -0700
@@ -127,13 +127,17 @@ static void hpet_reserve_platform_timers
 	hd.hd_phys_address = hpet_address;
 	hd.hd_address = hpet;
 	hd.hd_nirqs = nrtimers;
-	hd.hd_flags = HPET_DATA_PLATFORM;
 	hpet_reserve_timer(&hd, 0);
 
 #ifdef CONFIG_HPET_EMULATE_RTC
 	hpet_reserve_timer(&hd, 1);
 #endif
 
+	/*
+	 * NOTE that hd_irq[] reflects IOAPIC input pins (LEGACY_8254
+	 * is wrong for i8259!) not the output IRQ.  Many BIOS writers
+	 * don't bother configuring *any* comparator interrupts.
+	 */
 	hd.hd_irq[0] = HPET_LEGACY_8254;
 	hd.hd_irq[1] = HPET_LEGACY_RTC;
 
--- a/drivers/char/hpet.c	2008-07-21 15:38:28.000000000 -0700
+++ b/drivers/char/hpet.c	2008-07-21 21:41:16.000000000 -0700
@@ -76,7 +76,7 @@ static struct clocksource clocksource_hp
         .rating         = 250,
         .read           = read_hpet,
         .mask           = CLOCKSOURCE_MASK(64),
-        .mult           = 0, /*to be caluclated*/
+        .mult           = 0, /*to be calculated*/
         .shift          = 10,
         .flags          = CLOCK_SOURCE_IS_CONTINUOUS,
 };
@@ -85,8 +85,6 @@ static struct clocksource *hpet_clocksou
 
 /* A lock for concurrent access by app and isr hpet activity. */
 static DEFINE_SPINLOCK(hpet_lock);
-/* A lock for concurrent intermodule access to hpet and isr hpet activity. */
-static DEFINE_SPINLOCK(hpet_task_lock);
 
 #define	HPET_DEV_NAME	(7)
 
@@ -98,7 +96,6 @@ struct hpet_dev {
 	unsigned long hd_irqdata;
 	wait_queue_head_t hd_waitqueue;
 	struct fasync_struct *hd_async_queue;
-	struct hpet_task *hd_task;
 	unsigned int hd_flags;
 	unsigned int hd_irq;
 	unsigned int hd_hdwirq;
@@ -172,11 +169,6 @@ static irqreturn_t hpet_interrupt(int ir
 		writel(isr, &devp->hd_hpet->hpet_isr);
 	spin_unlock(&hpet_lock);
 
-	spin_lock(&hpet_task_lock);
-	if (devp->hd_task)
-		devp->hd_task->ht_func(devp->hd_task->ht_data);
-	spin_unlock(&hpet_task_lock);
-
 	wake_up_interruptible(&devp->hd_waitqueue);
 
 	kill_fasync(&devp->hd_async_queue, SIGIO, POLL_IN);
@@ -198,7 +190,7 @@ static int hpet_open(struct inode *inode
 	for (devp = NULL, hpetp = hpets; hpetp && !devp; hpetp = hpetp->hp_next)
 		for (i = 0; i < hpetp->hp_ntimer; i++)
 			if (hpetp->hp_dev[i].hd_flags & HPET_OPEN
-			    || hpetp->hp_dev[i].hd_task)
+					|| !hpetp->hp_dev[i].hd_hdwirq)
 				continue;
 			else {
 				devp = &hpetp->hp_dev[i];
@@ -437,7 +429,11 @@ static int hpet_ioctl_ieon(struct hpet_d
 	devp->hd_irq = irq;
 	t = devp->hd_ireqfreq;
 	v = readq(&timer->hpet_config);
-	g = v | Tn_INT_ENB_CNF_MASK;
+
+	/* 64-bit comparators are not yet supported through the ioctls,
+	 * so force this into 32-bit mode if it supports both modes
+	 */
+	g = v | Tn_32MODE_CNF_MASK | Tn_INT_ENB_CNF_MASK;
 
 	if (devp->hd_flags & HPET_PERIODIC) {
 		write_counter(t, &timer->hpet_compare);
@@ -447,6 +443,12 @@ static int hpet_ioctl_ieon(struct hpet_d
 		v |= Tn_VAL_SET_CNF_MASK;
 		writeq(v, &timer->hpet_config);
 		local_irq_save(flags);
+
+		/* FIXME this may trash both the system clocksource and
+		 * the current clock event device!  Use HPET_TN_SETVAL
+		 * instead, like arch/x86/kernel/hpet.c does ... never
+		 * modify the counter, ever.
+		 */
 		m = read_counter(&hpet->hpet_mc);
 		write_counter(t + m + hpetp->hp_delta, &timer->hpet_compare);
 	} else {
@@ -600,55 +602,6 @@ static int hpet_is_known(struct hpet_dat
 	return 0;
 }
 
-static inline int hpet_tpcheck(struct hpet_task *tp)
-{
-	struct hpet_dev *devp;
-	struct hpets *hpetp;
-
-	devp = tp->ht_opaque;
-
-	if (!devp)
-		return -ENXIO;
-
-	for (hpetp = hpets; hpetp; hpetp = hpetp->hp_next)
-		if (devp >= hpetp->hp_dev
-		    && devp < (hpetp->hp_dev + hpetp->hp_ntimer)
-		    && devp->hd_hpet == hpetp->hp_hpet)
-			return 0;
-
-	return -ENXIO;
-}
-
-int hpet_unregister(struct hpet_task *tp)
-{
-	struct hpet_dev *devp;
-	struct hpet_timer __iomem *timer;
-	int err;
-
-	if ((err = hpet_tpcheck(tp)))
-		return err;
-
-	spin_lock_irq(&hpet_task_lock);
-	spin_lock(&hpet_lock);
-
-	devp = tp->ht_opaque;
-	if (devp->hd_task != tp) {
-		spin_unlock(&hpet_lock);
-		spin_unlock_irq(&hpet_task_lock);
-		return -ENXIO;
-	}
-
-	timer = devp->hd_timer;
-	writeq((readq(&timer->hpet_config) & ~Tn_INT_ENB_CNF_MASK),
-	       &timer->hpet_config);
-	devp->hd_flags &= ~(HPET_IE | HPET_PERIODIC);
-	devp->hd_task = NULL;
-	spin_unlock(&hpet_lock);
-	spin_unlock_irq(&hpet_task_lock);
-
-	return 0;
-}
-
 static ctl_table hpet_table[] = {
 	{
 	 .ctl_name = CTL_UNNUMBERED,
@@ -803,9 +756,12 @@ int hpet_alloc(struct hpet_data *hdp)
 		printk("%s %d", i > 0 ? "," : "", hdp->hd_irq[i]);
 	printk("\n");
 
-	printk(KERN_INFO "hpet%u: %u %d-bit timers, %Lu Hz\n",
-	       hpetp->hp_which, hpetp->hp_ntimer,
-	       cap & HPET_COUNTER_SIZE_MASK ? 64 : 32, hpetp->hp_tick_freq);
+	printk(KERN_INFO
+		"hpet%u: %u comparators, %d-bit %u.%06u MHz counter\n",
+		hpetp->hp_which, hpetp->hp_ntimer,
+		cap & HPET_COUNTER_SIZE_MASK ? 64 : 32,
+		(unsigned) (hpetp->hp_tick_freq / 1000000),
+		(unsigned) (hpetp->hp_tick_freq % 1000000));
 
 	mcfg = readq(&hpet->hpet_config);
 	if ((mcfg & HPET_ENABLE_CNF_MASK) == 0) {
--- a/include/linux/hpet.h	2008-07-21 15:38:28.000000000 -0700
+++ b/include/linux/hpet.h	2008-07-21 19:00:06.000000000 -0700
@@ -91,23 +91,14 @@ struct hpet {
  * exported interfaces
  */
 
-struct hpet_task {
-	void (*ht_func) (void *);
-	void *ht_data;
-	void *ht_opaque;
-};
-
 struct hpet_data {
 	unsigned long hd_phys_address;
 	void __iomem *hd_address;
 	unsigned short hd_nirqs;
-	unsigned short hd_flags;
 	unsigned int hd_state;	/* timer allocated */
 	unsigned int hd_irq[HPET_MAX_TIMERS];
 };
 
-#define	HPET_DATA_PLATFORM	0x0001	/* platform call to hpet_alloc */
-
 static inline void hpet_reserve_timer(struct hpet_data *hd, int timer)
 {
 	hd->hd_state |= (1 << timer);
@@ -125,7 +119,7 @@ struct hpet_info {
 	unsigned short hi_timer;
 };
 
-#define	HPET_INFO_PERIODIC	0x0001	/* timer is periodic */
+#define HPET_INFO_PERIODIC	0x0010	/* periodic-capable comparator */
 
 #define	HPET_IE_ON	_IO('h', 0x01)	/* interrupt on */
 #define	HPET_IE_OFF	_IO('h', 0x02)	/* interrupt off */
