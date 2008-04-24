Return-Path: <linux-kernel-owner+w=401wt.eu-S1762802AbYDXPV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762802AbYDXPV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759590AbYDXPO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:14:57 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:56105 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759485AbYDXPOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:14:48 -0400
Message-Id: <20080424150324.802695381@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 24 Apr 2008 11:03:24 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: [patch 00/37] Linux Kernel Markers instrumentation for sched-devel.git
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu, 24 Apr 2008 15:13:52 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here is a rather large patchset applying kernel instrumentation to
sched-devel.git. It includes, mainly :

- x86 NMI-safe traps.
- Optimized Markers, using Immediate Values, with nops/jump patching
  optimization.
- ftrace sched and wakeup tracer port to the markers.
- The archtecture independent instrumentation found in LTTng.

Please see the individual patches for more details. A diffstat is appended at
the bottom of this email.

They apply in the following order on to of current sched-devel.git :

stringify-support-commas.patch
#
x86_64-page-fault-nmi-safe.patch
change-alpha-active-count-bit.patch
change-avr32-active-count-bit.patch
x86-nmi-safe-int3-and-page-fault.patch
#
kprobes-use-mutex-for-insn-pages.patch
kprobes-dont-use-kprobes-mutex-in-arch-code.patch
kprobes-declare-kprobes-mutex-static.patch
fix-sched-devel-text-poke.patch
text-edit-lock-architecture-independent-code.patch
text-edit-lock-kprobes-architecture-independent-support.patch
#
# Immediate Values (basic)
add-all-cpus-option-to-stop-machine-run.patch
immediate-values-architecture-independent-code.patch
immediate-values-kconfig-menu-in-embedded.patch
immediate-values-x86-optimization.patch
add-text-poke-and-sync-core-to-powerpc.patch
immediate-values-powerpc-optimization.patch
immediate-values-documentation.patch
immediate-values-support-init.patch
# Immediate Values (NMI-safe)
immediate-values-move-kprobes-x86-restore-interrupt-to-kdebug-h.patch
add-discard-section-to-x86.patch
immediate-values-x86-optimization-nmi-mce-support.patch
immediate-values-powerpc-optimization-nmi-mce-support.patch
immediate-values-use-arch-nmi-mce-support.patch
# Immediate Values (jump patching)
immediate-values-jump.patch
#
scheduler-profiling-use-immediate-values.patch
#
make-marker_debug-static.patch # in -mm
markers-remove-extra-format-argument.patch
markers-define-non-optimized-marker.patch
linux-kernel-markers-immediate-values.patch
markers-use-imv-jump.patch
#
port-ftrace-to-markers.patch
#
# Instrumentation, architecture independent
lttng-instrumentation-fs.patch
lttng-instrumentation-ipc.patch
lttng-instrumentation-kernel.patch
lttng-instrumentation-mm.patch
lttng-instrumentation-net.patch


The overall diffstat :

 a/kernel/marker.c                                         |    2 
 arch/x86/kernel/traps_32.c                                |    3 
 include/asm-generic/vmlinux.lds.h                         |    8 
 include/asm-powerpc/immediate.h                           |    4 
 include/asm-x86/immediate.h                               |   54 -
 include/linux/immediate.h                                 |   15 
 include/linux/marker.h                                    |   13 
 include/linux/module.h                                    |    2 
 init/main.c                                               |    1 
 kernel/immediate.c                                        |   37 
 kernel/kprobes.c                                          |   44 
 kernel/module.c                                           |   10 
 kernel/sched.c                                            |   14 
 linux-2.6-lttng/Documentation/immediate.txt               |  221 ++++
 linux-2.6-lttng/arch/powerpc/kernel/Makefile              |    1 
 linux-2.6-lttng/arch/powerpc/kernel/immediate.c           |   70 +
 linux-2.6-lttng/include/asm-powerpc/cacheflush.h          |    4 
 linux-2.6-lttng/include/asm-powerpc/immediate.h           |   18 
 linux-2.6-lttng/include/asm-x86/kdebug.h                  |   12 
 linux-2.6-lttng/include/asm-x86/kprobes.h                 |    9 
 linux-2.6-lttng/include/linux/immediate.h                 |   11 
 linux-2.6-lttng/include/linux/marker.h                    |   29 
 linux-2.6-lttng/include/linux/stringify.h                 |    5 
 linux-2.6-lttng/include/linux/swapops.h                   |    8 
 linux-2.6-lttng/ipc/msg.c                                 |    6 
 linux-2.6-lttng/ipc/sem.c                                 |    6 
 linux-2.6-lttng/ipc/shm.c                                 |    6 
 linux-2.6-lttng/kernel/immediate.c                        |   73 -
 linux-2.6-lttng/kernel/kprobes.c                          |    2 
 linux-2.6-lttng/kernel/marker.c                           |   30 
 linux-2.6-lttng/mm/filemap.c                              |    7 
 linux-2.6-lttng/mm/hugetlb.c                              |    3 
 linux-2.6-lttng/mm/memory.c                               |   41 
 linux-2.6-lttng/mm/page_alloc.c                           |    9 
 linux-2.6-lttng/mm/page_io.c                              |    6 
 linux-2.6-lttng/mm/swapfile.c                             |   23 
 linux-2.6-lttng/net/core/dev.c                            |    6 
 linux-2.6-lttng/net/ipv4/devinet.c                        |    6 
 linux-2.6-lttng/net/socket.c                              |   19 
 linux-2.6-sched-devel/Documentation/immediate.txt         |    8 
 linux-2.6-sched-devel/Documentation/markers.txt           |   17 
 linux-2.6-sched-devel/arch/ia64/kernel/kprobes.c          |    2 
 linux-2.6-sched-devel/arch/powerpc/Kconfig                |    1 
 linux-2.6-sched-devel/arch/powerpc/kernel/kprobes.c       |    2 
 linux-2.6-sched-devel/arch/s390/kernel/kprobes.c          |    2 
 linux-2.6-sched-devel/arch/x86/Kconfig                    |    1 
 linux-2.6-sched-devel/arch/x86/kernel/Makefile            |    1 
 linux-2.6-sched-devel/arch/x86/kernel/alternative.c       |   38 
 linux-2.6-sched-devel/arch/x86/kernel/asm-offsets_32.c    |    1 
 linux-2.6-sched-devel/arch/x86/kernel/asm-offsets_64.c    |    1 
 linux-2.6-sched-devel/arch/x86/kernel/entry_32.S          |   30 
 linux-2.6-sched-devel/arch/x86/kernel/entry_64.S          |   34 
 linux-2.6-sched-devel/arch/x86/kernel/immediate.c         |  697 ++++++++++++--
 linux-2.6-sched-devel/arch/x86/kernel/kprobes.c           |    2 
 linux-2.6-sched-devel/arch/x86/kernel/paravirt.c          |    3 
 linux-2.6-sched-devel/arch/x86/kernel/paravirt_patch_32.c |    6 
 linux-2.6-sched-devel/arch/x86/kernel/paravirt_patch_64.c |    6 
 linux-2.6-sched-devel/arch/x86/kernel/traps_32.c          |    8 
 linux-2.6-sched-devel/arch/x86/kernel/traps_64.c          |    4 
 linux-2.6-sched-devel/arch/x86/kernel/vmi_32.c            |    2 
 linux-2.6-sched-devel/arch/x86/kernel/vmlinux_32.lds.S    |    1 
 linux-2.6-sched-devel/arch/x86/kernel/vmlinux_64.lds.S    |    1 
 linux-2.6-sched-devel/arch/x86/kvm/x86.c                  |    2 
 linux-2.6-sched-devel/arch/x86/lguest/boot.c              |    1 
 linux-2.6-sched-devel/arch/x86/mm/fault.c                 |    4 
 linux-2.6-sched-devel/arch/x86/xen/enlighten.c            |    1 
 linux-2.6-sched-devel/fs/buffer.c                         |    3 
 linux-2.6-sched-devel/fs/compat.c                         |    2 
 linux-2.6-sched-devel/fs/exec.c                           |    2 
 linux-2.6-sched-devel/fs/ioctl.c                          |    3 
 linux-2.6-sched-devel/fs/open.c                           |    3 
 linux-2.6-sched-devel/fs/read_write.c                     |   23 
 linux-2.6-sched-devel/fs/select.c                         |    5 
 linux-2.6-sched-devel/include/asm-alpha/thread_info.h     |    2 
 linux-2.6-sched-devel/include/asm-avr32/thread_info.h     |    2 
 linux-2.6-sched-devel/include/asm-generic/vmlinux.lds.h   |    3 
 linux-2.6-sched-devel/include/asm-powerpc/immediate.h     |   57 +
 linux-2.6-sched-devel/include/asm-x86/immediate.h         |  111 ++
 linux-2.6-sched-devel/include/asm-x86/irqflags.h          |   56 +
 linux-2.6-sched-devel/include/asm-x86/paravirt.h          |    7 
 linux-2.6-sched-devel/include/linux/hardirq.h             |   27 
 linux-2.6-sched-devel/include/linux/immediate.h           |   94 +
 linux-2.6-sched-devel/include/linux/kprobes.h             |    2 
 linux-2.6-sched-devel/include/linux/marker.h              |   16 
 linux-2.6-sched-devel/include/linux/memory.h              |    7 
 linux-2.6-sched-devel/include/linux/module.h              |   16 
 linux-2.6-sched-devel/include/linux/profile.h             |    5 
 linux-2.6-sched-devel/include/linux/sched.h               |   32 
 linux-2.6-sched-devel/include/linux/stop_machine.h        |    8 
 linux-2.6-sched-devel/init/Kconfig                        |   18 
 linux-2.6-sched-devel/init/main.c                         |    8 
 linux-2.6-sched-devel/kernel/Makefile                     |    1 
 linux-2.6-sched-devel/kernel/exit.c                       |    8 
 linux-2.6-sched-devel/kernel/fork.c                       |    5 
 linux-2.6-sched-devel/kernel/immediate.c                  |  149 ++
 linux-2.6-sched-devel/kernel/irq/handle.c                 |    7 
 linux-2.6-sched-devel/kernel/itimer.c                     |   13 
 linux-2.6-sched-devel/kernel/kthread.c                    |    5 
 linux-2.6-sched-devel/kernel/lockdep.c                    |   20 
 linux-2.6-sched-devel/kernel/marker.c                     |    8 
 linux-2.6-sched-devel/kernel/module.c                     |   50 -
 linux-2.6-sched-devel/kernel/printk.c                     |   27 
 linux-2.6-sched-devel/kernel/profile.c                    |   22 
 linux-2.6-sched-devel/kernel/sched.c                      |    5 
 linux-2.6-sched-devel/kernel/sched_fair.c                 |    5 
 linux-2.6-sched-devel/kernel/signal.c                     |    3 
 linux-2.6-sched-devel/kernel/softirq.c                    |   23 
 linux-2.6-sched-devel/kernel/stop_machine.c               |   32 
 linux-2.6-sched-devel/kernel/timer.c                      |   13 
 linux-2.6-sched-devel/kernel/trace/trace.h                |   20 
 linux-2.6-sched-devel/kernel/trace/trace_sched_switch.c   |  173 ++-
 linux-2.6-sched-devel/kernel/trace/trace_sched_wakeup.c   |  108 ++
 linux-2.6-sched-devel/mm/memory.c                         |   34 
 113 files changed, 2542 insertions(+), 415 deletions(-)


Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
