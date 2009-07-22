Return-Path: <linux-kernel-owner+w=401wt.eu-S1756040AbZGVFv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbZGVFv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 01:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752556AbZGVFv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 01:51:27 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:1276 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbZGVFv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 01:51:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wWpyLh22If7XJR9d3XnyJCaD4OyOrAO5HDu0uz80SCnlxdrPmcm0iI02wxlqd4LhgA
         f8auAsBcq6fhwOeRwBjjUGM3Nsu7hGukdyJ6J4330YP6za6TjtWPkagUZlNU7byLK66l
         JF2tEbRT180z9JZGN2mlXtoNrd4Cv0o99vBTI=
Date: Wed, 22 Jul 2009 13:53:38 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/4] kcore: clean up to use generic list ops
Message-ID: <20090722055338.GB6281@cr0.nay.redhat.com>
References: <20090722140613.0a751811.kamezawa.hiroyu@jp.fujitsu.com> <20090722140722.18a000ec.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090722140722.18a000ec.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 02:07:22PM +0900, KAMEZAWA Hiroyuki wrote:
>From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
>/proc/kcore uses its own list handling codes. It's better to use
>generic list codes.
>
>And read_kcore() use "m" to specifiy
>  - kcore entry
>  - vmalloc entry
>in different types.
>This patch renames "m" to "vms" for vmalloc(), avoiding confusion.
>
>No changes in logic. just clean up.


Nice cleaning!

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>


>
>Changelog v1->v2
> - no changes.
>
>Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>---
> fs/proc/kcore.c         |   41 ++++++++++++++++++++++-------------------
> include/linux/proc_fs.h |    2 +-
> 2 files changed, 23 insertions(+), 20 deletions(-)
>
>Index: mmotm-2.6.31-Jul16/fs/proc/kcore.c
>===================================================================
>--- mmotm-2.6.31-Jul16.orig/fs/proc/kcore.c
>+++ mmotm-2.6.31-Jul16/fs/proc/kcore.c
>@@ -20,6 +20,7 @@
> #include <linux/init.h>
> #include <asm/uaccess.h>
> #include <asm/io.h>
>+#include <linux/list.h>
> 
> #define CORE_STR "CORE"
> 
>@@ -57,7 +58,7 @@ struct memelfnote
> 	void *data;
> };
> 
>-static struct kcore_list *kclist;
>+static LIST_HEAD(kclist_head);
> static DEFINE_RWLOCK(kclist_lock);
> 
> void
>@@ -67,8 +68,7 @@ kclist_add(struct kcore_list *new, void 
> 	new->size = size;
> 
> 	write_lock(&kclist_lock);
>-	new->next = kclist;
>-	kclist = new;
>+	list_add_tail(&new->list, &kclist_head);
> 	write_unlock(&kclist_lock);
> }
> 
>@@ -80,7 +80,7 @@ static size_t get_kcore_size(int *nphdr,
> 	*nphdr = 1; /* PT_NOTE */
> 	size = 0;
> 
>-	for (m=kclist; m; m=m->next) {
>+	list_for_each_entry(m, &kclist_head, list) {
> 		try = kc_vaddr_to_offset((size_t)m->addr + m->size);
> 		if (try > size)
> 			size = try;
>@@ -192,7 +192,7 @@ static void elf_kcore_store_hdr(char *bu
> 	nhdr->p_align	= 0;
> 
> 	/* setup ELF PT_LOAD program header for every area */
>-	for (m=kclist; m; m=m->next) {
>+	list_for_each_entry(m, &kclist_head, list) {
> 		phdr = (struct elf_phdr *) bufp;
> 		bufp += sizeof(struct elf_phdr);
> 		offset += sizeof(struct elf_phdr);
>@@ -317,7 +317,7 @@ read_kcore(struct file *file, char __use
> 		struct kcore_list *m;
> 
> 		read_lock(&kclist_lock);
>-		for (m=kclist; m; m=m->next) {
>+		list_for_each_entry(m, &kclist_head, list) {
> 			if (start >= m->addr && start < (m->addr+m->size))
> 				break;
> 		}
>@@ -328,7 +328,7 @@ read_kcore(struct file *file, char __use
> 				return -EFAULT;
> 		} else if (is_vmalloc_addr((void *)start)) {
> 			char * elf_buf;
>-			struct vm_struct *m;
>+			struct vm_struct *vms;
> 			unsigned long curstart = start;
> 			unsigned long cursize = tsz;
> 
>@@ -337,29 +337,32 @@ read_kcore(struct file *file, char __use
> 				return -ENOMEM;
> 
> 			read_lock(&vmlist_lock);
>-			for (m=vmlist; m && cursize; m=m->next) {
>+			for (vms = vmlist; vms && cursize; vms = vms->next) {
> 				unsigned long vmstart;
> 				unsigned long vmsize;
>-				unsigned long msize = m->size - PAGE_SIZE;
>+				unsigned long msize = vms->size - PAGE_SIZE;
>+				unsigned long curend, vmend;
> 
>-				if (((unsigned long)m->addr + msize) < 
>+				if (((unsigned long)vms->addr + msize) < 
> 								curstart)
> 					continue;
>-				if ((unsigned long)m->addr > (curstart + 
>+				if ((unsigned long)vms->addr > (curstart + 
> 								cursize))
> 					break;
>-				vmstart = (curstart < (unsigned long)m->addr ? 
>-					(unsigned long)m->addr : curstart);
>-				if (((unsigned long)m->addr + msize) > 
>-							(curstart + cursize))
>-					vmsize = curstart + cursize - vmstart;
>+				if (curstart < (unsigned long)vms->addr)
>+					vmstart = (unsigned long)vms->addr;
> 				else
>-					vmsize = (unsigned long)m->addr + 
>-							msize - vmstart;
>+					vmstart = curstart;
>+				curend = curstart + cursize;
>+				vmend = (unsigned long)vms->addr + msize;
>+				if (vmend > curend)
>+					vmsize = curend - vmstart;
>+				else
>+					vmsize = vmend - vmstart;
> 				curstart = vmstart + vmsize;
> 				cursize -= vmsize;
> 				/* don't dump ioremap'd stuff! (TA) */
>-				if (m->flags & VM_IOREMAP)
>+				if (vms->flags & VM_IOREMAP)
> 					continue;
> 				memcpy(elf_buf + (vmstart - start),
> 					(char *)vmstart, vmsize);
>Index: mmotm-2.6.31-Jul16/include/linux/proc_fs.h
>===================================================================
>--- mmotm-2.6.31-Jul16.orig/include/linux/proc_fs.h
>+++ mmotm-2.6.31-Jul16/include/linux/proc_fs.h
>@@ -79,7 +79,7 @@ struct proc_dir_entry {
> };
> 
> struct kcore_list {
>-	struct kcore_list *next;
>+	struct list_head list;
> 	unsigned long addr;
> 	size_t size;
> };
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
