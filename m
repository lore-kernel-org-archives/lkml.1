Return-Path: <linux-kernel-owner+w=401wt.eu-S1756992AbYKVDnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992AbYKVDnz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 22:43:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756746AbYKVDnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 22:43:17 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:53394 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755812AbYKVDnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 22:43:14 -0500
From: Jeff Arnold <jbarnold@MIT.EDU>
To: linux-kernel@vger.kernel.org
Cc: Tim Abbott <tabbott@MIT.EDU>, Anders Kaseorg <andersk@MIT.EDU>,
       Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Nikanth Karthikesan <knikanth@suse.de>
Subject: [RFC v3 PATCH 0/7] Ksplice: Rebootless kernel updates
Date: Fri, 21 Nov 2008 22:35:54 -0500
Message-Id: <1227324961-13273-1-git-send-email-jbarnold@mit.edu>
X-Mailer: git-send-email 1.6.0
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add support for Ksplice [1], a rebootless update system, to 
the kernel.  We now think that Ksplice is ready to be merged (ideally into 
-mm), and we are sending this RFC to see whether we can shake loose any 
comments or code review.  If people have concerns about Ksplice, we'd like 
to hear them.

[1] http://www.ksplice.com/download

I previously mentioned Ksplice to the LKML in April [2], and I submitted 
RFC patches to the LKML in September [3].  The basic idea is that Ksplice 
can apply an update to a running Linux kernel based only on a source code 
patch and the original kernel source.  The Ksplice technical overview 
document [4] describes the design of Ksplice and one of the ways that 
Ksplice has been evaluated.

[2] http://lkml.org/lkml/2008/4/23/330
[3] http://lkml.org/lkml/2008/9/13/6
[4] http://www.ksplice.com/doc/ksplice.pdf

Specifically, Ksplice has been used to correct every significant Linux 
kernel CVE from May 2005 to May 2008 [5].  88% of these CVEs can be fixed 
without writing any new code at all; the remaining 12% of CVEs require a 
minimal amount of new code (on average, roughly 20 new 
semicolon-terminated lines per CVE).

[5] http://www.ksplice.com/cve-evaluation

The interface between the Ksplice kernel component and the userspace 
utilities is documented in the last patch of this series.  The current 
implementation of the userspace utilities is available from the Ksplice 
website and the Ksplice git repository [6].  The Ksplice userspace 
utilities transparently support both "integrated" operation (updating a 
kernel patched with this patch series) and "standalone" operation 
(updating a completely unmodified kernel).

[6] http://www.ksplice.com/git/ksplice.git

Just to let you know what direction we are going in: We're currently 
working on the problem of making it feasible to apply the entire stable 
tree using Ksplice.  Although Ksplice's original evaluation focused on 
patches for CVEs, we understand the idea that "security bugs are just 
'normal bugs'" [7] (i.e., tracking security bugs separately from normal 
bugs can be difficult and isn't necessarily advisable).  We ultimately 
want to provide to long-running machines hot updates for all of the bug 
fixes that go into the corresponding stable tree.  We think that 
long-running machines will be more secure and reliable if they can 
regularly be updated to the latest stable kernel code (along with the 
usual user space updates provided by distributions).

[7] http://lkml.org/lkml/2008/7/14/465

Even though work on Ksplice is ongoing, I think that merging Ksplice makes 
sense at this point because (1) development on the Ksplice kernel code has 
stabilized, and (2) the system, as it currently stands, can be useful in a 
variety of situations.

Jeff Arnold
jbarnold@mit.edu

Changes since v2:
- added taint flag, as requested by Alexey Dobriyan
- various speed optimizations
- support for replacing functions mapped read-only (CONFIG_DEBUG_RODATA)
- run-pre matching extended to bug table, ex_table, exported symbol table
- added hooks for calling custom code during the update process
- struct ksplice_export eliminated (struct ksplice_patch used instead)
- minor sysfs API changes
- added support for ksplice-apply's --partial option
- improved -ffunction-sections patches and added them to this patch series
- dropped ARM support for now, for simplicity

==

 Documentation/ksplice.txt                   |  282 ++
 Documentation/mutex-design.txt              |    4 +-
 MAINTAINERS                                 |   10 +
 Makefile                                    |    4 +
 arch/Kconfig                                |   14 +
 arch/alpha/kernel/head.S                    |    2 +-
 arch/alpha/kernel/init_task.c               |    2 +-
 arch/alpha/kernel/vmlinux.lds.S             |   14 +-
 arch/arm/kernel/head-nommu.S                |    3 +-
 arch/arm/kernel/head.S                      |    3 +-
 arch/arm/kernel/init_task.c                 |    2 +-
 arch/arm/kernel/vmlinux.lds.S               |   14 +-
 arch/arm/mm/proc-v6.S                       |    2 +-
 arch/arm/mm/proc-v7.S                       |    2 +-
 arch/arm/mm/tlb-v6.S                        |    2 +-
 arch/arm/mm/tlb-v7.S                        |    2 +-
 arch/avr32/kernel/init_task.c               |    2 +-
 arch/avr32/kernel/vmlinux.lds.S             |    6 +-
 arch/avr32/mm/init.c                        |    2 +-
 arch/blackfin/kernel/vmlinux.lds.S          |    2 +-
 arch/cris/kernel/process.c                  |    2 +-
 arch/frv/kernel/break.S                     |    4 +-
 arch/frv/kernel/entry.S                     |    2 +-
 arch/frv/kernel/head-mmu-fr451.S            |    2 +-
 arch/frv/kernel/head-uc-fr401.S             |    2 +-
 arch/frv/kernel/head-uc-fr451.S             |    2 +-
 arch/frv/kernel/head-uc-fr555.S             |    2 +-
 arch/frv/kernel/head.S                      |    4 +-
 arch/frv/kernel/init_task.c                 |    2 +-
 arch/frv/kernel/vmlinux.lds.S               |   18 +-
 arch/frv/mm/tlb-miss.S                      |    2 +-
 arch/h8300/boot/compressed/head.S           |    2 +-
 arch/h8300/boot/compressed/vmlinux.lds      |    2 +-
 arch/h8300/kernel/init_task.c               |    2 +-
 arch/h8300/kernel/vmlinux.lds.S             |    2 +-
 arch/ia64/include/asm/asmmacro.h            |   12 +-
 arch/ia64/include/asm/cache.h               |    2 +-
 arch/ia64/include/asm/percpu.h              |    2 +-
 arch/ia64/kernel/Makefile                   |    2 +-
 arch/ia64/kernel/gate-data.S                |    2 +-
 arch/ia64/kernel/gate.S                     |    8 +-
 arch/ia64/kernel/gate.lds.S                 |   10 +-
 arch/ia64/kernel/head.S                     |    2 +-
 arch/ia64/kernel/init_task.c                |    4 +-
 arch/ia64/kernel/ivt.S                      |    2 +-
 arch/ia64/kernel/minstate.h                 |    4 +-
 arch/ia64/kernel/paravirtentry.S            |   12 +-
 arch/ia64/kernel/vmlinux.lds.S              |   48 +-
 arch/ia64/kvm/vmm_ivt.S                     |    2 +-
 arch/ia64/xen/xensetup.S                    |    2 +-
 arch/m32r/kernel/init_task.c                |    2 +-
 arch/m32r/kernel/vmlinux.lds.S              |    6 +-
 arch/m68k/kernel/head.S                     |    2 +-
 arch/m68k/kernel/process.c                  |    2 +-
 arch/m68k/kernel/sun3-head.S                |    2 +-
 arch/m68k/kernel/vmlinux-std.lds            |    6 +-
 arch/m68k/kernel/vmlinux-sun3.lds           |    4 +-
 arch/m68knommu/kernel/init_task.c           |    2 +-
 arch/m68knommu/kernel/vmlinux.lds.S         |    6 +-
 arch/m68knommu/platform/68360/head-ram.S    |    2 +-
 arch/m68knommu/platform/68360/head-rom.S    |    2 +-
 arch/mips/kernel/init_task.c                |    2 +-
 arch/mips/kernel/vmlinux.lds.S              |    8 +-
 arch/mips/lasat/image/head.S                |    2 +-
 arch/mips/lasat/image/romscript.normal      |    2 +-
 arch/mn10300/kernel/head.S                  |    2 +-
 arch/mn10300/kernel/init_task.c             |    2 +-
 arch/mn10300/kernel/vmlinux.lds.S           |   18 +-
 arch/parisc/include/asm/cache.h             |    2 +-
 arch/parisc/include/asm/system.h            |    2 +-
 arch/parisc/kernel/head.S                   |    2 +-
 arch/parisc/kernel/init_task.c              |    8 +-
 arch/parisc/kernel/vmlinux.lds.S            |   26 +-
 arch/powerpc/include/asm/cache.h            |    2 +-
 arch/powerpc/include/asm/page_64.h          |    2 +-
 arch/powerpc/include/asm/ppc_asm.h          |    4 +-
 arch/powerpc/kernel/head_32.S               |    2 +-
 arch/powerpc/kernel/head_40x.S              |    2 +-
 arch/powerpc/kernel/head_44x.S              |    2 +-
 arch/powerpc/kernel/head_8xx.S              |    2 +-
 arch/powerpc/kernel/head_fsl_booke.S        |    2 +-
 arch/powerpc/kernel/init_task.c             |    2 +-
 arch/powerpc/kernel/machine_kexec_64.c      |    2 +-
 arch/powerpc/kernel/vdso.c                  |    2 +-
 arch/powerpc/kernel/vdso32/vdso32_wrapper.S |    2 +-
 arch/powerpc/kernel/vdso64/vdso64_wrapper.S |    2 +-
 arch/powerpc/kernel/vmlinux.lds.S           |   28 +-
 arch/s390/include/asm/cache.h               |    2 +-
 arch/s390/kernel/head.S                     |    2 +-
 arch/s390/kernel/init_task.c                |    2 +-
 arch/s390/kernel/vmlinux.lds.S              |   20 +-
 arch/sh/include/asm/cache.h                 |    2 +-
 arch/sh/kernel/cpu/sh5/entry.S              |    4 +-
 arch/sh/kernel/head_32.S                    |    2 +-
 arch/sh/kernel/head_64.S                    |    2 +-
 arch/sh/kernel/init_task.c                  |    2 +-
 arch/sh/kernel/irq.c                        |    4 +-
 arch/sh/kernel/vmlinux_32.lds.S             |   14 +-
 arch/sh/kernel/vmlinux_64.lds.S             |   14 +-
 arch/sparc/boot/btfixupprep.c               |    4 +-
 arch/sparc/include/asm/cache.h              |    2 +-
 arch/sparc/kernel/head.S                    |    2 +-
 arch/sparc/kernel/vmlinux.lds.S             |    8 +-
 arch/sparc64/kernel/head.S                  |    2 +-
 arch/sparc64/kernel/vmlinux.lds.S           |    8 +-
 arch/um/include/asm/common.lds.S            |    4 +-
 arch/um/kernel/dyn.lds.S                    |    4 +-
 arch/um/kernel/init_task.c                  |    4 +-
 arch/um/kernel/uml.lds.S                    |    4 +-
 arch/x86/Kconfig                            |    1 +
 arch/x86/boot/compressed/head_32.S          |    2 +-
 arch/x86/boot/compressed/head_64.S          |    2 +-
 arch/x86/boot/compressed/vmlinux.scr        |    2 +-
 arch/x86/boot/compressed/vmlinux_32.lds     |   14 +-
 arch/x86/boot/compressed/vmlinux_64.lds     |   10 +-
 arch/x86/include/asm/cache.h                |    4 +-
 arch/x86/kernel/acpi/wakeup_32.S            |    2 +-
 arch/x86/kernel/head_32.S                   |    6 +-
 arch/x86/kernel/head_64.S                   |    4 +-
 arch/x86/kernel/init_task.c                 |    6 +-
 arch/x86/kernel/ksplice-arch.c              |  125 +
 arch/x86/kernel/traps.c                     |    2 +-
 arch/x86/kernel/vmlinux_32.lds.S            |   37 +-
 arch/x86/kernel/vmlinux_64.lds.S            |   27 +-
 arch/xtensa/kernel/head.S                   |    2 +-
 arch/xtensa/kernel/init_task.c              |    2 +-
 arch/xtensa/kernel/vmlinux.lds.S            |    6 +-
 include/asm-frv/init.h                      |    8 +-
 include/asm-generic/vmlinux.lds.h           |   16 +-
 include/linux/cache.h                       |    2 +-
 include/linux/init.h                        |    8 +-
 include/linux/kallsyms.h                    |   13 +
 include/linux/kernel.h                      |    1 +
 include/linux/ksplice.h                     |  212 ++
 include/linux/linkage.h                     |    4 +-
 include/linux/module.h                      |   42 +
 include/linux/percpu.h                      |   12 +-
 include/linux/spinlock.h                    |    2 +-
 kernel/Makefile                             |    3 +
 kernel/extable.c                            |    3 +
 kernel/kallsyms.c                           |   19 +
 kernel/ksplice.c                            | 2716 +++++++++++++++++
 kernel/module.c                             |  164 +-
 kernel/panic.c                              |    1 +
 kernel/sched.c                              |    1 +
 lib/Kconfig.debug                           |    9 +
 lib/bug.c                                   |    1 +
 scripts/Makefile.modpost                    |    1 +
 scripts/mod/modpost.c                       |   22 +-
 scripts/recordmcount.pl                     |    6 +-
 150 files changed, 3929 insertions(+), 409 deletions(-)
