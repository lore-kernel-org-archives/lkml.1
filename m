Return-Path: <linux-kernel-owner+w=401wt.eu-S1759376AbZAMGM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759376AbZAMGM4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 01:12:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757176AbZAMGLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 01:11:52 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53890 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796AbZAMGLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 01:11:48 -0500
Message-Id: <20090113061147.356999436@goodmis.org>
References: <20090113061110.856268617@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 13 Jan 2009 01:11:12 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Shaohua Li <shaohua.li@intel.com>, ia64 <linux-ia64@vger.kernel.org>,
       Tony Luck <tony.luck@intel.com>, Sam Ravnborg <sam@ravnborg.org>,
       u.kleine-koenig@pengutronix.de, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/9] ftrace, ia64: explictly ignore a file in recordmcount.pl
Content-Disposition: inline; filename=0002-ftrace-ia64-explictly-ignore-a-file-in-recordmcoun.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shaohua Li <shaohua.li@intel.com>

In IA64, a function pointer isn't a 'unsigned long' but a
'struct {unsigned long ip, unsigned long gp}'. MCOUNT_ADDR is determined
at link time not compile time, so explictly ignore kernel/trace/ftrace.o
in recordmcount.pl.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ftrace.c   |   10 +---------
 scripts/recordmcount.pl |    5 +++++
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 9e54a6c..76bb884 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -263,14 +263,6 @@ static void ftrace_update_pid_func(void)
 # error Dynamic ftrace depends on MCOUNT_RECORD
 #endif
 
-/*
- * Since MCOUNT_ADDR may point to mcount itself, we do not want
- * to get it confused by reading a reference in the code as we
- * are parsing on objcopy output of text. Use a variable for
- * it instead.
- */
-static unsigned long mcount_addr = MCOUNT_ADDR;
-
 enum {
 	FTRACE_ENABLE_CALLS		= (1 << 0),
 	FTRACE_DISABLE_CALLS		= (1 << 1),
@@ -575,7 +567,7 @@ ftrace_code_disable(struct module *mod, struct dyn_ftrace *rec)
 
 	ip = rec->ip;
 
-	ret = ftrace_make_nop(mod, rec, mcount_addr);
+	ret = ftrace_make_nop(mod, rec, MCOUNT_ADDR);
 	if (ret) {
 		ftrace_bug(ret, ip);
 		rec->flags |= FTRACE_FL_FAILED;
diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 282485a..070042b 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -109,6 +109,11 @@ if ($#ARGV < 7) {
 my ($arch, $bits, $objdump, $objcopy, $cc,
     $ld, $nm, $rm, $mv, $is_module, $inputfile) = @ARGV;
 
+# This file refers to mcount and shouldn't be ftraced, so lets' ignore it
+if ($inputfile eq "kernel/trace/ftrace.o") {
+    exit(0);
+}
+
 # Acceptable sections to record.
 my %text_sections = (
      ".text" => 1,
-- 
1.5.6.5

-- 
