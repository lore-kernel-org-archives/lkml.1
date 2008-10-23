Return-Path: <linux-kernel-owner+w=401wt.eu-S1756641AbYJWNid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641AbYJWNid (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 09:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbYJWNh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 09:37:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:62136 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbYJWNhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 09:37:25 -0400
Message-Id: <20081023133722.718937147@goodmis.org>
References: <20081023133256.926296694@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 23 Oct 2008 09:32:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Wenji Huang <wenji.huang@oracle.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 01/12 v3] ftrace: handle generic arch calls
Content-Disposition: inline; filename=ftrace-rm-script-bit-interface.patch
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
--- linux-compile.git.orig/scripts/Makefile.build	2008-10-22 15:09:04.000000000 -0400
+++ linux-compile.git/scripts/Makefile.build	2008-10-22 15:09:07.000000000 -0400
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
--- linux-compile.git.orig/scripts/recordmcount.pl	2008-10-22 15:09:04.000000000 -0400
+++ linux-compile.git/scripts/recordmcount.pl	2008-10-22 15:09:45.000000000 -0400
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
+	$arch = "i386";
+    }
+}
+
 if ($arch eq "x86_64") {
     $section_regex = "Disassembly of section";
     $function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";

-- 
