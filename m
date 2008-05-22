Return-Path: <linux-kernel-owner+w=401wt.eu-S1759711AbYEVSb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759711AbYEVSb1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 14:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbYEVSbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 14:31:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34853 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759440AbYEVSbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 14:31:09 -0400
Date: Thu, 22 May 2008 14:31:07 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Michael Ellerman <michael@ellerman.id.au>, proski@gnu.org,
       a.p.zijlstra@chello.nl, Pekka Paalanen <pq@iki.fi>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>, linuxppc-dev@ozlabs.org,
       Soeren Sandmann Pedersen <sandmann@redhat.com>, paulus@samba.org
Subject: [PATCH] ftrace: powerpc clean ups
In-Reply-To: <1211292277.7960.8.camel@localhost>
Message-ID: <Pine.LNX.4.58.0805221429020.18018@gandalf.stny.rr.com>
References: <20080515034942.109223655@goodmis.org>  <20080515035918.896765954@goodmis.org>
 <1211292277.7960.8.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch cleans up the ftrace code in PowerPC based on the comments from
Michael Ellerman.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 -0700                           |binary
 arch/powerpc/kernel/entry_32.S  |   11 ++---------
 arch/powerpc/kernel/ftrace.c    |    8 +++++++-
 arch/powerpc/kernel/ppc_ksyms.c |    5 +++++
 arch/powerpc/kernel/setup_32.c  |    5 -----
 arch/powerpc/kernel/setup_64.c  |    5 -----
 include/asm-powerpc/ftrace.h    |    6 ++++++
 6 files changed, 20 insertions(+), 20 deletions(-)

Index: linux-tip.git/arch/powerpc/kernel/entry_32.S
===================================================================
--- linux-tip.git.orig/arch/powerpc/kernel/entry_32.S	2008-05-22 09:17:51.000000000 -0700
+++ linux-tip.git/arch/powerpc/kernel/entry_32.S	2008-05-22 09:18:21.000000000 -0700
@@ -1129,18 +1129,11 @@ _GLOBAL(_mcount)
 	stw	r5, 8(r1)

 	LOAD_REG_ADDR(r5, ftrace_trace_function)
-#if 0
-	mtctr	r3
-	mr	r1, r5
-	bctrl
-#endif
 	lwz	r5,0(r5)
-#if 1
+
 	mtctr	r5
 	bctrl
-#else
-	bl	ftrace_stub
-#endif
+
 	nop

 	lwz	r6, 8(r1)
Index: linux-tip.git/arch/powerpc/kernel/ftrace.c
===================================================================
--- linux-tip.git.orig/arch/powerpc/kernel/ftrace.c	2008-05-22 09:19:12.000000000 -0700
+++ linux-tip.git/arch/powerpc/kernel/ftrace.c	2008-05-22 09:29:45.000000000 -0700
@@ -51,10 +51,16 @@ notrace unsigned char *ftrace_call_repla
 {
 	static unsigned int op;

+	/*
+	 * It would be nice to just use create_function_call, but that will
+	 * update the code itself. Here we need to just return the
+	 * instruction that is going to be modified, without modifying the
+	 * code.
+	 */
 	addr = GET_ADDR(addr);

 	/* Set to "bl addr" */
-	op = 0x48000001 | (ftrace_calc_offset(ip, addr) & 0x03fffffe);
+	op = 0x48000001 | (ftrace_calc_offset(ip, addr) & 0x03fffffc);

 	/*
 	 * No locking needed, this must be called via kstop_machine
Index: linux-tip.git/arch/powerpc/kernel/ppc_ksyms.c
===================================================================
--- linux-tip.git.orig/arch/powerpc/kernel/ppc_ksyms.c	2008-05-22 09:37:28.000000000 -0700
+++ linux-tip.git/arch/powerpc/kernel/ppc_ksyms.c	2008-05-22 11:07:36.000000000 -0700
@@ -43,6 +43,7 @@
 #include <asm/div64.h>
 #include <asm/signal.h>
 #include <asm/dcr.h>
+#include <asm/ftrace.h>

 #ifdef CONFIG_PPC32
 extern void transfer_to_handler(void);
@@ -68,6 +69,10 @@ EXPORT_SYMBOL(single_step_exception);
 EXPORT_SYMBOL(sys_sigreturn);
 #endif

+#ifdef CONFIG_FTRACE
+EXPORT_SYMBOL(_mcount);
+#endif
+
 EXPORT_SYMBOL(strcpy);
 EXPORT_SYMBOL(strncpy);
 EXPORT_SYMBOL(strcat);
Index: linux-tip.git/arch/powerpc/kernel/setup_64.c
===================================================================
--- linux-tip.git.orig/arch/powerpc/kernel/setup_64.c	2008-05-22 09:35:30.000000000 -0700
+++ linux-tip.git/arch/powerpc/kernel/setup_64.c	2008-05-22 11:25:30.000000000 -0700
@@ -85,11 +85,6 @@ struct ppc64_caches ppc64_caches = {
 };
 EXPORT_SYMBOL_GPL(ppc64_caches);

-#ifdef CONFIG_FTRACE
-extern void _mcount(void);
-EXPORT_SYMBOL(_mcount);
-#endif
-
 /*
  * These are used in binfmt_elf.c to put aux entries on the stack
  * for each elf executable being started.
Index: linux-tip.git/include/asm-powerpc/ftrace.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-tip.git/include/asm-powerpc/ftrace.h	2008-05-22 09:39:39.000000000 -0700
@@ -0,0 +1,6 @@
+#ifndef _ASM_POWERPC_FTRACE
+#define _ASM_POWERPC_FTRACE
+
+extern void _mcount(void);
+
+#endif
Index: linux-tip.git/arch/powerpc/kernel/setup_32.c
===================================================================
--- linux-tip.git.orig/arch/powerpc/kernel/setup_32.c	2008-05-22 09:35:30.000000000 -0700
+++ linux-tip.git/arch/powerpc/kernel/setup_32.c	2008-05-22 11:25:39.000000000 -0700
@@ -47,11 +47,6 @@
 #include <asm/kgdb.h>
 #endif

-#ifdef CONFIG_FTRACE
-extern void _mcount(void);
-EXPORT_SYMBOL(_mcount);
-#endif
-
 extern void bootx_init(unsigned long r4, unsigned long phys);

 int boot_cpuid;


