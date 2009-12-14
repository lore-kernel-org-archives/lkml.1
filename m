Return-Path: <linux-kernel-owner+w=401wt.eu-S1753050AbZLNGEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050AbZLNGEI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 01:04:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbZLNGEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 01:04:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:46261 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973AbZLNGED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 01:04:03 -0500
Message-ID: <4B25D5A2.7030806@kernel.org>
Date: Mon, 14 Dec 2009 15:05:22 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
CC: Christoph Lameter <cl@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: [GIT PULL RESEND] percpu changes for 2.6.33-rc1
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

I'm resending this PULL request as it hasn't been pulled yet and the
original one had a couple of problems including missing cc to LKML.
There now are two merge conflicts.  Both are from variable renames to
avoid global / local symbol aliases and can be easily resolved.

Please pull from the following percpu branch.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-linus

The branch contains the following changes.

* Convert the last remaining architecture, ia64, to the new allocator
  and drop the old one.

* Christoph's patches to introduce and use this_cpu_*() operations
  which optimize accesses to local percpu variable.

* Prepare the tree for dropping per_cpu__ prefix from static percpu
  variables and add __percpu sparse annotations (rename variables in
  cases where percpu and local variable use the same name).

  Ingo isn't too happy about losing the namespace separation via
  per_cpu__ prefix but I and Rusty who wrote the original sparse
  annotation patch think that this is the right way to unify static
  and dynamic percpu accessors (as they have no difference in the new
  allocator) and better misuse detection coverage can be achieved by
  using sparse annoation similar to that used for iomem and user
  pointers.

  The patches to actually drop per_cpu__ prefix and implement sparse
  annotations aren't included in this batch as sparse annotations
  haven't been added to percpu users yet.

* Several fix patches.  One of them is needed to make kdump behave
  properly with page first chunk allocator (not the default) and will
  soon be pushed out to -stable.

* Two merge commits from for-linus to for-next.  Both were used to
  pull fix commits into for-next.

Merging into f40542532e96dda5506eb76badea322f2ae4731c results in a
conflict in arch/x86/kvm/svm.c and mm/slab.c.  I'm attaching
resolution below.

Thanks.

===================
Conflict resolution
===================
--- arch/x86/kvm/svm.c.conflict	2009-12-14 13:15:44.288712779 +0900
+++ arch/x86/kvm/svm.c	2009-12-14 13:16:21.019712652 +0900
@@ -333,13 +333,8 @@
 	}
 	sd = per_cpu(svm_data, me);
 
-<<<<<<< HEAD
-	if (!svm_data) {
-		printk(KERN_ERR "svm_hardware_enable: svm_data is NULL on %d\n",
-=======
 	if (!sd) {
-		printk(KERN_ERR "svm_cpu_init: svm_data is NULL on %d\n",
->>>>>>> 51e99be00ce2713cbb841cedc997cafa6e26c7f4
+		printk(KERN_ERR "svm_hardware_enable: svm_data is NULL on %d\n",
 		       me);
 		return -EINVAL;
 	}
@@ -355,13 +350,9 @@
 	wrmsrl(MSR_EFER, efer | EFER_SVME);
 
 	wrmsrl(MSR_VM_HSAVE_PA,
-<<<<<<< HEAD
-	       page_to_pfn(svm_data->save_area) << PAGE_SHIFT);
+	       page_to_pfn(sd->save_area) << PAGE_SHIFT);
 
 	return 0;
-=======
-	       page_to_pfn(sd->save_area) << PAGE_SHIFT);
->>>>>>> 51e99be00ce2713cbb841cedc997cafa6e26c7f4
 }
 
 static void svm_cpu_uninit(int cpu)
--- mm/slab.c.conflict	2009-12-14 13:15:56.847713001 +0900
+++ mm/slab.c	2009-12-14 13:16:56.431713262 +0900
@@ -697,31 +697,7 @@
 static DEFINE_MUTEX(cache_chain_mutex);
 static struct list_head cache_chain;
 
-<<<<<<< HEAD
-static DEFINE_PER_CPU(struct delayed_work, reap_work);
-=======
-/*
- * chicken and egg problem: delay the per-cpu array allocation
- * until the general caches are up.
- */
-static enum {
-	NONE,
-	PARTIAL_AC,
-	PARTIAL_L3,
-	EARLY,
-	FULL
-} g_cpucache_up;
-
-/*
- * used by boot code to determine if it can use slab based allocator
- */
-int slab_is_available(void)
-{
-	return g_cpucache_up >= EARLY;
-}
-
 static DEFINE_PER_CPU(struct delayed_work, slab_reap_work);
->>>>>>> 51e99be00ce2713cbb841cedc997cafa6e26c7f4
 
 static inline struct array_cache *cpu_cache_get(struct kmem_cache *cachep)
 {


==================
Summary of changes
==================

Christoph Lameter (13):
      this_cpu: Introduce this_cpu_ptr() and generic this_cpu_* operations
      this_cpu: Implement X86 optimized this_cpu operations
      this_cpu: Use this_cpu operations for SNMP statistics
      this_cpu: Use this_cpu operations for NFS statistics
      this_cpu: Use this_cpu ops for network statistics
      this_cpu: Straight transformations
      this_cpu: Eliminate get/put_cpu
      this_cpu: xfs_icsb_modify_counters does not need "cpu" variable
      this_cpu: Use this_cpu_ptr in crypto subsystem
      this_cpu: Use this_cpu ops for VM statistics
      this_cpu: Use this_cpu operations in RCU
      this_cpu: Use this_cpu_xx in nmi handling
      this_cpu: Use this_cpu_xx for ftrace

Tejun Heo (22):
      ia64: don't alias VMALLOC_END to vmalloc_end
      ia64: initialize cpu maps early
      ia64: allocate percpu area for cpu0 like percpu areas for other cpus
      ia64: convert to dynamic percpu allocator
      percpu: kill legacy percpu allocator
      Merge branch 'for-linus' into for-next
      this_cpu: Use this_cpu_xx in trace_functions_graph.c
      vmalloc: fix use of non-existent percpu variable in put_cpu_var()
      percpu: make alloc_percpu() handle array types
      percpu: remove some sparse warnings
      percpu: make percpu symbols under kernel/ and mm/ unique
      percpu: make percpu symbols in tracer unique
      percpu: make percpu symbols in oprofile unique
      percpu: make percpu symbols in cpufreq unique
      percpu: make percpu symbols in xen unique
      percpu: make percpu symbols in x86 unique
      percpu: make percpu symbols in powerpc unique
      percpu: make percpu symbols in ia64 unique
      percpu: make misc percpu symbols unique
      percpu: add missing per_cpu_ptr_to_phys() definition for UP
      Merge branch 'for-linus' into for-next
      m68k: rename global variable vmalloc_end to m68k_vmalloc_end

Vivek Goyal (1):
      percpu: Fix kdump failure if booted with percpu_alloc=page

 arch/ia64/Kconfig                          |    3 -
 arch/ia64/include/asm/meminit.h            |    2 +-
 arch/ia64/include/asm/pgtable.h            |    3 +-
 arch/ia64/include/asm/processor.h          |    6 +-
 arch/ia64/kernel/acpi.c                    |   33 +--
 arch/ia64/kernel/head.S                    |    4 +-
 arch/ia64/kernel/ia64_ksyms.c              |    2 +-
 arch/ia64/kernel/mca_asm.S                 |    2 +-
 arch/ia64/kernel/relocate_kernel.S         |    2 +-
 arch/ia64/kernel/setup.c                   |   27 +--
 arch/ia64/kernel/vmlinux.lds.S             |   11 +-
 arch/ia64/mm/contig.c                      |   99 +++++--
 arch/ia64/mm/discontig.c                   |  129 ++++++++-
 arch/ia64/mm/init.c                        |    4 +-
 arch/ia64/sn/kernel/sn2/sn2_smp.c          |    8 +-
 arch/ia64/xen/irq_xen.c                    |  131 +++++----
 arch/ia64/xen/time.c                       |   22 +-
 arch/m68k/include/asm/pgtable_mm.h         |    4 +-
 arch/m68k/sun3/mmu_emu.c                   |    8 +-
 arch/mn10300/kernel/kprobes.c              |   61 ++--
 arch/powerpc/include/asm/smp.h             |    2 +-
 arch/powerpc/kernel/perf_callchain.c       |    4 +-
 arch/powerpc/kernel/setup-common.c         |    4 +-
 arch/powerpc/kernel/smp.c                  |    2 +-
 arch/powerpc/platforms/cell/interrupt.c    |   14 +-
 arch/powerpc/platforms/pseries/dtl.c       |    4 +-
 arch/sparc/kernel/nmi.c                    |    8 +-
 arch/x86/include/asm/percpu.h              |  104 ++++++-
 arch/x86/kernel/apic/nmi.c                 |    8 +-
 arch/x86/kernel/cpu/common.c               |    8 +-
 arch/x86/kernel/cpu/cpu_debug.c            |   30 +-
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |   28 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c      |   54 ++--
 arch/x86/kernel/ds.c                       |    4 +-
 arch/x86/kvm/svm.c                         |   63 ++--
 arch/x86/xen/smp.c                         |   41 ++--
 arch/x86/xen/time.c                        |   24 +-
 crypto/cryptd.c                            |    2 +-
 drivers/base/cpu.c                         |    2 +-
 drivers/cpufreq/cpufreq.c                  |   16 +-
 drivers/cpufreq/freq_table.c               |   12 +-
 drivers/crypto/padlock-aes.c               |   12 +-
 drivers/dma/dmaengine.c                    |   36 +--
 drivers/infiniband/hw/ehca/ehca_irq.c      |    3 +-
 drivers/lguest/x86/core.c                  |    6 +-
 drivers/net/chelsio/sge.c                  |    5 +-
 drivers/net/loopback.c                     |    2 +-
 drivers/net/veth.c                         |    7 +-
 drivers/oprofile/cpu_buffer.c              |   19 +-
 drivers/oprofile/cpu_buffer.h              |    4 +-
 drivers/oprofile/oprofile_stats.c          |    4 +-
 drivers/s390/net/netiucv.c                 |    8 +-
 fs/ext4/mballoc.c                          |    2 +-
 fs/nfs/iostat.h                            |   24 +--
 fs/xfs/xfs_mount.c                         |   12 +-
 include/asm-generic/percpu.h               |    5 +
 include/linux/percpu-defs.h                |    1 +
 include/linux/percpu.h                     |  434 ++++++++++++++++++++++++++--
 include/linux/vmstat.h                     |   10 +-
 include/net/neighbour.h                    |    7 +-
 include/net/netfilter/nf_conntrack.h       |    4 +-
 include/net/snmp.h                         |   50 ++--
 kernel/lockdep.c                           |   11 +-
 kernel/module.c                            |  150 ----------
 kernel/rcutorture.c                        |    8 +-
 kernel/sched.c                             |    8 +-
 kernel/softirq.c                           |    4 +-
 kernel/softlockup.c                        |   54 ++--
 kernel/time/timer_stats.c                  |   11 +-
 kernel/trace/trace.c                       |   12 +-
 kernel/trace/trace.h                       |    2 +-
 kernel/trace/trace_functions_graph.c       |    4 +-
 kernel/trace/trace_hw_branches.c           |   51 ++--
 mm/Makefile                                |    4 -
 mm/allocpercpu.c                           |  177 -----------
 mm/percpu.c                                |   24 ++-
 mm/slab.c                                  |   18 +-
 mm/vmalloc.c                               |    4 +-
 mm/vmstat.c                                |    7 +-
 79 files changed, 1222 insertions(+), 977 deletions(-)
 delete mode 100644 mm/allocpercpu.c

--
tejun
