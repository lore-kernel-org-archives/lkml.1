Return-Path: <linux-kernel-owner+w=401wt.eu-S1760518AbYBOUfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760518AbYBOUfW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 15:35:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755536AbYBOUfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 15:35:08 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58998 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755051AbYBOUfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 15:35:07 -0500
Date: Fri, 15 Feb 2008 12:34:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Patch] Fix shadowed variables in fs/binfmt_elf.c
Message-Id: <20080215123459.0a675826.akpm@linux-foundation.org>
In-Reply-To: <20080215.215802.139099786.xiyou.wangcong@gmail.com>
References: <20080215.215802.139099786.xiyou.wangcong@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2008 21:58:02 +0800 (CST)
WANG Cong <xiyou.wangcong@gmail.com> wrote:

> 
> Fix these sparse warings:
> fs/binfmt_elf.c:1749:29: warning: symbol 'tmp' shadows an earlier one
> fs/binfmt_elf.c:1734:28: originally declared here
> fs/binfmt_elf.c:2009:26: warning: symbol 'vma' shadows an earlier one
> fs/binfmt_elf.c:1892:24: originally declared here
> 
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> 
> ---
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index 41a958a..6562563 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -1746,11 +1746,11 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
>  		while_each_thread(g, p);
>  		rcu_read_unlock();
>  		list_for_each(t, &info->thread_list) {
> -			struct elf_thread_status *tmp;
> +			struct elf_thread_status *temp;
>  			int sz;
>  
> -			tmp = list_entry(t, struct elf_thread_status, list);
> -			sz = elf_dump_thread_status(signr, tmp);
> +			temp = list_entry(t, struct elf_thread_status, list);
> +			sz = elf_dump_thread_status(signr, temp);
>  			info->thread_status_size += sz;
>  		}
>  	}

`tmp' is an awful identifier, and renaming it to "temp" hardly improves it.
Please take any opportunity to fix this sort of thing.

I chose "ets" which is a bit weird but once one understand what it means,
it makes the code much easier to follow.

Also used the same local for both loops.  There seems little point in
instantiating a second one.


diff -puN fs/binfmt_elf.c~elf-fix-shadowed-variables-in-fs-binfmt_elfc fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~elf-fix-shadowed-variables-in-fs-binfmt_elfc
+++ a/fs/binfmt_elf.c
@@ -1728,26 +1728,25 @@ static int fill_note_info(struct elfhdr 
 
 	info->thread_status_size = 0;
 	if (signr) {
-		struct elf_thread_status *tmp;
+		struct elf_thread_status *ets;
 		rcu_read_lock();
 		do_each_thread(g, p)
 			if (current->mm == p->mm && current != p) {
-				tmp = kzalloc(sizeof(*tmp), GFP_ATOMIC);
-				if (!tmp) {
+				ets = kzalloc(sizeof(*ets), GFP_ATOMIC);
+				if (!ets) {
 					rcu_read_unlock();
 					return 0;
 				}
-				tmp->thread = p;
-				list_add(&tmp->list, &info->thread_list);
+				ets->thread = p;
+				list_add(&ets->list, &info->thread_list);
 			}
 		while_each_thread(g, p);
 		rcu_read_unlock();
 		list_for_each(t, &info->thread_list) {
-			struct elf_thread_status *tmp;
 			int sz;
 
-			tmp = list_entry(t, struct elf_thread_status, list);
-			sz = elf_dump_thread_status(signr, tmp);
+			ets = list_entry(t, struct elf_thread_status, list);
+			sz = elf_dump_thread_status(signr, ets);
 			info->thread_status_size += sz;
 		}
 	}
@@ -2003,10 +2002,10 @@ static int elf_core_dump(long signr, str
 
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
@@ -2016,7 +2015,7 @@ static int elf_core_dump(long signr, str
 					}
 				} else {
 					void *kaddr;
-					flush_cache_page(vma, addr,
+					flush_cache_page(tmp_vma, addr,
 							 page_to_pfn(page));
 					kaddr = kmap(page);
 					if ((size += PAGE_SIZE) > limit ||
_

