Return-Path: <linux-kernel-owner+w=401wt.eu-S932468AbXCEWj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468AbXCEWj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 17:39:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932471AbXCEWj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 17:39:58 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:32656 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932468AbXCEWjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 17:39:55 -0500
Date: Mon, 5 Mar 2007 23:39:55 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: heiko.carstens@de.ibm.com
Subject: [S390] reipl: move dump_prefix_page out of text section.
Message-ID: <20070305223955.GC22630@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

[S390] reipl: move dump_prefix_page out of text section.

Reipl doesn't work on older machines were s390_reset_machine() gets
called. The reason is that the text section is read-only but the
variable dump_prefix_page is there. Since s390_reset_machine() writes
to it we get a protection exception.
Therefore move dump_prefix_page to the bss section.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/ipl.c     |    4 ++--
 arch/s390/kernel/reipl.S   |   13 +++++++------
 arch/s390/kernel/reipl64.S |   13 +++++++++----
 include/asm-s390/ipl.h     |    1 +
 4 files changed, 19 insertions(+), 12 deletions(-)

diff -urpN linux-2.6/arch/s390/kernel/ipl.c linux-2.6-patched/arch/s390/kernel/ipl.c
--- linux-2.6/arch/s390/kernel/ipl.c	2007-03-05 22:51:29.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/ipl.c	2007-03-05 22:51:49.000000000 +0100
@@ -1066,7 +1066,7 @@ static void do_reset_calls(void)
 		reset->fn();
 }
 
-extern __u32 dump_prefix_page;
+u32 dump_prefix_page;
 
 void s390_reset_system(void)
 {
@@ -1078,7 +1078,7 @@ void s390_reset_system(void)
 	lc->panic_stack = S390_lowcore.panic_stack;
 
 	/* Save prefix page address for dump case */
-	dump_prefix_page = (unsigned long) lc;
+	dump_prefix_page = (u32)(unsigned long) lc;
 
 	/* Disable prefixing */
 	set_prefix(0);
diff -urpN linux-2.6/arch/s390/kernel/reipl64.S linux-2.6-patched/arch/s390/kernel/reipl64.S
--- linux-2.6/arch/s390/kernel/reipl64.S	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/reipl64.S	2007-03-05 22:51:49.000000000 +0100
@@ -8,6 +8,12 @@
  */
 
 #include <asm/lowcore.h>
+
+#
+# do_reipl_asm
+# Parameter: r2 = schid of reipl device
+#
+
 		.globl	do_reipl_asm
 do_reipl_asm:	basr	%r13,0
 .Lpg0:		lpswe	.Lnewpsw-.Lpg0(%r13)
@@ -20,7 +26,8 @@ do_reipl_asm:	basr	%r13,0
 		stg	%r0,__LC_GPREGS_SAVE_AREA-0x1000+8(%r1)
 		stctg	%c0,%c15,__LC_CREGS_SAVE_AREA-0x1000(%r1)
 		stam	%a0,%a15,__LC_AREGS_SAVE_AREA-0x1000(%r1)
-		mvc	__LC_PREFIX_SAVE_AREA-0x1000(4,%r1),dump_prefix_page-.Lpg0(%r13)
+		lg	%r10,.Ldump_pfx-.Lpg0(%r13)
+		mvc	__LC_PREFIX_SAVE_AREA-0x1000(4,%r1),0(%r10)
 		stfpc	__LC_FP_CREG_SAVE_AREA-0x1000(%r1)
 		stckc	.Lclkcmp-.Lpg0(%r13)
 		mvc	__LC_CLOCK_COMP_SAVE_AREA-0x1000(8,%r1),.Lclkcmp-.Lpg0(%r13)
@@ -64,6 +71,7 @@ do_reipl_asm:	basr	%r13,0
 		.align	8
 .Lclkcmp:	.quad	0x0000000000000000
 .Lall:		.quad	0x00000000ff000000
+.Ldump_pfx:	.quad	dump_prefix_page
 .Lregsave:	.quad	0x0000000000000000
 		.align	16
 /*
@@ -103,6 +111,3 @@ do_reipl_asm:	basr	%r13,0
 		.long	0x00000000,0x00000000
 		.long	0x00000000,0x00000000
 		.long	0x00000000,0x00000000
-	.globl dump_prefix_page
-dump_prefix_page:
-	.long 0x00000000
diff -urpN linux-2.6/arch/s390/kernel/reipl.S linux-2.6-patched/arch/s390/kernel/reipl.S
--- linux-2.6/arch/s390/kernel/reipl.S	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/reipl.S	2007-03-05 22:51:49.000000000 +0100
@@ -8,6 +8,10 @@
 
 #include <asm/lowcore.h>
 
+#
+# do_reipl_asm
+# Parameter: r2 = schid of reipl device
+#
 		.globl	do_reipl_asm
 do_reipl_asm:	basr	%r13,0
 .Lpg0:		lpsw	.Lnewpsw-.Lpg0(%r13)
@@ -16,12 +20,12 @@ do_reipl_asm:	basr	%r13,0
 		stm	%r0,%r15,__LC_GPREGS_SAVE_AREA
 		stctl	%c0,%c15,__LC_CREGS_SAVE_AREA
 		stam	%a0,%a15,__LC_AREGS_SAVE_AREA
-		mvc	__LC_PREFIX_SAVE_AREA(4),dump_prefix_page-.Lpg0(%r13)
+		l	%r10,.Ldump_pfx-.Lpg0(%r13)
+		mvc	__LC_PREFIX_SAVE_AREA(4),0(%r10)
 		stckc	.Lclkcmp-.Lpg0(%r13)
 		mvc	__LC_CLOCK_COMP_SAVE_AREA(8),.Lclkcmp-.Lpg0(%r13)
 		stpt	__LC_CPU_TIMER_SAVE_AREA
 		st	%r13, __LC_PSW_SAVE_AREA+4
-
 		lctl	%c6,%c6,.Lall-.Lpg0(%r13)
 		lr	%r1,%r2
 		mvc	__LC_PGM_NEW_PSW(8),.Lpcnew-.Lpg0(%r13)
@@ -55,6 +59,7 @@ do_reipl_asm:	basr	%r13,0
 		.align	8
 .Lclkcmp:	.quad	0x0000000000000000
 .Lall:		.long	0xff000000
+.Ldump_pfx:	.long	dump_prefix_page
 		.align	8
 .Lnewpsw:	.long	0x00080000,0x80000000+.Lpg1
 .Lpcnew:	.long	0x00080000,0x80000000+.Lecs
@@ -79,7 +84,3 @@ do_reipl_asm:	basr	%r13,0
 		.long	0x00000000,0x00000000
 		.long	0x00000000,0x00000000
 		.long	0x00000000,0x00000000
-	.globl dump_prefix_page
-dump_prefix_page:
-	.long 0x00000000
-
diff -urpN linux-2.6/include/asm-s390/ipl.h linux-2.6-patched/include/asm-s390/ipl.h
--- linux-2.6/include/asm-s390/ipl.h	2007-03-05 22:51:39.000000000 +0100
+++ linux-2.6-patched/include/asm-s390/ipl.h	2007-03-05 22:51:49.000000000 +0100
@@ -74,6 +74,7 @@ struct ipl_parameter_block {
 extern u32 ipl_flags;
 extern u16 ipl_devno;
 
+extern u32 dump_prefix_page;
 extern void do_reipl(void);
 extern void ipl_save_parameters(void);
 
