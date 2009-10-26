Return-Path: <linux-kernel-owner+w=401wt.eu-S1753573AbZJZS13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573AbZJZS13 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 14:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753073AbZJZS12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 14:27:28 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:27663 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876AbZJZS12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 14:27:28 -0400
Subject: Re: [RFC] scripts/get_maintainer.pl: also find maintainers from
 Mercurial (hg log)
From: Marti Raudsepp <marti@juffo.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1256578064.1865.96.camel@Joe-Laptop.home>
References: <1256573044.7754.20.camel@localhost>
	 <1256578064.1865.96.camel@Joe-Laptop.home>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Oct 2009 20:27:28 +0200
Message-ID: <1256581648.20338.47.camel@newn>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 7:27 PM, Joe Perches <joe@perches.com> wrote:
> What about using hg annotate for the git blame?
>        hg annotate -c $file

Sure, I will get around to it once this patch is done.

'hg blame' without any arguments already gives the locally-unique
revision number which can be input to 'hg log -r ####' like the git
revhash. I think this would be the way to go.

> Is there an hg annotate select line range capability?

No, but -l adds line numbers to output, so it can be filtered in Perl.

> I'm not a user of hg. I did:
>        hg annotate -c -l README
> and the output line numbering style isn't clear to me.

It seems they reflect the line number in the original revision, the
documentation isn't clear on this; I will investigate it.
I guess we can get the real line number using a counter anyway.

> Maybe it's better not to introduce more arguments.
> Would it be acceptable to use --git instead of --hg
> and just execute hg if .git wasn't available but .hg
> was?  Basically just consider --git the equivalent of
> --vcs and execute whatever vcs system was supported?
>
> Or maybe just add --vcs instead of --hg so that
> the perforce/cvs/svn/darcs/VisualSourceSafe/etc users
> could be happy in the future too...

I'm split on this. At first it seems adding a --vcs as an alias to --git
would make the most sense.

But that's confusing because there already is a --scm option. Also
renaming all existing --git-* options doesn't sound like a good idea.

Since will do the right thing by default, sticking with --git/--nogit
might be the best way to go.

Marti

---
scripts/get_maintainer.pl: also find maintainers from Mercurial (hg log)

When a .git directory doesn't exist, get_maintainer now tries to use Mercurial
instead.

The --nogit option also disables Mercurial.

Signed-off-by: Marti Raudsepp <marti@juffo.org>

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -30,6 +30,7 @@
 my $email_git_min_percent = 5;
 my $email_git_since = "1-year-ago";
 my $email_git_blame = 0;
+my $email_hg_date = "-365";
 my $email_remove_duplicates = 1;
 my $output_multiline = 1;
 my $output_separator = ", ";
@@ -72,6 +73,7 @@
 		'git-min-percent=i' => \$email_git_min_percent,
 		'git-since=s' => \$email_git_since,
 		'git-blame!' => \$email_git_blame,
+		'hg-date=s' => \$email_hg_date,
 		'remove-duplicates!' => \$email_remove_duplicates,
 		'm!' => \$email_maintainer,
 		'n!' => \$email_usename,
@@ -278,7 +280,7 @@
     }
 
     if ($email && $email_git) {
-	recent_git_signoffs($file);
+	recent_vcs_signoffs($file);
     }
 
     if ($email && $email_git_blame) {
@@ -360,13 +362,14 @@
 
 MAINTAINER field selection options:
   --email => print email address(es) if any
-    --git => include recent git \*-by: signers
+    --git => include recent git or hg \*-by: signers
     --git-chief-penguins => include ${penguin_chiefs}
     --git-min-signatures => number of signatures required (default: 1)
     --git-max-maintainers => maximum maintainers to add (default: 5)
     --git-min-percent => minimum percentage of commits required (default: 5)
     --git-since => git history to use (default: 1-year-ago)
     --git-blame => use git blame to find modified commits for patch or file
+    --hg-date => hg history to use (default: -365)
     --m => include maintainer(s) if any
     --n => include name 'Full Name <addr\@domain.tld>'
     --l => include list(s) if any
@@ -661,7 +664,7 @@
     return @lines;
 }
 
-sub recent_git_signoffs {
+sub recent_vcs_signoffs {
     my ($file) = @_;
 
     my $sign_offs = "";
@@ -672,18 +675,26 @@
     my %hash;
     my $total_sign_offs;
 
-    if (which("git") eq "") {
-	warn("$P: git not found.  Add --nogit to options?\n");
-	return;
-    }
-    if (!(-d ".git")) {
-	warn("$P: .git directory not found.  Use a git repository for better results.\n");
+    if (-d ".git") {
+	if (which("git") eq "") {
+	    warn("$P: found .git directory but git is not installed.  Use --nogit?\n");
+	    return;
+	}
+
+	$cmd = "git log --since=${email_git_since} -- ${file}";
+    } elsif (-d ".hg") {
+	if (which("hg") eq "") {
+	    warn("$P: found .hg directory but Mercurial is not installed.  Use --nogit?\n");
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
 


