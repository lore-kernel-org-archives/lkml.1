Return-Path: <linux-kernel-owner+w=401wt.eu-S1757338AbZJ1FF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338AbZJ1FF3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 01:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755557AbZJ1FF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 01:05:28 -0400
Received: from mail-pw0-f42.google.com ([209.85.160.42]:45071 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392AbZJ1FF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 01:05:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :x-operating-system:user-agent;
        b=boBieEMpYuoLK9dRu6GpbMf24Ct+BIoomn9p6W5VoWbcKKS71mEA/Xms7Dn0AvmSIt
         /XnbcU8fFeLOBQII3VuapDkz5Poi4R86+8FouHeu9VbExBujQKRA0MA4qnB/4T06hPv+
         7Oc749Uwb9k05XOvWn3297NP/BnWg33pc1yl8=
Date: Wed, 28 Oct 2009 13:05:23 +0800
From: Li Hong <lihong.hi@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 5/8] tracing: recordmcount.pl Clarify the logic on
	mcount section check
Message-ID: <20091028050523.GE30758@uhli>
Mail-Followup-To: Steven Rostedt <rostedt@goodmis.org>,
	linux-kernel@vger.kernel.org
References: <20091028045532.GA30036@uhli>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091028045532.GA30036@uhli>
X-Operating-System: Linux uhli 2.6.28-11-generic 
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7cff5ca3e0cdad6fcb4933ef290e5e2bf90e26fb Mon Sep 17 00:00:00 2001
From: Li Hong <lihong.hi@gmail.com>
Date: Tue, 27 Oct 2009 12:53:52 +0800
Subject: [PATCH] tracing: recordmcount.pl Clarify the logic on mcount section check

Move the mcount section check to the beginning of the objdump read loop.
It is clearer, because mcount section check uses headers dump part of objdump
to identify a mcount section, which goes before the section parts.

Signed-off-by: Li Hong <lihong.hi@gmail.com>
---
 scripts/recordmcount.pl |   34 +++++++++++++++++++---------------
 1 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 1de9826..f4117d6 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -389,9 +389,27 @@ open(IN, "$objdump -hdr $inputfile|") || die "error running $objdump";
 
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
@@ -432,21 +450,7 @@ while (<IN>) {
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
-    }
-
+    } 
     # is this a call site to mcount? If so, record it to print later
     if ($text_found && /$mcount_regex/) {
 	$offsets[$#offsets + 1] = hex $1;
-- 
1.6.0.4

