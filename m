Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292Ab0BSHCm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 02:02:42 -0500
Received: from suva.vyatta.com ([76.74.103.44]:51980 "EHLO suva.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754174Ab0BSHCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 02:02:38 -0500
Message-Id: <20100219070130.698143797@vyatta.com>
References: <20100219070108.670062169@vyatta.com>
User-Agent: quilt/0.46-1
Date: Thu, 18 Feb 2010 23:01:09 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] get_maintainer: fix perlcritic warnings
Content-Disposition: inline; filename=cleanup-get-maintainer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perlcritic is a standard checker for Perl Best Practices.
This patch fixes most of the warnings in the get_maintainer script.
If kernel programmers are going to have checkpatch they should write
clean scripts as well...

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

---

Bareword file handle opened at line 176, column 1.  See pages 202,204 of PBP.  (Severity: 5)
Two-argument "open" used at line 176, column 1.  See page 207 of PBP.  (Severity: 5)
Bareword file handle opened at line 207, column 5.  See pages 202,204 of PBP.  (Severity: 5)
Two-argument "open" used at line 207, column 5.  See page 207 of PBP.  (Severity: 5)
Bareword file handle opened at line 246, column 6.  See pages 202,204 of PBP.  (Severity: 5)
Two-argument "open" used at line 246, column 6.  See page 207 of PBP.  (Severity: 5)
Bareword file handle opened at line 258, column 2.  See pages 202,204 of PBP.  (Severity: 5)
Two-argument "open" used at line 258, column 2.  See page 207 of PBP.  (Severity: 5)
Expression form of "eval" at line 983, column 17.  See page 161 of PBP.  (Severity: 5)
Expression form of "eval" at line 985, column 17.  See page 161 of PBP.  (Severity: 5)
Subroutine prototypes used at line 1186, column 1.  See page 194 of PBP.  (Severity: 5)
Subroutine prototypes used at line 1206, column 1.  See page 194 of PBP.  (Severity: 5)


--- a/scripts/get_maintainer.pl	2010-02-18 21:58:16.326458296 -0800
+++ b/scripts/get_maintainer.pl	2010-02-18 22:10:58.451944275 -0800
@@ -173,8 +173,9 @@ if (!top_of_kernel_tree($lk_path)) {
 my @typevalue = ();
 my %keyword_hash;
 
-open(MAINT, "<${lk_path}MAINTAINERS") || die "$P: Can't open MAINTAINERS\n";
-while (<MAINT>) {
+open (my $maint, '<', "${lk_path}MAINTAINERS")
+    or die "$P: Can't open MAINTAINERS: $!\n";
+while (<$maint>) {
     my $line = $_;
 
     if ($line =~ m/^(\C):\s*(.*)/) {
@@ -199,13 +200,14 @@ while (<MAINT>) {
 	push(@typevalue, $line);
     }
 }
-close(MAINT);
+close($maint);
 
 my %mailmap;
 
 if ($email_remove_duplicates) {
-    open(MAILMAP, "<${lk_path}.mailmap") || warn "$P: Can't open .mailmap\n";
-    while (<MAILMAP>) {
+    open(my $mailmap, '<', "${lk_path}.mailmap")
+	or warn "$P: Can't open .mailmap: $!\n";
+    while (<$mailmap>) {
 	my $line = $_;
 
 	next if ($line =~ m/^\s*#/);
@@ -224,7 +226,7 @@ if ($email_remove_duplicates) {
 	    $mailmap{$name} = \@arr;
 	}
     }
-    close(MAILMAP);
+    close($mailmap);
 }
 
 ## use the filenames on the command line or find the filenames in the patchfiles
@@ -243,20 +245,23 @@ foreach my $file (@ARGV) {
     if ($from_filename) {
 	push(@files, $file);
 	if (-f $file && $keywords) {
-	    open(FILE, "<$file") or die "$P: Can't open ${file}\n";
-	    my $text = do { local($/) ; <FILE> };
+	    open(my $f, '<', $file)
+		or die "$P: Can't open $file: $!\n";
+	    my $text = do { local($/) ; <$f> };
 	    foreach my $line (keys %keyword_hash) {
 		if ($text =~ m/$keyword_hash{$line}/x) {
 		    push(@keyword_tvi, $line);
 		}
 	    }
-	    close(FILE);
+	    close($f);
 	}
     } else {
 	my $file_cnt = @files;
 	my $lastfile;
-	open(PATCH, "<$file") or die "$P: Can't open ${file}\n";
-	while (<PATCH>) {
+
+	open(my $patch, '<', $file)
+	    or die "$P: Can't open $file: $!\n";
+	while (<$patch>) {
 	    my $patch_line = $_;
 	    if (m/^\+\+\+\s+(\S+)/) {
 		my $filename = $1;
@@ -276,7 +281,8 @@ foreach my $file (@ARGV) {
 		}
 	    }
 	}
-	close(PATCH);
+	close($patch);
+
 	if ($file_cnt == @files) {
 	    warn "$P: file '${file}' doesn't appear to be a patch.  "
 		. "Add -f to options?\n";
@@ -1183,7 +1189,7 @@ sub rfc822_strip_comments {
 
 #   valid: returns true if the parameter is an RFC822 valid address
 #
-sub rfc822_valid ($) {
+sub rfc822_valid {
     my $s = rfc822_strip_comments(shift);
 
     if (!$rfc822re) {
@@ -1203,7 +1209,7 @@ sub rfc822_valid ($) {
 #              from success with no addresses found, because an empty string is
 #              a valid list.
 
-sub rfc822_validlist ($) {
+sub rfc822_validlist {
     my $s = rfc822_strip_comments(shift);
 
     if (!$rfc822re) {

-- 

