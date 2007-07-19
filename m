Return-Path: <linux-kernel-owner+w=401wt.eu-S965844AbXGSTTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965844AbXGSTTm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 15:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932771AbXGSTSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 15:18:47 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:4448 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764339AbXGSTSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 15:18:45 -0400
Date: Thu, 19 Jul 2007 15:17:43 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, wwoods@redhat.com,
       nhorman@tuxdriver.com
Subject: [PATCH]: update coredump path in kernel to not check coredump rlim if core_pattern is a pipe
Message-ID: <20070719191743.GB1934@hmsreliant.homelinux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hey-
	Patch to update do_coredump such that it ignores RLIMIT_CORE in the
event that core_pattern is a pipe.  RLIMIT_CORE is meant to prevent dumping
cores that are to large for the filesystem they are being written to for a given
user id.  If the core_pattern points to a pipe, the core isn't written to disk,
but rather sent to a spawned reader utility, negating the need for the check.
If the pipe reader later decides to write the core to disk, the reading process
is bound by the quotas and permissions that the target filesystem has set on it.

Thanks and Regards
Neil

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 exec.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)


diff --git a/fs/exec.c b/fs/exec.c
index f20561f..590fca9 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1528,9 +1528,6 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 	 */
 	clear_thread_flag(TIF_SIGPENDING);
 
-	if (current->signal->rlim[RLIMIT_CORE].rlim_cur < binfmt->min_coredump)
-		goto fail_unlock;
-
 	/*
 	 * lock_kernel() because format_corename() is controlled by sysctl, which
 	 * uses lock_kernel()
@@ -1538,6 +1535,19 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
  	lock_kernel();
 	ispipe = format_corename(corename, core_pattern, signr);
 	unlock_kernel();
+
+	/*
+	 * Don't bother to check the RLIMIT_CORE value if core_pattern points
+	 * to a pipe.  Since we're not writing directly to the filesystem
+	 * RLIMIT_CORE doesn't really apply, as no actual core file will be
+	 * created unless the pipe reader choses to write out the core file
+	 * at which point file size limits and permissions will be imposed 
+	 * as it does with any other process
+	 */
+	if ((!ispipe) &&
+	   (current->signal->rlim[RLIMIT_CORE].rlim_cur < binfmt->min_coredump))
+		goto fail_unlock;
+
  	if (ispipe) {
 		/* SIGPIPE can happen, but it's just never processed */
  		if(call_usermodehelper_pipe(corename+1, NULL, NULL, &file)) {
-- 
/***************************************************
 *Neil Horman
 *Software Engineer
 *Red Hat, Inc.
 *nhorman@tuxdriver.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
