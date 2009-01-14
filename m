Return-Path: <linux-kernel-owner+w=401wt.eu-S1757096AbZANTga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096AbZANTga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 14:36:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754618AbZANTgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 14:36:22 -0500
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:3900 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279AbZANTgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 14:36:21 -0500
Subject: Re: [PATCH 0/10] MAINTAINERS - script, patterns, and misc fixes
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, pavel@ucw.cz, linux-kernel@vger.kernel.org
In-Reply-To: <20090113231329.ee0e534f.akpm@linux-foundation.org>
References: <1231878498-25171-1-git-send-email-joe@perches.com>
	 <20090113125435.4821123a.akpm@linux-foundation.org>
	 <1231907210.7935.527.camel@localhost>
	 <20090113231329.ee0e534f.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 14 Jan 2009 11:37:17 -0800
Message-Id: <1231961837.30095.23.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-13 at 23:13 -0800, Andrew Morton wrote:
> On Tue, 13 Jan 2009 20:26:50 -0800 Joe Perches <joe@perches.com> wrote:
> > get_maintainer output is in alphabetical order,
> > not ordered by signer frequency.
> The latter would be better?
> > Balbir Singh is one of the top 5 signers over the last year
> > for mm/filemap.c excluding you and Linus.
> > $ git log --since=1-year-ago mm/filemap.c | \
> > 	grep -P "^ +.*by:" | sort | uniq -c | sort -rn | head
> >      38     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> >      35     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> >      14     Signed-off-by: Nick Piggin <npiggin@suse.de>
> >       5     Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> >       5     Signed-off-by: Hugh Dickins <hugh@veritas.com>
> >       4     Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> >       4     Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> I assume there's some remove-akpm rule?  If so, can we please remove
> it?  This tool will be used for bug reports and patches - I want to see
> those emails!

Hi Andrew.

This seems to do what you want.

commit ce0155dfa768f29e09b45a818e177274ff26bf97
Author: Joe Perches <joe@perches.com>
Date:   Wed Jan 14 11:25:06 2009 -0800

    scripts/get_maintainers.pl - Output maintainers by commit frequency
    
    Do not sort the maintainers alphabetically
    
    Also add git options:
    
    git-max-maintainers - maximum # of signers to list
    git-min-signatures - minimum signatures to be considered maintainer
    git-since - git history to use
    
    Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 43da676..48e2d5f 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -13,7 +13,7 @@
 use strict;
 
 my $P = $0;
-my $V = '0.12';
+my $V = '0.13';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -25,6 +25,9 @@ my $email_list = 1;
 my $email_subscriber_list = 0;
 my $email_git = 1;
 my $email_git_penguin_chiefs = 0;
+my $email_git_min_signatures = 1;
+my $email_git_max_maintainers = 5;
+my $email_git_since = "1-year-ago";
 my $output_multiline = 1;
 my $output_separator = ", ";
 my $scm = 0;
@@ -37,7 +40,8 @@ my $exit = 0;
 
 my @penguin_chief = ();
 push(@penguin_chief,"Linus Torvalds:torvalds\@linux-foundation.org");
-push(@penguin_chief,"Andrew Morton:akpm\@linux-foundation.org");
+#Andrew wants in on most everything - 2009/01/14
+#push(@penguin_chief,"Andrew Morton:akpm\@linux-foundation.org");
 
 my @penguin_chief_names = ();
 foreach my $chief (@penguin_chief) {
@@ -53,6 +57,9 @@ if (!GetOptions(
 		'email!' => \$email,
 		'git!' => \$email_git,
 		'git-chief-penguins!' => \$email_git_penguin_chiefs,
+		'git-min-signatures=i' => \$email_git_min_signatures,
+		'git-max-maintainers=i' => \$email_git_max_maintainers,
+		'git-since=s' => \$email_git_since,
 		'm!' => \$email_maintainer,
 		'n!' => \$email_usename,
 		'l!' => \$email_list,
@@ -154,29 +161,11 @@ my @status = ();
 
 # Find responsible parties
 
-if ($email_git_penguin_chiefs) {
-    foreach my $chief (@penguin_chief) {
-	if ($chief =~ m/^(.*):(.*)/) {
-	    my $chief_name = $1;
-	    my $chief_addr = $2;
-	    if ($email_usename) {
-		push(@email_to, format_email($chief_name, $chief_addr));
-	    } else {
-		push(@email_to, $chief_addr);
-	    }
-	}
-    }
-}
-
 foreach my $file (@files) {
-    my $exclude = 0;
-
-    if ($email_git) {
-	recent_git_signoffs($file);
-    }
 
 #Do not match excluded file patterns
 
+    my $exclude = 0;
     foreach my $line (@typevalue) {
 	if ($line =~ m/^(\C):(.*)/) {
 	    my $type = $1;
@@ -204,6 +193,25 @@ foreach my $file (@files) {
 	    $tvi++;
 	}
     }
+
+    if ($email_git) {
+	recent_git_signoffs($file);
+    }
+
+}
+
+if ($email_git_penguin_chiefs) {
+    foreach my $chief (@penguin_chief) {
+	if ($chief =~ m/^(.*):(.*)/) {
+	    my $chief_name = $1;
+	    my $chief_addr = $2;
+	    if ($email_usename) {
+		push(@email_to, format_email($chief_name, $chief_addr));
+	    } else {
+		push(@email_to, $chief_addr);
+	    }
+	}
+    }
 }
 
 if ($email) {
@@ -211,7 +219,9 @@ if ($email) {
     if ($address_cnt == 0 && $email_list) {
 	push(@email_to, "linux-kernel\@vger.kernel.org");
     }
-    @email_to = sort_and_uniq(@email_to);
+
+#Don't sort email address list, but do remove duplicates
+    @email_to = uniq(@email_to);
     output(@email_to);
 }
 
@@ -273,6 +283,9 @@ MAINTAINER field selection options:
   --email => print email address(es) if any
     --git => include recent git \*-by: signers
     --git-chief-penguins => include ${penguin_chiefs}
+    --git-min-signatures => number of signatures required (default: 1)
+    --git-max-maintainers => maximum maintainers to add (default: 5)
+    --git-max-history => git history to use (default: 1-year-ago)
     --m => include maintainer(s) if any
     --n => include name 'Full Name <addr\@domain.tld>'
     --l => include list(s) if any
@@ -406,27 +419,36 @@ sub recent_git_signoffs {
     my $sign_offs = "";
     my $cmd = "";
     my $output = "";
-
+    my $count = 0;
     my @lines = ();
 
     if (which("git") eq "") {
 	die("$P: git not found.  Add --nogit to options?\n");
     }
 
-    $cmd = "git log --since=12.months.ago -- ${file}";
-    $cmd .= " | grep -i '^    [-a-z]*by:.*\\\@'";
+    $cmd = "git log --since=${email_git_since} -- ${file}";
+    $cmd .= " | grep -P '^    [-A-Za-z]+by:.*\\\@'";
     if (!$email_git_penguin_chiefs) {
 	$cmd .= " | grep -E -v \"${penguin_chiefs}\"";
     }
-    $cmd .= " | sort | uniq -c | sort -r -n | head -n 5";
-    $cmd .= " | cut -f 2 -d ':' -s";
+    $cmd .= " | sort | uniq -c | sort -rn";
 
     $output = `${cmd}`;
-
     $output =~ s/^\s*//gm;
 
     @lines = split("\n", $output);
     foreach my $line (@lines) {
+	if ($line =~ m/([0-9]+)\s+([-A-Za-z]+by:)\s+(.*)/) {
+	    my $sign_offs = $1;
+	    $line = $3;
+	    $count++;
+	    if ($sign_offs < $email_git_min_signatures ||
+	        $count > $email_git_max_maintainers) {
+		last;
+	    }
+	} else {
+	    die("$P: Unexpected git output: ${line}\n");
+	}
 	if ($line =~ m/(.*) <(.*)>/) {
 	    my $git_name = $1;
 	    my $git_addr = $2;
@@ -447,6 +469,14 @@ sub recent_git_signoffs {
     return $output;
 }
 
+sub uniq {
+    my @parms = @_;
+
+    my %saw;
+    @parms = grep(!$saw{$_}++, @parms);
+    return @parms;
+}
+
 sub sort_and_uniq {
     my @parms = @_;
 


