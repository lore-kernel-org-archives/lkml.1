Return-Path: <linux-kernel-owner+w=401wt.eu-S1756171AbZBINl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbZBINl2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 08:41:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755441AbZBINkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 08:40:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:37803 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755404AbZBINkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 08:40:41 -0500
From: Tejun Heo <tj@kernel.org>
To: hpa@zytor.com, jeremy@goop.org, tglx@linutronix.de, mingo@elte.hu,
       linux-kernel@vger.kernel.org, x86@kernel.org, rusty@rustcorp.com.au
Subject: [PATCHSET x86/master] add stack protector support for x86_32
Date: Mon,  9 Feb 2009 22:39:47 +0900
Message-Id: <1234186798-16820-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 09 Feb 2009 13:40:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

This patchset adds stack protector support for x86_32.  The basics are
the same with x86_64 but there are some noticeable differences.

* x86_32 uses %fs for percpu base.  %gs is unused by the kernel and
  managed lazily.  %gs is used for userland TLS and loading %gs with
  different value on kernel entry is known to cost quite a bit on some
  chips.

  Lazy %gs handling is made optional and disabled if stack protector
  is enabled.  To do this, entry for %gs is added to pt_regs.  This
  adds one "pushl $0" to SAVE_ALL in entry_32.S when lazy %gs is on.
  However, no overhead is added to common exit path and error_code
  entry path shed a few instructions.  I don't think there will be
  noticeable overhead but then again it does add an instruction to a
  very hot path.  Would this be okay?

* x86_32 doesn't support direct access to shadow part of %gs and
  there's no swapgs, so GDT entry should be built for stack canary.

  GDT entry 28 is used for this.  The boot cpu one is setup from
  head_32.S.  Others while setting up percpu areas.

* math_emu register access was completely broken.  Fixed.

* x86_32 exception handlers take register frame verbatim as struct
  pt_regs.  With -fstack-protector, gcc copies pt_regs into the
  callee's stack frame to put it after the stack canary.  Of course it
  doesn't copy back (as the callee owns the argument) and any change
  made to pt_regs is lost on return.  This is currently worked around
  by adding -fno-stack-protector to any file containing such
  functions.  We really need to teach gcc about the calling
  convention.

This patchset contains the following eleven patches.

  0001-x86-include-correct-gs-in-a.out-core-dump.patch
  0002-x86-math_emu-info-cleanup.patch
  0003-x86-fix-math_emu-register-frame-access.patch
  0004-elf-add-ELF_CORE_COPY_KERNEL_REGS.patch
  0005-x86-stackprotector.h-misc-update.patch
  0006-stackprotector-update-make-rules.patch
  0007-x86-no-stack-protector-for-vdso.patch
  0008-x86-use-asm-.macro-instead-of-cpp-define-in-entry_.patch
  0009-x86-add-gs-accessors-for-x86_32.patch
  0010-x86-make-lazy-gs-optional-on-x86_32.patch
  0011-x86-implement-x86_32-stack-protector.patch

0001 is a misc fix.  0002-0003 fixes math_emu register frame access.
0004-0008 preps for stack protector changes.  0009-0010 makes lazy %gs
handling optional.  0011 implements stack protector support for
x86_32.

Jeremy, Rusty, can you guys please take a look at patch #0010 and
#0011 and see whether xen and lguest are okay?  I don't think anything
is broken for those although stackp might not work but haven't tested
them.  I'll try to learn xen and lguest and test them in the future.

This patchset is against the current x86/master[1].  If acked, please
pull from the following git branch

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-stackp32

to receive the following changes.

 Makefile                                  |    3 
 arch/x86/Kconfig                          |    5 
 arch/x86/Makefile                         |   17 -
 arch/x86/include/asm/a.out-core.h         |    4 
 arch/x86/include/asm/elf.h                |   15 -
 arch/x86/include/asm/math_emu.h           |   29 --
 arch/x86/include/asm/mmu_context.h        |    2 
 arch/x86/include/asm/processor.h          |    6 
 arch/x86/include/asm/ptrace.h             |    4 
 arch/x86/include/asm/segment.h            |    9 
 arch/x86/include/asm/stackprotector.h     |   96 ++++++
 arch/x86/include/asm/system.h             |   40 ++
 arch/x86/include/asm/traps.h              |    4 
 arch/x86/kernel/Makefile                  |   18 +
 arch/x86/kernel/asm-offsets_32.c          |    1 
 arch/x86/kernel/cpu/common.c              |   17 -
 arch/x86/kernel/entry_32.S                |  423 ++++++++++++++++++------------
 arch/x86/kernel/head_32.S                 |   20 +
 arch/x86/kernel/process_32.c              |   11 
 arch/x86/kernel/ptrace.c                  |   19 -
 arch/x86/kernel/setup_percpu.c            |    2 
 arch/x86/kernel/signal.c                  |   41 +-
 arch/x86/kernel/traps.c                   |   15 -
 arch/x86/kernel/vm86_32.c                 |    4 
 arch/x86/lguest/boot.c                    |    2 
 arch/x86/math-emu/fpu_entry.c             |    6 
 arch/x86/math-emu/fpu_proto.h             |    4 
 arch/x86/math-emu/fpu_system.h            |   16 -
 arch/x86/math-emu/get_address.c           |   75 ++---
 arch/x86/vdso/Makefile                    |    2 
 arch/x86/xen/enlighten.c                  |   17 -
 include/linux/elfcore.h                   |    9 
 kernel/kexec.c                            |    2 
 kernel/panic.c                            |    4 
 scripts/gcc-x86_32-has-stack-protector.sh |    8 
 scripts/gcc-x86_64-has-stack-protector.sh |    4 
 36 files changed, 619 insertions(+), 335 deletions(-)

Thanks.

--
tejun

[1] 2076fe22811d836936b80ad1c55997f70bb0ae8d
