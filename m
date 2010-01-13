Return-Path: <linux-kernel-owner+w=401wt.eu-S1754169Ab0AMB5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab0AMB5w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 20:57:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753606Ab0AMB5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 20:57:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37950 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751694Ab0AMB5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 20:57:51 -0500
Date: Tue, 12 Jan 2010 17:57:35 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: x86: clean up rwsem type system
In-Reply-To: <alpine.LFD.2.00.1001121708100.17145@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1001121755220.17145@localhost.localdomain>
References: <alpine.LFD.2.00.1001121613560.17145@localhost.localdomain> <4B4D1865.5000107@zytor.com> <alpine.LFD.2.00.1001121659220.17145@localhost.localdomain> <alpine.LFD.2.00.1001121708100.17145@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The fast version of the rwsems (the code that uses xadd) has
traditionally only worked on x86-32, and as a result it mixes different
kinds of types wildly - they just all happen to be 32-bit.  We have
"long", we have "__s32", and we have "int".

To make it work on x86-64, the types suddenly matter a lot more.  It can
be either a 32-bit or 64-bit signed type, and both work (with the caveat
that a 32-bit counter will only have 15 bits of effective write
counters, so it's limited to 32767 users).  But whatever type you
choose, it needs to be used consistently.

This makes a new 'rwsem_counter_t', that is a 32-bit signed type.  For a
64-bit type, you'd need to also update the BIAS values.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---

Ok, this is the final cleanup. With this, the <asm/rwsem.h> header file 
should be usable on x86-64 too. It needs some more support functions (the 
actual rwsem asm->C trampoline functions that save/restore all the 
clobbered registers etc), but that's a separate thing.

Similarly, this will need further changes for actual 64-bit counters. The 
32767-thread limit is fine on x86-32 (we're thread-limited by lowmem 
anyway), but likely not on x86-64.

Comments?


diff --git a/arch/x86/include/asm/rwsem.h b/arch/x86/include/asm/rwsem.h
index e9480be..705265f 100644
--- a/arch/x86/include/asm/rwsem.h
+++ b/arch/x86/include/asm/rwsem.h
@@ -55,6 +55,9 @@ extern asmregparm struct rw_semaphore *
 
 /*
  * the semaphore definition
+ *
+ * The bias values and the counter type needs to be extended to 64 bits
+ * if we want to have more than 32767 potential readers/writers
  */
 
 #define RWSEM_UNLOCKED_VALUE		0x00000000
@@ -64,8 +67,10 @@ extern asmregparm struct rw_semaphore *
 #define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
 #define RWSEM_ACTIVE_WRITE_BIAS		(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
 
+typedef signed int rwsem_count_t;
+
 struct rw_semaphore {
-	signed long		count;
+	rwsem_count_t		count;
 	spinlock_t		wait_lock;
 	struct list_head	wait_list;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
@@ -121,7 +126,7 @@ static inline void __down_read(struct rw_semaphore *sem)
  */
 static inline int __down_read_trylock(struct rw_semaphore *sem)
 {
-	__s32 result, tmp;
+	rwsem_count_t result, tmp;
 	asm volatile("# beginning __down_read_trylock\n\t"
 		     "1:\n\t"
 		     "  mov          %1,%2\n\t"
@@ -142,7 +147,7 @@ static inline int __down_read_trylock(struct rw_semaphore *sem)
  */
 static inline void __down_write_nested(struct rw_semaphore *sem, int subclass)
 {
-	int tmp;
+	rwsem_count_t tmp;
 
 	tmp = RWSEM_ACTIVE_WRITE_BIAS;
 	asm volatile("# beginning down_write\n\t"
@@ -169,9 +174,9 @@ static inline void __down_write(struct rw_semaphore *sem)
  */
 static inline int __down_write_trylock(struct rw_semaphore *sem)
 {
-	signed long ret = cmpxchg(&sem->count,
-				  RWSEM_UNLOCKED_VALUE,
-				  RWSEM_ACTIVE_WRITE_BIAS);
+	rwsem_count_t ret = cmpxchg(&sem->count,
+				    RWSEM_UNLOCKED_VALUE,
+				    RWSEM_ACTIVE_WRITE_BIAS);
 	if (ret == RWSEM_UNLOCKED_VALUE)
 		return 1;
 	return 0;
@@ -182,7 +187,7 @@ static inline int __down_write_trylock(struct rw_semaphore *sem)
  */
 static inline void __up_read(struct rw_semaphore *sem)
 {
-	__s32 tmp = -RWSEM_ACTIVE_READ_BIAS;
+	rwsem_count_t tmp = -RWSEM_ACTIVE_READ_BIAS;
 	asm volatile("# beginning __up_read\n\t"
 		     LOCK_PREFIX "  xadd      %1,(%2)\n\t"
 		     /* subtracts 1, returns the old value */
@@ -200,7 +205,7 @@ static inline void __up_read(struct rw_semaphore *sem)
  */
 static inline void __up_write(struct rw_semaphore *sem)
 {
-	unsigned long tmp;
+	rwsem_count_t tmp;
 	asm volatile("# beginning __up_write\n\t"
 		     LOCK_PREFIX "  xadd      %1,(%2)\n\t"
 		     /* tries to transition
@@ -244,9 +249,9 @@ static inline void rwsem_atomic_add(int delta, struct rw_semaphore *sem)
 /*
  * implement exchange and add functionality
  */
-static inline int rwsem_atomic_update(int delta, struct rw_semaphore *sem)
+static inline rwsem_count_t rwsem_atomic_update(int delta, struct rw_semaphore *sem)
 {
-	int tmp = delta;
+	rwsem_count_t tmp = delta;
 
 	asm volatile(LOCK_PREFIX "xadd %0,%1"
 		     : "+r" (tmp), "+m" (sem->count)
