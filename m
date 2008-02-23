Return-Path: <linux-kernel-owner+w=401wt.eu-S1756606AbYBWQ5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606AbYBWQ5j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 11:57:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751759AbYBWQ5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 11:57:32 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708AbYBWQ5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 11:57:31 -0500
Message-ID: <47C04FF7.4070100@redhat.com>
Date: Sat, 23 Feb 2008 11:55:19 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 0/8] 2.6.23-stable review
References: <20080223001702.GA27727@suse.de>
In-Reply-To: <20080223001702.GA27727@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2008 07:17 PM, Greg KH wrote:
> This is the start of the stable review cycle for the 2.6.23.17 release.
> There are 8 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let us know.  If anyone is a maintainer of the proper subsystem, and
> wants to add a Signed-off-by: line to the patch, please respond with it.
>
> These patches are sent out with a number of different people on the
> Cc: line.  If you wish to be a reviewer, please email stable@kernel.org
> to add your name to the list.  If you want to be off the reviewer list,
> also email us.
>
> Responses should be made by Tuesday, Feb 25, 2008, 00:10:00 UTC.
> Anything received after that time might be too late.
>

Still missing this one? (trivial backport)

Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=9d55b9923a1b7ea8193b8875c57ec940dc2ff027
Commit:     9d55b9923a1b7ea8193b8875c57ec940dc2ff027
Parent:     5df7fa1c62146a0933767d040d400013310dbcc7
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri Feb 1 17:45:14 2008 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri Feb 1 17:45:14 2008 +0100

    x86: replace LOCK_PREFIX in futex.h

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

	[cebbert@redhat.com: backport to 2.6.23]

---
 include/asm-i386/futex.h   |    6 +++---
 include/asm-x86_64/futex.h |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

--- vanilla.orig/include/asm-i386/futex.h
+++ vanilla/include/asm-i386/futex.h
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
--- vanilla.orig/include/asm-x86_64/futex.h
+++ vanilla/include/asm-x86_64/futex.h
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


