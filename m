Return-Path: <linux-kernel-owner+w=401wt.eu-S1753554AbZKPQsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbZKPQsX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 11:48:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbZKPQsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 11:48:23 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:55349 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514AbZKPQsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 11:48:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=gmxCVQfQUerrPfL8kpNK2D/RW9edDX/OM+bju8FDIwMMp7gLKf+tflcwA3xVA0GrFj
         syr5XJZ6iLfPf2+G/tSMJAkI+eVKebDSMBtur+qVbDEwpXm9ijpCC0P1sszsyM5ZE3A8
         GC3dyjNZggx23gyZoySz+O+A5jARxpG6z81mY=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>, Jaroslav Kysela <perex@perex.cz>,
       Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, Wu Zhangjin <wuzhangjin@gmail.com>,
       Wu Zhangjin <wuzj@lemote.com>
Subject: [PATCH] MIPS: Fixups of ALSA memory maps
Date: Tue, 17 Nov 2009 00:48:14 +0800
Message-Id: <9cbcd06037c18288a6493459b8f3a6e1562eca77.1258389992.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, All

Seems this is MIPS specific, but it's not that easy to move this patch
into the arch/mips part, So, any better solution?

Thanks & Regards,
       Wu Zhangjin

------------------------

The user application mmap audio dma regions must be dma-coherent. This
patch fix it.

Without this patch, artsd will fail on boot, and mplayer will exit with
"Segmentation fault". (this happens on YeeLoong netbook, fuloong2f
mini pc with snd_cs5535 audio card)

This is originally from the to-mips branch of
http://dev.lemote.com/code/linux_loongson, and contributed by Yanhua
from Lemote Inc.

Reported-by: qiaochong <qiaochong@gmail.com>
Signed-off-by: Wu Zhangjin <wuzj@lemote.com>
---
 sound/core/pcm_native.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index ab73edf..2779b9a 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -3087,7 +3087,11 @@ static int snd_pcm_mmap_data_fault(struct vm_area_struct *area,
 			return VM_FAULT_SIGBUS;
 	} else {
 		vaddr = runtime->dma_area + offset;
+#if defined(__mips__) && defined(CONFIG_DMA_NONCOHERENT)
+		page = virt_to_page(CAC_ADDR(vaddr));
+#else
 		page = virt_to_page(vaddr);
+#endif
 	}
 	get_page(page);
 	vmf->page = page;
@@ -3202,6 +3206,11 @@ static int snd_pcm_mmap(struct file *file, struct vm_area_struct *area)
 	if (PCM_RUNTIME_CHECK(substream))
 		return -ENXIO;
 
+#if defined(__mips__) && defined(CONFIG_DMA_NONCOHERENT)
+	/* all mmap using uncached mode */
+	area->vm_page_prot = pgprot_noncached(area->vm_page_prot);
+	area->vm_flags |= (VM_RESERVED | VM_IO);
+#endif
 	offset = area->vm_pgoff << PAGE_SHIFT;
 	switch (offset) {
 	case SNDRV_PCM_MMAP_OFFSET_STATUS:
-- 
1.6.2.1

