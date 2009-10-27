Return-Path: <linux-kernel-owner+w=401wt.eu-S1756485AbZJ0HBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485AbZJ0HBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 03:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756447AbZJ0HBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 03:01:20 -0400
Received: from mail-pw0-f42.google.com ([209.85.160.42]:55206 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756428AbZJ0HBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 03:01:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :x-operating-system:user-agent;
        b=riXA2MOi3Q8rNAzHQ5EmkkBlMMHlpDDU3yL1EzxWe++lJorUpKJ2GS41OzOiZ8Gliu
         vf190OK0sQO+yQmjoJk1YN5iRdeqiohYztPEFEwJUFva5Jt8GyhosmETzvy2AgNqgeB1
         XNiGWhFr7QmZfnSQxUO9j3M4CSOYLr5jE1PwM=
Date: Tue, 27 Oct 2009 15:01:13 +0800
From: Li Hong <lihong.hi@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/9] tracing: recordmcount.pl Clarify the logic on mcount
	section check
Message-ID: <20091027070113.GE22032@uhli>
Mail-Followup-To: Steven Rostedt <rostedt@goodmis.org>,
	linux-kernel@vger.kernel.org
References: <20091027065421.GA22032@uhli>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091027065421.GA22032@uhli>
X-Operating-System: Linux uhli 2.6.28-11-generic 
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From eb8a2d53bc2484be223e4fa0df8804389e969b72 Mon Sep 17 00:00:00 2001
From: Li Hong <lihong.hi@gmail.com>
Date: Tue, 27 Oct 2009 12:53:52 +0800
Subject: [PATCH] tracing: recordmcount.pl Clarify the logic on mcount section check

Move the mcount section check to the beginning of the objdump read loop.
It is clearer, because mcount section check uses headers dump part of objdump
to identify a mcount section, which goes before the section parts.

Signed-off-by: Li Hong <lihong.hi@gmail.com>

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 970c6d6..a6585b6 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -384,9 +384,26 @@ open(IN, "$objdump -hdr $inputfile|") || die "error running $objdump";
 
 my $text;
 
-my $read_headers = 1;
 
 while (<IN>) {
+    # read headers first
+    my $read_headers = 1;
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
@@ -427,21 +444,7 @@ while (<IN>) {
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

