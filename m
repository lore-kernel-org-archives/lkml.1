Return-Path: <linux-kernel-owner+w=401wt.eu-S1754297AbZGITgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297AbZGITgI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 15:36:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754845AbZGITfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 15:35:48 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1499 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356AbZGITfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 15:35:47 -0400
Subject: Re: [PATCH 5/7] MAINTAINERS: Remove L: linux-kernel@vger.kernel.org
From: Joe Perches <joe@perches.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>
In-Reply-To: <20090709150810.GA25112@rakim.wolfsonmicro.main>
References: <cover.1247032324.git.joe@perches.com>
	 <9c84258bdd3ebecd54e2bc203dbded1382af9c02.1247032324.git.joe@perches.com>
	 <84144f020907072332h4f0cdc16lfed34f6509782394@mail.gmail.com>
	 <1247035197.5124.9.camel@Joe-Laptop.home>
	 <1247035481.15919.31.camel@penberg-laptop>
	 <1247035628.5124.11.camel@Joe-Laptop.home>
	 <20090709093004.GA32655@sirena.org.uk>
	 <1247151536.12426.39.camel@Joe-Laptop.home>
	 <20090709150810.GA25112@rakim.wolfsonmicro.main>
Content-Type: text/plain
Date: Thu, 09 Jul 2009 12:35:39 -0700
Message-Id: <1247168139.3461.2.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-09 at 16:08 +0100, Mark Brown wrote:
> That's pretty much what I was thinking of too - tweaking the values for
> the log queries based on the total number of hits so people only turn up
> if they did a certain proportion of the commits.  It'd take some
> experimentation to work out what the values to use should be, I guess.

Perhaps something like this:

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 7fc09fc..a97f248 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -27,6 +27,7 @@ my $email_git = 1;
 my $email_git_penguin_chiefs = 0;
 my $email_git_min_signatures = 1;
 my $email_git_max_maintainers = 5;
+my $email_git_min_percent = 0;
 my $email_git_since = "1-year-ago";
 my $output_multiline = 1;
 my $output_separator = ", ";
@@ -65,6 +66,7 @@ if (!GetOptions(
 		'git-chief-penguins!' => \$email_git_penguin_chiefs,
 		'git-min-signatures=i' => \$email_git_min_signatures,
 		'git-max-maintainers=i' => \$email_git_max_maintainers,
+		'git-min-percent=i' => \$email_git_min_percent,
 		'git-since=s' => \$email_git_since,
 		'm!' => \$email_maintainer,
 		'n!' => \$email_usename,
@@ -307,6 +309,7 @@ MAINTAINER field selection options:
     --git-chief-penguins => include ${penguin_chiefs}
     --git-min-signatures => number of signatures required (default: 1)
     --git-max-maintainers => maximum maintainers to add (default: 5)
+    --git-min-percent => minimum percentage of commits required (default: 0)
     --git-since => git history to use (default: 1-year-ago)
     --m => include maintainer(s) if any
     --n => include name 'Full Name <addr\@domain.tld>'
@@ -497,6 +500,7 @@ sub recent_git_signoffs {
     my $output = "";
     my $count = 0;
     my @lines = ();
+    my $total_sign_offs;
 
     if (which("git") eq "") {
 	warn("$P: git not found.  Add --nogit to options?\n");
@@ -520,6 +524,14 @@ sub recent_git_signoffs {
     $output =~ s/^\s*//gm;
 
     @lines = split("\n", $output);
+
+    $total_sign_offs = 0;
+    foreach my $line (@lines) {
+	if ($line =~ m/([0-9]+)\s+(.*)/) {
+	    $total_sign_offs += $1;
+	}
+    }
+
     foreach my $line (@lines) {
 	if ($line =~ m/([0-9]+)\s+(.*)/) {
 	    my $sign_offs = $1;
@@ -529,6 +541,11 @@ sub recent_git_signoffs {
 	        $count > $email_git_max_maintainers) {
 		last;
 	    }
+	    if ($email_git_min_percent > 0 &&
+		(($sign_offs * 100 / $total_sign_offs) < $email_git_min_percent)
+		) {
+		last;
+	    }
 	} else {
 	    die("$P: Unexpected git output: ${line}\n");
 	}


