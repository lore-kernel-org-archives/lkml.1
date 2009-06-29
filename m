Return-Path: <linux-kernel-owner+w=401wt.eu-S1757686AbZF2Ado@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686AbZF2Ado (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 20:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbZF2Adh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 20:33:37 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55603 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbZF2Adg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 20:33:36 -0400
Date: Sun, 28 Jun 2009 20:33:28 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, earl_chew@agilent.com,
       Oleg Nesterov <oleg@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/2] exec: Make do_coredump more robust and safer when
	using pipes in core_pattern (v3)
Message-ID: <20090629003328.GB2479@localhost.localdomain>
References: <20090622172818.GB14673@hmsreliant.think-freely.org> <20090625163050.d6a71a13.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090625163050.d6a71a13.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

core_pattern: Change how we detect recursive dumps with core_pattern pipes

Change how we detect recursive dumps.  Currently we have a mechanism by which
we try to compare pathnames of the crashing process to the core_pattern path.
This is broken for a dozen reasons, and just doesn't work in any sort of robust
way.  I'm replacing it with the use of a 0 RLIMIT_CORE value.  Since helper
apps set RLIMIT_CORE to zero, we don't write out core files for any process with
that particular limit set.  It the core_pattern is a pipe, any non-zero limit is
translated to RLIM_INFINITY.  This allows complete dumps to be captured, but
prevents infinite recursion in the event that the core_pattern process itself
crashes.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Reported-by: Earl Chew <earl_chew@agilent.com>

diff --git a/fs/exec.c b/fs/exec.c
index 9e05bd8..9defd20 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1776,35 +1776,34 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
  	lock_kernel();
 	ispipe = format_corename(corename, signr);
 	unlock_kernel();
-	/*
-	 * Don't bother to check the RLIMIT_CORE value if core_pattern points
-	 * to a pipe.  Since we're not writing directly to the filesystem
-	 * RLIMIT_CORE doesn't really apply, as no actual core file will be
-	 * created unless the pipe reader choses to write out the core file
-	 * at which point file size limits and permissions will be imposed
-	 * as it does with any other process
-	 */
+
  	if (ispipe) {
+		if (core_limit == 0) {
+			 /*
+			  * Normally core limits are irrelevant to pipes, since
+			  * we're not writing to the file system, but we use
+			  * core_limit of 0 here as a speacial value. Any
+			  * non-zero limit gets set to RLIM_INFINITY below, but
+			  * a limit of 0 skips the dump.  This is a consistent
+			  * way to catch recursive crashes.  We can still crash
+			  * if the core_pattern binary sets RLIM_CORE =  !0
+			  * but it runs as root, and can do lots of stupid things
+			  * Note that we use task_tgid_vnr here to grab the pid of the
+			  * process group leader.  That way we get the right pid if a thread
+			  * in a multi-threaded core_pattern process dies.
+			  */
+			printk(KERN_WARNING "Process %d(%s) has RLIMIT_CORE set to 0\n",
+			       task_tgid_vnr(current), current->comm);
+			printk(KERN_WARNING "Aborting core\n");
+			goto fail_unlock;
+		}
+
 		helper_argv = argv_split(GFP_KERNEL, corename+1, &helper_argc);
 		if (!helper_argv) {
 			printk(KERN_WARNING "%s failed to allocate memory\n",
 			       __func__);
 			goto fail_unlock;
 		}
-		/* Terminate the string before the first option */
-		delimit = strchr(corename, ' ');
-		if (delimit)
-			*delimit = '\0';
-		delimit = strrchr(helper_argv[0], '/');
-		if (delimit)
-			delimit++;
-		else
-			delimit = helper_argv[0];
-		if (!strcmp(delimit, current->comm)) {
-			printk(KERN_NOTICE "Recursive core dump detected, "
-					"aborting\n");
-			goto fail_unlock;
-		}
 
 		core_limit = RLIM_INFINITY;
 
