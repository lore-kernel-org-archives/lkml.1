Return-Path: <linux-kernel-owner+w=401wt.eu-S1764265AbYCUW4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764265AbYCUW4r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 18:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763670AbYCUWuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:50:22 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:59191 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763659AbYCUWuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:50:20 -0400
Message-Id: <20080321224357.457392668@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:20 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <gregkh@suse.de>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 30/76] x86: replace LOCK_PREFIX in futex.h
Content-Disposition: inline; filename=x86-replace-lock_prefix-in-futex.h.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Thomas Gleixner <tglx@linutronix.de>

The exception fixup for the futex macros __futex_atomic_op1/2 and
futex_atomic_cmpxchg_inatomic() is missing an entry when the lock
prefix is replaced by a NOP via SMP alternatives.

Chuck Ebert tracked this down from the information provided in:
https://bugzilla.redhat.com/show_bug.cgi?id=429412

A possible solution would be to add another fixup after the
LOCK_PREFIX, so both the LOCK and NOP case have their own entry in the
exception table, but it's not really worth the trouble.

Simply replace LOCK_PREFIX with lock and keep those untouched by SMP
alternatives.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
[cebbert@redhat.com: backport to 2.6.24]
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/asm-x86/futex_32.h |    6 +++---
 include/asm-x86/futex_64.h |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/include/asm-x86/futex_32.h
+++ b/include/asm-x86/futex_32.h
@@ -28,7 +28,7 @@
 "1:	movl	%2, %0\n\
 	movl	%0, %3\n"					\
 	insn "\n"						\
-"2:	" LOCK_PREFIX "cmpxchgl %3, %2\n\
+"2:	lock ; cmpxchgl %3, %2\n\
 	jnz	1b\n\
 3:	.section .fixup,\"ax\"\n\
 4:	mov	%5, %1\n\
@@ -68,7 +68,7 @@ futex_atomic_op_inuser (int encoded_op, 
 #endif
 		switch (op) {
 		case FUTEX_OP_ADD:
-			__futex_atomic_op1(LOCK_PREFIX "xaddl %0, %2", ret,
+			__futex_atomic_op1("lock ; xaddl %0, %2", ret,
 					   oldval, uaddr, oparg);
 			break;
 		case FUTEX_OP_OR:
@@ -111,7 +111,7 @@ futex_atomic_cmpxchg_inatomic(int __user
 		return -EFAULT;
 
 	__asm__ __volatile__(
-		"1:	" LOCK_PREFIX "cmpxchgl %3, %1		\n"
+		"1:	lock ; cmpxchgl %3, %1			\n"
 
 		"2:	.section .fixup, \"ax\"			\n"
 		"3:	mov     %2, %0				\n"
--- a/include/asm-x86/futex_64.h
+++ b/include/asm-x86/futex_64.h
@@ -27,7 +27,7 @@
 "1:	movl	%2, %0\n\
 	movl	%0, %3\n"					\
 	insn "\n"						\
-"2:	" LOCK_PREFIX "cmpxchgl %3, %2\n\
+"2:	lock ; cmpxchgl %3, %2\n\
 	jnz	1b\n\
 3:	.section .fixup,\"ax\"\n\
 4:	mov	%5, %1\n\
@@ -62,7 +62,7 @@ futex_atomic_op_inuser (int encoded_op, 
 		__futex_atomic_op1("xchgl %0, %2", ret, oldval, uaddr, oparg);
 		break;
 	case FUTEX_OP_ADD:
-		__futex_atomic_op1(LOCK_PREFIX "xaddl %0, %2", ret, oldval,
+		__futex_atomic_op1("lock ; xaddl %0, %2", ret, oldval,
 				   uaddr, oparg);
 		break;
 	case FUTEX_OP_OR:
@@ -101,7 +101,7 @@ futex_atomic_cmpxchg_inatomic(int __user
 		return -EFAULT;
 
 	__asm__ __volatile__(
-		"1:	" LOCK_PREFIX "cmpxchgl %3, %1		\n"
+		"1:	lock ; cmpxchgl %3, %1			\n"
 
 		"2:	.section .fixup, \"ax\"			\n"
 		"3:	mov     %2, %0				\n"

-- 
