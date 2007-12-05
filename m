Return-Path: <linux-kernel-owner+w=401wt.eu-S1755339AbXLEH5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbXLEH5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 02:57:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754226AbXLEHz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 02:55:29 -0500
Received: from mx2.suse.de ([195.135.220.15]:42671 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177AbXLEHzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 02:55:10 -0500
Message-Id: <20071205071628.115327000@nick.local0.net>
References: <20071205071547.701344000@nick.local0.net>
User-Agent: quilt/0.46-14
Date: Wed, 05 Dec 2007 18:16:00 +1100
From: npiggin@suse.de
To: akpm@linux-foundation.org
Cc: perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org
Subject: [patch 13/18] alsa: nopage
Content-Disposition: inline; filename=alsa-nopage.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert ALSA from nopage to fault.
Switch from OOM to SIGBUS if the resource is not available.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: perex@perex.cz
Cc: tiwai@suse.de
Cc: alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org
---
 sound/core/pcm_native.c |   59 ++++++++++++++++++++----------------------------
 1 file changed, 25 insertions(+), 34 deletions(-)

Index: linux-2.6/sound/core/pcm_native.c
===================================================================
--- linux-2.6.orig/sound/core/pcm_native.c
+++ linux-2.6/sound/core/pcm_native.c
@@ -3018,26 +3018,23 @@ static unsigned int snd_pcm_capture_poll
 /*
  * mmap status record
  */
-static struct page * snd_pcm_mmap_status_nopage(struct vm_area_struct *area,
-						unsigned long address, int *type)
+static int snd_pcm_mmap_status_fault(struct vm_area_struct *area,
+						struct vm_fault *vmf)
 {
 	struct snd_pcm_substream *substream = area->vm_private_data;
 	struct snd_pcm_runtime *runtime;
-	struct page * page;
 	
 	if (substream == NULL)
-		return NOPAGE_SIGBUS;
+		return VM_FAULT_SIGBUS;
 	runtime = substream->runtime;
-	page = virt_to_page(runtime->status);
-	get_page(page);
-	if (type)
-		*type = VM_FAULT_MINOR;
-	return page;
+	vmf->page = virt_to_page(runtime->status);
+	get_page(vmf->page);
+	return 0;
 }
 
 static struct vm_operations_struct snd_pcm_vm_ops_status =
 {
-	.nopage =	snd_pcm_mmap_status_nopage,
+	.fault =	snd_pcm_mmap_status_fault,
 };
 
 static int snd_pcm_mmap_status(struct snd_pcm_substream *substream, struct file *file,
@@ -3061,26 +3058,23 @@ static int snd_pcm_mmap_status(struct sn
 /*
  * mmap control record
  */
-static struct page * snd_pcm_mmap_control_nopage(struct vm_area_struct *area,
-						 unsigned long address, int *type)
+static int snd_pcm_mmap_control_fault(struct vm_area_struct *area,
+						struct vm_fault *vmf)
 {
 	struct snd_pcm_substream *substream = area->vm_private_data;
 	struct snd_pcm_runtime *runtime;
-	struct page * page;
 	
 	if (substream == NULL)
-		return NOPAGE_SIGBUS;
+		return VM_FAULT_SIGBUS;
 	runtime = substream->runtime;
-	page = virt_to_page(runtime->control);
-	get_page(page);
-	if (type)
-		*type = VM_FAULT_MINOR;
-	return page;
+	vmf->page = virt_to_page(runtime->control);
+	get_page(vmf->page);
+	return 0;
 }
 
 static struct vm_operations_struct snd_pcm_vm_ops_control =
 {
-	.nopage =	snd_pcm_mmap_control_nopage,
+	.fault =	snd_pcm_mmap_control_fault,
 };
 
 static int snd_pcm_mmap_control(struct snd_pcm_substream *substream, struct file *file,
@@ -3117,10 +3111,10 @@ static int snd_pcm_mmap_control(struct s
 #endif /* coherent mmap */
 
 /*
- * nopage callback for mmapping a RAM page
+ * fault callback for mmapping a RAM page
  */
-static struct page *snd_pcm_mmap_data_nopage(struct vm_area_struct *area,
-					     unsigned long address, int *type)
+static int snd_pcm_mmap_data_fault(struct vm_area_struct *area,
+						struct vm_fault *vmf)
 {
 	struct snd_pcm_substream *substream = area->vm_private_data;
 	struct snd_pcm_runtime *runtime;
@@ -3130,33 +3124,30 @@ static struct page *snd_pcm_mmap_data_no
 	size_t dma_bytes;
 	
 	if (substream == NULL)
-		return NOPAGE_SIGBUS;
+		return VM_FAULT_SIGBUS;
 	runtime = substream->runtime;
-	offset = area->vm_pgoff << PAGE_SHIFT;
-	offset += address - area->vm_start;
-	snd_assert((offset % PAGE_SIZE) == 0, return NOPAGE_SIGBUS);
+	offset = vmf->pgoff << PAGE_SHIFT;
 	dma_bytes = PAGE_ALIGN(runtime->dma_bytes);
 	if (offset > dma_bytes - PAGE_SIZE)
-		return NOPAGE_SIGBUS;
+		return VM_FAULT_SIGBUS;
 	if (substream->ops->page) {
 		page = substream->ops->page(substream, offset);
-		if (! page)
-			return NOPAGE_OOM; /* XXX: is this really due to OOM? */
+		if (!page)
+			return VM_FAULT_SIGBUS;
 	} else {
 		vaddr = runtime->dma_area + offset;
 		page = virt_to_page(vaddr);
 	}
 	get_page(page);
-	if (type)
-		*type = VM_FAULT_MINOR;
-	return page;
+	vmf->page = page;
+	return 0;
 }
 
 static struct vm_operations_struct snd_pcm_vm_ops_data =
 {
 	.open =		snd_pcm_mmap_data_open,
 	.close =	snd_pcm_mmap_data_close,
-	.nopage =	snd_pcm_mmap_data_nopage,
+	.fault =	snd_pcm_mmap_data_fault,
 };
 
 /*

-- 

