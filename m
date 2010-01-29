Return-Path: <linux-kernel-owner+w=401wt.eu-S1756577Ab0A2IWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577Ab0A2IWW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 03:22:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755140Ab0A2IWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 03:22:21 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:27234 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab0A2IWV convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;4:1>);
	Fri, 29 Jan 2010 03:22:21 -0500
Message-Id: <4B62A40B020000780002CA99@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 29 Jan 2010 08:02:03 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] x86: enlightenment for ticket spinlocks - remove
	 NOPs from unlock path
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Under the assumption that the nop-s added by the base ticket spinlock
enlightenment patch might be considered undesirable (or worse), here
is an optional patch to eliminate these nop-s again. This is done
through extending the memory operands of the inc instructions used for
unlocking ticket locks to the necessary size, using assembler and
linker features.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

---
 arch/x86/Makefile                      |    3 +
 arch/x86/include/asm/alternative-asm.h |   59 +++++++++++++++++++++++++++++++++
 arch/x86/include/asm/alternative.h     |    5 ++
 arch/x86/include/asm/spinlock.h        |   27 ++++-----------
 arch/x86/kernel/symdefs.lds            |    1 
 arch/x86/kernel/vmlinux.lds.S          |    2 +
 6 files changed, 78 insertions(+), 19 deletions(-)

--- 2.6.33-rc5-virt-spinlocks.orig/arch/x86/Makefile
+++ 2.6.33-rc5-virt-spinlocks/arch/x86/Makefile
@@ -87,6 +87,9 @@ ifeq ($(CONFIG_KMEMCHECK),y)
 	KBUILD_CFLAGS += $(call cc-option,-fno-builtin-memcpy)
 endif
 
+KBUILD_CFLAGS += -Wa,-I$(srctree)/arch/x86/include
+LDFLAGS_MODULE += -T $(srctree)/arch/x86/kernel/symdefs.lds
+
 # Stackpointer is addressed different for 32 bit and 64 bit x86
 sp-$(CONFIG_X86_32) := esp
 sp-$(CONFIG_X86_64) := rsp
--- 2.6.33-rc5-virt-spinlocks.orig/arch/x86/include/asm/alternative.h
+++ 2.6.33-rc5-virt-spinlocks/arch/x86/include/asm/alternative.h
@@ -6,6 +6,11 @@
 #include <linux/stringify.h>
 #include <asm/asm.h>
 
+#if !defined(__ASSEMBLY__) && !defined(__PIC__)
+#include <asm/alternative-asm.h> /* just for tracking the build dependency */
+__asm__(".include \"asm/alternative-asm.h\"");
+#endif
+
 /*
  * Alternative inline assembly for SMP.
  *
--- 2.6.33-rc5-virt-spinlocks.orig/arch/x86/include/asm/alternative-asm.h
+++ 2.6.33-rc5-virt-spinlocks/arch/x86/include/asm/alternative-asm.h
@@ -1,3 +1,7 @@
+#if 0 /* Hide this from compiler. */
+	.if 0 # Hide assembly source stuff when assembling compiler output.
+#endif
+
 #ifdef __ASSEMBLY__
 
 #include <asm/asm.h>
@@ -16,3 +20,58 @@
 #endif
 
 #endif  /*  __ASSEMBLY__  */
+
+#if 0 /* Hide this from compiler. */
+	.else # Code to be used in compiler output:
+
+	.weak _$.zero
+
+	.macro unary opc arg1 arg2 arg3
+	 .Lempty=2
+	 .irpc c,"\arg2"
+	  .Lempty=3
+	 .endr
+	 .irpc c,"\arg3"
+	  .Lempty=0
+	 .endr
+	 .Lsym=1
+	 .Lnum=0
+	 .irpc c,"\arg1"
+	  .irpc m,"(123456789-0"
+	   .ifeqs "\c","\m"
+	    .Lsym=0
+	    .exitm
+	   .endif
+	   .Lnum=1
+	  .endr
+	  .exitm
+	 .endr
+	 .if .Lempty == 2
+	  .if .Lsym
+	   \opc \arg1
+	  .elseif .Lnum
+	   \opc _$.zero+\arg1
+	  .else
+	   \opc _$.zero\arg1
+	  .endif
+	 .elseif .Lempty == 3
+	  .if .Lsym
+	   \opc \arg1,\arg2
+	  .elseif .Lnum
+	   \opc _$.zero+\arg1,\arg2
+	  .else
+	   \opc _$.zero\arg1,\arg2
+	  .endif
+	 .else
+	  .if .Lsym
+	   \opc \arg1,\arg2,\arg3
+	  .elseif .Lnum
+	   \opc _$.zero+\arg1,\arg2,\arg3
+	  .else
+	   \opc _$.zero\arg1,\arg2,\arg3
+	  .endif
+	 .endif
+	.endm
+
+	.endif
+#endif
--- 2.6.33-rc5-virt-spinlocks.orig/arch/x86/include/asm/spinlock.h
+++ 2.6.33-rc5-virt-spinlocks/arch/x86/include/asm/spinlock.h
@@ -10,7 +10,6 @@
 
 #ifdef CONFIG_ENLIGHTEN_SPINLOCKS
 #include <asm/alternative.h>
-#include <asm/nops.h>
 /* Including asm/smp.h here causes a cyclic include dependency. */
 #include <asm/percpu.h>
 DECLARE_PER_CPU(int, cpu_number);
@@ -155,20 +154,15 @@ static __always_inline int __ticket_spin
 static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
 {
 #ifndef CONFIG_ENLIGHTEN_SPINLOCKS
-	asm volatile(
+	asm volatile(UNLOCK_LOCK_PREFIX "incb %0"
+		     : "+m" (lock->slock)
+		     :
 #else
 	unsigned int token;
 
 	alternative_io(
 		     ".L%=orig:\n\t"
-#endif
-		     UNLOCK_LOCK_PREFIX "incb %0"
-#ifndef CONFIG_ENLIGHTEN_SPINLOCKS
-		     : "+m" (lock->slock)
-		     :
-#else
-		     "\n\t"
-		     ASM_NOP3
+		     UNLOCK_LOCK_PREFIX "unary incb %0\n\t"
 		     ".L%=done:",
 		     ".L%=alt:\n\t"
 		     /* jmp .L%=callout */
@@ -286,20 +280,15 @@ static __always_inline int __ticket_spin
 static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
 {
 #ifndef CONFIG_ENLIGHTEN_SPINLOCKS
-	asm volatile(
+	asm volatile(UNLOCK_LOCK_PREFIX "incw %0"
+		     : "+m" (lock->slock)
+		     :
 #else
 	unsigned int token, tmp;
 
 	alternative_io(
 		     ".L%=orig:\n\t"
-#endif
-		     UNLOCK_LOCK_PREFIX "incw %0"
-#ifndef CONFIG_ENLIGHTEN_SPINLOCKS
-		     : "+m" (lock->slock)
-		     :
-#else
-		     "\n\t"
-		     ASM_NOP2
+		     UNLOCK_LOCK_PREFIX "unary incw %0\n\t"
 		     ".L%=done:",
 		     ".L%=alt:\n\t"
 		     /* jmp .L%=callout */
--- /dev/null
+++ 2.6.33-rc5-virt-spinlocks/arch/x86/kernel/symdefs.lds
@@ -0,0 +1 @@
+_$.zero = 0;
--- 2.6.33-rc5-virt-spinlocks.orig/arch/x86/kernel/vmlinux.lds.S
+++ 2.6.33-rc5-virt-spinlocks/arch/x86/kernel/vmlinux.lds.S
@@ -27,6 +27,8 @@
 #include <asm/cache.h>
 #include <asm/boot.h>
 
+#include "symdefs.lds"
+
 #undef i386     /* in case the preprocessor is a 32bit one */
 
 OUTPUT_FORMAT(CONFIG_OUTPUT_FORMAT, CONFIG_OUTPUT_FORMAT, CONFIG_OUTPUT_FORMAT)


