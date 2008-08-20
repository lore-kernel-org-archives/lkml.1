Return-Path: <linux-kernel-owner+w=401wt.eu-S1757792AbYHTOHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757792AbYHTOHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 10:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbYHTOHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 10:07:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:49038 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbYHTOHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 10:07:36 -0400
Date: Wed, 20 Aug 2008 10:07:35 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] ftrace: handle weak symbol functions
Message-ID: <alpine.DEB.1.10.0808200049140.13132@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


During tests and checks, I've discovered that there were failures to
convert mcount callers into nops. Looking deeper into these failures,
code that was attempted to be changed was not an mcount caller.
The current code only updates if the code being changed is what it expects,
but I still investigate any time there is a failure.

What was happening is that a weak symbol was being used as a reference
for other mcount callers. That weak symbol was also referenced elsewhere
so the offsets were using the strong symbol and not the function symbol
that it was referenced from.

This patch changes the setting up of the mcount_loc section to search
for a global function that is not weak. It will pick a local over a weak
but if only a weak is found in a section, a warning is printed and the
mcount location is not recorded (just to be safe).

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 scripts/recordmcount.pl |  106 ++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 86 insertions(+), 20 deletions(-)

Index: linux-tip.git/scripts/recordmcount.pl
===================================================================
--- linux-tip.git.orig/scripts/recordmcount.pl	2008-08-20 09:27:03.000000000 -0400
+++ linux-tip.git/scripts/recordmcount.pl	2008-08-20 09:36:26.000000000 -0400
@@ -119,17 +119,19 @@ $mv = "mv" if ((length $mv) == 0);
 #print STDERR "running: $P '$arch' '$objdump' '$objcopy' '$cc' '$ld' " .
 #    "'$nm' '$rm' '$mv' '$inputfile'\n";
 
-my %locals;
-my %convert;
+my %locals;		# List of local (static) functions
+my %weak;		# List of weak functions
+my %convert;		# List of local functions used that needs conversion
 
 my $type;
 my $section_regex;	# Find the start of a section
-my $function_regex;	# Find the name of a function (return func name)
+my $function_regex;	# Find the name of a function
+			#    (return offset and func name)
 my $mcount_regex;	# Find the call site to mcount (return offset)
 
 if ($arch eq "x86_64") {
     $section_regex = "Disassembly of section";
-    $function_regex = "<(.*?)>:";
+    $function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
     $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount([+-]0x[0-9a-zA-Z]+)?\$";
     $type = ".quad";
 
@@ -141,7 +143,7 @@ if ($arch eq "x86_64") {
 
 } elsif ($arch eq "i386") {
     $section_regex = "Disassembly of section";
-    $function_regex = "<(.*?)>:";
+    $function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
     $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount\$";
     $type = ".long";
 
@@ -158,7 +160,6 @@ if ($arch eq "x86_64") {
 my $text_found = 0;
 my $read_function = 0;
 my $opened = 0;
-my $text = "";
 my $mcount_section = "__mcount_loc";
 
 my $dirname;
@@ -186,46 +187,111 @@ my $mcount_s = $dirname . "/.tmp_mc_" . 
 my $mcount_o = $dirname . "/.tmp_mc_" . $prefix . ".o";
 
 #
-# Step 1: find all the local symbols (static functions).
+# Step 1: find all the local (static functions) and weak symbols.
+#        't' is local, 'w/W' is weak (we never use a weak function)
 #
 open (IN, "$nm $inputfile|") || die "error running $nm";
 while (<IN>) {
     if (/^[0-9a-fA-F]+\s+t\s+(\S+)/) {
 	$locals{$1} = 1;
+    } elsif (/^[0-9a-fA-F]+\s+([wW])\s+(\S+)/) {
+	$weak{$2} = $1;
     }
 }
 close(IN);
 
+my @offsets;		# Array of offsets of mcount callers
+my $ref_func;		# reference function to use for offsets
+my $offset = 0;		# offset of ref_func to section beginning
+
+##
+# update_funcs - print out the current mcount callers
+#
+#  Go through the list of offsets to callers and write them to
+#  the output file in a format that can be read by an assembler.
+#
+sub update_funcs
+{
+    return if ($#offsets < 0);
+
+    defined($ref_func) || die "No function to reference";
+
+    # A section only had a weak function, to represent it.
+    # Unfortunately, a weak function may be overwritten by another
+    # function of the same name, making all these offsets incorrect.
+    # To be safe, we simply print a warning and bail.
+    if (defined $weak{$ref_func}) {
+	print STDERR
+	    "$inputfile: WARNING: referencing weak function" .
+	    " $ref_func for mcount\n";
+	return;
+    }
+
+    # is this function static? If so, note this fact.
+    if (defined $locals{$ref_func}) {
+	$convert{$ref_func} = 1;
+    }
+
+    # Loop through all the mcount caller offsets and print a reference
+    # to the caller based from the ref_func.
+    for (my $i=0; $i <= $#offsets; $i++) {
+	if (!$opened) {
+	    open(FILE, ">$mcount_s") || die "can't create $mcount_s\n";
+	    $opened = 1;
+	    print FILE "\t.section $mcount_section,\"a\",\@progbits\n";
+	}
+	printf FILE "\t%s %s + %d\n", $type, $ref_func, $offsets[$i] - $offset;
+    }
+}
+
 #
 # Step 2: find the sections and mcount call sites
 #
 open(IN, "$objdump -dr $inputfile|") || die "error running $objdump";
 
+my $text;
+
 while (<IN>) {
     # is it a section?
     if (/$section_regex/) {
 	$read_function = 1;
+	# print out any recorded offsets
+	update_funcs() if ($text_found);
+
+	# reset all markers and arrays
 	$text_found = 0;
+	undef($ref_func);
+	undef(@offsets);
+
     # section found, now is this a start of a function?
     } elsif ($read_function && /$function_regex/) {
-	$read_function = 0;
 	$text_found = 1;
-	$text = $1;
-	# is this function static? If so, note this fact.
-	if (defined $locals{$text}) {
-	    $convert{$text} = 1;
-	}
-    # is this a call site to mcount? If so, print the offset from the section
-    } elsif ($text_found && /$mcount_regex/) {
-	if (!$opened) {
-	    open(FILE, ">$mcount_s") || die "can't create $mcount_s\n";
-	    $opened = 1;
-	    print FILE "\t.section $mcount_section,\"a\",\@progbits\n";
+	$offset = hex $1;
+	$text = $2;
+
+	# if this is either a local function or a weak function
+	# keep looking for functions that are global that
+	# we can use safely.
+	if (!defined($locals{$text}) && !defined($weak{$text})) {
+	    $ref_func = $text;
+	    $read_function = 0;
+	} else {
+	    # if we already have a function, and this is weak, skip it
+	    if (!defined($ref_func) || !defined($weak{$text})) {
+		$ref_func = $text;
+	    }
 	}
-	print FILE "\t$type $text + 0x$1\n";
+    }
+
+    # is this a call site to mcount? If so, record it to print later
+    if ($text_found && /$mcount_regex/) {
+	$offsets[$#offsets + 1] = hex $1;
     }
 }
 
+# dump out anymore offsets that may have been found
+update_funcs() if ($text_found);
+
 # If we did not find any mcount callers, we are done (do nothing).
 if (!$opened) {
     exit(0);
