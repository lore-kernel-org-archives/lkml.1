Return-Path: <linux-kernel-owner+w=401wt.eu-S1757186AbYDQTXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186AbYDQTXW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 15:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752814AbYDQTXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 15:23:10 -0400
Received: from www.tglx.de ([62.245.132.106]:54593 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395AbYDQTXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 15:23:05 -0400
Date: Thu, 17 Apr 2008 21:22:35 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT pull] (hr)timer updates for 2.6.26
Message-ID: <alpine.LFD.1.10.0804172114570.3261@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  ssh://master.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-hrt.git master

a rather small bunch of updates to timers & Co.

The patches have brewed in linux-next for quite some time.

One outstanding is the revert of the revert of Andis clocksource
watchdog cycle change, which was reverted in your tree due to
regressions. The revert was a bit hasty as the really correct patch
unearthed the long standing add_timer_on() bug of NOHZ which we fixed
late in the 25 cycle.

Thanks,
	tglx

---
Andi Kleen (1):
      clocksource: make clocksource watchdog cycle through online CPUs

Karsten Wiese (1):
      clockevents: optimise tick_nohz_stop_sched_tick() a bit

Oleg Nesterov (3):
      timers: simplify lockdep handling
      hrtimers: simplify lockdep handling
      locking: remove unused double_spin_lock()

Pavel Machek (1):
      timer_list: add annotations to workqueue.c

Thomas Gleixner (3):
      hrtimer: add nanosleep specific restart_block member
      hrtimer: use nanosleep specific restart_block fields
      Documentation: move timer related documentation to a single place

WANG Cong (1):
      posix-timers: fix shadowed variables

 Documentation/00-INDEX                            |    6 +--
 Documentation/{hrtimers => timers}/highres.txt    |    0 
 Documentation/{hrtimers => timers}/hrtimers.txt   |    0 
 Documentation/{hrtimer => timers}/timer_stats.txt |    0 
 include/linux/hrtimer.h                           |    2 -
 include/linux/spinlock.h                          |   37 ---------------------
 include/linux/thread_info.h                       |   12 +++++++
 kernel/compat.c                                   |   15 ++++----
 kernel/hrtimer.c                                  |   22 ++++++-------
 kernel/posix-cpu-timers.c                         |   30 ++++++++--------
 kernel/time/clocksource.c                         |   18 ++++++++--
 kernel/time/tick-sched.c                          |    6 +--
 kernel/timer.c                                    |   16 ++-------
 kernel/workqueue.c                                |    2 +
 14 files changed, 68 insertions(+), 98 deletions(-)
 rename Documentation/{hrtimers => timers}/highres.txt (100%)
 rename Documentation/{hrtimers => timers}/hrtimers.txt (100%)
 rename Documentation/{hrtimer => timers}/timer_stats.txt (100%)
diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
index e8fb246..f7923a4 100644
--- a/Documentation/00-INDEX
+++ b/Documentation/00-INDEX
@@ -167,10 +167,8 @@ highuid.txt
 	- notes on the change from 16 bit to 32 bit user/group IDs.
 hpet.txt
 	- High Precision Event Timer Driver for Linux.
-hrtimer/
-	- info on the timer_stats debugging facility for timer (ab)use.
-hrtimers/
-	- info on the hrtimers subsystem for high-resolution kernel timers.
+timers/
+	- info on the timer related topics
 hw_random.txt
 	- info on Linux support for random number generator in i8xx chipsets.
 hwmon/
diff --git a/Documentation/hrtimer/timer_stats.txt b/Documentation/hrtimer/timer_stats.txt
deleted file mode 100644
index 20d368c..0000000
--- a/Documentation/hrtimer/timer_stats.txt
+++ /dev/null
@@ -1,73 +0,0 @@
-timer_stats - timer usage statistics
-------------------------------------
-
-timer_stats is a debugging facility to make the timer (ab)usage in a Linux
-system visible to kernel and userspace developers. If enabled in the config
-but not used it has almost zero runtime overhead, and a relatively small
-data structure overhead. Even if collection is enabled runtime all the
-locking is per-CPU and lookup is hashed.
-
-timer_stats should be used by kernel and userspace developers to verify that
-their code does not make unduly use of timers. This helps to avoid unnecessary
-wakeups, which should be avoided to optimize power consumption.
-
-It can be enabled by CONFIG_TIMER_STATS in the "Kernel hacking" configuration
-section.
-
-timer_stats collects information about the timer events which are fired in a
-Linux system over a sample period:
-
-- the pid of the task(process) which initialized the timer
-- the name of the process which initialized the timer
-- the function where the timer was intialized
-- the callback function which is associated to the timer
-- the number of events (callbacks)
-
-timer_stats adds an entry to /proc: /proc/timer_stats
-
-This entry is used to control the statistics functionality and to read out the
-sampled information.
-
-The timer_stats functionality is inactive on bootup.
-
-To activate a sample period issue:
-# echo 1 >/proc/timer_stats
-
-To stop a sample period issue:
-# echo 0 >/proc/timer_stats
-
-The statistics can be retrieved by:
-# cat /proc/timer_stats
-
-The readout of /proc/timer_stats automatically disables sampling. The sampled
-information is kept until a new sample period is started. This allows multiple
-readouts.
-
-Sample output of /proc/timer_stats:
-
-Timerstats sample period: 3.888770 s
-  12,     0 swapper          hrtimer_stop_sched_tick (hrtimer_sched_tick)
-  15,     1 swapper          hcd_submit_urb (rh_timer_func)
-   4,   959 kedac            schedule_timeout (process_timeout)
-   1,     0 swapper          page_writeback_init (wb_timer_fn)
-  28,     0 swapper          hrtimer_stop_sched_tick (hrtimer_sched_tick)
-  22,  2948 IRQ 4            tty_flip_buffer_push (delayed_work_timer_fn)
-   3,  3100 bash             schedule_timeout (process_timeout)
-   1,     1 swapper          queue_delayed_work_on (delayed_work_timer_fn)
-   1,     1 swapper          queue_delayed_work_on (delayed_work_timer_fn)
-   1,     1 swapper          neigh_table_init_no_netlink (neigh_periodic_timer)
-   1,  2292 ip               __netdev_watchdog_up (dev_watchdog)
-   1,    23 events/1         do_cache_clean (delayed_work_timer_fn)
-90 total events, 30.0 events/sec
-
-The first column is the number of events, the second column the pid, the third
-column is the name of the process. The forth column shows the function which
-initialized the timer and in parantheses the callback function which was
-executed on expiry.
-
-    Thomas, Ingo
-
-Added flag to indicate 'deferrable timer' in /proc/timer_stats. A deferrable
-timer will appear as follows
-  10D,     1 swapper          queue_delayed_work_on (delayed_work_timer_fn)
-
diff --git a/Documentation/hrtimers/highres.txt b/Documentation/hrtimers/highres.txt
deleted file mode 100644
index a73ecf5..0000000
--- a/Documentation/hrtimers/highres.txt
+++ /dev/null
@@ -1,249 +0,0 @@
-High resolution timers and dynamic ticks design notes
------------------------------------------------------
-
-Further information can be found in the paper of the OLS 2006 talk "hrtimers
-and beyond". The paper is part of the OLS 2006 Proceedings Volume 1, which can
-be found on the OLS website:
-http://www.linuxsymposium.org/2006/linuxsymposium_procv1.pdf
-
-The slides to this talk are available from:
-http://tglx.de/projects/hrtimers/ols2006-hrtimers.pdf
-
-The slides contain five figures (pages 2, 15, 18, 20, 22), which illustrate the
-changes in the time(r) related Linux subsystems. Figure #1 (p. 2) shows the
-design of the Linux time(r) system before hrtimers and other building blocks
-got merged into mainline.
-
-Note: the paper and the slides are talking about "clock event source", while we
-switched to the name "clock event devices" in meantime.
-
-The design contains the following basic building blocks:
-
-- hrtimer base infrastructure
-- timeofday and clock source management
-- clock event management
-- high resolution timer functionality
-- dynamic ticks
-
-
-hrtimer base infrastructure
----------------------------
-
-The hrtimer base infrastructure was merged into the 2.6.16 kernel. Details of
-the base implementation are covered in Documentation/hrtimers/hrtimer.txt. See
-also figure #2 (OLS slides p. 15)
-
-The main differences to the timer wheel, which holds the armed timer_list type
-timers are:
-       - time ordered enqueueing into a rb-tree
-       - independent of ticks (the processing is based on nanoseconds)
-
-
-timeofday and clock source management
--------------------------------------
-
-John Stultz's Generic Time Of Day (GTOD) framework moves a large portion of
-code out of the architecture-specific areas into a generic management
-framework, as illustrated in figure #3 (OLS slides p. 18). The architecture
-specific portion is reduced to the low level hardware details of the clock
-sources, which are registered in the framework and selected on a quality based
-decision. The low level code provides hardware setup and readout routines and
-initializes data structures, which are used by the generic time keeping code to
-convert the clock ticks to nanosecond based time values. All other time keeping
-related functionality is moved into the generic code. The GTOD base patch got
-merged into the 2.6.18 kernel.
-
-Further information about the Generic Time Of Day framework is available in the
-OLS 2005 Proceedings Volume 1:
-http://www.linuxsymposium.org/2005/linuxsymposium_procv1.pdf
-
-The paper "We Are Not Getting Any Younger: A New Approach to Time and
-Timers" was written by J. Stultz, D.V. Hart, & N. Aravamudan.
-
-Figure #3 (OLS slides p.18) illustrates the transformation.
-
-
-clock event management
-----------------------
-
-While clock sources provide read access to the monotonically increasing time
-value, clock event devices are used to schedule the next event
-interrupt(s). The next event is currently defined to be periodic, with its
-period defined at compile time. The setup and selection of the event device
-for various event driven functionalities is hardwired into the architecture
-dependent code. This results in duplicated code across all architectures and
-makes it extremely difficult to change the configuration of the system to use
-event interrupt devices other than those already built into the
-architecture. Another implication of the current design is that it is necessary
-to touch all the architecture-specific implementations in order to provide new
-functionality like high resolution timers or dynamic ticks.
-
-The clock events subsystem tries to address this problem by providing a generic
-solution to manage clock event devices and their usage for the various clock
-event driven kernel functionalities. The goal of the clock event subsystem is
-to minimize the clock event related architecture dependent code to the pure
-hardware related handling and to allow easy addition and utilization of new
-clock event devices. It also minimizes the duplicated code across the
-architectures as it provides generic functionality down to the interrupt
-service handler, which is almost inherently hardware dependent.
-
-Clock event devices are registered either by the architecture dependent boot
-code or at module insertion time. Each clock event device fills a data
-structure with clock-specific property parameters and callback functions. The
-clock event management decides, by using the specified property parameters, the
-set of system functions a clock event device will be used to support. This
-includes the distinction of per-CPU and per-system global event devices.
-
-System-level global event devices are used for the Linux periodic tick. Per-CPU
-event devices are used to provide local CPU functionality such as process
-accounting, profiling, and high resolution timers.
-
-The management layer assigns one or more of the following functions to a clock
-event device:
-      - system global periodic tick (jiffies update)
-      - cpu local update_process_times
-      - cpu local profiling
-      - cpu local next event interrupt (non periodic mode)
-
-The clock event device delegates the selection of those timer interrupt related
-functions completely to the management layer. The clock management layer stores
-a function pointer in the device description structure, which has to be called
-from the hardware level handler. This removes a lot of duplicated code from the
-architecture specific timer interrupt handlers and hands the control over the
-clock event devices and the assignment of timer interrupt related functionality
-to the core code.
-
-The clock event layer API is rather small. Aside from the clock event device
-registration interface it provides functions to schedule the next event
-interrupt, clock event device notification service and support for suspend and
-resume.
-
-The framework adds about 700 lines of code which results in a 2KB increase of
-the kernel binary size. The conversion of i386 removes about 100 lines of
-code. The binary size decrease is in the range of 400 byte. We believe that the
-increase of flexibility and the avoidance of duplicated code across
-architectures justifies the slight increase of the binary size.
-
-The conversion of an architecture has no functional impact, but allows to
-utilize the high resolution and dynamic tick functionalites without any change
-to the clock event device and timer interrupt code. After the conversion the
-enabling of high resolution timers and dynamic ticks is simply provided by
-adding the kernel/time/Kconfig file to the architecture specific Kconfig and
-adding the dynamic tick specific calls to the idle routine (a total of 3 lines
-added to the idle function and the Kconfig file)
-
-Figure #4 (OLS slides p.20) illustrates the transformation.
-
-
-high resolution timer functionality
------------------------------------
-
-During system boot it is not possible to use the high resolution timer
-functionality, while making it possible would be difficult and would serve no
-useful function. The initialization of the clock event device framework, the
-clock source framework (GTOD) and hrtimers itself has to be done and
-appropriate clock sources and clock event devices have to be registered before
-the high resolution functionality can work. Up to the point where hrtimers are
-initialized, the system works in the usual low resolution periodic mode. The
-clock source and the clock event device layers provide notification functions
-which inform hrtimers about availability of new hardware. hrtimers validates
-the usability of the registered clock sources and clock event devices before
-switching to high resolution mode. This ensures also that a kernel which is
-configured for high resolution timers can run on a system which lacks the
-necessary hardware support.
-
-The high resolution timer code does not support SMP machines which have only
-global clock event devices. The support of such hardware would involve IPI
-calls when an interrupt happens. The overhead would be much larger than the
-benefit. This is the reason why we currently disable high resolution and
-dynamic ticks on i386 SMP systems which stop the local APIC in C3 power
-state. A workaround is available as an idea, but the problem has not been
-tackled yet.
-
-The time ordered insertion of timers provides all the infrastructure to decide
-whether the event device has to be reprogrammed when a timer is added. The
-decision is made per timer base and synchronized across per-cpu timer bases in
-a support function. The design allows the system to utilize separate per-CPU
-clock event devices for the per-CPU timer bases, but currently only one
-reprogrammable clock event device per-CPU is utilized.
-
-When the timer interrupt happens, the next event interrupt handler is called
-from the clock event distribution code and moves expired timers from the
-red-black tree to a separate double linked list and invokes the softirq
-handler. An additional mode field in the hrtimer structure allows the system to
-execute callback functions directly from the next event interrupt handler. This
-is restricted to code which can safely be executed in the hard interrupt
-context. This applies, for example, to the common case of a wakeup function as
-used by nanosleep. The advantage of executing the handler in the interrupt
-context is the avoidance of up to two context switches - from the interrupted
-context to the softirq and to the task which is woken up by the expired
-timer.
-
-Once a system has switched to high resolution mode, the periodic tick is
-switched off. This disables the per system global periodic clock event device -
-e.g. the PIT on i386 SMP systems.
-
-The periodic tick functionality is provided by an per-cpu hrtimer. The callback
-function is executed in the next event interrupt context and updates jiffies
-and calls update_process_times and profiling. The implementation of the hrtimer
-based periodic tick is designed to be extended with dynamic tick functionality.
-This allows to use a single clock event device to schedule high resolution
-timer and periodic events (jiffies tick, profiling, process accounting) on UP
-systems. This has been proved to work with the PIT on i386 and the Incrementer
-on PPC.
-
-The softirq for running the hrtimer queues and executing the callbacks has been
-separated from the tick bound timer softirq to allow accurate delivery of high
-resolution timer signals which are used by itimer and POSIX interval
-timers. The execution of this softirq can still be delayed by other softirqs,
-but the overall latencies have been significantly improved by this separation.
-
-Figure #5 (OLS slides p.22) illustrates the transformation.
-
-
-dynamic ticks
--------------
-
-Dynamic ticks are the logical consequence of the hrtimer based periodic tick
-replacement (sched_tick). The functionality of the sched_tick hrtimer is
-extended by three functions:
-
-- hrtimer_stop_sched_tick
-- hrtimer_restart_sched_tick
-- hrtimer_update_jiffies
-
-hrtimer_stop_sched_tick() is called when a CPU goes into idle state. The code
-evaluates the next scheduled timer event (from both hrtimers and the timer
-wheel) and in case that the next event is further away than the next tick it
-reprograms the sched_tick to this future event, to allow longer idle sleeps
-without worthless interruption by the periodic tick. The function is also
-called when an interrupt happens during the idle period, which does not cause a
-reschedule. The call is necessary as the interrupt handler might have armed a
-new timer whose expiry time is before the time which was identified as the
-nearest event in the previous call to hrtimer_stop_sched_tick.
-
-hrtimer_restart_sched_tick() is called when the CPU leaves the idle state before
-it calls schedule(). hrtimer_restart_sched_tick() resumes the periodic tick,
-which is kept active until the next call to hrtimer_stop_sched_tick().
-
-hrtimer_update_jiffies() is called from irq_enter() when an interrupt happens
-in the idle period to make sure that jiffies are up to date and the interrupt
-handler has not to deal with an eventually stale jiffy value.
-
-The dynamic tick feature provides statistical values which are exported to
-userspace via /proc/stats and can be made available for enhanced power
-management control.
-
-The implementation leaves room for further development like full tickless
-systems, where the time slice is controlled by the scheduler, variable
-frequency profiling, and a complete removal of jiffies in the future.
-
-
-Aside the current initial submission of i386 support, the patchset has been
-extended to x86_64 and ARM already. Initial (work in progress) support is also
-available for MIPS and PowerPC.
-
-	  Thomas, Ingo
-
-
-
diff --git a/Documentation/hrtimers/hrtimers.txt b/Documentation/hrtimers/hrtimers.txt
deleted file mode 100644
index ce31f65..0000000
--- a/Documentation/hrtimers/hrtimers.txt
+++ /dev/null
@@ -1,178 +0,0 @@
-
-hrtimers - subsystem for high-resolution kernel timers
-----------------------------------------------------
-
-This patch introduces a new subsystem for high-resolution kernel timers.
-
-One might ask the question: we already have a timer subsystem
-(kernel/timers.c), why do we need two timer subsystems? After a lot of
-back and forth trying to integrate high-resolution and high-precision
-features into the existing timer framework, and after testing various
-such high-resolution timer implementations in practice, we came to the
-conclusion that the timer wheel code is fundamentally not suitable for
-such an approach. We initially didn't believe this ('there must be a way
-to solve this'), and spent a considerable effort trying to integrate
-things into the timer wheel, but we failed. In hindsight, there are
-several reasons why such integration is hard/impossible:
-
-- the forced handling of low-resolution and high-resolution timers in
-  the same way leads to a lot of compromises, macro magic and #ifdef
-  mess. The timers.c code is very "tightly coded" around jiffies and
-  32-bitness assumptions, and has been honed and micro-optimized for a
-  relatively narrow use case (jiffies in a relatively narrow HZ range)
-  for many years - and thus even small extensions to it easily break
-  the wheel concept, leading to even worse compromises. The timer wheel
-  code is very good and tight code, there's zero problems with it in its
-  current usage - but it is simply not suitable to be extended for
-  high-res timers.
-
-- the unpredictable [O(N)] overhead of cascading leads to delays which
-  necessitate a more complex handling of high resolution timers, which
-  in turn decreases robustness. Such a design still led to rather large
-  timing inaccuracies. Cascading is a fundamental property of the timer
-  wheel concept, it cannot be 'designed out' without unevitably
-  degrading other portions of the timers.c code in an unacceptable way.
-
-- the implementation of the current posix-timer subsystem on top of
-  the timer wheel has already introduced a quite complex handling of
-  the required readjusting of absolute CLOCK_REALTIME timers at
-  settimeofday or NTP time - further underlying our experience by
-  example: that the timer wheel data structure is too rigid for high-res
-  timers.
-
-- the timer wheel code is most optimal for use cases which can be
-  identified as "timeouts". Such timeouts are usually set up to cover
-  error conditions in various I/O paths, such as networking and block
-  I/O. The vast majority of those timers never expire and are rarely
-  recascaded because the expected correct event arrives in time so they
-  can be removed from the timer wheel before any further processing of
-  them becomes necessary. Thus the users of these timeouts can accept
-  the granularity and precision tradeoffs of the timer wheel, and
-  largely expect the timer subsystem to have near-zero overhead.
-  Accurate timing for them is not a core purpose - in fact most of the
-  timeout values used are ad-hoc. For them it is at most a necessary
-  evil to guarantee the processing of actual timeout completions
-  (because most of the timeouts are deleted before completion), which
-  should thus be as cheap and unintrusive as possible.
-
-The primary users of precision timers are user-space applications that
-utilize nanosleep, posix-timers and itimer interfaces. Also, in-kernel
-users like drivers and subsystems which require precise timed events
-(e.g. multimedia) can benefit from the availability of a separate
-high-resolution timer subsystem as well.
-
-While this subsystem does not offer high-resolution clock sources just
-yet, the hrtimer subsystem can be easily extended with high-resolution
-clock capabilities, and patches for that exist and are maturing quickly.
-The increasing demand for realtime and multimedia applications along
-with other potential users for precise timers gives another reason to
-separate the "timeout" and "precise timer" subsystems.
-
-Another potential benefit is that such a separation allows even more
-special-purpose optimization of the existing timer wheel for the low
-resolution and low precision use cases - once the precision-sensitive
-APIs are separated from the timer wheel and are migrated over to
-hrtimers. E.g. we could decrease the frequency of the timeout subsystem
-from 250 Hz to 100 HZ (or even smaller).
-
-hrtimer subsystem implementation details
-----------------------------------------
-
-the basic design considerations were:
-
-- simplicity
-
-- data structure not bound to jiffies or any other granularity. All the
-  kernel logic works at 64-bit nanoseconds resolution - no compromises.
-
-- simplification of existing, timing related kernel code
-
-another basic requirement was the immediate enqueueing and ordering of
-timers at activation time. After looking at several possible solutions
-such as radix trees and hashes, we chose the red black tree as the basic
-data structure. Rbtrees are available as a library in the kernel and are
-used in various performance-critical areas of e.g. memory management and
-file systems. The rbtree is solely used for time sorted ordering, while
-a separate list is used to give the expiry code fast access to the
-queued timers, without having to walk the rbtree.
-
-(This separate list is also useful for later when we'll introduce
-high-resolution clocks, where we need separate pending and expired
-queues while keeping the time-order intact.)
-
-Time-ordered enqueueing is not purely for the purposes of
-high-resolution clocks though, it also simplifies the handling of
-absolute timers based on a low-resolution CLOCK_REALTIME. The existing
-implementation needed to keep an extra list of all armed absolute
-CLOCK_REALTIME timers along with complex locking. In case of
-settimeofday and NTP, all the timers (!) had to be dequeued, the
-time-changing code had to fix them up one by one, and all of them had to
-be enqueued again. The time-ordered enqueueing and the storage of the
-expiry time in absolute time units removes all this complex and poorly
-scaling code from the posix-timer implementation - the clock can simply
-be set without having to touch the rbtree. This also makes the handling
-of posix-timers simpler in general.
-
-The locking and per-CPU behavior of hrtimers was mostly taken from the
-existing timer wheel code, as it is mature and well suited. Sharing code
-was not really a win, due to the different data structures. Also, the
-hrtimer functions now have clearer behavior and clearer names - such as
-hrtimer_try_to_cancel() and hrtimer_cancel() [which are roughly
-equivalent to del_timer() and del_timer_sync()] - so there's no direct
-1:1 mapping between them on the algorithmical level, and thus no real
-potential for code sharing either.
-
-Basic data types: every time value, absolute or relative, is in a
-special nanosecond-resolution type: ktime_t. The kernel-internal
-representation of ktime_t values and operations is implemented via
-macros and inline functions, and can be switched between a "hybrid
-union" type and a plain "scalar" 64bit nanoseconds representation (at
-compile time). The hybrid union type optimizes time conversions on 32bit
-CPUs. This build-time-selectable ktime_t storage format was implemented
-to avoid the performance impact of 64-bit multiplications and divisions
-on 32bit CPUs. Such operations are frequently necessary to convert
-between the storage formats provided by kernel and userspace interfaces
-and the internal time format. (See include/linux/ktime.h for further
-details.)
-
-hrtimers - rounding of timer values
------------------------------------
-
-the hrtimer code will round timer events to lower-resolution clocks
-because it has to. Otherwise it will do no artificial rounding at all.
-
-one question is, what resolution value should be returned to the user by
-the clock_getres() interface. This will return whatever real resolution
-a given clock has - be it low-res, high-res, or artificially-low-res.
-
-hrtimers - testing and verification
-----------------------------------
-
-We used the high-resolution clock subsystem ontop of hrtimers to verify
-the hrtimer implementation details in praxis, and we also ran the posix
-timer tests in order to ensure specification compliance. We also ran
-tests on low-resolution clocks.
-
-The hrtimer patch converts the following kernel functionality to use
-hrtimers:
-
- - nanosleep
- - itimers
- - posix-timers
-
-The conversion of nanosleep and posix-timers enabled the unification of
-nanosleep and clock_nanosleep.
-
-The code was successfully compiled for the following platforms:
-
- i386, x86_64, ARM, PPC, PPC64, IA64
-
-The code was run-tested on the following platforms:
-
- i386(UP/SMP), x86_64(UP/SMP), ARM, PPC
-
-hrtimers were also integrated into the -rt tree, along with a
-hrtimers-based high-resolution clock implementation, so the hrtimers
-code got a healthy amount of testing and use in practice.
-
-	Thomas Gleixner, Ingo Molnar
diff --git a/Documentation/timers/highres.txt b/Documentation/timers/highres.txt
new file mode 100644
index 0000000..a73ecf5
--- /dev/null
+++ b/Documentation/timers/highres.txt
@@ -0,0 +1,249 @@
+High resolution timers and dynamic ticks design notes
+-----------------------------------------------------
+
+Further information can be found in the paper of the OLS 2006 talk "hrtimers
+and beyond". The paper is part of the OLS 2006 Proceedings Volume 1, which can
+be found on the OLS website:
+http://www.linuxsymposium.org/2006/linuxsymposium_procv1.pdf
+
+The slides to this talk are available from:
+http://tglx.de/projects/hrtimers/ols2006-hrtimers.pdf
+
+The slides contain five figures (pages 2, 15, 18, 20, 22), which illustrate the
+changes in the time(r) related Linux subsystems. Figure #1 (p. 2) shows the
+design of the Linux time(r) system before hrtimers and other building blocks
+got merged into mainline.
+
+Note: the paper and the slides are talking about "clock event source", while we
+switched to the name "clock event devices" in meantime.
+
+The design contains the following basic building blocks:
+
+- hrtimer base infrastructure
+- timeofday and clock source management
+- clock event management
+- high resolution timer functionality
+- dynamic ticks
+
+
+hrtimer base infrastructure
+---------------------------
+
+The hrtimer base infrastructure was merged into the 2.6.16 kernel. Details of
+the base implementation are covered in Documentation/hrtimers/hrtimer.txt. See
+also figure #2 (OLS slides p. 15)
+
+The main differences to the timer wheel, which holds the armed timer_list type
+timers are:
+       - time ordered enqueueing into a rb-tree
+       - independent of ticks (the processing is based on nanoseconds)
+
+
+timeofday and clock source management
+-------------------------------------
+
+John Stultz's Generic Time Of Day (GTOD) framework moves a large portion of
+code out of the architecture-specific areas into a generic management
+framework, as illustrated in figure #3 (OLS slides p. 18). The architecture
+specific portion is reduced to the low level hardware details of the clock
+sources, which are registered in the framework and selected on a quality based
+decision. The low level code provides hardware setup and readout routines and
+initializes data structures, which are used by the generic time keeping code to
+convert the clock ticks to nanosecond based time values. All other time keeping
+related functionality is moved into the generic code. The GTOD base patch got
+merged into the 2.6.18 kernel.
+
+Further information about the Generic Time Of Day framework is available in the
+OLS 2005 Proceedings Volume 1:
+http://www.linuxsymposium.org/2005/linuxsymposium_procv1.pdf
+
+The paper "We Are Not Getting Any Younger: A New Approach to Time and
+Timers" was written by J. Stultz, D.V. Hart, & N. Aravamudan.
+
+Figure #3 (OLS slides p.18) illustrates the transformation.
+
+
+clock event management
+----------------------
+
+While clock sources provide read access to the monotonically increasing time
+value, clock event devices are used to schedule the next event
+interrupt(s). The next event is currently defined to be periodic, with its
+period defined at compile time. The setup and selection of the event device
+for various event driven functionalities is hardwired into the architecture
+dependent code. This results in duplicated code across all architectures and
+makes it extremely difficult to change the configuration of the system to use
+event interrupt devices other than those already built into the
+architecture. Another implication of the current design is that it is necessary
+to touch all the architecture-specific implementations in order to provide new
+functionality like high resolution timers or dynamic ticks.
+
+The clock events subsystem tries to address this problem by providing a generic
+solution to manage clock event devices and their usage for the various clock
+event driven kernel functionalities. The goal of the clock event subsystem is
+to minimize the clock event related architecture dependent code to the pure
+hardware related handling and to allow easy addition and utilization of new
+clock event devices. It also minimizes the duplicated code across the
+architectures as it provides generic functionality down to the interrupt
+service handler, which is almost inherently hardware dependent.
+
+Clock event devices are registered either by the architecture dependent boot
+code or at module insertion time. Each clock event device fills a data
+structure with clock-specific property parameters and callback functions. The
+clock event management decides, by using the specified property parameters, the
+set of system functions a clock event device will be used to support. This
+includes the distinction of per-CPU and per-system global event devices.
+
+System-level global event devices are used for the Linux periodic tick. Per-CPU
+event devices are used to provide local CPU functionality such as process
+accounting, profiling, and high resolution timers.
+
+The management layer assigns one or more of the following functions to a clock
+event device:
+      - system global periodic tick (jiffies update)
+      - cpu local update_process_times
+      - cpu local profiling
+      - cpu local next event interrupt (non periodic mode)
+
+The clock event device delegates the selection of those timer interrupt related
+functions completely to the management layer. The clock management layer stores
+a function pointer in the device description structure, which has to be called
+from the hardware level handler. This removes a lot of duplicated code from the
+architecture specific timer interrupt handlers and hands the control over the
+clock event devices and the assignment of timer interrupt related functionality
+to the core code.
+
+The clock event layer API is rather small. Aside from the clock event device
+registration interface it provides functions to schedule the next event
+interrupt, clock event device notification service and support for suspend and
+resume.
+
+The framework adds about 700 lines of code which results in a 2KB increase of
+the kernel binary size. The conversion of i386 removes about 100 lines of
+code. The binary size decrease is in the range of 400 byte. We believe that the
+increase of flexibility and the avoidance of duplicated code across
+architectures justifies the slight increase of the binary size.
+
+The conversion of an architecture has no functional impact, but allows to
+utilize the high resolution and dynamic tick functionalites without any change
+to the clock event device and timer interrupt code. After the conversion the
+enabling of high resolution timers and dynamic ticks is simply provided by
+adding the kernel/time/Kconfig file to the architecture specific Kconfig and
+adding the dynamic tick specific calls to the idle routine (a total of 3 lines
+added to the idle function and the Kconfig file)
+
+Figure #4 (OLS slides p.20) illustrates the transformation.
+
+
+high resolution timer functionality
+-----------------------------------
+
+During system boot it is not possible to use the high resolution timer
+functionality, while making it possible would be difficult and would serve no
+useful function. The initialization of the clock event device framework, the
+clock source framework (GTOD) and hrtimers itself has to be done and
+appropriate clock sources and clock event devices have to be registered before
+the high resolution functionality can work. Up to the point where hrtimers are
+initialized, the system works in the usual low resolution periodic mode. The
+clock source and the clock event device layers provide notification functions
+which inform hrtimers about availability of new hardware. hrtimers validates
+the usability of the registered clock sources and clock event devices before
+switching to high resolution mode. This ensures also that a kernel which is
+configured for high resolution timers can run on a system which lacks the
+necessary hardware support.
+
+The high resolution timer code does not support SMP machines which have only
+global clock event devices. The support of such hardware would involve IPI
+calls when an interrupt happens. The overhead would be much larger than the
+benefit. This is the reason why we currently disable high resolution and
+dynamic ticks on i386 SMP systems which stop the local APIC in C3 power
+state. A workaround is available as an idea, but the problem has not been
+tackled yet.
+
+The time ordered insertion of timers provides all the infrastructure to decide
+whether the event device has to be reprogrammed when a timer is added. The
+decision is made per timer base and synchronized across per-cpu timer bases in
+a support function. The design allows the system to utilize separate per-CPU
+clock event devices for the per-CPU timer bases, but currently only one
+reprogrammable clock event device per-CPU is utilized.
+
+When the timer interrupt happens, the next event interrupt handler is called
+from the clock event distribution code and moves expired timers from the
+red-black tree to a separate double linked list and invokes the softirq
+handler. An additional mode field in the hrtimer structure allows the system to
+execute callback functions directly from the next event interrupt handler. This
+is restricted to code which can safely be executed in the hard interrupt
+context. This applies, for example, to the common case of a wakeup function as
+used by nanosleep. The advantage of executing the handler in the interrupt
+context is the avoidance of up to two context switches - from the interrupted
+context to the softirq and to the task which is woken up by the expired
+timer.
+
+Once a system has switched to high resolution mode, the periodic tick is
+switched off. This disables the per system global periodic clock event device -
+e.g. the PIT on i386 SMP systems.
+
+The periodic tick functionality is provided by an per-cpu hrtimer. The callback
+function is executed in the next event interrupt context and updates jiffies
+and calls update_process_times and profiling. The implementation of the hrtimer
+based periodic tick is designed to be extended with dynamic tick functionality.
+This allows to use a single clock event device to schedule high resolution
+timer and periodic events (jiffies tick, profiling, process accounting) on UP
+systems. This has been proved to work with the PIT on i386 and the Incrementer
+on PPC.
+
+The softirq for running the hrtimer queues and executing the callbacks has been
+separated from the tick bound timer softirq to allow accurate delivery of high
+resolution timer signals which are used by itimer and POSIX interval
+timers. The execution of this softirq can still be delayed by other softirqs,
+but the overall latencies have been significantly improved by this separation.
+
+Figure #5 (OLS slides p.22) illustrates the transformation.
+
+
+dynamic ticks
+-------------
+
+Dynamic ticks are the logical consequence of the hrtimer based periodic tick
+replacement (sched_tick). The functionality of the sched_tick hrtimer is
+extended by three functions:
+
+- hrtimer_stop_sched_tick
+- hrtimer_restart_sched_tick
+- hrtimer_update_jiffies
+
+hrtimer_stop_sched_tick() is called when a CPU goes into idle state. The code
+evaluates the next scheduled timer event (from both hrtimers and the timer
+wheel) and in case that the next event is further away than the next tick it
+reprograms the sched_tick to this future event, to allow longer idle sleeps
+without worthless interruption by the periodic tick. The function is also
+called when an interrupt happens during the idle period, which does not cause a
+reschedule. The call is necessary as the interrupt handler might have armed a
+new timer whose expiry time is before the time which was identified as the
+nearest event in the previous call to hrtimer_stop_sched_tick.
+
+hrtimer_restart_sched_tick() is called when the CPU leaves the idle state before
+it calls schedule(). hrtimer_restart_sched_tick() resumes the periodic tick,
+which is kept active until the next call to hrtimer_stop_sched_tick().
+
+hrtimer_update_jiffies() is called from irq_enter() when an interrupt happens
+in the idle period to make sure that jiffies are up to date and the interrupt
+handler has not to deal with an eventually stale jiffy value.
+
+The dynamic tick feature provides statistical values which are exported to
+userspace via /proc/stats and can be made available for enhanced power
+management control.
+
+The implementation leaves room for further development like full tickless
+systems, where the time slice is controlled by the scheduler, variable
+frequency profiling, and a complete removal of jiffies in the future.
+
+
+Aside the current initial submission of i386 support, the patchset has been
+extended to x86_64 and ARM already. Initial (work in progress) support is also
+available for MIPS and PowerPC.
+
+	  Thomas, Ingo
+
+
+
diff --git a/Documentation/timers/hrtimers.txt b/Documentation/timers/hrtimers.txt
new file mode 100644
index 0000000..ce31f65
--- /dev/null
+++ b/Documentation/timers/hrtimers.txt
@@ -0,0 +1,178 @@
+
+hrtimers - subsystem for high-resolution kernel timers
+----------------------------------------------------
+
+This patch introduces a new subsystem for high-resolution kernel timers.
+
+One might ask the question: we already have a timer subsystem
+(kernel/timers.c), why do we need two timer subsystems? After a lot of
+back and forth trying to integrate high-resolution and high-precision
+features into the existing timer framework, and after testing various
+such high-resolution timer implementations in practice, we came to the
+conclusion that the timer wheel code is fundamentally not suitable for
+such an approach. We initially didn't believe this ('there must be a way
+to solve this'), and spent a considerable effort trying to integrate
+things into the timer wheel, but we failed. In hindsight, there are
+several reasons why such integration is hard/impossible:
+
+- the forced handling of low-resolution and high-resolution timers in
+  the same way leads to a lot of compromises, macro magic and #ifdef
+  mess. The timers.c code is very "tightly coded" around jiffies and
+  32-bitness assumptions, and has been honed and micro-optimized for a
+  relatively narrow use case (jiffies in a relatively narrow HZ range)
+  for many years - and thus even small extensions to it easily break
+  the wheel concept, leading to even worse compromises. The timer wheel
+  code is very good and tight code, there's zero problems with it in its
+  current usage - but it is simply not suitable to be extended for
+  high-res timers.
+
+- the unpredictable [O(N)] overhead of cascading leads to delays which
+  necessitate a more complex handling of high resolution timers, which
+  in turn decreases robustness. Such a design still led to rather large
+  timing inaccuracies. Cascading is a fundamental property of the timer
+  wheel concept, it cannot be 'designed out' without unevitably
+  degrading other portions of the timers.c code in an unacceptable way.
+
+- the implementation of the current posix-timer subsystem on top of
+  the timer wheel has already introduced a quite complex handling of
+  the required readjusting of absolute CLOCK_REALTIME timers at
+  settimeofday or NTP time - further underlying our experience by
+  example: that the timer wheel data structure is too rigid for high-res
+  timers.
+
+- the timer wheel code is most optimal for use cases which can be
+  identified as "timeouts". Such timeouts are usually set up to cover
+  error conditions in various I/O paths, such as networking and block
+  I/O. The vast majority of those timers never expire and are rarely
+  recascaded because the expected correct event arrives in time so they
+  can be removed from the timer wheel before any further processing of
+  them becomes necessary. Thus the users of these timeouts can accept
+  the granularity and precision tradeoffs of the timer wheel, and
+  largely expect the timer subsystem to have near-zero overhead.
+  Accurate timing for them is not a core purpose - in fact most of the
+  timeout values used are ad-hoc. For them it is at most a necessary
+  evil to guarantee the processing of actual timeout completions
+  (because most of the timeouts are deleted before completion), which
+  should thus be as cheap and unintrusive as possible.
+
+The primary users of precision timers are user-space applications that
+utilize nanosleep, posix-timers and itimer interfaces. Also, in-kernel
+users like drivers and subsystems which require precise timed events
+(e.g. multimedia) can benefit from the availability of a separate
+high-resolution timer subsystem as well.
+
+While this subsystem does not offer high-resolution clock sources just
+yet, the hrtimer subsystem can be easily extended with high-resolution
+clock capabilities, and patches for that exist and are maturing quickly.
+The increasing demand for realtime and multimedia applications along
+with other potential users for precise timers gives another reason to
+separate the "timeout" and "precise timer" subsystems.
+
+Another potential benefit is that such a separation allows even more
+special-purpose optimization of the existing timer wheel for the low
+resolution and low precision use cases - once the precision-sensitive
+APIs are separated from the timer wheel and are migrated over to
+hrtimers. E.g. we could decrease the frequency of the timeout subsystem
+from 250 Hz to 100 HZ (or even smaller).
+
+hrtimer subsystem implementation details
+----------------------------------------
+
+the basic design considerations were:
+
+- simplicity
+
+- data structure not bound to jiffies or any other granularity. All the
+  kernel logic works at 64-bit nanoseconds resolution - no compromises.
+
+- simplification of existing, timing related kernel code
+
+another basic requirement was the immediate enqueueing and ordering of
+timers at activation time. After looking at several possible solutions
+such as radix trees and hashes, we chose the red black tree as the basic
+data structure. Rbtrees are available as a library in the kernel and are
+used in various performance-critical areas of e.g. memory management and
+file systems. The rbtree is solely used for time sorted ordering, while
+a separate list is used to give the expiry code fast access to the
+queued timers, without having to walk the rbtree.
+
+(This separate list is also useful for later when we'll introduce
+high-resolution clocks, where we need separate pending and expired
+queues while keeping the time-order intact.)
+
+Time-ordered enqueueing is not purely for the purposes of
+high-resolution clocks though, it also simplifies the handling of
+absolute timers based on a low-resolution CLOCK_REALTIME. The existing
+implementation needed to keep an extra list of all armed absolute
+CLOCK_REALTIME timers along with complex locking. In case of
+settimeofday and NTP, all the timers (!) had to be dequeued, the
+time-changing code had to fix them up one by one, and all of them had to
+be enqueued again. The time-ordered enqueueing and the storage of the
+expiry time in absolute time units removes all this complex and poorly
+scaling code from the posix-timer implementation - the clock can simply
+be set without having to touch the rbtree. This also makes the handling
+of posix-timers simpler in general.
+
+The locking and per-CPU behavior of hrtimers was mostly taken from the
+existing timer wheel code, as it is mature and well suited. Sharing code
+was not really a win, due to the different data structures. Also, the
+hrtimer functions now have clearer behavior and clearer names - such as
+hrtimer_try_to_cancel() and hrtimer_cancel() [which are roughly
+equivalent to del_timer() and del_timer_sync()] - so there's no direct
+1:1 mapping between them on the algorithmical level, and thus no real
+potential for code sharing either.
+
+Basic data types: every time value, absolute or relative, is in a
+special nanosecond-resolution type: ktime_t. The kernel-internal
+representation of ktime_t values and operations is implemented via
+macros and inline functions, and can be switched between a "hybrid
+union" type and a plain "scalar" 64bit nanoseconds representation (at
+compile time). The hybrid union type optimizes time conversions on 32bit
+CPUs. This build-time-selectable ktime_t storage format was implemented
+to avoid the performance impact of 64-bit multiplications and divisions
+on 32bit CPUs. Such operations are frequently necessary to convert
+between the storage formats provided by kernel and userspace interfaces
+and the internal time format. (See include/linux/ktime.h for further
+details.)
+
+hrtimers - rounding of timer values
+-----------------------------------
+
+the hrtimer code will round timer events to lower-resolution clocks
+because it has to. Otherwise it will do no artificial rounding at all.
+
+one question is, what resolution value should be returned to the user by
+the clock_getres() interface. This will return whatever real resolution
+a given clock has - be it low-res, high-res, or artificially-low-res.
+
+hrtimers - testing and verification
+----------------------------------
+
+We used the high-resolution clock subsystem ontop of hrtimers to verify
+the hrtimer implementation details in praxis, and we also ran the posix
+timer tests in order to ensure specification compliance. We also ran
+tests on low-resolution clocks.
+
+The hrtimer patch converts the following kernel functionality to use
+hrtimers:
+
+ - nanosleep
+ - itimers
+ - posix-timers
+
+The conversion of nanosleep and posix-timers enabled the unification of
+nanosleep and clock_nanosleep.
+
+The code was successfully compiled for the following platforms:
+
+ i386, x86_64, ARM, PPC, PPC64, IA64
+
+The code was run-tested on the following platforms:
+
+ i386(UP/SMP), x86_64(UP/SMP), ARM, PPC
+
+hrtimers were also integrated into the -rt tree, along with a
+hrtimers-based high-resolution clock implementation, so the hrtimers
+code got a healthy amount of testing and use in practice.
+
+	Thomas Gleixner, Ingo Molnar
diff --git a/Documentation/timers/timer_stats.txt b/Documentation/timers/timer_stats.txt
new file mode 100644
index 0000000..20d368c
--- /dev/null
+++ b/Documentation/timers/timer_stats.txt
@@ -0,0 +1,73 @@
+timer_stats - timer usage statistics
+------------------------------------
+
+timer_stats is a debugging facility to make the timer (ab)usage in a Linux
+system visible to kernel and userspace developers. If enabled in the config
+but not used it has almost zero runtime overhead, and a relatively small
+data structure overhead. Even if collection is enabled runtime all the
+locking is per-CPU and lookup is hashed.
+
+timer_stats should be used by kernel and userspace developers to verify that
+their code does not make unduly use of timers. This helps to avoid unnecessary
+wakeups, which should be avoided to optimize power consumption.
+
+It can be enabled by CONFIG_TIMER_STATS in the "Kernel hacking" configuration
+section.
+
+timer_stats collects information about the timer events which are fired in a
+Linux system over a sample period:
+
+- the pid of the task(process) which initialized the timer
+- the name of the process which initialized the timer
+- the function where the timer was intialized
+- the callback function which is associated to the timer
+- the number of events (callbacks)
+
+timer_stats adds an entry to /proc: /proc/timer_stats
+
+This entry is used to control the statistics functionality and to read out the
+sampled information.
+
+The timer_stats functionality is inactive on bootup.
+
+To activate a sample period issue:
+# echo 1 >/proc/timer_stats
+
+To stop a sample period issue:
+# echo 0 >/proc/timer_stats
+
+The statistics can be retrieved by:
+# cat /proc/timer_stats
+
+The readout of /proc/timer_stats automatically disables sampling. The sampled
+information is kept until a new sample period is started. This allows multiple
+readouts.
+
+Sample output of /proc/timer_stats:
+
+Timerstats sample period: 3.888770 s
+  12,     0 swapper          hrtimer_stop_sched_tick (hrtimer_sched_tick)
+  15,     1 swapper          hcd_submit_urb (rh_timer_func)
+   4,   959 kedac            schedule_timeout (process_timeout)
+   1,     0 swapper          page_writeback_init (wb_timer_fn)
+  28,     0 swapper          hrtimer_stop_sched_tick (hrtimer_sched_tick)
+  22,  2948 IRQ 4            tty_flip_buffer_push (delayed_work_timer_fn)
+   3,  3100 bash             schedule_timeout (process_timeout)
+   1,     1 swapper          queue_delayed_work_on (delayed_work_timer_fn)
+   1,     1 swapper          queue_delayed_work_on (delayed_work_timer_fn)
+   1,     1 swapper          neigh_table_init_no_netlink (neigh_periodic_timer)
+   1,  2292 ip               __netdev_watchdog_up (dev_watchdog)
+   1,    23 events/1         do_cache_clean (delayed_work_timer_fn)
+90 total events, 30.0 events/sec
+
+The first column is the number of events, the second column the pid, the third
+column is the name of the process. The forth column shows the function which
+initialized the timer and in parantheses the callback function which was
+executed on expiry.
+
+    Thomas, Ingo
+
+Added flag to indicate 'deferrable timer' in /proc/timer_stats. A deferrable
+timer will appear as follows
+  10D,     1 swapper          queue_delayed_work_on (delayed_work_timer_fn)
+
diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 1ad56a7..56f3236 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -173,7 +173,6 @@ struct hrtimer_clock_base {
  * struct hrtimer_cpu_base - the per cpu clock bases
  * @lock:		lock protecting the base and associated clock bases
  *			and timers
- * @lock_key:		the lock_class_key for use with lockdep
  * @clock_base:		array of clock bases for this cpu
  * @curr_timer:		the timer which is executing a callback right now
  * @expires_next:	absolute time of the next event which was scheduled
@@ -189,7 +188,6 @@ struct hrtimer_clock_base {
  */
 struct hrtimer_cpu_base {
 	spinlock_t			lock;
-	struct lock_class_key		lock_key;
 	struct hrtimer_clock_base	clock_base[HRTIMER_MAX_CLOCK_BASES];
 	struct list_head		cb_pending;
 #ifdef CONFIG_HIGH_RES_TIMERS
diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 1129ee0..d311a09 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -296,43 +296,6 @@ do {						\
 })
 
 /*
- * Locks two spinlocks l1 and l2.
- * l1_first indicates if spinlock l1 should be taken first.
- */
-static inline void double_spin_lock(spinlock_t *l1, spinlock_t *l2,
-				    bool l1_first)
-	__acquires(l1)
-	__acquires(l2)
-{
-	if (l1_first) {
-		spin_lock(l1);
-		spin_lock(l2);
-	} else {
-		spin_lock(l2);
-		spin_lock(l1);
-	}
-}
-
-/*
- * Unlocks two spinlocks l1 and l2.
- * l1_taken_first indicates if spinlock l1 was taken first and therefore
- * should be released after spinlock l2.
- */
-static inline void double_spin_unlock(spinlock_t *l1, spinlock_t *l2,
-				      bool l1_taken_first)
-	__releases(l1)
-	__releases(l2)
-{
-	if (l1_taken_first) {
-		spin_unlock(l2);
-		spin_unlock(l1);
-	} else {
-		spin_unlock(l1);
-		spin_unlock(l2);
-	}
-}
-
-/*
  * Pull the atomic_t declaration:
  * (asm-mips/atomic.h needs above definitions)
  */
diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
index 421323e..accd7ba 100644
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -9,6 +9,9 @@
 
 #include <linux/types.h>
 
+struct timespec;
+struct compat_timespec;
+
 /*
  * System call restart block.
  */
@@ -26,6 +29,15 @@ struct restart_block {
 			u32 bitset;
 			u64 time;
 		} futex;
+		/* For nanosleep */
+		struct {
+			clockid_t index;
+			struct timespec __user *rmtp;
+#ifdef CONFIG_COMPAT
+			struct compat_timespec __user *compat_rmtp;
+#endif
+			u64 expires;
+		} nanosleep;
 	};
 };
 
diff --git a/kernel/compat.c b/kernel/compat.c
index 5f0e201..9c48abf 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -47,15 +47,14 @@ static long compat_nanosleep_restart(struct restart_block *restart)
 	mm_segment_t oldfs;
 	long ret;
 
-	rmtp = (struct compat_timespec __user *)(restart->arg1);
-	restart->arg1 = (unsigned long)&rmt;
+	restart->nanosleep.rmtp = (struct timespec __user *) &rmt;
 	oldfs = get_fs();
 	set_fs(KERNEL_DS);
 	ret = hrtimer_nanosleep_restart(restart);
 	set_fs(oldfs);
 
 	if (ret) {
-		restart->arg1 = (unsigned long)rmtp;
+		rmtp = restart->nanosleep.compat_rmtp;
 
 		if (rmtp && put_compat_timespec(&rmt, rmtp))
 			return -EFAULT;
@@ -89,7 +88,7 @@ asmlinkage long compat_sys_nanosleep(struct compat_timespec __user *rqtp,
 			= &current_thread_info()->restart_block;
 
 		restart->fn = compat_nanosleep_restart;
-		restart->arg1 = (unsigned long)rmtp;
+		restart->nanosleep.compat_rmtp = rmtp;
 
 		if (rmtp && put_compat_timespec(&rmt, rmtp))
 			return -EFAULT;
@@ -607,9 +606,9 @@ static long compat_clock_nanosleep_restart(struct restart_block *restart)
 	long err;
 	mm_segment_t oldfs;
 	struct timespec tu;
-	struct compat_timespec *rmtp = (struct compat_timespec *)(restart->arg1);
+	struct compat_timespec *rmtp = restart->nanosleep.compat_rmtp;
 
-	restart->arg1 = (unsigned long) &tu;
+	restart->nanosleep.rmtp = (struct timespec __user *) &tu;
 	oldfs = get_fs();
 	set_fs(KERNEL_DS);
 	err = clock_nanosleep_restart(restart);
@@ -621,7 +620,7 @@ static long compat_clock_nanosleep_restart(struct restart_block *restart)
 
 	if (err == -ERESTART_RESTARTBLOCK) {
 		restart->fn = compat_clock_nanosleep_restart;
-		restart->arg1 = (unsigned long) rmtp;
+		restart->nanosleep.compat_rmtp = rmtp;
 	}
 	return err;
 }
@@ -652,7 +651,7 @@ long compat_sys_clock_nanosleep(clockid_t which_clock, int flags,
 	if (err == -ERESTART_RESTARTBLOCK) {
 		restart = &current_thread_info()->restart_block;
 		restart->fn = compat_clock_nanosleep_restart;
-		restart->arg1 = (unsigned long) rmtp;
+		restart->nanosleep.compat_rmtp = rmtp;
 	}
 	return err;
 }
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 98bee01..c642ef7 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1354,13 +1354,13 @@ long __sched hrtimer_nanosleep_restart(struct restart_block *restart)
 	struct hrtimer_sleeper t;
 	struct timespec __user  *rmtp;
 
-	hrtimer_init(&t.timer, restart->arg0, HRTIMER_MODE_ABS);
-	t.timer.expires.tv64 = ((u64)restart->arg3 << 32) | (u64) restart->arg2;
+	hrtimer_init(&t.timer, restart->nanosleep.index, HRTIMER_MODE_ABS);
+	t.timer.expires.tv64 = restart->nanosleep.expires;
 
 	if (do_nanosleep(&t, HRTIMER_MODE_ABS))
 		return 0;
 
-	rmtp = (struct timespec __user *)restart->arg1;
+	rmtp = restart->nanosleep.rmtp;
 	if (rmtp) {
 		int ret = update_rmtp(&t.timer, rmtp);
 		if (ret <= 0)
@@ -1394,10 +1394,9 @@ long hrtimer_nanosleep(struct timespec *rqtp, struct timespec __user *rmtp,
 
 	restart = &current_thread_info()->restart_block;
 	restart->fn = hrtimer_nanosleep_restart;
-	restart->arg0 = (unsigned long) t.timer.base->index;
-	restart->arg1 = (unsigned long) rmtp;
-	restart->arg2 = t.timer.expires.tv64 & 0xFFFFFFFF;
-	restart->arg3 = t.timer.expires.tv64 >> 32;
+	restart->nanosleep.index = t.timer.base->index;
+	restart->nanosleep.rmtp = rmtp;
+	restart->nanosleep.expires = t.timer.expires.tv64;
 
 	return -ERESTART_RESTARTBLOCK;
 }
@@ -1425,7 +1424,6 @@ static void __cpuinit init_hrtimers_cpu(int cpu)
 	int i;
 
 	spin_lock_init(&cpu_base->lock);
-	lockdep_set_class(&cpu_base->lock, &cpu_base->lock_key);
 
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++)
 		cpu_base->clock_base[i].cpu_base = cpu_base;
@@ -1466,16 +1464,16 @@ static void migrate_hrtimers(int cpu)
 	tick_cancel_sched_timer(cpu);
 
 	local_irq_disable();
-	double_spin_lock(&new_base->lock, &old_base->lock,
-			 smp_processor_id() < cpu);
+	spin_lock(&new_base->lock);
+	spin_lock_nested(&old_base->lock, SINGLE_DEPTH_NESTING);
 
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
 		migrate_hrtimer_list(&old_base->clock_base[i],
 				     &new_base->clock_base[i]);
 	}
 
-	double_spin_unlock(&new_base->lock, &old_base->lock,
-			   smp_processor_id() < cpu);
+	spin_unlock(&old_base->lock);
+	spin_unlock(&new_base->lock);
 	local_irq_enable();
 	put_cpu_var(hrtimer_bases);
 }
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 2eae91f..ae5c6c1 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -1087,45 +1087,45 @@ static void check_process_timers(struct task_struct *tsk,
 	maxfire = 20;
 	prof_expires = cputime_zero;
 	while (!list_empty(timers)) {
-		struct cpu_timer_list *t = list_first_entry(timers,
+		struct cpu_timer_list *tl = list_first_entry(timers,
 						      struct cpu_timer_list,
 						      entry);
-		if (!--maxfire || cputime_lt(ptime, t->expires.cpu)) {
-			prof_expires = t->expires.cpu;
+		if (!--maxfire || cputime_lt(ptime, tl->expires.cpu)) {
+			prof_expires = tl->expires.cpu;
 			break;
 		}
-		t->firing = 1;
-		list_move_tail(&t->entry, firing);
+		tl->firing = 1;
+		list_move_tail(&tl->entry, firing);
 	}
 
 	++timers;
 	maxfire = 20;
 	virt_expires = cputime_zero;
 	while (!list_empty(timers)) {
-		struct cpu_timer_list *t = list_first_entry(timers,
+		struct cpu_timer_list *tl = list_first_entry(timers,
 						      struct cpu_timer_list,
 						      entry);
-		if (!--maxfire || cputime_lt(utime, t->expires.cpu)) {
-			virt_expires = t->expires.cpu;
+		if (!--maxfire || cputime_lt(utime, tl->expires.cpu)) {
+			virt_expires = tl->expires.cpu;
 			break;
 		}
-		t->firing = 1;
-		list_move_tail(&t->entry, firing);
+		tl->firing = 1;
+		list_move_tail(&tl->entry, firing);
 	}
 
 	++timers;
 	maxfire = 20;
 	sched_expires = 0;
 	while (!list_empty(timers)) {
-		struct cpu_timer_list *t = list_first_entry(timers,
+		struct cpu_timer_list *tl = list_first_entry(timers,
 						      struct cpu_timer_list,
 						      entry);
-		if (!--maxfire || sum_sched_runtime < t->expires.sched) {
-			sched_expires = t->expires.sched;
+		if (!--maxfire || sum_sched_runtime < tl->expires.sched) {
+			sched_expires = tl->expires.sched;
 			break;
 		}
-		t->firing = 1;
-		list_move_tail(&t->entry, firing);
+		tl->firing = 1;
+		list_move_tail(&tl->entry, firing);
 	}
 
 	/*
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 7f60097..912156d 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -141,8 +141,16 @@ static void clocksource_watchdog(unsigned long data)
 	}
 
 	if (!list_empty(&watchdog_list)) {
-		__mod_timer(&watchdog_timer,
-			    watchdog_timer.expires + WATCHDOG_INTERVAL);
+		/*
+		 * Cycle through CPUs to check if the CPUs stay
+		 * synchronized to each other.
+		 */
+		int next_cpu = next_cpu(raw_smp_processor_id(), cpu_online_map);
+
+		if (next_cpu >= NR_CPUS)
+			next_cpu = first_cpu(cpu_online_map);
+		watchdog_timer.expires += WATCHDOG_INTERVAL;
+		add_timer_on(&watchdog_timer, next_cpu);
 	}
 	spin_unlock(&watchdog_lock);
 }
@@ -164,7 +172,8 @@ static void clocksource_check_watchdog(struct clocksource *cs)
 		if (!started && watchdog) {
 			watchdog_last = watchdog->read();
 			watchdog_timer.expires = jiffies + WATCHDOG_INTERVAL;
-			add_timer(&watchdog_timer);
+			add_timer_on(&watchdog_timer,
+				     first_cpu(cpu_online_map));
 		}
 	} else {
 		if (cs->flags & CLOCK_SOURCE_IS_CONTINUOUS)
@@ -185,7 +194,8 @@ static void clocksource_check_watchdog(struct clocksource *cs)
 				watchdog_last = watchdog->read();
 				watchdog_timer.expires =
 					jiffies + WATCHDOG_INTERVAL;
-				add_timer(&watchdog_timer);
+				add_timer_on(&watchdog_timer,
+					     first_cpu(cpu_online_map));
 			}
 		}
 	}
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 686da82..69dba0c 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -158,9 +158,8 @@ void tick_nohz_stop_idle(int cpu)
 	}
 }
 
-static ktime_t tick_nohz_start_idle(int cpu)
+static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
 {
-	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 	ktime_t now, delta;
 
 	now = ktime_get();
@@ -201,8 +200,8 @@ void tick_nohz_stop_sched_tick(void)
 	local_irq_save(flags);
 
 	cpu = smp_processor_id();
-	now = tick_nohz_start_idle(cpu);
 	ts = &per_cpu(tick_cpu_sched, cpu);
+	now = tick_nohz_start_idle(ts);
 
 	/*
 	 * If this cpu is offline and it is the one which updates
@@ -222,7 +221,6 @@ void tick_nohz_stop_sched_tick(void)
 	if (need_resched())
 		goto end;
 
-	cpu = smp_processor_id();
 	if (unlikely(local_softirq_pending())) {
 		static int ratelimit;
 
diff --git a/kernel/timer.c b/kernel/timer.c
index b024106..f3d35d4 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1228,13 +1228,6 @@ asmlinkage long sys_sysinfo(struct sysinfo __user *info)
 	return 0;
 }
 
-/*
- * lockdep: we want to track each per-CPU base as a separate lock-class,
- * but timer-bases are kmalloc()-ed, so we need to attach separate
- * keys to them:
- */
-static struct lock_class_key base_lock_keys[NR_CPUS];
-
 static int __cpuinit init_timers_cpu(int cpu)
 {
 	int j;
@@ -1277,7 +1270,6 @@ static int __cpuinit init_timers_cpu(int cpu)
 	}
 
 	spin_lock_init(&base->lock);
-	lockdep_set_class(&base->lock, base_lock_keys + cpu);
 
 	for (j = 0; j < TVN_SIZE; j++) {
 		INIT_LIST_HEAD(base->tv5.vec + j);
@@ -1316,8 +1308,8 @@ static void __cpuinit migrate_timers(int cpu)
 	new_base = get_cpu_var(tvec_bases);
 
 	local_irq_disable();
-	double_spin_lock(&new_base->lock, &old_base->lock,
-			 smp_processor_id() < cpu);
+	spin_lock(&new_base->lock);
+	spin_lock_nested(&old_base->lock, SINGLE_DEPTH_NESTING);
 
 	BUG_ON(old_base->running_timer);
 
@@ -1330,8 +1322,8 @@ static void __cpuinit migrate_timers(int cpu)
 		migrate_timer_list(new_base, old_base->tv5.vec + i);
 	}
 
-	double_spin_unlock(&new_base->lock, &old_base->lock,
-			   smp_processor_id() < cpu);
+	spin_unlock(&old_base->lock);
+	spin_unlock(&new_base->lock);
 	local_irq_enable();
 	put_cpu_var(tvec_bases);
 }
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index ff06611..00ff4d0 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -219,6 +219,7 @@ int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 	struct timer_list *timer = &dwork->timer;
 	struct work_struct *work = &dwork->work;
 
+	timer_stats_timer_set_start_info(&dwork->timer);
 	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
 		BUG_ON(timer_pending(timer));
 		BUG_ON(!list_empty(&work->entry));
@@ -580,6 +581,7 @@ EXPORT_SYMBOL(schedule_delayed_work);
 int schedule_delayed_work_on(int cpu,
 			struct delayed_work *dwork, unsigned long delay)
 {
+	timer_stats_timer_set_start_info(&dwork->timer);
 	return queue_delayed_work_on(cpu, keventd_wq, dwork, delay);
 }
 EXPORT_SYMBOL(schedule_delayed_work_on);
