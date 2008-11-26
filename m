Return-Path: <linux-kernel-owner+w=401wt.eu-S1750932AbYKZIu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750932AbYKZIu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 03:50:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753496AbYKZInH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 03:43:07 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:25617 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160AbYKZInC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 03:43:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:from:date:message-id;
        b=tC+xsb8pNUqXX2fYCflH5u+eVtigwtGh3SYv+VKfbTFBPdFF583FktJEOFr9zkqA2A
         E7q9fLSsxP1Z6BmEItqnCCi1gEDn6ALuRtBwDPTQSHjOBaqFxmq1R+7yooj16itNpwn5
         zwTU1+5u9/GxSXSlseqV8zvNZdvvs6JO1yWeM=
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu, x86@kernel.org,
       andi@firstfloor.org, eranian@gmail.com, sfr@canb.auug.org.au
Subject: [patch 23/24] perfmon: kernel documentation
From: eranian@googlemail.com
Date: Wed, 26 Nov 2008 00:43:00 -0800 (PST)
Message-ID: <492d0c14.02225e0a.15ab.6f8e@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the perfmon interface documentation text file
under Documentation.

Signed-off-by: Stephane Eranian <eranian@gmail.com>
--

Index: o3/Documentation/perfmon.txt
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ o3/Documentation/perfmon.txt	2008-10-16 12:25:49.000000000 +0200
@@ -0,0 +1,206 @@
+              The perfmon hardware monitoring interface
+              ------------------------------------------
+		           Stephane Eranian
+			  <eranian@gmail.com>
+
+I/ Introduction
+
+   The perfmon interface provides access to the hardware performance counters
+   of major processors. Nowadays, all processors implement some flavor of
+   performance counters which capture micro-architectural level information
+   such as the number of elapsed cycles, number of cache misses, and so on.
+
+   The interface is implemented as a set of new system calls and a set of
+   config files in /sys.
+
+   It is possible to monitor a single thread or a CPU. In either mode,
+   applications can count or sample. System-wide monitoring is supported by
+   running a monitoring session on each CPU. The interface supports event-based
+   sampling where the sampling period is expressed as the number of occurrences
+   of event, instead of just a timeout. This approach provides a better
+   granularity and flexibility.
+
+   For performance reason, it is possible to use a kernel-level sampling buffer
+   to minimize the overhead incurred by sampling. The format of the buffer,
+   what is recorded, how it is recorded, and how it is exported to user is
+   controlled by a kernel module called a sampling format. The current
+   implementation comes with a default format but it is possible to create
+   additional formats. There is an kernel registration interface for formats.
+   Each format is identified by a simple string which a tool can pass when a
+   monitoring session is created.
+
+   The interface also provides support for event set and multiplexing to work
+   around hardware limitations in the number of available counters or in how
+   events can be combined. Each set defines as many counters as the hardware
+   can support. The kernel then multiplexes the sets. The interface supports
+   time-based switching but also overflow-based switching, i.e., after n
+   overflows of designated counters.
+
+   Applications never manipulates the actual performance counter registers.
+   Instead they see a logical Performance Monitoring Unit (PMU) composed of a
+   set of config registers (PMC) and a set of data registers (PMD). Note that
+   PMD are not necessarily counters, they can be buffers. The logical PMU is
+   then mapped onto the actual PMU using a mapping table which is implemented
+   as a kernel module. The mapping is chosen once for each new processor. It is
+   visible in /sys/kernel/perfmon/pmu_desc. The kernel module is automatically
+   loaded on first use.
+
+   A monitoring session is uniquely identified by a file descriptor obtained
+   when the session is created. File sharing semantics apply to access the
+   session inside a process. A session is never inherited across fork. The file
+   descriptor can be used to receive counter overflow notifications or when the
+   sampling buffer is full. It is possible to use poll/select on the descriptor
+   to wait for notifications from multiple sessions. Similarly, the descriptor
+   supports asynchronous notifications via SIGIO.
+
+   Counters are always exported as being 64-bit wide regardless of what the
+   underlying hardware implements.
+
+II/ Kernel compilation
+
+    To enable perfmon, you need to enable CONFIG_PERFMON and also some of the
+    model-specific PMU modules.
+
+III/ OProfile interactions
+
+    The set of features offered by perfmon is rich enough to support migrating
+    Oprofile on top of it. That means that PMU programming and low-level
+    interrupt handling could be done by perfmon. The Oprofile sampling buffer
+    management code in the kernel as well as how samples are exported to users
+    could remain through the use of a sampling format. This is how Oprofile
+    works on Itanium.
+
+    The current interactions with Oprofile are:
+	- on X86: Both subsystems can be compiled into the same kernel. There
+		  is enforced mutual exclusion between the two subsystems. When
+		  there is an Oprofile session, no perfmon session can exist
+		  and vice-versa.
+
+	- On IA-64: Oprofile works on top of perfmon. Oprofile being a
+		    system-wide monitoring tool, the regular per-thread vs.
+		    system-wide session restrictions apply.
+
+	- on PPC: no integration yet. Only one subsystem can be enabled.
+	- on MIPS: no integration yet.  Only one subsystem can be enabled.
+
+IV/ User tools
+
+    We have released a simple monitoring tool to demonstrate the features of
+    the interface. The tool is called pfmon and it comes with a simple helper
+    library called libpfm. The library comes with a set of examples to show
+    how to use the kernel interface. Visit http://perfmon2.sf.net for details.
+
+    There maybe other tools available for perfmon.
+
+V/ How to program?
+
+   The best way to learn how to program perfmon, is to take a look at the
+   source code for the examples in libpfm. The source code is available from:
+
+		http://perfmon2.sf.net
+
+VI/ System calls overview
+
+   In this section, we describe the state of the interface as submitted to the
+   kernel. There are more extensions available, and we will update the section
+   as they get implemented in the upstream kernel.
+
+   The interface is implemented by the following system calls:
+
+   * int pfm_create(int flags, pfarg_sinfo_t *s);
+
+      This function creates a perfmon per-thread session.
+      The flags parameter is currently unused and must be set to 0.
+
+      Upon return and if s is not NULL, the kernel return the list of available
+      PMC and PMD registers. Tools should not assume, they have access to the
+      entire PMU, it may be shared with other kernel subsystems, e.g., on X86
+      the NMI watchdog timer.
+
+      The function returns the file descriptor identifying the session.
+
+   * int pfm_write(int fd, int flags, int type, void *d, size_t sz)
+
+      This function is used to write PMU registers for the session identified
+      by fd.
+
+      The flags parameter is currently unused and must be set to 0.
+
+      The type reflects the type of registers to write and determines the type
+      of the d parameter. The following types are defined:
+
+         - PFM_RW_PMC: write PMC registers, expect pfarg_pmr_t pointer for d
+         - PFM_RW_PMD: write PMD registers, expect pfarg_pmr_t pointer for d
+
+     The type field is not a bitmask, only one type can be passed per call.
+
+     the sz parameter describes the size of the vector of elements passed in d.
+
+   * int pfm_read(int fd, int flags, int type, void *d, size_t sz);
+
+      This function is used to read PMU registers for the session identified
+      by fd.
+
+      This function is used to write PMU registers for the session identified
+      by fd.
+
+      The flags parameter is currently unused and must be set to 0.
+
+      The type reflects the type of registers to write and determines the type
+      of the d parameter. The following types are supported:
+
+         - PFM_RW_PMD: write PMD registers, expect pfarg_pmr_t pointer for d
+
+     The type field is not a bitmask, only one type can be passed per call.
+
+     Reading of PMC registers is not allowed.
+
+     the sz parameter describes the size of the vector of elements passed in d.
+
+
+   * int pfm_attach(int fd, int flags, int target);
+
+      This function is used to attach and detach the session to and from
+      thread.
+
+      To attach the thread is identified by target which must have the
+      value returned by gettid() (not pthread_self). For a single threaded
+      process, that value is equal to the value returned by getpid().
+
+      To detach, the special target PFM_NO_TARGET must be passed.
+
+      The flags parameter is currently unused and must be set to 0.
+
+      The session is always attached as stopped, i.e., with monitoring
+      inactive. Monitoring is always stopped as a consequence of detaching.
+
+   * int pfm_set_state(int fd, int flags, int state);
+
+     The function is used to set the running state of the session. The state to
+     go to is indicated by state.
+
+     The following states are defined, only one can be specified at a time:
+
+        - PFM_ST_START: start monitoring
+        - PFM_ST_STOP: stop monitoring
+
+      The flags parameter is currently unused and must be set to 0.
+
+   * int close(int fd)
+
+   To destroy a session, the regular close() system call is used.
+
+
+VII/ /sys interface overview
+
+   Refer to Documentation/ABI/testing/sysfs-perfmon-* for a detailed
+   description of the sysfs interface of perfmon2.
+
+VIII/ debugfs interface overview
+
+  Refer to Documentation/perfmon-debugfs.txt for a detailed description of the
+  debug and statistics interface of perfmon.
+
+IX/ Documentation
+
+   Visit http://perfmon2.sf.net
Index: o3/Documentation/ABI/testing/sysfs-perfmon
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ o3/Documentation/ABI/testing/sysfs-perfmon	2008-10-16 12:25:18.000000000 +0200
@@ -0,0 +1,42 @@
+What:		/sys/kernel/perfmon
+Date:		Oct 2008
+KernelVersion:	2.6.27
+Contact:	eranian@gmail.com
+
+Description:	provide the configuration interface for the perfmon subsystems.
+	        The tree contains information about the detected hardware,
+		current state of the subsystem as well as some configuration
+		parameters.
+
+		The tree consists of the following entries:
+
+	/sys/kernel/perfmon/debug (read-write):
+
+		Enable perfmon debugging output. The traces are rate-limited
+		to avoid flooding the console. It is possible to change the
+		throttling via /proc/sys/kernel/printk_ratelimit.
+
+		The value is interpreted as a bitmask.  Each bit enables a
+		particular type of debug messages. Refer to the file
+		include/linux/perfmon_kern.h for more information.
+
+	/sys/kernel/perfmon/task_group (read-write):
+
+		Users group allowed to create a per-thread context (session).
+   		-1 means any group.
+
+	/sys/kernel/perfmon/task_sessions_count (read-only):
+
+		Number of per-thread contexts (sessions) currently attached
+		to threads.
+
+   	/sys/kernel/perfmon/version (read-only):
+
+		Perfmon interface revision number.
+
+	/sys/kernel/perfmon/arg_mem_max(read-write):
+
+		Maximum size of vector arguments expressed in bytes.
+		It can be modified but must be at least a page.
+		Default: PAGE_SIZE
+
Index: o3/Documentation/ABI/testing/sysfs-perfmon-pmu
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ o3/Documentation/ABI/testing/sysfs-perfmon-pmu	2008-10-16 12:25:04.000000000 +0200
@@ -0,0 +1,48 @@
+What:		/sys/kernel/perfmon/pmu
+Date:		Nov 2007
+KernelVersion:	2.6.24
+Contact:	eranian@gmail.com
+
+Description:	Provides information about the active PMU description
+		module.  The module contains the mapping of the actual
+		performance counter registers onto the logical PMU exposed by
+		perfmon.  There is at most one PMU description module loaded
+		at any time.
+
+		The sysfs PMU tree provides a description of the mapping for
+		each register. There is one subdir per config and data register
+		along an entry for the name of the PMU model.
+
+		The entries are as follows:
+
+	/sys/kernel/perfmon/pmu_desc/model (read-only):
+
+		Name of the PMU model is clear text and zero terminated.
+
+	Then, for each logical PMU register, XX, gets a subtree with the
+	following entries:
+
+	/sys/kernel/perfmon/pmu_desc/pm*XX/addr (read-only):
+
+		The physical address or index of the actual underlying hardware
+		register.  On Itanium, it corresponds to the index. But on X86
+		processor, this is the actual MSR address.
+
+	/sys/kernel/perfmon/pmu_desc/pm*XX/dfl_val (read-only):
+
+		The default value of the register in hexadecimal.
+
+	/sys/kernel/perfmon/pmu_desc/pm*XX/name (read-only):
+
+		The name of the hardware register.
+
+	/sys/kernel/perfmon/pmu_desc/pm*XX/rsvd_msk (read-only):
+
+		Bitmask of reserved bits, i.e., bits which cannot be changed
+		by applications. When a bit is set, it means the corresponding
+		bit in the actual register is reserved.
+
+	/sys/kernel/perfmon/pmu_desc/pm*XX/width (read-only):
+
+		The width in bits of the registers. This field is only
+		relevant for counter registers.

-- 

