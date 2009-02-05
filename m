Return-Path: <linux-kernel-owner+w=401wt.eu-S1753746AbZBEUo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746AbZBEUo4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 15:44:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbZBEUoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 15:44:16 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:44647 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbZBEUoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 15:44:15 -0500
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH 3/3] binfmt_misc.c: Allow arguments in interpreter string
Date: Thu,  5 Feb 2009 22:47:44 +0200
Message-Id: <1233866864-14422-3-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.6.0.2.GIT
In-Reply-To: <1233866864-14422-2-git-send-email-kirill@shutemov.name>
References: <1233866864-14422-1-git-send-email-kirill@shutemov.name>
 <1233866864-14422-2-git-send-email-kirill@shutemov.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use parse_shell_args() to parse interpreter string. It allows to pass
arguments to interpreter.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
---
 fs/binfmt_misc.c |   46 +++++++++++++++++++++++++++++-----------------
 1 files changed, 29 insertions(+), 17 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index c4e8353..fadb29d 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -14,6 +14,7 @@
  *  1997-06-30 minor cleanup
  *  1997-08-09 removed extension stripping, locking cleanup
  *  2001-02-28 AV: rewritten into something that resembles C. Original didn't.
+ *  2009-02-03 Allow arguments in interpreter string
  */
 
 #include <linux/module.h>
@@ -50,7 +51,7 @@ typedef struct {
 	int size;			/* size of magic/mask */
 	char *magic;			/* magic or filename extension */
 	char *mask;			/* mask, NULL for exact match */
-	char *interpreter;		/* filename of interpreter */
+	char *command;			/* command to interprete the file */
 	char *name;
 	struct dentry *dentry;
 } Node;
@@ -107,8 +108,8 @@ static int load_misc_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 {
 	Node *fmt;
 	struct file * interp_file = NULL;
-	char iname[BINPRM_BUF_SIZE];
-	char *iname_addr = iname;
+	char out[BINPRM_BUF_SIZE];
+	int argc = 0;
 	int retval;
 	int fd_binary = -1;
 
@@ -120,13 +121,14 @@ static int load_misc_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	if (bprm->recursion_depth > BINPRM_MAX_RECURSION)
 		goto _ret;
 
-	/* to keep locking time low, we copy the interpreter string */
+	/* to keep locking time low, we copy the command string */
 	read_lock(&entries_lock);
 	fmt = check_file(bprm);
 	if (fmt)
-		strlcpy(iname, fmt->interpreter, BINPRM_BUF_SIZE);
+		argc = parse_shell_args(fmt->command, out, BINPRM_BUF_SIZE);
 	read_unlock(&entries_lock);
-	if (!fmt)
+
+	if (!argc)
 		goto _ret;
 
 	if (!(fmt->flags & MISC_FMT_PRESERVE_ARGV0)) {
@@ -170,15 +172,25 @@ static int load_misc_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 		goto _error;
 	bprm->argc++;
 
-	/* add the interp as argv[0] */
-	retval = copy_strings_kernel (1, &iname_addr, bprm);
-	if (retval < 0)
-		goto _error;
-	bprm->argc ++;
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
+	}
 
-	bprm->interp = iname;	/* for binfmt_script */
+	bprm->interp = out;	/* for binfmt_script */
 
-	interp_file = open_exec (iname);
+	interp_file = open_exec (out);
 	retval = PTR_ERR (interp_file);
 	if (IS_ERR (interp_file))
 		goto _error;
@@ -287,7 +299,7 @@ static char * check_special_flags (char * sfs, Node * e)
 }
 /*
  * This registers a new binary format, it recognises the syntax
- * ':name:type:offset:magic:mask:interpreter:flags'
+ * ':name:type:offset:magic:mask:command:flags'
  * where the ':' is the IFS, that can be chosen with the first char
  */
 static Node *create_entry(const char __user *buffer, size_t count)
@@ -379,12 +391,12 @@ static Node *create_entry(const char __user *buffer, size_t count)
 			goto Einval;
 		*p++ = '\0';
 	}
-	e->interpreter = p;
+	e->command = p;
 	p = strchr(p, del);
 	if (!p)
 		goto Einval;
 	*p++ = '\0';
-	if (!e->interpreter[0])
+	if (!e->command[0])
 		goto Einval;
 
 
@@ -448,7 +460,7 @@ static void entry_status(Node *e, char *page)
 		return;
 	}
 
-	sprintf(page, "%s\ninterpreter %s\n", status, e->interpreter);
+	sprintf(page, "%s\ninterpreter %s\n", status, e->command);
 	dp = page + strlen(page);
 
 	/* print the special flags */
-- 
1.6.0.2.GIT

