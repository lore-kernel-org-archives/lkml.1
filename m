Return-Path: <linux-kernel-owner+w=401wt.eu-S932514AbYGBLds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932514AbYGBLds (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 07:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932299AbYGBLdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 07:33:25 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2921 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228AbYGBLdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 07:33:24 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 2/5] checkpatch: variants -- move the main unary/binary operators to use variants
Date: Wed,  2 Jul 2008 12:31:15 +0100
Message-Id: <1214998278-11767-3-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.5.6.1.201.g3e7d3
In-Reply-To: <1214998278-11767-1-git-send-email-apw@shadowen.org>
References: <1214998278-11767-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have a variants system, move to using that to carry the
unary/binary designation for +, -, &, and *.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |   36 ++++++++++++++++++------------------
 1 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 88027f2..8afa88a 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -858,6 +858,19 @@ sub annotate_values {
 			print "CLOSE($1)\n" if ($dbg_values > 1);
 			$type = 'N';
 
+		} elsif ($cur =~ /^(-(?![->])|\+(?!\+)|\*|\&(?!\&))/o) {
+			my $variant;
+
+			print "OPV($1)\n" if ($dbg_values > 1);
+			if ($type eq 'V') {
+				$variant = 'B';
+			} else {
+				$variant = 'U';
+			}
+
+			substr($var, length($res), 1, $variant);
+			$type = 'N';
+
 		} elsif ($cur =~ /^($Operators)/o) {
 			print "OP($1)\n" if ($dbg_values > 1);
 			if ($1 ne '++' && $1 ne '--') {
@@ -1573,22 +1586,8 @@ sub process {
 				my $ptr = substr($blank, 0, $off) . "^";
 				my $hereptr = "$hereline$ptr\n";
 
-				# Classify operators into binary, unary, or
-				# definitions (* only) where they have more
-				# than one mode.
+				# Pull out the value of this operator.
 				my $op_type = substr($curr_values, $off + 1, 1);
-				my $op_left = substr($curr_values, $off, 1);
-				my $is_unary;
-				if ($op_type eq 'T') {
-					$is_unary = 2;
-				} elsif ($op_left eq 'V') {
-					$is_unary = 0;
-				} else {
-					$is_unary = 1;
-				}
-				#if ($op eq '-' || $op eq '&' || $op eq '*') {
-				#	print "UNARY: <$op_left$op_type $is_unary $a:$op:$c> <$ca:$op:$cc> <$unary_ctx>\n";
-				#}
 
 				# Get the full operator variant.
 				my $opv = $op . substr($curr_vars, $off, 1);
@@ -1625,18 +1624,19 @@ sub process {
 					}
 
 				# '*' as part of a type definition -- reported already.
-				} elsif ($op eq '*' && $is_unary == 2) {
+				} elsif ($opv eq '*_') {
 					#warn "'*' is part of type\n";
 
 				# unary operators should have a space before and
 				# none after.  May be left adjacent to another
 				# unary operator, or a cast
 				} elsif ($op eq '!' || $op eq '~' ||
-				         ($is_unary && ($op eq '*' || $op eq '-' || $op eq '&'))) {
+					 $opv eq '*U' || $opv eq '-U' ||
+					 $opv eq '&U') {
 					if ($ctx !~ /[WEBC]x./ && $ca !~ /(?:\)|!|~|\*|-|\&|\||\+\+|\-\-|\{)$/) {
 						ERROR("space required before that '$op' $at\n" . $hereptr);
 					}
-					if ($op  eq '*' && $cc =~/\s*const\b/) {
+					if ($op eq '*' && $cc =~/\s*const\b/) {
 						# A unary '*' may be const
 
 					} elsif ($ctx =~ /.xW/) {
-- 
1.5.6.1.201.g3e7d3

