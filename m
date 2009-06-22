Return-Path: <linux-kernel-owner+w=401wt.eu-S1755714AbZFVWpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714AbZFVWpe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 18:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbZFVWp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 18:45:27 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:39900
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbZFVWp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 18:45:27 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Convert mkcapflags.pl to mkcapflags.sh
Date: Mon, 22 Jun 2009 17:45:27 -0500
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; x86_64; ; )
References: <200906221741.17239.rob@landley.net>
In-Reply-To: <200906221741.17239.rob@landley.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906221745.28408.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rob@landley.net>

Convert kernel/cpu/mkcapflags.pl to kernel/cpu/mkcapflags.sh.

This script generates kernel/cpu/capflags.c from include/asm/cpufeature.h.

Signed-off-by: Rob Landley <rob@landley.net>
---

Changes from previous version (http://lkml.org/lkml/2009/1/2/24):

None, just a rediff for 2.6.30.

 arch/x86/kernel/cpu/Makefile      |    4 +--
 arch/x86/kernel/cpu/mkcapflags.pl |   32 ----------------------------
 arch/x86/kernel/cpu/mkcapflags.sh |   28 ++++++++++++++++++++++++
 3 files changed, 30 insertions(+), 34 deletions(-)

diff -ruN linux-2.6.30.old/arch/x86/kernel/cpu/Makefile linux-2.6.30/arch/x86/kernel/cpu/Makefile
--- linux-2.6.30.old/arch/x86/kernel/cpu/Makefile	2009-06-09 22:05:27.000000000 -0500
+++ linux-2.6.30/arch/x86/kernel/cpu/Makefile	2009-06-22 16:39:06.000000000 -0500
@@ -30,10 +30,10 @@
 obj-$(CONFIG_X86_LOCAL_APIC) += perfctr-watchdog.o
 
 quiet_cmd_mkcapflags = MKCAP   $@
-      cmd_mkcapflags = $(PERL) $(srctree)/$(src)/mkcapflags.pl $< $@
+      cmd_mkcapflags = $(CONFIG_SHELL) $(srctree)/$(src)/mkcapflags.sh $< $@
 
 cpufeature = $(src)/../../include/asm/cpufeature.h
 
 targets += capflags.c
-$(obj)/capflags.c: $(cpufeature) $(src)/mkcapflags.pl FORCE
+$(obj)/capflags.c: $(cpufeature) $(src)/mkcapflags.sh FORCE
 	$(call if_changed,mkcapflags)
diff -ruN linux-2.6.30.old/arch/x86/kernel/cpu/mkcapflags.pl linux-2.6.30/arch/x86/kernel/cpu/mkcapflags.pl
--- linux-2.6.30.old/arch/x86/kernel/cpu/mkcapflags.pl	2009-06-09 22:05:27.000000000 -0500
+++ linux-2.6.30/arch/x86/kernel/cpu/mkcapflags.pl	1969-12-31 18:00:00.000000000 -0600
@@ -1,32 +0,0 @@
-#!/usr/bin/perl
-#
-# Generate the x86_cap_flags[] array from include/asm-x86/cpufeature.h
-#
-
-($in, $out) = @ARGV;
-
-open(IN, "< $in\0")   or die "$0: cannot open: $in: $!\n";
-open(OUT, "> $out\0") or die "$0: cannot create: $out: $!\n";
-
-print OUT "#include <asm/cpufeature.h>\n\n";
-print OUT "const char * const x86_cap_flags[NCAPINTS*32] = {\n";
-
-while (defined($line = <IN>)) {
-	if ($line =~ /^\s*\#\s*define\s+(X86_FEATURE_(\S+))\s+(.*)$/) {
-		$macro = $1;
-		$feature = $2;
-		$tail = $3;
-		if ($tail =~ /\/\*\s*\"([^"]*)\".*\*\//) {
-			$feature = $1;
-		}
-
-		if ($feature ne '') {
-			printf OUT "\t%-32s = \"%s\",\n",
-				"[$macro]", "\L$feature";
-		}
-	}
-}
-print OUT "};\n";
-
-close(IN);
-close(OUT);
diff -ruN linux-2.6.30.old/arch/x86/kernel/cpu/mkcapflags.sh linux-2.6.30/arch/x86/kernel/cpu/mkcapflags.sh
--- linux-2.6.30.old/arch/x86/kernel/cpu/mkcapflags.sh	1969-12-31 18:00:00.000000000 -0600
+++ linux-2.6.30/arch/x86/kernel/cpu/mkcapflags.sh	2009-06-22 16:39:06.000000000 -0500
@@ -0,0 +1,28 @@
+#!/bin/sh
+#
+# Generate the x86_cap_flags[] array from include/asm/cpufeature.h
+#
+
+IN=$1
+OUT=$2
+
+(
+	echo "#include <asm/cpufeature.h>"
+	echo ""
+	echo "const char * const x86_cap_flags[NCAPINTS*32] = {"
+
+	# Iterate through any input lines starting with #define X86_FEATURE_
+	sed -n -e 's/\t/ /g' -e 's/^ *# *define *X86_FEATURE_//p' $IN |
+	while read i
+	do
+		# Name is everything up to the first whitespace
+		NAME="$(echo "$i" | sed 's/ .*//')"
+
+		# If the /* comment */ starts with a quote string, grab that.
+		VALUE="$(echo "$i" | sed -n 's@.*/\* *\("[^"]*"\).*\*/@\1@p')"
+		[ -z "$VALUE" ] && VALUE="\"$(echo "$NAME" | tr A-Z a-z)\""
+
+		[ "$VALUE" != '""' ] && echo "	[X86_FEATURE_$NAME] = $VALUE,"
+	done
+	echo "};"
+) > $OUT

-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
