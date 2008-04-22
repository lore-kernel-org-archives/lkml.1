Return-Path: <linux-kernel-owner+w=401wt.eu-S1757628AbYDVH53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628AbYDVH53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 03:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756654AbYDVH5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 03:57:09 -0400
Received: from brick.kernel.dk ([87.55.233.238]:26294 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958AbYDVH5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 03:57:06 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: npiggin@suse.de, torvalds@linux-foundation.org
Subject: [PATCH 0/11] Generic smp_call_function() and friends
Date: Tue, 22 Apr 2008 09:57:26 +0200
Message-Id: <1208851058-8500-1-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.5.1.57.g5909c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While working on the more scalable and faster
smp_call_function_single(), the amount of arch duplicated code in there
botherered me. So I started adding a generic kernel/smp.c helper that
the archs could use instead.

Arch code exports two helper functions:

arch_send_call_function_single_ipi(cpu)
	Send call function single ipi to given cpu
arch_send_call_function_ipi(cpumask)
	Send call function ipi to cpus in cpumask

and then use the generic ipi interrupt helpers to execute the code. I
converted most of the archs capable of SMP, I think only sparc and
sparc64 are still missing. Archs set CONFIG_GENERIC_SMP_HELPERS if they
wish to use the generic helpers for this.

The end result is that we have unified code for handling ipi for
function calls. Even with adding special handling for the single cpu
function call, the diffstat is pretty nice (see below.

There are a couple of changes that affect all archs, and changes that
affect some archs:

- smp_call_function() and friends used to wait for all other CPUs to see
  the individual structure before returning, even if 'wait' wasn't set.
  Not sure what the reasoning behind this was, the new code does not
  wait for other CPUs to start up before returning. If 'wait' is 1,
  it'll wait for completion as before of course. This affects all archs.
  It's easy enough to add if there's a good reason, it'll slow it down a
  little and add an atomic_t to the call_single_data structure.

- A few archs had timeout code, most did not. I removed the timeout
  code, we can add it back if requested.

- The ipi_lock is a little muddy, which may or may not break cpu
  onlining.

In general the new code should be easier to maintain, and it is much
faster than before. The code works fine on x86, x86-64, ia64, and
powerpc. Other archs have been compiled whenever possible, some have
not. Each arch patch should contain a note saying what the status of it
is.

 arch/alpha/Kconfig                         |    5 
 arch/alpha/kernel/core_marvel.c            |    6 
 arch/alpha/kernel/smp.c                    |  170 ---------
 arch/arm/Kconfig                           |    5 
 arch/arm/kernel/smp.c                      |  148 --------
 arch/ia64/Kconfig                          |    5 
 arch/ia64/kernel/smp.c                     |  239 -------------
 arch/m32r/Kconfig                          |    5 
 arch/m32r/kernel/smp.c                     |  128 -------
 arch/m32r/kernel/traps.c                   |    3 
 arch/mips/Kconfig                          |    5 
 arch/mips/kernel/smp-mt.c                  |   27 +
 arch/mips/kernel/smp.c                     |  133 -------
 arch/mips/kernel/smtc.c                    |    7 
 arch/mips/sibyte/bcm1480/smp.c             |    3 
 arch/mips/sibyte/sb1250/smp.c              |    2 
 arch/parisc/Kconfig                        |    5 
 arch/parisc/kernel/smp.c                   |  134 +------
 arch/powerpc/Kconfig                       |    5 
 arch/powerpc/kernel/smp.c                  |  220 ------------
 arch/powerpc/platforms/cell/interrupt.c    |    1 
 arch/powerpc/platforms/ps3/smp.c           |    7 
 arch/powerpc/platforms/pseries/xics.c      |    6 
 arch/powerpc/sysdev/mpic.c                 |    2 
 arch/s390/Kconfig                          |    5 
 arch/s390/kernel/smp.c                     |  160 ---------
 arch/sh/Kconfig                            |    5 
 arch/sh/kernel/smp.c                       |   48 --
 arch/sparc64/kernel/sparc64_ksyms.c        |    1 
 arch/x86/Kconfig                           |    5 
 arch/x86/kernel/apic_32.c                  |    4 
 arch/x86/kernel/entry_64.S                 |    3 
 arch/x86/kernel/i8259_64.c                 |    4 
 arch/x86/kernel/smp.c                      |  148 +-------
 arch/x86/kernel/smpcommon.c                |   56 ---
 arch/x86/mach-voyager/voyager_smp.c        |   91 -----
 arch/x86/xen/enlighten.c                   |    1 
 arch/x86/xen/mmu.c                         |    2 
 arch/x86/xen/smp.c                         |  108 +-----
 include/asm-alpha/smp.h                    |    2 
 include/asm-ia64/smp.h                     |    3 
 include/asm-m32r/smp.h                     |    1 
 include/asm-mips/smp.h                     |   12 
 include/asm-powerpc/smp.h                  |    5 
 include/asm-s390/sigp.h                    |    1 
 include/asm-s390/smp.h                     |    2 
 include/asm-sh/smp.h                       |   12 
 include/asm-x86/hw_irq_32.h                |    1 
 include/asm-x86/hw_irq_64.h                |    2 
 include/asm-x86/mach-default/entry_arch.h  |    1 
 include/asm-x86/mach-default/irq_vectors.h |    1 
 include/asm-x86/mach-voyager/entry_arch.h  |    2 
 include/asm-x86/mach-voyager/irq_vectors.h |    4 
 include/asm-x86/smp.h                      |   10 
 include/linux/smp.h                        |   27 +
 init/main.c                                |    3 
 kernel/Makefile                            |    1 
 kernel/smp.c                               |  366 +++++++++++++++++++++
 58 files changed, 694 insertions(+), 1674 deletions(-)

-- 
Jens Axboe


