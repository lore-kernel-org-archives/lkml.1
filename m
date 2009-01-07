Return-Path: <linux-kernel-owner+w=401wt.eu-S1763897AbZAGXVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763897AbZAGXVc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 18:21:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758512AbZAGXVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 18:21:06 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:35532 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755754AbZAGXVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 18:21:05 -0500
X-Greylist: delayed 1176 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Jan 2009 18:21:05 EST
Date: Thu, 8 Jan 2009 02:01:44 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Nick Piggin <npiggin@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Henderson <rth@twiddle.net>, linux-kernel@vger.kernel.org
Subject: [PATCH] alpha: fix vmalloc breakage
Message-ID: <20090107230144.GA30170@jurassic.park.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On alpha, we have to map some stuff in the VMALLOC space very
early in the boot process (to make SRM console callbacks work
and so on, see arch/alpha/mm/init.c). For old VM allocator,
we just manually placed a vm_struct onto the global vmlist
and this worked for ages.
Unfortunately, the new allocator isn't aware of this, so it constantly
tries to allocate the VM space which is already in use, making vmalloc
on alpha defunct.

This patch forces KVA to import vmlist entries on init.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
---
 mm/vmalloc.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index c5db9a7..0dd9c2e 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -24,6 +24,7 @@
 #include <linux/rbtree.h>
 #include <linux/radix-tree.h>
 #include <linux/rcupdate.h>
+#include <linux/bootmem.h>
 
 #include <asm/atomic.h>
 #include <asm/uaccess.h>
@@ -984,6 +985,8 @@ EXPORT_SYMBOL(vm_map_ram);
 
 void __init vmalloc_init(void)
 {
+	struct vmap_area *va;
+	struct vm_struct *tmp;
 	int i;
 
 	for_each_possible_cpu(i) {
@@ -996,6 +999,16 @@ void __init vmalloc_init(void)
 		vbq->nr_dirty = 0;
 	}
 
+	/* Import existing vmlist entries. */
+	for (tmp = vmlist; tmp; tmp = tmp->next) {
+		va = alloc_bootmem(sizeof(struct vmap_area));
+		if (!va)
+			break;
+		va->flags = tmp->flags | VM_VM_AREA;
+		va->va_start = (unsigned long)tmp->addr;
+		va->va_end = va->va_start + tmp->size;
+		__insert_vmap_area(va);
+	}
 	vmap_initialized = true;
 }
 
