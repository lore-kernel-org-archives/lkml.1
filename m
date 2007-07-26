Return-Path: <linux-kernel-owner+w=401wt.eu-S933728AbXGZOE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933728AbXGZOE3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 10:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758266AbXGZOEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 10:04:16 -0400
Received: from madara.hpl.hp.com ([192.6.19.124]:55154 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765418AbXGZOEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 10:04:12 -0400
Date: Thu, 26 Jul 2007 07:02:22 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: perfmon@napali.hpl.hp.com
Cc: linux-kernel@vger.kernel.org, perfctr-devel@lists.sourceforge.net,
       oprofile-list@lists.sourceforge.net,
       Stephane Eranian <eranian@hpl.hp.com>
Subject: 2.6.22 new perfmon code base + libpfm + pfmon
Message-ID: <20070726140222.GA7852@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have released another version of the perfmon new code base package.
This version of the kernel patch is relative to 2.6.22. Sorry for
the delay but there was some traveling on my part + a lot
of patches to integrate + a lot of important changes.

This  new kernel patch includes the following new features and
bug fixes:
	- co-exist with Oprofile on x86_64 and i386. Both subsystems
	  are mutually exclusive. You either run a session in one or
	  the other. But the kernel can be compiled with both subsystems
	  enabled. No changes  required to the user level Oprofile code.

	- rename perfmon_gen_ia32.c to perfmon_intel_arch.c

	- perfmon_intel_arch.c supports architectural perfmon v1 and v2
	  (as defined in IA-32 manual Vol 3b dated May 2007)

	- perfmon_core.c renamed perfmon_intel_core.c

	- reworked register mapping for perfmon_core.c to be compatible
	  with V1 and V2. The Intel Core PMU is backward compatible with
	  V1 and V2. it is important to ensure that an application written
	  to know only about architectural perfmon can work unmodified on
	  all PMU that implement architectural perfmon. Generic counters
	  are in range 0-16, fixed counters are in range 16-31. PEBS is
	  added as PMC17.
	  
	- renamed pfm_msg_t to pfarg_msg_t to match argument naming. The
	  structure layout was also modified.

	- simplify API by having only one bitmap size for all PMD bitmaps
	  shared with the user level. Deal with IA-64 v2.0 compatibility
	  separately. This is is incompatible with earlier v2.xx version,
	  recompilation is necessary.

	- created an arch specific header files (asm-*/perfmon_const.h) to
	  specify the per-arch maximum number of PMCs and PMDs supported
	  (including SW PMU registers).

	- remove ability to have the SW-maintained 64-bit counters remapped
	  at the user level (PFM_FL_MAP_SETS). This feature was not really
	  used. this features was not available on all archs as it required
	  the ability to read a hw counter directly at the user level.

	- remove the ability to provide a explicit set number as the next set
	  to go to PFM_SETFL_EXPL_NEXT. This feature was not really used. Now,
	  this is a simple round-robin following the set order. The data
	  structure pfarg_setdesc has been changed accordingly.
	  
	- improved overflow-based set switching by leveraging the fact that
	  monitoring is already stopped

	- on x86, connect perfmon to the basic PMU register allocator used by
	  the NMI watchdog and Oprofile. PMU registers are now acquired on first
	  perfmon context creation. They are released when the last perfmon
	  context is destroyed.

	- simplification of active NMI watchdog detection. Now in common
	  i386/x86_64 perfmon code.

	- On Intel Core (and architectural perfmon v2), we do not use/expose the
	  new GLOBAL_* PMU MSR due to sharing issues with NMI watchdog.

	- Certain MIPS systems have cache aliasing problems with the sampling buffer.
	  Provide compile time option to enable two possible workarounds: explicit
	  flushing on write in the buffer, force a mich bigger page alignment for
	  the buffer in vmalloc().  Patches provided by Kevin Cernekee.

	- PowerPC updates, Power5 udpates, Cell Processor code support.
	  Patches provided by Kevin Corry (IBM)

	- AMD Barcelona support, general code cleanup, improved debug messages
	  in syscall code. Patches provided by Robert Richter (AMD). AMD IBS
	  support not yet included.

	- enable Pentium II support by Vince Weaver (Cornell)

	- sysfs /sys stale entries removal

A lot of changes went into this release. A particular thank you to Kevin
and Robert for providing bug fixes and cleanups to the common code base.
I would also like to thank David Rientjes (Google) for his detailed code
review. I have integrated almost all of his remarks in this release.
Special thanks to Andi Kleen for his code review and his constructive
remarks.

IMPORTANT: This release is not backward compatible with previous releases.
You need to recompile and/or adjust your apps. Old IA-64 v2.0, applications
are supported with no recompilation/modification.

I have also released a new libpfm, libpfm-3.2-070725, with lots of
changes. Here are some of the most important ones:
	- reflect ALL API changes for the v2.6 perfmon interface
	  including syscall number changes
	- Cray Blackwidow support by Steve Kaufmann (Cray Inc)
	- PowerPC updates by Kevin Corry (IBM)
	- some MIPS updates by Manoj Ekbote
	- simplify config.mk by compiling all known targets for each architecture
	- man pages updates by Steve Kaufmann
	- examples updates especially self.c to avoid compiler optimizations
	- check for CPU revisions (A,B,C,D,E) on AMD64 event mask support
	- enable Pentium II Deschutes  by Vince Weaver (Cornell)

IMPORTANT: this version of the library ONLY works with 2.6.22.

Also a new version of pfmon, pfmon-3.2-070725, with lots of changes,including:
	- update to v2.6 kernel API and latest libpfm
	- cleanup breakpoint API
	- added x86 software breakpoint code (not yet functional)
	- merge pfmon_util_i386.c and pfmon_util_x86_64.c into pfmon_util_x86.c
	- simplify config.mk by compiling all known targets for each architecture

IMPORTANT: you need libpfm-3.2-070725 with this release of pfmon

In terms of mainline integration, the kernel package includes a base.diff
patch which contains a several infrastructure changes:

	- all arch: remove TIF_NOTIFY_RESUME
	- mips    : add smp_call_function_single()
	- x86_64  : add AMD64 (family 16) MSR definitions for PMU
	- i386    : add cpu_has_arch_perfmon macro
	- i386    : perfctr-watchdog.c don't BUG_ON() when msr is unknown
	- i386    : oprofile/nmi_int.c do model_shutdown() only once

Unfortunately, this patches grew again in this release but mostly due to the
removal of the TIF_NOTIFY_RESUME patch which has been submitted to LKML.
The simple PMU register allocator in perfctr-watchdog.c still needs a lot of
work. Bjorn Steinbrink has been working on this.

You can get the package and very detailed changelogs our the web site:

	 http://perfmon2.sf.net

Enjoy,

-- 

-Stephane
