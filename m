Return-Path: <linux-kernel-owner+w=401wt.eu-S932420AbZJNT3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420AbZJNT3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 15:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758901AbZJNT3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 15:29:18 -0400
Received: from claw.goop.org ([74.207.240.146]:55271 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753450AbZJNT3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 15:29:16 -0400
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Xen-devel <xen-devel@lists.xensource.com>, kurt.hackel@oracle.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Avi Kivity <avi@redhat.com>, the arch/x86 maintainers <x86@kernel.org>,
       Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL RFC] pvclock cleanups and pvclock vsyscall support
Date: Wed, 14 Oct 2009 12:28:24 -0700
Message-Id: <1255548516-15260-1-git-send-email-jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This series contains several things:

 - Unify the separate vdso and vsyscall implementations of vgettimeofday and
   vgetcpu.  There's at least one bugfix which was only applied to one copy
   (ignore tcache in vgetcpu was only applied to the vdso version); this
   should avoid such skews in future.

 - Bug fixes for the Xen and KVM clocksource.read functions to make sure
   the returned time doesn't regress compared to clocksource.cycle_last.
   (Probably stable material.)

 - Make sure the pvclock rdtsc is surrounded by appropriate barriers so
   that it doesn't get speculated to the wrong place with respect to reading
   the time parameters.  (Probably stable material.)

 - General cleanups of the pvclock algorithm (there's no need to make a local
   copy of the time parameters before use).

 - Add a new CONFIG_X86_VSYSCALL to control the compilation of vsyscall-related
   code rather than just using CONFIG_X86_64 - we may want to implement 32-bit
   vsyscall at some point, and this will make it easier.

 - Add the sched notifier for task migration between CPUs, for use by
   pvclock vread.

 - Implement a pvclock vread function, so that pvclock-using clocksources can be
   used by vsyscall/vdso vgettimeofday and vclock_gettime.

 - Use pvclock vread in the Xen clocksource.

The following changes since commit 74fca6a42863ffacaf7ba6f1936a9f228950f657:
  Linus Torvalds (1):
        Linux 2.6.31

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git xen/vsyscall

Jeremy Fitzhardinge (12):
      x86/vsyscall: use common implementation for vgetcpu
      x86/vgetcpu: ignore tcache in common code.
      x86/vsyscall: use common implementation for vgettimeofday
      kvm/pvclock: add monotonicity check
      xen/pvclock: add monotonicity check
      x86/pvclock: make sure rdtsc doesn't speculate out of region
      pvclock: there's no need to copy time_info into shadow
      x86: create specific X86_VSYSCALL config variable
      sched: add notifier for cross-cpu migrations
      x86/pvclock: add vsyscall implementation
      x86/fixmap: add a predicate for usermode fixmaps
      xen/time: add pvclock_clocksource_vread support

 arch/x86/Kconfig                |   10 ++-
 arch/x86/include/asm/fixmap.h   |   25 +++++-
 arch/x86/include/asm/pvclock.h  |    6 ++
 arch/x86/include/asm/vgtod.h    |   64 +++++++++++++-
 arch/x86/include/asm/vsyscall.h |   30 ++++++
 arch/x86/kernel/Makefile        |    5 +-
 arch/x86/kernel/hpet.c          |    4 +-
 arch/x86/kernel/kvmclock.c      |    7 ++-
 arch/x86/kernel/pvclock.c       |  186 +++++++++++++++++++++++++++++---------
 arch/x86/kernel/tsc.c           |    4 +-
 arch/x86/kernel/vsyscall_64.c   |   91 +-------------------
 arch/x86/vdso/vclock_gettime.c  |   46 +---------
 arch/x86/vdso/vgetcpu.c         |   17 +---
 arch/x86/xen/Kconfig            |    6 ++
 arch/x86/xen/mmu.c              |    5 +-
 arch/x86/xen/smp.c              |    2 +
 arch/x86/xen/time.c             |   61 +++++++++++++-
 arch/x86/xen/xen-ops.h          |    8 ++
 include/linux/sched.h           |    8 ++
 include/xen/interface/vcpu.h    |   41 +++++++++
 kernel/sched.c                  |   14 +++
 21 files changed, 438 insertions(+), 202 deletions(-)
