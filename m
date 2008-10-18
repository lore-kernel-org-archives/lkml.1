Return-Path: <linux-kernel-owner+w=401wt.eu-S1757211AbYJRAU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211AbYJRAU1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 20:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755150AbYJRAUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 20:20:19 -0400
Received: from charon.persephoneslair.org ([216.254.15.24]:36885 "EHLO
	charon.persephoneslair.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755090AbYJRAUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 20:20:18 -0400
X-Greylist: delayed 820 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Oct 2008 20:20:18 EDT
Date: Fri, 17 Oct 2008 17:06:35 -0700
From: Andrea Shepard <andrea@persephoneslair.org>
To: davem@davemloft.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix race in arch/sparc64/kernel/trampoline.S
Message-ID: <20081018000635.GA16445@charon.persephoneslair.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make arch/sparc64/kernel/trampoline.S in 2.6.27.1 lock prom_entry_lock
when calling the PROM.  This prevents a race condition that I observed
causing a hang on startup on a 12-CPU E4500.

I am not subscribed to this list, so please CC me on replies.

Signed-off-by: Andrea Shepard <andrea@persephoneslair.org>

diff -Naur linux-2.6.27.1/arch/sparc64/kernel/trampoline.S linux-2.6.27.1.patched/arch/sparc64/kernel/trampoline.S
--- linux-2.6.27.1/arch/sparc64/kernel/trampoline.S	2008-10-15 16:02:53.000000000 -0700
+++ linux-2.6.27.1.patched/arch/sparc64/kernel/trampoline.S	2008-10-17 13:17:09.401334338 -0700
@@ -328,6 +328,12 @@
 
 	wrpr		%g0, 0, %wstate
 
+	sethi		%hi(prom_entry_lock), %g2
+1:	ldstub		[%g2 + %lo(prom_entry_lock)], %g1
+	membar		#StoreLoad | #StoreStore
+	brnz,pn		%g1, 1b
+	 nop
+
 	/* As a hack, put &init_thread_union into %g6.
 	 * prom_world() loads from here to restore the %asi
 	 * register.
@@ -337,9 +343,9 @@
 
 	sethi		%hi(is_sun4v), %o0
 	lduw		[%o0 + %lo(is_sun4v)], %o0
-	brz,pt		%o0, 1f
+	brz,pt		%o0, 2f
 	 nop

 	TRAP_LOAD_TRAP_BLOCK(%g2, %g3)
 	add		%g2, TRAP_PER_CPU_FAULT_INFO, %g2
 	stxa		%g2, [%g0] ASI_SCRATCHPAD
@@ -369,10 +375,10 @@
 	call		%o1
 	 add		%sp, (2047 + 128), %o0
 
-	ba,pt		%xcc, 2f
+	ba,pt		%xcc, 3f
 	 nop
 
-1:	sethi		%hi(sparc64_ttable_tl0), %o0
+2:	sethi		%hi(sparc64_ttable_tl0), %o0
 	set		prom_set_trap_table_name, %g2
 	stx		%g2, [%sp + 2047 + 128 + 0x00]
 	mov		1, %g2
@@ -386,9 +392,13 @@
 	call		%o1
 	 add		%sp, (2047 + 128), %o0
 
-2:	ldx		[%l0], %g6
+3:	sethi		%hi(prom_entry_lock), %g2
+	stb		%g0, [%g2 + %lo(prom_entry_lock)]
+	membar		#StoreStore | #StoreLoad
+
+	ldx		[%l0], %g6
 	ldx		[%g6 + TI_TASK], %g4

 	mov		1, %g5
 	sllx		%g5, THREAD_SHIFT, %g5
 	sub		%g5, (STACKFRAME_SZ + STACK_BIAS), %g5
