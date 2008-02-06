Return-Path: <linux-kernel-owner+w=401wt.eu-S1760249AbYBFXnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760249AbYBFXnk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:43:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757343AbYBFXnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:43:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60547 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755679AbYBFXna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:43:30 -0500
Date: Thu, 7 Feb 2008 00:43:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>, Chuck Ebbert <cebbert@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Gerd Hoffmann <kraxel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stable Team <stable@kernel.org>
Subject: Re: [stable] The SMP alternatives code breaks exception fixup?
Message-ID: <20080206234309.GA13758@elte.hu>
References: <479504F6.4080005@redhat.com> <p73zluymnx0.fsf@crumb.suse.de> <alpine.LFD.1.00.0801221312200.3199@apollo.tec.linutronix.de> <47964FD5.6020801@redhat.com> <20080206231020.GB12395@kroah.com> <alpine.LFD.1.00.0802061534470.2883@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802061534470.2883@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > I don't see this in Linus's tree, am I just missing it?  Do you have 
> > a git commit id?
> 
> Isn't this 9d55b9923a1b7ea8193b8875c57ec940dc2ff027 (possibly with 
> 2532ec6d178abc55681d049097d3dc577eaa266c on top)?

yeah.

Greg: note that this is against post-unification asm-x86/futex.h so it 
wont apply to .24.

I've backported the fix to .24 - find it below. (untested but obvious)

	Ingo

----------------------->
Subject: x86: replace LOCK_PREFIX in futex.h
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
---
 include/asm-x86/futex_32.h |    6 +++---
 include/asm-x86/futex_64.h |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

Index: linux-2.6.24/include/asm-x86/futex_32.h
===================================================================
--- linux-2.6.24.orig/include/asm-x86/futex_32.h
+++ linux-2.6.24/include/asm-x86/futex_32.h
@@ -28,7 +28,7 @@
 "1:	movl	%2, %0\n\
 	movl	%0, %3\n"					\
 	insn "\n"						\
-"2:	" LOCK_PREFIX "cmpxchgl %3, %2\n\
+"2:	lock; cmpxchgl %3, %2\n					\
 	jnz	1b\n\
 3:	.section .fixup,\"ax\"\n\
 4:	mov	%5, %1\n\
@@ -68,7 +68,7 @@ futex_atomic_op_inuser (int encoded_op, 
 #endif
 		switch (op) {
 		case FUTEX_OP_ADD:
-			__futex_atomic_op1(LOCK_PREFIX "xaddl %0, %2", ret,
+			__futex_atomic_op1("lock; xaddl %0, %2", ret, oldval,
 					   oldval, uaddr, oparg);
 			break;
 		case FUTEX_OP_OR:
@@ -111,8 +111,8 @@ futex_atomic_cmpxchg_inatomic(int __user
 		return -EFAULT;
 
 	__asm__ __volatile__(
-		"1:	" LOCK_PREFIX "cmpxchgl %3, %1		\n"
 
+		"1:	lock; cmpxchgl %3, %1			\n"
 		"2:	.section .fixup, \"ax\"			\n"
 		"3:	mov     %2, %0				\n"
 		"	jmp     2b				\n"
Index: linux-2.6.24/include/asm-x86/futex_64.h
===================================================================
--- linux-2.6.24.orig/include/asm-x86/futex_64.h
+++ linux-2.6.24/include/asm-x86/futex_64.h
@@ -27,7 +27,7 @@
 "1:	movl	%2, %0\n\
 	movl	%0, %3\n"					\
 	insn "\n"						\
-"2:	" LOCK_PREFIX "cmpxchgl %3, %2\n\
+"2:	lock; cmpxchgl %3, %2\n					\
 	jnz	1b\n\
 3:	.section .fixup,\"ax\"\n\
 4:	mov	%5, %1\n\
@@ -62,7 +62,7 @@ futex_atomic_op_inuser (int encoded_op, 
 		__futex_atomic_op1("xchgl %0, %2", ret, oldval, uaddr, oparg);
 		break;
 	case FUTEX_OP_ADD:
-		__futex_atomic_op1(LOCK_PREFIX "xaddl %0, %2", ret, oldval,
+		__futex_atomic_op1("lock; xaddl %0, %2", ret, oldval,
 				   uaddr, oparg);
 		break;
 	case FUTEX_OP_OR:
@@ -101,8 +101,8 @@ futex_atomic_cmpxchg_inatomic(int __user
 		return -EFAULT;
 
 	__asm__ __volatile__(
-		"1:	" LOCK_PREFIX "cmpxchgl %3, %1		\n"
 
+		"1:	lock; cmpxchgl %3, %1			\n"
 		"2:	.section .fixup, \"ax\"			\n"
 		"3:	mov     %2, %0				\n"
 		"	jmp     2b				\n"
