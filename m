Return-Path: <linux-kernel-owner+w=401wt.eu-S1757745AbYAPW3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757745AbYAPW3i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 17:29:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755262AbYAPWTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 17:19:04 -0500
Received: from mail.suse.de ([195.135.220.2]:55690 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753648AbYAPWTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 17:19:00 -0500
From: Andi Kleen <ak@suse.de>
References: <200801161118.044582000@suse.de>
In-Reply-To: <200801161118.044582000@suse.de>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH mm] [2/2] Remove ibcs2 support in ELF loader too
Message-Id: <20080116221859.2BE86150C8@wotan.suse.de>
Date: Wed, 16 Jan 2008 23:18:59 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ibcs2 support has never been supported on 2.6 kernels as far as I know,
and if it has it must have been an external patch. Anyways, if anybody
applies an external patch they could as well readd the ibcs checking
code to the ELF loader in the same patch. But there is no reason
to keep this code running in all Linux kernels. This will save at least
two strcmps each ELF execution.

No deprecation period because it could not have been used anyways.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 fs/binfmt_elf.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

Index: linux/fs/binfmt_elf.c
===================================================================
--- linux.orig/fs/binfmt_elf.c
+++ linux/fs/binfmt_elf.c
@@ -530,7 +530,6 @@ static int load_elf_binary(struct linux_
  	unsigned long load_addr = 0, load_bias = 0;
 	int load_addr_set = 0;
 	char * elf_interpreter = NULL;
-	unsigned char ibcs2_interpreter = 0;
 	unsigned long error;
 	struct elf_phdr *elf_ppnt, *elf_phdata;
 	unsigned long elf_bss, elf_brk;
@@ -647,14 +646,6 @@ static int load_elf_binary(struct linux_
 			if (elf_interpreter[elf_ppnt->p_filesz - 1] != '\0')
 				goto out_free_interp;
 
-			/* If the program interpreter is one of these two,
-			 * then assume an iBCS2 image. Otherwise assume
-			 * a native linux image.
-			 */
-			if (strcmp(elf_interpreter,"/usr/lib/libc.so.1") == 0 ||
-			    strcmp(elf_interpreter,"/usr/lib/ld.so.1") == 0)
-				ibcs2_interpreter = 1;
-
 			/*
 			 * The early SET_PERSONALITY here is so that the lookup
 			 * for the interpreter happens in the namespace of the 
@@ -674,7 +665,7 @@ static int load_elf_binary(struct linux_
 			 * switch really is going to happen - do this in
 			 * flush_thread().	- akpm
 			 */
-			SET_PERSONALITY(loc->elf_ex, ibcs2_interpreter);
+			SET_PERSONALITY(loc->elf_ex, 0);
 
 			interpreter = open_exec(elf_interpreter);
 			retval = PTR_ERR(interpreter);
@@ -725,7 +716,7 @@ static int load_elf_binary(struct linux_
 			goto out_free_dentry;
 	} else {
 		/* Executables without an interpreter also need a personality  */
-		SET_PERSONALITY(loc->elf_ex, ibcs2_interpreter);
+		SET_PERSONALITY(loc->elf_ex, 0);
 	}
 
 	/* OK, we are done with that, now set up the arg stuff,
@@ -748,7 +739,7 @@ static int load_elf_binary(struct linux_
 
 	/* Do this immediately, since STACK_TOP as used in setup_arg_pages
 	   may depend on the personality.  */
-	SET_PERSONALITY(loc->elf_ex, ibcs2_interpreter);
+	SET_PERSONALITY(loc->elf_ex, 0);
 	if (elf_read_implies_exec(loc->elf_ex, executable_stack))
 		current->personality |= READ_IMPLIES_EXEC;
 
