Return-Path: <linux-kernel-owner+w=401wt.eu-S932335AbYBUPyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335AbYBUPyq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 10:54:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756281AbYBUPyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 10:54:09 -0500
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:41262
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755622AbYBUPyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 10:54:06 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH [RT] 00/14] RFC - adaptive real-time locks
To: mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       rostedt@goodmis.org, linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, bill.huey@gmail.com, kevin@hilman.org,
       cminyard@mvista.com, dsingleton@mvista.com, dwalker@mvista.com,
       npiggin@suse.de, dsaxena@plexity.net, ak@suse.de, gregkh@suse.de,
       sdietrich@novell.com, pmorreale@novell.com, mkohari@novell.com,
       ghaskins@novell.com
Date: Thu, 21 Feb 2008 10:26:25 -0500
Message-ID: <20080221152504.4804.8724.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Real Time patches to the Linux kernel converts the architecture
specific SMP-synchronization primitives commonly referred to as
"spinlocks" to an "RT mutex" implementation that support a priority
inheritance protocol, and priority-ordered wait queues.  The RT mutex
implementation allows tasks that would otherwise busy-wait for a
contended lock to be preempted by higher priority tasks without
compromising the integrity of critical sections protected by the lock.
The unintended side-effect is that the -rt kernel suffers from
significant degradation of IO throughput (disk and net) due to the
extra overhead associated with managing pi-lists and context switching.
This has been generally accepted as a price to pay for low-latency
preemption.

Our research indicates that it doesn't necessarily have to be this
way.  This patch set introduces an adaptive technology that retains both
the priority inheritance protocol as well as the preemptive nature of
spinlocks and mutexes and adds a 300+% throughput increase to the Linux
Real time kernel.  It applies to 2.6.24-rt1.  

These performance increases apply to disk IO as well as netperf UDP
benchmarks, without compromising RT preemption latency.  For more
complex applications, overall the I/O throughput seems to approach the
throughput on a PREEMPT_VOLUNTARY or PREEMPT_DESKTOP Kernel, as is
shipped by most distros.

Essentially, the RT Mutex has been modified to busy-wait under
contention for a limited (and configurable) time.  This works because
most locks are typically held for very short time spans.  Too often,
by the time a task goes to sleep on a mutex, the mutex is already being
released on another CPU.

The effect (on SMP) is that by polling a mutex for a limited time we
reduce context switch overhead by up to 90%, and therefore eliminate CPU
cycles as well as massive hot-spots in the scheduler / other bottlenecks
in the Kernel - even though we busy-wait (using CPU cycles) to poll the
lock.

We have put together some data from different types of benchmarks for
this patch series, which you can find here:

ftp://ftp.novell.com/dev/ghaskins/adaptive-locks.pdf

It compares a stock kernel.org 2.6.24 (PREEMPT_DESKTOP), a stock
2.6.24-rt1 (PREEMPT_RT), and a 2.6.24-rt1 + adaptive-lock
(2.6.24-rt1-al) (PREEMPT_RT) kernel.  The machine is a 4-way (dual-core,
dual-socket) 2Ghz 5130 Xeon (core2duo-woodcrest) Dell Precision 490. 

Some tests show a marked improvement (for instance, dbench and hackbench),
whereas some others (make -j 128) the results were not as profound but
they were still net-positive. In all cases we have also verified that
deterministic latency is not impacted by using cyclic-test. 

This patch series also includes some re-work on the raw_spinlock
infrastructure, including Nick Piggin's x86-ticket-locks.  We found that
the increased pressure on the lock->wait_locks could cause rare but
serious latency spikes that are fixed by a fifo raw_spinlock_t
implementation.  Nick was gracious enough to allow us to re-use his
work (which is already accepted in 2.6.25).  Note that we also have a
C version of his protocol available if other architectures need
fifo-lock support as well, which we will gladly post upon request.

Special thanks go to many people who were instrumental to this project,
including:
  *) the -rt team here at Novell for research, development, and testing.
  *) Nick Piggin for his invaluable consultation/feedback and use of his
     x86-ticket-locks.
  *) The reviewers/testers at Suse, Montavista, and Bill Huey for their
     time and feedback on the early versions of these patches.

As always, comments/feedback/bug-fixes are welcome.

Regards,
-Greg

