Return-Path: <linux-kernel-owner+w=401wt.eu-S1755974AbZKQRNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974AbZKQRNx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 12:13:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755560AbZKQRNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 12:13:52 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:58439 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755846AbZKQRNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 12:13:50 -0500
Message-Id: <20091117171355.860182440@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 17 Nov 2009 12:12:45 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 3/3] [PATCH 3/3] tracing: Only print objcopy version warning once from recordmcount
References: <20091117171242.761539651@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Only-print-objcopy-version-warning-once-from.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

If the user has an older version of objcopy, that can not handle
converting local symbols to global and vice versa, then some
functions will not be part of the dynamic function tracer. The current
code in recordmcount.pl will print a warning in this case. Unfortunately,
there exists lots of files that may have this issue with older objcopys
and this will cause a warning for every file compiled with this
issue.

This patch solves this overwhelming output by creating a
.tmp_quiet_recordmcount file on the first instance the warning is
encountered. The warning will not print if this file exists.

The temp file is deleted at the beginning of the compile to ensure that
the warning will happen once again on new compiles (because the issue
is still present).

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Makefile                |    1 +
 scripts/recordmcount.pl |   12 ++++++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 9425d1d..1c949ac 100644
--- a/Makefile
+++ b/Makefile
@@ -379,6 +379,7 @@ export RCS_TAR_IGNORE := --exclude SCCS --exclude BitKeeper --exclude .svn --exc
 PHONY += scripts_basic
 scripts_basic:
 	$(Q)$(MAKE) $(build)=scripts/basic
+	$(Q)rm -f .tmp_quiet_recordmcount
 
 # To avoid any implicit rule to kick in, define an empty command.
 scripts/basic/%: scripts_basic ;
diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index a4e2435..f0d1445 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -162,6 +162,11 @@ my $alignment;		# The .align value to use for $mcount_section
 my $section_type;	# Section header plus possible alignment command
 my $can_use_local = 0; 	# If we can use local function references
 
+# Shut up recordmcount if user has older objcopy
+my $quiet_recordmcount = ".tmp_quiet_recordmcount";
+my $print_warning = 1;
+$print_warning = 0 if ( -f $quiet_recordmcount);
+
 ##
 # check_objcopy - whether objcopy supports --globalize-symbols
 #
@@ -179,10 +184,13 @@ sub check_objcopy
     }
     close (IN);
 
-    if (!$can_use_local) {
+    if (!$can_use_local && $print_warning) {
 	print STDERR "WARNING: could not find objcopy version or version " .
 	    "is less than 2.17.\n" .
-	    "\tLocal function references is disabled.\n";
+	    "\tLocal function references are disabled.\n";
+	open (QUIET, ">$quiet_recordmcount");
+	printf QUIET "Disables the warning from recordmcount.pl\n";
+	close QUIET;
     }
 }
 
-- 
1.6.5


