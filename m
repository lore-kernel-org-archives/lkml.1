Return-Path: <linux-kernel-owner+w=401wt.eu-S1759229AbZAHMzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759229AbZAHMzc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 07:55:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755327AbZAHMzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 07:55:17 -0500
Received: from mx2.redhat.com ([66.187.237.31]:40729 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653AbZAHMzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 07:55:15 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 02/10] NOMMU: Rename ARM's struct vm_region [ver #3]
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: bernds_cb1@t-online.de, dhowells@redhat.com, rgetz@blackfin.uclinux.org,
       vapier.adi@gmail.com, lethal@linux-sh.org, linux-kernel@vger.kernel.org
Date: Thu, 08 Jan 2009 12:53:56 +0000
Message-ID: <20090108125356.28454.55227.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090108125346.28454.90871.stgit@warthog.procyon.org.uk>
References: <20090108125346.28454.90871.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename ARM's struct vm_region so that I can introduce my own global version
for NOMMU.  It's feasible that the ARM version may wish to use my global one
instead.

The NOMMU vm_region struct defines areas of the physical memory map that are
under mmap.  This may include chunks of RAM or regions of memory mapped
devices, such as flash.  It is also used to retain copies of file content so
that shareable private memory mappings of files can be made.  As such, it may
be compatible with what is described in the banner comment for ARM's vm_region
struct.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/arm/mm/dma-mapping.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)


diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 6796001..310e479 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -71,7 +71,7 @@ static DEFINE_SPINLOCK(consistent_lock);
  * the amount of RAM found at boot time.)  I would imagine that get_vm_area()
  * would have to initialise this each time prior to calling vm_region_alloc().
  */
-struct vm_region {
+struct arm_vm_region {
 	struct list_head	vm_list;
 	unsigned long		vm_start;
 	unsigned long		vm_end;
@@ -79,20 +79,20 @@ struct vm_region {
 	int			vm_active;
 };
 
-static struct vm_region consistent_head = {
+static struct arm_vm_region consistent_head = {
 	.vm_list	= LIST_HEAD_INIT(consistent_head.vm_list),
 	.vm_start	= CONSISTENT_BASE,
 	.vm_end		= CONSISTENT_END,
 };
 
-static struct vm_region *
-vm_region_alloc(struct vm_region *head, size_t size, gfp_t gfp)
+static struct arm_vm_region *
+arm_vm_region_alloc(struct arm_vm_region *head, size_t size, gfp_t gfp)
 {
 	unsigned long addr = head->vm_start, end = head->vm_end - size;
 	unsigned long flags;
-	struct vm_region *c, *new;
+	struct arm_vm_region *c, *new;
 
-	new = kmalloc(sizeof(struct vm_region), gfp);
+	new = kmalloc(sizeof(struct arm_vm_region), gfp);
 	if (!new)
 		goto out;
 
@@ -127,9 +127,9 @@ vm_region_alloc(struct vm_region *head, size_t size, gfp_t gfp)
 	return NULL;
 }
 
-static struct vm_region *vm_region_find(struct vm_region *head, unsigned long addr)
+static struct arm_vm_region *arm_vm_region_find(struct arm_vm_region *head, unsigned long addr)
 {
-	struct vm_region *c;
+	struct arm_vm_region *c;
 	
 	list_for_each_entry(c, &head->vm_list, vm_list) {
 		if (c->vm_active && c->vm_start == addr)
@@ -149,7 +149,7 @@ __dma_alloc(struct device *dev, size_t size, dma_addr_t *handle, gfp_t gfp,
 	    pgprot_t prot)
 {
 	struct page *page;
-	struct vm_region *c;
+	struct arm_vm_region *c;
 	unsigned long order;
 	u64 mask = ISA_DMA_THRESHOLD, limit;
 
@@ -214,7 +214,7 @@ __dma_alloc(struct device *dev, size_t size, dma_addr_t *handle, gfp_t gfp,
 	/*
 	 * Allocate a virtual address in the consistent mapping region.
 	 */
-	c = vm_region_alloc(&consistent_head, size,
+	c = arm_vm_region_alloc(&consistent_head, size,
 			    gfp & ~(__GFP_DMA | __GFP_HIGHMEM));
 	if (c) {
 		pte_t *pte;
@@ -311,13 +311,13 @@ static int dma_mmap(struct device *dev, struct vm_area_struct *vma,
 		    void *cpu_addr, dma_addr_t dma_addr, size_t size)
 {
 	unsigned long flags, user_size, kern_size;
-	struct vm_region *c;
+	struct arm_vm_region *c;
 	int ret = -ENXIO;
 
 	user_size = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
 
 	spin_lock_irqsave(&consistent_lock, flags);
-	c = vm_region_find(&consistent_head, (unsigned long)cpu_addr);
+	c = arm_vm_region_find(&consistent_head, (unsigned long)cpu_addr);
 	spin_unlock_irqrestore(&consistent_lock, flags);
 
 	if (c) {
@@ -359,7 +359,7 @@ EXPORT_SYMBOL(dma_mmap_writecombine);
  */
 void dma_free_coherent(struct device *dev, size_t size, void *cpu_addr, dma_addr_t handle)
 {
-	struct vm_region *c;
+	struct arm_vm_region *c;
 	unsigned long flags, addr;
 	pte_t *ptep;
 	int idx;
@@ -378,7 +378,7 @@ void dma_free_coherent(struct device *dev, size_t size, void *cpu_addr, dma_addr
 	size = PAGE_ALIGN(size);
 
 	spin_lock_irqsave(&consistent_lock, flags);
-	c = vm_region_find(&consistent_head, (unsigned long)cpu_addr);
+	c = arm_vm_region_find(&consistent_head, (unsigned long)cpu_addr);
 	if (!c)
 		goto no_area;
 

