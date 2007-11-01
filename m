Return-Path: <linux-kernel-owner+w=401wt.eu-S1755262AbXKATx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262AbXKATx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 15:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754686AbXKATxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 15:53:51 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:55243 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460AbXKATxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 15:53:50 -0400
Date: Thu, 1 Nov 2007 15:53:26 -0400
From: Jeff Dike <jdike@addtoit.com>
To: stable@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 3/4] UML - stop using libc asm/user.h
Message-ID: <20071101195326.GA8877@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit 08b37a8744252a58766905f29b354a0e611dbdf4
Author: Jeff Dike <jdike@addtoit.com>
Date:   Tue Oct 16 01:27:14 2007 -0700

    uml: don't use glibc asm/user.h
    
    Stop including asm/user.h from libc - it seems to be disappearing from
    distros.  It's replaced with sys/user.h which defines user_fpregs_struct and
    user_fpxregs_struct instead of user_i387_struct and struct user_fxsr_struct on
    i386.
    
    As a bonus, on x86_64, I get to dump some stupid typedefs which were needed in
    order to get asm/user.h to compile.
    
    Signed-off-by: Jeff Dike <jdike@linux.intel.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 arch/um/sys-i386/user-offsets.c   |    6 +++---
 arch/um/sys-x86_64/user-offsets.c |    9 +--------
 2 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/arch/um/sys-i386/user-offsets.c b/arch/um/sys-i386/user-offsets.c
index 29118cf..5142415 100644
--- a/arch/um/sys-i386/user-offsets.c
+++ b/arch/um/sys-i386/user-offsets.c
@@ -2,9 +2,9 @@
 #include <stddef.h>
 #include <signal.h>
 #include <sys/poll.h>
+#include <sys/user.h>
 #include <sys/mman.h>
 #include <asm/ptrace.h>
-#include <asm/user.h>
 
 #define DEFINE(sym, val) \
 	asm volatile("\n->" #sym " %0 " #val : : "i" (val))
@@ -48,8 +48,8 @@ void foo(void)
 	OFFSET(HOST_SC_FP_ST, _fpstate, _st);
 	OFFSET(HOST_SC_FXSR_ENV, _fpstate, _fxsr_env);
 
-	DEFINE_LONGS(HOST_FP_SIZE, sizeof(struct user_i387_struct));
-	DEFINE_LONGS(HOST_XFP_SIZE, sizeof(struct user_fxsr_struct));
+	DEFINE_LONGS(HOST_FP_SIZE, sizeof(struct user_fpregs_struct));
+	DEFINE_LONGS(HOST_XFP_SIZE, sizeof(struct user_fpxregs_struct));
 
 	DEFINE(HOST_IP, EIP);
 	DEFINE(HOST_SP, UESP);
diff --git a/arch/um/sys-x86_64/user-offsets.c b/arch/um/sys-x86_64/user-offsets.c
index 0d5fd76..f1ef2a8 100644
--- a/arch/um/sys-x86_64/user-offsets.c
+++ b/arch/um/sys-x86_64/user-offsets.c
@@ -3,17 +3,10 @@
 #include <signal.h>
 #include <sys/poll.h>
 #include <sys/mman.h>
+#include <sys/user.h>
 #define __FRAME_OFFSETS
 #include <asm/ptrace.h>
 #include <asm/types.h>
-/* For some reason, x86_64 defines u64 and u32 only in <pci/types.h>, which I
- * refuse to include here, even though they're used throughout the headers.
- * These are used in asm/user.h, and that include can't be avoided because of
- * the sizeof(struct user_regs_struct) below.
- */
-typedef __u64 u64;
-typedef __u32 u32;
-#include <asm/user.h>
 
 #define DEFINE(sym, val) \
         asm volatile("\n->" #sym " %0 " #val : : "i" (val))

commit 2a772652c3971745228a2e40e6575ae594c88365
Author: Jeff Dike <jdike@addtoit.com>
Date:   Tue Oct 16 01:26:45 2007 -0700

    uml: fix an IPV6 libc vs kernel symbol clash
    
    On some systems, with IPV6 configured, there is a clash between the kernel's
    in6addr_any and the one in libc.
    
    This is handled in the usual (gross) way of defining the kernel symbol out of
    the way on the gcc command line.
    
    Signed-off-by: Jeff Dike <jdike@linux.intel.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/arch/um/Makefile b/arch/um/Makefile
index 989224f..c3a399e 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -60,7 +60,8 @@ SYS_DIR		:= $(ARCH_DIR)/include/sysdep-$(SUBARCH)
 
 CFLAGS += $(CFLAGS-y) -D__arch_um__ -DSUBARCH=\"$(SUBARCH)\"	\
 	$(ARCH_INCLUDE) $(MODE_INCLUDE) -Dvmap=kernel_vmap	\
-	-Din6addr_loopback=kernel_in6addr_loopback
+	-Din6addr_loopback=kernel_in6addr_loopback \
+	-Din6addr_any=kernel_in6addr_any
 
 AFLAGS += $(ARCH_INCLUDE)
 

