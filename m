Return-Path: <linux-kernel-owner+w=401wt.eu-S1758741AbZDEXQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741AbZDEXQz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 19:16:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758735AbZDEXQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 19:16:35 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:56072 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758721AbZDEXQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 19:16:34 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Tim Abbott <tabbott@MIT.EDU>, Anders Kaseorg <andersk@MIT.EDU>,
       Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Arnold <jbarnold@MIT.EDU>
Subject: [PATCH v2 0/4] Add support for compiling with -ffunction-sections -fdata-sections
Date: Sun,  5 Apr 2009 19:14:34 -0400
Message-Id: <1238973278-31735-1-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here is a new version of the -ffunction-sections -fdata-sections patch
series based on your current master.  Please apply.

When I sent a version of this patch series at the start of the merge
window, Stephen Rothwell pointed out that the first patch conflicted
with several changes in linux-next, and it should be resent near the
end of the merge window once those changes were merged.  There are
now no conflicting changes staged in linux-next[0], so now is probably
the optimal time to merge this patch series.

[0] There is one trivial merge conflict with next-20090403 because
e5083a63b6a8546c5fe1e571fe529e3939787ec2 was merged into master since
then, but this will presumably disappear when next catches up tomorrow.

	-Tim Abbott

--

The purpose of this patch series is to make it possible to build the
kernel with "gcc -ffunction-sections -fdata-sections".  There are two
major applications for this functionality: decreasing vmlinux image
size with --gc-sections, and Ksplice.

The original motivation for this functionality was to allow using the
linker's unused section garbage collection support (ld --gc-sections)
in order to get a smaller vmlinux image for embedded systems.  People
have been developing patches for supporting building the kernel with
-ffunction-sections -fdata-sections for this purpose for a few years
now (e.g. [1]).  The most recent previous set of patches for
--gc-sections was by Denys Vlasenko, and saved 10% on vmlinux size
with CONFIG_MODULES=n and 1% with CONFIG_MODULES=y [2,3,4].  The
primary source of complexity in the various patch series for doing
section garbage collection has been in the patches adding support for
compiling the kernel with -ffunction-sections -fdata-sections, so
merging this patch series should be a big step towards those
significant savings in kernel image size.

[1] <http://lkml.org/lkml/2006/6/4/169>
[2] <http://lkml.org/lkml/2007/9/5/90>
[3] <http://lkml.org/lkml/2007/9/7/110>
[4] <http://lkml.org/lkml/2008/7/1/499>

Support for building the kernel with -ffunction-sections
-fdata-sections is the only significant prerequisite change currently
required by Ksplice.  Ksplice is a system for updating the Linux
kernel without rebooting [5].

[5] <http://lkml.org/lkml/2009/2/24/362> is the latest version of the
Ksplice patch series

Patches 1/4, 2/4, and 3/4 are independent of each other, but
all three are prerequisites for patch 4/4.

Anders Kaseorg (1):
  modpost: Check the section flags, not name, to catch missing
    "ax"/"aw"

Denys Vlasenko (1):
  modpost: Support objects with more than 64k sections

Tim Abbott (1):
  Make section names compatible with -ffunction-sections
    -fdata-sections

Waseem Daher (1):
  x86: Add an option to compile with -ffunction-sections
    -fdata-sections

 Documentation/mutex-design.txt              |    4 +-
 Makefile                                    |    4 +
 arch/alpha/kernel/head.S                    |    2 +-
 arch/alpha/kernel/init_task.c               |    2 +-
 arch/alpha/kernel/vmlinux.lds.S             |   14 ++--
 arch/arm/kernel/head-nommu.S                |    2 +-
 arch/arm/kernel/head.S                      |    2 +-
 arch/arm/kernel/init_task.c                 |    2 +-
 arch/arm/kernel/vmlinux.lds.S               |   16 ++--
 arch/arm/mm/proc-v6.S                       |    2 +-
 arch/arm/mm/proc-v7.S                       |    2 +-
 arch/arm/mm/tlb-v6.S                        |    2 +-
 arch/arm/mm/tlb-v7.S                        |    2 +-
 arch/avr32/kernel/init_task.c               |    2 +-
 arch/avr32/kernel/vmlinux.lds.S             |    6 +-
 arch/avr32/mm/init.c                        |    2 +-
 arch/blackfin/kernel/vmlinux.lds.S          |    2 +-
 arch/cris/kernel/process.c                  |    2 +-
 arch/cris/kernel/vmlinux.lds.S              |    2 +-
 arch/frv/kernel/break.S                     |    4 +-
 arch/frv/kernel/entry.S                     |    2 +-
 arch/frv/kernel/head-mmu-fr451.S            |    2 +-
 arch/frv/kernel/head-uc-fr401.S             |    2 +-
 arch/frv/kernel/head-uc-fr451.S             |    2 +-
 arch/frv/kernel/head-uc-fr555.S             |    2 +-
 arch/frv/kernel/head.S                      |    4 +-
 arch/frv/kernel/init_task.c                 |    2 +-
 arch/frv/kernel/vmlinux.lds.S               |   18 ++--
 arch/frv/mm/tlb-miss.S                      |    2 +-
 arch/h8300/boot/compressed/head.S           |    2 +-
 arch/h8300/boot/compressed/vmlinux.lds      |    2 +-
 arch/h8300/kernel/init_task.c               |    2 +-
 arch/h8300/kernel/vmlinux.lds.S             |    2 +-
 arch/ia64/include/asm/asmmacro.h            |   12 +-
 arch/ia64/include/asm/cache.h               |    2 +-
 arch/ia64/include/asm/percpu.h              |    2 +-
 arch/ia64/kernel/Makefile.gate              |    2 +-
 arch/ia64/kernel/gate-data.S                |    2 +-
 arch/ia64/kernel/gate.S                     |    8 +-
 arch/ia64/kernel/gate.lds.S                 |   10 +-
 arch/ia64/kernel/head.S                     |    2 +-
 arch/ia64/kernel/init_task.c                |    4 +-
 arch/ia64/kernel/ivt.S                      |    2 +-
 arch/ia64/kernel/minstate.h                 |    4 +-
 arch/ia64/kernel/paravirtentry.S            |    2 +-
 arch/ia64/kernel/vmlinux.lds.S              |   44 ++++----
 arch/ia64/kvm/vmm_ivt.S                     |    2 +-
 arch/ia64/xen/gate-data.S                   |    2 +-
 arch/ia64/xen/xensetup.S                    |    2 +-
 arch/m32r/kernel/head.S                     |    2 +-
 arch/m32r/kernel/init_task.c                |    2 +-
 arch/m32r/kernel/vmlinux.lds.S              |    8 +-
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
 arch/mn10300/kernel/vmlinux.lds.S           |   16 ++--
 arch/parisc/include/asm/cache.h             |    2 +-
 arch/parisc/include/asm/system.h            |    2 +-
 arch/parisc/kernel/head.S                   |    2 +-
 arch/parisc/kernel/init_task.c              |    8 +-
 arch/parisc/kernel/vmlinux.lds.S            |   26 +++---
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
 arch/powerpc/kernel/vmlinux.lds.S           |   22 ++--
 arch/s390/include/asm/cache.h               |    2 +-
 arch/s390/kernel/head.S                     |    2 +-
 arch/s390/kernel/init_task.c                |    2 +-
 arch/s390/kernel/vdso.c                     |    2 +-
 arch/s390/kernel/vdso32/vdso32_wrapper.S    |    2 +-
 arch/s390/kernel/vdso64/vdso64_wrapper.S    |    2 +-
 arch/s390/kernel/vmlinux.lds.S              |   20 ++--
 arch/sh/include/asm/cache.h                 |    2 +-
 arch/sh/kernel/cpu/sh5/entry.S              |    4 +-
 arch/sh/kernel/head_32.S                    |    2 +-
 arch/sh/kernel/head_64.S                    |    2 +-
 arch/sh/kernel/init_task.c                  |    2 +-
 arch/sh/kernel/irq.c                        |    4 +-
 arch/sh/kernel/vmlinux_32.lds.S             |   14 ++--
 arch/sh/kernel/vmlinux_64.lds.S             |   14 ++--
 arch/sparc/boot/btfixupprep.c               |    4 +-
 arch/sparc/include/asm/cache.h              |    2 +-
 arch/sparc/kernel/head_32.S                 |    4 +-
 arch/sparc/kernel/head_64.S                 |    2 +-
 arch/sparc/kernel/init_task.c               |    2 +-
 arch/sparc/kernel/vmlinux.lds.S             |   14 ++--
 arch/um/include/asm/common.lds.S            |    4 +-
 arch/um/kernel/dyn.lds.S                    |    4 +-
 arch/um/kernel/init_task.c                  |    4 +-
 arch/um/kernel/uml.lds.S                    |    4 +-
 arch/x86/Kconfig                            |    1 +
 arch/x86/boot/compressed/head_32.S          |    2 +-
 arch/x86/boot/compressed/head_64.S          |    2 +-
 arch/x86/boot/compressed/relocs.c           |    2 +-
 arch/x86/boot/compressed/vmlinux.scr        |    2 +-
 arch/x86/boot/compressed/vmlinux_32.lds     |   14 ++-
 arch/x86/boot/compressed/vmlinux_64.lds     |   10 +-
 arch/x86/include/asm/cache.h                |    4 +-
 arch/x86/kernel/acpi/wakeup_32.S            |    2 +-
 arch/x86/kernel/head_32.S                   |    6 +-
 arch/x86/kernel/head_64.S                   |    4 +-
 arch/x86/kernel/init_task.c                 |    4 +-
 arch/x86/kernel/setup_percpu.c              |    2 +-
 arch/x86/kernel/traps.c                     |    2 +-
 arch/x86/kernel/vmlinux_32.lds.S            |   29 +++---
 arch/x86/kernel/vmlinux_64.lds.S            |   27 +++---
 arch/xtensa/kernel/head.S                   |    2 +-
 arch/xtensa/kernel/init_task.c              |    2 +-
 arch/xtensa/kernel/vmlinux.lds.S            |    6 +-
 include/asm-frv/init.h                      |    8 +-
 include/asm-generic/vmlinux.lds.h           |   35 ++++---
 include/linux/cache.h                       |    2 +-
 include/linux/init.h                        |    8 +-
 include/linux/linkage.h                     |    4 +-
 include/linux/percpu.h                      |    2 +-
 include/linux/spinlock.h                    |    2 +-
 kernel/module.c                             |    2 +-
 lib/Kconfig.debug                           |   18 +++
 scripts/mod/file2alias.c                    |    6 +-
 scripts/mod/modpost.c                       |  155 ++++++++++++++++-----------
 scripts/mod/modpost.h                       |   43 ++++++++
 scripts/recordmcount.pl                     |    6 +-
 144 files changed, 513 insertions(+), 407 deletions(-)

