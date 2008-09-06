Return-Path: <linux-kernel-owner+w=401wt.eu-S1754016AbYIFPJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbYIFPJx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 11:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbYIFPJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 11:09:32 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:22249 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbYIFPJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 11:09:31 -0400
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: linux-kernel@vger.kernel.org
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
       Pavel Emelyanov <xemul@openvz.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Allow recursion in binfmt_script and binfmt_misc
Date: Sat,  6 Sep 2008 18:09:55 +0300
Message-Id: <1220713795-5313-2-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.5.6.5.GIT
In-Reply-To: <1220713795-5313-1-git-send-email-kirill@shutemov.name>
References: <20080902110648.GA5027@localhost.localdomain>
 <1220713795-5313-1-git-send-email-kirill@shutemov.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

binfmt_script and binfmt_misc disallow recursion to avoid stack overflow
using sh_bang and misc_bang. It causes problem in some cases:

$ echo '#!/bin/ls' > /tmp/t0
$ echo '#!/tmp/t0' > /tmp/t1
$ echo '#!/tmp/t1' > /tmp/t2
$ chmod +x /tmp/t*
$ /tmp/t2
zsh: exec format error: /tmp/t2

Similar problem with binfmt_misc.

This patch introduces field 'recursion_depth' into struct linux_binprm
to track recursion level in binfmt_misc and binfmt_script. If recursion
level more then BINPRM_MAX_RECURSION it generates -ENOEXEC.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 fs/binfmt_em86.c        |    2 +-
 fs/binfmt_misc.c        |    4 ++--
 fs/binfmt_script.c      |    5 +++--
 include/linux/binfmts.h |    4 ++--
 4 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/binfmt_em86.c b/fs/binfmt_em86.c
index f9c88d0..32fb00b 100644
--- a/fs/binfmt_em86.c
+++ b/fs/binfmt_em86.c
@@ -43,7 +43,7 @@ static int load_em86(struct linux_binprm *bprm,struct pt_regs *regs)
 			return -ENOEXEC;
 	}
 
-	bprm->sh_bang = 1;	/* Well, the bang-shell is implicit... */
+	bprm->recursion_depth++; /* Well, the bang-shell is implicit... */
 	allow_write_access(bprm->file);
 	fput(bprm->file);
 	bprm->file = NULL;
diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 8d7e88e..f2744ab 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -117,7 +117,7 @@ static int load_misc_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 		goto _ret;
 
 	retval = -ENOEXEC;
-	if (bprm->misc_bang)
+	if (bprm->recursion_depth > BINPRM_MAX_RECURSION)
 		goto _ret;
 
 	/* to keep locking time low, we copy the interpreter string */
@@ -197,7 +197,7 @@ static int load_misc_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	if (retval < 0)
 		goto _error;
 
-	bprm->misc_bang = 1;
+	bprm->recursion_depth++;
 
 	retval = search_binary_handler (bprm, regs);
 	if (retval < 0)
diff --git a/fs/binfmt_script.c b/fs/binfmt_script.c
index 9e3963f..0834350 100644
--- a/fs/binfmt_script.c
+++ b/fs/binfmt_script.c
@@ -22,14 +22,15 @@ static int load_script(struct linux_binprm *bprm,struct pt_regs *regs)
 	char interp[BINPRM_BUF_SIZE];
 	int retval;
 
-	if ((bprm->buf[0] != '#') || (bprm->buf[1] != '!') || (bprm->sh_bang)) 
+	if ((bprm->buf[0] != '#') || (bprm->buf[1] != '!') ||
+	    (bprm->recursion_depth > BINPRM_MAX_RECURSION))
 		return -ENOEXEC;
 	/*
 	 * This section does the #! interpretation.
 	 * Sorta complicated, but hopefully it will work.  -TYT
 	 */
 
-	bprm->sh_bang = 1;
+	bprm->recursion_depth++;
 	allow_write_access(bprm->file);
 	fput(bprm->file);
 	bprm->file = NULL;
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 54980a3..1506b0d 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -34,8 +34,7 @@ struct linux_binprm{
 #endif
 	struct mm_struct *mm;
 	unsigned long p; /* current top of mem */
-	unsigned int sh_bang:1,
-		     misc_bang:1;
+	unsigned char recursion_depth;
 #ifdef __alpha__
 	unsigned int taso:1;
 #endif
@@ -61,6 +60,7 @@ struct linux_binprm{
 #define BINPRM_FLAGS_EXECFD_BIT 1
 #define BINPRM_FLAGS_EXECFD (1 << BINPRM_FLAGS_EXECFD_BIT)
 
+#define BINPRM_MAX_RECURSION 4
 
 /*
  * This structure defines the functions that are used to load the binary formats that
-- 
1.5.6.5.GIT

