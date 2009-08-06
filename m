Return-Path: <linux-kernel-owner+w=401wt.eu-S1753741AbZHFCnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741AbZHFCnz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 22:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753634AbZHFCnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 22:43:52 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:3234 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbZHFCnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 22:43:50 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Julia Lawall <julia@diku.dk>,
       Greg KH <greg@kroah.com>
Subject: [PATCH 2/7] scripts/get_maintainer.pl: Add sections in pattern match depth order
Date: Wed,  5 Aug 2009 19:43:43 -0700
Message-Id: <0b6f4e55641868094dd770f5e2bdbf093c473b26.1249525834.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1249525834.git.joe@perches.com>
References: <cover.1249525834.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before this change, matched sections were added in the order
of appearance in the normally alphabetic section order of
the MAINTAINERS file.

For instance, finding the maintainer for drivers/scsi/wd7000.c
would first find "SCSI SUBSYSTEM", then "WD7000 SCSI SUBSYSTEM",
then "THE REST".

before patch:

$ ./scripts/get_maintainer.pl --nogit -f drivers/scsi/wd7000.c
James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Miroslav Zagorac <zaga@fly.cc.fer.hr>
linux-scsi@vger.kernel.org
linux-kernel@vger.kernel.org

get_maintainer.pl now selects matched sections by longest pattern match.
Longest is the number of "/"s and any specific file pattern.

This changes the example output order of MAINTAINERS to whatever is
selected in "WD7000 SUBSYSTEM", then "SCSI SYSTEM", then "THE REST".

after patch:

$ ./scripts/get_maintainer.pl --nogit -f drivers/scsi/wd7000.c
Miroslav Zagorac <zaga@fly.cc.fer.hr>
James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
linux-scsi@vger.kernel.org
linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/get_maintainer.pl |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 35781e0..fb446e0 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -211,6 +211,7 @@ foreach my $file (@files) {
 	    if ($type eq 'X') {
 		if (file_match_pattern($file, $value)) {
 		    $exclude = 1;
+		    last;
 		}
 	    }
 	}
@@ -218,18 +219,24 @@ foreach my $file (@files) {
 
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
-- 
1.6.3.1.10.g659a0.dirty

