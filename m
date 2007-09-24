Return-Path: <linux-kernel-owner+w=401wt.eu-S1765121AbXIXRT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765121AbXIXRT4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 13:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762029AbXIXRTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 13:19:19 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:45314 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760998AbXIXRTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 13:19:18 -0400
Message-Id: <20070924165428.009275376@polymtl.ca>
References: <20070924164950.006047409@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Mon, 24 Sep 2007 12:49:55 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "Frank Ch. Eigler" <fche@redhat.com>, Adrian Bunk <bunk@stusta.de>
Subject: [patch 5/7] Linux Kernel Markers - Use instrumentation kconfig menu
Content-Disposition: inline; filename=linux-kernel-markers-instrumentation-menu.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Mon, 24 Sep 2007 17:18:43 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With the increasing complexity of today's user-space application and the wide
deployment of SMP systems, the users need an increasing understanding of the
behavior and performance of a system across multiple processes/different
execution contexts/multiple CPUs.  In applications such as large clusters
(Google, IBM), video acquisition (Autodesk), embedded real-time systems (Wind
River, Monta Vista, Sony) or sysadmin/programmer-type tasks (SystemTAP from
Redhat), a tool that permits tracing of kernel-user space interaction becomes
necessary.

Usage of such tools have been made to successfully pinpoint problems such as:
latency issues in a user-space video acquisition application, slowdown
problems in large clusters due to a switch to a different filesystems with a
different cache size, abnormal Linux scheduler latency (just to name a few
that I have personally investigated).

The currently existing solutions does not give a system-wide overview of what
- and when - things are happening on the system.  Ptracing a program works
with few processes, but quickly becomes useless when it comes to keeping track
of many processes.

Bugs occuring because of bad interaction of such complex systems can be very
hard to find due to the fact that they occur rarely (sometimes once a week on
hundreds of machines).  One can therefore only hope at having the best
conditions to statistically reproduce the bug while extracting information
from the system.  Some bugs have been successfully found at Google using their
ktrace tracer only because they could enable it on production machines and
therefore recreate the same context where the bug happened.

Therefore, it makes sense to offer an instrumentation set of the most relevant
events occurring in the Linux that can have the smallest performance cost
possible when not active while not requiring a reboot of a production system
to activate.  This is essentially what the markers are providing.

Since we cannot limit the growth of the Linux kernel, nor can we pre-determine
each and every "interesting" instrumentation within each subsystem and driver,
it is sensible to let this task to the persons who knows the best their code. 
Adding instrumentation should therefore be as easy as adding and maintaining a
"printk" in the kernel code from the developer's point of view.

Towards a complete tracing mechanism in the Linux kernel, the markers are only
one step forward.  The following step is to connect probes to those markers
that will record the tracing information in buffers exported to user-space,
organized in timestamped "events".  Probe callbacks are responsible for
serializing the information passed as parameter to the markers (described by
the format string) into the events.  A control mechanism to activate/stop the
tracing is required, as well as a daemon that maps the buffers to write them
to disk or send them through the network.

Keeping track of the events also requires a centralized infrastructure : the
idea is to assign a unique ID to each event so they can be later recognized in
the trace.  Keeping in mind that recording the complete instrumentation site
name string for each event would be more that inefficient, assigning a numeric
unique identifier makes sense.

Finally, support for gathering events coming from user-space, with a minimal
performance impact, is very useful to see the interaction between the system's
execution contexts.

The last steps are currently implemented in Linux Trace Toolkit Next
Generation (LTTng).

The SystemTAP project could clearly benefit from such an infrastructure for
tracing.  In addition, they would be providing support for dynamic addition of
kernel probes through breakpoints/jumps when possible, with the associated
restrictions (accessing local variables, reentrancy, speed).




This marker infrastructure is a hook-callback mechanism.  It is meant to have
an impact as low as possible on the system performances when no callback
(probe) is connected so markers (hooks) can be compiled into a production
kernel without noticeable slowdown.

Why use the markers instead of kprobes?

The rationale behind this mechanism the following :

1 - It makes sense to have instrumentation (for tracing, profiling)
    within the kernel source tree so that it can follow its evolution.
    Other options, such as kprobes, imply maintaining an external set of
    instrumentation that must be adapted to each kernel version.
    Although it may make sense for distributions, it is not well suited
    for kernel developers, since they rarely work on a major
    distribution image.
2 - kprobes, although being a very good attempt at providing a dynamic
    hooking mechanism that has no impact when disabled, suffers from
    important limitations :
  a - It cannot access local variables of a function at a particular
      point within its body that will be consistent thorough the kernel
      versions without involving a lot of recurrent hair-pulling.
  b - Kprobes is slow, since it involves going though a trap each time
      a probe site is executed. Even though the djprobes project made a
      good effort to make things faster, it cannot currently instrument
      fully-preemptible kernels and does not solve (1), (2a) and (2c).
  c - On the reentrancy side, going though a trap (thus playing with
      interrupt enable/disable) and taking spinlocks are not suited to
      some code paths, i.e. :
      kernel/lockdep.c, printk (within the lockdep_on()/lockdep_off()).
      It must be understood that some code paths interesting for
      instrumentation often present a particular reentrancy challenge.

Some more details :

The probe callback connection to its markers is done dynamically.  A predicted
branch (see the immediate values infrastructure) is used to skip the hook stack
setup and function call when the marker is "disabled" (no probe is connected).
Further optimizations can be implemented for each architecture to make this
branch faster. (see immediate values)

Instrumentation of a subsystem becomes therefore a straightforward task.  One
has to add instrumentation within the key locations of the kernel code in the
following form :

trace_mark(subsystem_event, "%d %p", myint, myptr);


Jim Keniston <jkenisto@us.ibm.com> adds:

kprobes remains a vital foundation for SystemTap.  But markers are attactive
as an alternate source of trace/debug info.  Here's why:

1. Markers will live in the kernel and presumably be kept up to date by
   the maintainers of the enclosing code.  We have a growing set of tapsets
   (probe libraries), each of which "knows" the source code for a certain area
   of the kernel.  Whenever the underlying kernel code changes (e.g., a
   function or one of its args disappears or is renamed), there's a chance
   that the tapset will become invalid until we bring it back in sync with the
   kernel.  As you can imagine, maintaining tapsets separate from the kernel
   source is a maintenance headache.  Markers could mitigate this.

2. Because the kernel code is highly optimized, the kernel's dwarf info
   doesn't always accurately reflect which variables have which values on
   which lines (sometimes even upon entry to a function).  A marker is a way
   to ensure that values of interest are available to SystemTap at marked
   points.

3. Sometimes the overhead of a kprobe probepoint is too much (either in
   terms of time or locking) for the particular hotspot we want to probe.


In OLS2006 proceedings, vol. 1
http://www.linuxsymposium.org/2006/linuxsymposium_procv1.pdf

Frank C. Eigler, from SystemTAP, presents its "static probing markers"
(pp. 261-268) in his paper "Problem Solving With Systemtap".

He explains the advantages :

"In exchange for this effort, systemtap marker-based probes are faster and
 more precise than kprobes.  The better precision comes from not having to
 covet the compiler's favours.  Such fickle favours include retaining
 clean boundaries in the instruction stream between interesting statements,
 and precisely describing positions of variables in the stack frame.  Since
 markers don't rely on debugging information, neither favour is required,
 and the compiler can channel its charms into unabated optimization.  The
 speed advantage comes from using direct call instructions rather than int 3
 breakpoints to dispatch to the systemtap handlers.  We will see below just
 how big a difference this makes."

He does a comparison of his "simple" marker solution with kprobes (his simple
solution looks like my generic markers, but with a major race condition).  I
also posted numbers about the markers performance impact a few months ago in
the initial thread.  I can dig into my emails to find them for you if you
consider it important for the Changelog.

He concludes with :

"To the extent that is true, we propose that these groups consider using a
 shared pool of static markers as the basic kernel-side instrumentation
 mechanism.  If they prove to have as low dormant cost and as high active
 performance as initial experience suggests, perhaps this could motivate the
 various tracing efforts and kernel subsystem developers to finally join
 forces.  Let's designate standard trace/probe points once and for all. 
 Tracing backends can attach to these markers the same way systemtap would. 
 There would be no need for them to maintain kernel patches any more. 
 Let's think about it."


This patch:

Add Kconfig menus for the marker code.

[bunk@stusta.de: Never ever select MODULES]
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Acked-by: "Frank Ch. Eigler" <fche@redhat.com>
CC: Christoph Hellwig <hch@infradead.org>
CC: Adrian Bunk <bunk@stusta.de>
---
 kernel/Kconfig.instrumentation |   13 +++++++++++--
 kernel/Makefile                |    1 +
 2 files changed, 12 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng/kernel/Kconfig.instrumentation
===================================================================
--- linux-2.6-lttng.orig/kernel/Kconfig.instrumentation	2007-09-21 14:22:07.000000000 -0400
+++ linux-2.6-lttng/kernel/Kconfig.instrumentation	2007-09-21 14:27:42.000000000 -0400
@@ -3,9 +3,12 @@ menuconfig INSTRUMENTATION
 	default y
 	---help---
 	  Say Y here to get to see options related to performance measurement,
-	  debugging, and testing. This option alone does not add any kernel code.
+	  system-wide debugging, and testing. This option alone does not add any
+	  kernel code.
 
-	  If you say N, all options in this submenu will be skipped and disabled.
+	  If you say N, all options in this submenu will be skipped and
+	  disabled. If you're trying to debug the kernel itself, go see the
+	  Kernel Hacking menu.
 
 if INSTRUMENTATION
 
@@ -37,4 +40,10 @@ config KPROBES
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
 
+config MARKERS
+	bool "Activate markers"
+	help
+	  Place an empty function call at each marker site. Can be
+	  dynamically changed for a probe function.
+
 endif # INSTRUMENTATION
Index: linux-2.6-lttng/kernel/Makefile
===================================================================
--- linux-2.6-lttng.orig/kernel/Makefile	2007-09-21 14:19:51.000000000 -0400
+++ linux-2.6-lttng/kernel/Makefile	2007-09-21 14:28:01.000000000 -0400
@@ -61,6 +61,7 @@ obj-$(CONFIG_SYSCTL) += utsname_sysctl.o
 obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
 obj-$(CONFIG_RESOURCE_COUNTERS) += res_counter.o
+obj-$(CONFIG_MARKERS) += marker.o
 
 ifneq ($(CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
