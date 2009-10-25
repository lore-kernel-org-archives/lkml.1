Return-Path: <linux-kernel-owner+w=401wt.eu-S1753450AbZJYMC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbZJYMC7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 08:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbZJYMC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 08:02:59 -0400
Received: from mail-pw0-f42.google.com ([209.85.160.42]:59197 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835AbZJYMC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 08:02:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:x-operating-system:user-agent;
        b=Z6yg3s9nXsuOJGTzFKIFK/jVQ1JeqADA29P/zMa7ctnW/QVngT+OMU+hxgEI9yAF26
         9KDHCrPAlKUZS2f+D45Zd7UWDBMZ6HGJ9fTqInPBTd1vN8PLgqBa5WMuyQbUJJqVvOrD
         ZuPISsDBE9qTk/zim7XpfuRHFsf0w3/mvpw0w=
Date: Sun, 25 Oct 2009 20:02:50 +0800
From: Li Hong <lihong.hi@gmail.com>
To: Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH RFC] tracing: Improve recordmcount.pl in a simpler and
	cleaner way
Message-ID: <20091025120250.GA9845@uhli>
Mail-Followup-To: Steven Rostedt <srostedt@redhat.com>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
X-Operating-System: Linux uhli 2.6.28-11-generic 
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Now the implementation of recordmcount.pl have several problems:

  * This tool is not implemented as the documentation (the block comment at
    the head of the file) says. It will not always choose the first function
    as offset reference. e.g.

      .section ".sched.text", "ax"
            [...]
      func1:
            [...]
            call mcount  (offset: 0x10)
            [...]
            ret
      .globl fun2
      func2:             (offset: 0x20)
            [...]
            [...]
            ret
      func3:
            [...]
            call mcount (offset: 0x30)
            [...]

    First we will select func1, but we forget to set $read_function = 0 here
    (Line 410 - 423). When we meet func2, we will replace $ref_func to func2
    and finally set $read_function = 0 at Line 412.

    Luckily, this 'wrongly' implementation accidently makes the result same to
    the documentation. Because we use $ref_func + (call offset - ref_func offset)
    in tmp.s, here any ref func can give a right address finally.

  * The algorithm and implementation is a little complex. As above shows, we
    can use any function in this section as a reference, not just the first
    one. This will simplify the code much. A reasonable method is: choose the
    first global function we meet as a reference. If there is none, choose the
    first local one.

  * mcount section check is wrong. If the mcount section is not the first
    section, we will never find it.

  * Find objcopy version is wrong. If objcopy has a version but is less than
    2.17, we will still disable local function reference. $found_version can't
    be used to determine the show of the warning message.

  * Argment number check is wrong. Should be 10.

  * .L check path is partial, not on all run path.

  * If there is no global and local symbols, return early. If there are only
    locals and can't use local reference, return early.

  * input file can be absolute path?

  * Some documenation and in-line comment is wrong.

  * Code deals with weak functions will not be called. Remove it.

To resolve all these problems, I rewrite some part of the code and make the
algorithm and code simpler and cleaner.

Two pending issues:

  * I ignore all the weak functions now. Is that a big impact?

  * I just make some simple tests. Steven, are there some ways to do a full
    and strong verification? Also I will very appreciate if some guys can help
    me do some tests on other arches except x86.

As the change is large, except the patch, I also put the new version file in
the attchment.

Signed-off-by: Li Hong <lihong.hi@gmail.com>
---
 scripts/recordmcount.pl |  487 ++++++++++++++++++++++-------------------------
 1 files changed, 224 insertions(+), 263 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 090d300..1eeff67 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -1,82 +1,99 @@
 #!/usr/bin/perl -w
 # (c) 2008, Steven Rostedt <srostedt@redhat.com>
+# (C) 2009, Li Hong <lihong.hi@gmail.com>
+#
 # Licensed under the terms of the GNU GPL License version 2
 #
 # recordmcount.pl - makes a section called __mcount_loc that holds
 #                   all the offsets to the calls to mcount.
 #
 #
-# What we want to end up with is a section in vmlinux called
-# __mcount_loc that contains a list of pointers to all the
-# call sites in the kernel that call mcount. Later on boot up, the kernel
-# will read this list, save the locations and turn them into nops.
-# When tracing or profiling is later enabled, these locations will then
-# be converted back to pointers to some function.
+# What we want to end up with this is a data area in .init.data in vmlinux 
+# that contains a list of pointers to all the call sites in the kernel that 
+# call mcount. Later on boot up, the kernel will read this list, save the 
+# locations and turn them into nops. When tracing or profiling is later 
+# enabled, these locations will then be converted back to pointers to 
+# some function.
 #
 # This is no easy feat. This script is called just after the original
 # object is compiled and before it is linked.
 #
-# The references to the call sites are offsets from the section of text
-# that the call site is in. Hence, all functions in a section that
-# has a call site to mcount, will have the offset from the beginning of
-# the section and not the beginning of the function.
+# When parse this object file using 'objdump', the references to the call 
+# sites are offsets from the section that the call site is in. Hence, all 
+# functions in a section that  has a call site to mcount, will have the 
+# offset from the beginning of the section and not the beginning of the 
+# function.
+#
+# But where this section will reside finally in vmlinx is undetermined at 
+# this point. So we can't use this kind of offsets to record the final
+# address of this call site.
 #
-# The trick is to find a way to record the beginning of the section.
-# The way we do this is to look at the first function in the section
-# which will also be the location of that section after final link.
+# The trick is to change the call offset refering the start of a section to
+# refering a function symbol in this section. During the link step, 'ld' will
+# compute the final address according to the information we record.
+# 
 # e.g.
 #
 #  .section ".sched.text", "ax"
-#  .globl my_func
-#  my_func:
 #        [...]
-#        call mcount  (offset: 0x5)
+#  func1:
+#        [...]
+#        call mcount  (offset: 0x10)
 #        [...]
 #        ret
-#  other_func:
+#  .globl fun2
+#  func2:             (offset: 0x20)
 #        [...]
-#        call mcount (offset: 0x1b)
+#        [...]
+#        ret
+#  func3:
+#        [...]
+#        call mcount (offset: 0x30)
 #        [...]
 #
 # Both relocation offsets for the mcounts in the above example will be
-# offset from .sched.text. If we make another file called tmp.s with:
+# offset from .sched.text. If we choose global symbol func2 as a reference and
+# make another file called tmp.s with the new offsets:
 #
 #  .section __mcount_loc
-#  .quad  my_func + 0x5
-#  .quad  my_func + 0x1b
+#  .quad  func2 - 0x10
+#  .quad  func2 + 0x10
 #
-# We can then compile this tmp.s into tmp.o, and link it to the original
+# We can then compile this tmp.s into tmp.o, and link it back to the original
 # object.
 #
-# But this gets hard if my_func is not globl (a static function).
-# In such a case we have:
+# In our algorithm, we will choose the first global function we meet in this 
+# section as the reference. But this gets hard if there is no global functions 
+# in this section. In such a case we have to select a local one. E.g. func1:
 #
 #  .section ".sched.text", "ax"
-#  my_func:
+#  func1:
 #        [...]
-#        call mcount  (offset: 0x5)
+#        call mcount  (offset: 0x10)
 #        [...]
 #        ret
-#  other_func:
+#  func2:
 #        [...]
-#        call mcount (offset: 0x1b)
+#        call mcount (offset: 0x20)
 #        [...]
+#  .section "other.section"
 #
 # If we make the tmp.s the same as above, when we link together with
-# the original object, we will end up with two symbols for my_func:
+# the original object, we will end up with two symbols for func1:
 # one local, one global.  After final compile, we will end up with
-# an undefined reference to my_func.
+# an undefined reference to func1 or a wrong reference to another global
+# func1 in other files.
 #
 # Since local objects can reference local variables, we need to find
 # a way to make tmp.o reference the local objects of the original object
-# file after it is linked together. To do this, we convert the my_func
+# file after it is linked together. To do this, we convert func1
 # into a global symbol before linking tmp.o. Then after we link tmp.o
-# we will only have a single symbol for my_func that is global.
-# We can convert my_func back into a local symbol and we are done.
+# we will only have a single symbol for func1 that is global.
+# We can convert func1 back into a local symbol and we are done.
 #
 # Here are the steps we take:
 #
-# 1) Record all the local symbols by using 'nm'
+# 1) Record all the global and local symbols by using 'nm'
 # 2) Use objdump to find all the call site offsets and sections for
 #    mcount.
 # 3) Compile the list into its own object.
@@ -86,7 +103,6 @@
 # 6) Link together this new object with the list object.
 # 7) Convert the local functions back to local symbols and rename
 #    the result as the original object.
-#    End.
 # 8) Link the object with the list object.
 # 9) Move the result back to the original object.
 #    End.
@@ -94,56 +110,139 @@
 
 use strict;
 
-my $P = $0;
-$P =~ s@.*/@@g;
-
+my $P = $0; $P =~ s@.*/@@g;  
 my $V = '0.1';
-
-if ($#ARGV < 7) {
-	print "usage: $P arch bits objdump objcopy cc ld nm rm mv is_module inputfile\n";
-	print "version: $V\n";
-	exit(1);
-}
-
+my $opened = 0;
 my ($arch, $bits, $objdump, $objcopy, $cc,
     $ld, $nm, $rm, $mv, $is_module, $inputfile) = @ARGV;
+my ($dirname, $filename, $prefix, $ext, $mcount_s, $mcount_o);
 
-# This file refers to mcount and shouldn't be ftraced, so lets' ignore it
-if ($inputfile eq "kernel/trace/ftrace.o") {
-    exit(0);
-}
-
-# Acceptable sections to record.
-my %text_sections = (
-     ".text" => 1,
-     ".sched.text" => 1,
-     ".spinlock.text" => 1,
-     ".irqentry.text" => 1,
-);
-
-$objdump = "objdump" if ((length $objdump) == 0);
-$objcopy = "objcopy" if ((length $objcopy) == 0);
-$cc = "gcc" if ((length $cc) == 0);
-$ld = "ld" if ((length $ld) == 0);
-$nm = "nm" if ((length $nm) == 0);
-$rm = "rm" if ((length $rm) == 0);
-$mv = "mv" if ((length $mv) == 0);
-
-#print STDERR "running: $P '$arch' '$objdump' '$objcopy' '$cc' '$ld' " .
-#    "'$nm' '$rm' '$mv' '$inputfile'\n";
-
+my %globals;		# List of global functions
 my %locals;		# List of local (static) functions
-my %weak;		# List of weak functions
 my %convert;		# List of local functions used that needs conversion
 
-my $type;
-my $nm_regex;		# Find the local functions (return function)
+# The following three variables are only valid in one section and will 
+# re-initialized in a new section.
+my @offsets;		# Array of offsets of mcount callers
+my $ref_func;		# Reference function used for offsets
+my $offset;		# Offset of ref_func to section beginning
+
+my $global_regex;	# Match a global function (return function)
+my $local_regex;	# Match a local function (return function)
 my $section_regex;	# Find the start of a section
-my $function_regex;	# Find the name of a function
-			#    (return offset and func name)
+my $function_regex;	# Find the name of a function (return offset and function)
 my $mcount_regex;	# Find the call site to mcount (return offset)
+
+my $can_use_local = 0; 	# If we can use local function references
 my $alignment;		# The .align value to use for $mcount_section
+my $type;		# The type to use for $mcount_section
 my $section_type;	# Section header plus possible alignment command
+my $mcount_section;	# Mcount section name 
+my %text_sections = (	# Acceptable sections to record.
+    ".text" => 1,
+    ".sched.text" => 1,
+    ".spinlock.text" => 1,
+    ".irqentry.text" => 1,
+);
+
+$global_regex = "^[0-9a-fA-F]+\\s+T\\s+(\\S+)";
+$local_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\S+)";
+$section_regex = "Disassembly of section\\s+(\\S+):";
+$function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
+$mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount\$";
+$mcount_section = "__mcount_loc";
+$section_type = '@progbits';
+$type = ".long";
+
+##
+# check_objcopy - whether objcopy supports --globalize-symbols
+#
+#  --globalize-symbols came out in 2.17, we must test the version
+#  of objcopy, and if it is less than 2.17, then we can not
+#  record local functions.
+sub check_objcopy
+{
+    open (IN, "$objcopy --version |") or die "error running $objcopy";
+    while (<IN>) {
+        if (/objcopy.*\s(\d+)\.(\d+)/) {
+            $can_use_local = 1 if ($1 > 2 || ($1 == 2 && $2 >= 17)); 
+            last;
+        }
+    }
+    close (IN);
+
+    print STDERR "WARNING: could not find objcopy version or version is less than 2.17.\n" .
+	"\tLocal function references is disabled.\n" if !$can_use_local; 
+}
+
+##
+# update_funcs - print out the current mcount callers
+#
+#  Loop through all the mcount caller offsets and print a reference
+#  to the caller based from the ref_func.
+#
+sub update_funcs
+{
+    if ($ref_func && @offsets) {
+        return if $locals{$ref_func} && !$can_use_local;
+        $convert{$ref_func} = 1 if $locals{$ref_func};    
+	
+        if (!$opened) {
+	    open(FILE, ">$mcount_s") or die "can't create $mcount_s\n";
+	    $opened = 1;
+	    print FILE "\t.section $mcount_section,\"a\",$section_type\n";
+	    print FILE "\t.align $alignment\n" if (defined($alignment));
+	}
+
+        foreach (@offsets) {
+	    printf FILE "\t%s %s + %d\n", $type, $ref_func, $_ - $offset;
+        }
+    }
+}
+
+
+##
+# Real work starts from here
+#
+
+if ($#ARGV != 10) {
+    print "usage: $P arch bits objdump objcopy cc ld nm rm mv is_module inputfile\n";
+    print "version: $V\n";
+    exit(1);
+}
+
+# Some arguments can be empty string
+$objdump = "objdump" unless $objdump;
+$objcopy = "objcopy" unless $objcopy;
+$cc = "gcc" unless $cc;
+$ld = "ld" unless $ld;
+$nm = "nm" unless $nm;
+$rm = "rm" unless $rm;
+$mv = "mv" unless $mv;
+
+# This file refers to mcount and shouldn't be ftraced, so let's ignore it
+exit(0) if ($inputfile =~ "kernel/trace/ftrace.o"); 
+
+check_objcopy();
+
+if ($inputfile =~ m,^(.*)/([^/]*)$,) {
+    $dirname = $1;
+    $filename = $2;
+} else {
+    $dirname = ".";
+    $filename = $inputfile;
+}
+
+if ($filename =~ m,^(.*)(\.\S),) {
+    $prefix = $1;
+    $ext = $2;
+} else {
+    $prefix = $filename;
+    $ext = "";
+}
+
+$mcount_s = $dirname . "/.tmp_mc_" . $prefix . ".s";
+$mcount_o = $dirname . "/.tmp_mc_" . $prefix . ".o";
 
 if ($arch eq "x86") {
     if ($bits == 64) {
@@ -153,17 +252,6 @@ if ($arch eq "x86") {
     }
 }
 
-#
-# We base the defaults off of i386, the other archs may
-# feel free to change them in the below if statements.
-#
-$nm_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\S+)";
-$section_regex = "Disassembly of section\\s+(\\S+):";
-$function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
-$mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount\$";
-$section_type = '@progbits';
-$type = ".long";
-
 if ($arch eq "x86_64") {
     $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount([+-]0x[0-9a-zA-Z]+)?\$";
     $type = ".quad";
@@ -206,7 +294,8 @@ if ($arch eq "x86_64") {
     $cc .= " -m32";
 
 } elsif ($arch eq "powerpc") {
-    $nm_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\.?\\S+)";
+    $global_regex = "^[0-9a-fA-F]+\\s+T\\s+(\\.?\\S+)";
+    $local_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\.?\\S+)";
     $function_regex = "^([0-9a-fA-F]+)\\s+<(\\.?.*?)>:";
     $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s\\.?_mcount\$";
 
@@ -249,201 +338,75 @@ if ($arch eq "x86_64") {
     die "Arch $arch is not supported with CONFIG_FTRACE_MCOUNT_RECORD";
 }
 
-my $text_found = 0;
-my $read_function = 0;
-my $opened = 0;
-my $mcount_section = "__mcount_loc";
-
-my $dirname;
-my $filename;
-my $prefix;
-my $ext;
-
-if ($inputfile =~ m,^(.*)/([^/]*)$,) {
-    $dirname = $1;
-    $filename = $2;
-} else {
-    $dirname = ".";
-    $filename = $inputfile;
-}
-
-if ($filename =~ m,^(.*)(\.\S),) {
-    $prefix = $1;
-    $ext = $2;
-} else {
-    $prefix = $filename;
-    $ext = "";
-}
-
-my $mcount_s = $dirname . "/.tmp_mc_" . $prefix . ".s";
-my $mcount_o = $dirname . "/.tmp_mc_" . $prefix . ".o";
-
 #
-# --globalize-symbols came out in 2.17, we must test the version
-# of objcopy, and if it is less than 2.17, then we can not
-# record local functions.
-my $use_locals = 01;
-my $local_warn_once = 0;
-my $found_version = 0;
-
-open (IN, "$objcopy --version |") || die "error running $objcopy";
-while (<IN>) {
-    if (/objcopy.*\s(\d+)\.(\d+)/) {
-	my $major = $1;
-	my $minor = $2;
-
-	$found_version = 1;
-	if ($major < 2 ||
-	    ($major == 2 && $minor < 17)) {
-	    $use_locals = 0;
-	}
-	last;
-    }
-}
-close (IN);
-
-if (!$found_version) {
-    print STDERR "WARNING: could not find objcopy version.\n" .
-	"\tDisabling local function references.\n";
-}
-
+# Step 1: Find all global and local fuctions. "T" is global and "t" is local
 #
-# Step 1: find all the local (static functions) and weak symbols.
-#        't' is local, 'w/W' is weak (we never use a weak function)
-#
-open (IN, "$nm $inputfile|") || die "error running $nm";
+open (IN, "$nm $inputfile|") or die "error running $nm";
 while (<IN>) {
-    if (/$nm_regex/) {
+    if (/$global_regex/) {
+	$globals{$1} = 1;
+    } elsif (/$local_regex/) {
 	$locals{$1} = 1;
-    } elsif (/^[0-9a-fA-F]+\s+([wW])\s+(\S+)/) {
-	$weak{$2} = $1;
     }
 }
 close(IN);
 
-my @offsets;		# Array of offsets of mcount callers
-my $ref_func;		# reference function to use for offsets
-my $offset = 0;		# offset of ref_func to section beginning
+# Exit early if no work to do 
+exit(0) unless (%globals or (%locals and $can_use_local)); 
 
-##
-# update_funcs - print out the current mcount callers
 #
-#  Go through the list of offsets to callers and write them to
-#  the output file in a format that can be read by an assembler.
+# Step 2: For each section we concern, record all mcount call information
 #
-sub update_funcs
-{
-    return if ($#offsets < 0);
-
-    defined($ref_func) || die "No function to reference";
-
-    # A section only had a weak function, to represent it.
-    # Unfortunately, a weak function may be overwritten by another
-    # function of the same name, making all these offsets incorrect.
-    # To be safe, we simply print a warning and bail.
-    if (defined $weak{$ref_func}) {
-	print STDERR
-	    "$inputfile: WARNING: referencing weak function" .
-	    " $ref_func for mcount\n";
-	return;
-    }
-
-    # is this function static? If so, note this fact.
-    if (defined $locals{$ref_func}) {
-
-	# only use locals if objcopy supports globalize-symbols
-	if (!$use_locals) {
-	    return;
-	}
-	$convert{$ref_func} = 1;
-    }
-
-    # Loop through all the mcount caller offsets and print a reference
-    # to the caller based from the ref_func.
-    for (my $i=0; $i <= $#offsets; $i++) {
-	if (!$opened) {
-	    open(FILE, ">$mcount_s") || die "can't create $mcount_s\n";
-	    $opened = 1;
-	    print FILE "\t.section $mcount_section,\"a\",$section_type\n";
-	    print FILE "\t.align $alignment\n" if (defined($alignment));
-	}
-	printf FILE "\t%s %s + %d\n", $type, $ref_func, $offsets[$i] - $offset;
-    }
-}
-
-#
-# Step 2: find the sections and mcount call sites
-#
-open(IN, "$objdump -hdr $inputfile|") || die "error running $objdump";
-
-my $text;
-
-my $read_headers = 1;
+open(IN, "$objdump -hdr $inputfile|") or die "error running $objdump";
 
+my $valid_section = 0;
 while (<IN>) {
-    # is it a section?
-    if (/$section_regex/) {
-	$read_headers = 0;
-
-	# Only record text sections that we know are safe
-	if (defined($text_sections{$1})) {
-	    $read_function = 1;
-	} else {
-	    $read_function = 0;
-	}
-	# print out any recorded offsets
-	update_funcs() if (defined($ref_func));
-
-	# reset all markers and arrays
-	$text_found = 0;
-	undef($ref_func);
-	undef(@offsets);
-
-    # section found, now is this a start of a function?
-    } elsif ($read_function && /$function_regex/) {
-	$text_found = 1;
-	$text = $2;
-
-	# if this is either a local function or a weak function
-	# keep looking for functions that are global that
-	# we can use safely.
-	if (!defined($locals{$text}) && !defined($weak{$text})) {
-	    $ref_func = $text;
-	    $read_function = 0;
-	    $offset = hex $1;
-	} else {
-	    # if we already have a function, and this is weak, skip it
-	    if (!defined($ref_func) && !defined($weak{$text}) &&
-		 # PPC64 can have symbols that start with .L and
-		 # gcc considers these special. Don't use them!
-		 $text !~ /^\.L/) {
-		$ref_func = $text;
-		$offset = hex $1;
-	    }
-	}
-    } elsif ($read_headers && /$mcount_section/) {
-	#
-	# Somehow the make process can execute this script on an
-	# object twice. If it does, we would duplicate the mcount
-	# section and it will cause the function tracer self test
-	# to fail. Check if the mcount section exists, and if it does,
-	# warn and exit.
-	#
+    # Somehow the make process can execute this script on an object twice. 
+    # If it does, we would duplicate the mcount section and it will cause the 
+    # function tracer self test to fail. Check if the mcount section exists, 
+    # and if it does, warn and exit.
+    if (/$mcount_section/) {
 	print STDERR "ERROR: $mcount_section already in $inputfile\n" .
 	    "\tThis may be an indication that your build is corrupted.\n" .
 	    "\tDelete $inputfile and try again. If the same object file\n" .
 	    "\tstill causes an issue, then disable CONFIG_DYNAMIC_FTRACE.\n";
+        close(FILE) and `$rm $mcount_s` if $opened;
 	exit(-1);
     }
+    
+    # the start of a new section 
+    if (/$section_regex/) {
+        # write out the offsets in previous section if there are some
+        update_funcs();
 
-    # is this a call site to mcount? If so, record it to print later
-    if ($text_found && /$mcount_regex/) {
+	# reset for a new section 
+	undef($ref_func);
+	undef(@offsets) ;
+        $valid_section = 0;
+
+        # this is a section we concern?
+        $valid_section = 1 if $text_sections{$1}; 
+    } 
+
+    # record a ref_function and this offset
+    if ($valid_section && /$function_regex/) {
+        # PPC64 can have symbols that start with .L and
+        # gcc considers these special. Don't use them!
+	if ($2 !~ /^\.L/ 
+            && ((!$ref_func && ($globals{$2} || $locals{$2})) # set a new ref_func
+            || ($ref_func && $locals{$ref_func} && $globals{$2}))) { # replace a local
+            $ref_func = $2;
+            $offset = hex $1;
+        }
+    } 
+
+    # record a mcount call site
+    if ($valid_section && /$mcount_regex/) {
 	$offsets[$#offsets + 1] = hex $1;
     }
 }
 
-# dump out anymore offsets that may have been found
-update_funcs() if (defined($ref_func));
+update_funcs();
 
 # If we did not find any mcount callers, we are done (do nothing).
 if (!$opened) {
@@ -457,18 +420,16 @@ close(FILE);
 #
 `$cc -o $mcount_o -c $mcount_s`;
 
-my @converts = keys %convert;
-
 #
 # Step 4: Do we have sections that started with local functions?
 #
-if ($#converts >= 0) {
+if (keys %convert) {
     my $globallist = "";
     my $locallist = "";
 
-    foreach my $con (@converts) {
-	$globallist .= " --globalize-symbol $con";
-	$locallist .= " --localize-symbol $con";
+    foreach (keys %convert) {
+	$globallist .= " --globalize-symbol $_";
+	$locallist .= " --localize-symbol $_";
     }
 
     my $globalobj = $dirname . "/.tmp_gl_" . $filename;
-- 
1.6.0.4


--liOOAslEiF7prFVr
Content-Type: text/x-perl; charset=us-ascii
Content-Disposition: attachment; filename="recordmcount.pl"

#!/usr/bin/perl -w
# (c) 2008, Steven Rostedt <srostedt@redhat.com>
# (C) 2009, Li Hong <lihong.hi@gmail.com>
#
# Licensed under the terms of the GNU GPL License version 2
#
# recordmcount.pl - makes a section called __mcount_loc that holds
#                   all the offsets to the calls to mcount.
#
#
# What we want to end up with this is a data area in .init.data in vmlinux 
# that contains a list of pointers to all the call sites in the kernel that 
# call mcount. Later on boot up, the kernel will read this list, save the 
# locations and turn them into nops. When tracing or profiling is later 
# enabled, these locations will then be converted back to pointers to 
# some function.
#
# This is no easy feat. This script is called just after the original
# object is compiled and before it is linked.
#
# When parse this object file using 'objdump', the references to the call 
# sites are offsets from the section that the call site is in. Hence, all 
# functions in a section that  has a call site to mcount, will have the 
# offset from the beginning of the section and not the beginning of the 
# function.
#
# But where this section will reside finally in vmlinx is undetermined at 
# this point. So we can't use this kind of offsets to record the final
# address of this call site.
#
# The trick is to change the call offset refering the start of a section to
# refering a function symbol in this section. During the link step, 'ld' will
# compute the final address according to the information we record.
# 
# e.g.
#
#  .section ".sched.text", "ax"
#        [...]
#  func1:
#        [...]
#        call mcount  (offset: 0x10)
#        [...]
#        ret
#  .globl fun2
#  func2:             (offset: 0x20)
#        [...]
#        [...]
#        ret
#  func3:
#        [...]
#        call mcount (offset: 0x30)
#        [...]
#
# Both relocation offsets for the mcounts in the above example will be
# offset from .sched.text. If we choose global symbol func2 as a reference and
# make another file called tmp.s with the new offsets:
#
#  .section __mcount_loc
#  .quad  func2 - 0x10
#  .quad  func2 + 0x10
#
# We can then compile this tmp.s into tmp.o, and link it back to the original
# object.
#
# In our algorithm, we will choose the first global function we meet in this 
# section as the reference. But this gets hard if there is no global functions 
# in this section. In such a case we have to select a local one. E.g. func1:
#
#  .section ".sched.text", "ax"
#  func1:
#        [...]
#        call mcount  (offset: 0x10)
#        [...]
#        ret
#  func2:
#        [...]
#        call mcount (offset: 0x20)
#        [...]
#  .section "other.section"
#
# If we make the tmp.s the same as above, when we link together with
# the original object, we will end up with two symbols for func1:
# one local, one global.  After final compile, we will end up with
# an undefined reference to func1 or a wrong reference to another global
# func1 in other files.
#
# Since local objects can reference local variables, we need to find
# a way to make tmp.o reference the local objects of the original object
# file after it is linked together. To do this, we convert func1
# into a global symbol before linking tmp.o. Then after we link tmp.o
# we will only have a single symbol for func1 that is global.
# We can convert func1 back into a local symbol and we are done.
#
# Here are the steps we take:
#
# 1) Record all the global and local symbols by using 'nm'
# 2) Use objdump to find all the call site offsets and sections for
#    mcount.
# 3) Compile the list into its own object.
# 4) Do we have to deal with local functions? If not, go to step 8.
# 5) Make an object that converts these local functions to global symbols
#    with objcopy.
# 6) Link together this new object with the list object.
# 7) Convert the local functions back to local symbols and rename
#    the result as the original object.
# 8) Link the object with the list object.
# 9) Move the result back to the original object.
#    End.
#

use strict;

my $P = $0; $P =~ s@.*/@@g;  
my $V = '0.1';
my $opened = 0;
my ($arch, $bits, $objdump, $objcopy, $cc,
    $ld, $nm, $rm, $mv, $is_module, $inputfile) = @ARGV;
my ($dirname, $filename, $prefix, $ext, $mcount_s, $mcount_o);

my %globals;		# List of global functions
my %locals;		# List of local (static) functions
my %convert;		# List of local functions used that needs conversion

# The following three variables are only valid in one section and will 
# re-initialized in a new section.
my @offsets;		# Array of offsets of mcount callers
my $ref_func;		# Reference function used for offsets
my $offset;		# Offset of ref_func to section beginning

my $global_regex;	# Match a global function (return function)
my $local_regex;	# Match a local function (return function)
my $section_regex;	# Find the start of a section
my $function_regex;	# Find the name of a function (return offset and function)
my $mcount_regex;	# Find the call site to mcount (return offset)

my $can_use_local = 0; 	# If we can use local function references
my $alignment;		# The .align value to use for $mcount_section
my $type;		# The type to use for $mcount_section
my $section_type;	# Section header plus possible alignment command
my $mcount_section;	# Mcount section name 
my %text_sections = (	# Acceptable sections to record.
    ".text" => 1,
    ".sched.text" => 1,
    ".spinlock.text" => 1,
    ".irqentry.text" => 1,
);

$global_regex = "^[0-9a-fA-F]+\\s+T\\s+(\\S+)";
$local_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\S+)";
$section_regex = "Disassembly of section\\s+(\\S+):";
$function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
$mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount\$";
$mcount_section = "__mcount_loc";
$section_type = '@progbits';
$type = ".long";

##
# check_objcopy - whether objcopy supports --globalize-symbols
#
#  --globalize-symbols came out in 2.17, we must test the version
#  of objcopy, and if it is less than 2.17, then we can not
#  record local functions.
sub check_objcopy
{
    open (IN, "$objcopy --version |") or die "error running $objcopy";
    while (<IN>) {
        if (/objcopy.*\s(\d+)\.(\d+)/) {
            $can_use_local = 1 if ($1 > 2 || ($1 == 2 && $2 >= 17)); 
            last;
        }
    }
    close (IN);

    print STDERR "WARNING: could not find objcopy version or version is less than 2.17.\n" .
	"\tLocal function references is disabled.\n" if !$can_use_local; 
}

##
# update_funcs - print out the current mcount callers
#
#  Loop through all the mcount caller offsets and print a reference
#  to the caller based from the ref_func.
#
sub update_funcs
{
    if ($ref_func && @offsets) {
        return if $locals{$ref_func} && !$can_use_local;
        $convert{$ref_func} = 1 if $locals{$ref_func};    
	
        if (!$opened) {
	    open(FILE, ">$mcount_s") or die "can't create $mcount_s\n";
	    $opened = 1;
	    print FILE "\t.section $mcount_section,\"a\",$section_type\n";
	    print FILE "\t.align $alignment\n" if (defined($alignment));
	}

        foreach (@offsets) {
	    printf FILE "\t%s %s + %d\n", $type, $ref_func, $_ - $offset;
        }
    }
}


##
# Real work starts from here
#

if ($#ARGV != 10) {
    print "usage: $P arch bits objdump objcopy cc ld nm rm mv is_module inputfile\n";
    print "version: $V\n";
    exit(1);
}

# Some arguments can be empty string
$objdump = "objdump" unless $objdump;
$objcopy = "objcopy" unless $objcopy;
$cc = "gcc" unless $cc;
$ld = "ld" unless $ld;
$nm = "nm" unless $nm;
$rm = "rm" unless $rm;
$mv = "mv" unless $mv;

# This file refers to mcount and shouldn't be ftraced, so let's ignore it
exit(0) if ($inputfile =~ "kernel/trace/ftrace.o"); 

check_objcopy();

if ($inputfile =~ m,^(.*)/([^/]*)$,) {
    $dirname = $1;
    $filename = $2;
} else {
    $dirname = ".";
    $filename = $inputfile;
}

if ($filename =~ m,^(.*)(\.\S),) {
    $prefix = $1;
    $ext = $2;
} else {
    $prefix = $filename;
    $ext = "";
}

$mcount_s = $dirname . "/.tmp_mc_" . $prefix . ".s";
$mcount_o = $dirname . "/.tmp_mc_" . $prefix . ".o";

if ($arch eq "x86") {
    if ($bits == 64) {
	$arch = "x86_64";
    } else {
	$arch = "i386";
    }
}

if ($arch eq "x86_64") {
    $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount([+-]0x[0-9a-zA-Z]+)?\$";
    $type = ".quad";
    $alignment = 8;

    # force flags for this arch
    $ld .= " -m elf_x86_64";
    $objdump .= " -M x86-64";
    $objcopy .= " -O elf64-x86-64";
    $cc .= " -m64";

} elsif ($arch eq "i386") {
    $alignment = 4;

    # force flags for this arch
    $ld .= " -m elf_i386";
    $objdump .= " -M i386";
    $objcopy .= " -O elf32-i386";
    $cc .= " -m32";

} elsif ($arch eq "s390" && $bits == 32) {
    $mcount_regex = "^\\s*([0-9a-fA-F]+):\\s*R_390_32\\s+_mcount\$";
    $alignment = 4;
    $ld .= " -m elf_s390";
    $cc .= " -m31";

} elsif ($arch eq "s390" && $bits == 64) {
    $mcount_regex = "^\\s*([0-9a-fA-F]+):\\s*R_390_(PC|PLT)32DBL\\s+_mcount\\+0x2\$";
    $alignment = 8;
    $type = ".quad";
    $ld .= " -m elf64_s390";
    $cc .= " -m64";

} elsif ($arch eq "sh") {
    $alignment = 2;

    # force flags for this arch
    $ld .= " -m shlelf_linux";
    $objcopy .= " -O elf32-sh-linux";
    $cc .= " -m32";

} elsif ($arch eq "powerpc") {
    $global_regex = "^[0-9a-fA-F]+\\s+T\\s+(\\.?\\S+)";
    $local_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\.?\\S+)";
    $function_regex = "^([0-9a-fA-F]+)\\s+<(\\.?.*?)>:";
    $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s\\.?_mcount\$";

    if ($bits == 64) {
	$type = ".quad";
    }

} elsif ($arch eq "arm") {
    $alignment = 2;
    $section_type = '%progbits';

} elsif ($arch eq "ia64") {
    $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s_mcount\$";
    $type = "data8";

    if ($is_module eq "0") {
        $cc .= " -mconstant-gp";
    }
} elsif ($arch eq "sparc64") {
    # In the objdump output there are giblets like:
    # 0000000000000000 <igmp_net_exit-0x18>:
    # As there's some data blobs that get emitted into the
    # text section before the first instructions and the first
    # real symbols.  We don't want to match that, so to combat
    # this we use '\w' so we'll match just plain symbol names,
    # and not those that also include hex offsets inside of the
    # '<>' brackets.  Actually the generic function_regex setting
    # could safely use this too.
    $function_regex = "^([0-9a-fA-F]+)\\s+<(\\w*?)>:";

    # Sparc64 calls '_mcount' instead of plain 'mcount'.
    $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s_mcount\$";

    $alignment = 8;
    $type = ".xword";
    $ld .= " -m elf64_sparc";
    $cc .= " -m64";
    $objcopy .= " -O elf64-sparc";
} else {
    die "Arch $arch is not supported with CONFIG_FTRACE_MCOUNT_RECORD";
}

#
# Step 1: Find all global and local fuctions. "T" is global and "t" is local
#
open (IN, "$nm $inputfile|") or die "error running $nm";
while (<IN>) {
    if (/$global_regex/) {
	$globals{$1} = 1;
    } elsif (/$local_regex/) {
	$locals{$1} = 1;
    }
}
close(IN);

# Exit early if no work to do 
exit(0) unless (%globals or (%locals and $can_use_local)); 

#
# Step 2: For each section we concern, record all mcount call information
#
open(IN, "$objdump -hdr $inputfile|") or die "error running $objdump";

my $valid_section = 0;
while (<IN>) {
    # Somehow the make process can execute this script on an object twice. 
    # If it does, we would duplicate the mcount section and it will cause the 
    # function tracer self test to fail. Check if the mcount section exists, 
    # and if it does, warn and exit.
    if (/$mcount_section/) {
	print STDERR "ERROR: $mcount_section already in $inputfile\n" .
	    "\tThis may be an indication that your build is corrupted.\n" .
	    "\tDelete $inputfile and try again. If the same object file\n" .
	    "\tstill causes an issue, then disable CONFIG_DYNAMIC_FTRACE.\n";
        close(FILE) and `$rm $mcount_s` if $opened;
	exit(-1);
    }
    
    # the start of a new section 
    if (/$section_regex/) {
        # write out the offsets in previous section if there are some
        update_funcs();

	# reset for a new section 
	undef($ref_func);
	undef(@offsets) ;
        $valid_section = 0;

        # this is a section we concern?
        $valid_section = 1 if $text_sections{$1}; 
    } 

    # record a ref_function and this offset
    if ($valid_section && /$function_regex/) {
        # PPC64 can have symbols that start with .L and
        # gcc considers these special. Don't use them!
	if ($2 !~ /^\.L/ 
            && ((!$ref_func && ($globals{$2} || $locals{$2})) # set a new ref_func
            || ($ref_func && $locals{$ref_func} && $globals{$2}))) { # replace a local
            $ref_func = $2;
            $offset = hex $1;
        }
    } 

    # record a mcount call site
    if ($valid_section && /$mcount_regex/) {
	$offsets[$#offsets + 1] = hex $1;
    }
}

update_funcs();

# If we did not find any mcount callers, we are done (do nothing).
if (!$opened) {
    exit(0);
}

close(FILE);

#
# Step 3: Compile the file that holds the list of call sites to mcount.
#
`$cc -o $mcount_o -c $mcount_s`;

#
# Step 4: Do we have sections that started with local functions?
#
if (keys %convert) {
    my $globallist = "";
    my $locallist = "";

    foreach (keys %convert) {
	$globallist .= " --globalize-symbol $_";
	$locallist .= " --localize-symbol $_";
    }

    my $globalobj = $dirname . "/.tmp_gl_" . $filename;
    my $globalmix = $dirname . "/.tmp_mx_" . $filename;

    #
    # Step 5: set up each local function as a global
    #
    `$objcopy $globallist $inputfile $globalobj`;

    #
    # Step 6: Link the global version to our list.
    #
    `$ld -r $globalobj $mcount_o -o $globalmix`;

    #
    # Step 7: Convert the local functions back into local symbols
    #
    `$objcopy $locallist $globalmix $inputfile`;

    # Remove the temp files
    `$rm $globalobj $globalmix`;

} else {

    my $mix = $dirname . "/.tmp_mx_" . $filename;

    #
    # Step 8: Link the object with our list of call sites object.
    #
    `$ld -r $inputfile $mcount_o -o $mix`;

    #
    # Step 9: Move the result back to the original object.
    #
    `$mv $mix $inputfile`;
}

# Clean up the temp files
`$rm $mcount_o $mcount_s`;

exit(0);

--liOOAslEiF7prFVr--
