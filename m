Return-Path: <linux-kernel-owner+w=401wt.eu-S1754137AbYIEM1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbYIEM1e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 08:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbYIEM1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 08:27:25 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:29880 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbYIEM1Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 08:27:24 -0400
Message-Id: <48C141E1.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 Beta 
Date: Fri, 05 Sep 2008 13:27:45 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>, <hpa@zytor.com>
Cc: "Nick Piggin" <npiggin@suse.de>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] x86: ticket spin locks: reduce instruction
	 dependencies
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

--- linux-x86.orig/include/asm-x86/spinlock.h
+++ linux-x86/include/asm-x86/spinlock.h
@@ -21,8 +21,10 @@
 
 #ifdef CONFIG_X86_32
 # define LOCK_PTR_REG "a"
+# define REG_PTR_MODE "k"
 #else
 # define LOCK_PTR_REG "D"
+# define REG_PTR_MODE "q"
 #endif
 
 #if defined(CONFIG_X86_32) && \
@@ -77,19 +79,17 @@ static __always_inline void __ticket_spi
 
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
 		     LOCK_PREFIX "cmpxchgw %w1,%2\n\t"
 		     "1:"
 		     "sete %b1\n\t"
 		     "movzbl %b1,%0\n\t"
-		     : "=&a" (tmp), "=&Q" (new), "+m" (lock->slock)
+		     : "=&a" (tmp), "=&q" (new), "+m" (lock->slock)
 		     :
 		     : "memory", "cc");
 
@@ -136,8 +136,8 @@ static __always_inline int __ticket_spin
 		     "movl %0,%1\n\t"
 		     "roll $16, %0\n\t"
 		     "cmpl %0,%1\n\t"
+		     "leal 0x00010000(%" REG_PTR_MODE "0), %1\n\t"
 		     "jne 1f\n\t"
-		     "addl $0x00010000, %1\n\t"
 		     LOCK_PREFIX "cmpxchgl %1,%2\n\t"
 		     "1:"
 		     "sete %b1\n\t"



