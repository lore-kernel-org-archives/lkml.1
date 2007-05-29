Return-Path: <linux-kernel-owner+w=401wt.eu-S1765440AbXE2Smv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765440AbXE2Smv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 14:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbXE2Sis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 14:38:48 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:44094 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764189AbXE2Sip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 14:38:45 -0400
Message-Id: <20070529183800.021838637@polymtl.ca>
References: <20070529183725.179570071@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 29 May 2007 14:37:29 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Adrian Bunk <bunk@stusta.de>
Subject: [patch 4/6] Linux Kernel Markers - Add kconfig menus for the marker code
Content-Disposition: inline; filename=linux-kernel-markers-kconfig-menus.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 29 May 2007 18:38:00 +0000
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
branch (see the conditional call infrastructure) is used to skip the hook stack
setup and function call when the marker is "disabled" (no probe is connected).
Further optimizations can be implemented for each architecture to make this
branch faster.

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
CC: Adrian Bunk <bunk@stusta.de>
---

 arch/alpha/Kconfig       |    2 ++
 arch/arm/Kconfig         |    2 ++
 arch/arm26/Kconfig       |    2 ++
 arch/avr32/Kconfig.debug |    7 +++++++
 arch/cris/Kconfig        |    2 ++
 arch/frv/Kconfig         |    2 ++
 arch/h8300/Kconfig       |    2 ++
 arch/i386/Kconfig        |    2 ++
 arch/ia64/Kconfig        |    2 ++
 arch/m32r/Kconfig        |    2 ++
 arch/m68k/Kconfig        |    2 ++
 arch/m68knommu/Kconfig   |    2 ++
 arch/mips/Kconfig        |    2 ++
 arch/parisc/Kconfig      |    2 ++
 arch/powerpc/Kconfig     |    2 ++
 arch/ppc/Kconfig         |    2 ++
 arch/s390/Kconfig        |    2 ++
 arch/sh/Kconfig          |    2 ++
 arch/sh64/Kconfig        |    2 ++
 arch/sparc/Kconfig       |    2 ++
 arch/sparc64/Kconfig     |    2 ++
 arch/um/Kconfig          |    2 ++
 arch/v850/Kconfig        |    2 ++
 arch/x86_64/Kconfig      |    2 ++
 arch/xtensa/Kconfig      |    2 ++
 kernel/Kconfig.marker    |    8 ++++++++
 26 files changed, 63 insertions(+)

Index: linux-2.6-lttng/arch/alpha/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/alpha/Kconfig	2007-05-17 02:12:41.000000000 -0400
+++ linux-2.6-lttng/arch/alpha/Kconfig	2007-05-17 02:13:15.000000000 -0400
@@ -646,6 +646,8 @@
 
 source "kernel/Kconfig.condcall"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/alpha/Kconfig.debug"
Index: linux-2.6-lttng/arch/arm/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/arm/Kconfig	2007-05-17 02:12:41.000000000 -0400
+++ linux-2.6-lttng/arch/arm/Kconfig	2007-05-17 02:13:15.000000000 -0400
@@ -1029,6 +1029,8 @@
 
 source "kernel/Kconfig.condcall"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/arm/Kconfig.debug"
Index: linux-2.6-lttng/arch/arm26/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/arm26/Kconfig	2007-05-17 02:12:41.000000000 -0400
+++ linux-2.6-lttng/arch/arm26/Kconfig	2007-05-17 02:13:15.000000000 -0400
@@ -245,6 +245,8 @@
 
 source "kernel/Kconfig.condcall"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/arm26/Kconfig.debug"
Index: linux-2.6-lttng/arch/cris/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/cris/Kconfig	2007-05-17 02:12:41.000000000 -0400
+++ linux-2.6-lttng/arch/cris/Kconfig	2007-05-17 02:13:15.000000000 -0400
@@ -202,6 +202,8 @@
 
 source "kernel/Kconfig.condcall"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/cris/Kconfig.debug"
Index: linux-2.6-lttng/arch/frv/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/frv/Kconfig	2007-05-17 02:12:41.000000000 -0400
+++ linux-2.6-lttng/arch/frv/Kconfig	2007-05-17 02:13:15.000000000 -0400
@@ -389,6 +389,8 @@
 
 source "kernel/Kconfig.condcall"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/frv/Kconfig.debug"
Index: linux-2.6-lttng/arch/h8300/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/h8300/Kconfig	2007-05-17 02:12:41.000000000 -0400
+++ linux-2.6-lttng/arch/h8300/Kconfig	2007-05-17 02:13:15.000000000 -0400
@@ -224,6 +224,8 @@
 
 source "kernel/Kconfig.condcall"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/h8300/Kconfig.debug"
Index: linux-2.6-lttng/arch/i386/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/i386/Kconfig	2007-05-17 02:12:41.000000000 -0400
+++ linux-2.6-lttng/arch/i386/Kconfig	2007-05-17 02:13:15.000000000 -0400
@@ -1232,6 +1232,8 @@
 
 source "kernel/Kconfig.condcall"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/i386/Kconfig.debug"
Index: linux-2.6-lttng/arch/ia64/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/ia64/Kconfig	2007-05-17 02:12:41.000000000 -0400
+++ linux-2.6-lttng/arch/ia64/Kconfig	2007-05-17 02:13:15.000000000 -0400
@@ -594,6 +594,8 @@
 
 source "kernel/Kconfig.condcall"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/ia64/Kconfig.debug"
Index: linux-2.6-lttng/arch/m32r/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/m32r/Kconfig	2007-05-17 02:12:41.000000000 -0400
+++ linux-2.6-lttng/arch/m32r/Kconfig	2007-05-17 02:13:15.000000000 -0400
@@ -405,6 +405,8 @@
 
 source "kernel/Kconfig.condcall"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/m32r/Kconfig.debug"
Index: linux-2.6-lttng/arch/m68k/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/m68k/Kconfig	2007-05-17 02:12:41.000000000 -0400
+++ linux-2.6-lttng/arch/m68k/Kconfig	2007-05-17 02:13:15.000000000 -0400
@@ -674,6 +674,8 @@
 
 source "kernel/Kconfig.condcall"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/m68k/Kconfig.debug"
Index: linux-2.6-lttng/arch/m68knommu/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/m68knommu/Kconfig	2007-05-17 02:12:41.000000000 -0400
+++ linux-2.6-lttng/arch/m68knommu/Kconfig	2007-05-17 02:13:15.000000000 -0400
@@ -680,6 +680,8 @@
 
 source "kernel/Kconfig.condcall"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/m68knommu/Kconfig.debug"
Index: linux-2.6-lttng/arch/mips/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/mips/Kconfig	2007-05-17 02:12:41.000000000 -0400
+++ linux-2.6-lttng/arch/mips/Kconfig	2007-05-17 02:13:15.000000000 -0400
@@ -2154,6 +2154,8 @@
 
 source "kernel/Kconfig.condcall"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/mips/Kconfig.debug"
Index: linux-2.6-lttng/arch/parisc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/parisc/Kconfig	2007-05-17 02:12:41.000000000 -0400
+++ linux-2.6-lttng/arch/parisc/Kconfig	2007-05-17 02:13:15.000000000 -0400
@@ -273,6 +273,8 @@
 
 source "kernel/Kconfig.condcall"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/parisc/Kconfig.debug"
Index: linux-2.6-lttng/arch/powerpc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/Kconfig	2007-05-17 02:12:41.000000000 -0400
+++ linux-2.6-lttng/arch/powerpc/Kconfig	2007-05-17 02:13:15.000000000 -0400
@@ -905,6 +905,8 @@
 
 source "kernel/Kconfig.condcall"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/powerpc/Kconfig.debug"
Index: linux-2.6-lttng/arch/ppc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/ppc/Kconfig	2007-05-17 02:12:41.000000000 -0400
+++ linux-2.6-lttng/arch/ppc/Kconfig	2007-05-17 02:13:15.000000000 -0400
@@ -1459,6 +1459,8 @@
 
 source "kernel/Kconfig.condcall"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/ppc/Kconfig.debug"
Index: linux-2.6-lttng/arch/s390/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/s390/Kconfig	2007-05-17 02:12:41.000000000 -0400
+++ linux-2.6-lttng/arch/s390/Kconfig	2007-05-17 02:13:15.000000000 -0400
@@ -571,6 +571,8 @@
 
 source "kernel/Kconfig.condcall"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/s390/Kconfig.debug"
Index: linux-2.6-lttng/arch/sh/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sh/Kconfig	2007-05-17 02:12:41.000000000 -0400
+++ linux-2.6-lttng/arch/sh/Kconfig	2007-05-17 02:13:15.000000000 -0400
@@ -742,6 +742,8 @@
 
 source "kernel/Kconfig.condcall"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/sh/Kconfig.debug"
Index: linux-2.6-lttng/arch/sh64/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sh64/Kconfig	2007-05-17 02:12:41.000000000 -0400
+++ linux-2.6-lttng/arch/sh64/Kconfig	2007-05-17 02:13:15.000000000 -0400
@@ -285,6 +285,8 @@
 
 source "kernel/Kconfig.condcall"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/sh64/Kconfig.debug"
Index: linux-2.6-lttng/arch/sparc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sparc/Kconfig	2007-05-17 02:12:41.000000000 -0400
+++ linux-2.6-lttng/arch/sparc/Kconfig	2007-05-17 02:13:15.000000000 -0400
@@ -308,6 +308,8 @@
 
 source "kernel/Kconfig.condcall"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/sparc/Kconfig.debug"
Index: linux-2.6-lttng/arch/sparc64/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sparc64/Kconfig	2007-05-17 02:12:41.000000000 -0400
+++ linux-2.6-lttng/arch/sparc64/Kconfig	2007-05-17 02:13:15.000000000 -0400
@@ -447,6 +447,8 @@
 
 source "kernel/Kconfig.condcall"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/sparc64/Kconfig.debug"
Index: linux-2.6-lttng/arch/um/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/um/Kconfig	2007-05-17 02:12:41.000000000 -0400
+++ linux-2.6-lttng/arch/um/Kconfig	2007-05-17 02:13:15.000000000 -0400
@@ -337,6 +337,8 @@
 
 source "kernel/Kconfig.condcall"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/um/Kconfig.debug"
Index: linux-2.6-lttng/arch/v850/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/v850/Kconfig	2007-05-17 02:12:41.000000000 -0400
+++ linux-2.6-lttng/arch/v850/Kconfig	2007-05-17 02:13:15.000000000 -0400
@@ -343,6 +343,8 @@
 
 source "kernel/Kconfig.condcall"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/v850/Kconfig.debug"
Index: linux-2.6-lttng/arch/x86_64/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/x86_64/Kconfig	2007-05-17 02:12:41.000000000 -0400
+++ linux-2.6-lttng/arch/x86_64/Kconfig	2007-05-17 02:13:15.000000000 -0400
@@ -793,6 +793,8 @@
 
 source "kernel/Kconfig.condcall"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/x86_64/Kconfig.debug"
Index: linux-2.6-lttng/arch/xtensa/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/xtensa/Kconfig	2007-05-17 02:12:41.000000000 -0400
+++ linux-2.6-lttng/arch/xtensa/Kconfig	2007-05-17 02:13:15.000000000 -0400
@@ -255,6 +255,8 @@
 
 source "kernel/Kconfig.condcall"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/xtensa/Kconfig.debug"
Index: linux-2.6-lttng/kernel/Kconfig.marker
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/kernel/Kconfig.marker	2007-05-17 02:12:41.000000000 -0400
@@ -0,0 +1,8 @@
+# Code markers configuration
+
+config MARKERS
+	bool "Activate markers"
+	depends on MODULES && COND_CALL
+	help
+	  Place an empty function call at each marker site. Can be
+	  dynamically changed for a probe function.
Index: linux-2.6-lttng/arch/avr32/Kconfig.debug
===================================================================
--- linux-2.6-lttng.orig/arch/avr32/Kconfig.debug	2007-05-17 02:12:41.000000000 -0400
+++ linux-2.6-lttng/arch/avr32/Kconfig.debug	2007-05-17 02:13:15.000000000 -0400
@@ -9,6 +9,9 @@
 menu "Instrumentation Support"
 	depends on EXPERIMENTAL
 
+menu "Instrumentation Support"
+	depends on EXPERIMENTAL
+
 config KPROBES
 	bool "Kprobes"
 	depends on DEBUG_KERNEL
@@ -22,6 +25,10 @@
 
 source "kernel/Kconfig.condcall"
 
+source "kernel/Kconfig.marker"
+
+endmenu
+
 endmenu
 
 endmenu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
