Return-Path: <linux-kernel-owner+w=401wt.eu-S1751963AbZHaKLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963AbZHaKLm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 06:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751507AbZHaKLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 06:11:41 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41453 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbZHaKLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 06:11:39 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 31 Aug 2009 19:09:44 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       benh@kernel.crashing.org, ralf@linux-mips.org, xiyou.wangcong@gmail.com,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       jirislaby@gmail.com
Subject: [PATCH 7/8][mmotm] kcore register vmemmap range
Message-Id: <20090831190944.0104d5a7.kamezawa.hiroyu@jp.fujitsu.com>
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

This new patch is for enhancement.
=
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Benjamin Herrenschmidt <benh@kernel.crashing.org> pointed out that
vmemmap range is not included in KCORE_RAM, KCORE_VMALLOC ....

This adds KCORE_VMEMMAP if SPARSEMEM_VMEMMAP is used.
By this, vmemmap can be readable via /proc/kcore

Because it's not vmalloc area, vread/vwrite cannot be used.
But the range is static against the memory layout, this patch
handles vmemmap area by the same scheme with physical memory.

This patch assumes SPARSEMEM_VMEMMAP range is not in VMALLOC range.
It's correct now.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 fs/proc/kcore.c         |   52 ++++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/proc_fs.h |    1 
 2 files changed, 51 insertions(+), 2 deletions(-)

Index: mmotm-2.6.31-Aug27/fs/proc/kcore.c
===================================================================
--- mmotm-2.6.31-Aug27.orig/fs/proc/kcore.c
+++ mmotm-2.6.31-Aug27/fs/proc/kcore.c
@@ -103,7 +103,7 @@ static void free_kclist_ents(struct list
 	}
 }
 /*
- * Replace all KCORE_RAM information with passed list.
+ * Replace all KCORE_RAM/KCORE_VMEMMAP information with passed list.
  */
 static void __kcore_update_ram(struct list_head *list)
 {
@@ -113,7 +113,8 @@ static void __kcore_update_ram(struct li
 	write_lock(&kclist_lock);
 	if (kcore_need_update) {
 		list_for_each_entry_safe(pos, tmp, &kclist_head, list) {
-			if (pos->type == KCORE_RAM)
+			if (pos->type == KCORE_RAM
+				|| pos->type == KCORE_VMEMMAP)
 				list_move(&pos->list, &garbage);
 		}
 		list_splice_tail(list, &kclist_head);
@@ -151,6 +152,47 @@ static int kcore_update_ram(void)
 
 #else /* !CONFIG_HIGHMEM */
 
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+/* calculate vmemmap's address from given system ram pfn and register it */
+int get_sparsemem_vmemmap_info(struct kcore_list *ent, struct list_head *head)
+{
+	unsigned long pfn = __pa(ent->addr) >> PAGE_SHIFT;
+	unsigned long nr_pages = ent->size >> PAGE_SHIFT;
+	unsigned long start, end;
+	struct kcore_list *vmm, *tmp;
+
+
+	start = ((unsigned long)pfn_to_page(pfn)) & PAGE_MASK;
+	end = ((unsigned long)pfn_to_page(pfn + nr_pages)) - 1;
+	end = ALIGN(end, PAGE_SIZE);
+	/* overlap check (because we have to align page */
+	list_for_each_entry(tmp, head, list) {
+		if (tmp->type != KCORE_VMEMMAP)
+			continue;
+		if (start < tmp->addr + tmp->size)
+			if (end > tmp->addr)
+				end = tmp->addr;
+	}
+	if (start < end) {
+		vmm = kmalloc(sizeof(*vmm), GFP_KERNEL);
+		if (!vmm)
+			return 0;
+		vmm->addr = start;
+		vmm->size = end - start;
+		vmm->type = KCORE_VMEMMAP;
+		list_add_tail(&vmm->list, head);
+	}
+	return 1;
+
+}
+#else
+int get_sparsemem_vmemamp_info(struct kcore_list *ent, struct list_head *head)
+{
+	return 1;
+}
+
+#endif
+
 static int
 kclist_add_private(unsigned long pfn, unsigned long nr_pages, void *arg)
 {
@@ -181,6 +223,12 @@ kclist_add_private(unsigned long pfn, un
 
 	ent->type = KCORE_RAM;
 	list_add_tail(&ent->list, head);
+
+	if (!get_sparsemem_vmemmap_info(ent, head)) {
+		list_del(&ent->list);
+		goto free_out;
+	}
+
 	return 0;
 free_out:
 	kfree(ent);
Index: mmotm-2.6.31-Aug27/include/linux/proc_fs.h
===================================================================
--- mmotm-2.6.31-Aug27.orig/include/linux/proc_fs.h
+++ mmotm-2.6.31-Aug27/include/linux/proc_fs.h
@@ -82,6 +82,7 @@ enum kcore_type {
 	KCORE_TEXT,
 	KCORE_VMALLOC,
 	KCORE_RAM,
+	KCORE_VMEMMAP,
 	KCORE_OTHER,
 };
 

