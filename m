Return-Path: <linux-kernel-owner+w=401wt.eu-S1757728AbYGGT1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757728AbYGGT1e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 15:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754886AbYGGT1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 15:27:14 -0400
Received: from 166.sub-75-208-119.myvzw.com ([75.208.119.166]:55586 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754664AbYGGT1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 15:27:12 -0400
Message-Id: <20080707190749.299430659@goop.org>
User-Agent: quilt/0.46-1
Date: Mon, 07 Jul 2008 12:07:49 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@linux-foundation.org>,
       Petr Tesarik <ptesarik@suse.cz>,
       Virtualization <virtualization@lists.linux-foundation.org>,
       Xen devel <xen-devel@lists.xensource.com>,
       Thomas Friebel <thomas.friebel@amd.com>
Subject: [PATCH RFC 0/4] Paravirtual spinlocks
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the most recent Xen Summit, Thomas Friebel presented a paper
("Preventing Guests from Spinning Around",
http://xen.org/files/xensummitboston08/LHP.pdf) investigating the
interactions between spinlocks and virtual machines.  Specifically, he
looked at what happens when a lock-holding VCPU gets involuntarily
preempted.

The obvious first order effect is that while the VCPU is not running,
the effective critical region time goes from being microseconds to
milliseconds, until it gets scheduled again.  This increases the
chance that there will be be contention, and the contending VCPU will
waste time spinning.

This is a measurable effect, but not terribly serious.  After all,
since Linux tends to hold locks for very short periods of time,
the likelihood of being preempted while holding a lock is low.

The real eye-opener is the secondary effects specific to ticket locks.

Clearly ticket locks suffer the same problem as all spinlocks.  But
when the lock holder releases the lock, the real fun begins.

By design, ticket locks are strictly fair, by imposing a FIFO order
lock holders.  The micro-architectural effect of this is that the
lock cache line will bounce around between the contending CPUs until
it finds the next in line, who then takes the lock and carries on.

When running in a virtual machine, a similar effect happens at the
VCPU level.  If all the contending VCPUs are not currently running on
real CPUs, then VCPU scheduler will run some random subset of them.
If it isn't a given VCPUs turn to take the lock, it will spin, burning
a VCPU timeslice.  Eventually the next-in-line will get scheduled,
take the lock, release it, and the remaining contending VCPUs will
repeat the process until the next in line is scheduled.

This means that the effective contention time of the lock is not
merely the time if takes the original lock-holder to take and release
the lock - including any preemption it may suffer - but the
spin-scheduling storm that follows to schedule the right VCPU to next
take the lock.  This could happen if the original contention was not
as a result of preemption, but just normal spinlock level contention.

One of the results Thomas presents is a kernbench run which normally
takes less than a minute going for 45 minutes, with 99+% spent in
ticket lock contention.  I've reproduced similar results.

This series has:
 - a paravirt_ops spinlock interface, which defaults to the standard
   ticket lock algorithm,
 - a second spinlock implementation based on the pre-ticket-lock
   "lock-byte" algorithm,
 - And a Xen-specific spinlock algorithm which voluntarily preempts a
   VCPU if it spins for too long. [FOR REFERENCE ONLY: will not apply
   to a current git tree.]

When running on native hardware, the overhead of enabling
CONFIG_PARAVIRT is an extra direct call/return on the lock/unlock
paths; the paravirt-ops patching machinery eliminates any indirect
calls.  With a small amount of restructuring, this overhead could be
eliminated (by making spin_lock()/unlock() inline functions,
containing calls to __raw_spin_lock/unlock).

My experiments show that using a Xen-specific lock helps guest
performance a bit (reduction in elapsed and system time in a kernbench
run), but most significantly, reduces overall physical CPU consumption
by 10%, and so increases overall system scalability.

   J
-- 

