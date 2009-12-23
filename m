Return-Path: <linux-kernel-owner+w=401wt.eu-S1755917AbZLWNzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbZLWNzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 08:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755855AbZLWNzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 08:55:37 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:45468 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046AbZLWNzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 08:55:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=pPInel9cHVK0LMc5/2Tx+jxqBjtdAWXE9C8wk0qCP+5rGrZjzcsEkGfpa0uWhq7f6u
         Djhn3kysgBKKndOHY3jFsUdUUveb/sCSbUC4OTiNVo9AZx3rKY7nZOAe9osMWg92ZN3o
         YZ3jP9TmP2pCcKpHUuKtLydrbZh6QNiuBZ1mg=
MIME-Version: 1.0
Date: Wed, 23 Dec 2009 14:55:35 +0100
Message-ID: <9ea470500912230555k6b72407al730da6361d8aba0f@mail.gmail.com>
Subject: [PATCH] scripts/get_maintainer.pl: add support for STDIN:
From: Borislav Petkov <petkovbb@googlemail.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Teach get_maintainer.pl to read a diff from STDIN so that you can do
something like:

git diff | ./scripts/get_maintainer.pl -

and have the Cc: list before writing the commit message.

Cc: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 scripts/get_maintainer.pl |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 445e884..80d5a69 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -5,7 +5,7 @@
 # Print selected MAINTAINERS information for
 # the files modified in a patch or for a file
 #
-# usage: perl scripts/get_maintainer.pl [OPTIONS] <patch>
+# usage: perl scripts/get_maintainer.pl [OPTIONS] <patch>|STDIN
 #        perl scripts/get_maintainer.pl [OPTIONS] -f <file>
 #
 # Licensed under the terms of the GNU GPL License version 2
@@ -237,7 +237,7 @@ foreach my $file (@ARGV) {
     ##if $file is a directory and it lacks a trailing slash, add one
     if ((-d $file)) {
 	$file =~ s@([^/])$@$1/@;
-    } elsif (!(-f $file)) {
+    } elsif (!(-f $file) && ($file ne '-')) {
 	die "$P: file '${file}' not found\n";
     }
     if ($from_filename) {
@@ -255,7 +255,11 @@ foreach my $file (@ARGV) {
     } else {
 	my $file_cnt = @files;
 	my $lastfile;
-	open(PATCH, "<$file") or die "$P: Can't open ${file}\n";
+	if ($file eq '-') {
+	    open(PATCH, "<&STDIN");
+	} else {
+	    open(PATCH, "<$file") or die "$P: Can't open ${file}\n";
+	}
 	while (<PATCH>) {
 	    my $patch_line = $_;
 	    if (m/^\+\+\+\s+(\S+)/) {
@@ -422,7 +426,7 @@ sub file_match_pattern {

 sub usage {
     print <<EOT;
-usage: $P [options] patchfile
+usage: $P [options] patchfile|-
        $P [options] -f file|directory
 version: $V

-- 
1.6.5.4


-- 
Regards/Gruss,
Boris
