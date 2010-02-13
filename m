Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab0BMIdP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 03:33:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200Ab0BMIdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 03:33:14 -0500
From: Avi Kivity <avi@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2] x86-64, rwsem: Avoid store forwarding hazzard in __downgrade_write
Date: Sat, 13 Feb 2010 10:33:12 +0200
Message-Id: <1266049992-17419-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Intel Architecture Optimization Reference Manual states that a short
load that follows a long store to the same object will suffer a store
forwading penalty, particularly if the two accesses use different addresses.
Trivially, a long load that follows a short store will also suffer a penalty.

__downgrade_write() in rwsem incurs both penalties:  the increment operation
will not be able to reuse a recently-loaded rwsem value, and its result will
not be reused by any recently-following rwsem operation.

A comment in the code states that this is because 64-bit immediates are
special and expensive; but while they are slightly special (only a single
instruction allows them), they aren't expensive: a test shows that two loops,
one loading a 32-bit immediate and one loading a 64-bit immediate, both take
1.5 cycles per iteration.

Fix this by changing __downgrade_write to use the same add instruction on
i386 and on x86_64, so that it uses the same operand size as all the other
rwsem functions.

Signed-off-by: Avi Kivity <avi@redhat.com>
---

v2: use 'e' constraint to avoid #ifdef

 arch/x86/include/asm/rwsem.h |   25 +++++--------------------
 1 files changed, 5 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/rwsem.h b/arch/x86/include/asm/rwsem.h
index 10204a2..606ede1 100644
--- a/arch/x86/include/asm/rwsem.h
+++ b/arch/x86/include/asm/rwsem.h
@@ -232,34 +232,19 @@ static inline void __up_write(struct rw_semaphore *sem)
  */
 static inline void __downgrade_write(struct rw_semaphore *sem)
 {
-#ifdef CONFIG_X86_64
-# if RWSEM_WAITING_BIAS != -0x100000000
-#  error "This code assumes RWSEM_WAITING_BIAS == -2^32"
-# endif
-
-	/* 64-bit immediates are special and expensive, and not needed here */
-	asm volatile("# beginning __downgrade_write\n\t"
-		     LOCK_PREFIX "incl 4(%1)\n\t"
-		     /* transitions 0xZZZZZZZZ00000001 -> 0xYYYYYYYY00000001 */
-		     "  jns       1f\n\t"
-		     "  call call_rwsem_downgrade_wake\n"
-		     "1:\n\t"
-		     "# ending __downgrade_write\n"
-		     : "+m" (sem->count)
-		     : "a" (sem)
-		     : "memory", "cc");
-#else
 	asm volatile("# beginning __downgrade_write\n\t"
 		     LOCK_PREFIX _ASM_ADD "%2,(%1)\n\t"
-		     /* transitions 0xZZZZ0001 -> 0xYYYY0001 */
+		     /*
+		      * transitions 0xZZZZ0001 -> 0xYYYY0001 (i386)
+		      *     0xZZZZZZZZ00000001 -> 0xYYYYYYYY00000001 (x86_64)
+		      */
 		     "  jns       1f\n\t"
 		     "  call call_rwsem_downgrade_wake\n"
 		     "1:\n\t"
 		     "# ending __downgrade_write\n"
 		     : "+m" (sem->count)
-		     : "a" (sem), "i" (-RWSEM_WAITING_BIAS)
+		     : "a" (sem), "er" (-RWSEM_WAITING_BIAS)
 		     : "memory", "cc");
-#endif
 }
 
 /*
-- 
1.6.5.3

