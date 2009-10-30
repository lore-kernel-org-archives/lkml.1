Return-Path: <linux-kernel-owner+w=401wt.eu-S932627AbZJ3QVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932627AbZJ3QVT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 12:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932597AbZJ3QVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 12:21:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:40634 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932547AbZJ3QVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 12:21:17 -0400
Date: Fri, 30 Oct 2009 16:20:38 GMT
From: tip-bot for Li Hong <lihong.hi@gmail.com>
Cc: linux-kernel@vger.kernel.org, lihong.hi@gmail.com, hpa@zytor.com,
       mingo@redhat.com, rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, lihong.hi@gmail.com,
       linux-kernel@vger.kernel.org, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <20091028050743.GH30758@uhli>
References: <20091028050743.GH30758@uhli>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Exit with error if a weak function is used in recordmcount.pl
Message-ID: <tip-c4b8ac2c1aee1398b9378b8730bac56294b3410b@git.kernel.org>
Git-Commit-ID: c4b8ac2c1aee1398b9378b8730bac56294b3410b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c4b8ac2c1aee1398b9378b8730bac56294b3410b
Gitweb:     http://git.kernel.org/tip/c4b8ac2c1aee1398b9378b8730bac56294b3410b
Author:     Li Hong <lihong.hi@gmail.com>
AuthorDate: Wed, 28 Oct 2009 13:07:43 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 29 Oct 2009 15:11:57 -0400

tracing: Exit with error if a weak function is used in recordmcount.pl

If a weak function is used as a relocation reference for mcount callers
and that function is overridden, it will cause ftrace to fail at run time.

The current code should prevent a weak function from being used, but if
one is, the code should exit with an error to fail at compile time.

Signed-off-by: Li Hong <lihong.hi@gmail.com>
LKML-Reference: <20091028050743.GH30758@uhli>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/recordmcount.pl |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 884776a..a4e2435 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -350,15 +350,11 @@ sub update_funcs
 {
     return unless ($ref_func and @offsets);
 
-    # A section only had a weak function, to represent it.
-    # Unfortunately, a weak function may be overwritten by another
-    # function of the same name, making all these offsets incorrect.
-    # To be safe, we simply print a warning and bail.
+    # Sanity check on weak function. A weak function may be overwritten by
+    # another function of the same name, making all these offsets incorrect.
     if (defined $weak{$ref_func}) {
-	print STDERR
-	    "$inputfile: WARNING: referencing weak function" .
+	die "$inputfile: ERROR: referencing weak function" .
 	    " $ref_func for mcount\n";
-	return;
     }
 
     # is this function static? If so, note this fact.
