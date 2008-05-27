Return-Path: <linux-kernel-owner+w=401wt.eu-S1759536AbYE0Utp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759536AbYE0Utp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 16:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758549AbYE0Utf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 16:49:35 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:27822 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756428AbYE0Ute (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 16:49:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=c2F8wwzUOE3s2zLGAh+97Be+J+N7uaj+Vmn8G/UWAhjs7uH2O0PY8HmM9hZ4zvnRYYEOM4gmbZPQqItEaUEH+W/m01Mjwg+ftOGSyJuGFzrPmVQOuoKrRwiscyV3XFvu6TLgu0k15jZvzmos+CXQHgkoqbz69+JepvQg7KBcTUw=
Date: Tue, 27 May 2008 22:49:26 +0200
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: break mutual header inclusion
Message-ID: <20080527204926.GA15020@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

What do you think about this? The new file (vm86_mask.h) could actually be
embedded completely in processor-flags.h, but I went for what I believe is
the safer approach.

This has been compile tested on x86_32 and x86_64 defconfig.


Vegard


From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Tue, 27 May 2008 21:38:35 +0200
Subject: [PATCH] x86: break mutual header inclusion

This breaks up the mutual inclusion between headers ptrace.h and vm86.h
by moving what's needed by both files into a new (minimal) file
vm86_mask.h.

We also move #include lines to the top.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 include/asm-x86/ptrace.h    |   10 +++-------
 include/asm-x86/vm86.h      |    9 ++-------
 include/asm-x86/vm86_mask.h |   12 ++++++++++++
 3 files changed, 17 insertions(+), 14 deletions(-)
 create mode 100644 include/asm-x86/vm86_mask.h

diff --git a/include/asm-x86/ptrace.h b/include/asm-x86/ptrace.h
index 9f922b0..7ba799d 100644
--- a/include/asm-x86/ptrace.h
+++ b/include/asm-x86/ptrace.h
@@ -2,8 +2,10 @@
 #define _ASM_X86_PTRACE_H
 
 #include <linux/compiler.h>	/* For __user */
+#include <asm/ds.h>		/* the DS BTS struct is used for ptrace too */
+#include <asm/segment.h>
 #include <asm/ptrace-abi.h>
-
+#include <asm/vm86_mask.h>
 
 #ifndef __ASSEMBLY__
 
@@ -55,9 +57,6 @@ struct pt_regs {
 	unsigned long ss;
 };
 
-#include <asm/vm86.h>
-#include <asm/segment.h>
-
 #endif /* __KERNEL__ */
 
 #else /* __i386__ */
@@ -127,9 +126,6 @@ struct pt_regs {
 
 #ifdef __KERNEL__
 
-/* the DS BTS struct is used for ptrace as well */
-#include <asm/ds.h>
-
 struct task_struct;
 
 extern void ptrace_bts_take_timestamp(struct task_struct *, enum bts_qualifier);
diff --git a/include/asm-x86/vm86.h b/include/asm-x86/vm86.h
index 074b357..ad8d143 100644
--- a/include/asm-x86/vm86.h
+++ b/include/asm-x86/vm86.h
@@ -13,12 +13,8 @@
  */
 
 #include <asm/processor-flags.h>
-
-#ifdef CONFIG_VM86
-#define X86_VM_MASK	X86_EFLAGS_VM
-#else
-#define X86_VM_MASK	0 /* No VM86 support */
-#endif
+#include <asm/ptrace.h>
+#include <asm/vm86_mask.h>
 
 #define BIOSSEG		0x0f000
 
@@ -141,7 +137,6 @@ struct vm86plus_struct {
  * at the end of the structure. Look at ptrace.h to see the "normal"
  * setup. For user space layout see 'struct vm86_regs' above.
  */
-#include <asm/ptrace.h>
 
 struct kernel_vm86_regs {
 /*
diff --git a/include/asm-x86/vm86_mask.h b/include/asm-x86/vm86_mask.h
new file mode 100644
index 0000000..5f18288
--- /dev/null
+++ b/include/asm-x86/vm86_mask.h
@@ -0,0 +1,12 @@
+#ifndef ASM_X86_VM86_MASK
+#define ASM_X86_VM86_MASK
+
+#include <asm/processor-flags.h>
+
+#ifdef CONFIG_VM86
+#define X86_VM_MASK	X86_EFLAGS_VM
+#else
+#define X86_VM_MASK	0 /* No VM86 support */
+#endif
+
+#endif
-- 
1.5.4.1

