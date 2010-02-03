Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932800Ab0BCUeM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 15:34:12 -0500
Received: from mail.perches.com ([173.55.12.10]:1843 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932657Ab0BCUeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 15:34:07 -0500
Subject: [PATCH] scripts/get_maintainer.pl: add ability to read from STDIN
From: Joe Perches <joe@perches.com>
To: Borislav Petkov <petkovbb@googlemail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Mack <daniel@caiaq.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20100203072747.GB5428@liondog.tnic>
References: <1265135412-18391-1-git-send-email-daniel@caiaq.de>
	 <1265175347.18067.5.camel@Joe-Laptop.home>
	 <20100203072747.GB5428@liondog.tnic>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Feb 2010 12:34:04 -0800
Message-ID: <1265229244.24887.64.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-03 at 08:27 +0100, Borislav Petkov wrote:
> On Tue, Feb 02, 2010 at 09:35:47PM -0800, Joe Perches wrote:
> > I think it's better if the dash isn't required.
> > 
> > http://patchwork.kernel.org/patch/69650/
> 
> Yeah, about that, when are you going to send it upstream? Or do you want
> me to do that?

I already sent it to Andrew Morton but I
think he was away for the holidays then.

Andrew, can you pick this one up please for
the next not-rc release?

Doesn't need or accept '-' as a trailing option to read stdin.
Doesn't print usage() after bad options.
Adds --usage as command line equivalent of --help

Suggested-by: Borislav Petkov <petkovbb@googlemail.com>
Signed-off-by: Joe Perches <joe@perches.com>

---
diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 445e884..9fe4628 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -122,7 +122,7 @@ if (!GetOptions(
 		'k|keywords!' => \$keywords,
 		'f|file' => \$from_filename,
 		'v|version' => \$version,
-		'h|help' => \$help,
+		'h|help|usage' => \$help,
 		)) {
     die "$P: invalid argument - use --help if necessary\n";
 }
@@ -137,9 +137,9 @@ if ($version != 0) {
     exit 0;
 }
 
-if ($#ARGV < 0) {
-    usage();
-    die "$P: argument missing: patchfile or -f file please\n";
+if (-t STDIN && !@ARGV) {
+    # We're talking to a terminal, but have no command line arguments.
+    die "$P: missing patchfile or -f file - use --help if necessary\n";
 }
 
 if ($output_separator ne ", ") {
@@ -152,14 +152,12 @@ if ($output_rolestats) {
 
 my $selections = $email + $scm + $status + $subsystem + $web;
 if ($selections == 0) {
-    usage();
     die "$P:  Missing required option: email, scm, status, subsystem or web\n";
 }
 
 if ($email &&
     ($email_maintainer + $email_list + $email_subscriber_list +
      $email_git + $email_git_penguin_chiefs + $email_git_blame) == 0) {
-    usage();
     die "$P: Please select at least 1 email option\n";
 }
 
@@ -233,12 +231,18 @@ my @files = ();
 my @range = ();
 my @keyword_tvi = ();
 
+if (!@ARGV) {
+    push(@ARGV, "&STDIN");
+}
+
 foreach my $file (@ARGV) {
-    ##if $file is a directory and it lacks a trailing slash, add one
-    if ((-d $file)) {
-	$file =~ s@([^/])$@$1/@;
-    } elsif (!(-f $file)) {
-	die "$P: file '${file}' not found\n";
+    if ($file ne "&STDIN") {
+	##if $file is a directory and it lacks a trailing slash, add one
+	if ((-d $file)) {
+	    $file =~ s@([^/])$@$1/@;
+	} elsif (!(-f $file)) {
+	    die "$P: file '${file}' not found\n";
+	}
     }
     if ($from_filename) {
 	push(@files, $file);


