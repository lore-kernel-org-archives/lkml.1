Return-Path: <linux-kernel-owner+w=401wt.eu-S1756209AbYJXNM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbYJXNM3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 09:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbYJXNMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 09:12:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:50351 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbYJXNMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 09:12:20 -0400
Date: Fri, 24 Oct 2008 09:12:17 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Rakib Mullick <rakib.mullick@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] ftrace: use a real variable for ftrace_nop in x86
In-Reply-To: <20081024115005.GA5214@elte.hu>
Message-ID: <alpine.DEB.1.10.0810240910020.3882@gandalf.stny.rr.com>
References: <b9df5fa10810122250j1dd9c0eaq8c708c7b8e10a249@mail.gmail.com> <20081020162756.GA31201@elte.hu> <20081022070312.GA24749@elte.hu> <b9df5fa10810240409u311bb337x1ff9815431088685@mail.gmail.com> <20081024115005.GA5214@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The dynamic ftrace determines which nop is safe to use at start up.
When it finds a safe nop for patching, it sets a pointer called ftrace_nop
to point to the code. All call sites are then patched to this nop.

Later, when tracing is turned on, this ftrace_nop variable is again used
to compare the location to make sure it is a nop before we update it to
a mcount call. If this fails just once, a warning is outputed and ftrace
is disabled.

Rakib Mullick noted that the code that sets up the nop is a .init section
where as the nop itself is in the .text section. This is needed because
the nop is used later on after boot up. The problem is that the test of the
nop jumps back to the setup code and causes a "section mismatch" warning.

Rabik first recommended to convert the nop to .init.text, but as stated
above, this would fail since that text is used later.

The real solution is to extend Rabik's patch, and to make the ftrace_nop
into an array, and just save the code from the assembly to this array.

Now the section can stay as an init section, and we have a nop to use
later on.


Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/kernel/ftrace.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

Index: linux-tip.git/arch/x86/kernel/ftrace.c
===================================================================
--- linux-tip.git.orig/arch/x86/kernel/ftrace.c	2008-10-23 19:23:28.000000000 -0400
+++ linux-tip.git/arch/x86/kernel/ftrace.c	2008-10-24 08:51:59.000000000 -0400
@@ -21,8 +21,7 @@
 #include <asm/nops.h>
 
 
-/* Long is fine, even if it is only 4 bytes ;-) */
-static unsigned long *ftrace_nop;
+static unsigned char ftrace_nop[MCOUNT_INSN_SIZE];
 
 union ftrace_code_union {
 	char code[MCOUNT_INSN_SIZE];
@@ -40,7 +39,7 @@ static int ftrace_calc_offset(long ip, l
 
 unsigned char *ftrace_nop_replace(void)
 {
-	return (char *)ftrace_nop;
+	return ftrace_nop;
 }
 
 unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
@@ -125,9 +124,6 @@ int __init ftrace_dyn_arch_init(void *da
 	 * TODO: check the cpuid to determine the best nop.
 	 */
 	asm volatile (
-		"jmp ftrace_test_jmp\n"
-		/* This code needs to stay around */
-		".section .text, \"ax\"\n"
 		"ftrace_test_jmp:"
 		"jmp ftrace_test_p6nop\n"
 		"nop\n"
@@ -138,8 +134,6 @@ int __init ftrace_dyn_arch_init(void *da
 		"jmp 1f\n"
 		"ftrace_test_nop5:"
 		".byte 0x66,0x66,0x66,0x66,0x90\n"
-		"jmp 1f\n"
-		".previous\n"
 		"1:"
 		".section .fixup, \"ax\"\n"
 		"2:	movl $1, %0\n"
@@ -154,15 +148,15 @@ int __init ftrace_dyn_arch_init(void *da
 	switch (faulted) {
 	case 0:
 		pr_info("ftrace: converting mcount calls to 0f 1f 44 00 00\n");
-		ftrace_nop = (unsigned long *)ftrace_test_p6nop;
+		memcpy(ftrace_nop, ftrace_test_p6nop, MCOUNT_INSN_SIZE);
 		break;
 	case 1:
 		pr_info("ftrace: converting mcount calls to 66 66 66 66 90\n");
-		ftrace_nop = (unsigned long *)ftrace_test_nop5;
+		memcpy(ftrace_nop, ftrace_test_nop5, MCOUNT_INSN_SIZE);
 		break;
 	case 2:
 		pr_info("ftrace: converting mcount calls to jmp . + 5\n");
-		ftrace_nop = (unsigned long *)ftrace_test_jmp;
+		memcpy(ftrace_nop, ftrace_test_jmp, MCOUNT_INSN_SIZE);
 		break;
 	}
 



