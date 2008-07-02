Return-Path: <linux-kernel-owner+w=401wt.eu-S1763736AbYGBLeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763736AbYGBLeq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 07:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763851AbYGBLdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 07:33:32 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2924 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932354AbYGBLda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 07:33:30 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 1/5] checkpatch: add checks for question mark and colon spacing
Date: Wed,  2 Jul 2008 12:31:14 +0100
Message-Id: <1214998278-11767-2-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.5.6.1.201.g3e7d3
In-Reply-To: <1214998278-11767-1-git-send-email-apw@shadowen.org>
References: <1214998278-11767-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add checks for the question mark colon operator spacing, and also check
the other uses of colon.  Colon means a number of things:

 - it introduces the else part of the ?: operator,
 - it terminates a goto label,
 - it terminates the case value,
 - it separates the identifier from the bit size on bit fields, and
 - it is used to introduce option types in asm().

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |   81 +++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 72 insertions(+), 9 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 8a3b0fd..88027f2 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -689,17 +689,20 @@ sub cat_vet {
 my $av_preprocessor = 0;
 my $av_pending;
 my @av_paren_type;
+my $av_pend_colon;
 
 sub annotate_reset {
 	$av_preprocessor = 0;
 	$av_pending = '_';
 	@av_paren_type = ('E');
+	$av_pend_colon = 'O';
 }
 
 sub annotate_values {
 	my ($stream, $type) = @_;
 
 	my $res;
+	my $var = '_' x length($stream);
 	my $cur = $stream;
 
 	print "$stream\n" if ($dbg_values > 1);
@@ -784,7 +787,12 @@ sub annotate_values {
 			$av_pending = 'N';
 			$type = 'N';
 
-		} elsif ($cur =~/^(return|case|else|goto)/o) {
+		} elsif ($cur =~/^(case)/o) {
+			print "CASE($1)\n" if ($dbg_values > 1);
+			$av_pend_colon = 'C';
+			$type = 'N';
+
+		} elsif ($cur =~/^(return|else|goto)/o) {
 			print "KEYWORD($1)\n" if ($dbg_values > 1);
 			$type = 'N';
 
@@ -809,6 +817,15 @@ sub annotate_values {
 			$type = 'V';
 			$av_pending = 'V';
 
+		} elsif ($cur =~ /^($Ident\s*):/) {
+			if ($type eq 'E') {
+				$av_pend_colon = 'L';
+			} elsif ($type eq 'T') {
+				$av_pend_colon = 'B';
+			}
+			print "IDENT_COLON($1,$type>$av_pend_colon)\n" if ($dbg_values > 1);
+			$type = 'V';
+
 		} elsif ($cur =~ /^($Ident|$Constant)/o) {
 			print "IDENT($1)\n" if ($dbg_values > 1);
 			$type = 'V';
@@ -820,8 +837,24 @@ sub annotate_values {
 		} elsif ($cur =~/^(;|{|})/) {
 			print "END($1)\n" if ($dbg_values > 1);
 			$type = 'E';
+			$av_pend_colon = 'O';
+
+		} elsif ($cur =~ /^(\?)/o) {
+			print "QUESTION($1)\n" if ($dbg_values > 1);
+			$type = 'N';
+
+		} elsif ($cur =~ /^(:)/o) {
+			print "COLON($1,$av_pend_colon)\n" if ($dbg_values > 1);
+
+			substr($var, length($res), 1, $av_pend_colon);
+			if ($av_pend_colon eq 'C' || $av_pend_colon eq 'L') {
+				$type = 'E';
+			} else {
+				$type = 'N';
+			}
+			$av_pend_colon = 'O';
 
-		} elsif ($cur =~ /^(;|\?|:|\[)/o) {
+		} elsif ($cur =~ /^(;|\[)/o) {
 			print "CLOSE($1)\n" if ($dbg_values > 1);
 			$type = 'N';
 
@@ -840,7 +873,7 @@ sub annotate_values {
 		}
 	}
 
-	return $res;
+	return ($res, $var);
 }
 
 sub possible {
@@ -1294,12 +1327,14 @@ sub process {
 
 		# Track the 'values' across context and added lines.
 		my $opline = $line; $opline =~ s/^./ /;
-		my $curr_values = annotate_values($opline . "\n", $prev_values);
+		my ($curr_values, $curr_vars) =
+				annotate_values($opline . "\n", $prev_values);
 		$curr_values = $prev_values . $curr_values;
 		if ($dbg_values) {
 			my $outline = $opline; $outline =~ s/\t/ /g;
 			print "$linenr > .$outline\n";
 			print "$linenr > $curr_values\n";
+			print "$linenr >  $curr_vars\n";
 		}
 		$prev_values = substr($curr_values, -1);
 
@@ -1490,7 +1525,8 @@ sub process {
 				<<=|>>=|<=|>=|==|!=|
 				\+=|-=|\*=|\/=|%=|\^=|\|=|&=|
 				=>|->|<<|>>|<|>|=|!|~|
-				&&|\|\||,|\^|\+\+|--|&|\||\+|-|\*|\/|%
+				&&|\|\||,|\^|\+\+|--|&|\||\+|-|\*|\/|%|
+				\?|:
 			}x;
 			my @elements = split(/($ops|;)/, $opline);
 			my $off = 0;
@@ -1554,6 +1590,9 @@ sub process {
 				#	print "UNARY: <$op_left$op_type $is_unary $a:$op:$c> <$ca:$op:$cc> <$unary_ctx>\n";
 				#}
 
+				# Get the full operator variant.
+				my $opv = $op . substr($curr_vars, $off, 1);
+
 				# Ignore operators passed as parameters.
 				if ($op_type ne 'V' &&
 				    $ca =~ /\s$/ && $cc =~ /^\s*,/) {
@@ -1571,8 +1610,10 @@ sub process {
 				# // is a comment
 				} elsif ($op eq '//') {
 
-				# -> should have no spaces
-				} elsif ($op eq '->') {
+				# No spaces for:
+				#   ->
+				#   :   when part of a bitfield
+				} elsif ($op eq '->' || $opv eq ':B') {
 					if ($ctx =~ /Wx.|.xW/) {
 						ERROR("spaces prohibited around that '$op' $at\n" . $hereptr);
 					}
@@ -1628,11 +1669,33 @@ sub process {
 							$hereptr);
 					}
 
+				# A colon needs no spaces before when it is
+				# terminating a case value or a label.
+				} elsif ($opv eq ':C' || $opv eq ':L') {
+					if ($ctx =~ /Wx./) {
+						ERROR("space prohibited before that '$op' $at\n" . $hereptr);
+					}
+
 				# All the others need spaces both sides.
 				} elsif ($ctx !~ /[EWC]x[CWE]/) {
+					my $ok = 0;
+
 					# Ignore email addresses <foo@bar>
-					if (!($op eq '<' && $cb =~ /$;\S+\@\S+>/) &&
-					    !($op eq '>' && $cb =~ /<\S+\@\S+$;/)) {
+					if (($op eq '<' &&
+					     $cc =~ /^\S+\@\S+>/) ||
+					    ($op eq '>' &&
+					     $ca =~ /<\S+\@\S+$/))
+					{
+					    	$ok = 1;
+					}
+
+					# Ignore ?:
+					if (($opv eq ':O' && $ca =~ /\?$/) ||
+					    ($op eq '?' && $cc =~ /^:/)) {
+					    	$ok = 1;
+					}
+
+					if ($ok == 0) {
 						ERROR("spaces required around that '$op' $at\n" . $hereptr);
 					}
 				}
-- 
1.5.6.1.201.g3e7d3

