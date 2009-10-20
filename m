Return-Path: <linux-kernel-owner+w=401wt.eu-S1751158AbZJTU5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751158AbZJTU5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 16:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750937AbZJTU5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 16:57:39 -0400
Received: from mail.perches.com ([173.55.12.10]:2277 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbZJTU5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 16:57:38 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ben Hutchings <ben@decadent.org.uk>, Greg KH <greg@kroah.com>,
       Pavel Machek <pavel@ucw.cz>, Wolfram Sang <w.sang@pengutronix.de>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] scripts/get_maintainer.pl: Fix --non with --git-blame and cleanups
Date: Tue, 20 Oct 2009 13:57:42 -0700
Message-Id: <ed2ef6a3961d014fb2608579d72828d8bec4940f.1256056531.git.joe@perches.com>
X-Mailer: git-send-email 1.6.5.rc3.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix email matching without name --n and --git-blame
   Using --non and --git-blame caused maintainer signature
   matching to fail.  Fixed that by adding 3rd argument to
   sub format_email to control show/hide name portion of address
Slurp -f file instead of reading line-by-line for K: pattern matching.
   Suggested by Wolfram Sang <w.sang@pengutronix.de> as more efficient
Refactor git command execution
   Break into 2 functions, execute/analyze
   Share code between --git and --git-blame
   Don't warn multiple times when git isn't installed
Improve stats reporting
   --git-min-percent and -- rolestats now count the total number of commits
   for either the period of --git-since or if using --git-blame the commits
   used by the current file and calculate commit % as
      # of commits signed / total commits * 100
Code style cleaning
   Use consistent sub foo { my (args...) = @_;

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/get_maintainer.pl |  198 ++++++++++++++++++++++++---------------------
 1 files changed, 104 insertions(+), 94 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 638c209..65efc47 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -182,7 +182,7 @@ if ($email_remove_duplicates) {
 	next if ($line =~ m/^\s*$/);
 
 	my ($name, $address) = parse_email($line);
-	$line = format_email($name, $address);
+	$line = format_email($name, $address, $email_usename);
 
 	next if ($line =~ m/^\s*$/);
 
@@ -214,12 +214,10 @@ foreach my $file (@ARGV) {
 	push(@files, $file);
 	if (-f $file && $keywords) {
 	    open(FILE, "<$file") or die "$P: Can't open ${file}\n";
-	    while (<FILE>) {
-		my $patch_line = $_;
-		foreach my $line (keys %keyword_hash) {
-		    if ($patch_line =~ m/^.*$keyword_hash{$line}/x) {
-			push(@keyword_tvi, $line);
-		    }
+	    my $text = do { local($/) ; <FILE> };
+	    foreach my $line (keys %keyword_hash) {
+		if ($text =~ m/$keyword_hash{$line}/x) {
+		    push(@keyword_tvi, $line);
 		}
 	    }
 	    close(FILE);
@@ -311,7 +309,7 @@ foreach my $file (@files) {
     }
 
     if ($email && $email_git) {
-	recent_git_signoffs($file);
+	git_file_signoffs($file);
     }
 
     if ($email && $email_git_blame) {
@@ -331,7 +329,7 @@ if ($email) {
 	if ($chief =~ m/^(.*):(.*)/) {
 	    my $email_address;
 
-	    $email_address = format_email($1, $2);
+	    $email_address = format_email($1, $2, $email_usename);
 	    if ($email_git_penguin_chiefs) {
 		push(@email_to, [$email_address, 'chief penguin']);
 	    } else {
@@ -509,7 +507,7 @@ sub parse_email {
 }
 
 sub format_email {
-    my ($name, $address) = @_;
+    my ($name, $address, $usename) = @_;
 
     my $formatted_email;
 
@@ -522,11 +520,11 @@ sub format_email {
 	$name = "\"$name\"";
     }
 
-    if ($email_usename) {
+    if ($usename) {
 	if ("$name" eq "") {
 	    $formatted_email = "$address";
 	} else {
-	    $formatted_email = "$name <${address}>";
+	    $formatted_email = "$name <$address>";
 	}
     } else {
 	$formatted_email = $address;
@@ -671,7 +669,7 @@ sub add_categories {
 			if ($tv =~ m/^(\C):\s*(.*)/) {
 			    if ($1 eq "P") {
 				$name = $2;
-				$pvalue = format_email($name, $address);
+				$pvalue = format_email($name, $address, $email_usename);
 			    }
 			}
 		    }
@@ -714,9 +712,9 @@ sub push_email_address {
     }
 
     if (!$email_remove_duplicates) {
-	push(@email_to, [format_email($name, $address), $role]);
+	push(@email_to, [format_email($name, $address, $email_usename), $role]);
     } elsif (!email_inuse($name, $address)) {
-	push(@email_to, [format_email($name, $address), $role]);
+	push(@email_to, [format_email($name, $address, $email_usename), $role]);
 	$email_hash_name{$name}++;
 	$email_hash_address{$address}++;
     }
@@ -747,7 +745,7 @@ sub add_role {
     my ($line, $role) = @_;
 
     my ($name, $address) = parse_email($line);
-    my $email = format_email($name, $address);
+    my $email = format_email($name, $address, $email_usename);
 
     foreach my $entry (@email_to) {
 	if ($email_remove_duplicates) {
@@ -784,7 +782,7 @@ sub which {
 }
 
 sub mailmap {
-    my @lines = @_;
+    my (@lines) = @_;
     my %hash;
 
     foreach my $line (@lines) {
@@ -793,14 +791,14 @@ sub mailmap {
 	    $hash{$name} = $address;
 	} elsif ($address ne $hash{$name}) {
 	    $address = $hash{$name};
-	    $line = format_email($name, $address);
+	    $line = format_email($name, $address, $email_usename);
 	}
 	if (exists($mailmap{$name})) {
 	    my $obj = $mailmap{$name};
 	    foreach my $map_address (@$obj) {
 		if (($map_address eq $address) &&
 		    ($map_address ne $hash{$name})) {
-		    $line = format_email($name, $hash{$name});
+		    $line = format_email($name, $hash{$name}, $email_usename);
 		}
 	    }
 	}
@@ -809,33 +807,44 @@ sub mailmap {
     return @lines;
 }
 
-sub recent_git_signoffs {
-    my ($file) = @_;
-
-    my $sign_offs = "";
-    my $cmd = "";
-    my $output = "";
-    my $count = 0;
-    my @lines = ();
-    my %hash;
-    my $total_sign_offs;
-
+my $printed_nogit = 0;
+my $printed_nogitdir = 0;
+sub has_git {
     if (which("git") eq "") {
-	warn("$P: git not found.  Add --nogit to options?\n");
-	return;
+	if (!$printed_nogit) {
+	    warn("$P: git not found.  Add --nogit to options?\n");
+	    $printed_nogit = 1;
+	}
+	return 0;
     }
     if (!(-d ".git")) {
-	warn("$P: .git directory not found.  Use a git repository for better results.\n");
-	warn("$P: perhaps 'git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git'\n");
-	return;
+	if (!$printed_nogitdir) {
+	    warn(".git directory not found.  "
+		 . "Using a git repository produces better results.\n");
+	    warn("Try Linus Torvalds' latest git repository using:\n");
+	    warn("git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git\n");
+	    $printed_nogitdir = 1;
+	}
+	return 0;
     }
 
-    $cmd = "git log --since=${email_git_since} -- ${file}";
+    return 1;
+}
+
+sub git_find_signers {
+    my ($cmd) = @_;
+
+    my $output;
+    my @lines = ();
+    my $commits;
+
+    return (0, @lines) if (!has_git());
 
     $output = `${cmd}`;
     $output =~ s/^\s*//gm;
 
     @lines = split("\n", $output);
+    $commits = grep(/^commit [0-9a-f]{40,40}/, @lines);		# of commits
 
     @lines = grep(/^[-_ 	a-z]+by:.*\@.*$/i, @lines);
     if (!$email_git_penguin_chiefs) {
@@ -844,10 +853,28 @@ sub recent_git_signoffs {
     # cut -f2- -d":"
     s/.*:\s*(.+)\s*/$1/ for (@lines);
 
-    $total_sign_offs = @lines;
+## Reformat email addresses (with names) to avoid badly written signatures
+
     foreach my $line (@lines) {
 	my ($name, $address) = parse_email($line);
-	$line = format_email($name, $address);
+	$line = format_email($name, $address, 1);
+    }
+
+    return ($commits, @lines);
+}
+
+sub git_assign_signers {
+    my ($role, $divisor, @lines) = @_;
+
+    my %hash;
+    my $count = 0;
+
+    return if (!has_git());
+    return if (@lines <= 0);
+
+    if ($divisor <= 0) {
+	warn("Bad divisor in git_assign_signers: $divisor\n");
+	$divisor = 1;
     }
 
     if ($email_remove_duplicates) {
@@ -862,27 +889,43 @@ sub recent_git_signoffs {
     # sort -rn
     foreach my $line (sort {$hash{$b} <=> $hash{$a}} keys %hash) {
 	my $sign_offs = $hash{$line};
-	my $role;
+	my $percent = $sign_offs * 100 / $divisor;
 
+	$percent = 100 if ($percent > 100);
 	$count++;
 	last if ($sign_offs < $email_git_min_signatures ||
 		 $count > $email_git_max_maintainers ||
-		 $sign_offs * 100 / $total_sign_offs < $email_git_min_percent);
+		 $percent < $email_git_min_percent);
 	push_email_address($line, '');
-	$role = "git-signer";
 	if ($output_rolestats) {
-	    my $percent = sprintf("%.0f", $sign_offs * 100 / $total_sign_offs);
-	    $role = "$role:$sign_offs/$total_sign_offs=$percent%";
+	    my $fmt_percent = sprintf("%.0f", $percent);
+	    add_role($line, "$role:$sign_offs/$divisor=$fmt_percent%");
+	} else {
+	    add_role($line, $role);
 	}
-	add_role($line, $role);
     }
 }
 
+sub git_file_signoffs {
+    my ($file) = @_;
+
+    my @signers = ();
+    my $total_signers;
+
+    return if (!has_git());
+
+    ($total_signers, @signers) =
+	git_find_signers("git log --since=$email_git_since -- $file");
+    git_assign_signers("git_signer", $total_signers, @signers);
+}
+
 sub save_commits {
     my ($cmd, @commits) = @_;
     my $output;
     my @lines = ();
 
+    return (@lines) if (!has_git());
+
     $output = `${cmd}`;
 
     @lines = split("\n", $output);
@@ -897,13 +940,10 @@ sub save_commits {
 sub git_assign_blame {
     my ($file) = @_;
 
-    my @lines = ();
-    my @commits = ();
     my $cmd;
-    my $output;
-    my %hash;
-    my $total_sign_offs;
-    my $count;
+    my @commits = ();
+    my @signers = ();
+    my $total_commits;
 
     if (@range) {
 	foreach my $file_range_diff (@range) {
@@ -922,57 +962,27 @@ sub git_assign_blame {
 	}
     }
 
-    $total_sign_offs = 0;
     @commits = uniq(@commits);
-    foreach my $commit (@commits) {
-	$cmd = "git log -1 ${commit}";
-
-	$output = `${cmd}`;
-	$output =~ s/^\s*//gm;
-	@lines = split("\n", $output);
-
-	@lines = grep(/^[-_ 	a-z]+by:.*\@.*$/i, @lines);
-	if (!$email_git_penguin_chiefs) {
-	    @lines = grep(!/${penguin_chiefs}/i, @lines);
-	}
-
-	# cut -f2- -d":"
-	s/.*:\s*(.+)\s*/$1/ for (@lines);
-
-	$total_sign_offs += @lines;
+    $total_commits = @commits;
 
-	if ($email_remove_duplicates) {
-	    @lines = mailmap(@lines);
-	}
+    foreach my $commit (@commits) {
+	my $commit_count;
+	my @commit_signers = ();
 
-	$hash{$_}++ for @lines;
+	($commit_count, @commit_signers) =
+	    git_find_signers("git log -1 $commit");
+	@signers = (@signers, @commit_signers);
     }
 
-    $count = 0;
-    foreach my $line (sort {$hash{$b} <=> $hash{$a}} keys %hash) {
-	my $sign_offs = $hash{$line};
-	my $role;
-
-	$count++;
-	last if ($sign_offs < $email_git_min_signatures ||
-		 $count > $email_git_max_maintainers ||
-		 $sign_offs * 100 / $total_sign_offs < $email_git_min_percent);
-	push_email_address($line, '');
-	if ($from_filename) {
-	    $role = "commits";
-	} else {
-	    $role = "modified commits";
-	}
-	if ($output_rolestats) {
-	    my $percent = sprintf("%.0f", $sign_offs * 100 / $total_sign_offs);
-	    $role = "$role:$sign_offs/$total_sign_offs=$percent%";
-	}
-	add_role($line, $role);
+    if ($from_filename) {
+	git_assign_signers("commits", $total_commits, @signers);
+    } else {
+	git_assign_signers("modified commits", $total_commits, @signers);
     }
 }
 
 sub uniq {
-    my @parms = @_;
+    my (@parms) = @_;
 
     my %saw;
     @parms = grep(!$saw{$_}++, @parms);
@@ -980,7 +990,7 @@ sub uniq {
 }
 
 sub sort_and_uniq {
-    my @parms = @_;
+    my (@parms) = @_;
 
     my %saw;
     @parms = sort @parms;
@@ -1008,7 +1018,7 @@ sub merge_email {
 }
 
 sub output {
-    my @parms = @_;
+    my (@parms) = @_;
 
     if ($output_multiline) {
 	foreach my $line (@parms) {
-- 
1.6.5.rc3.dirty

