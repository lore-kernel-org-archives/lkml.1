Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab0BSHCt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 02:02:49 -0500
Received: from suva.vyatta.com ([76.74.103.44]:51983 "EHLO suva.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754335Ab0BSHCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 02:02:44 -0500
Message-Id: <20100219070130.781454971@vyatta.com>
References: <20100219070108.670062169@vyatta.com>
User-Agent: quilt/0.46-1
Date: Thu, 18 Feb 2010 23:01:10 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] get_maintainer: use references and closures
Content-Disposition: inline; filename=get-maintainer-closure.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using eval on a string is considered bad practice in Perl because of the 
possiblity of errors at run time.  Better to use a closure for
the is VCx available test.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

--- a/scripts/get_maintainer.pl	2010-02-18 22:11:36.885833644 -0800
+++ b/scripts/get_maintainer.pl	2010-02-18 22:44:47.638010342 -0800
@@ -69,11 +69,11 @@ my $rfc822_char = '[\\000-\\377]';
 
 # VCS command support: class-like functions and strings
 
-my %VCS_cmds;
+my $VCS_cmds;
 
 my %VCS_cmds_git = (
     "execute_cmd" => \&git_execute_cmd,
-    "available" => '(which("git") ne "") && (-d ".git")',
+    "available" => sub { (which("git") ne "") && (-d ".git") },
     "find_signers_cmd" => "git log --no-color --since=\$email_git_since -- \$file",
     "find_commit_signers_cmd" => "git log --no-color -1 \$commit",
     "blame_range_cmd" => "git blame -l -L \$diff_start,+\$diff_length \$file",
@@ -84,7 +84,7 @@ my %VCS_cmds_git = (
 
 my %VCS_cmds_hg = (
     "execute_cmd" => \&hg_execute_cmd,
-    "available" => '(which("hg") ne "") && (-d ".hg")',
+    "available" => sub { (which("hg") ne "") && (-d ".hg") },
     "find_signers_cmd" =>
 	"hg log --date=\$email_hg_since" .
 		" --template='commit {node}\\n{desc}\\n' -- \$file",
@@ -900,9 +900,9 @@ sub vcs_find_signers {
     my @lines = ();
     my $commits;
 
-    @lines = &{$VCS_cmds{"execute_cmd"}}($cmd);
+    @lines = &{$VCS_cmds->{"execute_cmd"}}($cmd);
 
-    my $pattern = $VCS_cmds{"commit_pattern"};
+    my $pattern = $VCS_cmds->{"commit_pattern"};
 
     $commits = grep(/$pattern/, @lines);	# of commits
 
@@ -928,10 +928,10 @@ sub vcs_save_commits {
     my @lines = ();
     my @commits = ();
 
-    @lines = &{$VCS_cmds{"execute_cmd"}}($cmd);
+    @lines = &{$VCS_cmds->{"execute_cmd"}}($cmd);
 
     foreach my $line (@lines) {
-	if ($line =~ m/$VCS_cmds{"blame_commit_pattern"}/) {
+	if ($line =~ m/$VCS_cmds->{"blame_commit_pattern"}/) {
 	    push(@commits, $1);
 	}
     }
@@ -946,10 +946,10 @@ sub vcs_blame {
 
     return @commits if (!(-f $file));
 
-    if (@range && $VCS_cmds{"blame_range_cmd"} eq "") {
+    if (@range && $VCS_cmds->{"blame_range_cmd"} eq "") {
 	my @all_commits = ();
 
-	$cmd = $VCS_cmds{"blame_file_cmd"};
+	$cmd = $VCS_cmds->{"blame_file_cmd"};
 	$cmd =~ s/(\$\w+)/$1/eeg;		#interpolate $cmd
 	@all_commits = vcs_save_commits($cmd);
 
@@ -970,12 +970,12 @@ sub vcs_blame {
 	    my $diff_start = $2;
 	    my $diff_length = $3;
 	    next if ("$file" ne "$diff_file");
-	    $cmd = $VCS_cmds{"blame_range_cmd"};
+	    $cmd = $VCS_cmds->{"blame_range_cmd"};
 	    $cmd =~ s/(\$\w+)/$1/eeg;		#interpolate $cmd
 	    push(@commits, vcs_save_commits($cmd));
 	}
     } else {
-	$cmd = $VCS_cmds{"blame_file_cmd"};
+	$cmd = $VCS_cmds->{"blame_file_cmd"};
 	$cmd =~ s/(\$\w+)/$1/eeg;		#interpolate $cmd
 	@commits = vcs_save_commits($cmd);
     }
@@ -985,16 +985,17 @@ sub vcs_blame {
 
 my $printed_novcs = 0;
 sub vcs_exists {
-    %VCS_cmds = %VCS_cmds_git;
-    return 1 if eval $VCS_cmds{"available"};
-    %VCS_cmds = %VCS_cmds_hg;
-    return 1 if eval $VCS_cmds{"available"};
-    %VCS_cmds = ();
+    $VCS_cmds = \%VCS_cmds_git;
+    return 1 if eval $VCS_cmds->{"available"}();
+    $VCS_cmds = \%VCS_cmds_hg;
+    return 1 if eval $VCS_cmds->{"available"}();
+    $VCS_cmds = undef;
+
     if (!$printed_novcs) {
-	warn("$P: No supported VCS found.  Add --nogit to options?\n");
-	warn("Using a git repository produces better results.\n");
-	warn("Try Linus Torvalds' latest git repository using:\n");
-	warn("git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git\n");
+	warn "$P: No supported VCS found.  Add --nogit to options?\n",
+	     "Using a git repository produces better results.\n",
+	     "Try Linus Torvalds' latest git repository using:\n",
+	"git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git\n";
 	$printed_novcs = 1;
     }
     return 0;
@@ -1050,7 +1051,7 @@ sub vcs_file_signoffs {
 
     return if (!vcs_exists());
 
-    my $cmd = $VCS_cmds{"find_signers_cmd"};
+    my $cmd = $VCS_cmds->{"find_signers_cmd"};
     $cmd =~ s/(\$\w+)/$1/eeg;		# interpolate $cmd
 
     ($commits, @signers) = vcs_find_signers($cmd);
@@ -1074,7 +1075,7 @@ sub vcs_file_blame {
 	my $commit_count;
 	my @commit_signers = ();
 
-	my $cmd = $VCS_cmds{"find_commit_signers_cmd"};
+	my $cmd = $VCS_cmds->{"find_commit_signers_cmd"};
 	$cmd =~ s/(\$\w+)/$1/eeg;	#interpolate $cmd
 
 	($commit_count, @commit_signers) = vcs_find_signers($cmd);

-- 

