Return-Path: <linux-kernel-owner+w=401wt.eu-S1759046AbYAKEVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759046AbYAKEVc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 23:21:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756082AbYAKEVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 23:21:25 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:53095 "EHLO
	dwalker1.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754998AbYAKEVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 23:21:24 -0500
Message-Id: <20080111041120.085610726@mvista.com>
User-Agent: quilt/0.46-1
Date: Thu, 10 Jan 2008 20:11:20 -0800
Message-Id: <20080111041030.043498178@mvista.com>
User-Agent: quilt/0.46-1
Date: Thu, 10 Jan 2008 20:10:30 -0800
From: Daniel Walker <dwalker@mvista.com>
To: apw@shadowen.org
Cc: linux-kernel@vger.kernel.org
CC: rdunlap@xenotime.net
CC: jschopp@austin.ibm.com
Subject: [PATCH] checkpatch.pl: allow piping
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A little feature addition to allow checkpatch.pl to check patches piped
into it, in addition to specific file arguments.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
---
 scripts/checkpatch.pl |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

Index: linux-2.6.23/scripts/checkpatch.pl
===================================================================
--- linux-2.6.23.orig/scripts/checkpatch.pl
+++ linux-2.6.23/scripts/checkpatch.pl
@@ -24,6 +24,7 @@ my $file = 0;
 my $check = 0;
 my $summary = 1;
 my $mailback = 0;
+my $piped = (-t STDIN) ? 0 : 1;
 my $root;
 GetOptions(
 	'q|quiet+'	=> \$quiet,
@@ -43,7 +44,7 @@ GetOptions(
 
 my $exit = 0;
 
-if ($#ARGV < 0) {
+if ($#ARGV < 0 && !$piped) {
 	print "usage: $P [options] patchfile\n";
 	print "version: $V\n";
 	print "options: -q           => quiet\n";
@@ -181,6 +182,18 @@ if ($tree && -f "$root/$removal") {
 }
 
 my @rawlines = ();
+
+if ($piped) {
+	while (<STDIN>) {
+		chomp;
+		push(@rawlines, $_);
+	}
+	if (!process("", @rawlines)) {
+		$exit = 1;
+	}
+	@rawlines = ();
+}
+
 for my $filename (@ARGV) {
 	if ($file) {
 		open(FILE, "diff -u /dev/null $filename|") ||
-- 

-- 
