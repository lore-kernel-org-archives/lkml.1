Return-Path: <linux-kernel-owner+w=401wt.eu-S1756823AbYLGSdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823AbYLGSdv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 13:33:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754678AbYLGSbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 13:31:08 -0500
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:55716 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604AbYLGSbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 13:31:07 -0500
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 08/13] checkpatch: track #ifdef/#else/#endif when tracking blocks
Date: Sun,  7 Dec 2008 18:30:45 +0000
Message-Id: <1228674650-24392-9-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.4.911.gc990
In-Reply-To: <1228674650-24392-1-git-send-email-apw@shadowen.org>
References: <1228674650-24392-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Whitcroft <apw@canonical.com>

When picking up a complete statement or block for analysis we cannot
simply track open/close/etc parenthesis we must take into account
preprocessor section boundaries.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 67b0c9f..906624c 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -405,6 +405,7 @@ sub ctx_statement_block {
 
 	my $type = '';
 	my $level = 0;
+	my @stack = ([$type, $level]);
 	my $p;
 	my $c;
 	my $len = 0;
@@ -436,6 +437,16 @@ sub ctx_statement_block {
 		$remainder = substr($blk, $off);
 
 		#warn "CSB: c<$c> type<$type> level<$level> remainder<$remainder> coff_set<$coff_set>\n";
+
+		# Handle nested #if/#else.
+		if ($remainder =~ /^#\s*(?:ifndef|ifdef|if)\s/) {
+			push(@stack, [ $type, $level ]);
+		} elsif ($remainder =~ /^#\s*(?:else|elif)\b/) {
+			($type, $level) = @{$stack[$#stack - 1]};
+		} elsif ($remainder =~ /^#\s*endif\b/) {
+			($type, $level) = @{pop(@stack)};
+		}
+
 		# Statement ends at the ';' or a close '}' at the
 		# outermost level.
 		if ($level == 0 && $c eq ';') {
@@ -582,11 +593,22 @@ sub ctx_block_get {
 	my @res = ();
 
 	my $level = 0;
+	my @stack = ($level);
 	for ($line = $start; $remain > 0; $line++) {
 		next if ($rawlines[$line] =~ /^-/);
 		$remain--;
 
 		$blk .= $rawlines[$line];
+
+		# Handle nested #if/#else.
+		if ($rawlines[$line] =~ /^.\s*#\s*(?:ifndef|ifdef|if)\s/) {
+			push(@stack, $level);
+		} elsif ($rawlines[$line] =~ /^.\s*#\s*(?:else|elif)\b/) {
+			$level = $stack[$#stack - 1];
+		} elsif ($rawlines[$line] =~ /^.\s*#\s*endif\b/) {
+			$level = pop(@stack);
+		}
+
 		foreach my $c (split(//, $rawlines[$line])) {
 			##print "C<$c>L<$level><$open$close>O<$off>\n";
 			if ($off > 0) {
-- 
1.6.0.4.911.gc990

