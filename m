Return-Path: <linux-kernel-owner+w=401wt.eu-S934354AbXLMX6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934354AbXLMX6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 18:58:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764413AbXLMX5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 18:57:18 -0500
Received: from mga02.intel.com ([134.134.136.20]:62032 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763574AbXLMX5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 18:57:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,163,1196668800"; 
   d="scan'208";a="241552104"
Message-Id: <20071213235711.682021000@intel.com>
References: <20071213235543.568682000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 13 Dec 2007 15:55:46 -0800
From: venkatesh.pallipadi@intel.com
To: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [RFC PATCH 03/12] PAT 64b: drm driver changes for PAT
Content-Disposition: inline; filename=pat-drivers.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Straight forward port of pat-drivers.patch to x86 tree

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/drivers/char/drm/drm_proc.c b/drivers/char/drm/drm_proc.c
index 12dfea8..c49be81 100644
--- a/drivers/char/drm/drm_proc.c
+++ b/drivers/char/drm/drm_proc.c
@@ -510,13 +510,13 @@ static int drm__vma_info(char *buf, char **start, off_t offset, int request,
 			       vma->vm_flags & VM_IO ? 'i' : '-',
 			       vma->vm_pgoff);
 
-#if defined(__i386__)
+#if defined(CONFIG_X86)
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
diff --git a/drivers/char/drm/drm_vm.c b/drivers/char/drm/drm_vm.c
index e8d50af..1bd4b49 100644
--- a/drivers/char/drm/drm_vm.c
+++ b/drivers/char/drm/drm_vm.c
@@ -45,11 +45,8 @@ static pgprot_t drm_io_prot(uint32_t map_type, struct vm_area_struct *vma)
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
diff --git a/drivers/video/gbefb.c b/drivers/video/gbefb.c
index b9b572b..1126e20 100644
--- a/drivers/video/gbefb.c
+++ b/drivers/video/gbefb.c
@@ -57,7 +57,7 @@ struct gbefb_par {
 #endif
 #endif
 #ifdef CONFIG_X86
-#define pgprot_fb(_prot) ((_prot) | _PAGE_PCD)
+#define pgprot_fb(_prot) pgprot_writecombine(_prot)
 #endif
 
 /*
diff --git a/drivers/video/sgivwfb.c b/drivers/video/sgivwfb.c
index 4fb1624..3a75a7b 100644
--- a/drivers/video/sgivwfb.c
+++ b/drivers/video/sgivwfb.c
@@ -714,8 +714,7 @@ static int sgivwfb_mmap(struct fb_info *info,
 	if (offset + size > sgivwfb_mem_size)
 		return -EINVAL;
 	offset += sgivwfb_mem_phys;
-	pgprot_val(vma->vm_page_prot) =
-	    pgprot_val(vma->vm_page_prot) | _PAGE_PCD;
+	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
 	vma->vm_flags |= VM_IO;
 	if (remap_pfn_range(vma, vma->vm_start, offset >> PAGE_SHIFT,
 						size, vma->vm_page_prot))
diff --git a/include/asm-x86/fb.h b/include/asm-x86/fb.h
index 5301846..e438d48 100644
--- a/include/asm-x86/fb.h
+++ b/include/asm-x86/fb.h
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
