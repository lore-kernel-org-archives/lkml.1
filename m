Return-Path: <linux-kernel-owner+w=401wt.eu-S1752633AbYJAXD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbYJAXD5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 19:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbYJAXDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 19:03:22 -0400
Received: from www.tglx.de ([62.245.132.106]:56528 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbYJAXDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 19:03:20 -0400
Message-Id: <20081001223213.078984344@linutronix.de>
User-Agent: quilt/0.47-1
Date: Wed, 01 Oct 2008 23:02:08 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Veen <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Sven Dietrich <sdietrich@suse.de>
Subject: [RFC patch 0/5] genirq: add infrastructure for threaded interrupt
	handlers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series implements support for threaded irq handlers for the
generic IRQ layer.

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

I hope to have a real converted driver (aside of the dummy module used
for testing) ready real soon - as far as bugs/regressions stay out of
my way for a while. :)

Comments, reviews, flames as usual.

Thanks,

	tglx

