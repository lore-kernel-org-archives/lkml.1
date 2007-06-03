Return-Path: <linux-kernel-owner+w=401wt.eu-S1751964AbXFCUqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964AbXFCUqo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 16:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753070AbXFCUqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 16:46:00 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:55921 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416AbXFCUp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 16:45:58 -0400
Date: Sun, 3 Jun 2007 22:47:00 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net
Subject: [PATCH 08/19] scripts: Make cleanfile/cleanpatch warn about long lines
Message-ID: <20070603204700.GH9240@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 08/19] scripts: Make cleanfile/cleanpatch warn about long lines
From: H. Peter Anvin <hpa@zytor.com>
Date: Fri, 25 May 2007 17:58:26 -0700

Make the "cleanfile" and "cleanpatch" script warn about long lines,
by default lines whose visual width exceeds 79 characters.

Per suggestion from Auke Kok.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/cleanfile  |   54 ++++++++++++++++++++++++++++++++++++++++++++++-
 scripts/cleanpatch |   58 +++++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 107 insertions(+), 5 deletions(-)

diff --git a/scripts/cleanfile b/scripts/cleanfile
index f1ba8aa..cefd29e 100755
--- a/scripts/cleanfile
+++ b/scripts/cleanfile
@@ -7,7 +7,9 @@
 use bytes;
 use File::Basename;
 
-#
+# Default options
+$max_width = 79;
+
 # Clean up space-tab sequences, either by removing spaces or
 # replacing them with tabs.
 sub clean_space_tabs($)
@@ -48,9 +50,49 @@ sub clean_space_tabs($)
     return $lo;
 }
 
+# Compute the visual width of a string
+sub strwidth($) {
+    no bytes;			# Tab alignment depends on characters
+
+    my($li) = @_;
+    my($c, $i);
+    my $pos = 0;
+    my $mlen = 0;
+
+    for ($i = 0; $i < length($li); $i++) {
+	$c = substr($li,$i,1);
+	if ($c eq "\t") {
+	    $pos = ($pos+8) & ~7;
+	} elsif ($c eq "\n") {
+	    $mlen = $pos if ($pos > $mlen);
+	    $pos = 0;
+	} else {
+	    $pos++;
+	}
+    }
+
+    $mlen = $pos if ($pos > $mlen);
+    return $mlen;
+}
+
 $name = basename($0);
 
-foreach $f ( @ARGV ) {
+@files = ();
+
+while (defined($a = shift(@ARGV))) {
+    if ($a =~ /^-/) {
+	if ($a eq '-width' || $a eq '-w') {
+	    $max_width = shift(@ARGV)+0;
+	} else {
+	    print STDERR "Usage: $name [-width #] files...\n";
+	    exit 1;
+	}
+    } else {
+	push(@files, $a);
+    }
+}
+
+foreach $f ( @files ) {
     print STDERR "$name: $f\n";
 
     if (! -f $f) {
@@ -90,8 +132,10 @@ foreach $f ( @ARGV ) {
 
     @blanks = ();
     @lines  = ();
+    $lineno = 0;
 
     while ( defined($line = <FILE>) ) {
+	$lineno++;
 	$in_bytes += length($line);
 	$line =~ s/[ \t\r]*$//;		# Remove trailing spaces
 	$line = clean_space_tabs($line);
@@ -107,6 +151,12 @@ foreach $f ( @ARGV ) {
 	    @blanks = ();
 	    $blank_bytes = 0;
 	}
+
+	$l_width = strwidth($line);
+	if ($max_width && $l_width > $max_width) {
+	    print STDERR
+		"$f:$lineno: line exceeds $max_width characters ($l_width)\n";
+	}
     }
 
     # Any blanks at the end of the file are discarded
diff --git a/scripts/cleanpatch b/scripts/cleanpatch
index a53f987..9680d03 100755
--- a/scripts/cleanpatch
+++ b/scripts/cleanpatch
@@ -7,7 +7,9 @@
 use bytes;
 use File::Basename;
 
-#
+# Default options
+$max_width = 79;
+
 # Clean up space-tab sequences, either by removing spaces or
 # replacing them with tabs.
 sub clean_space_tabs($)
@@ -48,9 +50,49 @@ sub clean_space_tabs($)
     return $lo;
 }
 
+# Compute the visual width of a string
+sub strwidth($) {
+    no bytes;			# Tab alignment depends on characters
+
+    my($li) = @_;
+    my($c, $i);
+    my $pos = 0;
+    my $mlen = 0;
+
+    for ($i = 0; $i < length($li); $i++) {
+	$c = substr($li,$i,1);
+	if ($c eq "\t") {
+	    $pos = ($pos+8) & ~7;
+	} elsif ($c eq "\n") {
+	    $mlen = $pos if ($pos > $mlen);
+	    $pos = 0;
+	} else {
+	    $pos++;
+	}
+    }
+
+    $mlen = $pos if ($pos > $mlen);
+    return $mlen;
+}
+
 $name = basename($0);
 
-foreach $f ( @ARGV ) {
+@files = ();
+
+while (defined($a = shift(@ARGV))) {
+    if ($a =~ /^-/) {
+	if ($a eq '-width' || $a eq '-w') {
+	    $max_width = shift(@ARGV)+0;
+	} else {
+	    print STDERR "Usage: $name [-width #] files...\n";
+	    exit 1;
+	}
+    } else {
+	push(@files, $a);
+    }
+}
+
+foreach $f ( @files ) {
     print STDERR "$name: $f\n";
 
     if (! -f $f) {
@@ -86,6 +128,7 @@ foreach $f ( @ARGV ) {
 
     $in_bytes = 0;
     $out_bytes = 0;
+    $lineno = 0;
 
     @lines  = ();
 
@@ -93,10 +136,12 @@ foreach $f ( @ARGV ) {
     $err = 0;
 
     while ( defined($line = <FILE>) ) {
+	$lineno++;
 	$in_bytes += length($line);
 
 	if (!$in_hunk) {
-	    if ($line =~ /^\@\@\s+\-([0-9]+),([0-9]+)\s+\+([0-9]+),([0-9]+)\s\@\@/) {
+	    if ($line =~
+		/^\@\@\s+\-([0-9]+),([0-9]+)\s+\+([0-9]+),([0-9]+)\s\@\@/) {
 		$minus_lines = $2;
 		$plus_lines = $4;
 		if ($minus_lines || $plus_lines) {
@@ -117,6 +162,13 @@ foreach $f ( @ARGV ) {
 		$text =~ s/[ \t\r]*$//;		# Remove trailing spaces
 		$text = clean_space_tabs($text);
 
+		$l_width = strwidth($text);
+		if ($max_width && $l_width > $max_width) {
+		    print STDERR
+			"$f:$lineno: adds line exceeds $max_width ",
+			"characters ($l_width)\n";
+		}
+
 		push(@hunk_lines, '+'.$text);
 	    } elsif ($line =~ /^\-/) {
 		$minus_lines--;
-- 
1.5.1.rc3.1544.g8a923


----- End forwarded message -----
