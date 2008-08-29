Return-Path: <linux-kernel-owner+w=401wt.eu-S1757697AbYH2L7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757697AbYH2L7O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 07:59:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756781AbYH2L66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 07:58:58 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:14243 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756020AbYH2L66 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 07:58:58 -0400
Message-Id: <48B800EC.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 Beta 
Date: Fri, 29 Aug 2008 13:00:12 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: improve instruction selection/placement for
	 ticket locks
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce the amount of partial register accesses in the NR_CPUS < 256
case, and slightly weaken resource dependencies in the other case.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Nick Piggin <npiggin@suse.de>

---
 include/asm-x86/spinlock.h |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- linux-2.6.27-rc5/include/asm-x86/spinlock.h	2008-08-21 14:37:34.000000000 +0200
+++ 2.6.27-rc5-x86-spinlock-insns/include/asm-x86/spinlock.h	2008-08-19 12:43:22.000000000 +0200
@@ -21,8 +21,10 @@
 
 #ifdef CONFIG_X86_32
 # define LOCK_PTR_REG "a"
+# define REG_PTR_MODE "k"
 #else
 # define LOCK_PTR_REG "D"
+# define REG_PTR_MODE "q"
 #endif
 
 #if defined(CONFIG_X86_32) && \
@@ -89,19 +91,17 @@ static __always_inline void __ticket_spi
 
 static __always_inline int __ticket_spin_trylock(raw_spinlock_t *lock)
 {
-	int tmp;
-	short new;
+	int tmp, new;
 
-	asm volatile("movw %2,%w0\n\t"
+	asm volatile("movzwl %2, %0\n\t"
 		     "cmpb %h0,%b0\n\t"
+		     "leal 0x100(%" REG_PTR_MODE "0), %1\n\t"
 		     "jne 1f\n\t"
-		     "movw %w0,%w1\n\t"
-		     "incb %h1\n\t"
 		     "lock ; cmpxchgw %w1,%2\n\t"
 		     "1:"
 		     "sete %b1\n\t"
 		     "movzbl %b1,%0\n\t"
-		     : "=&a" (tmp), "=Q" (new), "+m" (lock->slock)
+		     : "=&a" (tmp), "=&q" (new), "+m" (lock->slock)
 		     :
 		     : "memory", "cc");
 
@@ -160,8 +160,8 @@ static __always_inline int __ticket_spin
 		     "movl %0,%1\n\t"
 		     "roll $16, %0\n\t"
 		     "cmpl %0,%1\n\t"
+		     "leal 0x00010000(%" REG_PTR_MODE "0), %1\n\t"
 		     "jne 1f\n\t"
-		     "addl $0x00010000, %1\n\t"
 		     "lock ; cmpxchgl %1,%2\n\t"
 		     "1:"
 		     "sete %b1\n\t"



