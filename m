Return-Path: <linux-kernel-owner+w=401wt.eu-S1755734AbZDNPwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734AbZDNPwX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 11:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754235AbZDNPvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 11:51:43 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45944 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752651AbZDNPvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 11:51:42 -0400
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 00/14] convert voyager over to the x86 quirks model
Date: Tue, 14 Apr 2009 10:51:26 -0500
Message-Id: <1239724300-16371-1-git-send-email-James.Bottomley@HansenPartnership.com>
X-Mailer: git-send-email 1.6.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Given the lack of actual technical feedback, I went ahead and
implemented the additions to smp_ops and x86_quirks (and a dynamic mca
NMI hook) to allow voyager to be plumbed in.

There also needs to be changes in the boot setup to make voyager work
dynamically: It has to be detected first, so the a20 gate check is
only executed if a voyager is not found.

I also completed some of the subarchitecture eliminations, so all the
include file infrastructure should be gone.

The result is that I can boot both my PC SMP x86 boxes and voyager
with the same kernel.

This patch series applies on git head (obviously with
965c7ecaf2e2b083d711a01ab33735a4bdeee1a4 reverted)


James Bottomley (14):
  [VOYAGER] x86: add {safe,hard}_smp_processor_id to smp_ops
  [VOYAGER] x86/mca: make mca_nmi_hook external
  [VOYAGER] x86: add prefill_possible_map to x86_quirks
  [VOYAGER] x86: use boot_cpu_id instead of zero for checking boot
    processor
  [VOYAGER] x86/voyager: Move voyager detection to a new bootparam area
  [VOYAGER] x86: eliminate subarchitecture file setup_arch.h
  [VOYAGER] x86: eliminate subarchitecture file entry_arch.h
  [VOYAGER] x86: eliminate subarchitecture file do_timer.h
  [VOYAGER] x86: redo irq2 cascade setup
  [VOYAGER] x86: make disabling the apics functional instead of a flag
  [VOYAGER] x86/Voyager: add missing QIC call function single gate
  [VOYAGER] x86/Voyager: replace inline io area reads with readX
    accessors
  [VOYAGER] x86/voyager: remove direct use of pg0 in favour of
    early_ioremap()
  [VOYAGER] x86/Voyager: Plumb voyager back into the build

 arch/x86/Kconfig                               |    4 +-
 arch/x86/Makefile                              |    2 +
 arch/x86/boot/Makefile                         |    4 +-
 arch/x86/boot/a20.c                            |   13 +-
 arch/x86/boot/boot.h                           |    2 +-
 arch/x86/boot/voyager.c                        |    5 +-
 arch/x86/include/asm/apic.h                    |    6 +
 arch/x86/include/asm/bootparam.h               |    5 +-
 arch/x86/include/asm/do_timer.h                |   16 -
 arch/x86/include/asm/entry_arch.h              |   59 ---
 arch/x86/include/asm/hw_irq.h                  |   11 +
 arch/x86/include/asm/mach-voyager/do_timer.h   |   17 -
 arch/x86/include/asm/mach-voyager/entry_arch.h |   26 --
 arch/x86/include/asm/mach-voyager/setup_arch.h |   12 -
 arch/x86/include/asm/mca.h                     |    3 +
 arch/x86/include/asm/setup.h                   |    6 +-
 arch/x86/include/asm/setup_arch.h              |    3 -
 arch/x86/include/asm/smp.h                     |   13 +-
 arch/x86/include/asm/voyager.h                 |   80 ++---
 arch/x86/include/asm/voyager_bios.h            |   21 +
 arch/x86/include/asm/voyager_boot.h            |   27 ++
 arch/x86/include/asm/voyager_vectors.h         |   37 ++
 arch/x86/kernel/apic/apic.c                    |    8 +-
 arch/x86/kernel/apic/ipi.c                     |    2 +-
 arch/x86/kernel/apic/probe_32.c                |    3 +
 arch/x86/kernel/entry_32.S                     |   72 +++-
 arch/x86/kernel/irqinit_32.c                   |   15 +-
 arch/x86/kernel/mca_32.c                       |   12 +
 arch/x86/kernel/probe_roms_32.c                |    1 -
 arch/x86/kernel/setup.c                        |   35 +--
 arch/x86/kernel/smp.c                          |    7 +
 arch/x86/kernel/smpboot.c                      |    2 +-
 arch/x86/kernel/time_32.c                      |   11 +-
 arch/x86/kernel/visws_quirks.c                 |    7 -
 arch/x86/mach-voyager/setup.c                  |   66 ++--
 arch/x86/mach-voyager/voyager_basic.c          |  111 +++---
 arch/x86/mach-voyager/voyager_smp.c            |  544 ++++++++----------------
 arch/x86/mach-voyager/voyager_thread.c         |    5 +-
 arch/x86/xen/smp.c                             |    7 +
 39 files changed, 554 insertions(+), 726 deletions(-)
 delete mode 100644 arch/x86/include/asm/do_timer.h
 delete mode 100644 arch/x86/include/asm/entry_arch.h
 delete mode 100644 arch/x86/include/asm/mach-voyager/do_timer.h
 delete mode 100644 arch/x86/include/asm/mach-voyager/entry_arch.h
 delete mode 100644 arch/x86/include/asm/mach-voyager/setup_arch.h
 delete mode 100644 arch/x86/include/asm/setup_arch.h
 create mode 100644 arch/x86/include/asm/voyager_bios.h
 create mode 100644 arch/x86/include/asm/voyager_boot.h
 create mode 100644 arch/x86/include/asm/voyager_vectors.h

