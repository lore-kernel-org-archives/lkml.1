Return-Path: <linux-kernel-owner+w=401wt.eu-S1753644AbYAVUU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbYAVUU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 15:20:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbYAVUUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 15:20:19 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820AbYAVUUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 15:20:18 -0500
Message-ID: <47964FD5.6020801@redhat.com>
Date: Tue, 22 Jan 2008 15:19:33 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Stable Team <stable@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: The SMP alternatives code breaks exception fixup?
References: <479504F6.4080005@redhat.com> <p73zluymnx0.fsf@crumb.suse.de> <alpine.LFD.1.00.0801221312200.3199@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.00.0801221312200.3199@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2008 07:35 AM, Thomas Gleixner wrote:
> 
> That's a long standing bug in both the PI futex and the standard futex
> code. Needs to go to stable as well.
> 

Here's the 2.6.23 version:


Subject: x86: fix missing exception entry for SMP alternatives in futex macros
From: Thomas Gleixner <tglx@linutronix.de>

The exception fixup for the futex macros __futex_atomic_op2 and
futex_atomic_cmpxchg_inatomic() is missing an entry when the lock
prefix is replaced by a NOP via SMP alternatives.

Chuck Ebert tracked this down from the information provided in:
https://bugzilla.redhat.com/show_bug.cgi?id=429412

The solution is to add another fixup after the LOCK_PREFIX, so both
the LOCK and NOP case have their own entry in the exception table.

The solution was pointed out by Andi Kleen.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>

---
 include/asm-i386/futex.h |    8 ++++----
 include/asm-x86_64/futex.h |    8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

Index: linux-2.6/include/asm-i386/futex.h
===================================================================
--- linux-2.6.orig/include/asm-i386/futex.h	2008-01-22 13:13:10.000000000 +0100
+++ linux-2.6/include/asm-i386/futex.h	2008-01-22 13:13:49.000000000 +0100
@@ -28,7 +28,7 @@
 "1:	movl	%2, %0\n\
 	movl	%0, %3\n"					\
 	insn "\n"						\
-"2:	" LOCK_PREFIX "cmpxchgl %3, %2\n\
+"2:	" LOCK_PREFIX "\n 5: cmpxchgl %3, %2\n\
 	jnz	1b\n\
 3:	.section .fixup,\"ax\"\n\
 4:	mov	%5, %1\n\
@@ -36,7 +36,7 @@
 	.previous\n\
 	.section __ex_table,\"a\"\n\
 	.align	8\n\
-	.long	1b,4b,2b,4b\n\
+	.long	1b,4b,2b,4b,5b,4b\n\
 	.previous"						\
 	: "=&a" (oldval), "=&r" (ret), "+m" (*uaddr),		\
 	  "=&r" (tem)						\
@@ -111,7 +111,7 @@ futex_atomic_cmpxchg_inatomic(int __user
 		return -EFAULT;
 
 	__asm__ __volatile__(
-		"1:	" LOCK_PREFIX "cmpxchgl %3, %1		\n"
+		"1:	" LOCK_PREFIX "\n 4: cmpxchgl %3, %1	\n"
 
 		"2:	.section .fixup, \"ax\"			\n"
 		"3:	mov     %2, %0				\n"
@@ -120,7 +120,7 @@ futex_atomic_cmpxchg_inatomic(int __user
 
 		"	.section __ex_table, \"a\"		\n"
 		"	.align  8				\n"
-		"	.long   1b,3b				\n"
+		"	.long   1b,3b,4b,3b			\n"
 		"	.previous				\n"
 
 		: "=a" (oldval), "+m" (*uaddr)
Index: linux-2.6/include/asm-x86_64/futex.h
===================================================================
--- linux-2.6.orig/include/asm-x86_64/futex.h	2008-01-22 13:13:10.000000000 +0100
+++ linux-2.6/include/asm-x86_64/futex.h	2008-01-22 13:13:49.000000000 +0100
@@ -27,7 +27,7 @@
 "1:	movl	%2, %0\n\
 	movl	%0, %3\n"					\
 	insn "\n"						\
-"2:	" LOCK_PREFIX "cmpxchgl %3, %2\n\
+"2:	" LOCK_PREFIX "\n 5: cmpxchgl %3, %2\n\
 	jnz	1b\n\
 3:	.section .fixup,\"ax\"\n\
 4:	mov	%5, %1\n\
@@ -35,7 +35,7 @@
 	.previous\n\
 	.section __ex_table,\"a\"\n\
 	.align	8\n\
-	.quad	1b,4b,2b,4b\n\
+	.quad	1b,4b,2b,4b,5b,4b\n\
 	.previous"						\
 	: "=&a" (oldval), "=&r" (ret), "=m" (*uaddr),		\
 	  "=&r" (tem)						\
@@ -101,7 +101,7 @@ futex_atomic_cmpxchg_inatomic(int __user
 		return -EFAULT;
 
 	__asm__ __volatile__(
-		"1:	" LOCK_PREFIX "cmpxchgl %3, %1		\n"
+		"1:	" LOCK_PREFIX "\n 4: cmpxchgl %3, %1	\n"
 
 		"2:	.section .fixup, \"ax\"			\n"
 		"3:	mov     %2, %0				\n"
@@ -110,7 +110,7 @@ futex_atomic_cmpxchg_inatomic(int __user
 
 		"	.section __ex_table, \"a\"		\n"
 		"	.align  8				\n"
-		"	.quad   1b,3b				\n"
+		"	.quad   1b,3b,4b,3b			\n"
 		"	.previous				\n"
 
 		: "=a" (oldval), "=m" (*uaddr)
