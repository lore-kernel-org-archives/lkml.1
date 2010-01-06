Return-Path: <linux-kernel-owner+w=401wt.eu-S932586Ab0AFXSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586Ab0AFXSN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 18:18:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933049Ab0AFXR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 18:17:58 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56858 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932521Ab0AFXPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 18:15:34 -0500
X-Authority-Analysis: v=1.0 c=1 a=GAnzq1PaWlIA:10 a=meVymXHHAAAA:8 a=TJfVt-zLeefMa5q-PlMA:9 a=psFa9bVKmAqwu7Hsm0IA:7 a=AktdL0hiOyoRo_AXBmSReCHPs1sA:4 a=XNN-oNMjSfgA:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100106231533.554505577@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 Jan 2010 18:13:58 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH 09/11] tracing: optimize recordmcount.pl for offsets-handling
References: <20100106231349.107649729@goodmis.org>
Content-Disposition: inline; filename=0009-tracing-optimize-recordmcount.pl-for-offsets-handlin.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfram Sang <w.sang@pengutronix.de>

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
 
-- 
1.6.5


