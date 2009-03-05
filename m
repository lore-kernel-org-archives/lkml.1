Return-Path: <linux-kernel-owner+w=401wt.eu-S1755539AbZCEIki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539AbZCEIki (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 03:40:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752992AbZCEIk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 03:40:29 -0500
Received: from charybdis-ext.suse.de ([195.135.221.2]:53672 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751737AbZCEIk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 03:40:28 -0500
Subject: [ANNOUNCE] USB genirq infrastructure for threaded interrupt
 handlers V2
From: Sven-Thorsten Dietrich <sdietrich@novell.com>
To: Thomas Gleixner <tglx@linutronix.de>,
       Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jon Masters <jonathan@jonmasters.org>
In-Reply-To: <20090226131336.423054348@linutronix.de>
References: <20090226131336.423054348@linutronix.de>
Content-Type: text/plain
Organization: Novell
Date: Thu, 05 Mar 2009 00:40:18 -0800
Message-Id: <1236242418.9736.41.camel@sven.thebigcorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-26 at 13:28 +0000, Thomas Gleixner wrote:
> This patch series implements support for threaded irq handlers for the
> generic IRQ layer.
> 
> Changes vs. V1:
> 	- review comments addressed
> 	- irq affinity setting for handler threads
> 

I have forward-ported Thomas's patch set to 2.6.29-rc7, and added the
USB irq implementation for ohci, ehci and uhci.

A tar ball of the entire series is here:

http://www.thebigcorporation.com/Sven/genirq-usb/genirq-usb-2.6.29-rc7-v0.1.tar.bz2


After spending quite a bit of time looking at this implementation (and
at RT's):

The primary difference between the RT IRQ threading implementation, and
this one, is that the former implements mandatory per-LINE IRQ
threading, while the latter implements opt-in per-DEVICE IRQ threading.

The RFC "per-DEVICE" design can side-step the boot-IRQ quirks issue that
has plagued RT. But the opt-in design requires, that EVERY driver that
is to support IRQ threading must be modified.

Currently per-DEVICE design cannot cleanly support switching IRQs in and
out of thread context.

Last but not least, not all devices would be able to support IRQ
threading in this design. (RT has effectively no fall-out - practically
every piece of hardware works in that implementation)

The per-LINE design in RT brings with it a host of problems and
performance compromises, see the boot IRQ quirks work merged into
2.6.28. 

But the IRQ quirks issue can't be addressed for all chipsets, and
continues to be a problem on some hardware. This implementation would
also not completely eliminate that problem, depending on the device
palette presented and their IRQ arrangement / sharing.

The advantage of the RT per-line design, is that drivers modifications
are minimal, and just about every driver and every architecture works
with the existing implementation.

But per-line performance is abysmal under high IRQ loads when IRQs are
shared, and this has potential to boost throughput for RT. In some
cases, (multi-core) it might even boost throughput for the other PREEMPT
configurations. TBd.


The ideal solution IMO, would be one where you can switch IRQs in and
out of thread context. 

This would increase the tuning and debugging options, and not compromise
throughput for those who don't care for what threading can provide.

SO with those general comments, following is the punch list against my
USB implementation:

1. IRQ threading will impact performance, and simply forcing it on, as
in the USB case, may not be an ideal solution. This design does not
allow the ability to turn on and off IRQ threading as the RT per-line
IRQ implementation does. 

I'll run some benchmarks with what hardware I have here tomorrow.

2. Status tracking. The contents of the status register should be stored
in the IRQ (quickcheck handler, and used in the threaded portion). I
have added some debugging, and I can see the USB status registers
changing between running the quickcheck handler in IRQ context, and
executing the thread. 

This would obviously happen if a USB device is plugged in, between IRQ
and thread execution, for example. But any USB activity causes status
register changes.

USB drivers seem to be graceful enough to "catch up" on the changes.

Other hardware may not be as forgiving. What do you do - queue up a list
of status register snapshots, or just process the device as-is, when the
thread runs? What events may be missed? This is probably hardware
dependent, and possibly further driver-code mods may be needed to
accommodate case-by-case.

3. Locking. USB has 3 primary implementations. Each use a different
degree of locking strictness, and this implementation requires adding
locks to be compatible with any possible RT implementation (because in
RT, the IRQ-context portion locks must be raw locks, while the thread
side locks must be mutexes to avoid all sorts of latency and
scheduling-while-atomic fiascos).

In general, there has to be at least some locking around the caching of
status registers, so that the quickcheck does not stomp of status
register bits being written by a yet incomplete thread-level execution.

I.e. the assumption is, that device level IRQs are not re-enabled until
the end of thread execution. This is probably not consistent with a lot
of driver implementations, which may assume that IRQ-context execution
is non-reentrant. 

This is the very terse version, just to put down some of my thoughts.


Overall, I would be curious about feedback on in implementation of this
on top of the RT tree. 

IMO, a hybrid solution, where per-device as well as per-line IRQ
threading, and NO IRQ threading, are all possible to co-exist, would be
ideal both for variants.

Regards,

Sven
 



