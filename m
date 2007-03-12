Return-Path: <linux-kernel-owner+w=401wt.eu-S1752601AbXCLTVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbXCLTVc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 15:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752470AbXCLTVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 15:21:17 -0400
Received: from terminus.zytor.com ([192.83.249.54]:37815 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbXCLTVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 15:21:08 -0400
Message-Id: <200703121920.l2CJK24N008104@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 12 Mar 2007 12:16:30 -0700
Subject: [PATCH] cleanfile: a script to clean up stealth whitespace
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This script cleans up various classes of stealth whitespace.  In
particular, it cleans up:

- Whitespace (spaces or tabs)before newline;
- DOS line endings (CR before LF);
- Space before tab (spaces are deleted or converted to tabs);
- Empty lines at end of file.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 scripts/cleanfile |  126 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 126 insertions(+), 0 deletions(-)
 create mode 100755 scripts/cleanfile

diff --git a/scripts/cleanfile b/scripts/cleanfile
new file mode 100755
index 0000000..f1ba8aa
--- /dev/null
+++ b/scripts/cleanfile
@@ -0,0 +1,126 @@
+#!/usr/bin/perl -w
+#
+# Clean a text file -- or directory of text files -- of stealth whitespace.
+# WARNING: this can be a highly destructive operation.  Use with caution.
+#
+
+use bytes;
+use File::Basename;
+
+#
+# Clean up space-tab sequences, either by removing spaces or
+# replacing them with tabs.
+sub clean_space_tabs($)
+{
+    no bytes;			# Tab alignment depends on characters
+
+    my($li) = @_;
+    my($lo) = '';
+    my $pos = 0;
+    my $nsp = 0;
+    my($i, $c);
+
+    for ($i = 0; $i < length($li); $i++) {
+	$c = substr($li, $i, 1);
+	if ($c eq "\t") {
+	    my $npos = ($pos+$nsp+8) & ~7;
+	    my $ntab = ($npos >> 3) - ($pos >> 3);
+	    $lo .= "\t" x $ntab;
+	    $pos = $npos;
+	    $nsp = 0;
+	} elsif ($c eq "\n" || $c eq "\r") {
+	    $lo .= " " x $nsp;
+	    $pos += $nsp;
+	    $nsp = 0;
+	    $lo .= $c;
+	    $pos = 0;
+	} elsif ($c eq " ") {
+	    $nsp++;
+	} else {
+	    $lo .= " " x $nsp;
+	    $pos += $nsp;
+	    $nsp = 0;
+	    $lo .= $c;
+	    $pos++;
+	}
+    }
+    $lo .= " " x $nsp;
+    return $lo;
+}
+
+$name = basename($0);
+
+foreach $f ( @ARGV ) {
+    print STDERR "$name: $f\n";
+
+    if (! -f $f) {
+	print STDERR "$f: not a file\n";
+	next;
+    }
+
+    if (!open(FILE, '+<', $f)) {
+	print STDERR "$name: Cannot open file: $f: $!\n";
+	next;
+    }
+
+    binmode FILE;
+
+    # First, verify that it is not a binary file; consider any file
+    # with a zero byte to be a binary file.  Is there any better, or
+    # additional, heuristic that should be applied?
+    $is_binary = 0;
+
+    while (read(FILE, $data, 65536) > 0) {
+	if ($data =~ /\0/) {
+	    $is_binary = 1;
+	    last;
+	}
+    }
+
+    if ($is_binary) {
+	print STDERR "$name: $f: binary file\n";
+	next;
+    }
+
+    seek(FILE, 0, 0);
+
+    $in_bytes = 0;
+    $out_bytes = 0;
+    $blank_bytes = 0;
+
+    @blanks = ();
+    @lines  = ();
+
+    while ( defined($line = <FILE>) ) {
+	$in_bytes += length($line);
+	$line =~ s/[ \t\r]*$//;		# Remove trailing spaces
+	$line = clean_space_tabs($line);
+
+	if ( $line eq "\n" ) {
+	    push(@blanks, $line);
+	    $blank_bytes += length($line);
+	} else {
+	    push(@lines, @blanks);
+	    $out_bytes += $blank_bytes;
+	    push(@lines, $line);
+	    $out_bytes += length($line);
+	    @blanks = ();
+	    $blank_bytes = 0;
+	}
+    }
+
+    # Any blanks at the end of the file are discarded
+
+    if ($in_bytes != $out_bytes) {
+	# Only write to the file if changed
+	seek(FILE, 0, 0);
+	print FILE @lines;
+
+	if ( !defined($where = tell(FILE)) ||
+	     !truncate(FILE, $where) ) {
+	    die "$name: Failed to truncate modified file: $f: $!\n";
+	}
+    }
+
+    close(FILE);
+}
-- 
1.5.0.3

