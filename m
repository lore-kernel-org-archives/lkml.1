Return-Path: <linux-kernel-owner+w=401wt.eu-S1756261AbXERRdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261AbXERRdV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 13:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbXERRdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 13:33:14 -0400
Received: from [207.189.120.14] ([207.189.120.14]:37841 "EHLO
	smtp2.linux-foundation.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750893AbXERRdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 13:33:13 -0400
Date: Fri, 18 May 2007 10:29:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kratochvil <honza@jikos.cz>
Cc: Jiri Kosina <jkosina@suse.cz>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RESEND] PIE randomization
Message-Id: <20070518102918.4b9272e9.akpm@linux-foundation.org>
In-Reply-To: <alpine.LRH.0.98.0705172221440.22353@twin.jikos.cz>
References: <alpine.LRH.0.98.0705111338230.22353@twin.jikos.cz>
	<20070511125629.3df919cf.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705112211440.16923@twin.jikos.cz>
	<20070511133651.63f8a14d.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705120048230.11493@jikos.suse.cz>
	<Pine.LNX.4.64.0705161851120.25986@twin.jikos.cz>
	<alpine.LRH.0.98.0705172221440.22353@twin.jikos.cz>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2007 22:24:11 +0200 (CEST)
Jan Kratochvil <honza@jikos.cz> wrote:

> This patch is using mmap()'s randomization functionality in such a way 
> that it maps the main executable of (specially compiled/linked -pie/-fpie) 
> ET_DYN binaries onto a random address (in cases in which mmap() is allowed 
> to perform a randomization).
> 
> Origin of this patch is in exec-shield (http://people.redhat.com/mingo/exec-shield/)


From: Andrew Morton <akpm@linux-foundation.org>

- the compiler knows how to inline things

- return -EINVAL on zero-size, not -EIO

- reduce scope of local `interp_map_addr', remove unneeded initialisation,
  add needed comment.

- coding-style repairs

Cc: Jan Kratochvil <honza@jikos.cz>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>
Cc: Jakub Jelinek <jakub@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |   26 +++++++++++++++++---------
 1 files changed, 17 insertions(+), 9 deletions(-)

diff -puN fs/binfmt_elf.c~pie-randomization-fix fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~pie-randomization-fix
+++ a/fs/binfmt_elf.c
@@ -322,17 +322,17 @@ static unsigned long elf_map(struct file
 
 #endif /* !elf_map */
 
-static inline unsigned long total_mapping_size(struct elf_phdr *cmds, int nr)
+static unsigned long total_mapping_size(struct elf_phdr *cmds, int nr)
 {
 	int i, first_idx = -1, last_idx = -1;
 
-	for (i = 0; i < nr; i++)
+	for (i = 0; i < nr; i++) {
 		if (cmds[i].p_type == PT_LOAD) {
 			last_idx = i;
 			if (first_idx == -1)
 				first_idx = i;
 		}
-
+	}
 	if (first_idx == -1)
 		return 0;
 
@@ -396,8 +396,10 @@ static unsigned long load_elf_interp(str
 	}
 
 	total_size = total_mapping_size(elf_phdata, interp_elf_ex->e_phnum);
-	if (!total_size)
+	if (!total_size) {
+		error = -EINVAL;
 		goto out_close;
+	}
 
 	eppnt = elf_phdata;
 	for (i = 0; i < interp_elf_ex->e_phnum; i++, eppnt++) {
@@ -586,7 +588,8 @@ static int load_elf_binary(struct linux_
 	int elf_exec_fileno;
 	int retval, i;
 	unsigned int size;
-	unsigned long elf_entry, interp_load_addr = 0, interp_map_addr = 0;
+	unsigned long elf_entry;
+	unsigned long interp_load_addr = 0;
 	unsigned long start_code, end_code, start_data, end_data;
 	unsigned long reloc_func_desc = 0;
 	char passed_fileno[6];
@@ -908,7 +911,7 @@ static int load_elf_binary(struct linux_
 			 * default mmap base, as well as whatever program they
 			 * might try to exec.  This is because the brk will
 			 * follow the loader, and is not movable.  */
-#if defined(__i386__) || defined(__x86_64__)
+#ifdef CONFIG_X86
 			load_bias = 0;
 #else
 			load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE - vaddr);
@@ -992,16 +995,21 @@ static int load_elf_binary(struct linux_
 	}
 
 	if (elf_interpreter) {
-		if (interpreter_type == INTERPRETER_AOUT)
+		if (interpreter_type == INTERPRETER_AOUT) {
 			elf_entry = load_aout_interp(&loc->interp_ex,
 						     interpreter);
-		else {
+		} else {
+			unsigned long interp_map_addr;	/* unused */
+
 			elf_entry = load_elf_interp(&loc->interp_elf_ex,
 						    interpreter,
 						    &interp_map_addr,
 						    load_bias);
 			if (!BAD_ADDR(elf_entry)) {
-				/* load_elf_interp() returns relocation adjustment */
+				/*
+				 * load_elf_interp() returns relocation
+				 * adjustment
+				 */
 				interp_load_addr = elf_entry;
 				elf_entry += loc->interp_elf_ex.e_entry;
 			}
_

