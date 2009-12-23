Return-Path: <linux-kernel-owner+w=401wt.eu-S1756108AbZLWX1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbZLWX1K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 18:27:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755479AbZLWX1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 18:27:08 -0500
Received: from mail.perches.com ([173.55.12.10]:1400 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938AbZLWX1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 18:27:08 -0500
Subject: [PATCH] scripts/get_maintainer.pl: add support to read patch from
 STDIN
From: Joe Perches <joe@perches.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <9ea470500912230555k6b72407al730da6361d8aba0f@mail.gmail.com>
References: <9ea470500912230555k6b72407al730da6361d8aba0f@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Dec 2009 15:27:04 -0800
Message-ID: <1261610824.1923.58.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-23 at 14:55 +0100, Borislav Petkov wrote:
> Teach get_maintainer.pl to read a diff from STDIN

How about this instead?

Doesn't need or accept '-' as a trailing option to read stdin.
Doesn't print usage() after bad options.
Adds --usage as command line equivalent of --help

Signed-off-by: Joe Perches <joe@perches.com>

 scripts/get_maintainer.pl |  110 ++++++++++++++++++++++++++++-----------------
 1 files changed, 69 insertions(+), 41 deletions(-)

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


