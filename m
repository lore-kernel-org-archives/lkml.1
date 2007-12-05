Return-Path: <linux-kernel-owner+w=401wt.eu-S1755104AbXLEH7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104AbXLEH7H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 02:59:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754397AbXLEHzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 02:55:36 -0500
Received: from ns1.suse.de ([195.135.220.2]:38669 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253AbXLEHzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 02:55:12 -0500
Message-Id: <20071205071628.332985000@nick.local0.net>
References: <20071205071547.701344000@nick.local0.net>
User-Agent: quilt/0.46-14
Date: Wed, 05 Dec 2007 18:16:02 +1100
From: npiggin@suse.de
To: akpm@linux-foundation.org
Cc: tiwai@suse.de, annabellesgarden@yahoo.de, linux-kernel@vger.kernel.org
Subject: [patch 15/18] alsa: usx2y nopage
Content-Disposition: inline; filename=alsa-usx2y-nopage.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert alsa usx2y driver from nopage to fault.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: tiwai@suse.de
Cc: annabellesgarden@yahoo.de
Cc: linux-kernel@vger.kernel.org
---
 sound/usb/usx2y/usX2Yhwdep.c    |   21 ++++++++-------------
 sound/usb/usx2y/usx2yhwdeppcm.c |   19 ++++++-------------
 2 files changed, 14 insertions(+), 26 deletions(-)

Index: linux-2.6/sound/usb/usx2y/usX2Yhwdep.c
===================================================================
--- linux-2.6.orig/sound/usb/usx2y/usX2Yhwdep.c
+++ linux-2.6/sound/usb/usx2y/usX2Yhwdep.c
@@ -34,34 +34,29 @@
 int usX2Y_hwdep_pcm_new(struct snd_card *card);
 
 
-static struct page * snd_us428ctls_vm_nopage(struct vm_area_struct *area, unsigned long address, int *type)
+static int snd_us428ctls_vm_fault(struct vm_area_struct *area, struct vm_fault *vmf)
 {
 	unsigned long offset;
 	struct page * page;
 	void *vaddr;
 
-	snd_printdd("ENTER, start %lXh, ofs %lXh, pgoff %ld, addr %lXh\n",
+	snd_printdd("ENTER, start %lXh, pgoff %ld\n",
 		   area->vm_start,
-		   address - area->vm_start,
-		   (address - area->vm_start) >> PAGE_SHIFT,
-		   address);
+		   vmf->pgoff);
 	
-	offset = area->vm_pgoff << PAGE_SHIFT;
-	offset += address - area->vm_start;
-	snd_assert((offset % PAGE_SIZE) == 0, return NOPAGE_SIGBUS);
+	offset = vmf->pgoff << PAGE_SHIFT;
 	vaddr = (char*)((struct usX2Ydev *)area->vm_private_data)->us428ctls_sharedmem + offset;
 	page = virt_to_page(vaddr);
 	get_page(page);
-	snd_printdd( "vaddr=%p made us428ctls_vm_nopage() return %p; offset=%lX\n", vaddr, page, offset);
+	vmf->page = page;
 
-	if (type)
-		*type = VM_FAULT_MINOR;
+	snd_printdd( "vaddr=%p made us428ctls_vm_fault() page %p\n", vaddr, page);
 
-	return page;
+	return 0;
 }
 
 static struct vm_operations_struct us428ctls_vm_ops = {
-	.nopage = snd_us428ctls_vm_nopage,
+	.fault = snd_us428ctls_vm_fault,
 };
 
 static int snd_us428ctls_mmap(struct snd_hwdep * hw, struct file *filp, struct vm_area_struct *area)
Index: linux-2.6/sound/usb/usx2y/usx2yhwdeppcm.c
===================================================================
--- linux-2.6.orig/sound/usb/usx2y/usx2yhwdeppcm.c
+++ linux-2.6/sound/usb/usx2y/usx2yhwdeppcm.c
@@ -683,30 +683,23 @@ static void snd_usX2Y_hwdep_pcm_vm_close
 }
 
 
-static struct page * snd_usX2Y_hwdep_pcm_vm_nopage(struct vm_area_struct *area, unsigned long address, int *type)
+static int snd_usX2Y_hwdep_pcm_vm_fault(struct vm_area_struct *area, struct vm_fault *vmf)
 {
 	unsigned long offset;
-	struct page *page;
 	void *vaddr;
 
-	offset = area->vm_pgoff << PAGE_SHIFT;
-	offset += address - area->vm_start;
-	snd_assert((offset % PAGE_SIZE) == 0, return NOPAGE_OOM);
+	offset = vmf->pgoff << PAGE_SHIFT;
 	vaddr = (char*)((struct usX2Ydev *)area->vm_private_data)->hwdep_pcm_shm + offset;
-	page = virt_to_page(vaddr);
-	get_page(page);
-
-	if (type)
-		*type = VM_FAULT_MINOR;
-
-	return page;
+	vmf->page = virt_to_page(vaddr);
+	get_page(vmf->page);
+	return 0;
 }
 
 
 static struct vm_operations_struct snd_usX2Y_hwdep_pcm_vm_ops = {
 	.open = snd_usX2Y_hwdep_pcm_vm_open,
 	.close = snd_usX2Y_hwdep_pcm_vm_close,
-	.nopage = snd_usX2Y_hwdep_pcm_vm_nopage,
+	.fault = snd_usX2Y_hwdep_pcm_vm_fault,
 };
 
 

-- 

