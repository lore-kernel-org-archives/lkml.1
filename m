Return-Path: <linux-kernel-owner+w=401wt.eu-S1755631AbYAJTO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631AbYAJTO2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 14:14:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751317AbYAJTOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 14:14:19 -0500
Received: from mga03.intel.com ([143.182.124.21]:2071 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbYAJTOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 14:14:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,267,1196668800"; 
   d="scan'208";a="363696683"
Message-Id: <20080110184855.454555000@intel.com>
References: <20080110184840.927409000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 10 Jan 2008 10:48:45 -0800
From: venkatesh.pallipadi@intel.com
To: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       davem@davemloft.net
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 05/11] PAT x86: drm driver changes for PAT
Content-Disposition: inline; filename=pat-drivers.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Straight forward port of pat-drivers.patch to x86 tree

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Index: linux-2.6.24-rc/drivers/char/drm/drm_proc.c
===================================================================
--- linux-2.6.24-rc.orig/drivers/char/drm/drm_proc.c
+++ linux-2.6.24-rc/drivers/char/drm/drm_proc.c
@@ -480,7 +480,7 @@ static int drm__vma_info(char *buf, char
 	int len = 0;
 	struct drm_vma_entry *pt;
 	struct vm_area_struct *vma;
-#if defined(__i386__)
+#ifdef CONFIG_X86
 	unsigned int pgprot;
 #endif
 
@@ -510,13 +510,13 @@ static int drm__vma_info(char *buf, char
 			       vma->vm_flags & VM_IO ? 'i' : '-',
 			       vma->vm_pgoff);
 
-#if defined(__i386__)
+#ifdef CONFIG_X86
 		pgprot = pgprot_val(vma->vm_page_prot);
 		DRM_PROC_PRINT(" %c%c%c%c%c%c%c%c%c",
 			       pgprot & _PAGE_PRESENT ? 'p' : '-',
 			       pgprot & _PAGE_RW ? 'w' : 'r',
 			       pgprot & _PAGE_USER ? 'u' : 's',
-			       pgprot & _PAGE_PWT ? 't' : 'b',
+			       ((pgprot & _PAGE_CACHE_MASK) == _PAGE_WC) ? 'w' : 'b',
 			       pgprot & _PAGE_PCD ? 'u' : 'c',
 			       pgprot & _PAGE_ACCESSED ? 'a' : '-',
 			       pgprot & _PAGE_DIRTY ? 'd' : '-',
Index: linux-2.6.24-rc/drivers/char/drm/drm_vm.c
===================================================================
--- linux-2.6.24-rc.orig/drivers/char/drm/drm_vm.c
+++ linux-2.6.24-rc/drivers/char/drm/drm_vm.c
@@ -45,11 +45,8 @@ static pgprot_t drm_io_prot(uint32_t map
 {
 	pgprot_t tmp = vm_get_page_prot(vma->vm_flags);
 
-#if defined(__i386__) || defined(__x86_64__)
-	if (boot_cpu_data.x86 > 3 && map_type != _DRM_AGP) {
-		pgprot_val(tmp) |= _PAGE_PCD;
-		pgprot_val(tmp) &= ~_PAGE_PWT;
-	}
+#ifdef CONFIG_X86
+	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
 #elif defined(__powerpc__)
 	pgprot_val(tmp) |= _PAGE_NO_CACHE;
 	if (map_type == _DRM_REGISTERS)
Index: linux-2.6.24-rc/drivers/video/gbefb.c
===================================================================
--- linux-2.6.24-rc.orig/drivers/video/gbefb.c
+++ linux-2.6.24-rc/drivers/video/gbefb.c
@@ -57,7 +57,7 @@ struct gbefb_par {
 #endif
 #endif
 #ifdef CONFIG_X86
-#define pgprot_fb(_prot) ((_prot) | _PAGE_PCD)
+#define pgprot_fb(_prot) pgprot_writecombine(_prot)
 #endif
 
 /*
Index: linux-2.6.24-rc/drivers/video/sgivwfb.c
===================================================================
--- linux-2.6.24-rc.orig/drivers/video/sgivwfb.c
+++ linux-2.6.24-rc/drivers/video/sgivwfb.c
@@ -714,8 +714,7 @@ static int sgivwfb_mmap(struct fb_info *
 	if (offset + size > sgivwfb_mem_size)
 		return -EINVAL;
 	offset += sgivwfb_mem_phys;
-	pgprot_val(vma->vm_page_prot) =
-	    pgprot_val(vma->vm_page_prot) | _PAGE_PCD;
+	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
 	vma->vm_flags |= VM_IO;
 	if (remap_pfn_range(vma, vma->vm_start, offset >> PAGE_SHIFT,
 						size, vma->vm_page_prot))
Index: linux-2.6.24-rc/include/asm-x86/fb.h
===================================================================
--- linux-2.6.24-rc.orig/include/asm-x86/fb.h
+++ linux-2.6.24-rc/include/asm-x86/fb.h
@@ -8,8 +8,7 @@
 static inline void fb_pgprotect(struct file *file, struct vm_area_struct *vma,
 				unsigned long off)
 {
-	if (boot_cpu_data.x86 > 3)
-		pgprot_val(vma->vm_page_prot) |= _PAGE_PCD;
+	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
 }
 
 #ifdef CONFIG_X86_32

-- 
