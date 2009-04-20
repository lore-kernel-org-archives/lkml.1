Return-Path: <linux-kernel-owner+w=401wt.eu-S1756379AbZDTPoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379AbZDTPoe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 11:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755851AbZDTPoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 11:44:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57486 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755686AbZDTPoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 11:44:04 -0400
Message-Id: <20090420154400.378511480@goodmis.org>
References: <20090420154325.698204138@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 20 Apr 2009 11:43:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/3] tracing: change branch profiling to a choice selection
Content-Disposition: inline; filename=0001-tracing-change-branch-profiling-to-a-choice-selecti.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This patch makes the branch profiling into a choice selection:

  None               - no branch profiling
  likely/unlikely    - only profile likely/unlikely branches
  all                - profile all branches

The all profiler will also enable the likely/unlikely branches.

This does not change the way the profiler works or the dependencies
between the profilers.

What this patch does, is keep the branch profiling from being selected
by an allyesconfig make. The branch profiler is very intrusive and
it is known to break various architecture builds when selected as an
allyesconfig.

[ Impact: prevent branch profiler from being selected in allyesconfig ]

Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/Kconfig |   39 +++++++++++++++++++++++++++++++++------
 1 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 57981d3..3ee28db 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -212,8 +212,36 @@ config BOOT_TRACER
 	  to enable this on bootup.
 
 config TRACE_BRANCH_PROFILING
-	bool "Trace likely/unlikely profiler"
+	bool
 	select TRACING
+
+choice
+	prompt "Branch Profiling"
+	default BRANCH_PROFILE_NONE
+	help
+	 The branch profiling is a software profiler. It will add hooks
+	 into the C conditionals to test which path a branch takes.
+
+	 The likely/unlikely profiler only looks at the conditions that
+	 are annotated with a likely or unlikely macro.
+
+	 The "all branch" profiler will profile every if statement in the
+	 kernel. This profiler will also enable the likely/unlikely
+	 profiler as well.
+
+	 Either of the above profilers add a bit of overhead to the system.
+	 If unsure choose "No branch profiling".
+
+config BRANCH_PROFILE_NONE
+	bool "No branch profiling"
+	help
+	 No branch profiling. Branch profiling adds a bit of overhead.
+	 Only enable it if you want to analyse the branching behavior.
+	 Otherwise keep it disabled.
+
+config PROFILE_ANNOTATED_BRANCHES
+	bool "Trace likely/unlikely profiler"
+	select TRACE_BRANCH_PROFILING
 	help
 	  This tracer profiles all the the likely and unlikely macros
 	  in the kernel. It will display the results in:
@@ -223,11 +251,9 @@ config TRACE_BRANCH_PROFILING
 	  Note: this will add a significant overhead, only turn this
 	  on if you need to profile the system's use of these macros.
 
-	  Say N if unsure.
-
 config PROFILE_ALL_BRANCHES
 	bool "Profile all if conditionals"
-	depends on TRACE_BRANCH_PROFILING
+	select TRACE_BRANCH_PROFILING
 	help
 	  This tracer profiles all branch conditions. Every if ()
 	  taken in the kernel is recorded whether it hit or miss.
@@ -235,11 +261,12 @@ config PROFILE_ALL_BRANCHES
 
 	  /debugfs/tracing/profile_branch
 
+	  This option also enables the likely/unlikely profiler.
+
 	  This configuration, when enabled, will impose a great overhead
 	  on the system. This should only be enabled when the system
 	  is to be analyzed
-
-	  Say N if unsure.
+endchoice
 
 config TRACING_BRANCHES
 	bool
-- 
1.6.2.1

-- 
