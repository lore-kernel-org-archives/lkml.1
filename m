Return-Path: <linux-kernel-owner+w=401wt.eu-S1757384AbZGMVPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384AbZGMVPN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 17:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757350AbZGMVPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 17:15:12 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4035 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757326AbZGMVPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 17:15:07 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 16/16] get_maintainer.pl: Add git-min-percent option
Date: Mon, 13 Jul 2009 14:15:02 -0700
Message-Id: <1913d57db46d11a33dfac5b0322125204b57ee97.1247517374.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1247517373.git.joe@perches.com>
References: <cover.1247517373.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow an option to control the minimum percentage
of sign-offs required before being considered
a maintainer.

git-min-percent has a default value of 5

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/get_maintainer.pl |   19 ++++++++++++++++---
 1 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 7fc09fc..61ef275 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -27,6 +27,7 @@ my $email_git = 1;
 my $email_git_penguin_chiefs = 0;
 my $email_git_min_signatures = 1;
 my $email_git_max_maintainers = 5;
+my $email_git_min_percent = 5;
 my $email_git_since = "1-year-ago";
 my $output_multiline = 1;
 my $output_separator = ", ";
@@ -65,6 +66,7 @@ if (!GetOptions(
 		'git-chief-penguins!' => \$email_git_penguin_chiefs,
 		'git-min-signatures=i' => \$email_git_min_signatures,
 		'git-max-maintainers=i' => \$email_git_max_maintainers,
+		'git-min-percent=i' => \$email_git_min_percent,
 		'git-since=s' => \$email_git_since,
 		'm!' => \$email_maintainer,
 		'n!' => \$email_usename,
@@ -307,6 +309,7 @@ MAINTAINER field selection options:
     --git-chief-penguins => include ${penguin_chiefs}
     --git-min-signatures => number of signatures required (default: 1)
     --git-max-maintainers => maximum maintainers to add (default: 5)
+    --git-min-percent => minimum percentage of commits required (default: 0)
     --git-since => git history to use (default: 1-year-ago)
     --m => include maintainer(s) if any
     --n => include name 'Full Name <addr\@domain.tld>'
@@ -497,6 +500,7 @@ sub recent_git_signoffs {
     my $output = "";
     my $count = 0;
     my @lines = ();
+    my $total_sign_offs;
 
     if (which("git") eq "") {
 	warn("$P: git not found.  Add --nogit to options?\n");
@@ -520,17 +524,26 @@ sub recent_git_signoffs {
     $output =~ s/^\s*//gm;
 
     @lines = split("\n", $output);
+
+    $total_sign_offs = 0;
+    foreach my $line (@lines) {
+	if ($line =~ m/([0-9]+)\s+(.*)/) {
+	    $total_sign_offs += $1;
+	} else {
+	    die("$P: Unexpected git output: ${line}\n");
+	}
+    }
+
     foreach my $line (@lines) {
 	if ($line =~ m/([0-9]+)\s+(.*)/) {
 	    my $sign_offs = $1;
 	    $line = $2;
 	    $count++;
 	    if ($sign_offs < $email_git_min_signatures ||
-	        $count > $email_git_max_maintainers) {
+	        $count > $email_git_max_maintainers ||
+		$sign_offs * 100 / $total_sign_offs < $email_git_min_percent) {
 		last;
 	    }
-	} else {
-	    die("$P: Unexpected git output: ${line}\n");
 	}
 	if ($line =~ m/(.+)<(.+)>/) {
 	    my $git_name = $1;
-- 
1.6.3.1.10.g659a0.dirty

