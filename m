Return-Path: <linux-kernel-owner+w=401wt.eu-S1759464AbYHOQ5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759464AbYHOQ5S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 12:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754553AbYHOQ5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 12:57:05 -0400
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:44119 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754436AbYHOQ5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 12:57:03 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuYEAFxQpUhMRKxB/2dsb2JhbACBYrIZgVc
Date: Fri, 15 Aug 2008 12:56:59 -0400
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
Subject: [PATCH] x86 : spinlock use LOCK_PREFIX
Message-ID: <20080815165659.GD21138@Krystal>
References: <20080814205815.GA14076@Krystal> <alpine.LFD.1.10.0808150854140.3324@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808150854140.3324@nehalem.linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:45:13 up 71 days, 21:25,  7 users,  load average: 1.48, 1.37,
	1.01
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


x86 : spinlock use LOCK_PREFIX

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> 
> 
> On Thu, 14 Aug 2008, Mathieu Desnoyers wrote:
> >
> > Changing the 0x90 (single-byte nop) currently used into a 0x3E DS segment
> > override prefix should fix this issue. Since the default of the atomic
> > instructions is to use the DS segment anyway, it should not affect the
> > behavior.
> 
> Ok, so I think this is an _excellent_ patch, but I'd like to also then use 
> LOCK_PREFIX in include/asm-x86/futex.h.
> 
> See commit 9d55b9923a1b7ea8193b8875c57ec940dc2ff027.
> 
>     Linus

Unless there a rationale for this, I think these be changed to LOCK_PREFIX
too.

grep "lock ;" include/asm-x86/spinlock.h
         "lock ; cmpxchgw %w1,%2\n\t"
  asm volatile("lock ; xaddl %0, %1\n"
         "lock ; cmpxchgl %1,%2\n\t"

Applies to 2.6.27-rc2.

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
 include/asm-x86/spinlock.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6-lttng/include/asm-x86/spinlock.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-x86/spinlock.h	2008-08-15 12:51:59.000000000 -0400
+++ linux-2.6-lttng/include/asm-x86/spinlock.h	2008-08-15 12:52:10.000000000 -0400
@@ -97,7 +97,7 @@ static __always_inline int __ticket_spin
 		     "jne 1f\n\t"
 		     "movw %w0,%w1\n\t"
 		     "incb %h1\n\t"
-		     "lock ; cmpxchgw %w1,%2\n\t"
+		     LOCK_PREFIX "cmpxchgw %w1,%2\n\t"
 		     "1:"
 		     "sete %b1\n\t"
 		     "movzbl %b1,%0\n\t"
@@ -135,7 +135,7 @@ static __always_inline void __ticket_spi
 	int inc = 0x00010000;
 	int tmp;
 
-	asm volatile("lock ; xaddl %0, %1\n"
+	asm volatile(LOCK_PREFIX "xaddl %0, %1\n"
 		     "movzwl %w0, %2\n\t"
 		     "shrl $16, %0\n\t"
 		     "1:\t"
@@ -162,7 +162,7 @@ static __always_inline int __ticket_spin
 		     "cmpl %0,%1\n\t"
 		     "jne 1f\n\t"
 		     "addl $0x00010000, %1\n\t"
-		     "lock ; cmpxchgl %1,%2\n\t"
+		     LOCK_PREFIX "cmpxchgl %1,%2\n\t"
 		     "1:"
 		     "sete %b1\n\t"
 		     "movzbl %b1,%0\n\t"
-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
