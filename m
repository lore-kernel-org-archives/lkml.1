Return-Path: <linux-kernel-owner+w=401wt.eu-S1762041AbXJEQ4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762041AbXJEQ4n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 12:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757912AbXJEQ4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 12:56:21 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:55210 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756558AbXJEQ4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 12:56:20 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: apw@shadowen.org, rdunlap@xenotime.net, jschopp@austin.ibm.com
Cc: linux-kernel@vger.kernel.org, Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 2/3] CHECKPATCH: add terse output option to checkpatch.pl
Date: Fri,  5 Oct 2007 12:56:07 -0400
Message-Id: <11916033691871-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11916033681196-git-send-email-ezk@cs.sunysb.edu>
References: <11916033681196-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Such terse output complies with g/cc and looks like

	file_name:line_number:error_message

This output can be easily parsed within text editors (e.g., emacs/vim) that
can produce a split text screen showing in one screen the error message, and
in another screen the corresponding source file, with the cursor placed on
the offending line.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 scripts/checkpatch.pl |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index ecbb030..f8bd630 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -18,12 +18,14 @@ my $tree = 1;
 my $chk_signoff = 1;
 my $chk_patch = 1;
 my $tst_type = 0;
+my $terse = 0;		# terse ouput: report using g/cc error style
 GetOptions(
 	'q|quiet'	=> \$quiet,
 	'tree!'		=> \$tree,
 	'signoff!'	=> \$chk_signoff,
 	'patch!'	=> \$chk_patch,
 	'test-type!'	=> \$tst_type,
+	't|terse'	=> \$terse,
 ) or exit;
 
 my $exit = 0;
@@ -34,6 +36,7 @@ if ($#ARGV < 0) {
 	print "options: -q           => quiet\n";
 	print "         --no-tree    => run without a kernel tree\n";
 	print "         --no-signoff => don't check for signed-off-by\n";
+	print "         -t           => report errors using terse cc-style output (implies -q)\n";
 	exit(1);
 }
 
@@ -267,7 +270,16 @@ sub cat_vet {
 
 my @report = ();
 sub report {
-	push(@report, $_[0]);
+	if (!$terse) {
+		push(@report, $_[0]);
+		return;
+	}
+	# if terse output, extract filename, linenumber, and short message;
+	# format them as a new one-line message and push onto report
+	my($msg, $location, @rest) = split(/\n/, $_[0]);
+	@rest = split(/: /, $location);
+	my($newreport) = sprintf("%s%s\n", $rest[2], $msg);
+	push(@report, $newreport);
 }
 sub report_dump {
 	@report;
@@ -1097,17 +1109,17 @@ sub process {
 	if ($chk_patch && !$is_patch) {
 		ERROR("Does not appear to be a unified-diff format patch\n");
 	}
-	if ($is_patch && $chk_signoff && $signoff == 0) {
+	if ($terse == 0 && $is_patch && $chk_signoff && $signoff == 0) {
 		ERROR("Missing Signed-off-by: line(s)\n");
 	}
 
 	if ($clean == 0 && ($chk_patch || $is_patch)) {
 		print report_dump();
 	}
-	if ($clean == 1 && $quiet == 0) {
+	if ($terse == 0 && $clean == 1 && $quiet == 0) {
 		print "Your patch has no obvious style problems and is ready for submission.\n"
 	}
-	if ($clean == 0 && $quiet == 0) {
+	if ($terse == 0 && $clean == 0 && $quiet == 0) {
 		print "Your patch has style problems, please review.  If any of these errors\n";
 		print "are false positives report them to the maintainer, see\n";
 		print "CHECKPATCH in MAINTAINERS.\n";
-- 
1.5.2.2

