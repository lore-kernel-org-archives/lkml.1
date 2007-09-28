Return-Path: <linux-kernel-owner+w=401wt.eu-S1757494AbXI1Vcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494AbXI1Vcq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 17:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754903AbXI1VcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 17:32:15 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:55851 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754663AbXI1VcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 17:32:13 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 3/3] New script to check coding-style compliance on multiple regular files
Date: Fri, 28 Sep 2007 17:32:02 -0400
Message-Id: <1191015124866-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11910151223214-git-send-email-ezk@cs.sunysb.edu>
References: <11910151223214-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The script calls checkpatch.pl on each file, and formats any error messages
to comply with standard compiler error messages:

	file_name:line_number:error_message

This is particularly useful when run from within a text editor which can
parse these error messages and show the user a buffer with the file in
question, placing the cursor on the offending line (e.g., Emacs's "M-x
next-error" command, bound by default to C-x `).

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 scripts/check-coding-standards.pl |   59 +++++++++++++++++++++++++++++++++++++
 1 files changed, 59 insertions(+), 0 deletions(-)
 create mode 100755 scripts/check-coding-standards.pl

diff --git a/scripts/check-coding-standards.pl b/scripts/check-coding-standards.pl
new file mode 100755
index 0000000..a1ba597
--- /dev/null
+++ b/scripts/check-coding-standards.pl
@@ -0,0 +1,59 @@
+#!/usr/bin/perl -w
+# (c) 2007, Erez Zadok <ezk@cs.sunysb.edu>
+# Licensed under the terms of the GNU GPL License version 2
+#
+# Check one more more files for compliance with coding standards.
+# Outputs standard compiler-error format, one error per line, as follows
+#	filename:lineno:errormsg
+# This standard error message can be parsed by various tools, including
+# Emacs's M-x next-error
+#
+# Usage: check-coding-standards.pl file [files...]
+
+
+if (!defined($ARGV[0])) {
+    printf("Usage: $0 file [files...]\n");
+    exit(1);
+}
+
+$msg="";
+$lineno=0;
+foreach $file (@ARGV) {
+    die "$file: $!" unless (-f $file);
+    open(FILE, "diff -u /dev/null $file | perl scripts/checkpatch.pl --no-signoff - |") || die "$file: $!";
+    while (($line = <FILE>)) {
+	chop $line;
+	next if ($line =~ /^$/);
+	if ($line =~ /^ERROR: /) {
+	    $msg = $line;
+	    next;
+	}
+	if ($line =~ /^WARNING: /) {
+	    $msg = $line;
+	    next;
+	}
+	if ($line =~ /^CHECK: /) {
+	    $msg = $line;
+	    next;
+	}
+	if ($line =~ /^#/) {
+	    $lineno = (split(/:/, $line))[3];
+	    next;
+	}
+	if ($line =~ /^\+/) {
+	    if ($lineno > 0) {
+		printf(STDOUT "%s:%d:%s\n", $file, $lineno, $msg);
+		$msg="";
+		$lineno=0;
+	    }
+	    next;
+	}
+	next if ($line =~ /^\s+\^/);
+	next if ($line =~ /^Your patch has style problems, please review/);
+	next if ($line =~ /^are false positives report them to the/);
+	next if ($line =~ /^CHECKPATCH in MAINTAINERS/);
+	next if ($line =~ /^Your patch has no obvious style problems/);
+	die "unknown output from checkpatch: $line: $.";
+    }
+    close(FILE);
+}
-- 
1.5.2.2

