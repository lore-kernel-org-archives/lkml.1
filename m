Return-Path: <linux-kernel-owner+w=401wt.eu-S1755085AbYHKUSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085AbYHKUSw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 16:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757626AbYHKUSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 16:18:17 -0400
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:41254 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757553AbYHKUSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 16:18:17 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 11/17] checkpatch: report any absolute references to kernel source files
Date: Mon, 11 Aug 2008 21:13:06 +0100
Message-Id: <1218485592-6679-12-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.rc1.258.g80295
In-Reply-To: <1218485592-6679-1-git-send-email-apw@shadowen.org>
References: <1218485592-6679-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Absolute references to kernel source files are generally only useful
locally to the originator of the patch.  Check for any such references
and report them.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |   41 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 9e7e9d1..cc61cf7 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -958,6 +958,33 @@ sub CHK {
 	}
 }
 
+sub check_absolute_file {
+	my ($absolute, $herecurr) = @_;
+	my $file = $absolute;
+
+	##print "absolute<$absolute>\n";
+
+	# See if any suffix of this path is a path within the tree.
+	while ($file =~ s@^[^/]*/@@) {
+		if (-f "$root/$file") {
+			##print "file<$file>\n";
+			last;
+		}
+	}
+	if (! -f _)  {
+		return 0;
+	}
+
+	# It is, so see if the prefix is acceptable.
+	my $prefix = $absolute;
+	substr($prefix, -length($file)) = '';
+
+	##print "prefix<$prefix>\n";
+	if ($prefix ne ".../") {
+		WARN("use relative pathname instead of absolute in changelog text\n" . $herecurr);
+	}
+}
+
 sub process {
 	my $filename = shift;
 
@@ -1168,6 +1195,20 @@ sub process {
 				$herecurr) if (!$emitted_corrupt++);
 		}
 
+# Check for absolute kernel paths.
+		if ($tree) {
+			while ($line =~ m{(?:^|\s)(/\S*)}g) {
+				my $file = $1;
+
+				if ($file =~ m{^(.*?)(?::\d+)+:?$} &&
+				    check_absolute_file($1, $herecurr)) {
+					#
+				} else {
+					check_absolute_file($file, $herecurr);
+				}
+			}
+		}
+
 # UTF-8 regex found at http://www.w3.org/International/questions/qa-forms-utf-8.en.php
 		if (($realfile =~ /^$/ || $line =~ /^\+/) &&
 		    $rawline !~ m/^$UTF8*$/) {
-- 
1.6.0.rc1.258.g80295

