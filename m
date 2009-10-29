Return-Path: <linux-kernel-owner+w=401wt.eu-S1756619AbZJ2TXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619AbZJ2TXj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 15:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756553AbZJ2TXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 15:23:39 -0400
Received: from mail.perches.com ([173.55.12.10]:1118 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756431AbZJ2TXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 15:23:38 -0400
Subject: [PATCH] scripts/get_maintainer.pl: Support multiple VCSs - add
 mercurial
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Marti Raudsepp <marti@juffo.org>
In-Reply-To: <54b33ccd0910261207y3202ea57lfc5bc9e1b34cfc78@mail.gmail.com>
References: <1256573044.7754.20.camel@localhost>
	 <1256578064.1865.96.camel@Joe-Laptop.home> <1256581648.20338.47.camel@newn>
	 <1256583204.1865.108.camel@Joe-Laptop.home>
	 <54b33ccd0910261207y3202ea57lfc5bc9e1b34cfc78@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Oct 2009 12:23:42 -0700
Message-ID: <1256844222.29938.197.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Restructure a bit for multiple version control systems support.

Use a hash for each supported VCS that contains the commands
and patterns used to find commits, logs, and signers.

--git command line options are still used for hg except for
--git-since.  Use --hg-since instead.

The number of commits can differ for git and hg, so --rolestats
might be different.

Style changes: Use common push style push(@foo...), simplify a return

Bumped version to 0.23.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/get_maintainer.pl |  261 +++++++++++++++++++++++++++++----------------
 1 files changed, 168 insertions(+), 93 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 65efc47..5af9e35 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -13,7 +13,7 @@
 use strict;
 
 my $P = $0;
-my $V = '0.22';
+my $V = '0.23';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -23,13 +23,14 @@ my $email_usename = 1;
 my $email_maintainer = 1;
 my $email_list = 1;
 my $email_subscriber_list = 0;
-my $email_git = 1;
 my $email_git_penguin_chiefs = 0;
+my $email_git = 1;
+my $email_git_blame = 0;
 my $email_git_min_signatures = 1;
 my $email_git_max_maintainers = 5;
 my $email_git_min_percent = 5;
 my $email_git_since = "1-year-ago";
-my $email_git_blame = 0;
+my $email_hg_since = "-365";
 my $email_remove_duplicates = 1;
 my $output_multiline = 1;
 my $output_separator = ", ";
@@ -66,15 +67,44 @@ my $penguin_chiefs = "\(" . join("|",@penguin_chief_names) . "\)";
 my $rfc822_lwsp = "(?:(?:\\r\\n)?[ \\t])";
 my $rfc822_char = '[\\000-\\377]';
 
+# VCS command support: class-like functions and strings
+
+my %VCS_cmds;
+
+my %VCS_cmds_git = (
+    "execute_cmd" => \&git_execute_cmd,
+    "available" => '(which("git") ne "") && (-d ".git")',
+    "find_signers_cmd" => "git log --since=\$email_git_since -- \$file",
+    "find_commit_signers_cmd" => "git log -1 \$commit",
+    "blame_range_cmd" => "git blame -l -L \$diff_start,+\$diff_length \$file",
+    "blame_file_cmd" => "git blame -l \$file",
+    "commit_pattern" => "^commit [0-9a-f]{40,40}",
+    "blame_commit_pattern" => "^([0-9a-f]+) "
+);
+
+my %VCS_cmds_hg = (
+    "execute_cmd" => \&hg_execute_cmd,
+    "available" => '(which("hg") ne "") && (-d ".hg")',
+    "find_signers_cmd" =>
+	"hg log --date=\$email_hg_since" .
+		" --template='commit {node}\\n{desc}\\n' -- \$file",
+    "find_commit_signers_cmd" => "hg log --template='{desc}\\n' -r \$commit",
+    "blame_range_cmd" => "",		# not supported
+    "blame_file_cmd" => "hg blame -c \$file",
+    "commit_pattern" => "^commit [0-9a-f]{40,40}",
+    "blame_commit_pattern" => "^([0-9a-f]+):"
+);
+
 if (!GetOptions(
 		'email!' => \$email,
 		'git!' => \$email_git,
+		'git-blame!' => \$email_git_blame,
 		'git-chief-penguins!' => \$email_git_penguin_chiefs,
 		'git-min-signatures=i' => \$email_git_min_signatures,
 		'git-max-maintainers=i' => \$email_git_max_maintainers,
 		'git-min-percent=i' => \$email_git_min_percent,
 		'git-since=s' => \$email_git_since,
-		'git-blame!' => \$email_git_blame,
+		'hg-since=s' => \$email_hg_since,
 		'remove-duplicates!' => \$email_remove_duplicates,
 		'm!' => \$email_maintainer,
 		'n!' => \$email_usename,
@@ -309,11 +339,11 @@ foreach my $file (@files) {
     }
 
     if ($email && $email_git) {
-	git_file_signoffs($file);
+	vcs_file_signoffs($file);
     }
 
     if ($email && $email_git_blame) {
-	git_assign_blame($file);
+	vcs_file_blame($file);
     }
 }
 
@@ -403,8 +433,9 @@ MAINTAINER field selection options:
     --git-min-signatures => number of signatures required (default: 1)
     --git-max-maintainers => maximum maintainers to add (default: 5)
     --git-min-percent => minimum percentage of commits required (default: 5)
-    --git-since => git history to use (default: 1-year-ago)
     --git-blame => use git blame to find modified commits for patch or file
+    --git-since => git history to use (default: 1-year-ago)
+    --hg-since => hg history to use (default: -365)
     --m => include maintainer(s) if any
     --n => include name 'Full Name <addr\@domain.tld>'
     --l => include list(s) if any
@@ -437,8 +468,8 @@ Notes:
           directory are examined as git recurses directories.
           Any specified X: (exclude) pattern matches are _not_ ignored.
       Used with "--nogit", directory is used as a pattern match,
-         no individual file within the directory or subdirectory
-         is matched.
+          no individual file within the directory or subdirectory
+          is matched.
       Used with "--git-blame", does not iterate all files in directory
   Using "--git-blame" is slow and may add old committers and authors
       that are no longer active maintainers to the output.
@@ -449,6 +480,12 @@ Notes:
       not the percentage of the entire file authored.  # of commits is
       not a good measure of amount of code authored.  1 major commit may
       contain a thousand lines, 5 trivial commits may modify a single line.
+  If git is not installed, but mercurial (hg) is installed and an .hg
+      repository exists, the following options apply to mercurial:
+          --git,
+          --git-min-signatures, --git-max-maintainers, --git-min-percent, and
+          --git-blame
+      Use --hg-since not --git-since to control date selection
 EOT
 }
 
@@ -807,44 +844,37 @@ sub mailmap {
     return @lines;
 }
 
-my $printed_nogit = 0;
-my $printed_nogitdir = 0;
-sub has_git {
-    if (which("git") eq "") {
-	if (!$printed_nogit) {
-	    warn("$P: git not found.  Add --nogit to options?\n");
-	    $printed_nogit = 1;
-	}
-	return 0;
-    }
-    if (!(-d ".git")) {
-	if (!$printed_nogitdir) {
-	    warn(".git directory not found.  "
-		 . "Using a git repository produces better results.\n");
-	    warn("Try Linus Torvalds' latest git repository using:\n");
-	    warn("git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git\n");
-	    $printed_nogitdir = 1;
-	}
-	return 0;
-    }
+sub git_execute_cmd {
+    my ($cmd) = @_;
+    my @lines = ();
 
-    return 1;
+    my $output = `$cmd`;
+    $output =~ s/^\s*//gm;
+    @lines = split("\n", $output);
+
+    return @lines;
 }
 
-sub git_find_signers {
+sub hg_execute_cmd {
     my ($cmd) = @_;
+    my @lines = ();
+
+    my $output = `$cmd`;
+    @lines = split("\n", $output);
 
-    my $output;
+    return @lines;
+}
+
+sub vcs_find_signers {
+    my ($cmd) = @_;
     my @lines = ();
     my $commits;
 
-    return (0, @lines) if (!has_git());
+    @lines = &{$VCS_cmds{"execute_cmd"}}($cmd);
 
-    $output = `${cmd}`;
-    $output =~ s/^\s*//gm;
+    my $pattern = $VCS_cmds{"commit_pattern"};
 
-    @lines = split("\n", $output);
-    $commits = grep(/^commit [0-9a-f]{40,40}/, @lines);		# of commits
+    $commits = grep(/$pattern/, @lines);	# of commits
 
     @lines = grep(/^[-_ 	a-z]+by:.*\@.*$/i, @lines);
     if (!$email_git_penguin_chiefs) {
@@ -863,17 +893,93 @@ sub git_find_signers {
     return ($commits, @lines);
 }
 
-sub git_assign_signers {
+sub vcs_save_commits {
+    my ($cmd) = @_;
+    my @lines = ();
+    my @commits = ();
+
+    @lines = &{$VCS_cmds{"execute_cmd"}}($cmd);
+
+    foreach my $line (@lines) {
+	if ($line =~ m/$VCS_cmds{"blame_commit_pattern"}/) {
+	    push(@commits, $1);
+	}
+    }
+
+    return @commits;
+}
+
+sub vcs_blame {
+    my ($file) = @_;
+    my $cmd;
+    my @commits = ();
+
+    return @commits if (!(-f $file));
+
+    if (@range && $VCS_cmds{"blame_range_cmd"} eq "") {
+	my @all_commits = ();
+
+	$cmd = $VCS_cmds{"blame_file_cmd"};
+	$cmd =~ s/(\$\w+)/$1/eeg;		#interpolate $cmd
+	@all_commits = vcs_save_commits($cmd);
+
+	foreach my $file_range_diff (@range) {
+	    next if (!($file_range_diff =~ m/(.+):(.+):(.+)/));
+	    my $diff_file = $1;
+	    my $diff_start = $2;
+	    my $diff_length = $3;
+	    next if ("$file" ne "$diff_file");
+	    for (my $i = $diff_start; $i < $diff_start + $diff_length; $i++) {
+		push(@commits, $all_commits[$i]);
+	    }
+	}
+    } elsif (@range) {
+	foreach my $file_range_diff (@range) {
+	    next if (!($file_range_diff =~ m/(.+):(.+):(.+)/));
+	    my $diff_file = $1;
+	    my $diff_start = $2;
+	    my $diff_length = $3;
+	    next if ("$file" ne "$diff_file");
+	    $cmd = $VCS_cmds{"blame_range_cmd"};
+	    $cmd =~ s/(\$\w+)/$1/eeg;		#interpolate $cmd
+	    push(@commits, vcs_save_commits($cmd));
+	}
+    } else {
+	$cmd = $VCS_cmds{"blame_file_cmd"};
+	$cmd =~ s/(\$\w+)/$1/eeg;		#interpolate $cmd
+	@commits = vcs_save_commits($cmd);
+    }
+
+    return @commits;
+}
+
+my $printed_novcs = 0;
+sub vcs_exists {
+    %VCS_cmds = %VCS_cmds_git;
+    return 1 if eval $VCS_cmds{"available"};
+    %VCS_cmds = %VCS_cmds_hg;
+    return 1 if eval $VCS_cmds{"available"};
+    %VCS_cmds = ();
+    if (!$printed_novcs) {
+	warn("$P: No supported VCS found.  Add --nogit to options?\n");
+	warn("Using a git repository produces better results.\n");
+	warn("Try Linus Torvalds' latest git repository using:\n");
+	warn("git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git\n");
+	$printed_novcs = 1;
+    }
+    return 0;
+}
+
+sub vcs_assign {
     my ($role, $divisor, @lines) = @_;
 
     my %hash;
     my $count = 0;
 
-    return if (!has_git());
     return if (@lines <= 0);
 
     if ($divisor <= 0) {
-	warn("Bad divisor in git_assign_signers: $divisor\n");
+	warn("Bad divisor in " . (caller(0))[3] . ": $divisor\n");
 	$divisor = 1;
     }
 
@@ -906,62 +1012,31 @@ sub git_assign_signers {
     }
 }
 
-sub git_file_signoffs {
+sub vcs_file_signoffs {
     my ($file) = @_;
 
     my @signers = ();
-    my $total_signers;
-
-    return if (!has_git());
-
-    ($total_signers, @signers) =
-	git_find_signers("git log --since=$email_git_since -- $file");
-    git_assign_signers("git_signer", $total_signers, @signers);
-}
-
-sub save_commits {
-    my ($cmd, @commits) = @_;
-    my $output;
-    my @lines = ();
+    my $commits;
 
-    return (@lines) if (!has_git());
+    return if (!vcs_exists());
 
-    $output = `${cmd}`;
+    my $cmd = $VCS_cmds{"find_signers_cmd"};
+    $cmd =~ s/(\$\w+)/$1/eeg;		# interpolate $cmd
 
-    @lines = split("\n", $output);
-    foreach my $line (@lines) {
-	if ($line =~ m/^(\w+) /) {
-	    push (@commits, $1);
-	}
-    }
-    return @commits;
+    ($commits, @signers) = vcs_find_signers($cmd);
+    vcs_assign("commit_signer", $commits, @signers);
 }
 
-sub git_assign_blame {
+sub vcs_file_blame {
     my ($file) = @_;
 
-    my $cmd;
-    my @commits = ();
     my @signers = ();
+    my @commits = ();
     my $total_commits;
 
-    if (@range) {
-	foreach my $file_range_diff (@range) {
-	    next if (!($file_range_diff =~ m/(.+):(.+):(.+)/));
-	    my $diff_file = $1;
-	    my $diff_start = $2;
-	    my $diff_length = $3;
-	    next if (!("$file" eq "$diff_file"));
-	    $cmd = "git blame -l -L $diff_start,+$diff_length $file";
-	    @commits = save_commits($cmd, @commits);
-	}
-    } else {
-	if (-f $file) {
-	    $cmd = "git blame -l $file";
-	    @commits = save_commits($cmd, @commits);
-	}
-    }
+    return if (!vcs_exists());
 
+    @commits = vcs_blame($file);
     @commits = uniq(@commits);
     $total_commits = @commits;
 
@@ -969,15 +1044,17 @@ sub git_assign_blame {
 	my $commit_count;
 	my @commit_signers = ();
 
-	($commit_count, @commit_signers) =
-	    git_find_signers("git log -1 $commit");
-	@signers = (@signers, @commit_signers);
+	my $cmd = $VCS_cmds{"find_commit_signers_cmd"};
+	$cmd =~ s/(\$\w+)/$1/eeg;	#interpolate $cmd
+
+	($commit_count, @commit_signers) = vcs_find_signers($cmd);
+	push(@signers, @commit_signers);
     }
 
     if ($from_filename) {
-	git_assign_signers("commits", $total_commits, @signers);
+	vcs_assign("commits", $total_commits, @signers);
     } else {
-	git_assign_signers("modified commits", $total_commits, @signers);
+	vcs_assign("modified commits", $total_commits, @signers);
     }
 }
 
@@ -1006,9 +1083,9 @@ sub merge_email {
 	my ($address, $role) = @$_;
 	if (!$saw{$address}) {
 	    if ($output_roles) {
-		push @lines, "$address ($role)";
+		push(@lines, "$address ($role)");
 	    } else {
-		push @lines, $address;
+		push(@lines, $address);
 	    }
 	    $saw{$address} = 1;
 	}
@@ -1115,11 +1192,9 @@ sub rfc822_validlist ($) {
     if ($s =~ m/^(?:$rfc822re)?(?:,(?:$rfc822re)?)*$/so &&
 	$s =~ m/^$rfc822_char*$/) {
         while ($s =~ m/(?:^|,$rfc822_lwsp*)($rfc822re)/gos) {
-            push @r, $1;
+            push(@r, $1);
         }
         return wantarray ? (scalar(@r), @r) : 1;
     }
-    else {
-        return wantarray ? () : 0;
-    }
+    return wantarray ? () : 0;
 }
-- 
1.6.5.1.65.gc2fd



