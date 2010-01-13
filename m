Return-Path: <linux-kernel-owner+w=401wt.eu-S1751885Ab0AMSlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885Ab0AMSlI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 13:41:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750908Ab0AMSlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 13:41:06 -0500
Received: from mail.perches.com ([173.55.12.10]:1108 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765Ab0AMSlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 13:41:05 -0500
Subject: [PATCH] scripts/get_maintainer.pl: Add --sections, print entire
 matched subsystem
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Jan 2010 10:41:03 -0800
Message-ID: <1263408063.8011.116.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Print the complete contents of the matched subsystem in pattern
match depth order.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/get_maintainer.pl |   36 ++++++++++++++++++++++++++++++++----
 1 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 1762e6b..16846ce 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -41,6 +41,7 @@ my $web = 0;
 my $subsystem = 0;
 my $status = 0;
 my $keywords = 1;
+my $sections = 0;
 my $file_emails = 0;
 my $from_filename = 0;
 my $pattern_depth = 0;
@@ -121,6 +122,7 @@ if (!GetOptions(
 		'web!' => \$web,
 		'pattern-depth=i' => \$pattern_depth,
 		'k|keywords!' => \$keywords,
+		'sections!' => \$sections,
 		'fe|file-emails!' => \$file_emails,
 		'f|file' => \$from_filename,
 		'v|version' => \$version,
@@ -152,10 +154,20 @@ if ($output_rolestats) {
     $output_roles = 1;
 }
 
-my $selections = $email + $scm + $status + $subsystem + $web;
-if ($selections == 0) {
-    usage();
-    die "$P:  Missing required option: email, scm, status, subsystem or web\n";
+if ($sections) {
+    $email = 0;
+    $email_list = 0;
+    $scm = 0;
+    $status = 0;
+    $subsystem = 0;
+    $web = 0;
+    $keywords = 0;
+} else {
+    my $selections = $email + $scm + $status + $subsystem + $web;
+    if ($selections == 0) {
+	usage();
+	die "$P:  Missing required option: email, scm, status, subsystem or web\n";
+    }
 }
 
 if ($email &&
@@ -346,6 +358,21 @@ foreach my $file (@files) {
 	}
 	foreach my $line (sort {$hash{$b} <=> $hash{$a}} keys %hash) {
 	    add_categories($line);
+	    if ($sections) {
+		my $i;
+		my $start = find_starting_index($line);
+		my $end = find_ending_index($line);
+		for ($i = $start; $i < $end; $i++) {
+		    my $line = $typevalue[$i];
+		    if ($line =~ /^[FX]:/) {		##Restore file patterns
+			$line =~ s/([^\\])\.([^\*])/$1\?$2/g;
+			$line =~ s/([^\\])\.$/$1\?/g;	##Convert . back to ?
+			$line =~ s/\\\./\./g;       	##Convert \. to .
+			$line =~ s/\.\*/\*/g;       	##Convert .* to *
+		    }
+		    print("$line\n");
+		}
+	    }
 	}
     }
 
@@ -476,6 +503,7 @@ Output type options:
 Other options:
   --pattern-depth => Number of pattern directory traversals (default: 0 (all))
   --keywords => scan patch for keywords (default: 1 (on))
+  --sections => print the entire subsystem sections with pattern matches
   --version => show version
   --help => show this help information
 


