Return-Path: <linux-kernel-owner+w=401wt.eu-S1755196AbZGUKat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbZGUKat (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 06:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755191AbZGUK2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 06:28:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:37017 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755085AbZGUK14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 06:27:56 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
       benh@kernel.crashing.org, davem@davemloft.net, dhowells@redhat.com,
       npiggin@suse.de, JBeulich@novell.com, cl@linux-foundation.org,
       rusty@rustcorp.com.au, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, x86@kernel.org, andi@firstfloor.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 13/20] vmalloc: separate out insert_vmalloc_vm()
Date: Tue, 21 Jul 2009 19:26:12 +0900
Message-Id: <1248171979-29166-14-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1248171979-29166-1-git-send-email-tj@kernel.org>
References: <1248171979-29166-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 21 Jul 2009 10:26:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate out insert_vmalloc_vm() from __get_vm_area_node().
insert_vmalloc_vm() initializes vm_struct from vmap_area and inserts
it into vmlist.  insert_vmalloc_vm() only initializes fields which can
be determined from @vm, @flags and @caller The rest should be
initialized by the caller.  For __get_vm_area_node(), all other fields
just need to be cleared and this is done by using kzalloc instead of
kmalloc.

This will be used to implement pcpu_get_vm_areas().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Nick Piggin <npiggin@suse.de>
---
 mm/vmalloc.c |   45 ++++++++++++++++++++++++---------------------
 1 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index f8189a4..2eb461c 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1122,13 +1122,34 @@ EXPORT_SYMBOL_GPL(map_vm_area);
 DEFINE_RWLOCK(vmlist_lock);
 struct vm_struct *vmlist;
 
+static void insert_vmalloc_vm(struct vm_struct *vm, struct vmap_area *va,
+			      unsigned long flags, void *caller)
+{
+	struct vm_struct *tmp, **p;
+
+	vm->flags = flags;
+	vm->addr = (void *)va->va_start;
+	vm->size = va->va_end - va->va_start;
+	vm->caller = caller;
+	va->private = vm;
+	va->flags |= VM_VM_AREA;
+
+	write_lock(&vmlist_lock);
+	for (p = &vmlist; (tmp = *p) != NULL; p = &tmp->next) {
+		if (tmp->addr >= vm->addr)
+			break;
+	}
+	vm->next = *p;
+	*p = vm;
+	write_unlock(&vmlist_lock);
+}
+
 static struct vm_struct *__get_vm_area_node(unsigned long size,
 		unsigned long flags, unsigned long start, unsigned long end,
 		int node, gfp_t gfp_mask, void *caller)
 {
 	static struct vmap_area *va;
 	struct vm_struct *area;
-	struct vm_struct *tmp, **p;
 	unsigned long align = 1;
 
 	BUG_ON(in_interrupt());
@@ -1147,7 +1168,7 @@ static struct vm_struct *__get_vm_area_node(unsigned long size,
 	if (unlikely(!size))
 		return NULL;
 
-	area = kmalloc_node(sizeof(*area), gfp_mask & GFP_RECLAIM_MASK, node);
+	area = kzalloc_node(sizeof(*area), gfp_mask & GFP_RECLAIM_MASK, node);
 	if (unlikely(!area))
 		return NULL;
 
@@ -1162,25 +1183,7 @@ static struct vm_struct *__get_vm_area_node(unsigned long size,
 		return NULL;
 	}
 
-	area->flags = flags;
-	area->addr = (void *)va->va_start;
-	area->size = size;
-	area->pages = NULL;
-	area->nr_pages = 0;
-	area->phys_addr = 0;
-	area->caller = caller;
-	va->private = area;
-	va->flags |= VM_VM_AREA;
-
-	write_lock(&vmlist_lock);
-	for (p = &vmlist; (tmp = *p) != NULL; p = &tmp->next) {
-		if (tmp->addr >= area->addr)
-			break;
-	}
-	area->next = *p;
-	*p = area;
-	write_unlock(&vmlist_lock);
-
+	insert_vmalloc_vm(area, va, flags, caller);
 	return area;
 }
 
-- 
1.6.0.2

