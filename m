Return-Path: <linux-kernel-owner+w=401wt.eu-S1751560AbZJWKIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560AbZJWKIu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 06:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbZJWKIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 06:08:49 -0400
Received: from relay2.mail.masterhost.ru ([83.222.23.62]:58032 "EHLO
	relay2.mail.masterhost.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbZJWKIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 06:08:49 -0400
X-Greylist: delayed 1174 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Oct 2009 06:08:48 EDT
Message-ID: <4AE17C1A.4060009@mayc.ru>
Date: Fri, 23 Oct 2009 13:49:14 +0400
From: "Anton D. Kachalov" <mouse@mayc.ru>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] binfmt_elf: FatELF support in the binary loader.
Content-Type: multipart/mixed;
 boundary="------------020008000806080604080701"
X-SpamTest-Envelope-From: mouse@mayc.ru
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 10358 [Oct 23 2009]
X-SpamTest-Method: none
X-SpamTest-Rate: 0
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020008000806080604080701
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I have made very similar patch but it's quite small and do not require
deep hacks.
It should works with "setarch" too to force selection of binary.
There is a tool to merge binaries. Glibc / binutils patch work in progress.

Rgds,
Anton

--------------020008000806080604080701
Content-Type: text/x-patch;
 name="binfmt-truearch-mouse.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="binfmt-truearch-mouse.patch"

--- kernel-2.6.28-jaunty/fs/binfmt_elf.c.orig	2009-06-10 07:05:27.000000000 +0400
+++ kernel-2.6.28/fs/binfmt_elf.c	2009-09-29 14:46:39.008238197 +0400
@@ -571,6 +571,7 @@ static int load_elf_binary(struct linux_
 	unsigned long elf_bss, elf_brk;
 	int retval, i;
 	unsigned int size;
+	unsigned int offset;
 	unsigned long elf_entry;
 	unsigned long interp_load_addr = 0;
 	unsigned long start_code, end_code, start_data, end_data;
@@ -588,6 +589,8 @@ static int load_elf_binary(struct linux_
 		goto out_ret;
 	}
 	
+	offset = 0;
+retry_elf:
 	/* Get the exec-header */
 	loc->elf_ex = *((struct elfhdr *)bprm->buf);
 
@@ -598,8 +601,27 @@ static int load_elf_binary(struct linux_
 
 	if (loc->elf_ex.e_type != ET_EXEC && loc->elf_ex.e_type != ET_DYN)
 		goto out;
-	if (!elf_check_arch(&loc->elf_ex))
+#if (defined(__x86_64__) || defined(__powerpc64__) || defined(__s390x__)) \
+    && ELF_CLASS == ELFCLASS64
+	if (personality(current->personality) == PER_LINUX32)
 		goto out;
+#endif
+	if (!elf_check_arch(&loc->elf_ex)) {
+		offset = loc->elf_ex.e_ident[0xc]
+			| loc->elf_ex.e_ident[0xd] << 8
+			| loc->elf_ex.e_ident[0xe] << 16
+			| loc->elf_ex.e_ident[0xf] << 24;
+		if (offset != 0) {
+			memset(bprm->buf, 0, BINPRM_BUF_SIZE);
+			retval = kernel_read(bprm->file, offset, bprm->buf, BINPRM_BUF_SIZE);
+			if (retval != BINPRM_BUF_SIZE) {
+				retval = -ENOEXEC;
+				goto out;
+			}
+			goto retry_elf;
+		}
+		goto out;
+	}
 	if (!bprm->file->f_op||!bprm->file->f_op->mmap)
 		goto out;
 
@@ -723,13 +745,30 @@ static int load_elf_binary(struct linux_
 
 	/* Some simple consistency checks for the interpreter */
 	if (elf_interpreter) {
+		offset = 0;
+retry_interp:
 		retval = -ELIBBAD;
+		loc->interp_elf_ex = *((struct elfhdr *)bprm->buf);
 		/* Not an ELF interpreter */
 		if (memcmp(loc->interp_elf_ex.e_ident, ELFMAG, SELFMAG) != 0)
 			goto out_free_dentry;
 		/* Verify the interpreter has a valid arch */
-		if (!elf_check_arch(&loc->interp_elf_ex))
+		if (!elf_check_arch(&loc->interp_elf_ex)) {
+			offset = loc->interp_elf_ex.e_ident[0xc]
+				| loc->interp_elf_ex.e_ident[0xd] << 8
+				| loc->interp_elf_ex.e_ident[0xe] << 16
+				| loc->interp_elf_ex.e_ident[0xf] << 24;
+			if (offset != 0) {
+				memset(bprm->buf, 0, BINPRM_BUF_SIZE);
+				retval = kernel_read(bprm->file, offset, bprm->buf, BINPRM_BUF_SIZE);
+				if (retval != BINPRM_BUF_SIZE) {
+					retval = -ELIBBAD;
+					goto out;
+				}
+				goto retry_interp;
+			}
 			goto out_free_dentry;
+		}
 	} else {
 		/* Executables without an interpreter also need a personality  */
 		SET_PERSONALITY(loc->elf_ex);
@@ -1026,18 +1065,42 @@ static int load_elf_library(struct file 
 	unsigned long elf_bss, bss, len;
 	int retval, error, i, j;
 	struct elfhdr elf_ex;
+	unsigned int offset;
 
 	error = -ENOEXEC;
 	retval = kernel_read(file, 0, (char *)&elf_ex, sizeof(elf_ex));
 	if (retval != sizeof(elf_ex))
 		goto out;
 
+	offset = 0;
+retry_lib:
 	if (memcmp(elf_ex.e_ident, ELFMAG, SELFMAG) != 0)
 		goto out;
 
 	/* First of all, some simple consistency checks */
-	if (elf_ex.e_type != ET_EXEC || elf_ex.e_phnum > 2 ||
-	    !elf_check_arch(&elf_ex) || !file->f_op || !file->f_op->mmap)
+	if (elf_ex.e_type != ET_EXEC || elf_ex.e_phnum > 2)
+		goto out;
+#if (defined(__x86_64__) || defined(__powerpc64__) || defined(__s390x__)) \
+    && ELF_CLASS == ELFCLASS64
+	if (personality(current->personality) == PER_LINUX32)
+		goto out;
+#endif
+	if (!elf_check_arch(&elf_ex)) {
+		offset = elf_ex.e_ident[0xc]
+			| elf_ex.e_ident[0xd] << 8
+			| elf_ex.e_ident[0xe] << 16
+			| elf_ex.e_ident[0xf] << 24;
+		if (offset != 0) {
+			retval = kernel_read(file, offset, (char *)&elf_ex, sizeof(elf_ex));
+			if (retval != sizeof(elf_ex)) {
+				retval = -ENOEXEC;
+				goto out;
+			}
+			goto retry_lib;
+		}
+		goto out;
+	}
+	if (!file->f_op || !file->f_op->mmap)
 		goto out;
 
 	/* Now read in all of the header information */

--------------020008000806080604080701--
