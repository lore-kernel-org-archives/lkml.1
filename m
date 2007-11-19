Return-Path: <linux-kernel-owner+w=401wt.eu-S1756262AbXKSWGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbXKSWGO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 17:06:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbXKSWF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 17:05:57 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33911 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755913AbXKSWEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 17:04:35 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 06/18] x86 vDSO: arch/x86/vdso/vdso32
In-Reply-To: Roland McGrath's message of  Monday, 19 November 2007 13:59:43 -0800 <20071119215944.01B7C26F8BE@magilla.localdomain>
References: <20071119215944.01B7C26F8BE@magilla.localdomain>
X-Zippy-Says: If this was a SWEDISH MOVIE, I'd take off your GO-GO BOOTS!!
Message-Id: <20071119220425.6002E26F8BE@magilla.localdomain>
Date: Mon, 19 Nov 2007 14:04:25 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This moves the i386 vDSO sources into arch/x86/vdso/vdso32/, a
new directory.  This patch is a pure renaming, but paves the way
for consolidating the vDSO build logic.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/ia32/vsyscall-sigreturn.S                 |    3 +--
 arch/x86/kernel/Makefile_32                        |    3 +++
 .../vsyscall-int80_32.S => vdso/vdso32/int80.S}    |    2 +-
 .../vsyscall-note_32.S => vdso/vdso32/note.S}      |    2 +-
 .../vdso32/sigreturn.S}                            |    0 
 .../vdso32/sysenter.S}                             |    2 +-
 6 files changed, 7 insertions(+), 5 deletions(-)
 rename arch/x86/{kernel/vsyscall-int80_32.S => vdso/vdso32/int80.S} (97%)
 rename arch/x86/{kernel/vsyscall-note_32.S => vdso/vdso32/note.S} (95%)
 rename arch/x86/{kernel/vsyscall-sigreturn_32.S => vdso/vdso32/sigreturn.S} (100%)
 rename arch/x86/{kernel/vsyscall-sysenter_32.S => vdso/vdso32/sysenter.S} (99%)

diff --git a/arch/x86/ia32/vsyscall-sigreturn.S b/arch/x86/ia32/vsyscall-sigreturn.S
index b383be0..295eecf 100644
--- a/arch/x86/ia32/vsyscall-sigreturn.S
+++ b/arch/x86/ia32/vsyscall-sigreturn.S
@@ -139,5 +139,4 @@ __kernel_rt_sigreturn:
 	.align 4
 .LENDFDE3:
 
-#include "../../x86/kernel/vsyscall-note_32.S"
-
+#include "../vdso/vdso32/note.S"
diff --git a/arch/x86/kernel/Makefile_32 b/arch/x86/kernel/Makefile_32
index a7bc93c..7791895 100644
--- a/arch/x86/kernel/Makefile_32
+++ b/arch/x86/kernel/Makefile_32
@@ -56,6 +56,9 @@ $(obj)/vsyscall_32.o: $(obj)/vsyscall-int80_32.so $(obj)/vsyscall-sysenter_32.so
 targets += $(foreach F,int80 sysenter,vsyscall-$F_32.o vsyscall-$F_32.so)
 targets += vsyscall-note_32.o vsyscall_32.lds
 
+$(obj)/vsyscall-%_32.o: $(src)/../vdso/vdso32/%.S
+	$(call if_changed_dep,as_o_S)
+
 # The DSO images are built using a special linker script.
 quiet_cmd_syscall = SYSCALL $@
       cmd_syscall = $(CC) -m elf_i386 -nostdlib $(SYSCFLAGS_$(@F)) \
diff --git a/arch/x86/kernel/vsyscall-int80_32.S b/arch/x86/vdso/vdso32/int80.S
similarity index 97%
rename from arch/x86/kernel/vsyscall-int80_32.S
rename to arch/x86/vdso/vdso32/int80.S
index 103cab6..3c8e4c6 100644
--- a/arch/x86/kernel/vsyscall-int80_32.S
+++ b/arch/x86/vdso/vdso32/int80.S
@@ -50,4 +50,4 @@ __kernel_vsyscall:
 /*
  * Get the common code for the sigreturn entry points.
  */
-#include "vsyscall-sigreturn_32.S"
+#include "sigreturn.S"
diff --git a/arch/x86/kernel/vsyscall-note_32.S b/arch/x86/vdso/vdso32/note.S
similarity index 95%
rename from arch/x86/kernel/vsyscall-note_32.S
rename to arch/x86/vdso/vdso32/note.S
index fcf376a..0cf934f 100644
--- a/arch/x86/kernel/vsyscall-note_32.S
+++ b/arch/x86/vdso/vdso32/note.S
@@ -33,7 +33,7 @@ ELFNOTE_END
  * at boot time we set VDSO_NOTE_NONEGSEG_BIT if running under Xen.
  */
 
-#include "../../x86/xen/vdso.h"	/* Defines VDSO_NOTE_NONEGSEG_BIT.  */
+#include "../../xen/vdso.h"	/* Defines VDSO_NOTE_NONEGSEG_BIT.  */
 
 	.globl VDSO_NOTE_MASK
 ELFNOTE_START(GNU, 2, "a")
diff --git a/arch/x86/kernel/vsyscall-sigreturn_32.S b/arch/x86/vdso/vdso32/sigreturn.S
similarity index 100%
rename from arch/x86/kernel/vsyscall-sigreturn_32.S
rename to arch/x86/vdso/vdso32/sigreturn.S
diff --git a/arch/x86/kernel/vsyscall-sysenter_32.S b/arch/x86/vdso/vdso32/sysenter.S
similarity index 99%
rename from arch/x86/kernel/vsyscall-sysenter_32.S
rename to arch/x86/vdso/vdso32/sysenter.S
index ed879bf..4b98fc4 100644
--- a/arch/x86/kernel/vsyscall-sysenter_32.S
+++ b/arch/x86/vdso/vdso32/sysenter.S
@@ -119,4 +119,4 @@ SYSENTER_RETURN:
 /*
  * Get the common code for the sigreturn entry points.
  */
-#include "vsyscall-sigreturn_32.S"
+#include "sigreturn.S"
