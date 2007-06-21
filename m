Return-Path: <linux-kernel-owner+w=401wt.eu-S1755546AbXFUMP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546AbXFUMP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 08:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754041AbXFUMPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 08:15:19 -0400
Received: from rtsoft2.corbina.net ([85.21.88.2]:56439 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with SMTP id S1752541AbXFUMPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 08:15:17 -0400
Date: Thu, 21 Jun 2007 16:20:19 +0400
From: Konstantin Baydarov <kbaidarov@ru.mvista.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH RT] have x86_64 nmi watchdog also count irq 0
Message-ID: <20070621162019.650c8aac@windmill.dev.rtsoft.ru>
In-Reply-To: <1182365463.15228.39.camel@localhost.localdomain>
References: <1182365463.15228.39.camel@localhost.localdomain>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.19; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2007 14:51:03 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> I was getting false reports about NMI lockups on CPU 3.  For some
> reason CPU 0,1 and 2 where using apic timer, and CPU 3 was using the
> irq 0 timer.
> 
I think you are telling about case when nmi_watchdog is set to IO_APIC
(cmdline:nmi_watchdog=1). I've faced that problem too.
In case when nmi_watchdog is set to IO_APIC local APIC timers are disabled
kernel uses broadcast timer. External timer(PIT or PM I'm not sure) is used
instead of local CPU apic timers. But even that lapic timers are disabled,
lapic timer handler smp_apic_timer_interrupt() is triggered by broadcast timer
IPIs with the same vector as local APIC IRQs.
The problem is that IPIs are sent to all CPUs except CPU that is sending IPIs,
so local_apic_timer_interrupt won't executed for CPU that initiated IPIs,
instead high level timer code(event_handler) will be called explicitly. It's not a
problem in general but in case of watchdog per CPU variable apic_timer_irqs won't
be incremented, that's why we get lockup.
Steven, I think you have Boot CPU with physical id 3, timer handler(irq 0) runs
and sends broadcast IPIs only on Boot CPU so every time you get lockup on CPU3.

Also I suggest to fix i386 kernel, we should use per CPU statistic:
Index: git-linux-2.6/arch/i386/kernel/nmi.c
===================================================================
--- git-linux-2.6.orig/arch/i386/kernel/nmi.c
+++ git-linux-2.6/arch/i386/kernel/nmi.c
@@ -351,7 +351,7 @@ __kprobes int nmi_watchdog_tick(struct p
         * Take the local apic timer and PIT/HPET into account. We don't
         * know which one is active, when we have highres/dyntick on
         */
-       sum = per_cpu(irq_stat, cpu).apic_timer_irqs + kstat_irqs(0);
+       sum = per_cpu(irq_stat, cpu).apic_timer_irqs + kstat_cpu(cpu).irqs[0];

        /* if the none of the timers isn't firing, this cpu isn't doing much */
        if (!touched && last_irq_sums[cpu] == sum) {
