Return-Path: <linux-kernel-owner+w=401wt.eu-S1760269AbYFLMKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760269AbYFLMKn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 08:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760131AbYFLMIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 08:08:01 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4321 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760190AbYFLMH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 08:07:57 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 03/23] checkpatch: types: some types may also be identifiers
Date: Thu, 12 Jun 2008 13:05:42 +0100
Message-Id: <1213272362-19457-4-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.5.6.rc0.140.ga9675
In-Reply-To: <1213272362-19457-1-git-send-email-apw@shadowen.org>
References: <1213272362-19457-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some types such as typedefs may overlap real identifiers.  Be more
targetted about when a type can really exist.  Where it cannot let it be
an identifier.  This prevents false reporting of the minus '-' in unary
context in the following:

	foo[bar->bool - 1];

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 83ae37b..5420db6 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -171,6 +171,7 @@ our @modifierList = (
 sub build_types {
 	my $mods = "(?:  \n" . join("|\n  ", @modifierList) . "\n)";
 	my $all = "(?:  \n" . join("|\n  ", @typeList) . "\n)";
+	$Modifier	= qr{(?:$Attribute|$Sparse|$mods)};
 	$NonptrType	= qr{
 			(?:const\s+)?
 			(?:$mods\s+)?
@@ -178,15 +179,14 @@ sub build_types {
 				(?:typeof|__typeof__)\s*\(\s*\**\s*$Ident\s*\)|
 				(?:${all}\b)
 			)
-			(?:\s+$Sparse|\s+const)*
+			(?:\s+$Modifier|\s+const)*
 		  }x;
 	$Type	= qr{
 			$NonptrType
 			(?:\s*\*+\s*const|\s*\*+|(?:\s*\[\s*\])+)?
-			(?:\s+$Inline|\s+$Sparse|\s+$Attribute|\s+$mods)*
+			(?:\s+$Inline|\s+$Modifier)*
 		  }x;
 	$Declare	= qr{(?:$Storage\s+)?$Type};
-	$Modifier	= qr{(?:$Attribute|$Sparse|$mods)};
 }
 build_types();
 
@@ -715,7 +715,7 @@ sub annotate_values {
 				$av_preprocessor = 0;
 			}
 
-		} elsif ($cur =~ /^($Type)/) {
+		} elsif ($cur =~ /^($Type)\s*(?:$Ident|,|\))/) {
 			print "DECLARE($1)\n" if ($dbg_values > 1);
 			$type = 'T';
 
@@ -800,8 +800,9 @@ sub annotate_values {
 				print "PAREN('$1')\n" if ($dbg_values > 1);
 			}
 
-		} elsif ($cur =~ /^($Ident)\(/o) {
+		} elsif ($cur =~ /^($Ident)\s*\(/o) {
 			print "FUNC($1)\n" if ($dbg_values > 1);
+			$type = 'V';
 			$av_pending = 'V';
 
 		} elsif ($cur =~ /^($Ident|$Constant)/o) {
-- 
1.5.6.rc0.140.ga9675

