Return-Path: <linux-kernel-owner+w=401wt.eu-S1757964AbYKUUcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964AbYKUUcG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 15:32:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756114AbYKUUbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 15:31:07 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40719 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087AbYKUUbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 15:31:03 -0500
Message-Id: <20081121203100.453722807@goodmis.org>
References: <20081121202932.281682721@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Nov 2008 15:29:34 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Matt Fleming <mjf@gentoo.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Sam Ravnborg <sam@ravnborg.org>, Jim Radford <radford@galvanix.net>,
       Paul Mundt <lethal@linux-sh.org>, Jim Radford <radford@galvanix.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/5] ftrace: mcountrecord.pl for arm
Content-Disposition: inline; filename=0002-ftrace-mcountrecord.pl-for-arm.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Radford <radford@galvanix.com>

Arm uses %progbits instead of @progbits and requires only 4 byte alignment.

[ Thanks to Sam Ravnborg for mentioning that ARM uses %progbits ]

Signed-off-by: Jim Radford <radford@galvanix.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 scripts/recordmcount.pl |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 03b6af1..0197e2f 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -136,6 +136,7 @@ my $function_regex;	# Find the name of a function
 			#    (return offset and func name)
 my $mcount_regex;	# Find the call site to mcount (return offset)
 my $alignment;		# The .align value to use for $mcount_section
+my $section_type;	# Section header plus possible alignment command
 
 if ($arch eq "x86") {
     if ($bits == 64) {
@@ -153,6 +154,7 @@ $nm_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\S+)";
 $section_regex = "Disassembly of section\\s+(\\S+):";
 $function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
 $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount\$";
+$section_type = '@progbits';
 $type = ".long";
 
 if ($arch eq "x86_64") {
@@ -192,6 +194,10 @@ if ($arch eq "x86_64") {
 	$type = ".quad";
     }
 
+} elsif ($arch eq "arm") {
+    $alignment = 2;
+    $section_type = '%progbits';
+
 } else {
     die "Arch $arch is not supported with CONFIG_FTRACE_MCOUNT_RECORD";
 }
@@ -312,7 +318,7 @@ sub update_funcs
 	if (!$opened) {
 	    open(FILE, ">$mcount_s") || die "can't create $mcount_s\n";
 	    $opened = 1;
-	    print FILE "\t.section $mcount_section,\"a\",\@progbits\n";
+	    print FILE "\t.section $mcount_section,\"a\",$section_type\n";
 	    print FILE "\t.align $alignment\n" if (defined($alignment));
 	}
 	printf FILE "\t%s %s + %d\n", $type, $ref_func, $offsets[$i] - $offset;
-- 
1.5.6.5

-- 
