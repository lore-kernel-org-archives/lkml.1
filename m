Return-Path: <linux-kernel-owner+w=401wt.eu-S1751490AbZJJGFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490AbZJJGFx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 02:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752756AbZJJGFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 02:05:43 -0400
Received: from mail.perches.com ([173.55.12.10]:2046 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542AbZJJGFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 02:05:41 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Wolfram Sang <w.sang@pengutronix.de>,
       Grant Likely <grant.likely@secretlab.ca>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: [PATCH 1/3] scripts/get_maintainer.pl: Add patch/file search for keywords
Date: Fri,  9 Oct 2009 23:05:02 -0700
Message-Id: <73a375fb516cc420fcff9a0489e29a5509fbf34e.1255153863.git.joe@perches.com>
X-Mailer: git-send-email 1.6.5.rc3.dirty
In-Reply-To: <cover.1255153863.git.joe@perches.com>
References: <cover.1255153863.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on an idea from Wolfram Sang <w.sang@pengutronix.de>

Add search for MAINTAINERS line "K:" regex pattern match in a patch or file
Matches are added after file pattern matches
Add --keywords command line switch (default 1, on)
Change version to 0.21

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/get_maintainer.pl |   37 +++++++++++++++++++++++++++++++++++--
 1 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index cdb44b6..102b766 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -13,7 +13,7 @@
 use strict;
 
 my $P = $0;
-my $V = '0.20';
+my $V = '0.21';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -37,6 +37,7 @@ my $scm = 0;
 my $web = 0;
 my $subsystem = 0;
 my $status = 0;
+my $keywords = 1;
 my $from_filename = 0;
 my $pattern_depth = 0;
 my $version = 0;
@@ -84,6 +85,7 @@ if (!GetOptions(
 		'scm!' => \$scm,
 		'web!' => \$web,
 		'pattern-depth=i' => \$pattern_depth,
+		'k|keywords!' => \$keywords,
 		'f|file' => \$from_filename,
 		'v|version' => \$version,
 		'h|help' => \$help,
@@ -132,6 +134,8 @@ if (!top_of_kernel_tree($lk_path)) {
 ## Read MAINTAINERS for type/value pairs
 
 my @typevalue = ();
+my %keyword_hash;
+
 open(MAINT, "<${lk_path}MAINTAINERS") || die "$P: Can't open MAINTAINERS\n";
 while (<MAINT>) {
     my $line = $_;
@@ -149,6 +153,8 @@ while (<MAINT>) {
 	    if ((-d $value)) {
 		$value =~ s@([^/])$@$1/@;
 	    }
+	} elsif ($type eq "K") {
+	    $keyword_hash{@typevalue} = $value;
 	}
 	push(@typevalue, "$type:$value");
     } elsif (!/^(\s)*$/) {
@@ -188,6 +194,7 @@ if ($email_remove_duplicates) {
 
 my @files = ();
 my @range = ();
+my @keyword_tvi = ();
 
 foreach my $file (@ARGV) {
     ##if $file is a directory and it lacks a trailing slash, add one
@@ -198,11 +205,24 @@ foreach my $file (@ARGV) {
     }
     if ($from_filename) {
 	push(@files, $file);
+	if (-f $file && $keywords) {
+	    open(FILE, "<$file") or die "$P: Can't open ${file}\n";
+	    while (<FILE>) {
+		my $patch_line = $_;
+		foreach my $line (keys %keyword_hash) {
+		    if ($patch_line =~ m/^.*$keyword_hash{$line}/x) {
+			push(@keyword_tvi, $line);
+		    }
+		}
+	    }
+	    close(FILE);
+	}
     } else {
 	my $file_cnt = @files;
 	my $lastfile;
 	open(PATCH, "<$file") or die "$P: Can't open ${file}\n";
 	while (<PATCH>) {
+	    my $patch_line = $_;
 	    if (m/^\+\+\+\s+(\S+)/) {
 		my $filename = $1;
 		$filename =~ s@^[^/]*/@@;
@@ -213,6 +233,12 @@ foreach my $file (@ARGV) {
 		if ($email_git_blame) {
 		    push(@range, "$lastfile:$1:$2");
 		}
+	    } elsif ($keywords) {
+		foreach my $line (keys %keyword_hash) {
+		    if ($patch_line =~ m/^[+-].*$keyword_hash{$line}/x) {
+			push(@keyword_tvi, $line);
+		    }
+		}
 	    }
 	}
 	close(PATCH);
@@ -286,6 +312,13 @@ foreach my $file (@files) {
     }
 }
 
+if ($keywords) {
+    @keyword_tvi = sort_and_uniq(@keyword_tvi);
+    foreach my $line (@keyword_tvi) {
+	add_categories($line);
+    }
+}
+
 if ($email) {
     foreach my $chief (@penguin_chief) {
 	if ($chief =~ m/^(.*):(.*)/) {
@@ -384,6 +417,7 @@ Output type options:
 
 Other options:
   --pattern-depth => Number of pattern directory traversals (default: 0 (all))
+  --keywords => scan patch for keywords (default: 1 (on))
   --version => show version
   --help => show this help information
 
@@ -486,7 +520,6 @@ sub format_email {
 }
 
 sub find_starting_index {
-
     my ($index) = @_;
 
     while ($index > 0) {
-- 
1.6.5.rc3.dirty

