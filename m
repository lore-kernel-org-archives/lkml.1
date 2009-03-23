Return-Path: <linux-kernel-owner+w=401wt.eu-S1760176AbZCWSYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760176AbZCWSYu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 14:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759881AbZCWSY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 14:24:29 -0400
Received: from www.tglx.de ([62.245.132.106]:57626 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760186AbZCWSY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 14:24:27 -0400
Message-Id: <20090323172814.548471871@linutronix.de>
User-Agent: quilt/0.47-1
Date: Mon, 23 Mar 2009 18:23:04 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Christoph Hellwig <hch@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Sven Dietrich <sdietrich@suse.de>, David Brownell <david-b@pacbell.net>
Subject: [patch 0/2] Add support for threaded interrupt handlers - V3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series implements support for threaded irq handlers for the
generic IRQ layer.

Changes vs. V2:
	- review comments addressed
	- simplified design
	- synchronize_irq adapted to threaded handlers

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
provide a separate thread function, which is called from the per
device thread created in irq_request_threaded(). The primary handler
still needs to be supplied. It checks whether the interrupt was
originated from the device or not.

In case it was originated from the device the primary handler must
disable the interrupt at the device level and return
IRQ_WAKE_THREAD. The generic interrupt handling core then sets the
IRQF_RUNTHREAD in the irqaction of the handler and wakes the
associated thread.

The irqaction is referenced in the threads task_struct. The reference
is used to prevent further referencing of the thread in the interrupt
code in the case of segfault to make sure that the system (minus the
now dead interrupt handler) survives and debug information can be
retrieved. In the best case the driver can be restarted, but dont
expect that as a given.

The code was tested with a converted USB EHCI driver. The EHCI shares
an interrupt line with another device and both the threaded and the
non threaded handlers coexist nicely. 

Further the AHCI driver for ICH chipsets was converted and
tested. Interestingly enough this conversion did not cause worse
benchmark results with iobench and fio compared to the non threaded
mainline handler.

I'm still looking into a clean solution for the threaded demultiplex
handler case which was brought up by Dave to allow both the handling
of the demultiplexed devices in the context of the demultiplexer
interrupt thread and the wakeup of separate handler threads. But this
is an orthogonal extension of the existing patch set and does not
change the general design.

The patches apply on 
    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq/threaded

The irq/threaded branch contains the generic irq related changes which are
already queued for .30

Thanks,

	tglx

