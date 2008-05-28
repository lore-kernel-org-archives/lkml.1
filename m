Return-Path: <linux-kernel-owner+w=401wt.eu-S1752918AbYE1Hqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbYE1Hqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 03:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750852AbYE1Hqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 03:46:38 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:4054 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbYE1HqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 03:46:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=M/78E9p6zWaD5z6Tegwvuf3pOWDMVBotRCW3tShxzdq8fl73yIWghmWc9YvXpDUuVvImRtnJ/iX0ge7zChBm+Lf6Q/cPG4nspGGYwpXhGUF+99ZtLEZFXAtpaOyFOlJ/H5AkXyTnUJca5vRoEW83eD843dfSnsPL1gN2yJ6WjPc=
Date: Wed, 28 May 2008 09:46:19 +0200
To: Ingo Molnar <mingo@elte.hu>, Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [#2][PATCH] x86: break mutual header inclusion
Message-ID: <20080528074619.GA9235@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Tue, 27 May 2008 21:38:35 +0200
Subject: [PATCH] x86: break mutual header inclusion

This breaks up the mutual inclusion between headers ptrace.h and vm86.h
by moving some small part of vm86.h which is needed by ptrace.h into
processor-flags.h.

We also try to move #include lines to the top.

This has been compile tested on x86_32 and x86_64 defconfig, and run
through 'make headers_check'.

Cc: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 include/asm-x86/processor-flags.h |    6 ++++++
 include/asm-x86/ptrace.h          |   11 +++++------
 include/asm-x86/vm86.h            |    8 +-------
 3 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/include/asm-x86/processor-flags.h b/include/asm-x86/processor-flags.h
index 199cab1..092b39b 100644
--- a/include/asm-x86/processor-flags.h
+++ b/include/asm-x86/processor-flags.h
@@ -88,4 +88,10 @@
 #define CX86_ARR_BASE	0xc4
 #define CX86_RCR_BASE	0xdc
 
+#ifdef CONFIG_VM86
+#define X86_VM_MASK	X86_EFLAGS_VM
+#else
+#define X86_VM_MASK	0 /* No VM86 support */
+#endif
+
 #endif	/* __ASM_I386_PROCESSOR_FLAGS_H */
diff --git a/include/asm-x86/ptrace.h b/include/asm-x86/ptrace.h
index 9f922b0..3cdf146 100644
--- a/include/asm-x86/ptrace.h
+++ b/include/asm-x86/ptrace.h
@@ -3,7 +3,12 @@
 
 #include <linux/compiler.h>	/* For __user */
 #include <asm/ptrace-abi.h>
+#include <asm/processor-flags.h>
 
+#ifdef __KERNEL__
+#include <asm/ds.h>		/* the DS BTS struct is used for ptrace too */
+#include <asm/segment.h>
+#endif
 
 #ifndef __ASSEMBLY__
 
@@ -55,9 +60,6 @@ struct pt_regs {
 	unsigned long ss;
 };
 
-#include <asm/vm86.h>
-#include <asm/segment.h>
-
 #endif /* __KERNEL__ */
 
 #else /* __i386__ */
@@ -127,9 +129,6 @@ struct pt_regs {
 
 #ifdef __KERNEL__
 
-/* the DS BTS struct is used for ptrace as well */
-#include <asm/ds.h>
-
 struct task_struct;
 
 extern void ptrace_bts_take_timestamp(struct task_struct *, enum bts_qualifier);
diff --git a/include/asm-x86/vm86.h b/include/asm-x86/vm86.h
index 074b357..45ab116 100644
--- a/include/asm-x86/vm86.h
+++ b/include/asm-x86/vm86.h
@@ -13,12 +13,7 @@
  */
 
 #include <asm/processor-flags.h>
-
-#ifdef CONFIG_VM86
-#define X86_VM_MASK	X86_EFLAGS_VM
-#else
-#define X86_VM_MASK	0 /* No VM86 support */
-#endif
+#include <asm/ptrace.h>
 
 #define BIOSSEG		0x0f000
 
@@ -141,7 +136,6 @@ struct vm86plus_struct {
  * at the end of the structure. Look at ptrace.h to see the "normal"
  * setup. For user space layout see 'struct vm86_regs' above.
  */
-#include <asm/ptrace.h>
 
 struct kernel_vm86_regs {
 /*
-- 
1.5.4.1

