Return-Path: <linux-kernel-owner+w=401wt.eu-S1758246AbZEXCji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246AbZEXCji (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 22:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756250AbZEXCiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 22:38:09 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1430 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484AbZEXCiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 22:38:03 -0400
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 07/18] scripts/get_maintainer.pl - Support both "P:/M:" and integrated "M:" lines
Date: Sat, 23 May 2009 19:37:38 -0700
Message-Id: <136e58c251157179f19a7eecedd1e6fe71a3e6d9.1243131992.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1243131992.git.joe@perches.com>
References: <cover.1243131992.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/get_maintainer.pl |   30 ++++++++++++++++++++++--------
 1 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 9ea2db0..33872c7 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -55,7 +55,7 @@ foreach my $chief (@penguin_chief) {
 }
 my $penguin_chiefs = "\(" . join("|",@penguin_chief_names) . "\)";
 
-# rfc822 - preloaded methods go here.
+# rfc822 email address - preloaded methods go here.
 my $rfc822_lwsp = "(?:(?:\\r\\n)?[ \\t])";
 my $rfc822_char = '[\\000-\\177]';
 
@@ -396,7 +396,19 @@ sub add_categories {
 		    }
 		}
 	    } elsif ($ptype eq "M") {
-		if ($email_maintainer) {
+		my $p_used = 0;
+		if ($index >= 0) {
+		    my $tv = $typevalue[$index - 1];
+		    if ($tv =~ m/^(\C):\s*(.*)/) {
+			if ($1 eq "P") {
+			    if ($email_usename) {
+				push_email_address(format_email($2, $pvalue));
+				$p_used = 1;
+			    }
+			}
+		    }
+		}
+		if (!$p_used) {
 		    push_email_addresses($pvalue);
 		}
 	    } elsif ($ptype eq "T") {
@@ -436,13 +448,16 @@ sub push_email_addresses {
 
     my @address_list = ();
 
-    if (@address_list = rfc822_validlist($address)) {
+    if (rfc822_valid($address)) {
+	push_email_address($address);
+    } elsif (@address_list = rfc822_validlist($address)) {
 	my $array_count = shift(@address_list);
 	while (my $entry = shift(@address_list)) {
 	    push_email_address($entry);
 	}
+    } else {
+	warn("Invalid MAINTAINERS address: '" . $address . "'\n");
     }
-
 }
 
 sub which {
@@ -471,9 +486,8 @@ sub recent_git_signoffs {
 	return;
     }
     if (!(-d ".git")) {
-	warn("$P: .git repository not found.\n");
-	warn("Use a .git repository for better results.\n");
-	warn("ie: git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git\n");
+	warn("$P: .git directory not found.  Use a git repository for better results.\n");
+	warn("$P: perhaps 'git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git'\n");
 	return;
     }
 
@@ -632,7 +646,7 @@ sub rfc822_validlist ($) {
     my @r;
     if ($s =~ m/^(?:$rfc822re)?(?:,(?:$rfc822re)?)*$/so &&
 	$s =~ m/^$rfc822_char*$/) {
-        while($s =~ m/(?:^|,$rfc822_lwsp*)($rfc822re)/gos) {
+        while ($s =~ m/(?:^|,$rfc822_lwsp*)($rfc822re)/gos) {
             push @r, $1;
         }
         return wantarray ? (scalar(@r), @r) : 1;
-- 
1.6.3.1.10.g659a0.dirty

