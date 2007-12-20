Return-Path: <linux-kernel-owner+w=401wt.eu-S1760100AbXLTL4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760100AbXLTL4Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 06:56:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760346AbXLTLzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 06:55:25 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760322AbXLTLzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 06:55:22 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: Roland McGrath's message of  Thursday, 20 December 2007 03:52:00 -0800 <20071220115200.C767E26F98A@magilla.localdomain>
References: <20071220115200.C767E26F98A@magilla.localdomain>
Subject: [PATCH -mm 05/43] compat_binfmt_elf
Message-Id: <20071220115447.4F8E326F98A@magilla.localdomain>
Date: Thu, 20 Dec 2007 03:54:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds fs/compat_binfmt_elf.c, a wrapper around fs/binfmt_elf.c for
32-bit ELF support on 64-bit kernels.  It can replace all the hand-rolled
versions of this that each 32/64 arch has, which are all about the same.

To use this, an arch's asm/elf.h has to define at least a few compat_*
macros that parallel the various macros that fs/binfmt_elf.c uses for
native support.

There is no attempt to deal with compat macros for the core dump format
support.  To use this file, the arch has to define compat_gregset_t for
linux/elfcore-compat.h and #define CORE_DUMP_USE_REGSET.  The 32-bit
compatible formats should come automatically from task_user_regset_view
called on a 32-bit task.

Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 fs/compat_binfmt_elf.c |  131 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 131 insertions(+), 0 deletions(-)

diff --git a/fs/compat_binfmt_elf.c b/fs/compat_binfmt_elf.c
new file mode 100644
index 0000000..0adced2
--- /dev/null
+++ b/fs/compat_binfmt_elf.c
@@ -0,0 +1,131 @@
+/*
+ * 32-bit compatibility support for ELF format executables and core dumps.
+ *
+ * Copyright (C) 2007 Red Hat, Inc.  All rights reserved.
+ *
+ * This copyrighted material is made available to anyone wishing to use,
+ * modify, copy, or redistribute it subject to the terms and conditions
+ * of the GNU General Public License v.2.
+ *
+ * Red Hat Author: Roland McGrath.
+ *
+ * This file is used in a 64-bit kernel that wants to support 32-bit ELF.
+ * asm/elf.h is responsible for defining the compat_* and COMPAT_* macros
+ * used below, with definitions appropriate for 32-bit ABI compatibility.
+ *
+ * We use macros to rename the ABI types and machine-dependent
+ * functions used in binfmt_elf.c to compat versions.
+ */
+
+#include <linux/elfcore-compat.h>
+#include <linux/time.h>
+
+/*
+ * Rename the basic ELF layout types to refer to the 32-bit class of files.
+ */
+#undef	ELF_CLASS
+#define ELF_CLASS	ELFCLASS32
+
+#undef	elfhdr
+#undef	elf_phdr
+#undef	elf_note
+#undef	elf_addr_t
+#define elfhdr		elf32_hdr
+#define elf_phdr	elf32_phdr
+#define elf_note	elf32_note
+#define elf_addr_t	Elf32_Addr
+
+/*
+ * The machine-dependent core note format types are defined in elfcore-compat.h,
+ * which requires asm/elf.h to define compat_elf_gregset_t et al.
+ */
+#define elf_prstatus	compat_elf_prstatus
+#define elf_prpsinfo	compat_elf_prpsinfo
+
+/*
+ * Compat version of cputime_to_compat_timeval, perhaps this
+ * should be an inline in <linux/compat.h>.
+ */
+static void cputime_to_compat_timeval(const cputime_t cputime,
+				      struct compat_timeval *value)
+{
+	struct timeval tv;
+	cputime_to_timeval(cputime, &tv);
+	value->tv_sec = tv.tv_sec;
+	value->tv_usec = tv.tv_usec;
+}
+
+#undef cputime_to_timeval
+#define cputime_to_timeval cputime_to_compat_timeval
+
+
+/*
+ * To use this file, asm/elf.h must define compat_elf_check_arch.
+ * The other following macros can be defined if the compat versions
+ * differ from the native ones, or omitted when they match.
+ */
+
+#undef	ELF_ARCH
+#undef	elf_check_arch
+#define	elf_check_arch	compat_elf_check_arch
+
+#ifdef	COMPAT_ELF_PLATFORM
+#undef	ELF_PLATFORM
+#define	ELF_PLATFORM		COMPAT_ELF_PLATFORM
+#endif
+
+#ifdef	COMPAT_ELF_HWCAP
+#undef	ELF_HWCAP
+#define	ELF_HWCAP		COMPAT_ELF_HWCAP
+#endif
+
+#ifdef	COMPAT_ARCH_DLINFO
+#undef	ARCH_DLINFO
+#define	ARCH_DLINFO		COMPAT_ARCH_DLINFO
+#endif
+
+#ifdef	COMPAT_ELF_ET_DYN_BASE
+#undef	ELF_ET_DYN_BASE
+#define	ELF_ET_DYN_BASE		COMPAT_ELF_ET_DYN_BASE
+#endif
+
+#ifdef COMPAT_ELF_EXEC_PAGESIZE
+#undef	ELF_EXEC_PAGESIZE
+#define	ELF_EXEC_PAGESIZE	COMPAT_ELF_EXEC_PAGESIZE
+#endif
+
+#ifdef	COMPAT_ELF_PLAT_INIT
+#undef	ELF_PLAT_INIT
+#define	ELF_PLAT_INIT		COMPAT_ELF_PLAT_INIT
+#endif
+
+#ifdef	COMPAT_SET_PERSONALITY
+#undef	SET_PERSONALITY
+#define	SET_PERSONALITY		COMPAT_SET_PERSONALITY
+#endif
+
+#ifdef	compat_start_thread
+#undef	start_thread
+#define	start_thread		compat_start_thread
+#endif
+
+#ifdef	compat_arch_setup_additional_pages
+#undef	ARCH_HAS_SETUP_ADDITIONAL_PAGES
+#define ARCH_HAS_SETUP_ADDITIONAL_PAGES 1
+#undef	arch_setup_additional_pages
+#define	arch_setup_additional_pages compat_arch_setup_additional_pages
+#endif
+
+/*
+ * Rename a few of the symbols that binfmt_elf.c will define.
+ * These are all local so the names don't really matter, but it
+ * might make some debugging less confusing not to duplicate them.
+ */
+#define elf_format		compat_elf_format
+#define init_elf_binfmt		init_compat_elf_binfmt
+#define exit_elf_binfmt		exit_compat_elf_binfmt
+
+/*
+ * We share all the actual code with the native (64-bit) version.
+ */
+#include "binfmt_elf.c"
-- 
1.5.3.6

