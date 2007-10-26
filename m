Return-Path: <linux-kernel-owner+w=401wt.eu-S1763689AbXJZPmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763689AbXJZPmi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 11:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763346AbXJZPm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 11:42:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42156 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762818AbXJZPm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 11:42:26 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/2] MN10300: Permit AOUT library support to be suppressed in
	ELF binfmt
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-am33-list@redhat.com,
       dhowells@redhat.com
Date: Fri, 26 Oct 2007 16:42:15 +0100
Message-ID: <20071026154215.30983.32978.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071026154210.30983.67470.stgit@warthog.procyon.org.uk>
References: <20071026154210.30983.67470.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Permit AOUT library support to be suppressed in the ELF binfmt if the arch does
not support it.  AOUT support is suppressed by adding:

	config NO_AOUT_SUPPORT
		def_bool y

to the arch Kconfig file.

The MN10300 architecture does not support the AOUT binfmt, so the ELF binfmt
should not be permitted to go looking for AOUT libraries to load.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/Kconfig.binfmt     |    3 ++-
 fs/binfmt_elf.c       |   30 ++++++++++++++++++++++--------
 include/linux/a.out.h |    6 ++++++
 3 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/fs/Kconfig.binfmt b/fs/Kconfig.binfmt
index d4fc609..a9ea391 100644
--- a/fs/Kconfig.binfmt
+++ b/fs/Kconfig.binfmt
@@ -57,7 +57,8 @@ config BINFMT_SHARED_FLAT
 
 config BINFMT_AOUT
 	tristate "Kernel support for a.out and ECOFF binaries"
-	depends on X86_32 || ALPHA || ARM || M68K || SPARC32
+	depends on (X86_32 || ALPHA || ARM || M68K || SPARC32) && \
+		!NO_AOUT_SUPPORT
 	---help---
 	  A.out (Assembler.OUTput) is a set of formats for libraries and
 	  executables used in the earliest versions of UNIX.  Linux used
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index ba8de7c..5a348c6 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -464,6 +464,7 @@ out:
 	return error;
 }
 
+#ifndef CONFIG_NO_AOUT_SUPPORT
 static unsigned long load_aout_interp(struct exec *interp_ex,
 		struct file *interpreter)
 {
@@ -509,6 +510,10 @@ static unsigned long load_aout_interp(struct exec *interp_ex,
 out:
 	return elf_entry;
 }
+#else
+extern unsigned long load_aout_interp(struct exec *interp_ex,
+				      struct file *interpreter);
+#endif
 
 /*
  * These are the functions used to load ELF style executables and shared
@@ -516,9 +521,15 @@ out:
  */
 
 #define INTERPRETER_NONE 0
-#define INTERPRETER_AOUT 1
 #define INTERPRETER_ELF 2
 
+#ifndef CONFIG_NO_AOUT_SUPPORT
+#define INTERPRETER_AOUT 1
+#define IS_AOUT_INTERP(x) ((x) == INTERPRETER_AOUT)
+#else
+#define IS_AOUT_INTERP(x) (0)
+#endif
+
 #ifndef STACK_RND_MASK
 #define STACK_RND_MASK (0x7ff >> (PAGE_SHIFT - 12))	/* 8MB of VA */
 #endif
@@ -734,6 +745,7 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	/* Some simple consistency checks for the interpreter */
 	if (elf_interpreter) {
 		static int warn;
+#ifndef CONFIG_NO_AOUT_SUPPORT
 		interpreter_type = INTERPRETER_ELF | INTERPRETER_AOUT;
 
 		/* Now figure out which format our binary is */
@@ -741,11 +753,13 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 		    (N_MAGIC(loc->interp_ex) != ZMAGIC) &&
 		    (N_MAGIC(loc->interp_ex) != QMAGIC))
 			interpreter_type = INTERPRETER_ELF;
-
+#else
+		interpreter_type = INTERPRETER_ELF;
+#endif
 		if (memcmp(loc->interp_elf_ex.e_ident, ELFMAG, SELFMAG) != 0)
 			interpreter_type &= ~INTERPRETER_ELF;
 
-		if (interpreter_type == INTERPRETER_AOUT && warn < 10) {
+		if (IS_AOUT_INTERP(interpreter_type) && warn < 10) {
 			printk(KERN_WARNING "a.out ELF interpreter %s is "
 				"deprecated and will not be supported "
 				"after Linux 2.6.25\n", elf_interpreter);
@@ -774,7 +788,7 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 
 	/* OK, we are done with that, now set up the arg stuff,
 	   and then start this sucker up */
-	if ((!bprm->sh_bang) && (interpreter_type == INTERPRETER_AOUT)) {
+	if (IS_AOUT_INTERP(interpreter_type) && !bprm->sh_bang) {
 		char *passed_p = passed_fileno;
 		sprintf(passed_fileno, "%d", elf_exec_fileno);
 
@@ -961,7 +975,7 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	}
 
 	if (elf_interpreter) {
-		if (interpreter_type == INTERPRETER_AOUT)
+		if (IS_AOUT_INTERP(interpreter_type))
 			elf_entry = load_aout_interp(&loc->interp_ex,
 						     interpreter);
 		else
@@ -990,7 +1004,7 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 
 	kfree(elf_phdata);
 
-	if (interpreter_type != INTERPRETER_AOUT)
+	if (!IS_AOUT_INTERP(interpreter_type))
 		sys_close(elf_exec_fileno);
 
 	set_binfmt(&elf_format);
@@ -1006,14 +1020,14 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	compute_creds(bprm);
 	current->flags &= ~PF_FORKNOEXEC;
 	retval = create_elf_tables(bprm, &loc->elf_ex,
-			  (interpreter_type == INTERPRETER_AOUT),
+			  IS_AOUT_INTERP(interpreter_type),
 			  load_addr, interp_load_addr);
 	if (retval < 0) {
 		send_sig(SIGKILL, current, 0);
 		goto out;
 	}
 	/* N.B. passed_fileno might not be initialized? */
-	if (interpreter_type == INTERPRETER_AOUT)
+	if (IS_AOUT_INTERP(interpreter_type))
 		current->mm->arg_start += strlen(passed_fileno) + 1;
 	current->mm->end_code = end_code;
 	current->mm->start_code = start_code;
diff --git a/include/linux/a.out.h b/include/linux/a.out.h
index f913cc3..9624833 100644
--- a/include/linux/a.out.h
+++ b/include/linux/a.out.h
@@ -1,6 +1,8 @@
 #ifndef __A_OUT_GNU_H__
 #define __A_OUT_GNU_H__
 
+#ifndef CONFIG_NO_AOUT_SUPPORT
+
 #define __GNU_EXEC_MACROS__
 
 #ifndef __STRUCT_EXEC_OVERRIDE__
@@ -265,4 +267,8 @@ struct relocation_info
 #endif /* no N_RELOCATION_INFO_DECLARED.  */
 
 
+#else /* !CONFIG_NO_AOUT_SUPPORT */
+struct exec {
+};
+#endif /* !CONFIG_NO_AOUT_SUPPORT */
 #endif /* __A_OUT_GNU_H__ */

