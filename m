Return-Path: <linux-kernel-owner+w=401wt.eu-S1760693AbYHOQp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760693AbYHOQp2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 12:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755089AbYHOQpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 12:45:15 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:63416 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754436AbYHOQpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 12:45:13 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuYEAMxJpUhMRKxB/2dsb2JhbACBYrIlgVc
Date: Fri, 15 Aug 2008 12:45:09 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, Steven Rostedt <rostedt@goodmis.org>,
       Steven Rostedt <srostedt@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Roland McGrath <roland@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86 : revert replace LOCK_PREFIX in futex.h
Message-ID: <20080815164509.GC21138@Krystal>
References: <20080814205815.GA14076@Krystal> <alpine.LFD.1.10.0808150854140.3324@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808150854140.3324@nehalem.linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:37:56 up 71 days, 21:18,  6 users,  load average: 0.91, 0.78,
	0.83
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Depends on :

x86 alternatives : fix LOCK_PREFIX race with preemptible kernel and CPU hotplug

On Thu, 14 Aug 2008, Mathieu Desnoyers wrote:
>
> Changing the 0x90 (single-byte nop) currently used into a 0x3E DS segment
> override prefix should fix this issue. Since the default of the atomic
> instructions is to use the DS segment anyway, it should not affect the
> behavior.

Ok, so I think this is an _excellent_ patch, but I'd like to also then use
LOCK_PREFIX in include/asm-x86/futex.h.

See commit 9d55b9923a1b7ea8193b8875c57ec940dc2ff027.

                Linus

Applies to 2.6.27-rc2 (and -rc3 unless hell broke loose in futex.h between rc2
and rc3).

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: H. Peter Anvin <hpa@zytor.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Roland McGrath <roland@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
CC: Steven Rostedt <srostedt@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: David Miller <davem@davemloft.net>
CC: Ulrich Drepper <drepper@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: Gregory Haskins <ghaskins@novell.com>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
CC: Clark Williams <williams@redhat.com>
CC: Christoph Lameter <cl@linux-foundation.org>
CC: Andi Kleen <andi@firstfloor.org>
CC: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/asm-x86/futex.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6-lttng/include/asm-x86/futex.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-x86/futex.h	2008-08-15 12:32:38.000000000 -0400
+++ linux-2.6-lttng/include/asm-x86/futex.h	2008-08-15 12:41:33.000000000 -0400
@@ -25,7 +25,7 @@
 	asm volatile("1:\tmovl	%2, %0\n"			\
 		     "\tmovl\t%0, %3\n"				\
 		     "\t" insn "\n"				\
-		     "2:\tlock; cmpxchgl %3, %2\n"		\
+		     "2:\t" LOCK_PREFIX "cmpxchgl %3, %2\n"	\
 		     "\tjnz\t1b\n"				\
 		     "3:\t.section .fixup,\"ax\"\n"		\
 		     "4:\tmov\t%5, %1\n"			\
@@ -64,7 +64,7 @@ static inline int futex_atomic_op_inuser
 		__futex_atomic_op1("xchgl %0, %2", ret, oldval, uaddr, oparg);
 		break;
 	case FUTEX_OP_ADD:
-		__futex_atomic_op1("lock; xaddl %0, %2", ret, oldval,
+		__futex_atomic_op1(LOCK_PREFIX "xaddl %0, %2", ret, oldval,
 				   uaddr, oparg);
 		break;
 	case FUTEX_OP_OR:
@@ -122,7 +122,7 @@ static inline int futex_atomic_cmpxchg_i
 	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
 		return -EFAULT;
 
-	asm volatile("1:\tlock; cmpxchgl %3, %1\n"
+	asm volatile("1:\t" LOCK_PREFIX "cmpxchgl %3, %1\n"
 		     "2:\t.section .fixup, \"ax\"\n"
 		     "3:\tmov     %2, %0\n"
 		     "\tjmp     2b\n"

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
