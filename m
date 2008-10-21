Return-Path: <linux-kernel-owner+w=401wt.eu-S1753444AbYJUNgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbYJUNgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 09:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751118AbYJUNgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 09:36:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:34239 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbYJUNgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 09:36:12 -0400
Date: Tue, 21 Oct 2008 09:35:26 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Adrian Bunk <bunk@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kbuild@vger.kernel.org
Subject: [PATCH] ftrace: handle generic arch calls
Message-ID: <alpine.DEB.1.10.0810210931190.23042@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The recordmcount script requires that the actual arch is passed in.
This works well when ARCH=i386 or ARCH=x86_64 but does not handle the
case of ARCH=x86.

This patch adds a parameter to the function to pass in the number of
bits of the architecture. So that it can determine if x86 should be
run for x86_64 or i386 archs.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 scripts/Makefile.build  |   10 ++++++++--
 scripts/recordmcount.pl |   11 ++++++++++-
 2 files changed, 18 insertions(+), 3 deletions(-)

Index: linux-compile.git/scripts/Makefile.build
===================================================================
--- linux-compile.git.orig/scripts/Makefile.build	2008-10-21 09:25:45.000000000 -0400
+++ linux-compile.git/scripts/Makefile.build	2008-10-21 09:26:05.000000000 -0400
@@ -198,10 +198,16 @@ cmd_modversions =							\
 	fi;
 endif
 
+ifdef CONFIG_64BIT
+arch_bits = 64
+else
+arch_bits = 32
+endif
+
 ifdef CONFIG_FTRACE_MCOUNT_RECORD
 cmd_record_mcount = perl $(srctree)/scripts/recordmcount.pl \
-	"$(ARCH)" "$(OBJDUMP)" "$(OBJCOPY)" "$(CC)" "$(LD)" "$(NM)" "$(RM)" \
-	"$(MV)" "$(@)";
+	"$(ARCH)" "$(arch_bits)" "$(OBJDUMP)" "$(OBJCOPY)" "$(CC)" "$(LD)" \
+	"$(NM)" "$(RM)" "$(MV)" "$(@)";
 endif
 
 define rule_cc_o_c
Index: linux-compile.git/scripts/recordmcount.pl
===================================================================
--- linux-compile.git.orig/scripts/recordmcount.pl	2008-10-21 09:25:45.000000000 -0400
+++ linux-compile.git/scripts/recordmcount.pl	2008-10-21 09:28:36.000000000 -0400
@@ -106,7 +106,8 @@ if ($#ARGV < 6) {
 	exit(1);
 }
 
-my ($arch, $objdump, $objcopy, $cc, $ld, $nm, $rm, $mv, $inputfile) = @ARGV;
+my ($arch, $bits, $objdump, $objcopy, $cc,
+    $ld, $nm, $rm, $mv, $inputfile) = @ARGV;
 
 $objdump = "objdump" if ((length $objdump) == 0);
 $objcopy = "objcopy" if ((length $objcopy) == 0);
@@ -129,6 +130,14 @@ my $function_regex;	# Find the name of a
 			#    (return offset and func name)
 my $mcount_regex;	# Find the call site to mcount (return offset)
 
+if ($arch eq "x86") {
+    if ($bits == 64) {
+	$arch = "x86_64";
+    } else {
+	$arch = "xi386";
+    }
+}
+
 if ($arch eq "x86_64") {
     $section_regex = "Disassembly of section";
     $function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";

