Return-Path: <linux-kernel-owner+w=401wt.eu-S1758451AbXGOIVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758451AbXGOIVy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 04:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755271AbXGOIVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 04:21:44 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4339 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806AbXGOIVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 04:21:42 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] update checkpatch.pl to version 0.08
Message-ID: <740c90243aaa6f6d4640d71230c4fa27@pinky>
Date: Sun, 15 Jul 2007 09:25:13 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This version brings a number of new checks, and a number of bug
fixes.  Of note:

  - warnings for multiple assignments per line
  - warnings for multiple declarations per line
  - checks for single statement blocks with braces

This patch includes an update for feature-removal-schedule.txt to
better target checks.

Andy Whitcroft (12):
      Version: 0.08
      only apply printk checks where there is a string literal
      allow suppression of errors for when no patch is found
      warn about multiple assignments
      warn on declaration of multiple variables
      check for kfree() with needless null check
      check for single statement braced blocks
      check for aggregate initialisation on the next line
      handle the => operator
      check for spaces between function name and open parenthesis
      move to explicit Check: entries in feature-removal-schedule.txt
      handle pointer attributes

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---

	This has been tested, but not had quite its usual soak on
	the lkml flow.	It is being pushed out a little sooner than
	normal as I am going to be off the 'net for a week and wanted
	to get it out before.

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 1e8dba0..85d736e 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -63,6 +63,7 @@ Who:	David Miller <davem@davemloft.net>
 What:	Video4Linux API 1 ioctls and video_decoder.h from Video devices.
 When:	December 2006
 Files:	include/linux/video_decoder.h
+Check:	include/linux/video_decoder.h
 Why:	V4L1 AP1 was replaced by V4L2 API. during migration from 2.4 to 2.6
 	series. The old API have lots of drawbacks and don't provide enough
 	means to work with all video and audio standards. The newer API is
@@ -79,7 +80,7 @@ Who:	Mauro Carvalho Chehab <mchehab@brturbo.com.br>
 What:	remove EXPORT_SYMBOL(kernel_thread)
 When:	August 2006
 Files:	arch/*/kernel/*_ksyms.c
-Funcs:	kernel_thread
+Check:	kernel_thread
 Why:	kernel_thread is a low-level implementation detail.  Drivers should
         use the <linux/kthread.h> API instead which shields them from
 	implementation details and provides a higherlevel interface that
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 25e20a2..73751ab 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -9,7 +9,7 @@ use strict;
 my $P = $0;
 $P =~ s@.*/@@g;
 
-my $V = '0.07';
+my $V = '0.08';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -47,16 +47,14 @@ my $removal = 'Documentation/feature-removal-schedule.txt';
 if ($tree && -f $removal) {
 	open(REMOVE, "<$removal") || die "$P: $removal: open failed - $!\n";
 	while (<REMOVE>) {
-		if (/^Files:\s+(.*\S)/) {
-			for my $file (split(/[, ]+/, $1)) {
-				if ($file =~ m@include/(.*)@) {
+		if (/^Check:\s+(.*\S)/) {
+			for my $entry (split(/[, ]+/, $1)) {
+				if ($entry =~ m@include/(.*)@) {
 					push(@dep_includes, $1);
-				}
-			}
 
-		} elsif (/^Funcs:\s+(.*\S)/) {
-			for my $func (split(/[, ]+/, $1)) {
-				push(@dep_functions, $func);
+				} elsif ($entry !~ m@/@) {
+					push(@dep_functions, $entry);
+				}
 			}
 		}
 	}
@@ -153,7 +151,7 @@ sub sanitise_line {
 }
 
 sub ctx_block_get {
-	my ($linenr, $remain, $outer, $open, $close) = @_;
+	my ($linenr, $remain, $outer, $open, $close, $off) = @_;
 	my $line;
 	my $start = $linenr - 1;
 	my $blk = '';
@@ -161,38 +159,58 @@ sub ctx_block_get {
 	my @c;
 	my @res = ();
 
+	my $level = 0;
 	for ($line = $start; $remain > 0; $line++) {
 		next if ($rawlines[$line] =~ /^-/);
 		$remain--;
 
 		$blk .= $rawlines[$line];
+		foreach my $c (split(//, $rawlines[$line])) {
+			##print "C<$c>L<$level><$open$close>O<$off>\n";
+			if ($off > 0) {
+				$off--;
+				next;
+			}
 
-		@o = ($blk =~ /$open/g);
-		@c = ($blk =~ /$close/g);
+			if ($c eq $close && $level > 0) {
+				$level--;
+				last if ($level == 0);
+			} elsif ($c eq $open) {
+				$level++;
+			}
+		}
 
-		if (!$outer || (scalar(@o) - scalar(@c)) == 1) {
+		if (!$outer || $level <= 1) {
 			push(@res, $rawlines[$line]);
 		}
 
-		last if (scalar(@o) == scalar(@c));
+		last if ($level == 0);
 	}
 
-	return @res;
+	return ($level, @res);
 }
 sub ctx_block_outer {
 	my ($linenr, $remain) = @_;
 
-	return ctx_block_get($linenr, $remain, 1, '\{', '\}');
+	my ($level, @r) = ctx_block_get($linenr, $remain, 1, '{', '}', 0);
+	return @r;
 }
 sub ctx_block {
 	my ($linenr, $remain) = @_;
 
-	return ctx_block_get($linenr, $remain, 0, '\{', '\}');
+	my ($level, @r) = ctx_block_get($linenr, $remain, 0, '{', '}', 0);
+	return @r;
 }
 sub ctx_statement {
+	my ($linenr, $remain, $off) = @_;
+
+	my ($level, @r) = ctx_block_get($linenr, $remain, 0, '(', ')', $off);
+	return @r;
+}
+sub ctx_block_level {
 	my ($linenr, $remain) = @_;
 
-	return ctx_block_get($linenr, $remain, 0, '\(', '\)');
+	return ctx_block_get($linenr, $remain, 0, '{', '}', 0);
 }
 
 sub ctx_locate_comment {
@@ -246,16 +264,23 @@ sub cat_vet {
 	return $vet;
 }
 
+my @report = ();
+sub report {
+	push(@report, $_[0]);
+}
+sub report_dump {
+	@report;
+}
 sub ERROR {
-	print "ERROR: $_[0]\n";
+	report("ERROR: $_[0]\n");
 	our $clean = 0;
 }
 sub WARN {
-	print "WARNING: $_[0]\n";
+	report("WARNING: $_[0]\n");
 	our $clean = 0;
 }
 sub CHK {
-	print "CHECK: $_[0]\n";
+	report("CHECK: $_[0]\n");
 	our $clean = 0;
 }
 
@@ -318,7 +343,10 @@ sub process {
 				(?:\s*\*+\s*const|\s*\*+)?
 			  }x;
 	my $Declare	= qr{(?:$Storage\s+)?$Type};
-	my $Attribute	= qr{__read_mostly|__init|__initdata};
+	my $Attribute	= qr{const|__read_mostly|__init|__initdata|__meminit};
+
+	my $Member	= qr{->$Ident|\.$Ident|\[[^]]*\]};
+	my $Lval	= qr{$Ident(?:$Member)*};
 
 	# Pre-scan the patch looking for any __setup documentation.
 	my @setup_docs = ();
@@ -509,7 +537,7 @@ sub process {
 # if/while/etc brace do not go on next line, unless defining a do while loop,
 # or if that brace on the next line is for something else
 		if ($line =~ /\b(?:(if|while|for|switch)\s*\(|do\b|else\b)/ && $line !~ /^.#/) {
-			my @ctx = ctx_statement($linenr, $realcnt);
+			my @ctx = ctx_statement($linenr, $realcnt, 0);
 			my $ctx_ln = $linenr + $#ctx + 1;
 			my $ctx_cnt = $realcnt - $#ctx - 1;
 			my $ctx = join("\n", @ctx);
@@ -521,7 +549,7 @@ sub process {
 			##warn "line<$line>\nctx<$ctx>\nnext<$lines[$ctx_ln - 1]>";
 
 			if ($ctx !~ /{\s*/ && $ctx_cnt > 0 && $lines[$ctx_ln - 1] =~ /^\+\s*{/) {
-				ERROR("That { should be on the previous line\n" .
+				ERROR("That open brace { should be on the previous line\n" .
 					"$here\n$ctx\n$lines[$ctx_ln - 1]");
 			}
 		}
@@ -535,6 +563,12 @@ sub process {
 			next;
 		}
 
+# check for initialisation to aggregates open brace on the next line
+		if ($prevline =~ /$Declare\s*$Ident\s*=\s*$/ &&
+		    $line =~ /^.\s*{/) {
+			ERROR("That open brace { should be on the previous line\n" . $hereprev);
+		}
+
 #
 # Checks which are anchored on the added line.
 #
@@ -570,8 +604,13 @@ sub process {
 			}
 		}
 
+# check for external initialisers.
+		if ($line =~ /^.$Type\s*$Ident\s*=\s*(0|NULL);/) {
+			ERROR("do not initialise externals to 0 or NULL\n" .
+				$herecurr);
+		}
 # check for static initialisers.
-		if ($line=~/\s*static\s.*=\s+(0|NULL);/) {
+		if ($line =~ /\s*static\s.*=\s*(0|NULL);/) {
 			ERROR("do not initialise statics to 0 or NULL\n" .
 				$herecurr);
 		}
@@ -593,11 +632,11 @@ sub process {
 			ERROR("\"(foo $1 )\" should be \"(foo $1)\"\n" .
 				$herecurr);
 
-		} elsif ($line =~ m{$NonptrType(\*+)(?:\s+const)?\s+[A-Za-z\d_]+}) {
+		} elsif ($line =~ m{$NonptrType(\*+)(?:\s+$Attribute)?\s+[A-Za-z\d_]+}) {
 			ERROR("\"foo$1 bar\" should be \"foo $1bar\"\n" .
 				$herecurr);
 
-		} elsif ($line =~ m{$NonptrType\s+(\*+)(?!\s+const)\s+[A-Za-z\d_]+}) {
+		} elsif ($line =~ m{$NonptrType\s+(\*+)(?!\s+$Attribute)\s+[A-Za-z\d_]+}) {
 			ERROR("\"foo $1 bar\" should be \"foo $1bar\"\n" .
 				$herecurr);
 		}
@@ -614,7 +653,7 @@ sub process {
 # to try and find and validate the current printk.  In summary the current
 # printk includes all preceeding printk's which have no newline on the end.
 # we assume the first bad printk is the one to report.
-		if ($line =~ /\bprintk\((?!KERN_)/) {
+		if ($line =~ /\bprintk\((?!KERN_)\s*"/) {
 			my $ok = 0;
 			for (my $ln = $linenr - 1; $ln >= $first_line; $ln--) {
 				#print "CHECK<$lines[$ln - 1]\n";
@@ -639,6 +678,12 @@ sub process {
 			ERROR("open brace '{' following function declarations go on the next line\n" . $herecurr);
 		}
 
+# check for spaces between functions and their parentheses.
+		if ($line =~ /($Ident)\s+\(/ &&
+		    $1 !~ /^(?:if|for|while|switch|return|volatile)$/ &&
+		    $line !~ /$Type\s+\(/ && $line !~ /^.\#\s*define\b/) {
+			ERROR("no space between function name and open parenthesis '('\n" . $herecurr);
+		}
 # Check operator spacing.
 		# Note we expand the line with the leading + as the real
 		# line will be displayed with the leading + and the tabs
@@ -647,7 +692,7 @@ sub process {
 		$opline = expand_tabs($opline);
 		$opline =~ s/^./ /;
 		if (!($line=~/\#\s*include/)) {
-			my @elements = split(/(<<=|>>=|<=|>=|==|!=|\+=|-=|\*=|\/=|%=|\^=|\|=|&=|->|<<|>>|<|>|=|!|~|&&|\|\||,|\^|\+\+|--|;|&|\||\+|-|\*|\/\/|\/)/, $opline);
+			my @elements = split(/(<<=|>>=|<=|>=|==|!=|\+=|-=|\*=|\/=|%=|\^=|\|=|&=|=>|->|<<|>>|<|>|=|!|~|&&|\|\||,|\^|\+\+|--|;|&|\||\+|-|\*|\/\/|\/)/, $opline);
 			my $off = 0;
 			for (my $n = 0; $n < $#elements; $n += 2) {
 				$off += length($elements[$n]);
@@ -773,6 +818,18 @@ sub process {
 			}
 		}
 
+# check for multiple assignments
+		if ($line =~ /^.\s*$Lval\s*=\s*$Lval\s*=(?!=)/) {
+			WARN("multiple assignments should be avoided\n" . $herecurr);
+		}
+
+# check for multiple declarations, allowing for a function declaration
+# continuation.
+		if ($line =~ /^.\s*$Type\s+$Ident(?:\s*=[^,{]*)?\s*,\s*$Ident.*/ &&
+		    $line !~ /^.\s*$Type\s+$Ident(?:\s*=[^,{]*)?\s*,\s*$Type\s*$Ident.*/) {
+			WARN("declaring multiple variables together should be avoided\n" . $herecurr);
+		}
+
 #need space before brace following if, while, etc
 		if ($line =~ /\(.*\){/ || $line =~ /do{/) {
 			ERROR("need a space before the open brace '{'\n" . $herecurr);
@@ -847,13 +904,18 @@ sub process {
 			# or the one below.
 			my $ln = $linenr;
 			my $cnt = $realcnt;
+			my $off = 0;
 
-			# If the macro starts on the define line start there.
-			if ($prevline !~ m{^.#\s*define\s*$Ident(?:\([^\)]*\))?\s*\\\s*$}) {
+			# If the macro starts on the define line start
+			# grabbing the statement after the identifier
+			$prevline =~ m{^(.#\s*define\s*$Ident(?:\([^\)]*\))?\s*)(.*)\\\s*$};
+			##print "1<$1> 2<$2>\n";
+			if ($2 ne '') {
+				$off = length($1);
 				$ln--;
 				$cnt++;
 			}
-			my @ctx = ctx_statement($ln, $cnt);
+			my @ctx = ctx_statement($ln, $cnt, $off);
 			my $ctx_ln = $ln + $#ctx + 1;
 			my $ctx = join("\n", @ctx);
 
@@ -873,6 +935,44 @@ sub process {
 			}
 		}
 
+# check for redundant bracing round if etc
+		if ($line =~ /\b(if|while|for|else)\b/) {
+			# Locate the end of the opening statement.
+			my @control = ctx_statement($linenr, $realcnt, 0);
+			my $nr = $linenr + (scalar(@control) - 1);
+			my $cnt = $realcnt - (scalar(@control) - 1);
+
+			my $off = $realcnt - $cnt;
+			#print "$off: line<$line>end<" . $lines[$nr - 1] . ">\n";
+
+			# If this is is a braced statement group check it
+			if ($lines[$nr - 1] =~ /{\s*$/) {
+				my ($lvl, @block) = ctx_block_level($nr, $cnt);
+
+				my $stmt = join(' ', @block);
+				$stmt =~ s/^[^{]*{//;
+				$stmt =~ s/}[^}]*$//;
+
+				#print "block<" . join(' ', @block) . "><" . scalar(@block) . ">\n";
+				#print "stmt<$stmt>\n\n";
+
+				# Count the ;'s if there is fewer than two
+				# then there can only be one statement,
+				# if there is a brace inside we cannot
+				# trivially detect if its one statement.
+				# Also nested if's often require braces to
+				# disambiguate the else binding so shhh there.
+				my @semi = ($stmt =~ /;/g);
+				##print "semi<" . scalar(@semi) . ">\n";
+				if ($lvl == 0 && scalar(@semi) < 2 &&
+				    $stmt !~ /{/ && $stmt !~ /\bif\b/) {
+				    	my $herectx = "$here\n" . join("\n", @control, @block[1 .. $#block]) . "\n";
+				    	shift(@block);
+					ERROR("braces {} are not necessary for single statement blocks\n" . $herectx);
+				}
+			}
+		}
+
 # don't include deprecated include files (uses RAW line)
 		for my $inc (@dep_includes) {
 			if ($rawline =~ m@\#\s*include\s*\<$inc>@) {
@@ -898,6 +998,14 @@ sub process {
 				$herecurr);
 		}
 
+# check for needless kfree() checks
+		if ($prevline =~ /\bif\s*\(([^\)]*)\)/) {
+			my $expr = $1;
+			if ($line =~ /\bkfree\(\Q$expr\E\);/) {
+				WARN("kfree(NULL) is safe this check is probabally not required\n" . $hereprev);
+			}
+		}
+
 # warn about #ifdefs in C files
 #		if ($line =~ /^.#\s*if(|n)def/ && ($realfile =~ /\.c$/)) {
 #			print "#ifdef in C files should be avoided\n";
@@ -952,6 +1060,9 @@ sub process {
 		ERROR("Missing Signed-off-by: line(s)\n");
 	}
 
+	if ($clean == 0 && ($chk_patch || $is_patch)) {
+		print report_dump();
+	}
 	if ($clean == 1 && $quiet == 0) {
 		print "Your patch has no obvious style problems and is ready for submission.\n"
 	}
