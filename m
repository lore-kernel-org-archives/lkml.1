Return-Path: <linux-kernel-owner+w=401wt.eu-S966055AbXDKCma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966055AbXDKCma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 22:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966095AbXDKCma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 22:42:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:5581 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966055AbXDKCm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 22:42:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,392,1170662400"; 
   d="scan'208"; a="228146618:sNHT27917589"
Date: Wed, 11 Apr 2007 10:40:21 +0800
From: Wang Zhenyu <zhenyu.z.wang@intel.com>
To: Andi Kleen <ak@suse.de>, Dave Jones <davej@redhat.com>
Cc: David Miller <davem@davemloft.net>, hch@infradead.org, ashok.raj@intel.com,
       linux-kernel@vger.kernel.org, akpm@osdl.org, gregkh@suse.de,
       muli@il.ibm.com, asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com,
       shaohua.li@intel.com
Subject: Re: [patch 5/8] [Intel IOMMU] Graphics driver workarounds to provide unity map
Message-ID: <20070411024021.GA5897@zhen-devel.sh.intel.com>
Mail-Followup-To: Andi Kleen <ak@suse.de>, Dave Jones <davej@redhat.com>,
	David Miller <davem@davemloft.net>, hch@infradead.org,
	ashok.raj@intel.com, linux-kernel@vger.kernel.org, akpm@osdl.org,
	gregkh@suse.de, muli@il.ibm.com, asit.k.mallick@intel.com,
	suresh.b.siddha@intel.com, anil.s.keshavamurthy@intel.com,
	arjan@linux.intel.com, shaohua.li@intel.com
References: <20070409215552.221374000@intel.com> <20070410083351.GA19691@infradead.org> <20070410.020702.88477115.davem@davemloft.net> <200704101112.17869.ak@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="fUYQa+Pmc3FrFX/N"
Content-Disposition: inline
In-Reply-To: <200704101112.17869.ak@suse.de>
User-Agent: Mutt/1.4.2.1i
X-Mailer: mutt
X-Operating-System: Linux 2.6.15-1.2054_FC5smp i686
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2007.04.10 11:12:17 +0000, Andi Kleen wrote:
> > > On Mon, Apr 09, 2007 at 02:55:57PM -0700, Ashok Raj wrote:
> > > > Most GFX drivers don't call standard PCI DMA APIs to allocate DMA buffer,
> > > > Such drivers will be broken with IOMMU enabled. To workaround this issue, 
> > > > we added two options.
> > > 
> > > All drm drivers do it.  If the usual out of tree crap vendors are too
> > > stupid for their own sake it's their fault.
> > > 
> > > So NACK to this patch.
> > 
> > That's my feeling as well, everything we care about should be using
> > the proper APIs or else what is the point of them...
> 
> They can't. There is no proper API to do IOMMU mappings from user space.
> And that is how Xorg on x86 works.
> 
> I had some hackish patches to enable mapping on /sys/bus/pci/.../coherent_mem, but
> you need ioctls to pass out the translated address and it wasn't
> exactly pretty. Still also not sure that's the right way.
> 

For agpgart based gfx driver, we need to enable dma mapping on agpgart module, 
which would work in the IOMMU case. I attach my current patches to do this.
Dave, how do you think about it?


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="agpgart_dma_mapping.patch"

diff --git a/drivers/char/agp/agp.h b/drivers/char/agp/agp.h
index 552815d..0d3312d 100644
--- a/drivers/char/agp/agp.h
+++ b/drivers/char/agp/agp.h
@@ -115,6 +115,9 @@ struct agp_bridge_driver {
 	void *(*agp_alloc_page)(struct agp_bridge_data *);
 	void (*agp_destroy_page)(void *);
         int (*agp_type_to_mask_type) (struct agp_bridge_data *, int);
+	int (*agp_map_dma_pages)(struct agp_bridge_data *, struct agp_memory*);
+	void (*agp_unmap_dma_pages)(struct agp_bridge_data *, 
+			struct agp_memory *);
 };
 
 struct agp_bridge_data {
diff --git a/drivers/char/agp/generic.c b/drivers/char/agp/generic.c
index f902d71..03a001a 100644
--- a/drivers/char/agp/generic.c
+++ b/drivers/char/agp/generic.c
@@ -112,22 +112,34 @@ void agp_alloc_page_array(size_t size, s
 	mem->memory = NULL;
 	mem->vmalloc_flag = 0;
 
-	if (size <= 2*PAGE_SIZE)
+	if (size <= 2*PAGE_SIZE) {
 		mem->memory = kmalloc(size, GFP_KERNEL | __GFP_NORETRY);
+		mem->dma_memory = kmalloc(size, GFP_KERNEL | __GFP_NORETRY);
+	}
 	if (mem->memory == NULL) {
 		mem->memory = vmalloc(size);
-		mem->vmalloc_flag = 1;
+		mem->vmalloc_flag = AGP_MEMORY_VMALLOC;
+	}
+	if (mem->dma_memory == NULL) {
+		mem->dma_memory = vmalloc(size);
+		/* XXX this is a little overdo */
+		mem->vmalloc_flag |= AGP_DMA_MEMORY_VMALLOC;
 	}
 }
 EXPORT_SYMBOL(agp_alloc_page_array);
 
 void agp_free_page_array(struct agp_memory *mem)
 {
-	if (mem->vmalloc_flag) {
+	if (mem->vmalloc_flag & AGP_MEMORY_VMALLOC) {
 		vfree(mem->memory);
 	} else {
 		kfree(mem->memory);
 	}
+	if (mem->vmalloc_flag & AGP_DMA_MEMORY_VMALLOC) {
+		vfree(mem->dma_memory);
+	} else {
+		kfree(mem->dma_memory);
+	}
 }
 EXPORT_SYMBOL(agp_free_page_array);
 
@@ -155,6 +167,15 @@ static struct agp_memory *agp_create_use
 		kfree(new);
 		return NULL;
 	}
+	if (new->dma_memory == NULL) {
+		agp_free_key(new->key);
+		if (new->vmalloc_flag)
+			vfree(new->memory);
+		else
+			kfree(new->memory);
+		kfree(new);
+		return NULL;
+	}
 	new->num_scratch_pages = 0;
 	return new;
 }
@@ -181,6 +202,15 @@ struct agp_memory *agp_create_memory(int
 		kfree(new);
 		return NULL;
 	}
+	if (new->dma_memory == NULL) {
+		agp_free_key(new->key);
+		if (new->vmalloc_flag)
+			vfree(new->memory);
+		else
+			kfree(new->memory);
+		kfree(new);
+		return NULL;
+	}
 	new->num_scratch_pages = scratch_pages;
 	new->type = AGP_NORMAL_MEMORY;
 	return new;
@@ -433,6 +463,13 @@ int agp_bind_memory(struct agp_memory *c
 		curr->bridge->driver->cache_flush();
 		curr->is_flushed = TRUE;
 	}
+
+	if (curr->bridge->driver->agp_map_dma_pages) {
+		if (!curr->bridge->driver->agp_map_dma_pages(curr->bridge, curr))
+			return -EINVAL;
+		curr->is_dma_mapped = 1;
+	}
+
 	ret_val = curr->bridge->driver->insert_memory(curr, pg_start, curr->type);
 
 	if (ret_val != 0)
@@ -470,6 +507,10 @@ int agp_unbind_memory(struct agp_memory
 	if (ret_val != 0)
 		return ret_val;
 
+	if (curr->bridge->driver->agp_unmap_dma_pages)
+		curr->bridge->driver->agp_unmap_dma_pages(curr->bridge, curr);
+	curr->is_dma_mapped = 0;
+
 	curr->is_bound = FALSE;
 	curr->pg_start = 0;
 	return 0;
@@ -1094,8 +1135,13 @@ int agp_generic_insert_memory(struct agp
 	}
 
 	for (i = 0, j = pg_start; i < mem->page_count; i++, j++) {
-		writel(bridge->driver->mask_memory(bridge, mem->memory[i], mask_type),
-		       bridge->gatt_table+j);
+		if (mem->is_dma_mapped)
+			writel(bridge->driver->mask_memory(bridge, 
+						mem->dma_memory[i], mask_type),
+					bridge->gatt_table+j);
+		else
+			writel(bridge->driver->mask_memory(bridge, mem->memory[i], mask_type),
+					bridge->gatt_table+j);
 	}
 	readl(bridge->gatt_table+j-1);	/* PCI Posting. */
 
@@ -1356,3 +1406,41 @@ const struct aper_size_info_16 agp3_gene
 };
 EXPORT_SYMBOL(agp3_generic_sizes);
 
+int agp_generic_map_dma_pages(struct agp_bridge_data *bridge, struct agp_memory *mem)
+{
+	struct pci_dev *dev;
+	int i;
+
+	if (!bridge || !mem)
+		return 0;
+	dev = bridge->dev;
+	for (i = 0; i < mem->page_count; i++ ) {
+		mem->dma_memory[i] = pci_map_single(dev, 
+				gart_to_virt(mem->memory[i]), PAGE_SIZE, 
+				PCI_DMA_BIDIRECTIONAL);
+		if (pci_dma_mapping_error(mem->dma_memory[i])) {
+			int j;
+			for (j = 0; j < i; j++) {
+				pci_unmap_single(dev, mem->dma_memory[j],
+						PAGE_SIZE, 
+						PCI_DMA_BIDIRECTIONAL);
+			}
+			return 0;
+		}
+	}
+	return 1;
+}
+
+void agp_generic_unmap_dma_pages(struct agp_bridge_data *bridge, struct agp_memory *mem)
+{
+	struct pci_dev *dev;
+	int i;
+	if (!bridge || !mem)
+		return;
+	dev = bridge->dev;
+	for (i = 0; i < mem->page_count; i++ )
+		pci_unmap_single(dev, mem->dma_memory[i], PAGE_SIZE,
+				PCI_DMA_BIDIRECTIONAL);
+}
+EXPORT_SYMBOL(agp_generic_map_dma_pages);
+EXPORT_SYMBOL(agp_generic_unmap_dma_pages);
diff --git a/include/linux/agp_backend.h b/include/linux/agp_backend.h
index abc521c..abd2ca6 100644
--- a/include/linux/agp_backend.h
+++ b/include/linux/agp_backend.h
@@ -79,6 +79,8 @@ struct agp_memory {
 	struct agp_memory *prev;
 	struct agp_bridge_data *bridge;
 	unsigned long *memory;
+	dma_addr_t *dma_memory;
+	u8 is_dma_mapped;
 	size_t page_count;
 	int key;
 	int num_scratch_pages;
@@ -90,6 +92,9 @@ struct agp_memory {
         u8 vmalloc_flag;
 };
 
+#define AGP_MEMORY_VMALLOC	1
+#define AGP_DMA_MEMORY_VMALLOC  2
+
 #define AGP_NORMAL_MEMORY 0
 
 #define AGP_USER_TYPES (1 << 16)

--fUYQa+Pmc3FrFX/N--
