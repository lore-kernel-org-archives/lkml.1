Return-Path: <linux-kernel-owner+w=401wt.eu-S1761494AbYESRj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761494AbYESRj4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 13:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755263AbYESRjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 13:39:47 -0400
Received: from 66-189-124-104.dhcp.oxfr.ma.charter.com ([66.189.124.104]:45659
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753688AbYESRjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 13:39:46 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 0/8] adaptive-locks v3
To: mingo@elte.hu, peterz@infradead.org, tglx@linutronix.de,
       rostedt@goodmis.org, linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, bill.huey@gmail.com, dsingleton@mvista.com,
       dwalker@mvista.com, npiggin@suse.de, pavel@ucw.cz, acme@redhat.com,
       sdietrich@novell.com, pmorreale@novell.com, mkohari@novell.com,
       ghaskins@novell.com
Date: Mon, 19 May 2008 13:07:10 -0400
Message-ID: <20080519170356.6820.5274.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,
  Here is the latest queue that we have for your review, ported to 25.4-rt1.
  Steven Rostedt has a really nice optimization for owner-pointer management
  that he will hopefully post as a follow up to this series.

Regards,
-Greg

-------------------------------

﻿Adaptive real-time locks
------------------------

Synopsis:
---
This patch series offers a significant (up to 500% faster)
performance improvement to many areas of the Real-Time kernel by
introducing an adaptive sleep/spin algorithm to the core locking
primitives.

This is the third release of these patches.  Changes since v2:

*) Rebased from 24.2-rt2 to 25.4-rt1
*) Cleaned up lateral-steal patches (G. Haskins, S. Dietrich)
*) Removed lateral-steal config/sysctl option (S. Rostedt)
*) Exclude RT tasks from lateral steal (S. Rostedt)
*) Move "optimize wakeup" after the adaptive code (S. Rostedt)
*) Remove extra update_current(RUNNING_MUTEX) (S. Rostedt)
*) Converted loop-based timeouts to use nanoseconds (P. Morreale)
*) Fixed a bug that caused hyper-thread machines to hang (G. Haskins)
*) Incorporated misc. review feedback

Description:
﻿---
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
Real time kernel.

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

Benchmark Data:
---
We have put together some data from different types of benchmarks for
this patch series, which you can find here:

ftp://ftp.novell.com/dev/ghaskins/adaptive-locks.pdf

It compares a stock kernel.org 2.6.24 (PREEMPT_DESKTOP), a stock
2.6.24-rt1 (PREEMPT_RT), and a 2.6.24-rt1 + adaptive-lock
(2.6.24-rt1-al) (PREEMPT_RT) kernel.  The machine is a 4-way (dual-core,
dual-socket) 2Ghz 5130 Xeon (core2duo-woodcrest) Dell Precision 490. 

Some tests show a marked improvement (for instance, ~450% more throughput
for dbench, and ~500% faster for hackbench), whereas some others
(make -j 128) the results were not as profound but they were still
net-positive. In all cases we have also verified that deterministic
latency is not impacted by using cyclic-test. 

Todo:
---
*) Tie into lockstat infrastructure
*) Research algorithms to skip long-hold locks entirely.

Download:
---
You can download this series in its entirety here:

ftp://ftp.novell.com/dev/ghaskins/adaptive-locks-v3.tar.bz2

Acknowledgements
---

Special thanks go to many people who were instrumental to this project,
including:
  *) the -rt team here at Novell for research, development, and testing.
  *) Nick Piggin for his invaluable consultation/feedback and use of his
     x86-ticket-locks.
  *) The reviewers/testers at Suse, Montavista, RedHat, linux-rt-users,
     Bill Huey, Peter Zijlstra, and Steven Rostedt for their time and
     feedback on these patches.

As always, comments/feedback/bug-fixes are welcome.

Regards,
-Greg


