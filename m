Return-Path: <linux-kernel-owner+w=401wt.eu-S934003AbXGZRnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934003AbXGZRnY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 13:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761862AbXGZRnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 13:43:17 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:2844 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761772AbXGZRnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 13:43:16 -0400
Date: Thu, 26 Jul 2007 13:40:19 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, wwoods@redhat.com
Subject: [PATCH] core_pattern: Add ability for core_pattern to parse arguments when pattern is a pipe
Message-ID: <20070726173923.GA5701@hmsreliant.homelinux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hey-
	Currently, core dumps can be redirected to a pipe by placing the
following string template in /proc/sys/kernel/core_pattern:
|<path/to/application>
This patch extends this ability, allowing the core_pattern to contain arguments
to be passed as an argv array to the userspace helper application.  It also add
a format specifier, %c, which allows the RLIM_CORE value of the crashing
application to be passed on the command line, since RLIMIT_CORE is reduced to
zero when execing the userspace helper

Tested successfully by me on x86 & x86_64.

Regards
Neil

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 exec.c |  122 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 119 insertions(+), 3 deletions(-)



diff --git a/fs/exec.c b/fs/exec.c
index c0b5def..e862019 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -51,6 +51,7 @@
 #include <linux/cn_proc.h>
 #include <linux/audit.h>
 #include <linux/signalfd.h>
+#include <linux/string.h>
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
@@ -1448,6 +1449,109 @@ int set_binfmt(struct linux_binfmt *new)
 
 EXPORT_SYMBOL(set_binfmt);
 
+static void free_argv_array(char **argv)
+{
+	int i;
+	if (argv != NULL) {
+		for (i = 0; argv[i] != NULL; i++)
+			kfree(argv[i]);
+		kfree(argv);
+	}
+
+}
+
+/*
+ * format_corename_argv will inspect the corename string, 	
+ * and for every option found after the binary name
+ * it will remove the option from the string, and place it
+ * in the argv array, that can then be passed to the 
+ * usermodehelper if core_pattern is a pipe
+ * Assumes that corename is declared on the stack of the caller
+ */
+static char **format_corename_argv(char *corename)
+{
+	char *nptr = corename;
+	char *fptr = NULL;
+	char **orig_argv;
+	char **argv_ptr;
+	int i = 2;
+
+	/*
+	 * Start by populating element 0 with the name of the binary
+	 */	
+	argv_ptr = kmalloc(sizeof(char **)*i, GFP_KERNEL);
+	if (!argv_ptr)
+		goto out;
+	orig_argv = argv_ptr;
+
+	argv_ptr[0] = NULL;
+	argv_ptr[1] = NULL;
+	fptr = strchr(nptr, ' ');
+
+	/* This trucates the string command line for use in exec */
+	if (fptr != NULL) 
+		*fptr = '\0';
+
+	nptr = nptr + 1; /*this removes the leading | */
+	argv_ptr[0] = kmalloc(strlen(nptr), GFP_KERNEL);
+	if (argv_ptr[0] == NULL)
+		goto out_free;
+
+	strcpy(argv_ptr[0], nptr);
+
+	/*
+	 * This handles the case where we have no options
+	 */
+	if (fptr == NULL)
+		goto out;
+	/*
+	 * Now walk through the rest of the corename with nptr and
+	 * fptr, delimiting by spaces and filling out the array
+	 */
+	nptr = fptr + 1;
+	for(;;) {
+		fptr = strchr(nptr, ' ');
+
+		/*
+		 * Found a new option, lets add to the array
+		 */
+		argv_ptr = krealloc(argv_ptr, (sizeof(char **)*(i+1)), GFP_KERNEL);
+		if (!argv_ptr)
+			goto out_free;
+
+		argv_ptr[i] = NULL; /* set the end of the array to NULL */
+		if (fptr != NULL)
+			*fptr = '\0';
+
+		argv_ptr[i-1] = kmalloc(strlen(nptr), GFP_KERNEL);
+		if (argv_ptr[i-1] == NULL)
+			goto out_free;
+
+		/*
+		 * copy the option and advance our pointers
+		 */
+		strcpy(argv_ptr[i-1],nptr);
+		if (fptr == NULL)
+			break;
+		i++;
+		nptr = fptr + 1;
+	}
+
+
+	/*
+	 * now we have our array built
+	 */
+	return argv_ptr;
+
+out_free:
+	for (i = 0;orig_argv[i] != NULL; i++)
+		kfree(orig_argv[i]);
+	kfree(orig_argv);
+	argv_ptr = NULL;
+out:
+	return argv_ptr;
+}
+
 /* format_corename will inspect the pattern parameter, and output a
  * name into corename, which must have space for at least
  * CORENAME_MAX_SIZE bytes plus one byte for the zero terminator.
@@ -1543,6 +1647,14 @@ static int format_corename(char *corename, const char *pattern, long signr)
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
@@ -1727,6 +1839,7 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 	int flag = 0;
 	int ispipe = 0;
 	unsigned long core_limit = current->signal->rlim[RLIMIT_CORE].rlim_cur;
+	char **helper_argv = NULL;
 
 	audit_core_dumps(signr);
 
@@ -1775,14 +1888,14 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 	 * at which point file size limits and permissions will be imposed 
 	 * as it does with any other process
 	 */
-	if ((!ispipe) &&
-	   (core_limit < binfmt->min_coredump))
+	if ((!ispipe) && (core_limit < binfmt->min_coredump))
 		goto fail_unlock;
 
  	if (ispipe) {
 		core_limit = RLIM_INFINITY;
+		helper_argv = format_corename_argv(corename);
 		/* SIGPIPE can happen, but it's just never processed */
- 		if(call_usermodehelper_pipe(corename+1, NULL, NULL, &file)) {
+ 		if(call_usermodehelper_pipe(corename+1, helper_argv, NULL, &file)) {
  			printk(KERN_INFO "Core dump to %s pipe failed\n",
 			       corename);
  			goto fail_unlock;
@@ -1817,6 +1930,9 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 close_fail:
 	filp_close(file, NULL);
 fail_unlock:
+	if (ispipe)
+		free_argv_array(helper_argv);
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
