Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430Ab0BQWA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 17:00:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4039 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756084Ab0BQWAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 17:00:54 -0500
From: Zachary Amsden <zamsden@redhat.com>
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: x86@kernel.org, Avi Kivity <avi@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>
Subject: [PATCH] x86 rwsem optimization extreme
Date: Wed, 17 Feb 2010 11:58:21 -1000
Message-Id: <1266443901-3646-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The x86 instruction set provides the ability to add an additional
bit into addition or subtraction by using the carry flag.
It also provides instructions to directly set or clear the
carry flag.  By forcibly setting the carry flag, we can then
represent one particular 64-bit constant, namely

   0xffffffff + 1 = 0x100000000

using only 32-bit values.  In particular we can optimize the rwsem
write lock release by noting it is of exactly this form.

The old instruction sequence:

0000000000000073 <downgrade_write>:
  73:	55                   	push   %rbp
  74:	48 ba 00 00 00 00 01 	mov    $0x100000000,%rdx
  7b:	00 00 00
  7e:	48 89 f8             	mov    %rdi,%rax
  81:	48 89 e5             	mov    %rsp,%rbp
  84:	f0 48 01 10          	lock add %rdx,(%rax)
  88:	79 05                	jns    8f <downgrade_write+0x1c>
  8a:	e8 00 00 00 00       	callq  8f <downgrade_write+0x1c>
  8f:	c9                   	leaveq
  90:	c3                   	retq

The new instruction sequence:

0000000000000073 <downgrade_write>:
  73:	55                   	push   %rbp
  74:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  79:	48 89 f8             	mov    %rdi,%rax
  7c:	48 89 e5             	mov    %rsp,%rbp
  7f:	f9                   	stc
  80:	f0 48 11 10          	lock adc %rdx,(%rax)
  84:	79 05                	jns    8b <downgrade_write+0x18>
  86:	e8 00 00 00 00       	callq  8b <downgrade_write+0x18>
  8b:	c9                   	leaveq
  8c:	c3                   	retq

Thus we can save a huge amount of space, chiefly, the four extra
bytes required for a 64-bit constant and REX prefix over a 32-bit
constant load and forced carry.

Measured performance impact on Xeon cores is nil; 10e7 loops of
either sequence produces no noticable cycle count difference, with
random variation favoring neither.

Update: measured performance impact on AMD Turion core is also nil.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/include/asm/asm.h   |    1 +
 arch/x86/include/asm/rwsem.h |   23 ++++++++++++++++++-----
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
index b3ed1e1..3744038 100644
--- a/arch/x86/include/asm/asm.h
+++ b/arch/x86/include/asm/asm.h
@@ -25,6 +25,7 @@
 #define _ASM_INC	__ASM_SIZE(inc)
 #define _ASM_DEC	__ASM_SIZE(dec)
 #define _ASM_ADD	__ASM_SIZE(add)
+#define _ASM_ADC	__ASM_SIZE(adc)
 #define _ASM_SUB	__ASM_SIZE(sub)
 #define _ASM_XADD	__ASM_SIZE(xadd)
 
diff --git a/arch/x86/include/asm/rwsem.h b/arch/x86/include/asm/rwsem.h
index 606ede1..147adaf 100644
--- a/arch/x86/include/asm/rwsem.h
+++ b/arch/x86/include/asm/rwsem.h
@@ -233,18 +233,31 @@ static inline void __up_write(struct rw_semaphore *sem)
 static inline void __downgrade_write(struct rw_semaphore *sem)
 {
 	asm volatile("# beginning __downgrade_write\n\t"
+#ifdef CONFIG_X86_64
+#if RWSEM_WAITING_BIAS != -0x100000000
+# error "This code assumes RWSEM_WAITING_BIAS == -2^32"
+#endif
+		     "  stc\n\t"
+		     LOCK_PREFIX _ASM_ADC "%2,(%1)\n\t"
+		     /* transitions 0xZZZZZZZZ00000001 -> 0xYYYYYYYY00000001 */
+		     "  jns       1f\n\t"
+		     "  call call_rwsem_downgrade_wake\n"
+		     "1:\n\t"
+		     "# ending __downgrade_write\n"
+		     : "+m" (sem->count)
+		     : "a" (sem), "r" (-RWSEM_WAITING_BIAS-1)
+		     : "memory", "cc");
+#else
 		     LOCK_PREFIX _ASM_ADD "%2,(%1)\n\t"
-		     /*
-		      * transitions 0xZZZZ0001 -> 0xYYYY0001 (i386)
-		      *     0xZZZZZZZZ00000001 -> 0xYYYYYYYY00000001 (x86_64)
-		      */
+		     /* transitions 0xZZZZ0001 -> 0xYYYY0001 */
 		     "  jns       1f\n\t"
 		     "  call call_rwsem_downgrade_wake\n"
 		     "1:\n\t"
 		     "# ending __downgrade_write\n"
 		     : "+m" (sem->count)
-		     : "a" (sem), "er" (-RWSEM_WAITING_BIAS)
+		     : "a" (sem), "i" (-RWSEM_WAITING_BIAS)
 		     : "memory", "cc");
+#endif
 }
 
 /*
-- 
1.6.6

