Return-Path: <linux-kernel-owner+w=401wt.eu-S1756902AbZJ2WdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902AbZJ2WdV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 18:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756845AbZJ2WdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 18:33:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:52802 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756827AbZJ2WdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 18:33:16 -0400
Message-Id: <20091029223321.033537042@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 29 Oct 2009 18:33:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Li Hong <lihong.hi@gmail.com>
Subject: [PATCH 8/8] [PATCH 8/8] tracing: Exit with error if a weak function is used in recordmcount.pl
References: <20091029223254.504427063@goodmis.org>
Content-Disposition: inline; filename=0008-tracing-Exit-with-error-if-a-weak-function-is-used-i.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Hong <lihong.hi@gmail.com>

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
-- 
1.6.3.3


