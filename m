Return-Path: <linux-kernel-owner+w=401wt.eu-S1753859AbYJCP0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbYJCP0R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 11:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbYJCP0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 11:26:01 -0400
Received: from tallyho.bytemark.co.uk ([80.68.81.166]:57476 "EHLO
	tallyho.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbYJCP0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 11:26:00 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 01/13] checkpatch: do is not a possible type
Date: Fri,  3 Oct 2008 16:25:42 +0100
Message-Id: <1223047554-31111-2-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.1.451.gc8d31
In-Reply-To: <1223047554-31111-1-git-send-email-apw@shadowen.org>
References: <1223047554-31111-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A do without braces '{' may trigger a false possible type 'do' and then this
may be interpreted as an external definition of foo():

	do
		foo();
	while (bar);

Add do to the type exclusions.  Fix up tests so we can check for them.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |   24 ++++++++++++++++++------
 1 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 118fe1f..6b21188 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -913,12 +913,22 @@ sub annotate_values {
 sub possible {
 	my ($possible, $line) = @_;
 
-	print "CHECK<$possible> ($line)\n" if ($dbg_possible > 1);
-	if ($possible !~ /^(?:$Modifier|$Storage|$Type|DEFINE_\S+)$/ &&
-	    $possible ne 'goto' && $possible ne 'return' &&
-	    $possible ne 'case' && $possible ne 'else' &&
-	    $possible ne 'asm' && $possible ne '__asm__' &&
-	    $possible !~ /^(typedef|struct|enum)\b/) {
+	print "CHECK<$possible> ($line)\n" if ($dbg_possible > 2);
+	if ($possible !~ /(?:
+		^(?:
+			$Modifier|
+			$Storage|
+			$Type|
+			DEFINE_\S+|
+			goto|
+			return|
+			case|
+			else|
+			asm|__asm__|
+			do
+		)$|
+		^(?:typedef|struct|enum)\b
+	    )/x) {
 		# Check for modifiers.
 		$possible =~ s/\s*$Storage\s*//g;
 		$possible =~ s/\s*$Sparse\s*//g;
@@ -936,6 +946,8 @@ sub possible {
 			push(@typeList, $possible);
 		}
 		build_types();
+	} else {
+		warn "NOTPOSS: $possible ($line)\n" if ($dbg_possible > 1);
 	}
 }
 
-- 
1.6.0.1.451.gc8d31

