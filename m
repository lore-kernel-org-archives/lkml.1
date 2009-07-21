Return-Path: <linux-kernel-owner+w=401wt.eu-S1754217AbZGUJjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbZGUJjw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 05:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754002AbZGUJjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 05:39:51 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49227 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985AbZGUJju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 05:39:50 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 21 Jul 2009 18:38:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, ebiederm@xmission.com,
       xiyou.wangcong@gmail.com, tao.ma@oracle.com,
       linux-kernel@vger.kernel.org, adobriyan@gmail.com,
       mtk.manpages@gmail.com, y-goto@jp.fujitsu.com
Subject: [RFC][PATCH 1/3] kcore: use usual list ops in kclist
Message-Id: <20090721183802.91b2c832.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090721183628.edbb7b99.kamezawa.hiroyu@jp.fujitsu.com>
References: <m11vpqvozl.fsf@fess.ebiederm.org>
	<20090613040958.GA2959@cr0>
	<m17hzdhkr8.fsf@fess.ebiederm.org>
	<2375c9f90906160829g3d605836yb4c5b9beeac50c5f@mail.gmail.com>
	<m1my88568n.fsf@fess.ebiederm.org>
	<20090618030051.GA6133@cr0.nay.redhat.com>
	<m1tz2ei54r.fsf@fess.ebiederm.org>
	<20090618044055.GB6133@cr0.nay.redhat.com>
	<m1prd2rtdf.fsf@fess.ebiederm.org>
	<20090622085405.GA6499@cr0.nay.redhat.com>
	<20090630100850.GD5873@cr0.nay.redhat.com>
	<20090701144742.6ce3535b.akpm@linux-foundation.org>
	<m14otwq94e.fsf@fess.ebiederm.org>
	<20090701171249.004968e8.akpm@linux-foundation.org>
	<20090702094138.f86ead92.kamezawa.hiroyu@jp.fujitsu.com>
	<20090717152955.6585cbf9.akpm@linux-foundation.org>
	<20090721183628.edbb7b99.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

/proc/kcore uses its own list handling codes. But it's better to use
generic list codes.

And read_kcore() use "m" to specifiy
  - kcore entry
  - vmalloc entry
both in different types.
This patch renames "m" to "vms" for vmalloc(), avoiding confusion.

No changes in logic. just clean up.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 fs/proc/kcore.c         |   41 ++++++++++++++++++++++-------------------
 include/linux/proc_fs.h |    2 +-
 2 files changed, 23 insertions(+), 20 deletions(-)

Index: mmotm-2.6.31-Jul16/fs/proc/kcore.c
===================================================================
--- mmotm-2.6.31-Jul16.orig/fs/proc/kcore.c
+++ mmotm-2.6.31-Jul16/fs/proc/kcore.c
@@ -20,6 +20,7 @@
 #include <linux/init.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
+#include <linux/list.h>
 
 #define CORE_STR "CORE"
 
@@ -57,7 +58,7 @@ struct memelfnote
 	void *data;
 };
 
-static struct kcore_list *kclist;
+static LIST_HEAD(kclist_head);
 static DEFINE_RWLOCK(kclist_lock);
 
 void
@@ -67,8 +68,7 @@ kclist_add(struct kcore_list *new, void 
 	new->size = size;
 
 	write_lock(&kclist_lock);
-	new->next = kclist;
-	kclist = new;
+	list_add_tail(&new->list, &kclist_head);
 	write_unlock(&kclist_lock);
 }
 
@@ -80,7 +80,7 @@ static size_t get_kcore_size(int *nphdr,
 	*nphdr = 1; /* PT_NOTE */
 	size = 0;
 
-	for (m=kclist; m; m=m->next) {
+	list_for_each_entry(m, &kclist_head, list) {
 		try = kc_vaddr_to_offset((size_t)m->addr + m->size);
 		if (try > size)
 			size = try;
@@ -192,7 +192,7 @@ static void elf_kcore_store_hdr(char *bu
 	nhdr->p_align	= 0;
 
 	/* setup ELF PT_LOAD program header for every area */
-	for (m=kclist; m; m=m->next) {
+	list_for_each_entry(m, &kclist_head, list) {
 		phdr = (struct elf_phdr *) bufp;
 		bufp += sizeof(struct elf_phdr);
 		offset += sizeof(struct elf_phdr);
@@ -317,7 +317,7 @@ read_kcore(struct file *file, char __use
 		struct kcore_list *m;
 
 		read_lock(&kclist_lock);
-		for (m=kclist; m; m=m->next) {
+		list_for_each_entry(m, &kclist_head, list) {
 			if (start >= m->addr && start < (m->addr+m->size))
 				break;
 		}
@@ -328,7 +328,7 @@ read_kcore(struct file *file, char __use
 				return -EFAULT;
 		} else if (is_vmalloc_addr((void *)start)) {
 			char * elf_buf;
-			struct vm_struct *m;
+			struct vm_struct *vms;
 			unsigned long curstart = start;
 			unsigned long cursize = tsz;
 
@@ -337,29 +337,32 @@ read_kcore(struct file *file, char __use
 				return -ENOMEM;
 
 			read_lock(&vmlist_lock);
-			for (m=vmlist; m && cursize; m=m->next) {
+			for (vms = vmlist; vms && cursize; vms = vms->next) {
 				unsigned long vmstart;
 				unsigned long vmsize;
-				unsigned long msize = m->size - PAGE_SIZE;
+				unsigned long msize = vms->size - PAGE_SIZE;
+				unsigned long curend, vmend;
 
-				if (((unsigned long)m->addr + msize) < 
+				if (((unsigned long)vms->addr + msize) < 
 								curstart)
 					continue;
-				if ((unsigned long)m->addr > (curstart + 
+				if ((unsigned long)vms->addr > (curstart + 
 								cursize))
 					break;
-				vmstart = (curstart < (unsigned long)m->addr ? 
-					(unsigned long)m->addr : curstart);
-				if (((unsigned long)m->addr + msize) > 
-							(curstart + cursize))
-					vmsize = curstart + cursize - vmstart;
+				if (curstart < (unsigned long)vms->addr)
+					vmstart = (unsigned long)vms->addr;
 				else
-					vmsize = (unsigned long)m->addr + 
-							msize - vmstart;
+					vmstart = curstart;
+				curend = curstart + cursize;
+				vmend = (unsigned long)vms->addr + msize;
+				if (vmend > curend)
+					vmsize = curend - vmstart;
+				else
+					vmsize = vmend - vmstart;
 				curstart = vmstart + vmsize;
 				cursize -= vmsize;
 				/* don't dump ioremap'd stuff! (TA) */
-				if (m->flags & VM_IOREMAP)
+				if (vms->flags & VM_IOREMAP)
 					continue;
 				memcpy(elf_buf + (vmstart - start),
 					(char *)vmstart, vmsize);
Index: mmotm-2.6.31-Jul16/include/linux/proc_fs.h
===================================================================
--- mmotm-2.6.31-Jul16.orig/include/linux/proc_fs.h
+++ mmotm-2.6.31-Jul16/include/linux/proc_fs.h
@@ -79,7 +79,7 @@ struct proc_dir_entry {
 };
 
 struct kcore_list {
-	struct kcore_list *next;
+	struct list_head list;
 	unsigned long addr;
 	size_t size;
 };

