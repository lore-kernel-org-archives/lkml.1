Return-Path: <linux-kernel-owner+w=401wt.eu-S1760743AbZAUIrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760743AbZAUIrI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 03:47:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758134AbZAUIqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 03:46:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:38069 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757391AbZAUIqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 03:46:31 -0500
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, linux-kernel@vger.kernel.org, brgerst@gmail.com
Subject: [PATCHSET linux-2.6-x86:core/percpu] x86: misc clean up and unify x86_32/64 code paths
Date: Wed, 21 Jan 2009 17:46:08 +0900
Message-Id: <1232527578-1960-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 21 Jan 2009 08:46:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

This patchset contains the following 10 patches mostly unifying 32 and
64bit code paths.  0001 and 0007-0010 are from me and 0002-0006 are
from Brian Gerst.

  0001-x86-update-canary-handling-during-switch.patch
  0002-x86-clean-up-gdt_page-definition.patch
  0003-x86-fix-percpu_write-with-64-bit-constants.patch
  0004-x86-set-fs-to-__KERNEL_PERCPU-unconditionally-for.patch
  0005-x86-merge-mmu_context.h.patch
  0006-x86-merge-irq_regs.h.patch
  0007-x86-uv-cleanup.patch
  0008-x86-prepare-for-tlb-merge.patch
  0009-x86-make-x86_32-use-tlb_64.c.patch
  0010-x86-rename-tlb_64.c-to-tlb.c.patch

0001-0002 clean up after previous percpu changes.  0003 improves
percpu op slightly.  0004 simplifies x86_32 init path.  0005-0010
unifies mmu_context.h, irq_regs.h and tlb.c, which not only simplifies
the source code but also improves performance by applying
optimizations implemented for either bitness to the other one while
unifying.

The following git tree contains the above changes on top of
core/percpu[1].  Please pull from it if there's no objection.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu

diffstat follows.

 arch/x86/include/asm/genapic_32.h              |    7 -
 arch/x86/include/asm/genapic_64.h              |    6 -
 arch/x86/include/asm/irq_regs.h                |   36 +++-
 arch/x86/include/asm/irq_regs_32.h             |   31 ---
 arch/x86/include/asm/irq_regs_64.h             |    1 -
 arch/x86/include/asm/irq_vectors.h             |   36 ++--
 arch/x86/include/asm/mach-default/entry_arch.h |   18 ++-
 arch/x86/include/asm/mmu_context.h             |   63 ++++++-
 arch/x86/include/asm/mmu_context_32.h          |   55 ------
 arch/x86/include/asm/mmu_context_64.h          |   52 -----
 arch/x86/include/asm/percpu.h                  |    2 +-
 arch/x86/include/asm/system.h                  |   15 +-
 arch/x86/include/asm/uv/uv.h                   |   33 ++++
 arch/x86/include/asm/uv/uv_bau.h               |    2 -
 arch/x86/kernel/Makefile                       |    2 +-
 arch/x86/kernel/cpu/common.c                   |   23 ++-
 arch/x86/kernel/entry_32.S                     |    6 +-
 arch/x86/kernel/genx2apic_uv_x.c               |    1 +
 arch/x86/kernel/head_32.S                      |    6 +-
 arch/x86/kernel/irq_64.c                       |    3 +
 arch/x86/kernel/irqinit_32.c                   |   11 +-
 arch/x86/kernel/smpboot.c                      |    1 +
 arch/x86/kernel/{tlb_64.c => tlb.c}            |   48 +++---
 arch/x86/kernel/tlb_32.c                       |  239 ------------------------
 arch/x86/kernel/tlb_uv.c                       |   68 ++++---
 25 files changed, 268 insertions(+), 497 deletions(-)
 delete mode 100644 arch/x86/include/asm/irq_regs_32.h
 delete mode 100644 arch/x86/include/asm/irq_regs_64.h
 delete mode 100644 arch/x86/include/asm/mmu_context_32.h
 delete mode 100644 arch/x86/include/asm/mmu_context_64.h
 create mode 100644 arch/x86/include/asm/uv/uv.h
 rename arch/x86/kernel/{tlb_64.c => tlb.c} (90%)
 delete mode 100644 arch/x86/kernel/tlb_32.c

--
tejun

[1] 8f5d36ed5bb6e33024619eaee15b7ce2e3d115b3
