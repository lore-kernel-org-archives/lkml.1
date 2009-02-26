Return-Path: <linux-kernel-owner+w=401wt.eu-S1755949AbZBZN25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949AbZBZN25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 08:28:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753202AbZBZN2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 08:28:47 -0500
Received: from www.tglx.de ([62.245.132.106]:46805 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934AbZBZN2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 08:28:46 -0500
Message-Id: <20090226131336.423054348@linutronix.de>
User-Agent: quilt/0.47-1
Date: Thu, 26 Feb 2009 13:28:02 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jon Masters <jonathan@jonmasters.org>
Subject: [patch 0/4] genirq: add infrastructure for threaded interrupt
	handlers V2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series implements support for threaded irq handlers for the
generic IRQ layer.

Changes vs. V1:
	- review comments addressed
	- irq affinity setting for handler threads

Threaded interrupt handlers are not only interesting in the preempt-rt
context. Threaded interrupt handlers can help to address common
problems in the interrupt handling code:

 - move long running handlers out of the hard interrupt context

 - avoid complex hardirq -> tasklet/softirq interaction and locking
   problems by integration of this functionality into the threaded
   handler code

 - improved debugability of the kernel: faulty handlers do not take
   down the system.

 - allows prioritizing of the handlers which share an interrupt line

The implementation provides an opt-in mechanism to convert drivers to
the threaded interrupt handler model contrary to the preempt-rt patch
where the threaded handlers are enabled by a brute force switch. The
brute force switch is suboptimal as it does not change the interrupt
handler -> tasklet/softirq interaction problems, but was the only way
which was possible for the limited man power of the preempt-rt
developers.

Converting an interrupt to threaded makes only sense when the handler
code takes advantage of it by integrating tasklet/softirq
functionality and simplifying the locking.

When a driver wants to use threaded interrupt handlers it needs to
provide a quick check handler function, which checks whether the
interrupt was originated from the device or not.

In case it was originated from the device the quick check handler must
disable the interrupt at the device level and return
IRQ_WAKE_THREAD. The generic interrupt handling core then sets the
IRQF_RUNTHREAD in the irqaction of the handler and wakes the
associated thread.

The irqaction is referenced in the threads task_struct so handlers can
check for newly arrived interrupts in action flags. Aside of that the
reference is used to prevent further referencing of the thread in the
interrupt code in the case of segfault to make sure that the system
(minus the now dead interrupt handler) survives and debug information
can be retrieved. In the best case the driver can be restarted, but
dont expect that as a given.

The code was tested with a converted USB EHCI driver. The EHCI shares
an interrupt line with another device and both the threaded and the
non threaded handlers coexist nicely.

Thanks,

	tglx

