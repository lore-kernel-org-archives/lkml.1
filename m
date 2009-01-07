Return-Path: <linux-kernel-owner+w=401wt.eu-S1753568AbZAGQ0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbZAGQ0a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 11:26:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752321AbZAGQ0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 11:26:19 -0500
Received: from wf-out-1314.google.com ([209.85.200.173]:64677 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274AbZAGQ0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 11:26:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=fqD5TyGaBuD0lzjNIZVWAygNuESRR4rxdUH4+5czT7zL+hoZIPFXs8oV4plHVCCWQM
         YDVs2oEmdM4cYtAOCZXWicmTkvGrr6b/g6mjc/zUOSxgoHyAVJNfa6IS2JTT4xPLHd1y
         VuIswz6ZMcgnDgUhNEJYcQbpY8hnbw/q+WQtc=
From: Bryan Wu <cooloney@kernel.org>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/1] bin_elf_fdpic: check the return value of clear_user
Date: Thu,  8 Jan 2009 00:27:06 +0800
Message-Id: <1231345626-27023-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 fs/binfmt_elf_fdpic.c |   25 +++++++++++++++++--------
 1 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index aa5b432..008be20 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -980,9 +980,12 @@ static int elf_fdpic_map_file_constdisp_on_uclinux(
 			params->elfhdr_addr = seg->addr;
 
 		/* clear any space allocated but not loaded */
-		if (phdr->p_filesz < phdr->p_memsz)
-			clear_user((void *) (seg->addr + phdr->p_filesz),
-				   phdr->p_memsz - phdr->p_filesz);
+		if (phdr->p_filesz < phdr->p_memsz) {
+			ret = clear_user((void *) (seg->addr + phdr->p_filesz),
+					 phdr->p_memsz - phdr->p_filesz);
+			if (ret)
+				return ret;
+		}
 
 		if (mm) {
 			if (phdr->p_flags & PF_X) {
@@ -1022,7 +1025,7 @@ static int elf_fdpic_map_file_by_direct_mmap(struct elf_fdpic_params *params,
 	struct elf32_fdpic_loadseg *seg;
 	struct elf32_phdr *phdr;
 	unsigned long load_addr, delta_vaddr;
-	int loop, dvset;
+	int loop, dvset, ret;
 
 	load_addr = params->load_addr;
 	delta_vaddr = 0;
@@ -1122,7 +1125,9 @@ static int elf_fdpic_map_file_by_direct_mmap(struct elf_fdpic_params *params,
 		 * PT_LOAD */
 		if (prot & PROT_WRITE && disp > 0) {
 			kdebug("clear[%d] ad=%lx sz=%lx", loop, maddr, disp);
-			clear_user((void __user *) maddr, disp);
+			ret = clear_user((void __user *) maddr, disp);
+			if (ret)
+				return ret;
 			maddr += disp;
 		}
 
@@ -1157,15 +1162,19 @@ static int elf_fdpic_map_file_by_direct_mmap(struct elf_fdpic_params *params,
 		if (prot & PROT_WRITE && excess1 > 0) {
 			kdebug("clear[%d] ad=%lx sz=%lx",
 			       loop, maddr + phdr->p_filesz, excess1);
-			clear_user((void __user *) maddr + phdr->p_filesz,
-				   excess1);
+			ret = clear_user((void __user *) maddr + phdr->p_filesz,
+					 excess1);
+			if (ret)
+				return ret;
 		}
 
 #else
 		if (excess > 0) {
 			kdebug("clear[%d] ad=%lx sz=%lx",
 			       loop, maddr + phdr->p_filesz, excess);
-			clear_user((void *) maddr + phdr->p_filesz, excess);
+			ret = clear_user((void *) maddr + phdr->p_filesz, excess);
+			if (ret)
+				return ret;
 		}
 #endif
 
-- 
1.5.6

