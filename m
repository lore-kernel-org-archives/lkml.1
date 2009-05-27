Return-Path: <linux-kernel-owner+w=401wt.eu-S1756225AbZE0H6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225AbZE0H6b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750938AbZE0H6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:58:24 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:45901 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826AbZE0H6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:58:23 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dev@uclinux.org, uclinux-dist-devel@blackfin.uclinux.org,
       Jie Zhang <jie.zhang@analog.com>
Subject: [PATCH] FLAT: make sure data section is aligned at 32 bytes
Date: Wed, 27 May 2009 03:58:22 -0400
Message-Id: <1243411102-24630-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jie Zhang <jie.zhang@analog.com>

If a structure in the data section attempts to force a larger alignment,
the FLAT loader will break this when working with shared flat libraries
by inserting a few words before the data section.

URL: http://blackfin.uclinux.org/gf/tracker/4854
Signed-off-by: Jie Zhang <jie.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 fs/binfmt_flat.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index 5cebf0b..51d2e0e 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -542,7 +542,9 @@ static int load_flat_file(struct linux_binprm * bprm,
 			goto err;
 		}
 
-		len = data_len + extra + MAX_SHARED_LIBS * sizeof(unsigned long);
+		len = MAX_SHARED_LIBS * sizeof(unsigned long);
+		len = ALIGN(len, 0x20);
+		len = data_len + extra;
 		len = PAGE_ALIGN(len);
 		down_write(&current->mm->mmap_sem);
 		realdatastart = do_mmap(0, 0, len,
@@ -559,6 +561,7 @@ static int load_flat_file(struct linux_binprm * bprm,
 			goto err;
 		}
 		datapos = realdatastart + MAX_SHARED_LIBS * sizeof(unsigned long);
+		datapos = ALIGN(datapos, 0x20);
 
 		DBG_FLT("BINFMT_FLAT: Allocated data+bss+stack (%d bytes): %x\n",
 				(int)(data_len + bss_len + stack_len), (int)datapos);
@@ -577,7 +580,7 @@ static int load_flat_file(struct linux_binprm * bprm,
 		if (result >= (unsigned long)-4096) {
 			printk("Unable to read data+bss, errno %d\n", (int)-result);
 			do_munmap(current->mm, textpos, text_len);
-			do_munmap(current->mm, realdatastart, data_len + extra);
+			do_munmap(current->mm, realdatastart, len);
 			ret = result;
 			goto err;
 		}
@@ -587,7 +590,8 @@ static int load_flat_file(struct linux_binprm * bprm,
 		memp_size = len;
 	} else {
 
-		len = text_len + data_len + extra + MAX_SHARED_LIBS * sizeof(unsigned long);
+		len = text_len + MAX_SHARED_LIBS * sizeof(unsigned long);
+		len = ALIGN(len, 0x20) + data_len + extra;
 		len = PAGE_ALIGN(len);
 		down_write(&current->mm->mmap_sem);
 		textpos = do_mmap(0, 0, len,
@@ -605,8 +609,8 @@ static int load_flat_file(struct linux_binprm * bprm,
 
 		realdatastart = textpos + ntohl(hdr->data_start);
 		datapos = realdatastart + MAX_SHARED_LIBS * sizeof(unsigned long);
-		reloc = (unsigned long *) (textpos + ntohl(hdr->reloc_start) +
-				MAX_SHARED_LIBS * sizeof(unsigned long));
+		datapos = ALIGN(datapos, 0x20);
+		reloc = (unsigned long *) (datapos + ntohl(hdr->reloc_start) - text_len);
 		memp = textpos;
 		memp_size = len;
 #ifdef CONFIG_BINFMT_ZFLAT
@@ -643,8 +647,7 @@ static int load_flat_file(struct linux_binprm * bprm,
 		}
 		if (result >= (unsigned long)-4096) {
 			printk("Unable to read code+data+bss, errno %d\n",(int)-result);
-			do_munmap(current->mm, textpos, text_len + data_len + extra +
-				MAX_SHARED_LIBS * sizeof(unsigned long));
+			do_munmap(current->mm, textpos, len);
 			ret = result;
 			goto err;
 		}
@@ -892,7 +895,7 @@ static int load_flat_binary(struct linux_binprm * bprm, struct pt_regs * regs)
 #ifdef CONFIG_BINFMT_SHARED_FLAT
 	for (i = MAX_SHARED_LIBS-1; i>0; i--) {
 		if (libinfo.lib_list[i].loaded) {
-			/* Push previos first to call address */
+			/* Push previous first to call address */
 			--sp;	put_user(start_addr, sp);
 			start_addr = libinfo.lib_list[i].entry;
 		}
-- 
1.6.3.1

