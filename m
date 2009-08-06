Return-Path: <linux-kernel-owner+w=401wt.eu-S1753868AbZHFCol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868AbZHFCol (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 22:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753678AbZHFCnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 22:43:53 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:3240 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620AbZHFCnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 22:43:52 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Julia Lawall <julia@diku.dk>,
       Greg KH <greg@kroah.com>
Subject: [PATCH 5/7] scripts/get_maintainer.pl: Add .mailmap use, shell and email cleanups
Date: Wed,  5 Aug 2009 19:43:46 -0700
Message-Id: <b444d1912ea51559ebb622518ed22353f50893a6.1249525834.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1249525834.git.joe@perches.com>
References: <cover.1249525834.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add reading and using .mailmap file if it exists
Convert address entries in .mailmap to first encountered address
Don't terminate shell commands with \n
Strip characters found after sign-offs by: name <address> [stripped]

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/get_maintainer.pl |   72 ++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 65 insertions(+), 7 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 969c8fd..1422bf3 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -152,6 +152,36 @@ while (<MAINT>) {
 }
 close(MAINT);
 
+my %mailmap;
+
+open(MAILMAP, "<${lk_path}.mailmap") || warn "$P: Can't open .mailmap\n";
+while (<MAILMAP>) {
+    my $line = $_;
+
+    next if ($line =~ m/^\s*#/);
+    next if ($line =~ m/^\s*$/);
+
+    my ($name, $address) = parse_email($line);
+    $line = format_email($name, $address);
+
+    next if ($line =~ m/^\s*$/);
+
+    if (exists($mailmap{$name})) {
+	my $obj = $mailmap{$name};
+	push(@$obj, $address);
+    } else {
+	my @arr = ($address);
+	$mailmap{$name} = \@arr;
+    }
+}
+close(MAILMAP);
+
+foreach my $name (sort {$mailmap{$a} <=> $mailmap{$b}} keys %mailmap) {
+    my $obj = $mailmap{$name};
+    foreach my $address (@$obj) {
+    }
+}
+
 ## use the filenames on the command line or find the filenames in the patchfiles
 
 my @files = ();
@@ -403,12 +433,12 @@ sub parse_email {
     my $name = "";
     my $address = "";
 
-    if ($formatted_email =~ /^([^<]+)<(.*\@.*)>$/) {
+    if ($formatted_email =~ /^([^<]+)<(.*\@.*)>.*$/) {
 	$name = $1;
 	$address = $2;
-    } elsif ($formatted_email =~ /^<(.*\@.*)>$/) {
+    } elsif ($formatted_email =~ /^\s*<(.*\@.*)>.*$/) {
 	$address = $1;
-    } elsif ($formatted_email =~ /^(.*\@.*)$/) {
+    } elsif ($formatted_email =~ /^\s*(.*\@.*)$/) {
 	$address = $1;
     }
 
@@ -557,6 +587,29 @@ sub which {
     return "";
 }
 
+sub mailmap {
+    my @lines = @_;
+    my %hash;
+
+    foreach my $line (@lines) {
+	my ($name, $address) = parse_email($line);
+	if (!exists($hash{$name})) {
+	    $hash{$name} = $address;
+	}
+	if (exists($mailmap{$name})) {
+	    my $obj = $mailmap{$name};
+	    foreach my $map_address (@$obj) {
+		if (($map_address eq $address) &&
+		    ($map_address ne $hash{$name})) {
+		    $line = format_email($name, $hash{$name});
+		}
+	    }
+	}
+    }
+
+    return @lines;
+}
+
 sub recent_git_signoffs {
     my ($file) = @_;
 
@@ -592,9 +645,10 @@ sub recent_git_signoffs {
     # cut -f2- -d":"
     s/.*:\s*(.+)\s*/$1/ for (@lines);
 
+    $total_sign_offs = @lines;
+
     @lines = mailmap(@lines);
 
-    $total_sign_offs = @lines;
     @lines = sort(@lines);
     # uniq -c
     foreach my $line (@lines) {
@@ -655,12 +709,12 @@ sub git_assign_blame {
 	    my $diff_start = $2;
 	    my $diff_length = $3;
 	    next if (!("$file" eq "$diff_file"));
-	    $cmd = "git blame -l -L $diff_start,+$diff_length $file\n";
+	    $cmd = "git blame -l -L $diff_start,+$diff_length $file";
 	    @commits = save_commits($cmd, @commits);
 	}
     } else {
 	if (-f $file) {
-	    $cmd = "git blame -l $file\n";
+	    $cmd = "git blame -l $file";
 	    @commits = save_commits($cmd, @commits);
 	}
     }
@@ -678,11 +732,15 @@ sub git_assign_blame {
 	if (!$email_git_penguin_chiefs) {
 	    @lines = grep(!/${penguin_chiefs}/i, @lines);
 	}
+
 	# cut -f2- -d":"
 	s/.*:\s*(.+)\s*/$1/ for (@lines);
 
-	$hash{$_}++ for @lines;
 	$total_sign_offs += @lines;
+
+	@lines = mailmap(@lines);
+
+	$hash{$_}++ for @lines;
     }
 
     $count = 0;
-- 
1.6.3.1.10.g659a0.dirty

