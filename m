Return-Path: <linux-kernel-owner+w=401wt.eu-S1760685AbZAMKnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760685AbZAMKnz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 05:43:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757271AbZAMKjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 05:39:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:51189 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753100AbZAMKj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 05:39:29 -0500
From: Tejun Heo <tj@kernel.org>
To: ebiederm@xmission.com, cl@linux-foundation.org, rusty@rustcorp.com.au,
       mingo@elte.hu, travis@sgi.com, linux-kernel@vger.kernel.org,
       hpa@zytor.com, akpm@linux-foundation.org, steiner@sgi.com,
       hugh@veritas.com
Subject: [PATCHSET linux-2.6-x86:tip] x86: make percpu offsets zero-based on SMP
Date: Tue, 13 Jan 2009 19:38:04 +0900
Message-Id: <1231843097-18003-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.6
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 13 Jan 2009 10:38:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset is re-hash of Mike Travis' original work on zero-based
percpu offsets.  I couldn't get the original patches working (where is
the linker script changes other than the PHDR addition?) and ended up
doing a quite similar series of patches.  A lot of this patch series
was copied verbatim from or got a lot of hints from Mike Travis'
original patches.  Some differences are...

* better splitted - one thing at a time.

* how the pda is allocated at the head.  this patch uses preallocation
  directly from linker script as it's something arch specific anyway.

* pda ops are wrappers around x86 percpu ops.

* x86-32 SMP is also converted to zero-based offsets, so we should be
  able to do cpualloc (or whatever) for both subarchs.

This patchset contains the following thirteen patches.

  0001-x86_64-fix-pda_to_op.patch
  0002-x86-make-early_per_cpu-a-lvalue-and-use-it.patch
  0003-x86_64-Cleanup-early-setup_percpu-references.patch
  0004-x86_32-make-vmlinux_32.lds.S-use-PERCPU-macro.patch
  0005-x86_64-make-percpu-symbols-zerobased-on-SMP.patch
  0006-x86_64-load-pointer-to-pda-into-gs-while-brining-u.patch
  0007-x86_64-use-static-_cpu_pda-array.patch
  0008-x86_64-fold-pda-into-percpu-area-on-SMP.patch
  0009-x86_64-merge-64-and-32-SMP-percpu-handling.patch
  0010-x86_64-make-pda-a-percpu-variable.patch
  0011-x86_64-convert-pda-ops-to-wrappers-around-x86-percp.patch
  0012-x86_64-misc-clean-up-after-the-percpu-update.patch
  0013-x86_32-make-percpu-symbols-zerobased-on-SMP.patch

0001-0004 prepares for coming changes.  0005 converts x86_64 SMP
percpu to zero based offset.  0006-0007 preps for percpu/pda
simplification.  0008-0012 unifies percpu and pda handling
step-by-step.  0013 converts x86_32 SMP percpu to zer based offset.

Each step was tested with gcc-4.1.3, 4.2.3 and 4.3.1 on x86_64, 4.3.1
on i386 for both SMP and UP configurations.  The final state is
currently being tested using 4.2.3 on both x86_64 and 32.

This patchset is on top of the current linux-2.6-x86:tip[1] and also
available in the following git tree.

  http://git.kernel.org/?p=linux/kernel/git/tj/misc.git;a=shortlog;h=x86-percpu-zerobased
  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86-percpu-zerobased

 arch/x86/include/asm/pda.h          |   97 ++--------------------
 arch/x86/include/asm/percpu.h       |  137 ++++++++++++-------------------
 arch/x86/include/asm/setup.h        |    1 
 arch/x86/include/asm/smp.h          |    2 
 arch/x86/include/asm/topology.h     |    5 -
 arch/x86/include/asm/trampoline.h   |    1 
 arch/x86/kernel/acpi/sleep.c        |    1 
 arch/x86/kernel/apic.c              |   13 ---
 arch/x86/kernel/asm-offsets_64.c    |    2 
 arch/x86/kernel/cpu/common.c        |   17 ++-
 arch/x86/kernel/entry_64.S          |    7 -
 arch/x86/kernel/head64.c            |   23 -----
 arch/x86/kernel/head_32.S           |   37 +++++++-
 arch/x86/kernel/head_64.S           |   47 +++++++++-
 arch/x86/kernel/setup_percpu.c      |  156 +++++++++++++++++++-----------------
 arch/x86/kernel/smpboot.c           |   61 --------------
 arch/x86/kernel/smpcommon.c         |    3 
 arch/x86/kernel/vmlinux_32.lds.S    |   23 +++--
 arch/x86/kernel/vmlinux_64.lds.S    |   22 ++++-
 arch/x86/kernel/x8664_ksyms_64.c    |    2 
 arch/x86/mach-voyager/voyager_smp.c |    2 
 arch/x86/xen/enlighten.c            |    2 
 arch/x86/xen/smp.c                  |   10 --
 include/asm-generic/sections.h      |    2 
 include/asm-generic/vmlinux.lds.h   |   74 +++++++++++++++--
 25 files changed, 353 insertions(+), 394 deletions(-)

Thanks.

--
tejun

[1] c69feb89654622a77c5a8d8e5b20e3dbe0a7a92b
