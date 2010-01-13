Return-Path: <linux-kernel-owner+w=401wt.eu-S1755415Ab0AMKYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab0AMKYL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:24:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755333Ab0AMKYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:24:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:37924 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755301Ab0AMKYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:24:06 -0500
Date: Wed, 13 Jan 2010 10:23:39 GMT
From: tip-bot for Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, w.sang@pengutronix.de, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, w.sang@pengutronix.de, tglx@linutronix.de
In-Reply-To: <1262716072-14414-2-git-send-email-w.sang@pengutronix.de>
References: <1262716072-14414-2-git-send-email-w.sang@pengutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: optimize recordmcount.pl for offsets-handling
Message-ID: <tip-dc4f8845ee2ca39fe054a2d911729ffd269b4b66@git.kernel.org>
Git-Commit-ID: dc4f8845ee2ca39fe054a2d911729ffd269b4b66
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jan 2010 10:23:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dc4f8845ee2ca39fe054a2d911729ffd269b4b66
Gitweb:     http://git.kernel.org/tip/dc4f8845ee2ca39fe054a2d911729ffd269b4b66
Author:     Wolfram Sang <w.sang@pengutronix.de>
AuthorDate: Tue, 5 Jan 2010 19:27:51 +0100
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 6 Jan 2010 13:32:39 -0500

tracing: optimize recordmcount.pl for offsets-handling

- move check for open file in front of the writing loop
- use perl-constructs to access the array

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
LKML-Reference: <1262716072-14414-2-git-send-email-w.sang@pengutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
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
 
