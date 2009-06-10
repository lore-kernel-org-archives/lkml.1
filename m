Return-Path: <linux-kernel-owner+w=401wt.eu-S1757275AbZFJDfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275AbZFJDfm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 23:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754836AbZFJDdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 23:33:43 -0400
Received: from kroah.org ([198.145.64.141]:56651 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755477AbZFJDdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 23:33:42 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 17:23:42 2009
Message-Id: <20090610002341.950940186@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 17:13:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 10/60] sparc64: Reschedule KGDB capture to a software interrupt.
References: <20090610001328.251476848@blue.kroah.org>
Content-Disposition: inline; filename=sparc64-reschedule-kgdb-capture-to-a-software-interrupt.patch
In-Reply-To: <20090610032135.GA19346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: David S. Miller <davem@davemloft.net>

[ Upstream commit 42cc77c861e8e850e86252bb5b1e12e006261973 ]

Otherwise it might interrupt switch_to() midstream and use
half-cooked register window state.

Reported-by: Chris Torek <chris.torek@windriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/include/asm/pil.h |    1 +
 arch/sparc64/kernel/kgdb.c   |    2 +-
 arch/sparc64/kernel/ttable.S |    8 +++++++-
 arch/sparc64/mm/ultra.S      |   24 ++----------------------
 4 files changed, 11 insertions(+), 24 deletions(-)

--- a/arch/sparc64/kernel/kgdb.c
+++ b/arch/sparc64/kernel/kgdb.c
@@ -108,7 +108,7 @@ void gdb_regs_to_pt_regs(unsigned long *
 }
 
 #ifdef CONFIG_SMP
-void smp_kgdb_capture_client(struct pt_regs *regs)
+void smp_kgdb_capture_client(int irq, struct pt_regs *regs)
 {
 	unsigned long flags;
 
--- a/arch/sparc64/kernel/ttable.S
+++ b/arch/sparc64/kernel/ttable.S
@@ -63,7 +63,13 @@ tl0_irq6:	TRAP_IRQ(smp_call_function_sin
 #else
 tl0_irq6:	BTRAP(0x46)
 #endif
-tl0_irq7:	BTRAP(0x47) BTRAP(0x48) BTRAP(0x49)
+tl0_irq7:	BTRAP(0x47)
+#ifdef CONFIG_KGDB
+tl0_irq8:	TRAP_IRQ(smp_kgdb_capture_client, 8)
+#else
+tl0_irq8:	BTRAP(0x48)
+#endif
+tl0_irq9:	BTRAP(0x49)
 tl0_irq10:	BTRAP(0x4a) BTRAP(0x4b) BTRAP(0x4c) BTRAP(0x4d)
 tl0_irq14:	TRAP_IRQ(timer_interrupt, 14)
 tl0_irq15:	TRAP_IRQ(handler_irq, 15)
--- a/arch/sparc64/mm/ultra.S
+++ b/arch/sparc64/mm/ultra.S
@@ -681,28 +681,8 @@ xcall_new_mmu_context_version:
 #ifdef CONFIG_KGDB
 	.globl		xcall_kgdb_capture
 xcall_kgdb_capture:
-661:	rdpr		%pstate, %g2
-	wrpr		%g2, PSTATE_IG | PSTATE_AG, %pstate
-	.section	.sun4v_2insn_patch, "ax"
-	.word		661b
-	nop
-	nop
-	.previous
-
-	rdpr		%pil, %g2
-	wrpr		%g0, 15, %pil
-	sethi		%hi(109f), %g7
-	ba,pt		%xcc, etrap_irq
-109:	 or		%g7, %lo(109b), %g7
-#ifdef CONFIG_TRACE_IRQFLAGS
-	call		trace_hardirqs_off
-	 nop
-#endif
-	call		smp_kgdb_capture_client
-	 add		%sp, PTREGS_OFF, %o0
-	/* Has to be a non-v9 branch due to the large distance. */
-	ba		rtrap_xcall
-	 ldx		[%sp + PTREGS_OFF + PT_V9_TSTATE], %l1
+	wr		%g0, (1 << PIL_KGDB_CAPTURE), %set_softint
+	retry
 #endif
 
 #endif /* CONFIG_SMP */
--- a/arch/sparc/include/asm/pil.h
+++ b/arch/sparc/include/asm/pil.h
@@ -18,5 +18,6 @@
 #define PIL_SMP_CTX_NEW_VERSION	4
 #define PIL_DEVICE_IRQ		5
 #define PIL_SMP_CALL_FUNC_SNGL	6
+#define PIL_KGDB_CAPTURE	8
 
 #endif /* !(_SPARC64_PIL_H) */


