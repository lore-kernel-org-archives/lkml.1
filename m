Return-Path: <linux-kernel-owner+w=401wt.eu-S934197AbXC0TYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934197AbXC0TYo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 15:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934205AbXC0TYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 15:24:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44821 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934197AbXC0TYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 15:24:43 -0400
Date: Tue, 27 Mar 2007 21:24:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Early hang with 2.6.21-rc4-rt1
Message-ID: <20070327192400.GB31695@elte.hu>
References: <adad52xnccs.fsf@cisco.com> <20070325073146.GB10734@elte.hu> <ada4po9mlw5.fsf@cisco.com> <adavegpl0jd.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adavegpl0jd.fsf@cisco.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Roland Dreier <rdreier@cisco.com> wrote:

>  > I finally got curious enough to want to debug why starting kvm with
>  > tun/tap networking produces a bunch of
>  > 
>  >     rtc: lost some interrupts at 1024Hz.
>  > 
>  > messages.  So I'm assuming it's a ~millisecond irqs-off section
>  > somewhere.
> 
> And after everything, it's a heisenbug -- I repeatably get that lost 
> interrupts message on stock 2.6.21-rc4 but never on -rt1 with 
> CONFIG_LATENCY_TRACE.

please revert the patch below from -rt - i've hacked that message out of 
rtc.c :-/

	Ingo

Index: linux/drivers/char/rtc.c
===================================================================
--- linux.orig/drivers/char/rtc.c
+++ linux/drivers/char/rtc.c
@@ -82,10 +82,36 @@
 #include <asm/uaccess.h>
 #include <asm/system.h>
 
+#ifdef CONFIG_MIPS
+# include <asm/time.h>
+#endif
+
 #if defined(__i386__)
 #include <asm/hpet.h>
 #endif
 
+#ifdef CONFIG_RTC_HISTOGRAM
+
+static cycles_t last_interrupt_time;
+
+#include <asm/timex.h>
+
+#define CPU_MHZ		(cpu_khz / 1000)
+
+#define HISTSIZE	10000
+static int histogram[HISTSIZE];
+
+static int rtc_state;
+
+enum rtc_states {
+	S_STARTUP,		/* First round - let the application start */
+	S_IDLE,			/* Waiting for an interrupt */
+	S_WAITING_FOR_READ,	/* Signal delivered. waiting for rtc_read() */
+	S_READ_MISSED,		/* Signal delivered, read() deadline missed */
+};
+
+#endif
+
 #ifdef __sparc__
 #include <linux/pci.h>
 #include <asm/ebus.h>
@@ -191,7 +217,7 @@ static int rtc_proc_open(struct inode *i
 static unsigned long rtc_status = 0;	/* bitmapped status byte.	*/
 static unsigned long rtc_freq = 0;	/* Current periodic IRQ rate	*/
 static unsigned long rtc_irq_data = 0;	/* our output to the world	*/
-static unsigned long rtc_max_user_freq = 64; /* > this, need CAP_SYS_RESOURCE */
+static unsigned long rtc_max_user_freq = 1024; /* > this, need CAP_SYS_RESOURCE */
 
 #ifdef RTC_IRQ
 /*
@@ -225,7 +251,146 @@ static inline unsigned char rtc_is_updat
 	return uip;
 }
 
+#ifndef RTC_IRQ
+# undef CONFIG_RTC_HISTOGRAM
+#endif
+
+static inline void rtc_open_event(void)
+{
+#ifdef CONFIG_RTC_HISTOGRAM
+	int i;
+
+	last_interrupt_time = 0;
+	rtc_state = S_STARTUP;
+	rtc_irq_data = 0;
+
+	for (i = 0; i < HISTSIZE; i++)
+		histogram[i] = 0;
+#endif
+}
+
+static inline void rtc_wake_event(void)
+{
+#ifndef CONFIG_RTC_HISTOGRAM
+	kill_fasync (&rtc_async_queue, SIGIO, POLL_IN);
+#else
+	if (!(rtc_status & RTC_IS_OPEN))
+		return;
+
+	switch (rtc_state) {
+	/* Startup */
+	case S_STARTUP:
+		kill_fasync (&rtc_async_queue, SIGIO, POLL_IN);
+		break;
+	/* Waiting for an interrupt */
+	case S_IDLE:
+		kill_fasync (&rtc_async_queue, SIGIO, POLL_IN);
+		last_interrupt_time = get_cycles();
+		rtc_state = S_WAITING_FOR_READ;
+		break;
+
+	/* Signal has been delivered. waiting for rtc_read() */
+	case S_WAITING_FOR_READ:
+		/*
+		 * Well foo.  The usermode application didn't
+		 * schedule and read in time.
+		 */
+		last_interrupt_time = get_cycles();
+		rtc_state = S_READ_MISSED;
+		printk("Read missed before next interrupt\n");
+		break;
+	/* Signal has been delivered, read() deadline was missed */
+	case S_READ_MISSED:
+		/*
+		 * Not much we can do here.  We're waiting for the usermode
+		 * application to read the rtc
+		 */
+		last_interrupt_time = get_cycles();
+		break;
+	}
+#endif
+}
+
+static inline void rtc_read_event(void)
+{
+#ifdef CONFIG_RTC_HISTOGRAM
+	cycles_t now = get_cycles();
+
+	switch (rtc_state) {
+	/* Startup */
+	case S_STARTUP:
+		rtc_state = S_IDLE;
+		break;
+
+	/* Waiting for an interrupt */
+	case S_IDLE:
+		printk("bug in rtc_read(): called in state S_IDLE!\n");
+		break;
+	case S_WAITING_FOR_READ:	/*
+					 * Signal has been delivered.
+					 * waiting for rtc_read()
+					 */
+		/*
+		 * Well done
+		 */
+	case S_READ_MISSED:		/*
+					 * Signal has been delivered, read()
+					 * deadline was missed
+					 */
+		/*
+		 * So, you finally got here.
+		 */
+		if (!last_interrupt_time)
+			printk("bug in rtc_read(): last_interrupt_time = 0\n");
+		rtc_state = S_IDLE;
+		{
+			cycles_t latency = now - last_interrupt_time;
+			unsigned long delta;	/* Microseconds */
+
+			delta = latency;
+			delta /= CPU_MHZ;
+
+			if (delta > 1000 * 1000) {
+				printk("rtc: eek\n");
+			} else {
+				unsigned long slot = delta;
+				if (slot >= HISTSIZE)
+					slot = HISTSIZE - 1;
+				histogram[slot]++;
+				if (delta > 2000)
+					printk("wow!  That was a "
+							"%ld millisec bump\n",
+						delta / 1000);
+			}
+		}
+		rtc_state = S_IDLE;
+		break;
+	}
+#endif
+}
+
+static inline void rtc_close_event(void)
+{
+#ifdef CONFIG_RTC_HISTOGRAM
+	int i = 0;
+	unsigned long total = 0;
+
+	for (i = 0; i < HISTSIZE; i++)
+		total += histogram[i];
+	if (!total)
+		return;
+
+	printk("\nrtc latency histogram of {%s/%d, %lu samples}:\n",
+		current->comm, current->pid, total);
+	for (i = 0; i < HISTSIZE; i++) {
+		if (histogram[i])
+			printk("%d %d\n", i, histogram[i]);
+	}
+#endif
+}
+
 #ifdef RTC_IRQ
+
 /*
  *	A very tiny interrupt handler. It runs with IRQF_DISABLED set,
  *	but there is possibility of conflicting with the set_rtc_mmss()
@@ -269,9 +434,9 @@ irqreturn_t rtc_interrupt(int irq, void 
 	if (rtc_callback)
 		rtc_callback->func(rtc_callback->private_data);
 	spin_unlock(&rtc_task_lock);
-	wake_up_interruptible(&rtc_wait);	
 
-	kill_fasync (&rtc_async_queue, SIGIO, POLL_IN);
+	rtc_wake_event();
+	wake_up_interruptible(&rtc_wait);
 
 	return IRQ_HANDLED;
 }
@@ -381,6 +546,8 @@ static ssize_t rtc_read(struct file *fil
 		schedule();
 	} while (1);
 
+	rtc_read_event();
+
 	if (count == sizeof(unsigned int))
 		retval = put_user(data, (unsigned int __user *)buf) ?: sizeof(int);
 	else
@@ -613,6 +780,11 @@ static int rtc_do_ioctl(unsigned int cmd
 		save_freq_select = CMOS_READ(RTC_FREQ_SELECT);
 		CMOS_WRITE((save_freq_select|RTC_DIV_RESET2), RTC_FREQ_SELECT);
 
+		/*
+		 * Make CMOS date writes nonpreemptible even on PREEMPT_RT.
+		 * There's a limit to everything! =B-)
+		 */
+		preempt_disable();
 #ifdef CONFIG_MACH_DECSTATION
 		CMOS_WRITE(real_yrs, RTC_DEC_YEAR);
 #endif
@@ -622,6 +794,7 @@ static int rtc_do_ioctl(unsigned int cmd
 		CMOS_WRITE(hrs, RTC_HOURS);
 		CMOS_WRITE(min, RTC_MINUTES);
 		CMOS_WRITE(sec, RTC_SECONDS);
+		preempt_enable();
 
 		CMOS_WRITE(save_control, RTC_CONTROL);
 		CMOS_WRITE(save_freq_select, RTC_FREQ_SELECT);
@@ -720,6 +893,7 @@ static int rtc_open(struct inode *inode,
 	if(rtc_status & RTC_IS_OPEN)
 		goto out_busy;
 
+	rtc_open_event();
 	rtc_status |= RTC_IS_OPEN;
 
 	rtc_irq_data = 0;
@@ -775,6 +949,7 @@ no_irq:
 	rtc_irq_data = 0;
 	rtc_status &= ~RTC_IS_OPEN;
 	spin_unlock_irq (&rtc_lock);
+	rtc_close_event();
 	return 0;
 }
 
@@ -1159,7 +1334,7 @@ static void rtc_dropped_irq(unsigned lon
 
 	spin_unlock_irq(&rtc_lock);
 
-	printk(KERN_WARNING "rtc: lost some interrupts at %ldHz.\n", freq);
+//	printk(KERN_WARNING "rtc: lost some interrupts at %ldHz.\n", freq);
 
 	/* Now we have new data */
 	wake_up_interruptible(&rtc_wait);
