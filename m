Return-Path: <linux-kernel-owner+w=401wt.eu-S1753446AbZEDJUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbZEDJUs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 05:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbZEDJUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 05:20:39 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:35505 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbZEDJUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 05:20:38 -0400
X-Greylist: delayed 612 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 May 2009 05:20:37 EDT
Date: Mon, 04 May 2009 11:09:07 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [RFC] Multimedia device driver memory buffers (with src code)
To: "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
       "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
       Ben Dooks <ben-linux@fluff.org>
Message-id: <E4D3F24EA6C9E54F817833EAE0D912AC02243DBA9F@bssrvexch01.BS.local>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: en-US
Content-transfer-encoding: 7BIT
Accept-Language: en-US
Thread-topic: [RFC] Multimedia device driver memory buffers (with src code)
Thread-index: AcnMl/qOUMoDFkLjT6qi8B3mnyfgUA==
acceptlanguage: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

We are developing drivers for multimedia devices on S3C64XX SOC (which is an embedded UMA platform). This SOC includes the following 'multimedia' devices: frame buffer, 2D graphics accelerator (rotator, blitter and post processor which is capable of color space conversion), JPEG and multi-format video codecs and 3D graphics accelerator. Also a camera device interface can be considered as a multimedia device.

1. The problem

All these multimedia devices have some common features. They all require memory buffers for input and/or output data. All they can access any system memory directly, but none can actually do a scatter/gather so the buffer must be contiguous in physical memory.

Usually the device drivers allocate memory buffers on their own and export them to userspace (usually by mmap). If we consider this model then the following processing pipeline: JPEG decoder -> pre-processor scaller -> frame buffer will result in copying whole buffers two times.

We decided to solve this by using shared buffers between different devices, so in this example pre-processor driver would be able to access JPEG decoder output buffer directly and put its output directly into the frame buffer memory.

Another constraint is high security of the solution, so we cannot use any buffer sharing based on buffer physical address in the userspace. The solution based on a buffer manager would require to modify all devices to be aware of said manager, what we want to avoid.

Another limiting factor is the minimization of changes in existing device drivers (like for example the existing s3c frame buffer driver).

2. Proposed solution

Out solution bases on two facts:
- a pair of user-space buffer pointer address and the buffer size indentifies memory region unambiguously
- such a buffer can be easily checked if it is possible to use it directly by the hardware (if it is contiguous or not in physical memory).

With these facts I decided to define a translation layer that would convert the passed userspace virtual pointer to something useable by device drivers. If such a translation succeeds the physical memory region will be properly locked and is guaranteed to be in the memory till the end of transaction. The transaction must be closed explicitly.

3. Technical details

If user application performed a mmap call on some special device and a driver mapped some physical memory into user address space (with remap_pfn_range function), this will create a vm_area structure with VM_PFNMAP flag set in user address space map. The driver that wants to use such mapping can easily check if it is contiguous in physical memory.

The only problem is how to guarantee the security of this solution. VM_PFNMAP-type area does not have associated page structures so that memory pages cannot be locked directly in page cache. However I found that every such an area in user-space has associated special file that keeps the mapping. So it can be correctly locked by increasing reference counter of that special file (vm_area->vm_file). This would lock the mapping from being freed if user would accidently do something really nasty like unmapping that area.
Is this assumption correct? Are there any pitfalls I missed?

Further I extended my buffer-userspace-virtual-address-to-physical-address translation layer (as it will be common for the multimedia devices) to support also small buffers (smaller than one page, so they are always contiguous) of user-space standard memory area (like stack or heap). This was quite simple as there is already get_user_pages() function that can lock specified pages.

Then I extended the translation layer even more. I've added support for so called 'shadow buffers' - if the area specified by the userspace pointer address cannot be used directly (for example it is not contiguous) the additional memory buffer is allocated (currently with dma_alloc_coherent function) and the data is copied from/to that shadow buffer. The device driver in all cases simply get the physical address of the buffer that user specified and can pass it directly to hardware.

4. Results

We tested such a solution and it allowed us to create a driver for 2D graphics accelerator which can transparently blit images from and to framebuffer or userspace memory directly without the need of altering the frame buffer driver. Also the usage of that driver from userspace was really clean and simple as the arguments for ioctl are just pure pointers to image areas, without differentiating if the image is in the framebuffer or system memory.

Further we want to provide a special device for allocating temporary memory buffers that are contiguous in physical memory. Such temporary buffers might be required for efficient data processing in a pipeline of multimedia devices.

What do you think about such a solution? Could you please point me any flaws or drawbacks you notice?

5. Source code

This is the source code of the userspace buffer address translation layer:

diff --git a/drivers/s3cmm/upbuffer.c b/drivers/s3cmm/upbuffer.c
new file mode 100644
index 0000000..d1a6f2d
--- /dev/null
+++ b/drivers/s3cmm/upbuffer.c
@@ -0,0 +1,440 @@
+/*
+ * Helper functions for accessing userspace memory buffers
+ *
+ * Copyright (c) 2009 Samsung Electronics
+ *
+ * Author: Marek Szyprowski <m.szyprowski@samsung.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/sched.h>
+#include <linux/types.h>
+#include <linux/vmalloc.h>
+#include <linux/io.h>
+#include <asm/page.h>
+#include <linux/vmalloc.h>
+#include <linux/mm.h>
+#include <linux/file.h>
+#include <linux/pagemap.h>
+#include <linux/dma-mapping.h>
+#include <linux/memory.h>
+
+#include <linux/s3c/upbuffer.h>
+
+#ifdef DEBUG
+#define debug(fmt, args...) printk(KERN_INFO fmt, ##args)
+#else
+#define debug(fmt, args...)
+#endif
+
+/* case 0:
+   userspace physical memory cannot be directly used (non-continous, not a real
+   memory, etc), create shadow buffer and copy data on each sync
+*/
+
+/* TODO: use DMA to copy from/to non-continous userspace buffers
+   (if possible) */
+static int shadow_buffer_sync(struct upbuf *buf, enum upbuf_direction dir)
+{
+       int res = 0;
+       switch (dir) {
+       /* Send contents of cache to memory and then invalidate */
+       case UPBUF_FROM_USER:
+               res = copy_from_user(buf->vaddr, (const void __user *)buf->user_vaddr,
+                       buf->size);
+               break;
+
+       case UPBUF_TO_USER:
+               res = copy_to_user((void __user *)buf->user_vaddr, buf->vaddr, buf->size);
+               break;
+
+       default:
+               res = -EINVAL;
+       }
+       return res;
+}
+
+static int shadow_buffer_release(struct upbuf *buf)
+{
+       debug("shadow_buffer_release\n");
+       BUG_ON(buf->vaddr == NULL);
+
+       dma_free_coherent(NULL, buf->size, buf->vaddr, buf->paddr);
+       buf->vaddr = NULL;
+       return 0;
+}
+
+static int shadow_buffer_prepare(struct upbuf *buf)
+{
+       void *dma_buff;
+       dma_addr_t dma_addr;
+       int res = 0;
+
+       debug("Preparing shaddow buffer for virt buffer 0x%08lx, size %ld\n",
+               buf->user_vaddr, buf->size);
+
+       dma_buff = dma_alloc_coherent(NULL, buf->size, &dma_addr, GFP_KERNEL);
+       if (dma_buff != NULL) {
+               debug("Allocated continous memory area: phys addrr 0x%08lx, size %ld\n",
+               (unsigned long)dma_addr, buf->size);
+               buf->page_pa_first = dma_addr;
+               buf->paddr = dma_addr;
+               buf->vaddr = dma_buff;
+               /* shadow buffers are always mapped into kernel space */
+               buf->flags |= UPBUF_MAP_KERNEL;
+               buf->priv = dma_buff;
+               buf->sync = shadow_buffer_sync;
+               buf->release = shadow_buffer_release;
+               /* success */
+               return 0;
+       } else {
+               debug("Error: cannot allocate shadow buffer!\n");
+               res = -ENOMEM;
+       }
+
+       return res;
+}
+
+/* case 1:
+   physical memory mapped directly into userspace vma, VM_PFNMAP flag is set,
+   this mapping is done as mmaping special (device) file (i.e. /dev/fb0)
+*/
+
+static int direct_pfn_sync(struct upbuf *b, enum upbuf_direction dir)
+{
+       int res = 0;
+       switch (dir) {
+       /* Send contents of cache to memory and then invalidate */
+       case UPBUF_FROM_USER:
+               if (b->vaddr)
+                       dmac_flush_range(b->vaddr, (char *)b->vaddr + b->size);
+               outer_flush_range(b->page_pa_first,
+                       b->page_pa_first + b->page_buff_size - 1);
+               break;
+
+       case UPBUF_TO_USER:
+               if (b->vaddr)
+                       dmac_inv_range(b->vaddr, (char *)b->vaddr + b->size);
+               outer_inv_range(b->page_pa_first,
+                       b->page_pa_first + b->page_buff_size - 1);
+               break;
+
+       default:
+               res = -EINVAL;
+       }
+       return res;
+}
+
+static int direct_pfn_release(struct upbuf *b)
+{
+       struct vm_area_struct *vma = b->priv;
+
+       debug("direct_pfn_release\n");
+       BUG_ON(vma == NULL);
+       BUG_ON(vma->vm_file == NULL);
+
+       /* decrement file use count */
+       fput(vma->vm_file);
+       return 0;
+}
+
+static int get_pte(struct vm_area_struct *vma, unsigned long address,
+       unsigned int flags, pte_t *dst)
+{
+       pgd_t *pgd;
+       pud_t *pud;
+       pmd_t *pmd;
+       pte_t *pte;
+       struct mm_struct *mm = vma->vm_mm;
+
+       pgd = pgd_offset(mm, address);
+       if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
+               goto no_page_table;
+
+       pud = pud_offset(pgd, address);
+       if (pud_none(*pud) || unlikely(pgd_bad(*pud)))
+               goto no_page_table;
+
+       pmd = pmd_offset(pud, address);
+       if (pmd_none(*pmd) || unlikely(pmd_bad(*pmd)))
+               goto no_page_table;
+
+       pte = pte_offset_map(pmd, address);
+       if (!pte_present(*pte))
+               goto unlock;
+       *dst = *pte;
+
+       return 0;
+
+no_page_table:
+       return -EFAULT;
+}
+
+#define pte_phys(x) (pte_val(x) & PAGE_MASK)
+
+static int direct_pfn_prepare(struct upbuf *b, struct vm_area_struct *vma)
+{
+       unsigned long start = (unsigned long)b->page_va_first;
+       int page_count = b->page_count;
+       int res = 0;
+
+       debug("direct_pfn_prepare\n");
+
+       if ((vma->vm_flags & VM_PFNMAP) && vma->vm_file) {
+               pte_t *area;
+               int i;
+               unsigned long base = 0;
+               debug("Direct PFN mapping found, using special file reference "
+                       "counter.\n");
+
+               area = kmalloc(page_count * sizeof(pte_t *), GFP_KERNEL);
+
+               /* increment vma file use count before hacking with pte map */
+               get_file(vma->vm_file);
+
+               for (i = 0; res == 0 && i < page_count; i++)
+                       res = get_pte(vma, start+i*PAGE_SIZE, 0, &area[i]);
+
+               if (res == 0) {
+                       base = pte_phys(area[0]);
+                       for (i = 1; i < page_count; i++)
+                               if (pte_phys(area[i]) != base + PAGE_SIZE*i)
+                                       break;
+
+                       if (i == page_count) {
+                               debug("Found buffer that is continous memory area: vaddr "
+                                       "(userspace) 0x%08lx, phys 0x%08lx, size %ld\n", start,
+                                       base, b->page_buff_size);
+                               b->page_pa_first = base;
+                               b->paddr = b->page_pa_first + b->page_offset;
+                               b->priv = vma;
+                               b->sync = direct_pfn_sync;
+                               b->release = direct_pfn_release;
+                               kfree(area);
+                               /* success */
+                               return 0;
+                       } else
+                               res = -EINVAL;
+               }
+               fput(vma->vm_file);
+               kfree(area);
+       } else
+               res = -EINVAL;
+
+       return res;
+}
+
+/* ************ */
+
+/* case 2:
+   normal process memory, struct page * available for every page,
+   this can be either stack or heap, usualy can be continous only
+   if size <= single page,
+*/
+
+static int direct_usermem_sync(struct upbuf *b, enum upbuf_direction dir)
+{
+       struct page **pages = b->priv;
+       int page_count = b->page_count;
+       int i;
+       int res = 0;
+
+       switch (dir) {
+       /* Send contents of cache to memory and then invalidate */
+       case UPBUF_FROM_USER:
+               if (b->vaddr)
+                       dmac_flush_range(b->vaddr, (char *)b->vaddr + b->size);
+               outer_flush_range(b->page_pa_first,
+                       b->page_pa_first + b->page_buff_size - 1);
+               break;
+
+       case UPBUF_TO_USER:
+               if (b->vaddr)
+                       dmac_inv_range(b->vaddr, (char *)b->vaddr + b->size);
+               outer_inv_range(b->page_pa_first,
+                       b->page_pa_first + b->page_buff_size - 1);
+               for (i = 0; i < page_count; i++)
+                       if (!PageReserved(pages[i]))
+                               SetPageDirty(pages[i]);
+               break;
+
+       default:
+               res = -EINVAL;
+       }
+       return res;
+}
+
+static int direct_usermem_release(struct upbuf *b)
+{
+       struct page **pages = b->priv;
+       int page_count = b->page_count;
+       int i;
+
+       debug("direct_usermem_release\n");
+       BUG_ON(pages == NULL);
+
+       for (i = 0; i < page_count; i++)
+               page_cache_release(pages[i]);
+       kfree(pages);
+
+       return 0;
+}
+
+static int direct_usermem_prepare(struct upbuf *b)
+{
+       int page_count = b->page_count;
+       struct page **pages;
+       int res = 0;
+       int i;
+
+       debug("direct_usermem_prepare\n");
+
+       pages = kmalloc(page_count * sizeof(struct page *), GFP_KERNEL);
+       if (pages == NULL)
+               return -ENOMEM;
+
+       res = get_user_pages(current, current->mm, b->page_va_first, page_count,
+                            1, 1, pages, NULL);
+
+       if (res == page_count) {
+               unsigned long base = 0;
+
+               base = page_to_pfn(pages[0])<<PAGE_SHIFT;
+
+               for (i = 1; i < page_count; i++)
+                       if (page_to_pfn(pages[i])<<PAGE_SHIFT != base + PAGE_SIZE*i)
+                               break;
+
+               if (i == page_count) {
+                       debug("Found userspace buffer that is continous memory area: vaddr "
+                               "(userspace) 0x%08lx, phys 0x%08lx, size %ld\n",
+                               b->page_va_first, base, b->size);
+                       b->page_pa_first = base;
+                       b->paddr = b->page_pa_first + b->page_offset;
+                       b->priv = pages;
+                       b->sync = direct_usermem_sync;
+                       b->release = direct_usermem_release;
+                       /* success */
+                       return 0;
+               } else {
+                       debug("This userspace memory is not continous physical memory\n");
+                       res = -EINVAL;
+               }
+       } else {
+               if (res > 0)
+                       page_count = res;
+               res = -EINVAL;
+       }
+
+       for (i = 0; i < page_count; i++)
+               page_cache_release(pages[i]);
+       kfree(pages);
+
+       return res;
+}
+
+/* ************ */
+
+int upbuf_prepare(struct upbuf *buf, unsigned long vaddr, unsigned long size,
+       enum upbuf_flags flags)
+{
+       struct mm_struct *mm = current->mm;
+       struct vm_area_struct *vma;
+       int res;
+       unsigned int page_va_last;
+
+       BUG_ON(buf == NULL || current == NULL);
+
+       debug("upbuf_prepare: vaddr 0x%08lx, size 0x%ld, flags %d\n", vaddr, size,
+               flags);
+
+       mm = current->mm;
+       vma = find_extend_vma(mm, vaddr);
+
+       debug("vma: %p\n", vma);
+
+       if (!vma)
+               return -EFAULT;
+
+       memset(buf, 0, sizeof(*buf));
+
+       buf->flags = flags;
+       buf->size = size;
+       buf->user_vaddr = vaddr;
+       buf->page_offset = vaddr & ~PAGE_MASK;
+       buf->page_va_first = (vaddr          & PAGE_MASK);
+       page_va_last  = ((vaddr+size-1) & PAGE_MASK);
+       buf->page_count = ((page_va_last-buf->page_va_first) >> PAGE_SHIFT) + 1;
+       buf->page_buff_size = buf->page_count << PAGE_SHIFT;
+
+       if (vma->vm_end < vaddr + size) {
+               debug("Virtual area from 0x%08lx + 0x%08lx does not belong to single "
+                       " vm_area, cannot map it directly!\n", vaddr, size);
+               goto shadow_buffer;
+       }
+
+       if ((res = direct_pfn_prepare(buf, vma)) == 0)
+               goto map_kernel;
+
+       if ((res = direct_usermem_prepare(buf)) == 0)
+               goto map_kernel;
+
+shadow_buffer:
+       if (flags & UPBUF_NO_SHADOW)
+               return -EINVAL;
+       res = shadow_buffer_prepare(buf);
+
+map_kernel:
+       if (res == 0 && buf->vaddr == NULL && (flags & UPBUF_MAP_KERNEL)) {
+               void *kernel_vaddr;
+               if ((kernel_vaddr = ioremap(buf->paddr, size)) != NULL) {
+                       debug("Buffer is available at 0x%08lx in kernel space.\n",
+                               (unsigned long)kernel_vaddr);
+                       buf->vaddr = kernel_vaddr;
+                       buf->flags = UPBUF_MAP_KERNEL_DONE;
+               } else {
+                       if (buf->release)
+                               buf->release(buf);
+                       res = -EINVAL;
+               }
+       }
+       return res;
+}
+EXPORT_SYMBOL(upbuf_prepare);
+
+int upbuf_sync(struct upbuf *buf, enum upbuf_direction dir)
+{
+       int res = 0;
+       BUG_ON(buf == NULL);
+       debug("upbuf_sync\n");
+       if (buf->sync)
+               res = buf->sync(buf, dir);
+       return res;
+}
+EXPORT_SYMBOL(upbuf_sync);
+
+int upbuf_release(struct upbuf *buf)
+{
+       int res = 0;
+       BUG_ON(buf == NULL);
+       debug("upbuf_release\n");
+
+       if ((buf->flags & UPBUF_MAP_KERNEL_DONE) && buf->vaddr)
+               iounmap(buf->vaddr);
+
+       if (buf->release)
+               res = buf->release(buf);
+       if (res == 0)
+               memset(buf, 0, sizeof(*buf));
+       return res;
+}
+EXPORT_SYMBOL(upbuf_release);
diff --git a/include/linux/s3c/upbuffer.h b/include/linux/s3c/upbuffer.h
new file mode 100644
index 0000000..3973d7e
--- /dev/null
+++ b/include/linux/s3c/upbuffer.h
@@ -0,0 +1,80 @@
+/*
+ * Helper functions for accessing userspace memory buffers
+ *
+ * Copyright (c) 2009 Samsung Electronics
+ *
+ * Authors: Marek Szyprowski <m.szyprowski@samsung.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifndef UP_BUFFER_H
+#define UP_BUFFER_H
+
+#include <linux/types.h>
+
+enum upbuf_flags {
+       UPBUF_ANY = 0,
+
+       /* don't create shadow buffer, fail instead */
+       UPBUF_NO_SHADOW = 1<<1,
+
+       /* create virtual address mapping in kernel space */
+       UPBUF_MAP_KERNEL = 1<<2,
+
+       /* private flags */
+       /* virtual address mapping in kernel space sucessfully created */
+       UPBUF_MAP_KERNEL_DONE = 1<<16,
+};
+
+enum upbuf_direction {
+       UPBUF_FROM_USER,
+       UPBUF_TO_USER,
+};
+
+
+struct upbuf {
+       /* Buffer size */
+       unsigned long size;
+
+       /* Physical address */
+       unsigned long paddr;
+
+       /* Virtual addres (kernel space) */
+       void *vaddr;
+
+       /* private, do not use directly */
+       unsigned int flags;
+       unsigned long user_vaddr;
+       unsigned long page_va_first;
+       unsigned long page_pa_first;
+       unsigned long page_offset;
+       unsigned long page_count;
+       unsigned long page_buff_size;
+
+       void *priv;
+       int (*sync)(struct upbuf *upbuf, enum upbuf_direction dir);
+       int (*release)(struct upbuf *upbuf);
+};
+
+/*
+ * All functions return 0 on success or error code on failure
+ * All function must be called with valid current process pointer.
+ * Do not call them from interrupts or kernel threads!
+ */
+
+/** Prepare buffer, find its physical memory or create a shadow buffer it it is
+    not possible to use it directly */
+int __must_check upbuf_prepare(struct upbuf *upbuf, unsigned long u_vaddr,
+       unsigned long size, enum upbuf_flags flags);
+
+/** Copy from/to user buffer if needed */
+int __must_check upbuf_sync(struct upbuf *upbuf, enum upbuf_direction dir);
+
+/** Release buffer, all not synchronized changes are lost */
+int upbuf_release(struct upbuf *upbuf);
+
+#endif /* UP_BUFFER_H */
+

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center
