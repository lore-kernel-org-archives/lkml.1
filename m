Return-Path: <linux-kernel-owner+w=401wt.eu-S1756489AbYJWLJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489AbYJWLJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 07:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753708AbYJWLG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 07:06:59 -0400
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:50753 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023AbYJWLGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 07:06:55 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 8/9] checkpatch: dissallow spaces between stars in pointer types
Date: Thu, 23 Oct 2008 12:06:38 +0100
Message-Id: <1224759999-21389-9-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.2.711.gf1ba4
In-Reply-To: <1224759999-21389-1-git-send-email-apw@shadowen.org>
References: <1224759999-21389-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disallow spaces within multiple pointer stars (*) in both casts and
definitions.  Both of these would now be reported:

	(char * *)
	char * *foo;

Also now consistently detects and reports the attributes within these
structures making the error report itself clearer.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |   48 +++++++++++++++++++++++++++++++++---------------
 1 files changed, 33 insertions(+), 15 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 5acc48a..7cc7473 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -191,7 +191,7 @@ sub build_types {
 		  }x;
 	$Type	= qr{
 			$NonptrType
-			(?:\s*\*+\s*const|\s*\*+|(?:\s*\[\s*\])+)?
+			(?:[\s\*]+\s*const|[\s\*]+|(?:\s*\[\s*\])+)?
 			(?:\s+$Inline|\s+$Modifier)*
 		  }x;
 	$Declare	= qr{(?:$Storage\s+)?$Type};
@@ -1344,7 +1344,7 @@ sub process {
 			}
 
 			# any (foo ... *) is a pointer cast, and foo is a type
-			while ($s =~ /\(($Ident)(?:\s+$Sparse)*\s*\*+\s*\)/sg) {
+			while ($s =~ /\(($Ident)(?:\s+$Sparse)*[\s\*]+\s*\)/sg) {
 				possible($1, "C:" . $s);
 			}
 
@@ -1618,21 +1618,39 @@ sub process {
 		}
 
 # * goes on variable not on type
-		if ($line =~ m{\($NonptrType(\*+)(?:\s+const)?\)}) {
-			ERROR("\"(foo$1)\" should be \"(foo $1)\"\n" .
-				$herecurr);
+		# (char*[ const])
+		if ($line =~ m{\($NonptrType(\s*\*[\s\*]*(?:$Modifier\s*)*)\)}) {
+			my ($from, $to) = ($1, $1);
 
-		} elsif ($line =~ m{\($NonptrType\s+(\*+)(?!\s+const)\s+\)}) {
-			ERROR("\"(foo $1 )\" should be \"(foo $1)\"\n" .
-				$herecurr);
+			# Should start with a space.
+			$to =~ s/^(\S)/ $1/;
+			# Should not end with a space.
+			$to =~ s/\s+$//;
+			# '*'s should not have spaces between.
+			while ($to =~ s/(.)\s\*/$1\*/) {
+			}
 
-		} elsif ($line =~ m{\b$NonptrType(\*+)(?:\s+(?:$Attribute|$Sparse))?\s+[A-Za-z\d_]+}) {
-			ERROR("\"foo$1 bar\" should be \"foo $1bar\"\n" .
-				$herecurr);
+			#print "from<$from> to<$to>\n";
+			if ($from ne $to) {
+				ERROR("\"(foo$from)\" should be \"(foo$to)\"\n" .  $herecurr);
+			}
+		} elsif ($line =~ m{\b$NonptrType(\s*\*[\s\*]*(?:$Modifier\s*)?)($Ident)}) {
+			my ($from, $to, $ident) = ($1, $1, $2);
 
-		} elsif ($line =~ m{\b$NonptrType\s+(\*+)(?!\s+(?:$Attribute|$Sparse))\s+[A-Za-z\d_]+}) {
-			ERROR("\"foo $1 bar\" should be \"foo $1bar\"\n" .
-				$herecurr);
+			# Should start with a space.
+			$to =~ s/^(\S)/ $1/;
+			# Should not end with a space.
+			$to =~ s/\s+$//;
+			# '*'s should not have spaces between.
+			while ($to =~ s/(.)\s\*/$1\*/) {
+			}
+			# Modifiers should have spaces.
+			$to =~ s/(\b$Modifier$)/$1 /;
+
+			#print "from<$from> to<$to>\n";
+			if ($from ne $to) {
+				ERROR("\"foo${from}bar\" should be \"foo${to}bar\"\n" .  $herecurr);
+			}
 		}
 
 # # no BUG() or BUG_ON()
-- 
1.6.0.2.711.gf1ba4

