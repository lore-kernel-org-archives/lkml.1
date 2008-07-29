Return-Path: <linux-kernel-owner+w=401wt.eu-S1759906AbYG2UGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759906AbYG2UGs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 16:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbYG2UGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 16:06:13 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:21093 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752050AbYG2UGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 16:06:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ccMBG7X9S4/T5aOgKPMBmho4PHBEgEmUEzdQ55BGWhauC3l5m3BcOPXXirhK1oCWnrBIDxNvQk0KdkwglceEbnrMicpjoEMgpw2SPabfQhxxF6HNV+4XsUgWayPjuTrs+T+aSeMuUegoH9GLb1dFu9xJBAuhmDKNlRj+jU74fCE=  ;
X-YMail-OSG: lSmT5xQVM1kM4n3r60zNmn4UVd0rk6_T1LE_UvZIUxDAd3ucuU3M1T5aHE3_iUIsTvdtns0.EEiuYhJ8qAd4HWJoasQmRZ.VpBKR2YTz0X2AHaWiR_i995htwYhR29SPd3mV5sjB.itxTjBSjx1ZFt_IqVYy6oouD1SCf5HBa0FzTcB9EggvP9JswPWJ9gSP
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Clemens Ladisch <clemens@ladisch.de>, lkml <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.27-rc1] /dev/hpet - fixes and cleanup
Date: Tue, 29 Jul 2008 12:47:38 -0700
User-Agent: KMail/1.9.9
Cc: bob.picco@hp.com, venkatesh.pallipadi@intel.com,
       Vojtech Pavlik <vojtech@suse.cz>,
       the arch/x86 maintainers <x86@kernel.org>,
       Adrian Bunk <bunk@kernel.org>
References: <200807221508.56672.david-b@pacbell.net> <200807280127.22060.david-b@pacbell.net> <488D8D16.7010502@ladisch.de>
In-Reply-To: <488D8D16.7010502@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807291247.38869.david-b@pacbell.net>
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
      + displays *counter* (shared between comparators) bit width,
        not *timer* bit widths (which are often mixed)
      + relabel "timers" as "comparators"; this is less confusing,
        they are not independent like normal timers are (sigh)
      + display MHz not Hz; it's never less than 10 MHz.

  * Tighten and correct the userspace interface code
      + don't accidentally program comparators in 64-bit mode using
        32-bit values ... always force comparators into 32-bit mode
      + provide the correct bit definition flagging comparators with
        periodic capability ... the ABI is unchanged

  * Update Documentation/hpet.txt
      + be more correct and current
      + expand description a bit
      + don't mention that now-gone kernel interface

Plus, add a FIXME comment for something that could cause big trouble
on systems with more capable HPETs than at least Intel seems to ship. 

It seems that few folk use this userspace interface; it's not very
usable given the general lack of HPET IRQ routing.  I'm told that
the only real point of it any more is to mmap for fast timestamps;
IMO that's handled better through the gettimeofday() vsyscall.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
I CC'd everyone who MAINTAINERS says maintains HPET.  Odd to have
four entries!!

And re that kernel interface ... IMO, worth having a relatively
generic interface for hardware timers instead of inventing a new
interface for each new bit of hardware.  Embedded systems tend to
have at least half a dozen timers to spare.

 Documentation/hpet.txt |   43 +++++++++++------------
 arch/x86/kernel/hpet.c |    6 ++-
 drivers/char/hpet.c    |   90 +++++++++++++------------------------------------
 include/linux/hpet.h   |   11 -----
 4 files changed, 51 insertions(+), 99 deletions(-)

--- a/Documentation/hpet.txt	2008-07-27 15:48:04.000000000 -0700
+++ b/Documentation/hpet.txt	2008-07-28 00:37:15.000000000 -0700
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
--- a/arch/x86/kernel/hpet.c	2008-07-27 15:48:04.000000000 -0700
+++ b/arch/x86/kernel/hpet.c	2008-07-28 00:37:15.000000000 -0700
@@ -115,13 +115,17 @@ static void hpet_reserve_platform_timers
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
 
--- a/drivers/char/hpet.c	2008-07-27 15:48:04.000000000 -0700
+++ b/drivers/char/hpet.c	2008-07-28 01:22:01.000000000 -0700
@@ -53,6 +53,11 @@
 
 #define HPET_RANGE_SIZE		1024	/* from HPET spec */
 
+
+/* WARNING -- don't get confused.  These macros are never used
+ * to write the (single) counter, and rarely to read it.
+ * They're badly named; to fix, someday.
+ */
 #if BITS_PER_LONG == 64
 #define	write_counter(V, MC)	writeq(V, MC)
 #define	read_counter(MC)	readq(MC)
@@ -77,7 +82,7 @@ static struct clocksource clocksource_hp
         .rating         = 250,
         .read           = read_hpet,
         .mask           = CLOCKSOURCE_MASK(64),
-        .mult           = 0, /*to be caluclated*/
+        .mult           = 0, /*to be calculated*/
         .shift          = 10,
         .flags          = CLOCK_SOURCE_IS_CONTINUOUS,
 };
@@ -86,8 +91,6 @@ static struct clocksource *hpet_clocksou
 
 /* A lock for concurrent access by app and isr hpet activity. */
 static DEFINE_SPINLOCK(hpet_lock);
-/* A lock for concurrent intermodule access to hpet and isr hpet activity. */
-static DEFINE_SPINLOCK(hpet_task_lock);
 
 #define	HPET_DEV_NAME	(7)
 
@@ -99,7 +102,6 @@ struct hpet_dev {
 	unsigned long hd_irqdata;
 	wait_queue_head_t hd_waitqueue;
 	struct fasync_struct *hd_async_queue;
-	struct hpet_task *hd_task;
 	unsigned int hd_flags;
 	unsigned int hd_irq;
 	unsigned int hd_hdwirq;
@@ -173,11 +175,6 @@ static irqreturn_t hpet_interrupt(int ir
 		writel(isr, &devp->hd_hpet->hpet_isr);
 	spin_unlock(&hpet_lock);
 
-	spin_lock(&hpet_task_lock);
-	if (devp->hd_task)
-		devp->hd_task->ht_func(devp->hd_task->ht_data);
-	spin_unlock(&hpet_task_lock);
-
 	wake_up_interruptible(&devp->hd_waitqueue);
 
 	kill_fasync(&devp->hd_async_queue, SIGIO, POLL_IN);
@@ -199,8 +196,7 @@ static int hpet_open(struct inode *inode
 
 	for (devp = NULL, hpetp = hpets; hpetp && !devp; hpetp = hpetp->hp_next)
 		for (i = 0; i < hpetp->hp_ntimer; i++)
-			if (hpetp->hp_dev[i].hd_flags & HPET_OPEN
-			    || hpetp->hp_dev[i].hd_task)
+			if (hpetp->hp_dev[i].hd_flags & HPET_OPEN)
 				continue;
 			else {
 				devp = &hpetp->hp_dev[i];
@@ -441,7 +437,11 @@ static int hpet_ioctl_ieon(struct hpet_d
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
@@ -451,6 +451,12 @@ static int hpet_ioctl_ieon(struct hpet_d
 		v |= Tn_VAL_SET_CNF_MASK;
 		writeq(v, &timer->hpet_config);
 		local_irq_save(flags);
+
+		/* NOTE:  what we modify here is a hidden accumulator
+		 * register supported by periodic-capable comparators.
+		 * We never want to modify the (single) counter; that
+		 * would affect all the comparators.
+		 */
 		m = read_counter(&hpet->hpet_mc);
 		write_counter(t + m + hpetp->hp_delta, &timer->hpet_compare);
 	} else {
@@ -604,57 +610,6 @@ static int hpet_is_known(struct hpet_dat
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
-#if 0
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
-#endif  /*  0  */
-
 static ctl_table hpet_table[] = {
 	{
 	 .ctl_name = CTL_UNNUMBERED,
@@ -809,9 +764,12 @@ int hpet_alloc(struct hpet_data *hdp)
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
--- a/include/linux/hpet.h	2008-07-27 15:48:04.000000000 -0700
+++ b/include/linux/hpet.h	2008-07-28 00:37:15.000000000 -0700
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
@@ -125,7 +116,7 @@ struct hpet_info {
 	unsigned short hi_timer;
 };
 
-#define	HPET_INFO_PERIODIC	0x0001	/* timer is periodic */
+#define HPET_INFO_PERIODIC	0x0010	/* periodic-capable comparator */
 
 #define	HPET_IE_ON	_IO('h', 0x01)	/* interrupt on */
 #define	HPET_IE_OFF	_IO('h', 0x02)	/* interrupt off */
