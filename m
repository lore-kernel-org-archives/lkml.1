Return-Path: <linux-kernel-owner+w=401wt.eu-S1765156AbYASE72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765156AbYASE72 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 23:59:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762480AbYASE7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 23:59:21 -0500
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:35719 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756454AbYASE7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 23:59:20 -0500
Date: Sat, 19 Jan 2008 05:59:18 +0100
From: Andi Kleen <andi@firstfloor.org>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH for mm] Remove iBCS support
Message-ID: <20080119045918.GA12215@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 19 Jan 2008 04:53:05.0846 (UTC) FILETIME=[2DE16560:01C85A57]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Andrew,

Can you please queue this patch in -mm for .25. It was posted earlier
and nobody complained.

Thanks,
-Andi

----


Remove ibcs2 support in ELF loader too

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
 
