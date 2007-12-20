Return-Path: <linux-kernel-owner+w=401wt.eu-S1762961AbXLTMLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762961AbXLTMLY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 07:11:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761033AbXLTMBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 07:01:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761111AbXLTMAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 07:00:48 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>
In-Reply-To: Roland McGrath's message of  Thursday, 20 December 2007 03:52:00 -0800 <20071220115200.C767E26F98A@magilla.localdomain>
References: <20071220115200.C767E26F98A@magilla.localdomain>
Subject: [PATCH -mm 18/43] powerpc compat_binfmt_elf
Message-Id: <20071220115816.504CC26F98E@magilla.localdomain>
Date: Thu, 20 Dec 2007 03:58:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This switches the CONFIG_PPC64 support for 32-bit ELF to use the generic
fs/compat_binfmt_elf.c implementation instead of our own binfmt_elf32.c.
Since so much is the same between 32/64, there is only one macro we have to
define to make the generic support work out of the box.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/powerpc/kernel/Makefile       |    3 +-
 arch/powerpc/kernel/binfmt_elf32.c |   69 ------------------------------------
 include/asm-powerpc/elf.h          |    1 +
 3 files changed, 3 insertions(+), 70 deletions(-)

diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index 615ed96..2cbe58a 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -17,11 +17,12 @@ obj-y				:= semaphore.o cputable.o ptrace.o syscalls.o \
 				   init_task.o process.o systbl.o idle.o \
 				   signal.o
 obj-y				+= vdso32/
-obj-$(CONFIG_PPC64)		+= setup_64.o binfmt_elf32.o sys_ppc32.o \
+obj-$(CONFIG_PPC64)		+= setup_64.o sys_ppc32.o \
 				   signal_64.o ptrace32.o \
 				   paca.o cpu_setup_ppc970.o \
 				   cpu_setup_pa6t.o \
 				   firmware.o sysfs.o nvram_64.o
+obj-$(CONFIG_PPC64)		+= ../../../fs/compat_binfmt_elf.o
 obj-$(CONFIG_PPC64)		+= vdso64/
 obj-$(CONFIG_ALTIVEC)		+= vecemu.o vector.o
 obj-$(CONFIG_PPC_970_NAP)	+= idle_power4.o
diff --git a/arch/powerpc/kernel/binfmt_elf32.c b/arch/powerpc/kernel/binfmt_elf32.c
deleted file mode 100644
index 1d45d77..0000000
--- a/arch/powerpc/kernel/binfmt_elf32.c
+++ /dev/null
@@ -1,69 +0,0 @@
-/*
- * binfmt_elf32.c: Support 32-bit PPC ELF binaries on Power3 and followons.
- * based on the SPARC64 version.
- * Copyright (C) 1995, 1996, 1997, 1998 David S. Miller	(davem@redhat.com)
- * Copyright (C) 1995, 1996, 1997, 1998 Jakub Jelinek	(jj@ultra.linux.cz)
- *
- * Copyright (C) 2000,2001 Ken Aaker (kdaaker@rchland.vnet.ibm.com), IBM Corp
- * Copyright (C) 2001 Anton Blanchard (anton@au.ibm.com), IBM
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#include <asm/processor.h>
-#include <linux/module.h>
-#include <linux/compat.h>
-#include <linux/elfcore-compat.h>
-
-#undef	ELF_ARCH
-#undef	ELF_CLASS
-#define ELF_CLASS	ELFCLASS32
-#define ELF_ARCH	EM_PPC
-
-#undef	elfhdr
-#undef	elf_phdr
-#undef	elf_note
-#undef	elf_addr_t
-#define elfhdr		elf32_hdr
-#define elf_phdr	elf32_phdr
-#define elf_note	elf32_note
-#define elf_addr_t	Elf32_Off
-
-#define elf_prstatus	compat_elf_prstatus
-#define elf_prpsinfo	compat_elf_prpsinfo
-
-#define elf_core_copy_regs compat_elf_core_copy_regs
-static inline void compat_elf_core_copy_regs(compat_elf_gregset_t *elf_regs,
-					     struct pt_regs *regs)
-{
-	PPC_ELF_CORE_COPY_REGS((*elf_regs), regs);
-}
-
-#define elf_core_copy_task_regs compat_elf_core_copy_task_regs
-static int compat_elf_core_copy_task_regs(struct task_struct *tsk,
-					  compat_elf_gregset_t *elf_regs)
-{
-	struct pt_regs *regs = tsk->thread.regs;
-	if (regs)
-		compat_elf_core_copy_regs(elf_regs, regs);
-	return 1;
-}
-
-#include <linux/time.h>
-
-#undef cputime_to_timeval
-#define cputime_to_timeval cputime_to_compat_timeval
-static __inline__ void
-cputime_to_compat_timeval(const cputime_t cputime, struct compat_timeval *value)
-{
-	unsigned long jiffies = cputime_to_jiffies(cputime);
-	value->tv_usec = (jiffies % HZ) * (1000000L / HZ);
-	value->tv_sec = jiffies / HZ;
-}
-
-#define init_elf_binfmt init_elf32_binfmt
-
-#include "../../../fs/binfmt_elf.c"
diff --git a/include/asm-powerpc/elf.h b/include/asm-powerpc/elf.h
index fd9bf8b..9080d85 100644
--- a/include/asm-powerpc/elf.h
+++ b/include/asm-powerpc/elf.h
@@ -165,6 +165,7 @@ typedef elf_vrreg_t elf_vrregset_t32[ELF_NVRREG32];
  * This is used to ensure we don't load something for the wrong architecture.
  */
 #define elf_check_arch(x) ((x)->e_machine == ELF_ARCH)
+#define compat_elf_check_arch(x)	((x)->e_machine == EM_PPC)
 
 #define USE_ELF_CORE_DUMP
 #define CORE_DUMP_USE_REGSET
-- 
1.5.3.6

