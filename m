Return-Path: <linux-kernel-owner+w=401wt.eu-S1756486AbZFAJC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486AbZFAJC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 05:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756281AbZFAJBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 05:01:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:36576 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756314AbZFAJBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 05:01:46 -0400
From: Tejun Heo <tj@kernel.org>
To: JBeulich@novell.com, andi@firstfloor.org, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, x86@kernel.org,
       ink@jurassic.park.msu.ru, rth@twiddle.net, linux@arm.linux.org.uk,
       hskinnemoen@atmel.com, cooloney@kernel.org, starvik@axis.com,
       jesper.nilsson@axis.com, dhowells@redhat.com,
       ysato@users.sourceforge.jp, tony.luck@intel.com, takata@linux-m32r.org,
       geert@linux-m68k.org, monstr@monstr.eu, ralf@linux-mips.org,
       kyle@mcmartin.ca, benh@kernel.crashing.org, paulus@samba.org,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, lethal@linux-sh.org,
       davem@davemloft.net, jdike@addtoit.com, chris@zankel.net,
       rusty@rustcorp.com.au
Subject: [GIT PATCH core/percpu] percpu: convert most archs to dynamic percpu, take#2
Date: Mon,  1 Jun 2009 17:58:21 +0900
Message-Id: <1243846708-805-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 01 Jun 2009 08:58:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Upon ack, please pull from the following git tree.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu

This is the second take of percpu-convert-most-archs-to-dynamic-percpu
patchset.  Changes from the last take[L] are

* Rebased on top of tj-percpu-fix-remap.

* As suggested by Rusty Russell, complex percpu definition macros
  which used dummy variables to guarantee scope and uniqueness have
  been dropped.  Instead, now all percpu variables are required to be
  global.  No statics allowed.  All in-kernel users are converted by
  this patchset.

* Linker script .discard section handling patch no longer necessary
  and dropped.

This patchset contains the following seven patches.

  0001-percpu-use-dynamic-percpu-allocator-as-the-default.patch
  0002-percpu-cleanup-percpu-array-definitions.patch
  0003-percpu-clean-up-percpu-variable-definitions.patch
  0004-percpu-enforce-global-definition.patch
  0005-alpha-kill-unnecessary-__used-attribute-in-PER_CPU_.patch
  0006-alpha-switch-to-dynamic-percpu-allocator.patch
  0007-s390-switch-to-dynamic-percpu-allocator.patch

0001 converts archs which are easy to convert and make dynamic percpu
allocator the default.  0002-0003 prepares for percpu variable
definition change.  0004 enforces global definitions.  0005-0007
convert alpha and s390 to dynamic percpu variable using the weak
attribute.

This patchset is on top of

core/percpu (e1b9aa3f47242e757c776a3771bb6613e675bf9c)
+ linus-2.6#master (3218911f839b6c85acbf872ad264ea69aa4d89ad)
+ x86-percpu-fix-pageattr patchset, take#3 [1]

and contains the following changes.

 arch/alpha/include/asm/percpu.h                  |  101 ++---------------------
 arch/alpha/include/asm/tlbflush.h                |    1 
 arch/arm/kernel/smp.c                            |    2 
 arch/arm/mach-realview/localtimer.c              |    2 
 arch/avr32/kernel/cpu.c                          |    2 
 arch/blackfin/mach-common/smp.c                  |    2 
 arch/blackfin/mm/sram-alloc.c                    |   22 ++---
 arch/cris/include/asm/mmu_context.h              |    2 
 arch/ia64/Kconfig                                |    3 
 arch/ia64/kernel/crash.c                         |    2 
 arch/ia64/kernel/smp.c                           |    4 
 arch/ia64/kernel/traps.c                         |    2 
 arch/ia64/kvm/kvm-ia64.c                         |    2 
 arch/ia64/sn/kernel/setup.c                      |    2 
 arch/ia64/xen/irq_xen.c                          |   24 ++---
 arch/mips/kernel/cevt-bcm1480.c                  |    6 -
 arch/mips/kernel/cevt-sb1250.c                   |    6 -
 arch/mips/kernel/topology.c                      |    2 
 arch/mips/sgi-ip27/ip27-timer.c                  |    4 
 arch/parisc/kernel/irq.c                         |    2 
 arch/parisc/kernel/topology.c                    |    2 
 arch/powerpc/Kconfig                             |    3 
 arch/powerpc/kernel/cacheinfo.c                  |    2 
 arch/powerpc/kernel/process.c                    |    2 
 arch/powerpc/kernel/sysfs.c                      |    4 
 arch/powerpc/kernel/time.c                       |    6 -
 arch/powerpc/mm/pgtable.c                        |    2 
 arch/powerpc/mm/stab.c                           |    4 
 arch/powerpc/oprofile/op_model_cell.c            |    2 
 arch/powerpc/platforms/cell/cpufreq_spudemand.c  |    2 
 arch/powerpc/platforms/cell/interrupt.c          |    2 
 arch/powerpc/platforms/ps3/interrupt.c           |    2 
 arch/powerpc/platforms/ps3/smp.c                 |    2 
 arch/powerpc/platforms/pseries/dtl.c             |    2 
 arch/powerpc/platforms/pseries/iommu.c           |    2 
 arch/s390/appldata/appldata_base.c               |    2 
 arch/s390/include/asm/percpu.h                   |   32 +------
 arch/s390/kernel/nmi.c                           |    2 
 arch/s390/kernel/smp.c                           |    2 
 arch/s390/kernel/time.c                          |    4 
 arch/s390/kernel/vtime.c                         |    2 
 arch/sh/kernel/timers/timer-broadcast.c          |    2 
 arch/sh/kernel/topology.c                        |    2 
 arch/sparc/Kconfig                               |    3 
 arch/sparc/kernel/nmi.c                          |    6 -
 arch/sparc/kernel/pci_sun4v.c                    |    2 
 arch/sparc/kernel/sysfs.c                        |    4 
 arch/sparc/kernel/time_64.c                      |    4 
 arch/x86/Kconfig                                 |    3 
 arch/x86/kernel/apic/apic.c                      |    2 
 arch/x86/kernel/apic/nmi.c                       |    8 -
 arch/x86/kernel/cpu/common.c                     |    2 
 arch/x86/kernel/cpu/cpu_debug.c                  |   10 +-
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c       |    4 
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c        |    2 
 arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c |    4 
 arch/x86/kernel/cpu/intel_cacheinfo.c            |    6 -
 arch/x86/kernel/cpu/mcheck/mce_64.c              |    4 
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c          |    4 
 arch/x86/kernel/cpu/mcheck/mce_intel_64.c        |    2 
 arch/x86/kernel/cpu/mcheck/therm_throt.c         |    4 
 arch/x86/kernel/cpu/perfctr-watchdog.c           |    2 
 arch/x86/kernel/ds.c                             |    4 
 arch/x86/kernel/hpet.c                           |    2 
 arch/x86/kernel/irq_32.c                         |    8 -
 arch/x86/kernel/kvm.c                            |    2 
 arch/x86/kernel/kvmclock.c                       |    2 
 arch/x86/kernel/paravirt.c                       |    2 
 arch/x86/kernel/process_64.c                     |    2 
 arch/x86/kernel/smpboot.c                        |    2 
 arch/x86/kernel/tlb_uv.c                         |    6 -
 arch/x86/kernel/topology.c                       |    2 
 arch/x86/kernel/uv_time.c                        |    2 
 arch/x86/kernel/vmiclock_32.c                    |    2 
 arch/x86/kvm/svm.c                               |    2 
 arch/x86/kvm/vmx.c                               |    6 -
 arch/x86/kvm/x86.c                               |    2 
 arch/x86/mm/kmmio.c                              |    2 
 arch/x86/mm/mmio-mod.c                           |    4 
 arch/x86/oprofile/nmi_int.c                      |    4 
 arch/x86/xen/enlighten.c                         |    2 
 arch/x86/xen/multicalls.c                        |    2 
 arch/x86/xen/smp.c                               |    8 -
 arch/x86/xen/spinlock.c                          |    4 
 arch/x86/xen/time.c                              |   10 +-
 block/as-iosched.c                               |   10 +-
 block/blk-softirq.c                              |    2 
 block/cfq-iosched.c                              |   10 +-
 crypto/sha512_generic.c                          |    2 
 drivers/acpi/processor_core.c                    |    2 
 drivers/acpi/processor_thermal.c                 |    2 
 drivers/base/cpu.c                               |    2 
 drivers/char/random.c                            |    2 
 drivers/connector/cn_proc.c                      |    2 
 drivers/cpufreq/cpufreq.c                        |    8 -
 drivers/cpufreq/cpufreq_conservative.c           |   12 +-
 drivers/cpufreq/cpufreq_ondemand.c               |   15 +--
 drivers/cpufreq/cpufreq_stats.c                  |    2 
 drivers/cpufreq/cpufreq_userspace.c              |   11 +-
 drivers/cpufreq/freq_table.c                     |    2 
 drivers/cpuidle/governors/ladder.c               |    2 
 drivers/cpuidle/governors/menu.c                 |    2 
 drivers/crypto/padlock-aes.c                     |    2 
 drivers/lguest/page_tables.c                     |    2 
 drivers/lguest/x86/core.c                        |    2 
 drivers/xen/events.c                             |   13 +-
 fs/buffer.c                                      |    4 
 fs/file.c                                        |    2 
 fs/namespace.c                                   |    2 
 include/linux/percpu-defs.h                      |   10 +-
 include/linux/percpu.h                           |   12 ++
 init/main.c                                      |   24 -----
 kernel/kprobes.c                                 |    2 
 kernel/lockdep.c                                 |    2 
 kernel/module.c                                  |    6 -
 kernel/printk.c                                  |    2 
 kernel/profile.c                                 |    4 
 kernel/rcuclassic.c                              |    4 
 kernel/rcupdate.c                                |    2 
 kernel/rcupreempt.c                              |   10 +-
 kernel/rcutorture.c                              |    4 
 kernel/sched.c                                   |   30 +++---
 kernel/sched_clock.c                             |    2 
 kernel/sched_rt.c                                |    2 
 kernel/smp.c                                     |    6 -
 kernel/softirq.c                                 |    6 -
 kernel/softlockup.c                              |    6 -
 kernel/taskstats.c                               |    4 
 kernel/time/tick-sched.c                         |    2 
 kernel/time/timer_stats.c                        |    2 
 kernel/timer.c                                   |    2 
 kernel/trace/ring_buffer.c                       |    2 
 kernel/trace/trace.c                             |    6 -
 kernel/trace/trace_hw_branches.c                 |    4 
 kernel/trace/trace_irqsoff.c                     |    2 
 kernel/trace/trace_stack.c                       |    2 
 kernel/trace/trace_sysprof.c                     |    2 
 kernel/trace/trace_workqueue.c                   |    2 
 lib/radix-tree.c                                 |    2 
 lib/random32.c                                   |    2 
 mm/Makefile                                      |    2 
 mm/allocpercpu.c                                 |   28 ++++++
 mm/page-writeback.c                              |    5 -
 mm/percpu.c                                      |   40 ++++++++-
 mm/quicklist.c                                   |    2 
 mm/slab.c                                        |    4 
 mm/slub.c                                        |    6 -
 mm/swap.c                                        |    4 
 mm/vmalloc.c                                     |    2 
 mm/vmstat.c                                      |    2 
 net/core/drop_monitor.c                          |    2 
 net/core/flow.c                                  |    6 -
 net/core/sock.c                                  |    2 
 net/ipv4/route.c                                 |    2 
 net/ipv4/syncookies.c                            |    4 
 net/ipv6/syncookies.c                            |    4 
 net/socket.c                                     |    2 
 157 files changed, 399 insertions(+), 439 deletions(-)

Thanks.

--
tejun

[L] http://thread.gmane.org/gmane.linux.kernel/839059
[1] http://thread.gmane.org/gmane.linux.kernel/844298
