Return-Path: <linux-kernel-owner+w=401wt.eu-S1753414AbZHFAvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414AbZHFAvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 20:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbZHFAva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 20:51:30 -0400
Received: from mail.atheros.com ([12.36.123.2]:29956 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752330AbZHFAvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 20:51:17 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <akpm@linux-foundation.org>, <joe@perches.com>,
       <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <mcgrof@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 3/3] checkincludes.pl: add option to remove duplicates in place
Date: Wed, 5 Aug 2009 17:51:12 -0700
Message-ID: <1249519872-23958-4-git-send-email-lrodriguez@atheros.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249519872-23958-1-git-send-email-lrodriguez@atheros.com>
References: <1249519872-23958-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

checkincludes.pl is more useful if it actually removed
the lines. This adds support for that with -r.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 scripts/checkincludes.pl |   57 +++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 51 insertions(+), 6 deletions(-)

diff --git a/scripts/checkincludes.pl b/scripts/checkincludes.pl
index 4bff139..5a53407 100755
--- a/scripts/checkincludes.pl
+++ b/scripts/checkincludes.pl
@@ -2,32 +2,77 @@
 #
 # checkincludes: Find files included more than once in (other) files.
 # Copyright abandoned, 2000, Niels Kristian Bech Jensen <nkbj@image.dk>.
+# Copyright abandoned, 2009, Luis R. Rodriguez <mcgrof@gmail.com>
 
 sub usage {
-	print "Usage: checkincludes.pl <file list>\n";
+	print "Usage: checkincludes.pl [-r]\n";
+	print "By default we just warn of duplicates\n";
+	print "To remove files in place use -r\n";
 	exit 1;
 }
 
+my $remove = 0;
+
 if ($#ARGV < 0) {
-        usage();
+	usage();
+}
+
+if ($#ARGV >= 1) {
+	if ($ARGV[0] =~ /^-/) {
+		if ($ARGV[0] eq "-r") {
+			$remove = 1;
+			shift;
+		} else {
+			usage();
+		}
+	}
 }
 
 foreach $file (@ARGV) {
 	open(FILE, $file) or die "Cannot open $file: $!.\n";
 
 	my %includedfiles = ();
+	my @file_lines = ();
 
 	while (<FILE>) {
 		if (m/^\s*#\s*include\s*[<"](\S*)[>"]/o) {
 			++$includedfiles{$1};
 		}
+		push(@file_lines, $_);
 	}
 
 	close(FILE);
-	
-	foreach $filename (keys %includedfiles) {
-		if ($includedfiles{$filename} > 1) {
-			print "$file: $filename is included more than once.\n";
+
+	if (!$remove) {
+		foreach $filename (keys %includedfiles) {
+			if ($includedfiles{$filename} > 1) {
+				print "$file: $filename is included more than once.\n";
+			}
 		}
+		next;
 	}
+
+	open(FILE,">$file") || die("Cannot write to $file: $!");
+
+	my $dups = 0;
+	foreach (@file_lines) {
+		if (m/^\s*#\s*include\s*[<"](\S*)[>"]/o) {
+			foreach $filename (keys %includedfiles) {
+				if ($1 eq $filename) {
+					if ($includedfiles{$filename} > 1) {
+						$includedfiles{$filename}--;
+						$dups++;
+					} else {
+						print FILE $_;
+					}
+				}
+			}
+		} else {
+			print FILE $_;
+		}
+	}
+	if ($dups > 0) {
+		print "$file: removed $dups duplicate includes\n";
+	}
+	close(FILE);
 }
-- 
1.6.3.3

