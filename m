Return-Path: <linux-kernel-owner+w=401wt.eu-S1758958AbYDSJzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758958AbYDSJzx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 05:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbYDSJzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 05:55:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44443 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752840AbYDSJzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 05:55:45 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FDPIC: Check that the size returned by kernel_read() is what
	we asked for
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: chris.rohlf@gmail.com, dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Sat, 19 Apr 2008 10:54:10 +0100
Message-ID: <20080419095410.14947.72015.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Check that the size of the read returned by kernel_read() is what we asked for.
If it isn't, then reject the binary as being a badly formatted.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/binfmt_elf_fdpic.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)


diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 32649f2..ddd35d8 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -136,8 +136,8 @@ static int elf_fdpic_fetch_phdrs(struct elf_fdpic_params *params,
 
 	retval = kernel_read(file, params->hdr.e_phoff,
 			     (char *) params->phdrs, size);
-	if (retval < 0)
-		return retval;
+	if (unlikely(retval != size))
+		return retval < 0 ? retval : -ENOEXEC;
 
 	/* determine stack size for this binary */
 	phdr = params->phdrs;
@@ -218,8 +218,11 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm,
 					     phdr->p_offset,
 					     interpreter_name,
 					     phdr->p_filesz);
-			if (retval < 0)
+			if (unlikely(retval != phdr->p_filesz)) {
+				if (retval >= 0)
+					retval = -ENOEXEC;
 				goto error;
+			}
 
 			retval = -ENOENT;
 			if (interpreter_name[phdr->p_filesz - 1] != '\0')
@@ -245,8 +248,11 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm,
 
 			retval = kernel_read(interpreter, 0, bprm->buf,
 					     BINPRM_BUF_SIZE);
-			if (retval < 0)
+			if (unlikely(retval != BINPRM_BUF_SIZE)) {
+				if (retval >= 0)
+					retval = -ENOEXEC;
 				goto error;
+			}
 
 			interp_params.hdr = *((struct elfhdr *) bprm->buf);
 			break;

