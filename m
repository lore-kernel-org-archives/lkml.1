Return-Path: <linux-kernel-owner+w=401wt.eu-S1753035AbZLZS1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035AbZLZS1f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 13:27:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbZLZS1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 13:27:35 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:45197 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbZLZS1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 13:27:34 -0500
Date: Sat, 26 Dec 2009 23:57:25 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Roland McGrath <roland@redhat.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Vegard Nossum <vegardno@ifi.uio.no>, Oleg Nesterov <oleg@redhat.com>
Subject: [RFC Patch 1/2][Bugfix][x86][hw-breakpoint] Clear reserved bits of
	DR6 in do_debug()
Message-ID: <20091226182725.GB9494@in.ibm.com>
References: <20091226175533.149765731@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=fix_dr6_reserved_01
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clear the reserved bits from the stored copy of debug status register (DR6).
This will help easy bitwise operations.

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
---
 arch/x86/include/asm/debugreg.h |    3 +++
 arch/x86/kernel/traps.c         |    3 +++
 2 files changed, 6 insertions(+)

Index: linux-2.6-tip/arch/x86/include/asm/debugreg.h
===================================================================
--- linux-2.6-tip.orig/arch/x86/include/asm/debugreg.h
+++ linux-2.6-tip/arch/x86/include/asm/debugreg.h
@@ -14,6 +14,9 @@
    which debugging register was responsible for the trap.  The other bits
    are either reserved or not of interest to us. */
 
+/* Define reserved bits in DR6 which are always set to 1 */
+#define DR6_RESERVED	(0xFFFF0FF0)
+
 #define DR_TRAP0	(0x1)		/* db0 */
 #define DR_TRAP1	(0x2)		/* db1 */
 #define DR_TRAP2	(0x4)		/* db2 */
Index: linux-2.6-tip/arch/x86/kernel/traps.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/traps.c
+++ linux-2.6-tip/arch/x86/kernel/traps.c
@@ -534,6 +534,9 @@ dotraplinkage void __kprobes do_debug(st
 
 	get_debugreg(dr6, 6);
 
+	/* Filter out all the reserved bits which are preset to 1 */
+	dr6 &= ~DR6_RESERVED;
+
 	/* Catch kmemcheck conditions first of all! */
 	if ((dr6 & DR_STEP) && kmemcheck_trap(regs))
 		return;

