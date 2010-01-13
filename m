Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202Ab0AMCRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab0AMCRR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 21:17:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753486Ab0AMCRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 21:17:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44841 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753462Ab0AMCRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 21:17:16 -0500
Date: Tue, 12 Jan 2010 18:16:42 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: clean up rwsem type system
In-Reply-To: <alpine.LFD.2.00.1001121755220.17145@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1001121810410.17145@localhost.localdomain>
References: <alpine.LFD.2.00.1001121613560.17145@localhost.localdomain> <4B4D1865.5000107@zytor.com> <alpine.LFD.2.00.1001121659220.17145@localhost.localdomain> <alpine.LFD.2.00.1001121708100.17145@localhost.localdomain>
 <alpine.LFD.2.00.1001121755220.17145@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 12 Jan 2010, Linus Torvalds wrote:
> 
> Ok, this is the final cleanup. With this, the <asm/rwsem.h> header file 
> should be usable on x86-64 too. It needs some more support functions (the 
> actual rwsem asm->C trampoline functions that save/restore all the 
> clobbered registers etc), but that's a separate thing.
> 
> Similarly, this will need further changes for actual 64-bit counters. The 
> 32767-thread limit is fine on x86-32 (we're thread-limited by lowmem 
> anyway), but likely not on x86-64.

In case anybody wants to test, the final piece is appended.

Again, note the 32767-thread limit here. So this really does need that 
whole "make rwsem_count_t be 64-bit and fix the BIAS values to match" 
extension on top of it, but that is conceptually a totally independent 
issue.

NOT TESTED! The original patch that this all was based on were tested by 
KAMEZAWA Hiroyuki, but maybe I screwed up something when I created the 
cleaned-up series, so caveat emptor..

Also note that it _may_ be a good idea to mark some more registers 
clobbered on x86-64 in the inline asms instead of saving/restoring them. 
They are inline functions, but they are only used in places where there 
are not a lot of live registers _anyway_, so doing for example the 
clobbers of %r8-%r11 in the asm wouldn't make the fast-path code any 
worse, and would make the slow-path code smaller. 

(Not that the slow-path really matters to that degree. Saving a few 
unnecessary registers is the _least_ of our problems when we hit the slow 
path. The instruction/cycle counting really only matters in the fast 
path).

		Linus

---
x86-64: support native xadd rwsem implementation

This one is much faster than the spinlock based fallback rwsem code,
with certain artifical benchmarks having shown 300%+ improvement on
threaded page faults etc.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 arch/x86/Kconfig.cpu    |    2 +-
 arch/x86/lib/Makefile   |    1 +
 arch/x86/lib/rwsem_64.S |   81 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 83 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index f20ddf8..a198293 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -319,7 +319,7 @@ config X86_L1_CACHE_SHIFT
 
 config X86_XADD
 	def_bool y
-	depends on X86_32 && !M386
+	depends on X86_64 || !M386
 
 config X86_PPRO_FENCE
 	bool "PentiumPro memory ordering errata workaround"
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index cffd754..c802451 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -39,4 +39,5 @@ else
         lib-y += thunk_64.o clear_page_64.o copy_page_64.o
         lib-y += memmove_64.o memset_64.o
         lib-y += copy_user_64.o rwlock_64.o copy_user_nocache_64.o
+	lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem_64.o
 endif
diff --git a/arch/x86/lib/rwsem_64.S b/arch/x86/lib/rwsem_64.S
new file mode 100644
index 0000000..15acecf
--- /dev/null
+++ b/arch/x86/lib/rwsem_64.S
@@ -0,0 +1,81 @@
+/*
+ * x86-64 rwsem wrappers
+ *
+ * This interfaces the inline asm code to the slow-path
+ * C routines. We need to save the call-clobbered regs
+ * that the asm does not mark as clobbered, and move the
+ * argument from %rax to %rdi.
+ *
+ * NOTE! We don't need to save %rax, because the functions
+ * will always return the semaphore pointer in %rax (which
+ * is also the input argument to these helpers)
+ *
+ * The following can clobber %rdx because the asm clobbers it:
+ *   call_rwsem_down_write_failed
+ *   call_rwsem_wake
+ * but %rdi, %rsi, %rcx, %r8-r11 always need saving.
+ */
+
+#include <linux/linkage.h>
+#include <asm/rwlock.h>
+#include <asm/alternative-asm.h>
+#include <asm/frame.h>
+#include <asm/dwarf2.h>
+
+#define save_common_regs \
+	pushq %rdi; \
+	pushq %rsi; \
+	pushq %rcx; \
+	pushq %r8; \
+	pushq %r9; \
+	pushq %r10; \
+	pushq %r11
+
+#define restore_common_regs \
+	popq %r11; \
+	popq %r10; \
+	popq %r9; \
+	popq %r8; \
+	popq %rcx; \
+	popq %rsi; \
+	popq %rdi
+
+/* Fix up special calling conventions */
+ENTRY(call_rwsem_down_read_failed)
+	save_common_regs
+	pushq %rdx
+	movq %rax,%rdi
+	call rwsem_down_read_failed
+	popq %rdx
+	restore_common_regs
+	ret
+	ENDPROC(call_rwsem_down_read_failed)
+
+ENTRY(call_rwsem_down_write_failed)
+	save_common_regs
+	movq %rax,%rdi
+	call rwsem_down_write_failed
+	restore_common_regs
+	ret
+	ENDPROC(call_rwsem_down_write_failed)
+
+ENTRY(call_rwsem_wake)
+	decw %dx    /* do nothing if still outstanding active readers */
+	jnz 1f
+	save_common_regs
+	movq %rax,%rdi
+	call rwsem_wake
+	restore_common_regs
+1:	ret
+	ENDPROC(call_rwsem_wake)
+
+/* Fix up special calling conventions */
+ENTRY(call_rwsem_downgrade_wake)
+	save_common_regs
+	pushq %rdx
+	movq %rax,%rdi
+	call rwsem_downgrade_wake
+	popq %rdx
+	restore_common_regs
+	ret
+	ENDPROC(call_rwsem_downgrade_wake)
