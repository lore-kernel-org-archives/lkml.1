Return-Path: <linux-kernel-owner+w=401wt.eu-S1754420Ab0AMAtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab0AMAtB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 19:49:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753793Ab0AMAtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 19:49:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59404 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab0AMAtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 19:49:00 -0500
Message-ID: <4B4D1865.5000107@zytor.com>
Date: Tue, 12 Jan 2010 16:48:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86-32: clean up rwsem inline asm statements
References: <alpine.LFD.2.00.1001121613560.17145@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1001121613560.17145@localhost.localdomain>
Content-Type: multipart/mixed;
 boundary="------------000803050501090609020003"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000803050501090609020003
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 01/12/2010 04:21 PM, Linus Torvalds wrote:
> 
> So instead of using "(%%eax)" to specify the memory address that is the 
> semaphore, we use "(%1)" or similar. And instead of forcing the operation 
> to always be 32-bit, we use "%z0", taking the size from the actual 
> semaphore data structure itself.
> 
> This doesn't actually matter on x86-32, but if we want to use the same 
> inline asm for x86-64, we'll need to have the compiler generate the proper 
> 64-bit names for the registers (%rax instead of %eax), and if we want to 
> use a 64-bit counter too (in order to avoid the 15-bit limit on the 
> write counter that limits concurrent users to 32767 threads), we'll need 
> to be able to generate instructions with "q" accesses rather than "l".
> 

As far as I can tell, very few of these assembly statements actually
need a size at all -- the very first inc statement is purely to memory,
and as such it needs a size marker, but almost any operation which is
register-register or register-memory will simply take its size from the
register operand.  For those, it seems cleaner to simply drop the size
suffix, and in fact this is the style we have been pushing people
towards (use the suffix where mandatory or where the size is fixed
anyway, to help catch bugs; use no suffix where the size can vary and is
implied by the operands.)

So, proposed alternate version of your patch attached.

(Also changed cmpxchgl -> cmpxchg.)

	-hpa

--------------000803050501090609020003
Content-Type: text/plain;
 name="diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="diff"

diff --git a/arch/x86/include/asm/rwsem.h b/arch/x86/include/asm/rwsem.h
index ca7517d..4136200 100644
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
@@ -123,12 +123,12 @@ static inline int __down_read_trylock(struct rw_semaphore *sem)
 {
 	__s32 result, tmp;
 	asm volatile("# beginning __down_read_trylock\n\t"
-		     "  movl      %0,%1\n\t"
+		     "  mov          %0,%1\n\t"
 		     "1:\n\t"
-		     "  movl	     %1,%2\n\t"
-		     "  addl      %3,%2\n\t"
+		     "  mov          %1,%2\n\t"
+		     "  add          %3,%2\n\t"
 		     "  jle	     2f\n\t"
-		     LOCK_PREFIX "  cmpxchgl  %2,%0\n\t"
+		     LOCK_PREFIX "  cmpxchg  %2,%0\n\t"
 		     "  jnz	     1b\n\t"
 		     "2:\n\t"
 		     "# ending __down_read_trylock\n\t"
@@ -147,9 +147,9 @@ static inline void __down_write_nested(struct rw_semaphore *sem, int subclass)
 
 	tmp = RWSEM_ACTIVE_WRITE_BIAS;
 	asm volatile("# beginning down_write\n\t"
-		     LOCK_PREFIX "  xadd      %%edx,(%%eax)\n\t"
+		     LOCK_PREFIX "  xadd      %1,(%2)\n\t"
 		     /* subtract 0x0000ffff, returns the old value */
-		     "  testl     %%edx,%%edx\n\t"
+		     "  test      %1,%1\n\t"
 		     /* was the count 0 before? */
 		     "  jz        1f\n"
 		     "  call call_rwsem_down_write_failed\n"
@@ -185,7 +185,7 @@ static inline void __up_read(struct rw_semaphore *sem)
 {
 	__s32 tmp = -RWSEM_ACTIVE_READ_BIAS;
 	asm volatile("# beginning __up_read\n\t"
-		     LOCK_PREFIX "  xadd      %%edx,(%%eax)\n\t"
+		     LOCK_PREFIX "  xadd      %1,(%2)\n\t"
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
+		     LOCK_PREFIX "  xadd      %1,(%2)\n\t"
 		     /* tries to transition
 			0xffff0001 -> 0x00000000 */
 		     "  jz       1f\n"
 		     "  call call_rwsem_wake\n"
 		     "1:\n\t"
 		     "# ending __up_write\n"
-		     : "+m" (sem->count)
-		     : "a" (sem), "i" (-RWSEM_ACTIVE_WRITE_BIAS)
-		     : "memory", "cc", "edx");
+		     : "+m" (sem->count), "=d" (tmp)
+		     : "a" (sem), "1" (-RWSEM_ACTIVE_WRITE_BIAS)
+		     : "memory", "cc");
 }
 
 /*
@@ -221,7 +221,7 @@ static inline void __up_write(struct rw_semaphore *sem)
 static inline void __downgrade_write(struct rw_semaphore *sem)
 {
 	asm volatile("# beginning __downgrade_write\n\t"
-		     LOCK_PREFIX "  addl      %2,(%%eax)\n\t"
+		     LOCK_PREFIX "  add%z0    %2,(%1)\n\t"
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

--------------000803050501090609020003--
