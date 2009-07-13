Return-Path: <linux-kernel-owner+w=401wt.eu-S1757397AbZGMVPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397AbZGMVPO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 17:15:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757326AbZGMVPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 17:15:12 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4032 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757291AbZGMVPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 17:15:07 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 15/16] scripts/get_maintainer.pl: Add -f directory use
Date: Mon, 13 Jul 2009 14:15:01 -0700
Message-Id: <81ee6196ccaf3a5f123b25d05d9291b30ef8d402.1247517374.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1247517373.git.joe@perches.com>
References: <cover.1247517373.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't require a specific file in a directory
to be tested.

Also Arnd Bergmann pointed out that the MAINTAINERS
pattern requirement that directory patterns have a
trailing slash was unnecessary and was likely to be
error prone.  Removed that requirement.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/get_maintainer.pl |   23 +++++++++++++++++++----
 1 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 3e73314..7fc09fc 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -13,7 +13,7 @@
 use strict;
 
 my $P = $0;
-my $V = '0.16';
+my $V = '0.17';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -132,6 +132,10 @@ while (<MAINT>) {
 	    $value =~ s@\.@\\\.@g;       ##Convert . to \.
 	    $value =~ s/\*/\.\*/g;       ##Convert * to .*
 	    $value =~ s/\?/\./g;         ##Convert ? to .
+	    ##if pattern is a directory and it lacks a trailing slash, add one
+	    if ((-d $value)) {
+		$value =~ s@([^/])$@$1/@;
+	    }
 	}
 	push(@typevalue, "$type:$value");
     } elsif (!/^(\s)*$/) {
@@ -146,8 +150,10 @@ close(MAINT);
 my @files = ();
 
 foreach my $file (@ARGV) {
-    next if ((-d $file));
-    if (!(-f $file)) {
+    ##if $file is a directory and it lacks a trailing slash, add one
+    if ((-d $file)) {
+	$file =~ s@([^/])$@$1/@;
+    } elsif (!(-f $file)) {
 	die "$P: file '${file}' not found\n";
     }
     if ($from_filename) {
@@ -292,7 +298,7 @@ sub file_match_pattern {
 sub usage {
     print <<EOT;
 usage: $P [options] patchfile
-       $P [options] -f file
+       $P [options] -f file|directory
 version: $V
 
 MAINTAINER field selection options:
@@ -322,6 +328,15 @@ Other options:
   --version => show version
   --help => show this help information
 
+Notes:
+  Using "-f directory" may give unexpected results:
+
+  Used with "--git", git signators for _all_ files in and below
+     directory are examined as git recurses directories.
+     Any specified X: (exclude) pattern matches are _not_ ignored.
+  Used with "--nogit", directory is used as a pattern match,
+     no individual file within the directory or subdirectory
+     is matched.
 EOT
 }
 
-- 
1.6.3.1.10.g659a0.dirty

