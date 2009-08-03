Return-Path: <linux-kernel-owner+w=401wt.eu-S1754647AbZHCVYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbZHCVYV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 17:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbZHCVYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 17:24:20 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2611 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbZHCVYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 17:24:19 -0400
Subject: [PATCH] scripts/get_maintainer.pl: Add sections in pattern match
 directory depth order
From: Joe Perches <joe@perches.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Julia Lawall <julia@diku.dk>
Content-Type: text/plain
Date: Mon, 03 Aug 2009 14:24:18 -0700
Message-Id: <1249334658.5149.64.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before this change, matched sections were added in the normally
alphabetic order of MAINTAINERS.
    
For instance, finding the maintainer for drivers/scsi/wd7000.c
would first find "SCSI SUBSYSTEM", then "WD7000 SCSI SUBSYSTEM",
then "THE REST".
    
before patch:
    
$ ./scripts/get_maintainer.pl --nogit -f drivers/scsi/wd7000.c
James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Miroslav Zagorac <zaga@fly.cc.fer.hr>
linux-scsi@vger.kernel.org
linux-kernel@vger.kernel.org
    
This patch does a length based directory match depth check by
counting the number of "/" characters in the pattern and adding
1 more if the pattern is not a directory, then selecting the
matched pattern sections by greatest depth.
    
This changes the example output order of MAINTAINERS to whatever is
selected in "WD7000 SUBSYSTEM", then "SCSI SYSTEM", then "THE REST".
    
after patch:
    
$ ./scripts/get_maintainer.pl --nogit -f drivers/scsi/wd7000.c
Miroslav Zagorac <zaga@fly.cc.fer.hr>
James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
linux-scsi@vger.kernel.org
linux-kernel@vger.kernel.org
    
Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 278a45b..e875430 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -13,7 +13,7 @@
 use strict;
 
 my $P = $0;
-my $V = '0.17';
+my $V = '0.18';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -201,6 +201,7 @@ foreach my $file (@files) {
 	    if ($type eq 'X') {
 		if (file_match_pattern($file, $value)) {
 		    $exclude = 1;
+		    last;
 		}
 	    }
 	}
@@ -208,18 +209,24 @@ foreach my $file (@files) {
 
     if (!$exclude) {
 	my $tvi = 0;
+	my %hash;
 	foreach my $line (@typevalue) {
 	    if ($line =~ m/^(\C):\s*(.*)/) {
 		my $type = $1;
 		my $value = $2;
 		if ($type eq 'F') {
 		    if (file_match_pattern($file, $value)) {
-			add_categories($tvi);
+			my $pattern_depth = ($value =~ tr@/@@);
+			$pattern_depth++ if (!(substr($value,-1,1) eq "/"));
+			$hash{$tvi} = $pattern_depth;
 		    }
 		}
 	    }
 	    $tvi++;
 	}
+	foreach my $line (sort {$hash{$b} <=> $hash{$a}} keys %hash) {
+	    add_categories($line);
+	}
     }
 
     if ($email && $email_git) {


