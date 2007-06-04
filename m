Return-Path: <linux-kernel-owner+w=401wt.eu-S1753755AbXFDJ2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755AbXFDJ2P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 05:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752843AbXFDJ2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 05:28:01 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4194 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbXFDJ2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 05:28:00 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] update checkpatch.pl to version 0.03
Message-ID: <0a25fd03117c678f17006c5fcefaaed0@pinky>
Date: Mon, 04 Jun 2007 10:46:24 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This version brings a host of changes to cure false positives and
bugs detected on patches submitted to lkml and -mm.  It also brings
a number of new tests in response to reviews, of particular note:

  - catch use of volatile
  - allow deprecated functions to be listed in feature-removal-schedule.txt
  - warn about #ifdef's in c files
  - check that spinlock_t and struct mutex use is commented
  - report on architecture specific defines being used
  - report memory barriers without an associated comment

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---

Full changelog:

Andy Whitcroft (19):
      catch use of volatile
      convert other quoted string checks to common routine
      alloc deprecated functions to be listed in feature-removal-schedule.txt
      split out the line length and indent for each line
      improve switch block handling
      handle GNU diff context lines with no leading space
      warn about #ifdef's in c files
      tidy up tests for signed-off-by using raw mode
      check that spinlock_t and struct mutex use is commented
      syntax checks for open brace placement may drop off the bottom of hunk
      report memory barriers without an associated comment
      when a sign off is present but ugly do not report it missing
      do not mistake bitfield definitions for indented labels
      report on architecture specific defines being used
      major update to the operator checks
      prevent switch/if/while etc matching foo_switch
      generify assignement in condition error message
      introduce an operator context marker
      Version: 0.03
---
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
old mode 100644
new mode 100755
index e216d49..9590bbb
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -8,7 +8,7 @@ use strict;
 
 my $P = $0;
 
-my $V = '0.01';
+my $V = '0.03';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -38,7 +38,8 @@ if ($tree && !top_of_kernel_tree()) {
 	exit(2);
 }
 
-my @deprecated = ();
+my @dep_includes = ();
+my @dep_functions = ();
 my $removal = 'Documentation/feature-removal-schedule.txt';
 if ($tree && -f $removal) {
 	open(REMOVE, "<$removal") || die "$P: $removal: open failed - $!\n";
@@ -46,9 +47,14 @@ if ($tree && -f $removal) {
 		if (/^Files:\s+(.*\S)/) {
 			for my $file (split(/[, ]+/, $1)) {
 				if ($file =~ m@include/(.*)@) {
-					push(@deprecated, $1);
+					push(@dep_includes, $1);
 				}
 			}
+
+		} elsif (/^Funcs:\s+(.*\S)/) {
+			for my $func (split(/[, ]+/, $1)) {
+				push(@dep_functions, $func);
+			}
 		}
 	}
 }
@@ -99,6 +105,97 @@ sub expand_tabs {
 	return $res;
 }
 
+sub line_stats {
+	my ($line) = @_;
+
+	# Drop the diff line leader and expand tabs
+	$line =~ s/^.//;
+	$line = expand_tabs($line);
+
+	# Pick the indent from the front of the line.
+	my ($white) = ($line =~ /^(\s*)/);
+
+	return (length($line), length($white));
+}
+
+sub ctx_block_get {
+	my ($linenr, $remain, $outer) = @_;
+	my $line;
+	my $start = $linenr - 1;
+	my $end = $linenr - 1 + $remain;
+	my $blk = '';
+	my @o;
+	my @c;
+	my @res = ();
+
+	for ($line = $start; $line < $end; $line++) {
+		$blk .= $lines[$line];
+
+		@o = ($blk =~ /\{/g);
+		@c = ($blk =~ /\}/g);
+
+		if (!$outer || (scalar(@o) - scalar(@c)) == 1) {
+			push(@res, $lines[$line]);
+		}
+
+		last if (scalar(@o) == scalar(@c));
+	}
+
+	return @res;
+}
+sub ctx_block_outer {
+	my ($linenr, $remain) = @_;
+
+	return ctx_block_get($linenr, $remain, 1);
+}
+sub ctx_block {
+	my ($linenr, $remain) = @_;
+
+	return ctx_block_get($linenr, $remain, 0);
+}
+
+sub ctx_locate_comment {
+	my ($first_line, $end_line) = @_;
+
+	# Catch a comment on the end of the line itself.
+	my ($current_comment) = ($lines[$end_line - 1] =~ m@.*(/\*.*\*/)\s*$@);
+	return $current_comment if (defined $current_comment);
+
+	# Look through the context and try and figure out if there is a
+	# comment.
+	my $in_comment = 0;
+	$current_comment = '';
+	for (my $linenr = $first_line; $linenr < $end_line; $linenr++) {
+		my $line = $lines[$linenr - 1];
+		##warn "           $line\n";
+		if ($linenr == $first_line and $line =~ m@^.\s*\*@) {
+			$in_comment = 1;
+		}
+		if ($line =~ m@/\*@) {
+			$in_comment = 1;
+		}
+		if (!$in_comment && $current_comment ne '') {
+			$current_comment = '';
+		}
+		$current_comment .= $line . "\n" if ($in_comment);
+		if ($line =~ m@\*/@) {
+			$in_comment = 0;
+		}
+	}
+
+	chomp($current_comment);
+	return($current_comment);
+}
+sub ctx_has_comment {
+	my ($first_line, $end_line) = @_;
+	my $cmt = ctx_locate_comment($first_line, $end_line);
+
+	##print "LINE: $lines[$end_line - 1 ]\n";
+	##print "CMMT: $cmt\n";
+
+	return ($cmt ne '');
+}
+
 sub cat_vet {
 	my ($vet) = @_;
 
@@ -108,6 +205,10 @@ sub cat_vet {
 	return $vet;
 }
 
+sub has_non_quoted {
+	return ($_[0] =~ m{$_[1]} and $_[0] !~ m{\".*$_[1].*\"});
+}
+
 sub process {
 	my $filename = shift;
 	my @lines = @_;
@@ -116,7 +217,7 @@ sub process {
 	my $prevline="";
 	my $stashline="";
 
-	my $lineforcounting='';
+	my $length;
 	my $indent;
 	my $previndent=0;
 	my $stashindent=0;
@@ -145,7 +246,7 @@ sub process {
 #extract the line range in the file after the patch is applied
 		if ($line=~/^\@\@ -\d+,\d+ \+(\d+)(,(\d+))? \@\@/) {
 			$is_patch = 1;
-			$first_line = 1;
+			$first_line = $linenr + 1;
 			$in_comment = 0;
 			$realline=$1-1;
 			if (defined $2) {
@@ -156,8 +257,10 @@ sub process {
 			next;
 		}
 
-#track the line number as we move through the hunk
-		if ($line=~/^[ \+]/) {
+# track the line number as we move through the hunk, note that
+# new versions of GNU diff omit the leading space on completely
+# blank context lines so we need to count that too.
+		if ($line =~ /^( |\+|$)/) {
 			$realline++;
 			$realcnt-- if ($realcnt != 0);
 
@@ -168,7 +271,7 @@ sub process {
 			# Guestimate if this is a continuing comment.  If this
 			# is the start of a diff block and this line starts
 			# ' *' then it is very likely a comment.
-			if ($first_line and $line =~ m@^.\s*\*@) {
+			if ($linenr == $first_line and $line =~ m@^.\s*\*@) {
 				$in_comment = 1;
 			}
 			if ($line =~ m@/\*@) {
@@ -178,17 +281,12 @@ sub process {
 				$in_comment = 0;
 			}
 
-			$lineforcounting = $line;
-			$lineforcounting =~ s/^\+//;
-			$lineforcounting = expand_tabs($lineforcounting);
-
-			my ($white) = ($lineforcounting =~ /^(\s*)/);
-			$indent = length($white);
+			# Measure the line length and indent.
+			($length, $indent) = line_stats($line);
 
 			# Track the previous line.
 			($prevline, $stashline) = ($stashline, $line);
 			($previndent, $stashindent) = ($stashindent, $indent);
-			$first_line = 0;
 		}
 
 #make up the handle for any error we report on this line
@@ -203,6 +301,8 @@ sub process {
 			$signoff++;
 
 		} elsif ($line =~ /^\s*signed-off-by:/i) {
+			# This is a signoff, if ugly, so do not double report.
+			$signoff++;
 			if (!($line =~ /^\s*Signed-off-by:/)) {
 				print "use Signed-off-by:\n";
 				print "$herecurr";
@@ -229,7 +329,7 @@ sub process {
 			$clean = 0;
 		}
 #80 column limit
-		if (!($prevline=~/\/\*\*/) && length($lineforcounting) > 80) {
+		if (!($prevline=~/\/\*\*/) && $length > 80) {
 			print "line over 80 characters\n";
 			print "$herecurr";
 			$clean = 0;
@@ -254,7 +354,7 @@ sub process {
 		next if ($in_comment);
 
 # no C99 // comments
-		if ($line =~ m@//@ and !($line =~ m@\".*//.*\"@)) {
+		if (has_non_quoted($line, '//')) {
 			print "do not use C99 // comments\n";
 			print "$herecurr";
 			$clean = 0;
@@ -320,44 +420,44 @@ sub process {
 			print "$herecurr";
 			$clean = 0;
 		}
+		# Note we expand the line with the leading + as the real
+		# line will be displayed with the leading + and the tabs
+		# will therefore also expand that way.
 		my $opline = $line;
+		$opline = expand_tabs($opline);
 		$opline =~ s/^.//;
 		if (!($line=~/\#\s*include/)) {
 			# Check operator spacing.
 			my @elements = split(/(<<=|>>=|<=|>=|==|!=|\+=|-=|\*=|\/=|%=|\^=|\|=|&=|->|<<|>>|<|>|=|!|~|&&|\|\||,|\^|\+\+|--|;|&|\||\+|-|\*|\/\/|\/)/, $opline);
+			my $off = 1;
 			for (my $n = 0; $n < $#elements; $n += 2) {
-				# $wN says we have white-space before or after
-				# $sN says we have a separator before or after
-				# $oN says we have another operator before or after
-				my $w1 = $elements[$n] =~ /\s$/;
-				my $s1 = $elements[$n] =~ /(\[|\(|\s)$/;
-				my $o1 = $elements[$n] eq '';
+				$off += length($elements[$n]);
+
+				my $a = '';
+				$a = 'V' if ($elements[$n] ne '');
+				$a = 'W' if ($elements[$n] =~ /\s$/);
+				$a = 'B' if ($elements[$n] =~ /(\[|\()$/);
+				$a = 'O' if ($elements[$n] eq '');
+				$a = 'E' if ($elements[$n] eq '' && $n == 0);
+	
 				my $op = $elements[$n + 1];
-				my $w2 = 1;
-				my $s2 = 1;
-				my $o2 = 0;
-				# If we have something after the operator handle it.
+
+				my $c = '';
 				if (defined $elements[$n + 2]) {
-					$w2 = $elements[$n + 2] =~ /^\s/;
-					$s2 = $elements[$n + 2] =~ /^(\s|\)|\]|;)/;
-					$o2 = $elements[$n + 2] eq '';
+					$c = 'V' if ($elements[$n + 2] ne '');
+					$c = 'W' if ($elements[$n + 2] =~ /^\s/);
+					$c = 'B' if ($elements[$n + 2] =~ /^(\)|\]|;)/);
+					$c = 'O' if ($elements[$n + 2] eq '');
+				} else {
+					$c = 'E';
 				}
 
-				# Generate the context.
-				my $at = "here: ";
-				for (my $m = $n; $m >= 0; $m--) {
-					if ($elements[$m] ne '') {
-						$at .= $elements[$m];
-						last;
-					}
-				}
-				$at .= $op;
-				for (my $m = $n + 2; defined $elements[$m]; $m++) {
-					if ($elements[$m] ne '') {
-						$at .= $elements[$m];
-						last;
-					}
-				}
+				my $ctx = "${a}x${c}";
+
+				my $at = "(ctx:$ctx)";
+				
+				my $ptr = (" " x $off) . "^";
+				my $hereptr = "$here\n$line\n$ptr\n\n";
 
 				##print "<$s1:$op:$s2> <$elements[$n]:$elements[$n + 1]:$elements[$n + 2]>\n";
 				# Skip things apparently in quotes.
@@ -368,38 +468,38 @@ sub process {
 
 				# -> should have no spaces
 				} elsif ($op eq '->') {
-					if ($s1 or $s2) {
+					if ($ctx =~ /Wx.|.xW/) {
 						print "no spaces around that '$op' $at\n";
-						print "$herecurr";
+						print "$hereptr";
 						$clean = 0;
 					}
 
 				# , must have a space on the right.
 				} elsif ($op eq ',') {
-					if (!$s2) {
+					if ($ctx !~ /.xW|.xE/) {
 						print "need space after that '$op' $at\n";
-						print "$herecurr";
+						print "$hereptr";
 						$clean = 0;
 					}
 
 				# unary ! and unary ~ are allowed no space on the right
 				} elsif ($op eq '!' or $op eq '~') {
-					if (!$s1 && !$o1) {
+					if ($ctx !~ /[WOEB]x./) {
 						print "need space before that '$op' $at\n";
-						print "$herecurr";
+						print "$hereptr";
 						$clean = 0;
 					}
-					if ($s2) {
+					if ($ctx =~ /.xW/) {
 						print "no space after that '$op' $at\n";
-						print "$herecurr";
+						print "$hereptr";
 						$clean = 0;
 					}
 
 				# unary ++ and unary -- are allowed no space on one side.
 				} elsif ($op eq '++' or $op eq '--') {
-					if (($s1 && $s2) || ((!$s1 && !$o1) && (!$s2 && !$o2))) {
+					if ($ctx !~ /[WOB]x[^W]|[^W]x[WOB]/) {
 						print "need space one side of that '$op' $at\n";
-						print "$herecurr";
+						print "$hereptr";
 						$clean = 0;
 					}
 
@@ -420,10 +520,17 @@ sub process {
 				# 	(foo *)
 				#	(foo **)
 				#
-				} elsif ($op eq '&' or $op eq '-' or $op eq '*') {
-					if ($w2 and !$w1) {
+				} elsif ($op eq '&' or $op eq '-') {
+					if ($ctx !~ /VxV|[EWB]x[WE]|[EWB]x[VO]/) {
 						print "need space before that '$op' $at\n";
-						print "$herecurr";
+						print "$hereptr";
+						$clean = 0;
+					}
+
+				} elsif ($op eq '*') {
+					if ($ctx !~ /VxV|[EWB]x[WE]|[EWB]x[VO]|[EWO]x[OBV]/) {
+						print "need space before that '$op' $at\n";
+						print "$hereptr";
 						$clean = 0;
 					}
 
@@ -431,18 +538,19 @@ sub process {
 				} elsif ($op eq '<<' or $op eq '>>' or $op eq '+' or $op eq '/' or
 					 $op eq '^' or $op eq '|')
 				{
-					if ($s1 != $s2) {
+					if ($ctx !~ /VxV|WxW|VxE|WxE/) {
 						print "need consistent spacing around '$op' $at\n";
-						print "$herecurr";
+						print "$hereptr";
 						$clean = 0;
 					}
 
 				# All the others need spaces both sides.
-				} elsif (!$s1 or !$s2) {
+				} elsif ($ctx !~ /[EW]x[WE]/) {
 					print "need spaces around that '$op' $at\n";
-					print "$herecurr";
+					print "$hereptr";
 					$clean = 0;
 				}
+				$off += length($elements[$n + 1]);
 			}
 		}
 
@@ -454,7 +562,7 @@ sub process {
 		}
 
 #goto labels aren't indented, allow a single space however
-		if ($line=~/^.\s+[A-Za-z\d_]+:/ and
+		if ($line=~/^.\s+[A-Za-z\d_]+:(?![0-9]+)/ and
 		   !($line=~/^. [A-Za-z\d_]+:/) and !($line=~/^.\s+default:/)) {
 			print "labels should not be indented\n";
 			print "$herecurr";
@@ -462,15 +570,15 @@ sub process {
 		}
 
 # Need a space before open parenthesis after if, while etc
-		if ($line=~/(if|while|for|switch)\(/) {
+		if ($line=~/\b(if|while|for|switch)\(/) {
 			print "need a space before the open parenthesis\n";
 			print "$herecurr";
 			$clean = 0;
 		}
 
 # Check for illegal assignment in if conditional.
-		if ($line=~/(if|while)\s*\(.*[^<>!=]=[^=].*\)/) {
-			print "do not use assignment in if condition\n";
+		if ($line=~/\b(if|while)\s*\(.*[^<>!=]=[^=].*\)/) {
+			print "do not use assignment in condition\n";
 			print "$herecurr";
 			$clean = 0;
 		}
@@ -484,15 +592,28 @@ sub process {
 			$clean = 0;
 		}
 
-		# Check for switch () {<nl>case, these must be at the
-		# same indent.  We will only catch the first one, as our
-		# context is very small but people tend to be consistent
-		# so we will catch them out more often than not.
-		if ($prevline=~/\s*switch\s*\(.*\)/ and $line=~/\s*case\s+/
-						and $previndent != $indent) {
-			print "switch and case should be at the same indent\n";
-			print "$hereprev";
-			$clean = 0;
+		# Check for switch () and associated case and default
+		# statements should be at the same indent.
+		if ($line=~/\bswitch\s*\(.*\)/) {
+			my $err = '';
+			my $sep = '';
+			my @ctx = ctx_block_outer($linenr, $realcnt);
+			shift(@ctx);
+			for my $ctx (@ctx) {
+				my ($clen, $cindent) = line_stats($ctx);
+				if ($ctx =~ /\s*(case\s+|default:)/ &&
+							$indent != $cindent) {
+					$err .= "$sep$ctx\n";
+					$sep = '';
+				} else {
+					$sep = "[...]\n";
+				}
+			}
+			if ($err ne '') {
+				print "switch and case should be at the same indent\n";
+				print "$here\n$line\n$err\n";
+				$clean = 0;
+			}
 		}
 
 #studly caps, commented out until figure out how to distinguish between use of existing and adding new
@@ -520,7 +641,7 @@ sub process {
 		}
 
 #if/while/etc brace do not go on next line, unless #defining a do while loop, or if that brace on the next line is for something else
-		if ($prevline=~/(if|while|for|switch)\s*\(/) {
+		if ($prevline=~/\b(if|while|for|switch)\s*\(/) {
 			my @opened = $prevline=~/\(/g;
 			my @closed = $prevline=~/\)/g;
 			my $nr_line = $linenr;
@@ -529,7 +650,7 @@ sub process {
 			my $extra_lines = 0;
 			my $display_segment = $prevline;
 
-			while ($remaining > 0 && scalar @opened > scalar @closed) {
+			while ($remaining > 1 && scalar @opened > scalar @closed) {
 				$prevline .= $next_line;
 				$display_segment .= "\n" . $next_line;
 				$next_line = $lines[$nr_line];
@@ -540,10 +661,10 @@ sub process {
 				@closed = $prevline=~/\)/g;
 			}
 
-			if (($prevline=~/(if|while|for|switch)\s*\(.*\)\s*$/) and ($next_line=~/{/) and
-			   !($next_line=~/(if|while|for)/) and !($next_line=~/\#define.*do.*while/)) {
+			if (($prevline=~/\b(if|while|for|switch)\s*\(.*\)\s*$/) and ($next_line=~/{/) and
+			   !($next_line=~/\b(if|while|for)/) and !($next_line=~/\#define.*do.*while/)) {
 				print "That { should be on the previous line\n";
-				print "$display_segment\n$next_line\n\n";
+				print "$here\n$display_segment\n$next_line\n\n";
 				$clean = 0;
 			}
 		}
@@ -558,7 +679,7 @@ sub process {
 		}
 
 # don't include deprecated include files
-		for my $inc (@deprecated) {
+		for my $inc (@dep_includes) {
 			if ($line =~ m@\#\s*include\s*\<$inc>@) {
 				print "Don't use <$inc>: see Documentation/feature-removal-schedule.txt\n";
 				print "$herecurr";
@@ -566,9 +687,49 @@ sub process {
 			}
 		}
 
-# don't use kernel_thread()
-		if ($line =~ /\bkernel_thread\b/) {
-			print "Don't use kernel_thread(), use kthread(): see Documentation/feature-removal-schedule.txt\n";
+# don't use deprecated functions
+		for my $func (@dep_functions) {
+			if (has_non_quoted($line, '\b' . $func . '\b')) {
+				print "Don't use $func(): see Documentation/feature-removal-schedule.txt\n";
+				print "$herecurr";
+				$clean = 0;
+			}
+		}
+
+# no volatiles please
+ 		if (has_non_quoted($line, '\bvolatile\b')) {
+			print "Use of volatile is usually wrong: see Documentation/volatile-considered-harmful.txt\n";
+			print "$herecurr";
+			$clean = 0;
+		}
+
+# warn about #ifdefs in C files
+		if ($line =~ /^.#\s*if(|n)def/ && ($realfile =~ /\.c$/)) {
+			print "#ifdef in C files should be avoided\n";
+			print "$herecurr";
+			$clean = 0;
+		}
+
+# check for spinlock_t definitions without a comment.
+		if ($line =~ /^.\s*(struct\s+mutex|spinlock_t)\s+\S+;/) {
+			my $which = $1;
+			if (!ctx_has_comment($first_line, $linenr)) {
+				print "$1 definition without comment\n";
+				print "$herecurr";
+				$clean = 0;
+			}
+		}
+# check for memory barriers without a comment.
+		if ($line =~ /\b(mb|rmb|wmb|read_barrier_depends|smp_mb|smp_rmb|smp_wmb|smp_read_barrier_depends)\(/) {
+			if (!ctx_has_comment($first_line, $linenr)) {
+				print "memory barrier without comment\n";
+				print "$herecurr";
+				$clean = 0;
+			}
+		}
+# check of hardware specific defines
+		if ($line =~ m@^.#\s*if.*\b(__i386__|__powerpc64__|__sun__|__s390x__)\b@) {
+			print "architecture specific defines should be avoided\n";
 			print "$herecurr";
 			$clean = 0;
 		}
