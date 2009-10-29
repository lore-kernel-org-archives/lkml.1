Return-Path: <linux-kernel-owner+w=401wt.eu-S1756924AbZJ2WeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924AbZJ2WeO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 18:34:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756868AbZJ2WeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 18:34:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:52789 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780AbZJ2WdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 18:33:15 -0400
Message-Id: <20091029223320.137410896@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 29 Oct 2009 18:32:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Li Hong <lihong.hi@gmail.com>
Subject: [PATCH 5/8] [PATCH 5/8] tracing: Move mcount section search to front of loop in recordmcount.pl
References: <20091029223254.504427063@goodmis.org>
Content-Disposition: inline; filename=0005-tracing-Move-mcount-section-search-to-front-of-loop-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Hong <lihong.hi@gmail.com>

Move the mcount section check to the beginning of the objdump read loop.
This makes the code easier to follow since the search for the mcount
section is performed first before the mcount callers are processed.

Signed-off-by: Li Hong <lihong.hi@gmail.com>
LKML-Reference: <20091028050523.GE30758@uhli>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/recordmcount.pl |   32 ++++++++++++++++++--------------
 1 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index d6199fc..02c8055 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -391,9 +391,27 @@ open(IN, "$objdump -hdr $inputfile|") || die "error running $objdump";
 
 my $text;
 
+
+# read headers first
 my $read_headers = 1;
 
 while (<IN>) {
+
+    if ($read_headers && /$mcount_section/) {
+	#
+	# Somehow the make process can execute this script on an
+	# object twice. If it does, we would duplicate the mcount
+	# section and it will cause the function tracer self test
+	# to fail. Check if the mcount section exists, and if it does,
+	# warn and exit.
+	#
+	print STDERR "ERROR: $mcount_section already in $inputfile\n" .
+	    "\tThis may be an indication that your build is corrupted.\n" .
+	    "\tDelete $inputfile and try again. If the same object file\n" .
+	    "\tstill causes an issue, then disable CONFIG_DYNAMIC_FTRACE.\n";
+	exit(-1);
+    }
+
     # is it a section?
     if (/$section_regex/) {
 	$read_headers = 0;
@@ -434,21 +452,7 @@ while (<IN>) {
 		$offset = hex $1;
 	    }
 	}
-    } elsif ($read_headers && /$mcount_section/) {
-	#
-	# Somehow the make process can execute this script on an
-	# object twice. If it does, we would duplicate the mcount
-	# section and it will cause the function tracer self test
-	# to fail. Check if the mcount section exists, and if it does,
-	# warn and exit.
-	#
-	print STDERR "ERROR: $mcount_section already in $inputfile\n" .
-	    "\tThis may be an indication that your build is corrupted.\n" .
-	    "\tDelete $inputfile and try again. If the same object file\n" .
-	    "\tstill causes an issue, then disable CONFIG_DYNAMIC_FTRACE.\n";
-	exit(-1);
     }
-
     # is this a call site to mcount? If so, record it to print later
     if ($text_found && /$mcount_regex/) {
 	$offsets[$#offsets + 1] = hex $1;
-- 
1.6.3.3


