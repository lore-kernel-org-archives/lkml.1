Return-Path: <linux-kernel-owner+w=401wt.eu-S1752774AbYJVBYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774AbYJVBYo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 21:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbYJVBYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 21:24:35 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54800 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbYJVBYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 21:24:34 -0400
Date: Wed, 22 Oct 2008 10:24:04 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: [PATCH][BUGFIX] memcg: fix page_cgroup allocation
Message-Id: <20081022102404.e1f3565a.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, this is a fix to "x86 cannot boot if memcg is enabled" problem in Linus's git-tree,0
fix to "memcg: allocate all page_cgroup at boot" patch.

Thank you for all helps!
(*) I and Balbir tested this. other testers are welcome :)
-Kame
==

page_cgroup_init() is called from mem_cgroup_init(). But at this
point, we cannot call alloc_bootmem().
(and this caused panic at boot.)

This patch moves page_cgroup_init() to init/main.c.

Time table is following:
==
  parse_args(). # we can trust mem_cgroup_subsys.disabled bit after this.
  ....
  cgroup_init_early()  # "early" init of cgroup.
  ....
  setup_arch()         # memmap is allocated.
  ...
  page_cgroup_init();
  mem_init();   # we cannot call alloc_bootmem after this.
  ....
  cgroup_init() # mem_cgroup is initialized.
==

Before page_cgroup_init(), mem_map must be initialized. So, 
I added page_cgroup_init() to init/main.c directly.

(*) maybe this is not very clean but
    - cgroup_init_early() is too early
    - in cgroup_init(), we have to use vmalloc instead of alloc_bootmem().
    use of vmalloc area in x86-32 is important and we should avoid very large
    vmalloc() in x86-32. So, we want to use alloc_bootmem() and added page_cgroup_init()
    directly to init/main.c

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Tested-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

 init/main.c      |    2 ++
 mm/memcontrol.c  |    1 -
 mm/page_cgroup.c |   35 ++++++++++++++++++++++++++++-------
 3 files changed, 30 insertions(+), 8 deletions(-)

Index: linux-2.6/init/main.c
===================================================================
--- linux-2.6.orig/init/main.c
+++ linux-2.6/init/main.c
@@ -62,6 +62,7 @@
 #include <linux/signal.h>
 #include <linux/idr.h>
 #include <linux/ftrace.h>
+#include <linux/page_cgroup.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -647,6 +648,7 @@ asmlinkage void __init start_kernel(void
 	vmalloc_init();
 	vfs_caches_init_early();
 	cpuset_init_early();
+	page_cgroup_init();
 	mem_init();
 	enable_debug_pagealloc();
 	cpu_hotplug_init();
Index: linux-2.6/mm/memcontrol.c
===================================================================
--- linux-2.6.orig/mm/memcontrol.c
+++ linux-2.6/mm/memcontrol.c
@@ -1088,7 +1088,6 @@ mem_cgroup_create(struct cgroup_subsys *
 	int node;
 
 	if (unlikely((cont->parent) == NULL)) {
-		page_cgroup_init();
 		mem = &init_mem_cgroup;
 	} else {
 		mem = mem_cgroup_alloc();
Index: linux-2.6/mm/page_cgroup.c
===================================================================
--- linux-2.6.orig/mm/page_cgroup.c
+++ linux-2.6/mm/page_cgroup.c
@@ -4,7 +4,12 @@
 #include <linux/bit_spinlock.h>
 #include <linux/page_cgroup.h>
 #include <linux/hash.h>
+#include <linux/slab.h>
 #include <linux/memory.h>
+#include <linux/cgroup.h>
+
+extern struct cgroup_subsys	mem_cgroup_subsys;
+
 
 static void __meminit
 __init_page_cgroup(struct page_cgroup *pc, unsigned long pfn)
@@ -66,6 +71,9 @@ void __init page_cgroup_init(void)
 
 	int nid, fail;
 
+	if (mem_cgroup_subsys.disabled)
+		return;
+
 	for_each_online_node(nid)  {
 		fail = alloc_node_page_cgroup(nid);
 		if (fail)
@@ -106,9 +114,14 @@ int __meminit init_section_page_cgroup(u
 	nid = page_to_nid(pfn_to_page(pfn));
 
 	table_size = sizeof(struct page_cgroup) * PAGES_PER_SECTION;
-	base = kmalloc_node(table_size, GFP_KERNEL, nid);
-	if (!base)
-		base = vmalloc_node(table_size, nid);
+	if (slab_is_available()) {
+		base = kmalloc_node(table_size, GFP_KERNEL, nid);
+		if (!base)
+			base = vmalloc_node(table_size, nid);
+	} else {
+		base = __alloc_bootmem_node_nopanic(NODE_DATA(nid), table_size,
+				PAGE_SIZE, __pa(MAX_DMA_ADDRESS));
+	}
 
 	if (!base) {
 		printk(KERN_ERR "page cgroup allocation failure\n");
@@ -135,11 +148,16 @@ void __free_page_cgroup(unsigned long pf
 	if (!ms || !ms->page_cgroup)
 		return;
 	base = ms->page_cgroup + pfn;
-	ms->page_cgroup = NULL;
-	if (is_vmalloc_addr(base))
+	if (is_vmalloc_addr(base)) {
 		vfree(base);
-	else
-		kfree(base);
+		ms->page_cgroup = NULL;
+	} else {
+		struct page *page = virt_to_page(base);
+		if (!PageReserved(page)) { /* Is bootmem ? */
+			kfree(base);
+			ms->page_cgroup = NULL;
+		}
+	}
 }
 
 int online_page_cgroup(unsigned long start_pfn,
@@ -213,6 +231,9 @@ void __init page_cgroup_init(void)
 	unsigned long pfn;
 	int fail = 0;
 
+	if (mem_cgroup_subsys.disabled)
+		return;
+
 	for (pfn = 0; !fail && pfn < max_pfn; pfn += PAGES_PER_SECTION) {
 		if (!pfn_present(pfn))
 			continue;

