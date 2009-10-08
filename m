Return-Path: <linux-kernel-owner+w=401wt.eu-S1754726AbZJHGGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbZJHGGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 02:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754653AbZJHGGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 02:06:30 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:34632 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932092AbZJHGFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 02:05:48 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Thomas Chou <thomas@wytron.com.tw>, Graf Yang <graf.yang@analog.com>,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH 11/13] Blackfin: fix framebuffer mmap bug for nommu
Date: Thu,  8 Oct 2009 02:04:27 -0400
Message-Id: <1254981869-21586-12-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc2
In-Reply-To: <1254981869-21586-1-git-send-email-vapier@gentoo.org>
References: <1254981869-21586-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Chou <thomas@wytron.com.tw>

The patch added a special get_unmapped_area for framebuffer which
was hooked to the file ops in drivers/video/fbmem.c.

This is needed since v2.6.29-rc1 where nommu vma management was
updated, and mmap of framebuffer caused kernel BUG panic. You may turn
on "Debug the global anon/private NOMMU mapping region tree" config to
such message.

As Documentation/nommu-mmap.txt said,
"To provide shareable character device support, a driver must provide
a file->f_op->get_unmapped_area() operation. The mmap() routines will
call this to get a proposed address for the mapping."

With this change, user space should call mmap for framebuffer using
shared map. Or it can try shared map first, then private map if
failed. This shared map usage is now consistent between mmu and nommu.

The sys_ file may not be a good place for this patch. But there is a
similar one for sparc. I tested a similar patch on nios2nommu, though
I don't have a blackfin board to test.

Signed-off-by: Thomas Chou <thomas@wytron.com.tw>
Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/pgtable.h |    6 ++++++
 arch/blackfin/kernel/sys_bfin.c     |   11 +++++++++++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/include/asm/pgtable.h b/arch/blackfin/include/asm/pgtable.h
index b54cbdd..821c699 100644
--- a/arch/blackfin/include/asm/pgtable.h
+++ b/arch/blackfin/include/asm/pgtable.h
@@ -98,6 +98,12 @@ extern unsigned int kobjsize(const void *objp);
 #define	VMALLOC_START	0
 #define	VMALLOC_END	0xffffffff
 
+/* provide a special get_unmapped_area for framebuffer mmaps of nommu */
+extern unsigned long get_fb_unmapped_area(struct file *filp, unsigned long,
+					  unsigned long, unsigned long,
+					  unsigned long);
+#define HAVE_ARCH_FB_UNMAPPED_AREA
+
 #include <asm-generic/pgtable.h>
 
 #endif				/* _BLACKFIN_PGTABLE_H */
diff --git a/arch/blackfin/kernel/sys_bfin.c b/arch/blackfin/kernel/sys_bfin.c
index 8b294a1..afcef12 100644
--- a/arch/blackfin/kernel/sys_bfin.c
+++ b/arch/blackfin/kernel/sys_bfin.c
@@ -69,3 +69,14 @@ asmlinkage void *sys_dma_memcpy(void *dest, const void *src, size_t len)
 {
 	return safe_dma_memcpy(dest, src, len);
 }
+
+#if defined(CONFIG_FB) || defined(CONFIG_FB_MODULE)
+#include <linux/fb.h>
+unsigned long get_fb_unmapped_area(struct file *filp, unsigned long orig_addr,
+	unsigned long len, unsigned long pgoff, unsigned long flags)
+{
+	struct fb_info *info = filp->private_data;
+	return (unsigned long)info->screen_base;
+}
+EXPORT_SYMBOL(get_fb_unmapped_area);
+#endif
-- 
1.6.5.rc2

