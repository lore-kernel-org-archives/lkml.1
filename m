Return-Path: <linux-kernel-owner+w=401wt.eu-S1751558AbZHaKDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558AbZHaKDr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 06:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751041AbZHaKDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 06:03:46 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40176 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbZHaKDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 06:03:45 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 31 Aug 2009 19:01:51 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       benh@kernel.crashing.org, ralf@linux-mips.org, xiyou.wangcong@gmail.com,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       jirislaby@gmail.com
Subject: [PATCH 1/8][mmotm] kcore use usual list for kclist
Message-Id: <20090831190151.48a067c1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090831190024.fadc3b50.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090831190024.fadc3b50.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

This patchset is for /proc/kcore.  With this,

 - many per-arch hooks are removed.

 - /proc/kcore will know really valid physical memory area.

 - /proc/kcore will be aware of memory hotplug.

 - /proc/kcore will be architecture independent i.e.
   if an arch supports CONFIG_MMU, it can use /proc/kcore.
   (if the arch uses usual memory layout.)



This patch:

/proc/kcore uses its own list handling codes. It's better to use
generic list codes.

No changes in logic. just clean up.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c         |   12 ++++++------
 include/linux/proc_fs.h |    2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

Index: mmotm-2.6.31-Aug27/fs/proc/kcore.c
===================================================================
--- mmotm-2.6.31-Aug27.orig/fs/proc/kcore.c
+++ mmotm-2.6.31-Aug27/fs/proc/kcore.c
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
Index: mmotm-2.6.31-Aug27/include/linux/proc_fs.h
===================================================================
--- mmotm-2.6.31-Aug27.orig/include/linux/proc_fs.h
+++ mmotm-2.6.31-Aug27/include/linux/proc_fs.h
@@ -79,7 +79,7 @@ struct proc_dir_entry {
 };
 
 struct kcore_list {
-	struct kcore_list *next;
+	struct list_head list;
 	unsigned long addr;
 	size_t size;
 };

