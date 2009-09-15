Return-Path: <linux-kernel-owner+w=401wt.eu-S1758205AbZIOHYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205AbZIOHYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 03:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758194AbZIOHYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 03:24:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:55440 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758179AbZIOHYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 03:24:38 -0400
Message-ID: <4AAF411C.2040501@kernel.org>
Date: Tue, 15 Sep 2009 16:24:12 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
CC: Nick Piggin <npiggin@suse.de>, Rusty Russell <rusty@rustcorp.com.au>
Subject: [GIT PULL] percpu for v2.6.32
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 15 Sep 2009 07:24:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Please consider pulling from

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-linus

to receive percpu changes.  Pulling will cause the following conflict
at kernel/sched.c::298.

  <<<<<<< HEAD
  static DEFINE_PER_CPU_SHARED_ALIGNED(struct cfs_rq, init_cfs_rq);
  =======
  static DEFINE_PER_CPU(struct cfs_rq, init_tg_cfs_rq) ____cacheline_aligned_in_smp;
  >>>>>>> 2ca7d674d7ab2220707b2ada0b690c0e7c95e7ac
  #endif /* CONFIG_FAIR_GROUP_SCHED */

Which can be resolved as

  static DEFINE_PER_CPU_SHARED_ALIGNED(struct cfs_rq, init_tg_cfs_rq);

There have been a lot of changes.  Major changes are,

* Percpu allocator now does sparse congruent allocation in vmalloc
  area, which allows archs to allocate the first percpu units for each
  cpu in whatever way they want.  percpu allocator will allocate
  further chunks while maintaining their relative offsets.  This
  allows archs to simply alloc bootmem for each cpu and then feed the
  addresses to the percpu allocator.  So, the first percpu chunk (the
  static percpu variables and a bit of reserved space for dynamic
  ones) can share the usual linear address mapping.

  This makes arch implementations very simple and archs no longer have
  to trade off between allocating in NUMA-friendly way and added TLB
  pressure.  The removal of aliases also allows removing pageattr
  special case handling on x86.

* With embedded allocator extended to handle sparse embedding, lpage
  remapping allocator is no longer necessary and removed.  Internal
  implementation has been made more flexible in the process and arch
  specific code has been made generic.  If we ever need large pages
  for dynamic percpu allocations, it should be pretty easy to
  implement now.

* All arches except for ia64 have been converted to use the new
  allocator.

* This merge will bring the annoying limitation where all percpu
  symbols including the static ones need to be unique.  This was
  necessary to convert alpha and s390 to the new allocator.  The
  problem was that those archs assume static symbols to be addressable
  with reduced addressing range.  The assumption can be met for the
  kernel image but module texts and their percpu data end up very far
  breaking the assumption.  Using __weak attribute for percpu symbols
  forces the compiler to generate GOT based long addressing and thus
  works around the problem but with the said annoying restriction.

  Only alpha and s390 require it but CONFIG_DEBUG_FORCE_WEAK_PER_CPU
  enables the restriction for all so that we can avoid introducing
  duplicate symbols.

  This restriction can be lifted in one of the following two ways.

  1. Teaching gcc that those symbols aren't going to be located near
     text.  Most likely a new variable attribute.

  2. Reserving memory area near builtin text so that module text and
     data can be loaded near builtin text.  Percpu allocator already
     supports reserved area for module percpu variables in the first
     chunk, so half of the problem is already solved.

  #2 is much more likely and probably the right thing to do.  The only
  problem is that alpha and s390 are very difficult to come by.
  Fortunately, the uniqueness restriction is more of annoyance than
  pain.  For the time being, I think it should be okay but if anyone
  is interested in lifting this restriction, I'll be more than happy
  to help.

Thanks.
---
Fenghua Yu (1):
      ia64: Fix setup_per_cpu_areas() compilation error

Jesper Nilsson (1):
      CRIS: Change DEFINE_PER_CPU of current_pgd to be non volatile.

Michal Simek (1):
      microblaze: include EXIT_TEXT to _stext

Tejun Heo (46):
      percpu: use dynamic percpu allocator as the default percpu allocator
      linker script: throw away .discard section
      percpu: cleanup percpu array definitions
      percpu: use DEFINE_PER_CPU_SHARED_ALIGNED()
      percpu: clean up percpu variable definitions
      percpu: implement optional weak percpu definitions
      alpha: kill unnecessary __used attribute in PER_CPU_ATTRIBUTES
      alpha: switch to dynamic percpu allocator
      s390: switch to dynamic percpu allocator
      sparc64: fix build breakage introduced by percpu-convert-most patchset
      percpu: use __weak only in the definition of weak percpu variables
      Merge branch 'master' into for-next
      x86: make pcpu_chunk_addr_search() matching stricter
      percpu: drop @unit_size from embed first chunk allocator
      x86,percpu: generalize 4k first chunk allocator
      percpu: make 4k first chunk allocator map memory
      x86,percpu: generalize lpage first chunk allocator
      percpu: simplify pcpu_setup_first_chunk()
      percpu: reorder a few functions in mm/percpu.c
      percpu: drop pcpu_chunk->page[]
      percpu: allow non-linear / sparse cpu -> unit mapping
      percpu: teach large page allocator about NUMA
      linker script: unify usage of discard definition
      percpu: add dummy pcpu_lpage_remapped() for !CONFIG_SMP
      Merge branch 'percpu-for-linus' into percpu-for-next
      percpu: fix pcpu_reclaim() locking
      percpu: improve boot messages
      percpu: rename 4k first chunk allocator to page
      percpu: build first chunk allocators selectively
      percpu: generalize first chunk allocator selection
      percpu: drop @static_size from first chunk allocators
      percpu: make @dyn_size mandatory for pcpu_setup_first_chunk()
      percpu: add @align to pcpu_fc_alloc_fn_t
      percpu: move pcpu_lpage_build_unit_map() and pcpul_lpage_dump_cfg() upward
      percpu: introduce pcpu_alloc_info and pcpu_group_info
      percpu: add pcpu_unit_offsets[]
      percpu: add chunk->base_addr
      vmalloc: separate out insert_vmalloc_vm()
      vmalloc: implement pcpu_get_vm_areas()
      percpu: use group information to allocate vmap areas sparsely
      percpu: update embedding first chunk allocator to handle sparse units
      x86,percpu: use embedding for 64bit NUMA and page for 32bit NUMA
      percpu: kill lpage first chunk allocator
      sparc64: use embedding percpu first chunk allocator
      powerpc64: convert to dynamic percpu allocator
      Merge branch 'for-next' into for-linus

 Documentation/kernel-parameters.txt    |   11 +-
 Makefile                               |    2 +-
 arch/alpha/include/asm/percpu.h        |  100 +--
 arch/alpha/include/asm/tlbflush.h      |    1 +
 arch/alpha/kernel/vmlinux.lds.S        |    9 +-
 arch/arm/kernel/vmlinux.lds.S          |    1 +
 arch/avr32/kernel/vmlinux.lds.S        |    9 +-
 arch/blackfin/kernel/vmlinux.lds.S     |    5 +-
 arch/blackfin/mm/sram-alloc.c          |    6 +-
 arch/cris/include/asm/mmu_context.h    |    3 +-
 arch/cris/kernel/vmlinux.lds.S         |    9 +-
 arch/cris/mm/fault.c                   |    2 +-
 arch/frv/kernel/vmlinux.lds.S          |    2 +
 arch/h8300/kernel/vmlinux.lds.S        |    5 +-
 arch/ia64/Kconfig                      |    3 +
 arch/ia64/kernel/setup.c               |    6 +
 arch/ia64/kernel/smp.c                 |    3 +-
 arch/ia64/kernel/vmlinux.lds.S         |   16 +-
 arch/ia64/sn/kernel/setup.c            |    2 +-
 arch/m32r/kernel/vmlinux.lds.S         |   10 +-
 arch/m68k/kernel/vmlinux-std.lds       |   10 +-
 arch/m68k/kernel/vmlinux-sun3.lds      |    9 +-
 arch/m68knommu/kernel/vmlinux.lds.S    |    7 +-
 arch/microblaze/kernel/vmlinux.lds.S   |    6 +-
 arch/mips/kernel/vmlinux.lds.S         |   21 +-
 arch/mn10300/kernel/vmlinux.lds.S      |    8 +-
 arch/parisc/kernel/vmlinux.lds.S       |    8 +-
 arch/powerpc/Kconfig                   |    3 +
 arch/powerpc/kernel/setup_64.c         |   61 +-
 arch/powerpc/kernel/vmlinux.lds.S      |    9 +-
 arch/powerpc/mm/stab.c                 |    2 +-
 arch/powerpc/platforms/ps3/smp.c       |    2 +-
 arch/s390/include/asm/percpu.h         |   32 +-
 arch/s390/kernel/vmlinux.lds.S         |    9 +-
 arch/sh/kernel/vmlinux.lds.S           |   10 +-
 arch/sparc/Kconfig                     |    2 +-
 arch/sparc/kernel/smp_64.c             |  132 +---
 arch/sparc/kernel/vmlinux.lds.S        |    8 +-
 arch/um/include/asm/common.lds.S       |    5 -
 arch/um/kernel/dyn.lds.S               |    2 +
 arch/um/kernel/uml.lds.S               |    2 +
 arch/x86/Kconfig                       |    5 +-
 arch/x86/include/asm/percpu.h          |    9 -
 arch/x86/kernel/cpu/cpu_debug.c        |    4 +-
 arch/x86/kernel/cpu/mcheck/mce.c       |    8 +-
 arch/x86/kernel/cpu/mcheck/mce_amd.c   |    2 +-
 arch/x86/kernel/cpu/perf_counter.c     |   14 +-
 arch/x86/kernel/setup_percpu.c         |  364 +-------
 arch/x86/kernel/vmlinux.lds.S          |   11 +-
 arch/x86/mm/pageattr.c                 |   21 +-
 arch/xtensa/kernel/vmlinux.lds.S       |   13 +-
 block/as-iosched.c                     |   10 +-
 block/cfq-iosched.c                    |   10 +-
 drivers/cpufreq/cpufreq_conservative.c |   12 +-
 drivers/cpufreq/cpufreq_ondemand.c     |   15 +-
 drivers/xen/events.c                   |   13 +-
 include/asm-generic/vmlinux.lds.h      |   24 +-
 include/linux/percpu-defs.h            |   66 ++-
 include/linux/percpu.h                 |   88 ++-
 include/linux/vmalloc.h                |    6 +
 init/main.c                            |   24 -
 kernel/module.c                        |    6 +-
 kernel/perf_counter.c                  |    6 +-
 kernel/sched.c                         |    4 +-
 kernel/trace/trace_events.c            |    6 +-
 lib/Kconfig.debug                      |   15 +
 mm/Makefile                            |    2 +-
 mm/allocpercpu.c                       |   28 +
 mm/kmemleak-test.c                     |    6 +-
 mm/page-writeback.c                    |    5 +-
 mm/percpu.c                            | 1420 ++++++++++++++++++++++++--------
 mm/quicklist.c                         |    2 +-
 mm/slub.c                              |    4 +-
 mm/vmalloc.c                           |  338 +++++++-
 net/ipv4/syncookies.c                  |    5 +-
 net/ipv6/syncookies.c                  |    5 +-
 net/rds/ib_stats.c                     |    2 +-
 net/rds/iw_stats.c                     |    2 +-
 net/rds/page.c                         |    2 +-
 scripts/module-common.lds              |    8 +
 80 files changed, 1910 insertions(+), 1228 deletions(-)
 create mode 100644 scripts/module-common.lds

--
tejun
