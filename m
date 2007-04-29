Return-Path: <linux-kernel-owner+w=401wt.eu-S1030419AbXD2Reg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030419AbXD2Reg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 13:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754379AbXD2Rbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 13:31:37 -0400
Received: from gw.goop.org ([64.81.55.164]:58966 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030241AbXD2RaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 13:30:00 -0400
Message-Id: <20070429172910.877994000@goop.org>
References: <20070429172835.284784000@goop.org>
User-Agent: quilt/0.46-1
Date: Sun, 29 Apr 2007 10:28:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Zachary Amsden <zach@vmware.com>, Roland McGrath <roland@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>
Subject: [patch 03/32] xen: Add nosegneg capability to the vsyscall page notes
Content-Disposition: inline; filename=xen-vsyscall-note.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add the "nosegneg" fake capabilty to the vsyscall page notes. This is
used by the runtime linker to select a glibc version which then
disables negative-offset accesses to the thread-local segment via
%gs. These accesses require emulation in Xen (because segments are
truncated to protect the hypervisor address space) and avoiding them
provides a measurable performance boost.

Signed-off-by: Ian Pratt <ian.pratt@xensource.com>
Signed-off-by: Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Acked-by: Zachary Amsden <zach@vmware.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Ulrich Drepper <drepper@redhat.com>

---
 arch/i386/kernel/vsyscall-note.S |   23 +++++++++++++++++++++++
 include/asm-i386/elf.h           |   14 ++++++++++----
 2 files changed, 33 insertions(+), 4 deletions(-)

===================================================================
--- a/arch/i386/kernel/vsyscall-note.S
+++ b/arch/i386/kernel/vsyscall-note.S
@@ -12,3 +12,26 @@ ELFNOTE_START(Linux, 0, "a")
 ELFNOTE_START(Linux, 0, "a")
 	.long LINUX_VERSION_CODE
 ELFNOTE_END
+
+#ifdef CONFIG_XEN
+#include <asm/elf.h>
+
+/*
+ * Add a special note telling glibc's dynamic linker a fake hardware
+ * flavor that it will use to choose the search path for libraries in the
+ * same way it uses real hardware capabilities like "mmx".
+ * We supply "nosegneg" as the fake capability, to indicate that we
+ * do not like negative offsets in instructions using segment overrides,
+ * since we implement those inefficiently.  This makes it possible to
+ * install libraries optimized to avoid those access patterns in someplace
+ * like /lib/i686/tls/nosegneg.  Note that an /etc/ld.so.conf.d/file
+ * corresponding to the bits here is needed to make ldconfig work right.
+ * It should contain:
+ *	hwcap 0 nosegneg
+ * to match the mapping of bit to name that we give here.
+ */
+ELFNOTE_START(GNU, 2, "a")
+	.long 1, 1<<VDSO_NOTE_NONEGSEG_BIT		/* ncaps, mask */
+	.byte VDSO_NOTE_NONEGSEG_BIT; .asciz "nosegneg"	/* bit, name */
+ELFNOTE_END
+#endif
===================================================================
--- a/include/asm-i386/elf.h
+++ b/include/asm-i386/elf.h
@@ -1,10 +1,12 @@
 #ifndef __ASMi386_ELF_H
 #define __ASMi386_ELF_H
 
-/*
- * ELF register definitions..
- */
+/* Bit used for the pseudo-hwcap for non-negative segments.  We use
+   bit 1 to avoid bugs in some versions of glibc when bit 0 is
+   used. */
+#define VDSO_NOTE_NONEGSEG_BIT	1
 
+#ifndef __ASSEMBLY__
 #include <asm/ptrace.h>
 #include <asm/user.h>
 #include <asm/auxvec.h>
@@ -24,6 +26,9 @@
 #define R_386_GOTPC	10
 #define R_386_NUM	11
 
+/*
+ * ELF register definitions..
+ */
 typedef unsigned long elf_greg_t;
 
 #define ELF_NGREG (sizeof (struct user_regs_struct) / sizeof(elf_greg_t))
@@ -160,6 +165,7 @@ do if (vdso_enabled) {							\
 		NEW_AUX_ENT(AT_SYSINFO_EHDR, VDSO_CURRENT_BASE);	\
 } while (0)
 
-#endif
+#endif	/* ARCH_DLINFO */
+#endif	/* __ASSEMBLY__ */
 
 #endif

-- 

