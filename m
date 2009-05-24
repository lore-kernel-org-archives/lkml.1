Return-Path: <linux-kernel-owner+w=401wt.eu-S1757869AbZEXCjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869AbZEXCjO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 22:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755763AbZEXCiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 22:38:06 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1428 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468AbZEXCiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 22:38:01 -0400
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 01/18] scripts/get_maintainer.pl - Output first field only in mailing lists and after maintainers.
Date: Sat, 23 May 2009 19:37:32 -0700
Message-Id: <1b5753510699329f9d0a6ea06151a1327b4b4305.1243131992.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1243131992.git.joe@perches.com>
References: <cover.1243131992.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix mailing lists that are described, but not "(subscriber-only)"

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/get_maintainer.pl |   46 ++++++++++++++++++++++++++------------------
 1 files changed, 27 insertions(+), 19 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 60dc0c4..c4b25a7 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -13,7 +13,7 @@
 use strict;
 
 my $P = $0;
-my $V = '0.15';
+my $V = '0.16';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -169,6 +169,7 @@ foreach my $file (@ARGV) {
 }
 
 my @email_to = ();
+my @list_to = ();
 my @scm = ();
 my @web = ();
 my @subsystem = ();
@@ -182,7 +183,7 @@ foreach my $file (@files) {
 
     my $exclude = 0;
     foreach my $line (@typevalue) {
-	if ($line =~ m/^(\C):(.*)/) {
+	if ($line =~ m/^(\C):\s*(.*)/) {
 	    my $type = $1;
 	    my $value = $2;
 	    if ($type eq 'X') {
@@ -196,7 +197,7 @@ foreach my $file (@files) {
     if (!$exclude) {
 	my $tvi = 0;
 	foreach my $line (@typevalue) {
-	    if ($line =~ m/^(\C):(.*)/) {
+	    if ($line =~ m/^(\C):\s*(.*)/) {
 		my $type = $1;
 		my $value = $2;
 		if ($type eq 'F') {
@@ -229,15 +230,18 @@ if ($email_git_penguin_chiefs) {
     }
 }
 
-if ($email) {
-    my $address_cnt = @email_to;
-    if ($address_cnt == 0 && $email_list) {
-	push(@email_to, "linux-kernel\@vger.kernel.org");
+if ($email || $email_list) {
+    my @to = ();
+    if ($email) {
+	@to = (@to, @email_to);
     }
-
-#Don't sort email address list, but do remove duplicates
-    @email_to = uniq(@email_to);
-    output(@email_to);
+    if ($email_list) {
+	if (@list_to == 0) {
+	    push(@list_to, "linux-kernel\@vger.kernel.org");
+	@to = (@to, @list_to);
+	}
+    }
+    output(uniq(@to));
 }
 
 if ($scm) {
@@ -307,7 +311,7 @@ Output type options:
   --multiline => print 1 entry per line
 
 Default options:
-  [--email --git --m --l --multiline]
+  [--email --git --m --n --l --multiline]
 
 Other options:
   --version -> show version
@@ -366,26 +370,30 @@ sub add_categories {
     $index = $index - 1;
     while ($index >= 0) {
 	my $tv = $typevalue[$index];
-	if ($tv =~ m/^(\C):(.*)/) {
+	if ($tv =~ m/^(\C):\s*(.*)/) {
 	    my $ptype = $1;
 	    my $pvalue = $2;
 	    if ($ptype eq "L") {
-		my $subscr = $pvalue;
-		if ($subscr =~ m/\s*\(subscribers-only\)/) {
+		my $list_address = $pvalue;
+		my $list_additional = "";
+		if ($list_address =~ m/([^\s]+)\s+(.*)$/) {
+		    $list_address = $1;
+		    $list_additional = $2;
+		}
+		if ($list_additional =~ m/\(subscribers-only\)/) {
 		    if ($email_subscriber_list) {
-			$subscr =~ s/\s*\(subscribers-only\)//g;
-			push(@email_to, $subscr);
+			push(@list_to, $list_address);
 		    }
 		} else {
 		    if ($email_list) {
-			push(@email_to, $pvalue);
+			push(@list_to, $list_address);
 		    }
 		}
 	    } elsif ($ptype eq "M") {
 		if ($email_maintainer) {
 		    if ($index >= 0) {
 			my $tv = $typevalue[$index - 1];
-			if ($tv =~ m/^(\C):(.*)/) {
+			if ($tv =~ m/^(\C):\s*(.*)/) {
 			    if ($1 eq "P" && $email_usename) {
 				push(@email_to, format_email($2, $pvalue));
 			    } else {
-- 
1.6.3.1.10.g659a0.dirty

