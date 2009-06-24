Return-Path: <linux-kernel-owner+w=401wt.eu-S1754698AbZFXGq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbZFXGq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 02:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754012AbZFXGqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 02:46:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:57051 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753635AbZFXGqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 02:46:06 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org,
       mingo@elte.hu, kyle@mcmartin.ca, cl@linux-foundation.org,
       Jesper.Nilsson@axis.com, benh@kernel.crashing.org,
       paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au,
       torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: [PATCHSET core/percpu] percpu: convert most archs to dynamic percpu, take#4
Date: Wed, 24 Jun 2009 15:45:14 +0900
Message-Id: <1245825924-30412-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 24 Jun 2009 06:45:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

As per David Miller's request, I trimmed most arch maintainers from cc
list and just added the arch mailing list.

This is the fourth take of percpu-convert-most-archs-to-dynamic-percpu
patchset.  Changes from the last take[L] are

* Linus nacked enforcing global definitions for all percpu variables.
  Instead, revive the dummy guard variable tricks but apply it only to
  the archs which require it (s390 and alpha) and when the
  corresponding debug option is enabled.

* Rebased on top of percpu#for-tip

Weak definitions use two guard variables.  One to enforce scope and
the other to guarantee symbol uniqueness, which add the following two
restrictions to percpu variables.

  1. percpu symbols must be unique whether static or not
  2. percpu variables can't be defined inside a function

To ease checking that the above restrictions are followed in generic
code, config option - DEBUG_FORCE_WEAK_PER_CPU - is added which forces
the use of weak definitions.

For cases where weak definition is unnecessary and if the debug option
is not set, percpu variables are declared and defined in the same way
as before this patch.

This patchset contains the following ten patches.

  0001-percpu-use-dynamic-percpu-allocator-as-the-default.patch
  0002-linker-script-throw-away-.discard-section.patch
  0003-CRIS-Change-DEFINE_PER_CPU-of-current_pgd-to-be-non.patch
  0004-percpu-cleanup-percpu-array-definitions.patch
  0005-percpu-use-DEFINE_PER_CPU_SHARED_ALIGNED.patch
  0006-percpu-clean-up-percpu-variable-definitions.patch
  0007-percpu-implement-optional-weak-percpu-definitions.patch
  0008-alpha-kill-unnecessary-__used-attribute-in-PER_CPU_.patch
  0009-alpha-switch-to-dynamic-percpu-allocator.patch
  0010-s390-switch-to-dynamic-percpu-allocator.patch

0001 converts archs which used to use the default percpu init code to
dynamic percpu allocator.  Embedding first chunk allocator is used
such that the end result is basically the same.  Kyle McMartin
reported that default allocator change breaks parisc.  The problem is
still under investigation and he is okay with pushing this patchset
forward and fixing parisc later.

0002-0006 prepares for weak percpu variable definition patch.  0007
implements weak percpu variable definitions.  0009-0010 convert s390
and alpha to dynamic percpu allocator using weak percpu variable
definitions.

This patchset is on top of the current percpu#for-tip and available in
the following git tree.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git convert-most-archs

Unless the whole approach gets nacked.  I'll keep the tree incremental
from this point on and will publish the tree through linux-next.

This patchset contains the following changes.

 Makefile                               |    2 
 arch/alpha/include/asm/percpu.h        |  100 ++-------------------------------
 arch/alpha/include/asm/tlbflush.h      |    1 
 arch/alpha/kernel/vmlinux.lds.S        |    1 
 arch/arm/kernel/vmlinux.lds.S          |    1 
 arch/avr32/kernel/vmlinux.lds.S        |    1 
 arch/blackfin/kernel/vmlinux.lds.S     |    1 
 arch/blackfin/mm/sram-alloc.c          |    6 -
 arch/cris/include/asm/mmu_context.h    |    3 
 arch/cris/kernel/vmlinux.lds.S         |    1 
 arch/cris/mm/fault.c                   |    2 
 arch/frv/kernel/vmlinux.lds.S          |    2 
 arch/h8300/kernel/vmlinux.lds.S        |    1 
 arch/ia64/Kconfig                      |    3 
 arch/ia64/kernel/smp.c                 |    3 
 arch/ia64/kernel/vmlinux.lds.S         |    1 
 arch/ia64/sn/kernel/setup.c            |    2 
 arch/m32r/kernel/vmlinux.lds.S         |    1 
 arch/m68k/kernel/vmlinux-std.lds       |    1 
 arch/m68k/kernel/vmlinux-sun3.lds      |    1 
 arch/m68knommu/kernel/vmlinux.lds.S    |    1 
 arch/microblaze/kernel/vmlinux.lds.S   |    2 
 arch/mips/kernel/vmlinux.lds.S         |    1 
 arch/mn10300/kernel/vmlinux.lds.S      |    1 
 arch/parisc/kernel/vmlinux.lds.S       |    1 
 arch/powerpc/Kconfig                   |    3 
 arch/powerpc/kernel/vmlinux.lds.S      |    1 
 arch/powerpc/mm/stab.c                 |    2 
 arch/powerpc/platforms/ps3/smp.c       |    2 
 arch/s390/include/asm/percpu.h         |   32 ++--------
 arch/s390/kernel/vmlinux.lds.S         |    1 
 arch/sh/kernel/vmlinux.lds.S           |    1 
 arch/sparc/Kconfig                     |    3 
 arch/sparc/kernel/vmlinux.lds.S        |    1 
 arch/um/kernel/dyn.lds.S               |    2 
 arch/um/kernel/uml.lds.S               |    2 
 arch/x86/Kconfig                       |    3 
 arch/x86/kernel/cpu/cpu_debug.c        |    4 -
 arch/x86/kernel/cpu/mcheck/mce.c       |    8 +-
 arch/x86/kernel/cpu/mcheck/mce_amd.c   |    2 
 arch/x86/kernel/cpu/perf_counter.c     |   14 ++--
 arch/xtensa/kernel/vmlinux.lds.S       |    1 
 block/as-iosched.c                     |   10 +--
 block/cfq-iosched.c                    |   10 +--
 drivers/cpufreq/cpufreq_conservative.c |   12 +--
 drivers/cpufreq/cpufreq_ondemand.c     |   15 ++--
 drivers/xen/events.c                   |   13 ++--
 include/asm-generic/vmlinux.lds.h      |    8 ++
 include/linux/percpu-defs.h            |   65 ++++++++++++++++++---
 include/linux/percpu.h                 |   12 ++-
 init/main.c                            |   24 -------
 kernel/module.c                        |    6 -
 kernel/perf_counter.c                  |    6 -
 kernel/sched.c                         |    4 -
 kernel/trace/trace_events.c            |    6 -
 lib/Kconfig.debug                      |   15 ++++
 mm/Makefile                            |    2 
 mm/allocpercpu.c                       |   28 +++++++++
 mm/kmemleak-test.c                     |    6 -
 mm/page-writeback.c                    |    5 -
 mm/percpu.c                            |   40 ++++++++++++-
 mm/quicklist.c                         |    2 
 mm/slub.c                              |    4 -
 net/ipv4/syncookies.c                  |    5 -
 net/ipv6/syncookies.c                  |    5 -
 net/rds/ib_stats.c                     |    2 
 net/rds/iw_stats.c                     |    2 
 net/rds/page.c                         |    2 
 scripts/module-common.lds              |    8 ++
 69 files changed, 303 insertions(+), 236 deletions(-)

Thanks.

--
tejun

[L] http://thread.gmane.org/gmane.linux.kernel.cross-arch/3818
    (some patches missing probably due to too long cc list)
