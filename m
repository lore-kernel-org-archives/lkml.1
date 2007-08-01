Return-Path: <linux-kernel-owner+w=401wt.eu-S1763718AbXHAOUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763718AbXHAOUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 10:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbXHAOUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 10:20:33 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:54814 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbXHAOUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 10:20:31 -0400
From: Bob Nelson <rrnelson@linux.vnet.ibm.com>
To: eranian@hpl.hp.com
Subject: Re: 2.6.22 new perfmon code base + libpfm + pfmon
Date: Wed, 1 Aug 2007 09:22:41 -0500
User-Agent: KMail/1.9.7
References: <20070726140222.GA7852@frankl.hpl.hp.com>
In-Reply-To: <20070726140222.GA7852@frankl.hpl.hp.com>
Cc: linux kernel <linux-kernel@vger.kernel.org>,
       oprofile <oprofile-list@lists.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708010922.41551.rrnelson@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 July 2007 09:02:22 am Stephane Eranian wrote:
> Hello,
> 
> I have released another version of the perfmon new code base package.
> This version of the kernel patch is relative to 2.6.22. Sorry for
> the delay but there was some traveling on my part + a lot
> of patches to integrate + a lot of important changes.
> 
> This  new kernel patch includes the following new features and
> bug fixes:
> 	- co-exist with Oprofile on x86_64 and i386. Both subsystems
> 	  are mutually exclusive. You either run a session in one or
> 	  the other. But the kernel can be compiled with both subsystems
> 	  enabled. No changes  required to the user level Oprofile code.
> 
> 	- rename perfmon_gen_ia32.c to perfmon_intel_arch.c
> 
> 	- perfmon_intel_arch.c supports architectural perfmon v1 and v2
> 	  (as defined in IA-32 manual Vol 3b dated May 2007)
> 
> 	- perfmon_core.c renamed perfmon_intel_core.c
> 
> 	- reworked register mapping for perfmon_core.c to be compatible
> 	  with V1 and V2. The Intel Core PMU is backward compatible with
> 	  V1 and V2. it is important to ensure that an application written
> 	  to know only about architectural perfmon can work unmodified on
> 	  all PMU that implement architectural perfmon. Generic counters
> 	  are in range 0-16, fixed counters are in range 16-31. PEBS is
> 	  added as PMC17.
> 	  
> 	- renamed pfm_msg_t to pfarg_msg_t to match argument naming. The
> 	  structure layout was also modified.
> 
> 	- simplify API by having only one bitmap size for all PMD bitmaps
> 	  shared with the user level. Deal with IA-64 v2.0 compatibility
> 	  separately. This is is incompatible with earlier v2.xx version,
> 	  recompilation is necessary.
> 
> 	- created an arch specific header files (asm-*/perfmon_const.h) to
> 	  specify the per-arch maximum number of PMCs and PMDs supported
> 	  (including SW PMU registers).
> 
> 	- remove ability to have the SW-maintained 64-bit counters remapped
> 	  at the user level (PFM_FL_MAP_SETS). This feature was not really
> 	  used. this features was not available on all archs as it required
> 	  the ability to read a hw counter directly at the user level.
> 
> 	- remove the ability to provide a explicit set number as the next set
> 	  to go to PFM_SETFL_EXPL_NEXT. This feature was not really used. Now,
> 	  this is a simple round-robin following the set order. The data
> 	  structure pfarg_setdesc has been changed accordingly.
> 	  
> 	- improved overflow-based set switching by leveraging the fact that
> 	  monitoring is already stopped
> 
> 	- on x86, connect perfmon to the basic PMU register allocator used by
> 	  the NMI watchdog and Oprofile. PMU registers are now acquired on first
> 	  perfmon context creation. They are released when the last perfmon
> 	  context is destroyed.
> 
> 	- simplification of active NMI watchdog detection. Now in common
> 	  i386/x86_64 perfmon code.
> 
> 	- On Intel Core (and architectural perfmon v2), we do not use/expose the
> 	  new GLOBAL_* PMU MSR due to sharing issues with NMI watchdog.
> 
> 	- Certain MIPS systems have cache aliasing problems with the sampling buffer.
> 	  Provide compile time option to enable two possible workarounds: explicit
> 	  flushing on write in the buffer, force a mich bigger page alignment for
> 	  the buffer in vmalloc().  Patches provided by Kevin Cernekee.
> 
> 	- PowerPC updates, Power5 udpates, Cell Processor code support.
> 	  Patches provided by Kevin Corry (IBM)
> 
> 	- AMD Barcelona support, general code cleanup, improved debug messages
> 	  in syscall code. Patches provided by Robert Richter (AMD). AMD IBS
> 	  support not yet included.
> 
> 	- enable Pentium II support by Vince Weaver (Cornell)
> 
> 	- sysfs /sys stale entries removal
> 
> A lot of changes went into this release. A particular thank you to Kevin
> and Robert for providing bug fixes and cleanups to the common code base.
> I would also like to thank David Rientjes (Google) for his detailed code
> review. I have integrated almost all of his remarks in this release.
> Special thanks to Andi Kleen for his code review and his constructive
> remarks.
> 
> IMPORTANT: This release is not backward compatible with previous releases.
> You need to recompile and/or adjust your apps. Old IA-64 v2.0, applications
> are supported with no recompilation/modification.
> 
> I have also released a new libpfm, libpfm-3.2-070725, with lots of
> changes. Here are some of the most important ones:
> 	- reflect ALL API changes for the v2.6 perfmon interface
> 	  including syscall number changes
> 	- Cray Blackwidow support by Steve Kaufmann (Cray Inc)
> 	- PowerPC updates by Kevin Corry (IBM)
> 	- some MIPS updates by Manoj Ekbote
> 	- simplify config.mk by compiling all known targets for each architecture
> 	- man pages updates by Steve Kaufmann
> 	- examples updates especially self.c to avoid compiler optimizations
> 	- check for CPU revisions (A,B,C,D,E) on AMD64 event mask support
> 	- enable Pentium II Deschutes  by Vince Weaver (Cornell)
> 
> IMPORTANT: this version of the library ONLY works with 2.6.22.
> 
> Also a new version of pfmon, pfmon-3.2-070725, with lots of changes,including:
> 	- update to v2.6 kernel API and latest libpfm
> 	- cleanup breakpoint API
> 	- added x86 software breakpoint code (not yet functional)
> 	- merge pfmon_util_i386.c and pfmon_util_x86_64.c into pfmon_util_x86.c
> 	- simplify config.mk by compiling all known targets for each architecture
> 
> IMPORTANT: you need libpfm-3.2-070725 with this release of pfmon
> 
> In terms of mainline integration, the kernel package includes a base.diff
> patch which contains a several infrastructure changes:
> 
> 	- all arch: remove TIF_NOTIFY_RESUME
> 	- mips    : add smp_call_function_single()
> 	- x86_64  : add AMD64 (family 16) MSR definitions for PMU
> 	- i386    : add cpu_has_arch_perfmon macro
> 	- i386    : perfctr-watchdog.c don't BUG_ON() when msr is unknown
> 	- i386    : oprofile/nmi_int.c do model_shutdown() only once
> 
> Unfortunately, this patches grew again in this release but mostly due to the
> removal of the TIF_NOTIFY_RESUME patch which has been submitted to LKML.
> The simple PMU register allocator in perfctr-watchdog.c still needs a lot of
> work. Bjorn Steinbrink has been working on this.
> 
> You can get the package and very detailed changelogs our the web site:
> 
> 	 http://perfmon2.sf.net
> 
> Enjoy,
> 

Back during some of the previous discussion of this set of patches:

>On Mon, Jun 04, 2007 at 08:13:41AM -0700, David Rientjes wrote:
>> On Tue, 29 May 2007, Stephane Eranian wrote:
snipped..
>> > +++ linux-2.6.22/drivers/oprofile/oprofile_files.c	2007-05-29 03:24:14.000000000 -0700
>> > +
>> > +static ssize_t implementation(struct file * file, char __user * buf, size_t count, loff_t * offset)
>> > +{
>> > +	return oprofilefs_str_to_user(oprofile_ops.implementation, buf, count, offset);
>> > +}
>> > +
>> > +
>> > +static struct file_operations implementation_fops = {
>> > +	.read		= implementation,
>> > +};
>> > +
>> >  void oprofile_create_files(struct super_block * sb, struct dentry * root)
>> >  {
>> >  	oprofilefs_create_file(sb, root, "enable", &enable_fops);
>> > @@ -127,6 +137,7 @@ void oprofile_create_files(struct super_
>> >  	oprofilefs_create_ulong(sb, root, "buffer_watershed", &fs_buffer_watershed);
>> >  	oprofilefs_create_ulong(sb, root, "cpu_buffer_size", &fs_cpu_buffer_size);
>> >  	oprofilefs_create_file(sb, root, "cpu_type", &cpu_type_fops); 
>> > +	oprofilefs_create_file(sb, root, "implementation", &implementation_fops);
>> >  	oprofilefs_create_file(sb, root, "backtrace_depth", &depth_fops);
>> >  	oprofilefs_create_file(sb, root, "pointer_size", &pointer_size_fops);
>> >  	oprofile_create_stats_files(sb, root);
>> 
>> The commentary for how to interpret this new file is lacking; it appears 
>> as though it will return "timer", "oprofile", or "nmi_timer" for existing 
>> i386 subsystems and "perfmon2" with this addition.  This should be 
>> documented.
>> 
>> It isn't set generically in oprofile_arch_init() for other architectures.
>
>This modification of oprofile was one to allow the user level oprofile daemon
>to determine which kernel "implementation" of oprofile it is running on. This
>way tool could transparently run on existing Oprofile and also on systems
>with both perfmon and Oprofile.
>
>Andi suggested that during a transition period, we let Oprofile and perfmon
>co-exist as opposed to moving Oprofile on top of perfmon right away. I think this
>is a good suggestion. As a consequence, I will remove this Oprofile extension.

It looks to me like you were saying you would remove this extension to the
OProfile file system (/dev/oprofile/implementation).
However, it looks like it has made it into the mainline kernel code.  As David
pointed out, the value isn't initialized for architectures other than i386.  As
a result you get a kernel crash (at least on PPC) with the following commands.

opcontrol --init
cat /dev/oprofile/implementation

Kevin Corry is working on a patch but until that makes it out people may want
to be a little careful with this...

Bob Nelson

