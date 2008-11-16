Return-Path: <linux-kernel-owner+w=401wt.eu-S1754972AbYKPV0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972AbYKPV0a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 16:26:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753140AbYKPVZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 16:25:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51535 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbYKPVZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 16:25:17 -0500
Message-Id: <20081116212515.531244472@goodmis.org>
References: <20081116212428.938752312@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sun, 16 Nov 2008 16:24:31 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Pekka Paalanen <pq@iki.fi>,
       linuxppc-dev@ozlabs.org, Rusty Russell <rusty@rustcorp.com.au>,
       Paul Mackerras <paulus@samba.org>, Paul Mundt <lethal@linux-sh.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/7] ftrace: powerpc mcount record port
Content-Disposition: inline; filename=0003-ftrace-powerpc-mcount-record-port.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: enable PowerPC for dynamic ftrace

This patch converts PowerPC to use the mcount location section.

Currently, modules will be ignored by the converter.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/powerpc/Kconfig    |    2 ++
 scripts/recordmcount.pl |   13 +++++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index adb23ea..99d9500 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -108,6 +108,8 @@ config ARCH_NO_VIRT_TO_BUS
 config PPC
 	bool
 	default y
+	select HAVE_FTRACE_MCOUNT_RECORD if PPC64
+	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FUNCTION_TRACER
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select HAVE_IDE
diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index eeac71c..7acbe17 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -130,6 +130,7 @@ my %weak;		# List of weak functions
 my %convert;		# List of local functions used that needs conversion
 
 my $type;
+my $nm_regex;		# Find the local functions (return function)
 my $section_regex;	# Find the start of a section
 my $function_regex;	# Find the name of a function
 			#    (return offset and func name)
@@ -145,6 +146,7 @@ if ($arch eq "x86") {
 }
 
 if ($arch eq "x86_64") {
+    $nm_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\S+)";
     $section_regex = "Disassembly of section\\s+(\\S+):";
     $function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
     $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount([+-]0x[0-9a-zA-Z]+)?\$";
@@ -158,6 +160,7 @@ if ($arch eq "x86_64") {
     $cc .= " -m64";
 
 } elsif ($arch eq "i386") {
+    $nm_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\S+)";
     $section_regex = "Disassembly of section\\s+(\\S+):";
     $function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
     $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount\$";
@@ -170,6 +173,12 @@ if ($arch eq "x86_64") {
     $objcopy .= " -O elf32-i386";
     $cc .= " -m32";
 
+} elsif ($arch eq "powerpc") {
+    $nm_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\.?\\S+)";
+    $section_regex = "Disassembly of section\\s+(\\S+):";
+    $function_regex = "^([0-9a-fA-F]+)\\s+<(\\.?.*?)>:";
+    $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s\\.?_mcount\$";
+    $type = ".quad";
 } else {
     die "Arch $arch is not supported with CONFIG_FTRACE_MCOUNT_RECORD";
 }
@@ -239,7 +248,7 @@ if (!$found_version) {
 #
 open (IN, "$nm $inputfile|") || die "error running $nm";
 while (<IN>) {
-    if (/^[0-9a-fA-F]+\s+t\s+(\S+)/) {
+    if (/$nm_regex/) {
 	$locals{$1} = 1;
     } elsif (/^[0-9a-fA-F]+\s+([wW])\s+(\S+)/) {
 	$weak{$2} = $1;
@@ -291,7 +300,7 @@ sub update_funcs
 	    open(FILE, ">$mcount_s") || die "can't create $mcount_s\n";
 	    $opened = 1;
 	    print FILE "\t.section $mcount_section,\"a\",\@progbits\n";
-	    print FILE "\t.align $alignment\n";
+	    print FILE "\t.align $alignment\n" if (defined($alignment));
 	}
 	printf FILE "\t%s %s + %d\n", $type, $ref_func, $offsets[$i] - $offset;
     }
-- 
1.5.6.5

-- 
