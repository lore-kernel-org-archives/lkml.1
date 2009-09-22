Return-Path: <linux-kernel-owner+w=401wt.eu-S1752250AbZIVCO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250AbZIVCO5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 22:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbZIVCOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 22:14:50 -0400
Received: from fifo99.com ([67.223.236.141]:40485 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbZIVCOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 22:14:48 -0400
From: Daniel Walker <dwalker@fifo99.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org,
       Daniel Walker <dwalker@fifo99.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 3/5] checkpatch: add a blacklist
Date: Mon, 21 Sep 2009 19:14:49 -0700
Message-Id: <1253585691-10987-3-git-send-email-dwalker@fifo99.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1253585691-10987-2-git-send-email-dwalker@fifo99.com>
References: <1253585691-10987-1-git-send-email-dwalker@fifo99.com>
 <1253585691-10987-2-git-send-email-dwalker@fifo99.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are times when maintainers intentially don't follow the coding
style. When that happens it means some errors need to be ignored, so
that other errors can be focused on.

To handle that I added a blacklist to checkpatch. The blacklist holds the
file names and errors which are ignored. The output is modified to
remove the errors from the list and not to count them.

When the blacklist kicks in there is a note that does list how many
errors got removed and that it was due to a blacklist entry. There is
also a new option "--noblacklist" that allows the errors to be added
back as it was without the blacklist.

There is also a small fix I added to correct a problem when "--file" is
used. The patch output had one level of the directory structure
removed, which prevented the blacklist from catching those filenames.

Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Daniel Walker <dwalker@fifo99.com>
---
 scripts/checkpatch.pl |   36 ++++++++++++++++++++++++++++++++++--
 1 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 1c48a6c..c7f741f 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -26,6 +26,7 @@ my $check = 0;
 my $summary = 1;
 my $mailback = 0;
 my $summary_file = 0;
+my $noblacklist = 0;
 my $root;
 my %debug;
 GetOptions(
@@ -42,6 +43,7 @@ GetOptions(
 	'summary!'	=> \$summary,
 	'mailback!'	=> \$mailback,
 	'summary-file!'	=> \$summary_file,
+	'noblacklist'	=> \$noblacklist,
 
 	'debug=s'	=> \%debug,
 	'test-only=s'	=> \$tst_only,
@@ -61,6 +63,7 @@ if ($#ARGV < 0) {
 	print "         --root           => path to the kernel tree root\n";
 	print "         --no-summary     => suppress the per-file summary\n";
 	print "         --summary-file   => include the filename in summary\n";
+	print "         --noblacklist    => enable blacklisted file checking\n";
 	exit(1);
 }
 
@@ -99,6 +102,16 @@ if ($tree) {
 	}
 }
 
+# This blacklist should be used to remove errors that certain maintainers have
+# ordained as good for whatever reason. This list should not get very long.
+my @blacklist = (
+	# ftrace uses large numbers of spaces and tabs to space out certain
+	# macro in the include files. It's known, and it's doubtful any clean
+	# up there will be accepted.
+	[ 'include/trace/events/', 'space prohibited after that open parenthesis'],
+	[ 'include/trace/events/', 'space prohibited before that close parenthes'],
+);
+
 my $emitted_corrupt = 0;
 
 our $Ident       = qr{[A-Za-z_][A-Za-z\d_]*};
@@ -1005,6 +1018,19 @@ sub report {
 	if (defined $tst_only && $_[0] !~ /\Q$tst_only\E/) {
 		return 0;
 	}
+
+	# Check that this code isn't in the black list.
+	if (!$noblacklist) {
+		for my $blacked_out (@blacklist) {
+			my $file = ${$blacked_out}[0];
+			my $msg = ${$blacked_out}[1];
+
+			if ($_[0] =~ /FILE:\s$file/m && $_[0] =~ /$msg/m) {
+				our $cnt_blacklisted++;
+				return 0;
+			}
+		}
+	}
 	my $line = $prefix . $_[0];
 
 	$line = (split('\n', $line))[0] . "\n" if ($terse);
@@ -1085,6 +1111,7 @@ sub process {
 	our $cnt_error = 0;
 	our $cnt_warn = 0;
 	our $cnt_chk = 0;
+	our $cnt_blacklisted = 0;
 
 	# Trace the real file/line as we go.
 	my $realfile = '';
@@ -1243,9 +1270,11 @@ sub process {
 		# extract the filename as it passes
 		if ($line=~/^\+\+\+\s+(\S+)/) {
 			$realfile = $1;
-			$realfile =~ s@^([^/]*)/@@;
+			if (!$file) {
+				$realfile =~ s@^([^/]*)/@@;
+				$p1_prefix = $1;
+			}
 
-			$p1_prefix = $1;
 			if (!$file && $tree && $p1_prefix ne '' &&
 			    -e "$root/$p1_prefix") {
 				WARN("patch prefix '$p1_prefix' exists, appears to be a -p0 patch\n");
@@ -2606,6 +2635,9 @@ sub process {
 			"$cnt_lines lines checked\n";
 		print "\n" if ($quiet == 0);
 	}
+	if ($cnt_blacklisted != 0 && !$noblacklist && $quiet == 0) {
+		print "NOTE: $cnt_blacklisted errors have been removed due to the blacklist.\n\n"
+	}
 
 	if ($clean == 1 && $quiet == 0) {
 		print "$vname has no obvious style problems and is ready for submission.\n"
-- 
1.5.6.3

