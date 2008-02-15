Return-Path: <linux-kernel-owner+w=401wt.eu-S934082AbYBOOCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934082AbYBOOCh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 09:02:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759355AbYBOOCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 09:02:12 -0500
Received: from ag-out-0708.google.com ([72.14.246.245]:41797 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758540AbYBOOCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 09:02:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:message-id:to:cc:subject:from:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=JPkU+PzYbNPkxrhtx5oOhEYsyRlgpbpifvQZFmVrfz+G7bIqZhFxhjD7IRlbgbuHKHPBmPMDlhpaP0a+y31OdGrELjVvBUN9m7rnHUwJFORBINkSTkSZh7lsGvRHLMAZkeXmNf7KdtJE2wfpoPtLU7L6ivoTXP6jYN5JSKl7pM4=
Date: Fri, 15 Feb 2008 21:58:02 +0800 (CST)
Message-Id: <20080215.215802.139099786.xiyou.wangcong@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>
Subject: [Patch] Fix shadowed variables in fs/binfmt_elf.c
From: WANG Cong <xiyou.wangcong@gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix these sparse warings:
fs/binfmt_elf.c:1749:29: warning: symbol 'tmp' shadows an earlier one
fs/binfmt_elf.c:1734:28: originally declared here
fs/binfmt_elf.c:2009:26: warning: symbol 'vma' shadows an earlier one
fs/binfmt_elf.c:1892:24: originally declared here

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 41a958a..6562563 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1746,11 +1746,11 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
 		while_each_thread(g, p);
 		rcu_read_unlock();
 		list_for_each(t, &info->thread_list) {
-			struct elf_thread_status *tmp;
+			struct elf_thread_status *temp;
 			int sz;
 
-			tmp = list_entry(t, struct elf_thread_status, list);
-			sz = elf_dump_thread_status(signr, tmp);
+			temp = list_entry(t, struct elf_thread_status, list);
+			sz = elf_dump_thread_status(signr, temp);
 			info->thread_status_size += sz;
 		}
 	}
@@ -2006,10 +2006,10 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, un
 
 		for (addr = vma->vm_start; addr < end; addr += PAGE_SIZE) {
 			struct page *page;
-			struct vm_area_struct *vma;
+			struct vm_area_struct *tmp_vma;
 
 			if (get_user_pages(current, current->mm, addr, 1, 0, 1,
-						&page, &vma) <= 0) {
+						&page, &tmp_vma) <= 0) {
 				DUMP_SEEK(PAGE_SIZE);
 			} else {
 				if (page == ZERO_PAGE(0)) {
@@ -2019,7 +2019,7 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, un
 					}
 				} else {
 					void *kaddr;
-					flush_cache_page(vma, addr,
+					flush_cache_page(tmp_vma, addr,
 							 page_to_pfn(page));
 					kaddr = kmap(page);
 					if ((size += PAGE_SIZE) > limit ||
