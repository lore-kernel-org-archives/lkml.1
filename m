Return-Path: <linux-kernel-owner+w=401wt.eu-S1753134AbZHSQTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134AbZHSQTI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 12:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753121AbZHSQTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 12:19:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55699 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753092AbZHSQTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 12:19:04 -0400
Date: Wed, 19 Aug 2009 09:18:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [BUG] lockup with the latest kernel
Message-Id: <20090819091820.d55e3353.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.0908191134260.12663@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0908191134260.12663@gandalf.stny.rr.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Aug 2009 11:49:25 -0400 (EDT) Steven Rostedt <rostedt@goodmis.org> wrote:

> Always happens where one CPU is sending an IPI and the other has the rq 
> spinlock. Seems to be that the IPI expects the other CPU to not have 
> interrupts disabled or something?
> 
> Note, I've seen this on 2.6.30-rc6 as well (yes that's 2.6.30). But this 
> does not happen on 2.6.29. Unfortunately, 2.6.29 makes my NIC go kaputt 
> for some reason.
> 
> I've enabled LOCKDEP and it just makes the bug trigger easier.
> 
> Anyway, anyone have any ideas?

We'd need to see the backtrace on the target CPU.

It shouldn't be too hard - set that CPU's bit in
arch/x86/kernel/apic/nmi.c:backtrace_mask and then clear it again when
that CPU has responded.

Or even:

diff -puN arch/x86/kernel/apic/nmi.c~a arch/x86/kernel/apic/nmi.c
--- a/arch/x86/kernel/apic/nmi.c~a
+++ a/arch/x86/kernel/apic/nmi.c
@@ -387,6 +387,8 @@ void touch_nmi_watchdog(void)
 }
 EXPORT_SYMBOL(touch_nmi_watchdog);
 
+extern int wizzle;
+
 notrace __kprobes int
 nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
 {
@@ -415,7 +417,8 @@ nmi_watchdog_tick(struct pt_regs *regs, 
 	}
 
 	/* We can be called before check_nmi_watchdog, hence NULL check. */
-	if (backtrace_mask != NULL && cpumask_test_cpu(cpu, backtrace_mask)) {
+	if (cpu == wizzle ||
+	   (backtrace_mask != NULL && cpumask_test_cpu(cpu, backtrace_mask))) {
 		static DEFINE_SPINLOCK(lock);	/* Serialise the printks */
 
 		spin_lock(&lock);
diff -puN arch/x86/kernel/smp.c~a arch/x86/kernel/smp.c
--- a/arch/x86/kernel/smp.c~a
+++ a/arch/x86/kernel/smp.c
@@ -111,13 +111,17 @@
  * it goes straight through and wastes no time serializing
  * anything. Worst case is that we lose a reschedule ...
  */
+int wizzle = -1;
+
 static void native_smp_send_reschedule(int cpu)
 {
 	if (unlikely(cpu_is_offline(cpu))) {
 		WARN_ON(1);
 		return;
 	}
+	wizzle = cpu;
 	apic->send_IPI_mask(cpumask_of(cpu), RESCHEDULE_VECTOR);
+	wizzle = -1;
 }
 
 void native_send_call_func_single_ipi(int cpu)
_


