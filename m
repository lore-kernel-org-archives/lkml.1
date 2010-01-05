Return-Path: <linux-kernel-owner+w=401wt.eu-S1755273Ab0AES14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab0AES14 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 13:27:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755256Ab0AES1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 13:27:54 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43240 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257Ab0AES1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 13:27:52 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>, Wolfram Sang <w.sang@pengutronix.de>
Date: Tue,  5 Jan 2010 19:27:51 +0100
Message-Id: <1262716072-14414-2-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1262716072-14414-1-git-send-email-w.sang@pengutronix.de>
References: <1262716072-14414-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 92.198.50.58
X-SA-Exim-Mail-From: w.sang@pengutronix.de
Subject: [PATCH 1/2] tracing/recordmount.pl: optimize offsets-handling
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- move check for open file in front of the writing loop
- use perl-constructs to access the array

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---
 scripts/recordmcount.pl |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 92f09fe..5de12c7 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -432,14 +432,14 @@ sub update_funcs
 
     # Loop through all the mcount caller offsets and print a reference
     # to the caller based from the ref_func.
-    for (my $i=0; $i <= $#offsets; $i++) {
-	if (!$opened) {
-	    open(FILE, ">$mcount_s") || die "can't create $mcount_s\n";
-	    $opened = 1;
-	    print FILE "\t.section $mcount_section,\"a\",$section_type\n";
-	    print FILE "\t.align $alignment\n" if (defined($alignment));
-	}
-	printf FILE "\t%s %s + %d\n", $type, $ref_func, $offsets[$i] - $offset;
+    if (!$opened) {
+	open(FILE, ">$mcount_s") || die "can't create $mcount_s\n";
+	$opened = 1;
+	print FILE "\t.section $mcount_section,\"a\",$section_type\n";
+	print FILE "\t.align $alignment\n" if (defined($alignment));
+    }
+    foreach my $cur_offset (@offsets) {
+	printf FILE "\t%s %s + %d\n", $type, $ref_func, $cur_offset - $offset;
     }
 }
 
@@ -514,7 +514,7 @@ while (<IN>) {
     }
     # is this a call site to mcount? If so, record it to print later
     if ($text_found && /$mcount_regex/) {
-	$offsets[$#offsets + 1] = hex $1;
+	push(@offsets, hex $1);
     }
 }
 
-- 
1.6.3.3

