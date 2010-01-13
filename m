Return-Path: <linux-kernel-owner+w=401wt.eu-S1754696Ab0AMAV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab0AMAV3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 19:21:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754255Ab0AMAV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 19:21:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38352 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754217Ab0AMAV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 19:21:26 -0500
Date: Tue, 12 Jan 2010 16:21:09 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: x86-32: clean up rwsem inline asm statements
Message-ID: <alpine.LFD.2.00.1001121613560.17145@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This makes gcc use the right register names and instruction operand sizes 
automatically for the rwsem inline asm statements.

So instead of using "(%%eax)" to specify the memory address that is the 
semaphore, we use "(%1)" or similar. And instead of forcing the operation 
to always be 32-bit, we use "%z0", taking the size from the actual 
semaphore data structure itself.

This doesn't actually matter on x86-32, but if we want to use the same 
inline asm for x86-64, we'll need to have the compiler generate the proper 
64-bit names for the registers (%rax instead of %eax), and if we want to 
use a 64-bit counter too (in order to avoid the 15-bit limit on the 
write counter that limits concurrent users to 32767 threads), we'll need 
to be able to generate instructions with "q" accesses rather than "l".

Since this header currently isn't enabled on x86-64, none of that matters, 
but we do want to use the xadd version of the semaphores rather than have 
to take spinlocks to do a rwsem. The mm->mmap_sem can be heavily contended 
when you have lots of threads all taking page faults, and the fallback 
rwsem code that uses a spinlock performs abysmally badly in that case.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---

This really should be a no-op, but it does seem to do something to gcc so 
that when I do a "cmp" on the whole kernel before and after, it doesn't 
match. The differences _seem_ to be some code size issue that change all 
the offsets, it's a bit hard to figure it out from the binary.

Anyway, this is purely preparatory, but I think it cleans up the asm too, 
so...

		Linus

 arch/x86/include/asm/rwsem.h |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/rwsem.h b/arch/x86/include/asm/rwsem.h
index ca7517d..4a884e0 100644
--- a/arch/x86/include/asm/rwsem.h
+++ b/arch/x86/include/asm/rwsem.h
@@ -105,7 +105,7 @@ do {								\
 static inline void __down_read(struct rw_semaphore *sem)
 {
 	asm volatile("# beginning down_read\n\t"
-		     LOCK_PREFIX "  incl      (%%eax)\n\t"
+		     LOCK_PREFIX "  inc%z0      (%1)\n\t"
 		     /* adds 0x00000001, returns the old value */
 		     "  jns        1f\n"
 		     "  call call_rwsem_down_read_failed\n"
@@ -123,10 +123,10 @@ static inline int __down_read_trylock(struct rw_semaphore *sem)
 {
 	__s32 result, tmp;
 	asm volatile("# beginning __down_read_trylock\n\t"
-		     "  movl      %0,%1\n\t"
+		     "  mov%z0      %0,%1\n\t"
 		     "1:\n\t"
-		     "  movl	     %1,%2\n\t"
-		     "  addl      %3,%2\n\t"
+		     "  mov%z0	    %1,%2\n\t"
+		     "  add%z0      %3,%2\n\t"
 		     "  jle	     2f\n\t"
 		     LOCK_PREFIX "  cmpxchgl  %2,%0\n\t"
 		     "  jnz	     1b\n\t"
@@ -147,9 +147,9 @@ static inline void __down_write_nested(struct rw_semaphore *sem, int subclass)
 
 	tmp = RWSEM_ACTIVE_WRITE_BIAS;
 	asm volatile("# beginning down_write\n\t"
-		     LOCK_PREFIX "  xadd      %%edx,(%%eax)\n\t"
+		     LOCK_PREFIX "  xadd%z0     %1,(%2)\n\t"
 		     /* subtract 0x0000ffff, returns the old value */
-		     "  testl     %%edx,%%edx\n\t"
+		     "  test%z0     %1,%1\n\t"
 		     /* was the count 0 before? */
 		     "  jz        1f\n"
 		     "  call call_rwsem_down_write_failed\n"
@@ -185,7 +185,7 @@ static inline void __up_read(struct rw_semaphore *sem)
 {
 	__s32 tmp = -RWSEM_ACTIVE_READ_BIAS;
 	asm volatile("# beginning __up_read\n\t"
-		     LOCK_PREFIX "  xadd      %%edx,(%%eax)\n\t"
+		     LOCK_PREFIX "  xadd%z0     %1,(%2)\n\t"
 		     /* subtracts 1, returns the old value */
 		     "  jns        1f\n\t"
 		     "  call call_rwsem_wake\n"
@@ -201,18 +201,18 @@ static inline void __up_read(struct rw_semaphore *sem)
  */
 static inline void __up_write(struct rw_semaphore *sem)
 {
+	unsigned long tmp;
 	asm volatile("# beginning __up_write\n\t"
-		     "  movl      %2,%%edx\n\t"
-		     LOCK_PREFIX "  xaddl     %%edx,(%%eax)\n\t"
+		     LOCK_PREFIX "  xadd%z0     %1,(%2)\n\t"
 		     /* tries to transition
 			0xffff0001 -> 0x00000000 */
 		     "  jz       1f\n"
 		     "  call call_rwsem_wake\n"
 		     "1:\n\t"
 		     "# ending __up_write\n"
-		     : "+m" (sem->count)
-		     : "a" (sem), "i" (-RWSEM_ACTIVE_WRITE_BIAS)
-		     : "memory", "cc", "edx");
+		     : "+m" (sem->count),"=d" (tmp)
+		     : "a" (sem), "1" (-RWSEM_ACTIVE_WRITE_BIAS)
+		     : "memory", "cc");
 }
 
 /*
@@ -221,7 +221,7 @@ static inline void __up_write(struct rw_semaphore *sem)
 static inline void __downgrade_write(struct rw_semaphore *sem)
 {
 	asm volatile("# beginning __downgrade_write\n\t"
-		     LOCK_PREFIX "  addl      %2,(%%eax)\n\t"
+		     LOCK_PREFIX "  add%z0     %2,(%1)\n\t"
 		     /* transitions 0xZZZZ0001 -> 0xYYYY0001 */
 		     "  jns       1f\n\t"
 		     "  call call_rwsem_downgrade_wake\n"
@@ -237,7 +237,7 @@ static inline void __downgrade_write(struct rw_semaphore *sem)
  */
 static inline void rwsem_atomic_add(int delta, struct rw_semaphore *sem)
 {
-	asm volatile(LOCK_PREFIX "addl %1,%0"
+	asm volatile(LOCK_PREFIX "add%z0 %1,%0"
 		     : "+m" (sem->count)
 		     : "ir" (delta));
 }
@@ -249,7 +249,7 @@ static inline int rwsem_atomic_update(int delta, struct rw_semaphore *sem)
 {
 	int tmp = delta;
 
-	asm volatile(LOCK_PREFIX "xadd %0,%1"
+	asm volatile(LOCK_PREFIX "xadd%z0 %0,%1"
 		     : "+r" (tmp), "+m" (sem->count)
 		     : : "memory");
 
