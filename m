Return-Path: <linux-kernel-owner+w=401wt.eu-S2992921AbXCIDVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992921AbXCIDVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 22:21:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992927AbXCIDVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 22:21:40 -0500
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:38459 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992923AbXCIDVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 22:21:39 -0500
Date: Thu, 8 Mar 2007 22:21:37 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, mbligh@google.com, linux-kernel@vger.kernel.org,
       hskinnemoen@atmel.com
Subject: [PATCH] Fix avr32 TIF atomicity in do_debug_priv
Message-ID: <20070309032137.GD9462@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 22:19:01 up 34 days, 17:26,  6 users,  load average: 1.20, 1.29, 1.29
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix avr32 TIF atomicity in do_debug_priv

avr32 updates the thread flags 1 - non atomically and 2 - with the wrong value
(for TIF_SINGLE_STEP) in this function.

It applies to 2.6.20.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/arch/avr32/kernel/ptrace.c
+++ b/arch/avr32/kernel/ptrace.c
@@ -306,14 +306,12 @@ asmlinkage void do_debug_priv(struct pt_regs *regs)
 	if (likely(ds & DS_SSS)) {
 		extern void itlb_miss(void);
 		extern void tlb_miss_common(void);
-		struct thread_info *ti;
 
 		dc = __mfdr(DBGREG_DC);
 		dc &= ~DC_SS;
 		__mtdr(DBGREG_DC, dc);
 
-		ti = current_thread_info();
-		ti->flags |= _TIF_BREAKPOINT;
+		set_tsk_thread_flag(tsk, TIF_BREAKPOINT);
 
 		/* The TLB miss handlers don't check thread flags */
 		if ((regs->pc >= (unsigned long)&itlb_miss)
@@ -328,7 +326,7 @@ asmlinkage void do_debug_priv(struct pt_regs *regs)
 		 * single step.
 		 */
 		if ((regs->sr & MODE_MASK) != MODE_SUPERVISOR)
-			ti->flags |= TIF_SINGLE_STEP;
+			set_tsk_thread_flag(tsk, TIF_SINGLE_STEP);
 	} else {
 		panic("Unable to handle debug trap at pc = %08lx\n",
 		      regs->pc);
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
