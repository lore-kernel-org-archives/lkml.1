Return-Path: <linux-kernel-owner+w=401wt.eu-S937342AbXG0UJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937342AbXG0UJy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 16:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933217AbXG0UJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 16:09:46 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:4983 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932279AbXG0UJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 16:09:45 -0400
Date: Fri, 27 Jul 2007 16:08:31 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, jeremy@goop.org,
       martin.pitt@ubuntu.com, wwoods@redhat.com
Cc: nhorman@tuxdriver.com
Subject: [PATCH 2/3] core_pattern: allow passing of arguments to user mode helper when core_pattern is a pipe
Message-ID: <20070727200746.GC18946@hmsreliant.homelinux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hey
	Patch 2/3 of my core_pattern enhancements.  This patch is a rewrite of
my previous post for this enhancement.  It uses jeremy's split_argv/free_argv
library functions to translate core_pattern into an argv array to be passed to
the user mode helper process.  It also adds a translation to format_corename
such that the origional value of RLIMIT_CORE can be passed to userspace as an
argument.

Thanks & Regards
Neil

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 exec.c |   25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)


diff --git a/fs/exec.c b/fs/exec.c
index c0b5def..6855a52 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -51,6 +51,7 @@
 #include <linux/cn_proc.h>
 #include <linux/audit.h>
 #include <linux/signalfd.h>
+#include <linux/string.h>
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
@@ -1543,6 +1544,14 @@ static int format_corename(char *corename, const char *pattern, long signr)
 					goto out;
 				out_ptr += rc;
 				break;
+			/* core limit size */
+			case 'c':
+				rc = snprintf(out_ptr, out_end - out_ptr,
+					      "%lu", current->signal->rlim[RLIMIT_CORE].rlim_cur); 
+				if (rc > out_end - out_ptr)
+					goto out;
+				out_ptr += rc;
+				break;
 			default:
 				break;
 			}
@@ -1727,6 +1736,9 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 	int flag = 0;
 	int ispipe = 0;
 	unsigned long core_limit = current->signal->rlim[RLIMIT_CORE].rlim_cur;
+	char **helper_argv = NULL;
+	int helper_argc = 0;
+	char *delimit;
 
 	audit_core_dumps(signr);
 
@@ -1775,14 +1787,18 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 	 * at which point file size limits and permissions will be imposed 
 	 * as it does with any other process
 	 */
-	if ((!ispipe) &&
-	   (core_limit < binfmt->min_coredump))
+	if ((!ispipe) && (core_limit < binfmt->min_coredump))
 		goto fail_unlock;
 
  	if (ispipe) {
 		core_limit = RLIM_INFINITY;
+		helper_argv = argv_split(GFP_KERNEL, corename+1, &helper_argc);
+		/* Terminate the string before the first option */
+		delimit = strchr(corename, ' ');
+		if (delimit)
+			*delimit = '\0';
 		/* SIGPIPE can happen, but it's just never processed */
- 		if(call_usermodehelper_pipe(corename+1, NULL, NULL, &file)) {
+ 		if(call_usermodehelper_pipe(corename+1, helper_argv, NULL, &file)) {
  			printk(KERN_INFO "Core dump to %s pipe failed\n",
 			       corename);
  			goto fail_unlock;
@@ -1817,6 +1833,9 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 close_fail:
 	filp_close(file, NULL);
 fail_unlock:
+	if (helper_argv)
+		argv_free(helper_argv);
+
 	current->fsuid = fsuid;
 	complete_all(&mm->core_done);
 fail:
-- 
/***************************************************
 *Neil Horman
 *Software Engineer
 *Red Hat, Inc.
 *nhorman@tuxdriver.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
