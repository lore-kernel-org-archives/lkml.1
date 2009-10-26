Return-Path: <linux-kernel-owner+w=401wt.eu-S1753386AbZJZQEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbZJZQEL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 12:04:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753257AbZJZQEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 12:04:10 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:45381 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbZJZQEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 12:04:09 -0400
Subject: [RFC] scripts/get_maintainer.pl: also find maintainers from
 Mercurial (hg log)
From: Marti Raudsepp <marti@juffo.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Oct 2009 18:04:04 +0200
Message-ID: <1256573044.7754.20.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I've patched the get_maintainer.pl script to also try finding
maintainers from Mercurial history -- as alternative to git.

Given that there are official hg repositories available from kernel.org,
Mercurial seems to be an acceptable alternative to git. Does this patch
have any chance?

(I really did try git, but hg just works better for me. I don't want to
start a flame war here)

Marti

---
scripts/get_maintainer.pl: also find maintainers from Mercurial (hg log)

When a .git directory doesn't exist, get_maintainer now tries to use Mercurial
instead.

Changed behavior:
* Warns when .git is found but git is not installed
* Warns when .hg is found but Mercurial is not installed
* Previously --nogit made it quiet when outside a repository. Now --nogit yells
about non-existant .hg repository

New behavior can be disabled with --nohg

Signed-off-by: Marti Raudsepp <marti@juffo.org>

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -30,6 +30,8 @@
 my $email_git_min_percent = 5;
 my $email_git_since = "1-year-ago";
 my $email_git_blame = 0;
+my $email_hg = 1;
+my $email_hg_date = "-365";
 my $email_remove_duplicates = 1;
 my $output_multiline = 1;
 my $output_separator = ", ";
@@ -72,6 +74,8 @@
 		'git-min-percent=i' => \$email_git_min_percent,
 		'git-since=s' => \$email_git_since,
 		'git-blame!' => \$email_git_blame,
+		'hg!' => \$email_hg,
+		'hg-date=s' => \$email_hg_date,
 		'remove-duplicates!' => \$email_remove_duplicates,
 		'm!' => \$email_maintainer,
 		'n!' => \$email_usename,
@@ -277,8 +281,8 @@
 	}
     }
 
-    if ($email && $email_git) {
-	recent_git_signoffs($file);
+    if ($email && ($email_git || $email_hg)) {
+	recent_vcs_signoffs($file);
     }
 
     if ($email && $email_git_blame) {
@@ -367,6 +371,8 @@
     --git-min-percent => minimum percentage of commits required (default: 5)
     --git-since => git history to use (default: 1-year-ago)
     --git-blame => use git blame to find modified commits for patch or file
+    --hg => include recent signers from hg (if git is unavailable)
+    --hg-date => hg history to use (default: -365)
     --m => include maintainer(s) if any
     --n => include name 'Full Name <addr\@domain.tld>'
     --l => include list(s) if any
@@ -388,7 +394,7 @@
   --help => show this help information
 
 Default options:
-  [--email --git --m --n --l --multiline --pattern-depth=0 --remove-duplicates]
+  [--email --git --hg --m --n --l --multiline --pattern-depth=0 --remove-duplicates]
 
 Notes:
   Using "-f directory" may give unexpected results:
@@ -661,7 +667,7 @@
     return @lines;
 }
 
-sub recent_git_signoffs {
+sub recent_vcs_signoffs {
     my ($file) = @_;
 
     my $sign_offs = "";
@@ -672,18 +678,26 @@
     my %hash;
     my $total_sign_offs;
 
-    if (which("git") eq "") {
-	warn("$P: git not found.  Add --nogit to options?\n");
-	return;
-    }
-    if (!(-d ".git")) {
-	warn("$P: .git directory not found.  Use a git repository for better results.\n");
+    if ($email_git && -d ".git") {
+	if (which("git") eq "") {
+	    warn("$P: found .git directory but git is not installed.  Use --nogit?\n");
+	    return;
+	}
+
+	$cmd = "git log --since=${email_git_since} -- ${file}";
+    } elsif ($email_hg && -d ".hg") {
+	if (which("hg") eq "") {
+	    warn("$P: found .hg directory but Mercurial is not installed.  Use --nohg?\n");
+	    return;
+	}
+
+	$cmd = "hg log --date=${email_hg_date} --template='{desc}\\n' -- ${file}";
+    } else {
+	warn("$P: .git or .hg directory not found.  Use a git repository for better results.\n");
 	warn("$P: perhaps 'git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git'\n");
 	return;
     }
 
-    $cmd = "git log --since=${email_git_since} -- ${file}";
-
     $output = `${cmd}`;
     $output =~ s/^\s*//gm;
 


