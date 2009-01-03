Return-Path: <linux-kernel-owner+w=401wt.eu-S1757137AbZACHQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137AbZACHQ6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 02:16:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932077AbZACHQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 02:16:36 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41527 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759843AbZACHQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 02:16:35 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] get rid of special-casing the /sbin/loader on alpha
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1LJ0kL-0006Pn-2l@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 03 Jan 2009 07:16:33 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


... just make it a binfmt handler like #! one.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/alpha/kernel/Makefile        |    2 +-
 arch/alpha/kernel/binfmt_loader.c |   51 +++++++++++++++++++++++++++++++++++++
 fs/exec.c                         |   41 +-----------------------------
 3 files changed, 53 insertions(+), 41 deletions(-)
 create mode 100644 arch/alpha/kernel/binfmt_loader.c

diff --git a/arch/alpha/kernel/Makefile b/arch/alpha/kernel/Makefile
index ac706c1..b469775 100644
--- a/arch/alpha/kernel/Makefile
+++ b/arch/alpha/kernel/Makefile
@@ -8,7 +8,7 @@ EXTRA_CFLAGS	:= -Werror -Wno-sign-compare
 
 obj-y    := entry.o traps.o process.o init_task.o osf_sys.o irq.o \
 	    irq_alpha.o signal.o setup.o ptrace.o time.o \
-	    alpha_ksyms.o systbls.o err_common.o io.o
+	    alpha_ksyms.o systbls.o err_common.o io.o binfmt_loader.o
 
 obj-$(CONFIG_VGA_HOSE)	+= console.o
 obj-$(CONFIG_SMP)	+= smp.o
diff --git a/arch/alpha/kernel/binfmt_loader.c b/arch/alpha/kernel/binfmt_loader.c
new file mode 100644
index 0000000..4a0af90
--- /dev/null
+++ b/arch/alpha/kernel/binfmt_loader.c
@@ -0,0 +1,51 @@
+#include <linux/init.h>
+#include <linux/fs.h>
+#include <linux/file.h>
+#include <linux/mm_types.h>
+#include <linux/binfmts.h>
+#include <linux/a.out.h>
+
+static int load_binary(struct linux_binprm *bprm, struct pt_regs *regs)
+{
+	struct exec *eh = (struct exec *)bprm->buf;
+	unsigned long loader;
+	struct file *file;
+	int retval;
+
+	if (eh->fh.f_magic != 0x183 || (eh->fh.f_flags & 0x3000) != 0x3000)
+		return -ENOEXEC;
+
+	if (bprm->loader)
+		return -ENOEXEC;
+
+	allow_write_access(bprm->file);
+	fput(bprm->file);
+	bprm->file = NULL;
+
+	loader = bprm->vma->vm_end - sizeof(void *);
+
+	file = open_exec("/sbin/loader");
+	retval = PTR_ERR(file);
+	if (IS_ERR(file))
+		return retval;
+
+	/* Remember if the application is TASO.  */
+	bprm->taso = eh->ah.entry < 0x100000000UL;
+
+	bprm->file = file;
+	bprm->loader = loader;
+	retval = prepare_binprm(bprm);
+	if (retval < 0)
+		return retval;
+	return search_binary_handler(bprm,regs);
+}
+
+static struct linux_binfmt loader_format = {
+	.load_binary	= load_binary,
+};
+
+static int __init init_loader_binfmt(void)
+{
+	return register_binfmt(&loader_format);
+}
+arch_initcall(init_loader_binfmt);
diff --git a/fs/exec.c b/fs/exec.c
index dfbf700..3ef9cf9 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -57,11 +57,6 @@
 #include <asm/tlb.h>
 #include "internal.h"
 
-#ifdef __alpha__
-/* for /sbin/loader handling in search_binary_handler() */
-#include <linux/a.out.h>
-#endif
-
 int core_uses_pid;
 char core_pattern[CORENAME_MAX_SIZE] = "core";
 int suid_dumpable = 0;
@@ -1172,41 +1167,7 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 	unsigned int depth = bprm->recursion_depth;
 	int try,retval;
 	struct linux_binfmt *fmt;
-#ifdef __alpha__
-	/* handle /sbin/loader.. */
-	{
-	    struct exec * eh = (struct exec *) bprm->buf;
 
-	    if (!bprm->loader && eh->fh.f_magic == 0x183 &&
-		(eh->fh.f_flags & 0x3000) == 0x3000)
-	    {
-		struct file * file;
-		unsigned long loader;
-
-		allow_write_access(bprm->file);
-		fput(bprm->file);
-		bprm->file = NULL;
-
-		loader = bprm->vma->vm_end - sizeof(void *);
-
-		file = open_exec("/sbin/loader");
-		retval = PTR_ERR(file);
-		if (IS_ERR(file))
-			return retval;
-
-		/* Remember if the application is TASO.  */
-		bprm->taso = eh->ah.entry < 0x100000000UL;
-
-		bprm->file = file;
-		bprm->loader = loader;
-		retval = prepare_binprm(bprm);
-		if (retval<0)
-			return retval;
-		/* should call search_binary_handler recursively here,
-		   but it does not matter */
-	    }
-	}
-#endif
 	retval = security_bprm_check(bprm);
 	if (retval)
 		return retval;
-- 
1.5.6.5

