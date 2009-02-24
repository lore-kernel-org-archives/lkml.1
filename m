Return-Path: <linux-kernel-owner+w=401wt.eu-S1755663AbZBXDNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663AbZBXDNd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 22:13:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756577AbZBXDMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 22:12:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:58420 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756358AbZBXDMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 22:12:51 -0500
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, nickpiggin@yahoo.com.au, ink@jurassic.park.msu.ru
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/10] vmalloc: add @align to vm_area_register_early()
Date: Tue, 24 Feb 2009 12:11:35 +0900
Message-Id: <1235445101-7882-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1235445101-7882-1-git-send-email-tj@kernel.org>
References: <1235445101-7882-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Feb 2009 03:11:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: allow larger alignment for early vmalloc area allocation

Some early vmalloc users might want larger alignment, for example, for
custom large page mapping.  Add @align to vm_area_register_early().
While at it, drop docbook comment on non-existent @size.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
---
 arch/alpha/mm/init.c    |    2 +-
 include/linux/vmalloc.h |    2 +-
 mm/percpu.c             |    2 +-
 mm/vmalloc.c            |   11 +++++++----
 4 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/alpha/mm/init.c b/arch/alpha/mm/init.c
index df6df02..91eddd8 100644
--- a/arch/alpha/mm/init.c
+++ b/arch/alpha/mm/init.c
@@ -200,7 +200,7 @@ callback_init(void * kernel_end)
 		/* register the vm area */
 		console_remap_vm.flags = VM_ALLOC;
 		console_remap_vm.size = nr_pages << PAGE_SHIFT;
-		vm_area_register_early(&console_remap_vm);
+		vm_area_register_early(&console_remap_vm, PAGE_SIZE);
 
 		vaddr = (unsigned long)consle_remap_vm.addr;
 
diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 599ba79..2f6994f 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -109,6 +109,6 @@ extern long vwrite(char *buf, char *addr, unsigned long count);
  */
 extern rwlock_t vmlist_lock;
 extern struct vm_struct *vmlist;
-extern __init void vm_area_register_early(struct vm_struct *vm);
+extern __init void vm_area_register_early(struct vm_struct *vm, size_t align);
 
 #endif /* _LINUX_VMALLOC_H */
diff --git a/mm/percpu.c b/mm/percpu.c
index ed92caa..41e7a5f 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -860,7 +860,7 @@ size_t __init pcpu_setup_static(pcpu_populate_pte_fn_t populate_pte_fn,
 	/* init and register vm area */
 	static_vm.flags = VM_ALLOC;
 	static_vm.size = pcpu_chunk_size;
-	vm_area_register_early(&static_vm);
+	vm_area_register_early(&static_vm, PAGE_SIZE);
 
 	/* init static_chunk */
 	static_chunk = alloc_bootmem(pcpu_chunk_struct_size);
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 224eca9..366ae9e 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -995,7 +995,7 @@ EXPORT_SYMBOL(vm_map_ram);
 /**
  * vm_area_register_early - register vmap area early during boot
  * @vm: vm_struct to register
- * @size: size of area to register
+ * @align: requested alignment
  *
  * This function is used to register kernel vm area before
  * vmalloc_init() is called.  @vm->size and @vm->flags should contain
@@ -1004,12 +1004,15 @@ EXPORT_SYMBOL(vm_map_ram);
  *
  * DO NOT USE THIS FUNCTION UNLESS YOU KNOW WHAT YOU'RE DOING.
  */
-void __init vm_area_register_early(struct vm_struct *vm)
+void __init vm_area_register_early(struct vm_struct *vm, size_t align)
 {
 	static size_t vm_init_off __initdata;
+	unsigned long addr;
+
+	addr = ALIGN(VMALLOC_START + vm_init_off, align);
+	vm_init_off = PFN_ALIGN(addr + vm->size) - VMALLOC_START;
 
-	vm->addr = (void *)VMALLOC_START + vm_init_off;
-	vm_init_off = PFN_ALIGN(vm_init_off + vm->size);
+	vm->addr = (void *)addr;
 
 	vm->next = vmlist;
 	vmlist = vm;
-- 
1.6.0.2

