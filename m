Return-Path: <linux-kernel-owner+w=401wt.eu-S1761707AbXGRV34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761707AbXGRV34 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 17:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759275AbXGRV3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 17:29:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758133AbXGRV3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 17:29:44 -0400
Message-ID: <469E8625.5070109@redhat.com>
Date: Wed, 18 Jul 2007 17:29:09 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Jan Kratochvil <honza@jikos.cz>, Jakub Jelinek <jakub@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [patch] binfmt_elf: clean up the PIE randomization code
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The recent PIE randomization patch changed the BAD_ADDR() macro
in binfmt_elf.c:

     -#define BAD_ADDR(x) ((unsigned long)(x) >= TASK_SIZE)
     +#define BAD_ADDR(x) IS_ERR_VALUE(x)

But in general this is not what is desired. There was only
one piece of code that wanted to use a different check.
It is much cleaner and clearer to revert part of the patch
so the code works like it did before and the change to
the macro is unnecessary. (This is what has been done in
the Red Hat Enterprise kernels.)

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>

---
 fs/binfmt_elf.c |   26 +++++++-------------------
 1 file changed, 7 insertions(+), 19 deletions(-)

--- 2.6.22-git11-d390.orig/fs/binfmt_elf.c
+++ 2.6.22-git11-d390/fs/binfmt_elf.c
@@ -80,7 +80,7 @@ static struct linux_binfmt elf_format = 
 		.hasvdso	= 1
 };
 
-#define BAD_ADDR(x) IS_ERR_VALUE(x)
+#define BAD_ADDR(x) ((unsigned long)(x) >= TASK_SIZE)
 
 static int set_brk(unsigned long start, unsigned long end)
 {
@@ -347,7 +347,7 @@ static unsigned long total_mapping_size(
    an ELF header */
 
 static unsigned long load_elf_interp(struct elfhdr *interp_elf_ex,
-		struct file *interpreter, unsigned long *interp_map_addr,
+		struct file *interpreter, unsigned long *interp_load_addr,
 		unsigned long no_base)
 {
 	struct elf_phdr *elf_phdata;
@@ -424,8 +424,6 @@ static unsigned long load_elf_interp(str
 			map_addr = elf_map(interpreter, load_addr + vaddr,
 					   eppnt, elf_prot, elf_type, total_size);
 			total_size = 0;
-			if (!*interp_map_addr)
-				*interp_map_addr = map_addr;
 			error = map_addr;
 			if (BAD_ADDR(map_addr))
 				goto out_close;
@@ -491,7 +489,8 @@ static unsigned long load_elf_interp(str
 			goto out_close;
 	}
 
-	error = load_addr;
+	*interp_load_addr = load_addr;
+	error = ((unsigned long)interp_elf_ex->e_entry) + load_addr;
 
 out_close:
 	kfree(elf_phdata);
@@ -995,25 +994,14 @@ static int load_elf_binary(struct linux_
 	}
 
 	if (elf_interpreter) {
-		if (interpreter_type == INTERPRETER_AOUT) {
+		if (interpreter_type == INTERPRETER_AOUT)
 			elf_entry = load_aout_interp(&loc->interp_ex,
 						     interpreter);
-		} else {
-			unsigned long uninitialized_var(interp_map_addr);
-
+		else
 			elf_entry = load_elf_interp(&loc->interp_elf_ex,
 						    interpreter,
-						    &interp_map_addr,
+						    &interp_load_addr,
 						    load_bias);
-			if (!BAD_ADDR(elf_entry)) {
-				/*
-				 * load_elf_interp() returns relocation
-				 * adjustment
-				 */
-				interp_load_addr = elf_entry;
-				elf_entry += loc->interp_elf_ex.e_entry;
-			}
-		}
 		if (BAD_ADDR(elf_entry)) {
 			force_sig(SIGSEGV, current);
 			retval = IS_ERR((void *)elf_entry) ?
