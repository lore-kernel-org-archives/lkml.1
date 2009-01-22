Return-Path: <linux-kernel-owner+w=401wt.eu-S1755863AbZAVGxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbZAVGxK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 01:53:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbZAVGwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 01:52:55 -0500
Received: from cathcart.site5.com ([74.54.107.137]:54509 "EHLO
	cathcart.site5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357AbZAVGwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 01:52:55 -0500
Message-ID: <497817C1.2020200@compulab.co.il>
Date: Thu, 22 Jan 2009 08:52:49 +0200
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.16 (X11/20080907)
MIME-Version: 1.0
To: gregkh@suse.de
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: fix Android binder compilation
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cathcart.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building kernel with ARCH=arm and xm_x2xx_defconfig and Android binder driver
enabled gives the following error:

  CC      drivers/staging/android/binder.o
/mnt/sdb1/git/linux-2.6-arm/drivers/staging/android/binder.c: In function
'binder_vma_open':
/mnt/sdb1/git/linux-2.6-arm/drivers/staging/android/binder.c:2652: error:
request for member 'pgprot' in something not a structure or union
/mnt/sdb1/git/linux-2.6-arm/drivers/staging/android/binder.c: In function
'binder_vma_close':
/mnt/sdb1/git/linux-2.6-arm/drivers/staging/android/binder.c:2659: error:
request for member 'pgprot' in something not a structure or union
/mnt/sdb1/git/linux-2.6-arm/drivers/staging/android/binder.c: In function
'binder_mmap':
/mnt/sdb1/git/linux-2.6-arm/drivers/staging/android/binder.c:2680: error:
request for member 'pgprot' in something not a structure or union

Fix it.

Signed-off-by: Mike Rapoport <mike@compulab.co.il>

 drivers/staging/android/binder.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 6a4ceac..ab014bc 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -2649,14 +2649,14 @@ static void binder_vma_open(struct vm_area_struct *vma)
 {
 	struct binder_proc *proc = vma->vm_private_data;
 	if (binder_debug_mask & BINDER_DEBUG_OPEN_CLOSE)
-		printk(KERN_INFO "binder: %d open vm area %lx-%lx (%ld K) vma %lx pagep %lx\n", proc->pid, vma->vm_start, vma->vm_end, (vma->vm_end -
vma->vm_start) / SZ_1K, vma->vm_flags, vma->vm_page_prot.pgprot);
+		printk(KERN_INFO "binder: %d open vm area %lx-%lx (%ld K) vma %lx pagep %lx\n", proc->pid, vma->vm_start, vma->vm_end, (vma->vm_end -
vma->vm_start) / SZ_1K, vma->vm_flags, pgprot_val(vma->vm_page_prot));
 	dump_stack();
 }
 static void binder_vma_close(struct vm_area_struct *vma)
 {
 	struct binder_proc *proc = vma->vm_private_data;
 	if (binder_debug_mask & BINDER_DEBUG_OPEN_CLOSE)
-		printk(KERN_INFO "binder: %d close vm area %lx-%lx (%ld K) vma %lx pagep %lx\n", proc->pid, vma->vm_start, vma->vm_end, (vma->vm_end -
vma->vm_start) / SZ_1K, vma->vm_flags, vma->vm_page_prot.pgprot);
+		printk(KERN_INFO "binder: %d close vm area %lx-%lx (%ld K) vma %lx pagep %lx\n", proc->pid, vma->vm_start, vma->vm_end, (vma->vm_end -
vma->vm_start) / SZ_1K, vma->vm_flags, pgprot_val(vma->vm_page_prot));
 	proc->vma = NULL;
 }

@@ -2677,7 +2677,7 @@ static int binder_mmap(struct file *filp, struct vm_area_struct *vma)
 		vma->vm_end = vma->vm_start + SZ_4M;

 	if (binder_debug_mask & BINDER_DEBUG_OPEN_CLOSE)
-		printk(KERN_INFO "binder_mmap: %d %lx-%lx (%ld K) vma %lx pagep %lx\n", proc->pid, vma->vm_start, vma->vm_end, (vma->vm_end -
vma->vm_start) / SZ_1K, vma->vm_flags, vma->vm_page_prot.pgprot);
+		printk(KERN_INFO "binder_mmap: %d %lx-%lx (%ld K) vma %lx pagep %lx\n", proc->pid, vma->vm_start, vma->vm_end, (vma->vm_end -
vma->vm_start) / SZ_1K, vma->vm_flags, pgprot_val(vma->vm_page_prot));

 	if (vma->vm_flags & FORBIDDEN_MMAP_FLAGS) {
 		ret = -EPERM;


-- 
Sincerely yours,
Mike.


