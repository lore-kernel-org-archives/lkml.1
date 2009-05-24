Return-Path: <linux-kernel-owner+w=401wt.eu-S1757528AbZEXCiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528AbZEXCiq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 22:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755123AbZEXCiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 22:38:04 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1426 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209AbZEXCiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 22:38:01 -0400
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 03/18] scripts/get_maintainer.pl - improve --git-chief-penquins (Linus Torvalds) filtering
Date: Sat, 23 May 2009 19:37:34 -0700
Message-Id: <f1771e4ac81c06a818e282cfc969f12d2b9e0fa4.1243131992.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1243131992.git.joe@perches.com>
References: <cover.1243131992.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moved linux-kernel@vger.kernel.org to MAINTAINERS
lkml will be added to all CC lists via F: pattern match

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/get_maintainer.pl |   27 ++++++++++++---------------
 1 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index f302ad3..e733e87 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -216,16 +216,20 @@ foreach my $file (@files) {
 
 }
 
-if ($email_git_penguin_chiefs) {
+if ($email) {
     foreach my $chief (@penguin_chief) {
 	if ($chief =~ m/^(.*):(.*)/) {
-	    my $chief_name = $1;
-	    my $chief_addr = $2;
+	    my $email_address;
 	    if ($email_usename) {
-		push(@email_to, format_email($chief_name, $chief_addr));
+		$email_address = format_email($1, $2);
 	    } else {
-		push(@email_to, $chief_addr);
+		$email_address = $2;
 	    }
+	    if ($email_git_penguin_chiefs) {
+		push(@email_to, $email_address);
+	    } else {
+		@email_to = grep(!/${email_address}/, @email_to);
+	    }		
 	}
     }
 }
@@ -236,10 +240,7 @@ if ($email || $email_list) {
 	@to = (@to, @email_to);
     }
     if ($email_list) {
-	if (@list_to == 0) {
-	    push(@list_to, "linux-kernel\@vger.kernel.org");
 	@to = (@to, @list_to);
-	}
     }
     output(uniq(@to));
 }
@@ -314,7 +315,7 @@ Default options:
   [--email --git --m --n --l --multiline]
 
 Other options:
-  --version -> show version
+  --version => show version
   --help => show this help information
 
 EOT
@@ -423,7 +424,7 @@ sub add_categories {
 sub which {
     my ($bin) = @_;
 
-    foreach my $path (split /:/, $ENV{PATH}) {
+    foreach my $path (split(/:/, $ENV{PATH})) {
 	if (-e "$path/$bin") {
 	    return "$path/$bin";
 	}
@@ -446,12 +447,8 @@ sub recent_git_signoffs {
     }
 
     $cmd = "git log --since=${email_git_since} -- ${file}";
-    $cmd .= " | grep -Pi \"^[-_ 	a-z]+by:.*\\\@\"";
-    if (!$email_git_penguin_chiefs) {
-	$cmd .= " | grep -Pv \"${penguin_chiefs}\"";
-    }
+    $cmd .= " | grep -Pi \"^[-_ 	a-z]+by:.*\\\@.*\$\"";
     $cmd .= " | cut -f2- -d\":\"";
-    $cmd .= " | sed -e \"s/^\\s+//g\"";
     $cmd .= " | sort | uniq -c | sort -rn";
 
     $output = `${cmd}`;
-- 
1.6.3.1.10.g659a0.dirty

