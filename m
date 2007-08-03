Return-Path: <linux-kernel-owner+w=401wt.eu-S1763874AbXHCQJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763874AbXHCQJK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 12:09:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762897AbXHCQI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 12:08:59 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4929 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762894AbXHCQI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 12:08:57 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] update checkpatch.pl to version 0.09
Message-ID: <6d2af3f498ec3592be33ae9d740e5ce5@pinky>
Date: Fri, 03 Aug 2007 17:21:32 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This version brings a number of new checks, and a number of bug
fixes.  Of note:

  - checks for spacing on round and square bracket combinations
  - loosening of the single statement brace checks, to allow
    them when they contain comments or where other blocks in a
    compound statement have them.
  - parks the multple declaration support
  - allows architecture defines in architecture specific headers

Andy Whitcroft (21):
      Version: 0.09
      loosen single statement brace checks
      fix up multiple declaration to avoid function arguments
      add some function space parenthesis check exceptions
      handle EXPORT_'s with parentheses in their names
      clean up some warnings in multi-line macro bracketing support
      park the multiple declaration checks
      make block brace checks count comments as a statement
      __volatile__ and __extension__ are not functions
      allow architecture specific defined within architecture includes
      check spacing on square brackets
      check spacing on parentheses
      ensure we apply checks to the part before start comment
      check #ifdef conditional spacing
      handle __init_refok and __must_check
      add noinline to inline checks
      prevent email addresses from tripping spacing checks
      handle typed initialiser spacing
      handle line contination as end of line
      add bool to the type matcher
      refine EXPORT_SYMBOL checks to handle pointers

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
Latest version at the following URL:

    http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/

 scripts/checkpatch.pl |  102 ++++++++++++++++++++++++++++++++++---------------
 1 files changed, 71 insertions(+), 31 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 73751ab..4081fcb 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -9,7 +9,7 @@ use strict;
 my $P = $0;
 $P =~ s@.*/@@g;
 
-my $V = '0.08';
+my $V = '0.09';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -311,7 +311,7 @@ sub process {
 
 	my $Ident	= qr{[A-Za-z\d_]+};
 	my $Storage	= qr{extern|static};
-	my $Sparse	= qr{__user|__kernel|__force|__iomem};
+	my $Sparse	= qr{__user|__kernel|__force|__iomem|__must_check|__init_refok};
 	my $NonptrType	= qr{
 				\b
 				(?:const\s+)?
@@ -325,6 +325,7 @@ sub process {
 					unsigned|
 					float|
 					double|
+					bool|
 					long\s+int|
 					long\s+long|
 					long\s+long\s+int|
@@ -340,7 +341,8 @@ sub process {
 			  }x;
 	my $Type	= qr{
 				\b$NonptrType\b
-				(?:\s*\*+\s*const|\s*\*+)?
+				(?:\s*\*+\s*const|\s*\*+|(?:\s*\[\s*\])+)?
+				(?:\s+$Sparse)*
 			  }x;
 	my $Declare	= qr{(?:$Storage\s+)?$Type};
 	my $Attribute	= qr{const|__read_mostly|__init|__initdata|__meminit};
@@ -494,16 +496,15 @@ sub process {
 			ERROR("use tabs not spaces\n" . $herevet);
 		}
 
-		#
-		# The rest of our checks refer specifically to C style
-		# only apply those _outside_ comments.
-		#
-		next if ($in_comment);
-
 # Remove comments from the line before processing.
-		$line =~ s@/\*.*\*/@@g;
-		$line =~ s@/\*.*@@;
-		$line =~ s@.*\*/@@;
+		my $comment_edge = ($line =~ s@/\*.*\*/@@g) +
+				   ($line =~ s@/\*.*@@) +
+				   ($line =~ s@^(.).*\*/@$1@);
+
+# The rest of our checks refer specifically to C style
+# only apply those _outside_ comments.  Only skip
+# lines in the middle of comments.
+		next if (!$comment_edge && $in_comment);
 
 # Standardise the strings and chars within the input to simplify matching.
 		$line = sanitise_line($line);
@@ -599,7 +600,7 @@ sub process {
 			if (($prevline !~ /^}/) &&
 			   ($prevline !~ /^\+}/) &&
 			   ($prevline !~ /^ }/) &&
-			   ($prevline !~ /\s$name(?:\s+$Attribute)?\s*(?:;|=)/)) {
+			   ($prevline !~ /\b\Q$name\E(?:\s+$Attribute)?\s*(?:;|=)/)) {
 				WARN("EXPORT_SYMBOL(foo); should immediately follow its function/variable\n" . $herecurr);
 			}
 		}
@@ -680,9 +681,9 @@ sub process {
 
 # check for spaces between functions and their parentheses.
 		if ($line =~ /($Ident)\s+\(/ &&
-		    $1 !~ /^(?:if|for|while|switch|return|volatile)$/ &&
+		    $1 !~ /^(?:if|for|while|switch|return|volatile|__volatile__|__attribute__|format|__extension__|Copyright)$/ &&
 		    $line !~ /$Type\s+\(/ && $line !~ /^.\#\s*define\b/) {
-			ERROR("no space between function name and open parenthesis '('\n" . $herecurr);
+			WARN("no space between function name and open parenthesis '('\n" . $herecurr);
 		}
 # Check operator spacing.
 		# Note we expand the line with the leading + as the real
@@ -712,6 +713,7 @@ sub process {
 					$c = 'W' if ($elements[$n + 2] =~ /^\s/);
 					$c = 'B' if ($elements[$n + 2] =~ /^(\)|\]|;)/);
 					$c = 'O' if ($elements[$n + 2] eq '');
+					$c = 'E' if ($elements[$n + 2] =~ /\s*\\$/);
 				} else {
 					$c = 'E';
 				}
@@ -812,7 +814,11 @@ sub process {
 
 				# All the others need spaces both sides.
 				} elsif ($ctx !~ /[EW]x[WE]/) {
-					ERROR("need spaces around that '$op' $at\n" . $hereptr);
+					# Ignore email addresses <foo@bar>
+					if (!($op eq '<' && $cb =~ /$;\S+\@\S+>/) &&
+					    !($op eq '>' && $cb =~ /<\S+\@\S+$;/)) {
+						ERROR("need spaces around that '$op' $at\n" . $hereptr);
+					}
 				}
 				$off += length($elements[$n + 1]);
 			}
@@ -823,15 +829,24 @@ sub process {
 			WARN("multiple assignments should be avoided\n" . $herecurr);
 		}
 
-# check for multiple declarations, allowing for a function declaration
-# continuation.
-		if ($line =~ /^.\s*$Type\s+$Ident(?:\s*=[^,{]*)?\s*,\s*$Ident.*/ &&
-		    $line !~ /^.\s*$Type\s+$Ident(?:\s*=[^,{]*)?\s*,\s*$Type\s*$Ident.*/) {
-			WARN("declaring multiple variables together should be avoided\n" . $herecurr);
-		}
+## # check for multiple declarations, allowing for a function declaration
+## # continuation.
+## 		if ($line =~ /^.\s*$Type\s+$Ident(?:\s*=[^,{]*)?\s*,\s*$Ident.*/ &&
+## 		    $line !~ /^.\s*$Type\s+$Ident(?:\s*=[^,{]*)?\s*,\s*$Type\s*$Ident.*/) {
+## 
+## 			# Remove any bracketed sections to ensure we do not
+## 			# falsly report the parameters of functions.
+## 			my $ln = $line;
+## 			while ($ln =~ s/\([^\(\)]*\)//g) {
+## 			}
+## 			if ($ln =~ /,/) {
+## 				WARN("declaring multiple variables together should be avoided\n" . $herecurr);
+## 			}
+## 		}
 
 #need space before brace following if, while, etc
-		if ($line =~ /\(.*\){/ || $line =~ /do{/) {
+		if (($line =~ /\(.*\){/ && $line !~ /\($Type\){/) ||
+		    $line =~ /do{/) {
 			ERROR("need a space before the open brace '{'\n" . $herecurr);
 		}
 
@@ -841,6 +856,22 @@ sub process {
 			ERROR("need a space after that close brace '}'\n" . $herecurr);
 		}
 
+# check spacing on square brackets
+		if ($line =~ /\[\s/ && $line !~ /\[\s*$/) {
+			ERROR("no space after that open square bracket '['\n" . $herecurr);
+		}
+		if ($line =~ /\s\]/) {
+			ERROR("no space before that close square bracket ']'\n" . $herecurr);
+		}
+
+# check spacing on paretheses
+		if ($line =~ /\(\s/ && $line !~ /\(\s*$/) {
+			ERROR("no space after that open parenthesis '('\n" . $herecurr);
+		}
+		if ($line =~ /\s\)/) {
+			ERROR("no space before that close parenthesis ')'\n" . $herecurr);
+		}
+
 #goto labels aren't indented, allow a single space however
 		if ($line=~/^.\s+[A-Za-z\d_]+:(?![0-9]+)/ and
 		   !($line=~/^. [A-Za-z\d_]+:/) and !($line=~/^.\s+default:/)) {
@@ -910,7 +941,7 @@ sub process {
 			# grabbing the statement after the identifier
 			$prevline =~ m{^(.#\s*define\s*$Ident(?:\([^\)]*\))?\s*)(.*)\\\s*$};
 			##print "1<$1> 2<$2>\n";
-			if ($2 ne '') {
+			if (defined $2 && $2 ne '') {
 				$off = length($1);
 				$ln--;
 				$cnt++;
@@ -950,8 +981,10 @@ sub process {
 				my ($lvl, @block) = ctx_block_level($nr, $cnt);
 
 				my $stmt = join(' ', @block);
-				$stmt =~ s/^[^{]*{//;
-				$stmt =~ s/}[^}]*$//;
+				$stmt =~ s/(^[^{]*){//;
+				my $before = $1;
+				$stmt =~ s/}([^}]*$)//;
+				my $after = $1;
 
 				#print "block<" . join(' ', @block) . "><" . scalar(@block) . ">\n";
 				#print "stmt<$stmt>\n\n";
@@ -963,12 +996,14 @@ sub process {
 				# Also nested if's often require braces to
 				# disambiguate the else binding so shhh there.
 				my @semi = ($stmt =~ /;/g);
+				push(@semi, "/**/") if ($stmt =~ m@/\*@);
 				##print "semi<" . scalar(@semi) . ">\n";
 				if ($lvl == 0 && scalar(@semi) < 2 &&
-				    $stmt !~ /{/ && $stmt !~ /\bif\b/) {
+				    $stmt !~ /{/ && $stmt !~ /\bif\b/ &&
+				    $before !~ /}/ && $after !~ /{/) {
 				    	my $herectx = "$here\n" . join("\n", @control, @block[1 .. $#block]) . "\n";
 				    	shift(@block);
-					ERROR("braces {} are not necessary for single statement blocks\n" . $herectx);
+					WARN("braces {} are not necessary for single statement blocks\n" . $herectx);
 				}
 			}
 		}
@@ -1013,6 +1048,11 @@ sub process {
 #			$clean = 0;
 #		}
 
+# warn about spacing in #ifdefs
+		if ($line =~ /^.#\s*(ifdef|ifndef|elif)\s\s+/) {
+			ERROR("exactly one space required after that #$1\n" . $herecurr);
+		}
+
 # check for spinlock_t definitions without a comment.
 		if ($line =~ /^.\s*(struct\s+mutex|spinlock_t)\s+\S+;/) {
 			my $which = $1;
@@ -1027,14 +1067,14 @@ sub process {
 			}
 		}
 # check of hardware specific defines
-		if ($line =~ m@^.#\s*if.*\b(__i386__|__powerpc64__|__sun__|__s390x__)\b@) {
+		if ($line =~ m@^.#\s*if.*\b(__i386__|__powerpc64__|__sun__|__s390x__)\b@ && $realfile !~ m@include/asm-@) {
 			CHK("architecture specific defines should be avoided\n" .  $herecurr);
 		}
 
 # check the location of the inline attribute, that it is between
 # storage class and type.
-		if ($line =~ /$Type\s+(?:inline|__always_inline)\b/ ||
-		    $line =~ /\b(?:inline|always_inline)\s+$Storage/) {
+		if ($line =~ /$Type\s+(?:inline|__always_inline|noinline)\b/ ||
+		    $line =~ /\b(?:inline|__always_inline|noinline)\s+$Storage/) {
 			ERROR("inline keyword should sit between storage class and type\n" . $herecurr);
 		}
 
