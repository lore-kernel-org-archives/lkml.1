Return-Path: <linux-kernel-owner+w=401wt.eu-S1755956AbYDIXEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956AbYDIXEV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 19:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754232AbYDIXEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 19:04:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:46890 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559AbYDIXEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 19:04:10 -0400
Date: Wed, 9 Apr 2008 19:04:07 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, akpm@osdl.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Jan Beulich <jbeulich@novell.com>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] pop previous section in alternative.c
Message-ID: <Pine.LNX.4.58.0804091859400.31879@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


gcc expects all toplevel assembly to return to the original section type.
The code in alteranative.c does not do this. This caused some strange bugs
in sched-devel where code would end up in the .rodata section and when
the kernel sets the NX bit on all .rodata, the kernel would crash when
executing this code.

This patch adds a .previous marker to return the code back to the
original section.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/kernel/alternative.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

Index: linux-compile.git/arch/x86/kernel/alternative.c
===================================================================
--- linux-compile.git.orig/arch/x86/kernel/alternative.c	2008-04-09 18:55:28.000000000 -0400
+++ linux-compile.git/arch/x86/kernel/alternative.c	2008-04-09 18:55:49.000000000 -0400
@@ -65,7 +65,8 @@ __setup("noreplace-paravirt", setup_nore
    get them easily into strings. */
 asm("\t.section .rodata, \"a\"\nintelnops: "
 	GENERIC_NOP1 GENERIC_NOP2 GENERIC_NOP3 GENERIC_NOP4 GENERIC_NOP5 GENERIC_NOP6
-	GENERIC_NOP7 GENERIC_NOP8);
+	GENERIC_NOP7 GENERIC_NOP8
+    "\t.previous");
 extern const unsigned char intelnops[];
 static const unsigned char *const intel_nops[ASM_NOP_MAX+1] = {
 	NULL,
@@ -83,7 +84,8 @@ static const unsigned char *const intel_
 #ifdef K8_NOP1
 asm("\t.section .rodata, \"a\"\nk8nops: "
 	K8_NOP1 K8_NOP2 K8_NOP3 K8_NOP4 K8_NOP5 K8_NOP6
-	K8_NOP7 K8_NOP8);
+	K8_NOP7 K8_NOP8
+    "\t.previous");
 extern const unsigned char k8nops[];
 static const unsigned char *const k8_nops[ASM_NOP_MAX+1] = {
 	NULL,
@@ -101,7 +103,8 @@ static const unsigned char *const k8_nop
 #ifdef K7_NOP1
 asm("\t.section .rodata, \"a\"\nk7nops: "
 	K7_NOP1 K7_NOP2 K7_NOP3 K7_NOP4 K7_NOP5 K7_NOP6
-	K7_NOP7 K7_NOP8);
+	K7_NOP7 K7_NOP8
+    "\t.previous");
 extern const unsigned char k7nops[];
 static const unsigned char *const k7_nops[ASM_NOP_MAX+1] = {
 	NULL,
@@ -119,7 +122,8 @@ static const unsigned char *const k7_nop
 #ifdef P6_NOP1
 asm("\t.section .rodata, \"a\"\np6nops: "
 	P6_NOP1 P6_NOP2 P6_NOP3 P6_NOP4 P6_NOP5 P6_NOP6
-	P6_NOP7 P6_NOP8);
+	P6_NOP7 P6_NOP8
+    "\t.previous");
 extern const unsigned char p6nops[];
 static const unsigned char *const p6_nops[ASM_NOP_MAX+1] = {
 	NULL,

