Return-Path: <linux-kernel-owner+w=401wt.eu-S1754546AbYFAQQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbYFAQQj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 12:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217AbYFAQQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 12:16:18 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:55927 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbYFAQQQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 12:16:16 -0400
Date: Sun, 1 Jun 2008 18:15:10 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20080601161510.GA26854@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: LinuxPPS low-level IRQs timestamps & ldisc
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I write to both of you since my questions are related. :)

My last modifications to LinuxPPS are focused on adding a PPS ldisc
and a low-level IRQs timestamps recording.

First I added a new dcd_change() ldisc method which can be used as
follow:

static void pps_tty_dcd_change(struct tty_struct *tty, unsigned int status)
{
       int id = (int) tty->disc_data;
       struct timespec __ts;
       struct pps_ktime ts;

       /* First of all we get the time stamp... */
       getnstimeofday(&__ts);

       /* ... and translate it to PPS time data struct */
       ts.sec = __ts.tv_sec;
       ts.nsec = __ts.tv_nsec;

       /* Now do the PPS event report */
       pps_event(id, &ts,
                       status ? PPS_CAPTUREASSERT : PPS_CAPTURECLEAR, tty);

       pr_debug("[STDev] PPS %s at %lu on source #%d\n",
                       status ? "assert" : "clear", jiffies, id);
}

However this solution gives very low precision timestamps so that's
why I propose to add the following code to register IRQ timestamps as
soon as possible (here the code for x86_32 architecture):

diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index d3fde94..a3b8457 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -15,6 +15,7 @@
 #include <linux/notifier.h>
 #include <linux/cpu.h>
 #include <linux/delay.h>
+#include <linux/pps.h>
 
 #include <asm/apic.h>
 #include <asm/uaccess.h>
@@ -25,6 +26,11 @@ EXPORT_PER_CPU_SYMBOL(irq_stat);
 DEFINE_PER_CPU(struct pt_regs *, irq_regs);
 EXPORT_PER_CPU_SYMBOL(irq_regs);
 
+#ifdef CONFIG_PPS_IRQ_EVENTS
+struct pps_ktime pps_irq_ts[NR_IRQS];
+EXPORT_SYMBOL(pps_irq_ts);
+#endif
+
 /*
  * 'what should we do if we get a hw irq event on an illegal vector'.
  * each architecture has to answer this themselves.
@@ -76,6 +82,12 @@ fastcall unsigned int do_IRQ(struct pt_regs *regs)
        union irq_ctx *curctx, *irqctx;
        u32 *isp;
 #endif
+#ifdef CONFIG_PPS_IRQ_EVENTS
+       struct timespec __ts;
+
+       /* Get IRQ timestamps as soon as possible for the PPS layer */
+       getnstimeofday(&__ts);
+#endif
 
        if (unlikely((unsigned)irq >= NR_IRQS)) {
                printk(KERN_EMERG "%s: cannot handle IRQ %d\n",
@@ -83,6 +95,12 @@ fastcall unsigned int do_IRQ(struct pt_regs *regs)
                BUG();
        }
 
+#ifdef CONFIG_PPS_IRQ_EVENTS
+       /* Then, after sanity check, store the IRQ timestamp */
+       pps_irq_ts[irq].sec = __ts.tv_sec;
+       pps_irq_ts[irq].nsec = __ts.tv_nsec;
+#endif
+
        old_regs = set_irq_regs(regs);
        irq_enter();
 #ifdef CONFIG_DEBUG_STACKOVERFLOW

This allow the following modifications to the dcd_change() method:

static void pps_tty_dcd_change(struct tty_struct *tty, unsigned int irq,
                               unsigned int status)
{
       int id = (int) tty->disc_data;

       pps_event(id, &pps_irq_ts[irq],
                       status ? PPS_CAPTUREASSERT : PPS_CAPTURECLEAR, tty);

       pr_debug("[IRQev] PPS %s at %lu on source #%d\n",
                       status ? "assert" : "clear", jiffies, id);
}

Note that in this case I need also the "irq" parameter.

This solution gives very high timestamps precision! Better that
before! :D

What do you think about this solution? More precisely:

1) The low-level IRQ patch can be acceptable?

2) The new dcd_change() method is well implemented? Can I add the
"irq" parameter or I can find it somewhere?

Thanks a lot for your suggestions,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@linux.it
Embedded Systems                     phone:	+39 349 2432127
UNIX programming                     skype:     rodolfo.giometti
