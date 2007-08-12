Return-Path: <linux-kernel-owner+w=401wt.eu-S937146AbXHLPUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937146AbXHLPUM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 11:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936602AbXHLPNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 11:13:15 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:48033 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936343AbXHLPNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 11:13:07 -0400
Message-Id: <20070812151220.683232839@polymtl.ca>
References: <20070812151052.704221166@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sun, 12 Aug 2007 11:10:54 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Adrian Bunk <bunk@stusta.de>
Subject: [patch 2/4] Linux Kernel Markers - Add kconfig menus for the marker code
Content-Disposition: inline; filename=linux-kernel-markers-kconfig-menus.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sun, 12 Aug 2007 15:12:21 +0000
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
 kernel/Kconfig.marker    |    7 +++++++
 kernel/Makefile          |    1 +
 26 files changed, 61 insertions(+)

Index: linux-2.6-lttng/arch/alpha/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/alpha/Kconfig	2007-08-07 11:00:43.000000000 -0400
+++ linux-2.6-lttng/arch/alpha/Kconfig	2007-08-07 11:43:11.000000000 -0400
@@ -646,6 +646,8 @@ config SRM_ENV
 
 source "fs/Kconfig.binfmt"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "net/Kconfig"
Index: linux-2.6-lttng/arch/arm/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/arm/Kconfig	2007-08-07 11:03:18.000000000 -0400
+++ linux-2.6-lttng/arch/arm/Kconfig	2007-08-07 11:43:11.000000000 -0400
@@ -1052,6 +1052,8 @@ source "drivers/rtc/Kconfig"
 
 source "drivers/dma/Kconfig"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "fs/Kconfig"
Index: linux-2.6-lttng/arch/cris/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/cris/Kconfig	2007-08-07 10:47:43.000000000 -0400
+++ linux-2.6-lttng/arch/cris/Kconfig	2007-08-07 11:43:11.000000000 -0400
@@ -151,6 +151,8 @@ source "net/Kconfig"
 menu "Drivers for built-in interfaces"
 source arch/cris/arch-v10/drivers/Kconfig
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "drivers/base/Kconfig"
Index: linux-2.6-lttng/arch/frv/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/frv/Kconfig	2007-08-07 11:00:43.000000000 -0400
+++ linux-2.6-lttng/arch/frv/Kconfig	2007-08-07 11:43:11.000000000 -0400
@@ -367,6 +367,8 @@ menu "Executable formats"
 
 source "fs/Kconfig.binfmt"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "net/Kconfig"
Index: linux-2.6-lttng/arch/h8300/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/h8300/Kconfig	2007-08-07 11:00:43.000000000 -0400
+++ linux-2.6-lttng/arch/h8300/Kconfig	2007-08-07 11:43:11.000000000 -0400
@@ -219,6 +219,8 @@ source "drivers/hwmon/Kconfig"
 
 source "drivers/usb/Kconfig"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "fs/Kconfig"
Index: linux-2.6-lttng/arch/i386/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/i386/Kconfig	2007-08-07 11:03:46.000000000 -0400
+++ linux-2.6-lttng/arch/i386/Kconfig	2007-08-07 11:43:11.000000000 -0400
@@ -1258,6 +1258,8 @@ config KPROBES
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
 
+source "kernel/Kconfig.marker"
+
 endif # INSTRUMENTATION
 
 source "arch/i386/Kconfig.debug"
Index: linux-2.6-lttng/arch/ia64/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/ia64/Kconfig	2007-08-07 11:03:46.000000000 -0400
+++ linux-2.6-lttng/arch/ia64/Kconfig	2007-08-07 11:43:11.000000000 -0400
@@ -549,6 +549,8 @@ source "drivers/pci/hotplug/Kconfig"
 
 source "drivers/pcmcia/Kconfig"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 endif
Index: linux-2.6-lttng/arch/m32r/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/m32r/Kconfig	2007-08-07 11:00:44.000000000 -0400
+++ linux-2.6-lttng/arch/m32r/Kconfig	2007-08-07 11:43:11.000000000 -0400
@@ -398,6 +398,8 @@ menu "Executable file formats"
 
 source "fs/Kconfig.binfmt"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "net/Kconfig"
Index: linux-2.6-lttng/arch/m68k/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/m68k/Kconfig	2007-08-07 11:00:44.000000000 -0400
+++ linux-2.6-lttng/arch/m68k/Kconfig	2007-08-07 11:43:11.000000000 -0400
@@ -679,6 +679,8 @@ config SERIAL_CONSOLE
 
 	  If unsure, say N.
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "fs/Kconfig"
Index: linux-2.6-lttng/arch/m68knommu/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/m68knommu/Kconfig	2007-08-07 11:03:18.000000000 -0400
+++ linux-2.6-lttng/arch/m68knommu/Kconfig	2007-08-07 11:43:11.000000000 -0400
@@ -673,6 +673,8 @@ source "drivers/pcmcia/Kconfig"
 
 source "drivers/pci/hotplug/Kconfig"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 menu "Executable file formats"
Index: linux-2.6-lttng/arch/mips/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/mips/Kconfig	2007-08-07 11:03:37.000000000 -0400
+++ linux-2.6-lttng/arch/mips/Kconfig	2007-08-07 11:43:11.000000000 -0400
@@ -1947,6 +1947,8 @@ menu "Power management options"
 
 source "kernel/power/Kconfig"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "net/Kconfig"
Index: linux-2.6-lttng/arch/parisc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/parisc/Kconfig	2007-08-07 10:47:43.000000000 -0400
+++ linux-2.6-lttng/arch/parisc/Kconfig	2007-08-07 11:43:11.000000000 -0400
@@ -259,6 +259,8 @@ menu "Executable file formats"
 
 source "fs/Kconfig.binfmt"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "net/Kconfig"
Index: linux-2.6-lttng/arch/powerpc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/Kconfig	2007-08-07 11:03:46.000000000 -0400
+++ linux-2.6-lttng/arch/powerpc/Kconfig	2007-08-07 11:43:11.000000000 -0400
@@ -502,6 +502,8 @@ source "drivers/pcmcia/Kconfig"
 
 source "drivers/pci/hotplug/Kconfig"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 menu "Advanced setup"
Index: linux-2.6-lttng/arch/ppc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/ppc/Kconfig	2007-08-07 11:00:45.000000000 -0400
+++ linux-2.6-lttng/arch/ppc/Kconfig	2007-08-07 11:43:11.000000000 -0400
@@ -1449,6 +1449,8 @@ config SERIAL_SICC_CONSOLE
 	depends on SERIAL_SICC && UART0_TTYS1
 	default y
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "lib/Kconfig"
Index: linux-2.6-lttng/arch/s390/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/s390/Kconfig	2007-08-07 11:00:45.000000000 -0400
+++ linux-2.6-lttng/arch/s390/Kconfig	2007-08-07 11:43:11.000000000 -0400
@@ -547,6 +547,8 @@ config KPROBES
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/s390/Kconfig.debug"
Index: linux-2.6-lttng/arch/sh/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sh/Kconfig	2007-08-07 11:03:32.000000000 -0400
+++ linux-2.6-lttng/arch/sh/Kconfig	2007-08-07 11:43:11.000000000 -0400
@@ -722,6 +722,8 @@ depends on EXPERIMENTAL && SYS_SUPPORTS_
 
 source kernel/power/Kconfig
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "net/Kconfig"
Index: linux-2.6-lttng/arch/sh64/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sh64/Kconfig	2007-08-07 11:03:18.000000000 -0400
+++ linux-2.6-lttng/arch/sh64/Kconfig	2007-08-07 11:43:11.000000000 -0400
@@ -277,6 +277,8 @@ menu "Executable file formats"
 
 source "fs/Kconfig.binfmt"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "net/Kconfig"
Index: linux-2.6-lttng/arch/sparc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sparc/Kconfig	2007-08-07 11:03:46.000000000 -0400
+++ linux-2.6-lttng/arch/sparc/Kconfig	2007-08-07 11:43:11.000000000 -0400
@@ -316,6 +316,8 @@ config UNIX98_PTY_COUNT
 	  When not in use, each additional set of 256 PTYs occupy
 	  approximately 8 KB of kernel memory on 32-bit architectures.
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "fs/Kconfig"
Index: linux-2.6-lttng/arch/sparc64/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sparc64/Kconfig	2007-08-07 11:03:46.000000000 -0400
+++ linux-2.6-lttng/arch/sparc64/Kconfig	2007-08-07 11:43:11.000000000 -0400
@@ -419,6 +419,8 @@ config SOLARIS_EMUL
 	  To compile this code as a module, choose M here: the
 	  module will be called solaris.
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 config SCHED_SMT
Index: linux-2.6-lttng/arch/um/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/um/Kconfig	2007-08-07 11:00:46.000000000 -0400
+++ linux-2.6-lttng/arch/um/Kconfig	2007-08-07 11:43:11.000000000 -0400
@@ -296,6 +296,8 @@ config UML_REAL_TIME_CLOCK
 	up for the time spent at the breakpoint.  This could result in a
 	noticeable lag.  If this is a problem, then disable this option.
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "init/Kconfig"
Index: linux-2.6-lttng/arch/v850/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/v850/Kconfig	2007-08-07 11:00:46.000000000 -0400
+++ linux-2.6-lttng/arch/v850/Kconfig	2007-08-07 11:43:11.000000000 -0400
@@ -294,6 +294,8 @@ source "drivers/ide/Kconfig"
 
 source "drivers/scsi/Kconfig"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 #############################################################################
Index: linux-2.6-lttng/arch/x86_64/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/x86_64/Kconfig	2007-08-07 11:03:53.000000000 -0400
+++ linux-2.6-lttng/arch/x86_64/Kconfig	2007-08-07 11:43:11.000000000 -0400
@@ -817,6 +817,8 @@ config SYSVIPC_COMPAT
 	depends on COMPAT && SYSVIPC
 	default y
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "net/Kconfig"
Index: linux-2.6-lttng/arch/xtensa/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/xtensa/Kconfig	2007-08-07 10:47:43.000000000 -0400
+++ linux-2.6-lttng/arch/xtensa/Kconfig	2007-08-07 11:43:11.000000000 -0400
@@ -226,6 +226,8 @@ config KCORE_ELF
 
 source "fs/Kconfig.binfmt"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "net/Kconfig"
Index: linux-2.6-lttng/kernel/Kconfig.marker
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/kernel/Kconfig.marker	2007-08-07 11:43:11.000000000 -0400
@@ -0,0 +1,7 @@
+# Code markers configuration
+
+config MARKERS
+	bool "Activate markers"
+	help
+	  Place an empty function call at each marker site. Can be
+	  dynamically changed for a probe function.
Index: linux-2.6-lttng/arch/avr32/Kconfig.debug
===================================================================
--- linux-2.6-lttng.orig/arch/avr32/Kconfig.debug	2007-08-07 10:47:43.000000000 -0400
+++ linux-2.6-lttng/arch/avr32/Kconfig.debug	2007-08-07 11:43:11.000000000 -0400
@@ -6,6 +6,9 @@ config TRACE_IRQFLAGS_SUPPORT
 
 source "lib/Kconfig.debug"
 
+menu "Instrumentation Support"
+	depends on EXPERIMENTAL
+
 config KPROBES
 	bool "Kprobes"
 	depends on DEBUG_KERNEL
@@ -16,4 +19,8 @@ config KPROBES
           for kernel debugging, non-intrusive instrumentation and testing.
           If in doubt, say "N".
 
+source "kernel/Kconfig.marker"
+
+endmenu
+
 endmenu
Index: linux-2.6-lttng/kernel/Makefile
===================================================================
--- linux-2.6-lttng.orig/kernel/Makefile	2007-08-07 11:40:25.000000000 -0400
+++ linux-2.6-lttng/kernel/Makefile	2007-08-07 11:43:11.000000000 -0400
@@ -58,6 +58,7 @@ obj-$(CONFIG_SYSCTL) += utsname_sysctl.o
 obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
 obj-$(CONFIG_IMMEDIATE) += immediate.o
+obj-$(CONFIG_MARKERS) += marker.o
 
 ifneq ($(CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
