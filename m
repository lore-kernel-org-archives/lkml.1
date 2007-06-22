Return-Path: <linux-kernel-owner+w=401wt.eu-S1756036AbXFVIS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbXFVIS0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 04:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751811AbXFVISP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 04:18:15 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4421 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbXFVISM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 04:18:12 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] update checkpatch.pl to version 0.06
Message-ID: <e12915ec7c0cfcb5d6a7c4432f458161@pinky>
Date: Fri, 22 Jun 2007 09:45:04 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Update to checkpatch.pl v0.06.  Of note:

 - do { and else handled correctly as control structures for { matching
 - trailing whitespace correctly tripped when line otherwise empty
 - support for const, including const foo * const bar
 - multiline macros defining values correctly reported

This version of checkpatch.pl can be found at the following URL:

http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl-0.06

Full Changelog:

Andy Whitcroft (14):
      Version: 0.06
      cleanup the Type regular expression declarations
      fix up block counting
      end of line counts as a space for ++ and --
      do { needs the same checks as if, for et al
      handle "const foo * const a" as a valid type
      add spacing checks following ;
      complete whitespace lines should trip trailing whitespace check
      else is also a block control structure
      badly formatted else can trip function declaration
      detect and report trailing statements after else
      types need to be terminated by a boundary
      multiline macros defining values should be surrounded by parentheses
      soften the wording of the Signed-off-by: warnings

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 56c364c..277c326 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -9,7 +9,7 @@ use strict;
 my $P = $0;
 $P =~ s@.*/@@g;
 
-my $V = '0.05';
+my $V = '0.06';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -271,24 +271,38 @@ sub process {
 	my $in_comment = 0;
 	my $first_line = 0;
 
-	my $ident	= '[A-Za-z\d_]+';
-	my $storage	= '(?:extern|static)';
-	my $sparse	= '(?:__user|__kernel|__force|__iomem)';
-	my $type	= '(?:unsigned\s+)?' .
-			  '(?:void|char|short|int|long|unsigned|float|double|' .
-			  'long\s+long|' .
-			  "struct\\s+${ident}|" .
-			  "union\\s+${ident}|" .
-			  "${ident}_t)" .
-			  "(?:\\s+$sparse)*" .
-			  '(?:\s*\*+)?';
-	my $attribute	= '(?:__read_mostly|__init|__initdata)';
-
-	my $Ident	= $ident;
-	my $Type	= $type;
-	my $Storage	= $storage;
-	my $Declare	= "(?:$storage\\s+)?$type";
-	my $Attribute	= $attribute;
+	my $Ident	= qr{[A-Za-z\d_]+};
+	my $Storage	= qr{extern|static};
+	my $Sparse	= qr{__user|__kernel|__force|__iomem};
+	my $NonptrType	= qr{
+				\b
+				(?:const\s+)?
+				(?:unsigned\s+)?
+				(?:
+					void|
+					char|
+					short|
+					int|
+					long|
+					unsigned|
+					float|
+					double|
+					long\s+int|
+					long\s+long|
+					long\s+long\s+int|
+					struct\s+$Ident|
+					union\s+$Ident|
+					${Ident}_t
+				)
+				(?:\s+$Sparse)*
+				\b
+			  }x;
+	my $Type	= qr{
+				\b$NonptrType\b
+				(?:\s*\*+\s*const|\s*\*+)?
+			  }x;
+	my $Declare	= qr{(?:$Storage\s+)?$Type};
+	my $Attribute	= qr{__read_mostly|__init|__initdata};
 
 	foreach my $line (@lines) {
 		$linenr++;
@@ -321,6 +335,7 @@ sub process {
 # blank context lines so we need to count that too.
 		if ($line =~ /^( |\+|$)/) {
 			$realline++;
+			$realcnt-- if ($realcnt != 0);
 
 			# track any sort of multi-line comment.  Obviously if
 			# the added text or context do not include the whole
@@ -345,8 +360,9 @@ sub process {
 			# Track the previous line.
 			($prevline, $stashline) = ($stashline, $line);
 			($previndent, $stashindent) = ($stashindent, $indent);
+		} elsif ($realcnt == 1) {
+			$realcnt--;
 		}
-		$realcnt-- if ($realcnt != 0);
 
 #make up the handle for any error we report on this line
 		$here = "#$linenr: ";
@@ -357,14 +373,11 @@ sub process {
 		my $hereprev = "$here\n$prevline\n$line\n\n";
 
 #check the patch for a signoff:
-		if ($line =~ /^\s*Signed-off-by:\s/) {
-			$signoff++;
-
-		} elsif ($line =~ /^\s*signed-off-by:/i) {
+		if ($line =~ /^\s*signed-off-by:/i) {
 			# This is a signoff, if ugly, so do not double report.
 			$signoff++;
 			if (!($line =~ /^\s*Signed-off-by:/)) {
-				print "use Signed-off-by:\n";
+				print "Signed-off-by: is the preferred form\n";
 				print "$herecurr";
 				$clean = 0;
 			}
@@ -389,7 +402,7 @@ sub process {
 		next if ($realfile !~ /\.(h|c|s|S|pl|sh)$/);
 
 #trailing whitespace
-		if ($line=~/^\+.*\S\s+$/) {
+		if ($line =~ /^\+.*\S\s+$/ || $line =~ /^\+\s+$/) {
 			my $herevet = "$here\n" . cat_vet($line) . "\n\n";
 			print "trailing whitespace\n";
 			print "$herevet";
@@ -525,24 +538,23 @@ sub process {
 		}
 
 # * goes on variable not on type
-		if ($line =~ m{[A-Za-z\d_]+(\*+) [A-Za-z\d_]+}) {
-			print "\"foo$1 bar\" should be \"foo $1bar\"\n";
+		if ($line =~ m{\($NonptrType(\*+)(?:\s+const)?\)}) {
+			print "\"(foo$1)\" should be \"(foo $1)\"\n";
 			print "$herecurr";
 			$clean = 0;
-		}
-		if ($line =~ m{$Type (\*) [A-Za-z\d_]+} ||
-		    $line =~ m{[A-Za-z\d_]+ (\*\*+) [A-Za-z\d_]+}) {
-			print "\"foo $1 bar\" should be \"foo $1bar\"\n";
+
+		} elsif ($line =~ m{\($NonptrType\s+(\*+)(?!\s+const)\s+\)}) {
+			print "\"(foo $1 )\" should be \"(foo $1)\"\n";
 			print "$herecurr";
 			$clean = 0;
-		}
-		if ($line =~ m{\([A-Za-z\d_\s]+[A-Za-z\d_](\*+)\)}) {
-			print "\"(foo$1)\" should be \"(foo $1)\"\n";
+
+		} elsif ($line =~ m{$NonptrType(\*+)(?:\s+const)?\s+[A-Za-z\d_]+}) {
+			print "\"foo$1 bar\" should be \"foo $1bar\"\n";
 			print "$herecurr";
 			$clean = 0;
-		}
-		if ($line =~ m{\([A-Za-z\d_\s]+[A-Za-z\d_]\s+(\*+)\s+\)}) {
-			print "\"(foo $1 )\" should be \"(foo $1)\"\n";
+
+		} elsif ($line =~ m{$NonptrType\s+(\*+)(?!\s+const)\s+[A-Za-z\d_]+}) {
+			print "\"foo $1 bar\" should be \"foo $1bar\"\n";
 			print "$herecurr";
 			$clean = 0;
 		}
@@ -581,7 +593,7 @@ sub process {
 
 # function brace can't be on same line, except for #defines of do while,
 # or if closed on same line
-		if (($line=~/[A-Za-z\d_]+\**\s+\**[A-Za-z\d_]+\(.*\).* {/) and
+		if (($line=~/$Type\s*[A-Za-z\d_]+\(.*\).* {/) and
 		    !($line=~/\#define.*do\s{/) and !($line=~/}/)) {
 			print "braces following function declarations go on the next line\n";
 			print "$herecurr";
@@ -624,7 +636,7 @@ sub process {
 				my $ca = substr($opline, $off - 1, 1);
 				my $cc = '';
 				if (length($opline) >= ($off + length($elements[$n + 1]))) {
-					$cc = substr($opline, $off + length($elements[$n + 1]), 1);
+					$cc = substr($opline, $off + length($elements[$n + 1]));
 				}
 
 				my $ctx = "${a}x${c}";
@@ -636,8 +648,16 @@ sub process {
 
 				##print "<$s1:$op:$s2> <$elements[$n]:$elements[$n + 1]:$elements[$n + 2]>\n";
 
-				# We need ; as an operator.  // is a comment.
-				if ($op eq ';' or $op eq '//') {
+				# ; should have either the end of line or a space or \ after it
+				if ($op eq ';') {
+					if ($ctx !~ /.x[WE]/ && $cc !~ /^\\/) {
+						print "need space after that '$op' $at\n";
+						print "$hereptr";
+						$clean = 0;
+					}
+
+				# // is a comment
+				} elsif ($op eq '//') {
 
 				# -> should have no spaces
 				} elsif ($op eq '->') {
@@ -649,7 +669,7 @@ sub process {
 
 				# , must have a space on the right.
 				} elsif ($op eq ',') {
-					if ($ctx !~ /.xW|.xE/ && $cc ne '}') {
+					if ($ctx !~ /.xW|.xE/ && $cc !~ /^}/) {
 						print "need space after that '$op' $at\n";
 						print "$hereptr";
 						$clean = 0;
@@ -670,12 +690,12 @@ sub process {
 
 				# unary ++ and unary -- are allowed no space on one side.
 				} elsif ($op eq '++' or $op eq '--') {
-					if ($ctx !~ /[WOB]x[^W]/ && $ctx !~ /[^W]x[WOB]/) {
+					if ($ctx !~ /[WOB]x[^W]/ && $ctx !~ /[^W]x[WOBE]/) {
 						print "need space one side of that '$op' $at\n";
 						print "$hereptr";
 						$clean = 0;
 					}
-					if ($ctx =~ /Wx./ && $cc eq ';') {
+					if ($ctx =~ /Wx./ && $cc =~ /^;/) {
 						print "no space before that '$op' $at\n";
 						print "$hereptr";
 						$clean = 0;
@@ -707,7 +727,7 @@ sub process {
 				#
 				} elsif ($op eq '*') {
 					if ($ca eq '*') {
-						if ($cc =~ /\s/) {
+						if ($cc =~ /^\s(?!\s*const)/) {
 							print "no space after that '$op' $at\n";
 							print "$hereptr";
 							$clean = 0;
@@ -803,7 +823,7 @@ sub process {
 
 # if/while/etc brace do not go on next line, unless defining a do while loop,
 # or if that brace on the next line is for something else
-		if ($prevline=~/\b(if|while|for|switch)\s*\(/) {
+		if ($prevline=~/\b(?:(if|while|for|switch)\s*\(|do\b|else\b)/) {
 			my @opened = $prevline=~/\(/g;
 			my @closed = $prevline=~/\)/g;
 			my $nr_line = $linenr;
@@ -823,14 +843,22 @@ sub process {
 				@closed = $prevline=~/\)/g;
 			}
 
-			if (($prevline=~/\b(if|while|for|switch)\s*\(.*\)\s*$/) and ($next_line=~/{/) and
-			   !($next_line=~/\b(if|while|for|switch)/) and !($next_line=~/\#define.*do.*while/)) {
+			if (($prevline=~/\b(?:(if|while|for|switch)\s*\(.*\)|do|else)\s*$/) and ($next_line=~/{/) and
+			   !($next_line=~/\b(?:if|while|for|switch|do|else)\b/) and !($next_line=~/\#define.*do.*while/)) {
 				print "That { should be on the previous line\n";
 				print "$here\n$display_segment\n$next_line\n\n";
 				$clean = 0;
 			}
 		}
 
+# if and else should not have general statements after it
+		if ($line =~ /^.\s*(?:}\s*)?else\b(.*)/ &&
+		    $1 !~ /^\s*(?:\sif|{|$)/) {
+			print "trailing statements should be on next line\n";
+			print "$herecurr";
+			$clean = 0;
+		}
+
 # multi-statement macros should be enclosed in a do while loop, grab the
 # first statement and ensure its the whole macro if its not enclosed
 # in a known goot container
@@ -841,11 +869,22 @@ sub process {
 			# Grab the first statement, if that is the entire macro
 			# its ok.  This may start either on the #define line
 			# or the one below.
-			my $ctx1 = join('', ctx_statement($linenr - 1, $realcnt + 1));
-			my $ctx2 = join('', ctx_statement($linenr, $realcnt));
+			my $ln = $linenr;
+			my $cnt = $realcnt;
 
-			if ($ctx1 =~ /\\$/ && $ctx2 =~ /\\$/) {
-				print "Macros with multiple statements should be enclosed in a do - while loop\n";
+			# If the macro starts on the define line start there.
+			if ($prevline !~ m{^.#\s*define\s*$Ident(?:\([^\)]*\))?\s*\\\s*$}) {
+				$ln--;
+				$cnt++;
+			}
+			my $ctx = join('', ctx_statement($ln, $cnt));
+
+			if ($ctx =~ /\\$/) {
+				if ($ctx =~ /;/) {
+					print "Macros with multiple statements should be enclosed in a do - while loop\n";
+				} else {
+					print "Macros with complex values should be enclosed in parenthesis\n";
+				}
 				print "$hereprev";
 				$clean = 0;
 			}
