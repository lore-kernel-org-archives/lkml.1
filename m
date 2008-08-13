Return-Path: <linux-kernel-owner+w=401wt.eu-S1757276AbYHMXrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276AbYHMXrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 19:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754884AbYHMXrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 19:47:03 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:60990 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753716AbYHMXrA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 19:47:00 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjIFACgOo0hMRKxB/2dsb2JhbACBYLU4gVU
Date: Wed, 13 Aug 2008 19:41:56 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, Steven Rostedt <srostedt@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
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
       Christoph Lameter <cl@linux-foundation.org>
Subject: [RFC PATCH] x86 alternatives : fix LOCK_PREFIX race with
	preemptible kernel and CPU hotplug
Message-ID: <20080813234156.GA25775@Krystal>
References: <alpine.DEB.1.10.0808082030500.1396@gandalf.stny.rr.com> <489CE90D.1040902@goop.org> <alpine.LFD.1.10.0808081750060.3462@nehalem.linux-foundation.org> <alpine.DEB.1.10.0808082113090.3707@gandalf.stny.rr.com> <20080813175213.GA8679@Krystal> <alpine.LFD.1.10.0808131119290.3462@nehalem.linux-foundation.org> <20080813184142.GM1366@one.firstfloor.org> <20080813193011.GC15547@Krystal> <20080813193715.GQ1366@one.firstfloor.org> <20080813200119.GA18966@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20080813200119.GA18966@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:37:16 up 70 days,  4:17,  7 users,  load average: 0.54, 0.60,
	0.57
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a kernel thread is preempted in single-cpu mode right after the NOP (nop
about to be turned into a lock prefix), then we CPU hotplug a CPU, and then the
thread is scheduled back again, a SMP-unsafe atomic operation will be used on
shared SMP variables, leading to corruption. No corruption would happen in the
reverse case : going from SMP to UP is ok because we split a bit instruction
into tiny pieces, which does not present this condition.

Changing the 0x90 (single-byte nop) currently used into a 0x3E DS segment
override prefix should fix this issue. Since the default of the atomic
instructions is to use the DS segment anyway, it should not affect the
behavior.

** BIG FAT WARNING (tm) ** : this patch assumes that the 0x3E prefix will
leave atomic operations as-is (thus assuming they normally touch data in the DS
segment). Is there an obnoxious corner-case I would have missed ?

This source :
AMD64 Architecture Programmer's Manual Volume 3: General-Purpose and System
Instructions
States
"Instructions that Reference a Non-Stack Segment—If an instruction encoding
references any base register other than rBP or rSP, or if an instruction
contains an immediate offset, the default segment is the data segment (DS).
These instructions can use the segment-override prefix to select one of the
non-default segments, as shown in Table 1-5."

Therefore, forcing the DS segment on the atomic operations, which already use
the DS segment, should not change.

This source :
http://wiki.osdev.org/X86_Instruction_Encoding
States
"In 64-bit the CS, SS, DS and ES segment overrides are ignored."
(since it's a wiki, it would have to be confirmed, but at least the worse that
happens is that the DS override is ignored)

This patch applies to 2.6.27-rc2, but would also have to be applied to earlier
kernels (2.6.26, 2.6.25, ...).

Performance impact of the fix : tests done on "xaddq" and "xaddl" shows it
actually improves performances on Intel Xeon, AMD64, Pentium M. It does not
change the performance on Pentium 3 and Pentium 4.

Xeon E5405 2.0GHz :
NR_TESTS                                    10000000
test empty cycles :                        162207948
test test 1-byte nop xadd cycles :         170755422
test test DS override prefix xadd cycles : 170000118 *
test test LOCK xadd cycles :               472012134

AMD64 2.0GHz :
NR_TESTS                                    10000000
test empty cycles :                        146674549
test test 1-byte nop xadd cycles :         150273860
test test DS override prefix xadd cycles : 149982382 *
test test LOCK xadd cycles :               270000690

Pentium 4 3.0GHz
NR_TESTS                                    10000000
test empty cycles :                        290001195
test test 1-byte nop xadd cycles :         310000560
test test DS override prefix xadd cycles : 310000575 *
test test LOCK xadd cycles :              1050103740

Pentium M 2.0GHz
NR_TESTS 10000000
test empty cycles :                        180000523
test test 1-byte nop xadd cycles :         320000345
test test DS override prefix xadd cycles : 310000374 *
test test LOCK xadd cycles :               480000357

Pentium 3 550MHz
NR_TESTS                                    10000000
test empty cycles :                        510000231
test test 1-byte nop xadd cycles :         620000128
test test DS override prefix xadd cycles : 620000110 *
test test LOCK xadd cycles :               800000088

Speed test modules can be found at 
http://ltt.polymtl.ca/svn/trunk/tests/kernel/test-prefix-speed-32.c
http://ltt.polymtl.ca/svn/trunk/tests/kernel/test-prefix-speed.c

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andi Kleen <andi@firstfloor.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
CC: Steven Rostedt <srostedt@redhat.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: David Miller <davem@davemloft.net>
CC: Roland McGrath <roland@redhat.com>
CC: Ulrich Drepper <drepper@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: Gregory Haskins <ghaskins@novell.com>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
CC: Clark Williams <williams@redhat.com>
CC: Christoph Lameter <cl@linux-foundation.org>
---
 arch/x86/kernel/alternative.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6-lttng/arch/x86/kernel/alternative.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/alternative.c	2008-08-13 18:42:47.000000000 -0400
+++ linux-2.6-lttng/arch/x86/kernel/alternative.c	2008-08-13 18:54:36.000000000 -0400
@@ -241,25 +241,25 @@ static void alternatives_smp_lock(u8 **s
 			continue;
 		if (*ptr > text_end)
 			continue;
-		text_poke(*ptr, ((unsigned char []){0xf0}), 1); /* add lock prefix */
+		/* turn DS segment override prefix into lock prefix */
+		text_poke(*ptr, ((unsigned char []){0xf0}), 1);
 	};
 }
 
 static void alternatives_smp_unlock(u8 **start, u8 **end, u8 *text, u8 *text_end)
 {
 	u8 **ptr;
-	char insn[1];
 
 	if (noreplace_smp)
 		return;
 
-	add_nops(insn, 1);
 	for (ptr = start; ptr < end; ptr++) {
 		if (*ptr < text)
 			continue;
 		if (*ptr > text_end)
 			continue;
-		text_poke(*ptr, insn, 1);
+		/* turn lock prefix into DS segment override prefix */
+		text_poke(*ptr, ((unsigned char []){0x3E}), 1);
 	};
 }
 
-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
