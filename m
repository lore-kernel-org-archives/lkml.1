Return-Path: <linux-kernel-owner+w=401wt.eu-S932634AbZJ3QUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634AbZJ3QUK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 12:20:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932507AbZJ3QUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 12:20:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:58233 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932597AbZJ3QUC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 12:20:02 -0400
Date: Fri, 30 Oct 2009 16:19:50 GMT
From: tip-bot for Li Hong <lihong.hi@gmail.com>
Cc: linux-kernel@vger.kernel.org, lihong.hi@gmail.com, hpa@zytor.com,
       mingo@redhat.com, rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, lihong.hi@gmail.com,
       linux-kernel@vger.kernel.org, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <20091028050523.GE30758@uhli>
References: <20091028050523.GE30758@uhli>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Move mcount section search to front of loop in recordmcount.pl
Message-ID: <tip-db24c7dcf42f78629d89b34e5d5a98ed56ea2ff5@git.kernel.org>
Git-Commit-ID: db24c7dcf42f78629d89b34e5d5a98ed56ea2ff5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  db24c7dcf42f78629d89b34e5d5a98ed56ea2ff5
Gitweb:     http://git.kernel.org/tip/db24c7dcf42f78629d89b34e5d5a98ed56ea2ff5
Author:     Li Hong <lihong.hi@gmail.com>
AuthorDate: Wed, 28 Oct 2009 13:05:23 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 29 Oct 2009 15:11:48 -0400

tracing: Move mcount section search to front of loop in recordmcount.pl

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
