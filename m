Return-Path: <linux-kernel-owner+w=401wt.eu-S1751349AbZHCENu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349AbZHCENu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 00:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750845AbZHCENu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 00:13:50 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1461 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbZHCENt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 00:13:49 -0400
Subject: [RFC PATCH] scripts/get_maintainer.pl: Add optional "git blame"
 checking
From: Joe Perches <joe@perches.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Julia Lawall <julia@diku.dk>, Vegard Nossum <vegard.nossum@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0908021908441.18361@ask.diku.dk>
References: <Pine.LNX.4.64.0908021049350.15557@ask.diku.dk>
	 <20090802135122.GA15279@liondog.tnic>
	 <1249229645.22466.153.camel@Joe-Laptop.home>
	 <Pine.LNX.4.64.0908021822350.18361@ask.diku.dk>
	 <1249232640.22466.184.camel@Joe-Laptop.home>
	 <Pine.LNX.4.64.0908021908441.18361@ask.diku.dk>
Content-Type: text/plain
Date: Sun, 02 Aug 2009 21:13:46 -0700
Message-Id: <1249272826.22466.217.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-08-02 at 19:08 +0200, Julia Lawall wrote:
> Perhaps someone who recently signed a patch 
> should only be included if they modified a line that is near a line
> modified by the current patch?

Julia Lawall sent me a private email suggesting that
get_maintainers.pl should have the capability to include
signatories of commits that are modified by a particular patch.

Vegard Nossum did something similar once.
http://lkml.org/lkml/2008/5/29/449

Such a capability is provided with the patch below.
It can be enabled with the "--git-blame" command line option.

The modified script looks the commits for all lines in the
patch, and includes the "-by:" signatories for those commits.
It uses the same git-min-percent, git-max-maintainers, and
git-min-signatures options.  git-since is ignored.

It can be used independently from the --git default, so
	./scripts/get_maintainers.pl --nogit --git-blame <patch>
or
	./scripts/get_maintainers.pl --nogit --git-blame -f <file>
is acceptable.

If used with -f <file>, all lines/commits for the file are
checked.

It can be slow if used with -f <file>

Signed-off-by: Joe Perches <joe@perches.com>

 scripts/get_maintainer.pl |  133 ++++++++++++++++++++++++++++++++++++---------
 1 files changed, 106 insertions(+), 27 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 278a45b..34dc4b3 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -13,7 +13,7 @@
 use strict;
 
 my $P = $0;
-my $V = '0.17';
+my $V = '0.18beta2';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -29,6 +29,7 @@ my $email_git_min_signatures = 1;
 my $email_git_max_maintainers = 5;
 my $email_git_min_percent = 5;
 my $email_git_since = "1-year-ago";
+my $email_git_blame = 0;
 my $output_multiline = 1;
 my $output_separator = ", ";
 my $scm = 0;
@@ -68,6 +69,7 @@ if (!GetOptions(
 		'git-max-maintainers=i' => \$email_git_max_maintainers,
 		'git-min-percent=i' => \$email_git_min_percent,
 		'git-since=s' => \$email_git_since,
+		'git-blame!' => \$email_git_blame,
 		'm!' => \$email_maintainer,
 		'n!' => \$email_usename,
 		'l!' => \$email_list,
@@ -150,6 +152,7 @@ close(MAINT);
 ## use the filenames on the command line or find the filenames in the patchfiles
 
 my @files = ();
+my @range = ();
 
 foreach my $file (@ARGV) {
     ##if $file is a directory and it lacks a trailing slash, add one
@@ -162,13 +165,19 @@ foreach my $file (@ARGV) {
 	push(@files, $file);
     } else {
 	my $file_cnt = @files;
+	my $lastfile;
 	open(PATCH, "<$file") or die "$P: Can't open ${file}\n";
 	while (<PATCH>) {
 	    if (m/^\+\+\+\s+(\S+)/) {
 		my $filename = $1;
 		$filename =~ s@^[^/]*/@@;
 		$filename =~ s@\n@@;
+		$lastfile = $filename;
 		push(@files, $filename);
+	    } elsif (m/^\@\@ -(\d+),(\d+)/) {
+		if ($email_git_blame) {
+		    push(@range, "$lastfile:$1:$2");
+		}
 	    }
 	}
 	close(PATCH);
@@ -226,6 +235,9 @@ foreach my $file (@files) {
 	recent_git_signoffs($file);
     }
 
+    if ($email && $email_git_blame) {
+	git_assign_blame($file);
+    }
 }
 
 if ($email) {
@@ -311,6 +323,7 @@ MAINTAINER field selection options:
     --git-max-maintainers => maximum maintainers to add (default: 5)
     --git-min-percent => minimum percentage of commits required (default: 5)
     --git-since => git history to use (default: 1-year-ago)
+    --git-blame => use git blame to find modified commits for patch or file
     --m => include maintainer(s) if any
     --n => include name 'Full Name <addr\@domain.tld>'
     --l => include list(s) if any
@@ -333,13 +346,15 @@ Other options:
 
 Notes:
   Using "-f directory" may give unexpected results:
-
-  Used with "--git", git signators for _all_ files in and below
-     directory are examined as git recurses directories.
-     Any specified X: (exclude) pattern matches are _not_ ignored.
-  Used with "--nogit", directory is used as a pattern match,
-     no individual file within the directory or subdirectory
-     is matched.
+      Used with "--git", git signators for _all_ files in and below
+          directory are examined as git recurses directories.
+          Any specified X: (exclude) pattern matches are _not_ ignored.
+      Used with "--nogit", directory is used as a pattern match,
+         no individual file within the directory or subdirectory
+         is matched.
+      Used with "--git-blame", does not iterate all files in directory
+  Using "--git-blame" is slow and may add old committers and authors
+      that are no longer active maintainers to the output.
 EOT
 }
 
@@ -449,14 +464,19 @@ sub push_email_address {
     my ($email_address) = @_;
 
     my $email_name = "";
-    if ($email_address =~ m/([^<]+)<(.*\@.*)>$/) {
-	$email_name = $1;
-	$email_address = $2;
-    }
 
     if ($email_maintainer) {
-	if ($email_usename && $email_name) {
-	    push(@email_to, format_email($email_name, $email_address));
+	if ($email_address =~ m/([^<]+)<(.*\@.*)>$/) {
+	    $email_name = $1;
+	    $email_address = $2;
+	    if ($email_usename) {
+		push(@email_to, format_email($email_name, $email_address));
+	    } else {
+		push(@email_to, $email_address);
+	    }
+	} elsif ($email_address =~ m/<(.+)>/) {
+	    $email_address = $1;
+	    push(@email_to, $email_address);
 	} else {
 	    push(@email_to, $email_address);
 	}
@@ -545,20 +565,79 @@ sub recent_git_signoffs {
 		last;
 	    }
 	}
-	if ($line =~ m/(.+)<(.+)>/) {
-	    my $git_name = $1;
-	    my $git_addr = $2;
-	    if ($email_usename) {
-		push(@email_to, format_email($git_name, $git_addr));
-	    } else {
-		push(@email_to, $git_addr);
-	    }
-	} elsif ($line =~ m/<(.+)>/) {
-	    my $git_addr = $1;
-	    push(@email_to, $git_addr);
-	} else {
-	    push(@email_to, $line);
+	push_email_address($line);
+    }
+}
+
+sub save_commits {
+    my ($cmd, @commits) = @_;
+    my $output;
+    my @lines = ();
+
+    $output = `${cmd}`;
+
+    @lines = split("\n", $output);
+    foreach my $line (@lines) {
+	if ($line =~ m/^(\w+) /) {
+	    push (@commits, $1);
+	}
+    }
+    return @commits;
+}
+
+sub git_assign_blame {
+    my ($file) = @_;
+
+    my @lines = ();
+    my @commits = ();
+    my $cmd;
+    my $output;
+    my %hash;
+    my $total_sign_offs;
+    my $count;
+
+    if (@range) {
+	foreach my $file_range_diff (@range) {
+	    next if (!($file_range_diff =~ m/(.+):(.+):(.+)/));
+	    my $diff_file = $1;
+	    my $diff_start = $2;
+	    my $diff_length = $3;
+	    next if (!("$file" eq "$diff_file"));
+	    $cmd = "git blame -l -L $diff_start,+$diff_length $file\n";
+	    @commits = save_commits($cmd, @commits);
 	}
+    } else {
+	if (-f $file) {
+	    $cmd = "git blame -l $file\n";
+	    @commits = save_commits($cmd, @commits);
+	}
+    }
+
+    $total_sign_offs = 0;
+    @commits = uniq(@commits);
+    foreach my $commit (@commits) {
+	$cmd = "git log -1 ${commit}";
+	$cmd .= " | grep -Ei \"^[-_ 	a-z]+by:.*\\\@.*\$\"";
+	if (!$email_git_penguin_chiefs) {
+	    $cmd .= " | grep -Ev \"${penguin_chiefs}\"";
+	}
+	$cmd .= " | cut -f2- -d\":\"";
+
+	$output = `${cmd}`;
+	$output =~ s/^\s*//gm;
+	@lines = split("\n", $output);
+	$hash{$_}++ for @lines;
+	$total_sign_offs += @lines;
+    }
+
+    $count = 0;
+    foreach my $line (sort {$hash{$b} <=> $hash{$a}} keys %hash) {
+	my $sign_offs = $hash{$line};
+	$count++;
+	last if ($sign_offs < $email_git_min_signatures ||
+		 $count > $email_git_max_maintainers ||
+		 $sign_offs * 100 / $total_sign_offs < $email_git_min_percent);
+	push_email_address($line);
     }
 }
 


