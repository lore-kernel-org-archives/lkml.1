Return-Path: <linux-kernel-owner+w=401wt.eu-S1753459AbZBEUoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbZBEUoh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 15:44:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752253AbZBEUoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 15:44:13 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:45492 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbZBEUoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 15:44:12 -0500
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH 2/3] binfmt_script: rewrite using parse_shell_args()
Date: Thu,  5 Feb 2009 22:47:43 +0200
Message-Id: <1233866864-14422-2-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.6.0.2.GIT
In-Reply-To: <1233866864-14422-1-git-send-email-kirill@shutemov.name>
References: <1233866864-14422-1-git-send-email-kirill@shutemov.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

parse_shell_args() allows to use more than one argument in shebang

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
---
 fs/binfmt_script.c |   88 +++++++++++++++++++---------------------------------
 1 files changed, 32 insertions(+), 56 deletions(-)

diff --git a/fs/binfmt_script.c b/fs/binfmt_script.c
index 0834350..ab6a6b2 100644
--- a/fs/binfmt_script.c
+++ b/fs/binfmt_script.c
@@ -1,93 +1,69 @@
 /*
  *  linux/fs/binfmt_script.c
  *
+ *  Copyright (C) 2009  Kirill A. Shutemov
  *  Copyright (C) 1996  Martin von Löwis
  *  original #!-checking implemented by tytso.
  */
 
 #include <linux/module.h>
-#include <linux/string.h>
-#include <linux/stat.h>
-#include <linux/slab.h>
 #include <linux/binfmts.h>
-#include <linux/init.h>
 #include <linux/file.h>
-#include <linux/err.h>
 #include <linux/fs.h>
 
 static int load_script(struct linux_binprm *bprm,struct pt_regs *regs)
 {
-	char *cp, *i_name, *i_arg;
 	struct file *file;
-	char interp[BINPRM_BUF_SIZE];
-	int retval;
+	char out[BINPRM_BUF_SIZE];
+	int argc, retval;
 
 	if ((bprm->buf[0] != '#') || (bprm->buf[1] != '!') ||
 	    (bprm->recursion_depth > BINPRM_MAX_RECURSION))
 		return -ENOEXEC;
-	/*
-	 * This section does the #! interpretation.
-	 * Sorta complicated, but hopefully it will work.  -TYT
-	 */
 
 	bprm->recursion_depth++;
 	allow_write_access(bprm->file);
 	fput(bprm->file);
 	bprm->file = NULL;
 
-	bprm->buf[BINPRM_BUF_SIZE - 1] = '\0';
-	if ((cp = strchr(bprm->buf, '\n')) == NULL)
-		cp = bprm->buf+BINPRM_BUF_SIZE-1;
-	*cp = '\0';
-	while (cp > bprm->buf) {
-		cp--;
-		if ((*cp == ' ') || (*cp == '\t'))
-			*cp = '\0';
-		else
-			break;
-	}
-	for (cp = bprm->buf+2; (*cp == ' ') || (*cp == '\t'); cp++);
-	if (*cp == '\0') 
-		return -ENOEXEC; /* No interpreter name found */
-	i_name = cp;
-	i_arg = NULL;
-	for ( ; *cp && (*cp != ' ') && (*cp != '\t'); cp++)
-		/* nothing */ ;
-	while ((*cp == ' ') || (*cp == '\t'))
-		*cp++ = '\0';
-	if (*cp)
-		i_arg = cp;
-	strcpy (interp, i_name);
-	/*
-	 * OK, we've parsed out the interpreter name and
-	 * (optional) argument.
-	 * Splice in (1) the interpreter's name for argv[0]
-	 *           (2) (optional) argument to interpreter
-	 *           (3) filename of shell script (replace argv[0])
-	 *
-	 * This is done in reverse order, because of how the
-	 * user environment and arguments are stored.
-	 */
 	retval = remove_arg_zero(bprm);
 	if (retval)
 		return retval;
+
 	retval = copy_strings_kernel(1, &bprm->interp, bprm);
-	if (retval < 0) return retval; 
+	if (retval < 0)
+		return retval;
 	bprm->argc++;
-	if (i_arg) {
-		retval = copy_strings_kernel(1, &i_arg, bprm);
-		if (retval < 0) return retval; 
-		bprm->argc++;
+
+	bprm->buf[BINPRM_BUF_SIZE - 1] = '\0';
+
+	argc = parse_shell_args(bprm->buf+2, out, BINPRM_BUF_SIZE);
+
+	if (!argc)
+		return -ENOEXEC;
+
+	{
+		char *argv[argc];
+		char *out_p = out;
+		int i;
+
+		for(i=0; i < argc; i++) {
+			argv[i] = out_p;
+			out_p += strlen(out_p) + 1;
+		}
+
+		retval = copy_strings_kernel(argc, argv, bprm);
+		if (retval)
+			return retval;
+		bprm->argc += argc;
 	}
-	retval = copy_strings_kernel(1, &i_name, bprm);
-	if (retval) return retval; 
-	bprm->argc++;
-	bprm->interp = interp;
+
+	bprm->interp = out;
 
 	/*
 	 * OK, now restart the process with the interpreter's dentry.
 	 */
-	file = open_exec(interp);
+	file = open_exec(out);
 	if (IS_ERR(file))
 		return PTR_ERR(file);
 
@@ -95,7 +71,7 @@ static int load_script(struct linux_binprm *bprm,struct pt_regs *regs)
 	retval = prepare_binprm(bprm);
 	if (retval < 0)
 		return retval;
-	return search_binary_handler(bprm,regs);
+	return search_binary_handler(bprm, regs);
 }
 
 static struct linux_binfmt script_format = {
-- 
1.6.0.2.GIT

