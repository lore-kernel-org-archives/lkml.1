Return-Path: <linux-kernel-owner+w=401wt.eu-S1751873AbZJNGDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873AbZJNGDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 02:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbZJNGDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 02:03:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:58648 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613AbZJNGDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 02:03:15 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
       akpm@linux-foundation.org, rostedt@goodmis.org, hpa@zytor.com,
       cebbert@redhat.com
Subject: [RFC percpu#for-next] percpu: drop per_cpu__ prefix and add sparse annotations, take#2
Date: Wed, 14 Oct 2009 15:01:49 +0900
Message-Id: <1255500125-3210-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 06:02:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, all.

This is expanded version of Rusty's drop per_cpu__ prefix patchset
which first appeared way back and has been bit-rotting waiting for all
archs to move to the dynamic percpu allocator.  Now that it's
complete.  I tried to refresh Rusty's patchset and I ended up with
this rather large patchset.

This change has the following benefits.

* Allow unifying different percpu accessors.  With recent changes,
  static and dynamic variables are equal but we still have various now
  equivalent but slightly different accessors.  Dropping special
  handling of static percpu variable symbols will allow unifying them.

* Provide proper protection against incorrect accesses.  With dynamic
  ones becoming the first class citizens and addition of this_cpu_*()
  ops, the protection offered by __per_cpu_ prefixing has been
  diluted.  The usage of dynamic percpu variables and pointer
  variables will keep expanding and the prefixing simply can't cover
  anything not involving static symbols while accessors which don't
  require the prefix allow the same accessbility to both static and
  dynamic ones circumventing any existing protection.

This is the second take.  The cc list was too long on the first post
and lkml rejected it.  Changes from the first post are...

* Slight update on patch descriptions.

* Added Acked and Reviewed-by's.

* Updated against the current percpu#for-next.

  0001-vmalloc-fix-use-of-non-existent-percpu-variable-in-p.patch
  0002-percpu-make-alloc_percpu-handle-array-types.patch
  0003-percpu-remove-some-sparse-warnings.patch
  0004-percpu-make-percpu-symbols-under-kernel-and-mm-uniqu.patch
  0005-percpu-make-percpu-symbols-in-tracer-unique.patch
  0006-percpu-make-percpu-symbols-in-oprofile-unique.patch
  0007-percpu-make-percpu-symbols-in-cpufreq-unique.patch
  0008-percpu-make-percpu-symbols-in-xen-unique.patch
  0009-percpu-make-percpu-symbols-in-x86-unique.patch
  0010-percpu-make-percpu-symbols-in-powerpc-unique.patch
  0011-percpu-make-percpu-symbols-in-ia64-unique.patch
  0012-percpu-make-misc-percpu-symbols-unique.patch
  0013-percpu-remove-per_cpu__-prefix.patch
  0014-percpu-make-access-macros-universal.patch
  0015-percpu-add-__percpu-for-sparse.patch
  0016-percpu-make-accessors-check-for-percpu-pointer-in-sp.patch

0001-0002 fix misc stuff (not strictly necessary for upstream at this
point).

0003 removes existing sparse warnings triggered by percpu code.

0004-0012 make percpu symbols unique.  These patches are of larger
scope than Rusty's patch mainly because of the global visibility of
static percpu variables (for __weak usage in alpha and s390).  So, I
audited all percpu variables and made sure they are unique in global
namespace even with per_cpu__ prefix removed and they don't clash with
local variable usages.  If you're maintainer of the affected
subsystem, please ack the patch.  If you think a patch better be
routed through different tree, please let me know.  As long as it's a
stable git tree, the patch can go there and percpu tree can pull from
it.

0013-0014 remove per_cpu__ prefix and make all percpu accessors safe
to use for both static and dynamic percpu variables.

0015-0016 add sparse annotations to catch incorrect accesses.  BTW,
there are way too many existing sparse warnings which makes it very
difficult to verify stuff.  Is this expected?

This unification of static and dynamic variable handlings kind of
brings out the ugliness of the current percpu interface.  There are
different macros doing the same thing, names are inconsistent and too
many take lvalue when they should take a pointer.  So, it seems we
definitely can use some cleanup here.

This patchset is available in the following git tree.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git unified-symbols

and contains the following changes.

 arch/blackfin/mach-common/entry.S          |    4 
 arch/cris/arch-v10/kernel/entry.S          |    2 
 arch/cris/arch-v32/mm/mmu.S                |    2 
 arch/ia64/include/asm/percpu.h             |    4 
 arch/ia64/include/asm/processor.h          |    6 -
 arch/ia64/kernel/head.S                    |    4 
 arch/ia64/kernel/ia64_ksyms.c              |    4 
 arch/ia64/kernel/mca_asm.S                 |    2 
 arch/ia64/kernel/relocate_kernel.S         |    2 
 arch/ia64/kernel/setup.c                   |    4 
 arch/ia64/mm/discontig.c                   |    5 -
 arch/ia64/sn/kernel/sn2/sn2_smp.c          |    8 -
 arch/ia64/xen/irq_xen.c                    |  131 ++++++++++++++---------------
 arch/ia64/xen/time.c                       |   22 ++--
 arch/microblaze/include/asm/entry.h        |    2 
 arch/mn10300/kernel/kprobes.c              |   61 ++++++-------
 arch/parisc/lib/fixup.S                    |    8 -
 arch/powerpc/include/asm/smp.h             |    2 
 arch/powerpc/kernel/perf_callchain.c       |    4 
 arch/powerpc/kernel/setup-common.c         |    4 
 arch/powerpc/kernel/smp.c                  |    2 
 arch/powerpc/platforms/cell/interrupt.c    |   14 +--
 arch/powerpc/platforms/pseries/dtl.c       |    4 
 arch/powerpc/platforms/pseries/hvCall.S    |    2 
 arch/sparc/kernel/nmi.c                    |    6 -
 arch/sparc/kernel/rtrap_64.S               |    8 -
 arch/x86/include/asm/percpu.h              |   63 ++++++-------
 arch/x86/include/asm/system.h              |    8 -
 arch/x86/kernel/apic/nmi.c                 |    6 -
 arch/x86/kernel/cpu/common.c               |    8 -
 arch/x86/kernel/cpu/cpu_debug.c            |   30 +++---
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |   28 +++---
 arch/x86/kernel/cpu/intel_cacheinfo.c      |   54 +++++------
 arch/x86/kernel/ds.c                       |    4 
 arch/x86/kernel/head_32.S                  |    6 -
 arch/x86/kernel/vmlinux.lds.S              |    4 
 arch/x86/kvm/svm.c                         |   63 ++++++-------
 arch/x86/xen/smp.c                         |   41 ++++-----
 arch/x86/xen/time.c                        |   24 ++---
 arch/x86/xen/xen-asm_32.S                  |    4 
 drivers/cpufreq/cpufreq.c                  |   16 +--
 drivers/cpufreq/freq_table.c               |   12 +-
 drivers/crypto/padlock-aes.c               |   12 +-
 drivers/lguest/x86/core.c                  |    6 -
 drivers/oprofile/cpu_buffer.c              |   19 +---
 drivers/oprofile/cpu_buffer.h              |    4 
 drivers/oprofile/oprofile_stats.c          |    4 
 drivers/s390/net/netiucv.c                 |    8 -
 include/asm-generic/percpu.h               |   18 ++-
 include/linux/compiler.h                   |    4 
 include/linux/percpu-defs.h                |   41 +++++----
 include/linux/percpu.h                     |   94 +++++++++++---------
 include/linux/vmstat.h                     |    8 -
 kernel/lockdep.c                           |   11 +-
 kernel/rcutorture.c                        |    8 -
 kernel/sched.c                             |    8 -
 kernel/softirq.c                           |    4 
 kernel/softlockup.c                        |   54 +++++------
 kernel/time/timer_stats.c                  |   11 +-
 kernel/trace/trace.c                       |   10 +-
 kernel/trace/trace_functions_graph.c       |    4 
 kernel/trace/trace_hw_branches.c           |   51 +++++------
 mm/percpu.c                                |    1 
 mm/slab.c                                  |   18 +--
 mm/vmalloc.c                               |    4 
 mm/vmstat.c                                |    7 -
 66 files changed, 562 insertions(+), 535 deletions(-)

Thanks.

--
tejun
