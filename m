Return-Path: <linux-kernel-owner+w=401wt.eu-S1757402AbYKTWNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402AbYKTWNh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 17:13:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756112AbYKTWN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 17:13:27 -0500
Received: from cpe-67-49-92-118.socal.res.rr.com ([67.49.92.118]:45707 "EHLO
	mail.blackbean.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756108AbYKTWN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 17:13:26 -0500
Date: Thu, 20 Nov 2008 14:04:06 -0800
From: Jim Radford <radford@galvanix.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       Paul Mundt <lethal@linux-sh.org>, Matt Fleming <mjf@gentoo.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH] ftrace: mcountrecord.pl for arm
Message-ID: <20081120220406.GA2159@blackbean.org>
References: <20081120203415.251344054@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081120203415.251344054@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo and Steven,

Here is a patch on top of Steven's for recordmcount.pl on arm.

-Jim

---
From: Jim Radford <radford@galvanix.com>
Subject: ftrace: mcountrecord.pl for arm

Signed-Off-By: Jim Radford <radford@galvanix.com>

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index c5c58ac..3d16795 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -135,6 +135,7 @@ my $section_regex;	# Find the start of a section
 my $function_regex;	# Find the name of a function
 			#    (return offset and func name)
 my $mcount_regex;	# Find the call site to mcount (return offset)
+my $section_type;	# Section header plus possible alignment command
 my $alignment;         # The .align value to use for $mcount_section
 
 if ($arch eq "x86") {
@@ -153,6 +154,7 @@ $nm_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\S+)";
 $section_regex = "Disassembly of section\\s+(\\S+):";
 $function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
 $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount\$";
+$section_type = '@progbits';
 $type = ".long";
 
 if ($arch eq "x86_64") {
@@ -191,6 +193,10 @@ if ($arch eq "x86_64") {
 	$type = ".quad";
     }
 
+} elsif ($arch eq "arm") {
+    $alignment = 2;
+    $section_type = '%progbits';
+
 } else {
     die "Arch $arch is not supported with CONFIG_FTRACE_MCOUNT_RECORD";
 }
@@ -311,7 +317,7 @@ sub update_funcs
 	if (!$opened) {
 	    open(FILE, ">$mcount_s") || die "can't create $mcount_s\n";
 	    $opened = 1;
-	    print FILE "\t.section $mcount_section,\"a\",\@progbits\n";
+	    print FILE "\t.section $mcount_section,\"a\",$section_type\n";
 	    print FILE "\t.align $alignment\n" if (defined($alignment));
 	}
 	printf FILE "\t%s %s + %d\n", $type, $ref_func, $offsets[$i] - $offset;
