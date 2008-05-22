Return-Path: <linux-kernel-owner+w=401wt.eu-S1756104AbYEVQLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbYEVQLv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 12:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753927AbYEVQLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 12:11:43 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:38729 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864AbYEVQLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 12:11:42 -0400
Date: Thu, 22 May 2008 19:11:40 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: dhowells@redhat.com
cc: clameter@sgi.com, mpm@selenic.com, lethal@linux-sh.org,
       linux-kernel@vger.kernel.org
Subject: [RFC/PATCH] nommu: fix ksize() abuse
Message-ID: <Pine.LNX.4.64.0805221909050.4056@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

The nommu binfmt code uses ksize() for pointers returned from do_mmap() 
which is wrong. This converts the call-sites to use the nommu specific 
kobjsize() function which works as expected.

Cc: Christoph Lameter <clameter@sgi.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 fs/binfmt_elf_fdpic.c |    2 +-
 fs/binfmt_flat.c      |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index ddd35d8..d051a32 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -390,7 +390,7 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm,
 	}
 
 	/* expand the stack mapping to use up the entire allocation granule */
-	fullsize = ksize((char *) current->mm->start_brk);
+	fullsize = kobjsize((char *) current->mm->start_brk);
 	if (!IS_ERR_VALUE(do_mremap(current->mm->start_brk, stack_size,
 				    fullsize, 0, 0)))
 		stack_size = fullsize;
diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index 3b40d45..2cb1acd 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -548,7 +548,7 @@ static int load_flat_file(struct linux_binprm * bprm,
 			PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE, 0);
 		/* Remap to use all availabe slack region space */
 		if (realdatastart && (realdatastart < (unsigned long)-4096)) {
-			reallen = ksize((void *)realdatastart);
+			reallen = kobjsize((void *)realdatastart);
 			if (reallen > len) {
 				realdatastart = do_mremap(realdatastart, len,
 					reallen, MREMAP_FIXED, realdatastart);
@@ -600,7 +600,7 @@ static int load_flat_file(struct linux_binprm * bprm,
 			PROT_READ | PROT_EXEC | PROT_WRITE, MAP_PRIVATE, 0);
 		/* Remap to use all availabe slack region space */
 		if (textpos && (textpos < (unsigned long) -4096)) {
-			reallen = ksize((void *)textpos);
+			reallen = kobjsize((void *)textpos);
 			if (reallen > len) {
 				textpos = do_mremap(textpos, len, reallen,
 					MREMAP_FIXED, textpos);
@@ -683,7 +683,7 @@ static int load_flat_file(struct linux_binprm * bprm,
 		 */
 		current->mm->start_brk = datapos + data_len + bss_len;
 		current->mm->brk = (current->mm->start_brk + 3) & ~3;
-		current->mm->context.end_brk = memp + ksize((void *) memp) - stack_len;
+		current->mm->context.end_brk = memp + kobjsize((void *) memp) - stack_len;
 	}
 
 	if (flags & FLAT_FLAG_KTRACE)
@@ -790,7 +790,7 @@ static int load_flat_file(struct linux_binprm * bprm,
 
 	/* zero the BSS,  BRK and stack areas */
 	memset((void*)(datapos + data_len), 0, bss_len + 
-			(memp + ksize((void *) memp) - stack_len -	/* end brk */
+			(memp + kobjsize((void *) memp) - stack_len -	/* end brk */
 			libinfo->lib_list[id].start_brk) +		/* start brk */
 			stack_len);
 
-- 
1.5.2.5

