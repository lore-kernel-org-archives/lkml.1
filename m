Return-Path: <linux-kernel-owner+w=401wt.eu-S1752807AbXJWTXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbXJWTXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 15:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbXJWTXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 15:23:09 -0400
Received: from europa.telenet-ops.be ([195.130.137.75]:56178 "EHLO
	europa.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbXJWTXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 15:23:07 -0400
Date: Tue, 23 Oct 2007 21:23:00 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jens Axboe <jens.axboe@oracle.com>, Boaz Harrosh <bharrosh@panasas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH 09/10] Change table chaining layout
In-Reply-To: <20071023112738.GA13847@elte.hu>
Message-ID: <Pine.LNX.4.64.0710232120080.21337@anakin>
References: <Pine.LNX.4.64.0710222137520.7105@anakin>
 <alpine.LFD.0.999.0710221248120.30120@woody.linux-foundation.org>
 <20071022211617.31f5c63d@the-village.bc.nu>
 <alpine.LFD.0.999.0710221343330.30120@woody.linux-foundation.org>
 <20071022224343.4abf3c96@the-village.bc.nu>
 <alpine.LFD.0.999.0710221444220.30120@woody.linux-foundation.org>
 <471DBEF4.4030303@panasas.com> <20071023094142.GD5059@kernel.dk>
 <20071023103351.GA2795@elte.hu> <20071023105615.GI5059@kernel.dk>
 <20071023112738.GA13847@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2007, Ingo Molnar wrote:
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > > Linus' latest tree, which has your SG-list enhancements included, 
> > > certainly works fine here and does not have the problems of the 
> > > first iteration.
> > 
> > That's good to hear :-)
> > 
> > I have a series of pending patches where I've collected fallout 
> > patches from people and some from myself here:
> > 
> > http://git.kernel.dk/?p=linux-2.6-block.git;a=shortlog;h=sg
> > 
> > or pullable from
> > 
> > git://git.kernel.dk/inux-2.6-block.git sg
> 
> i've attached your fixes as a diff against linus-latest below - for 
> those who'd like to have it in patch form.

The below are still needed for m68k
---

m68k: sg fallout

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/kernel/dma.c               |    2 +-
 drivers/scsi/atari_NCR5380.c         |    5 ++---
 drivers/scsi/sun3x_esp.c             |    4 ++--
 net/ieee80211/ieee80211_crypt_tkip.c |    2 +-
 net/ieee80211/ieee80211_crypt_wep.c  |    2 +-
 net/mac80211/wep.c                   |    2 +-
 6 files changed, 8 insertions(+), 9 deletions(-)

--- a/arch/m68k/kernel/dma.c
+++ b/arch/m68k/kernel/dma.c
@@ -9,10 +9,10 @@
 #include <linux/dma-mapping.h>
 #include <linux/device.h>
 #include <linux/kernel.h>
+#include <linux/scatterlist.h>
 #include <linux/vmalloc.h>
 
 #include <asm/pgalloc.h>
-#include <asm/scatterlist.h>
 
 void *dma_alloc_coherent(struct device *dev, size_t size,
 			 dma_addr_t *handle, gfp_t flag)
--- a/drivers/scsi/atari_NCR5380.c
+++ b/drivers/scsi/atari_NCR5380.c
@@ -477,10 +477,9 @@ static void merge_contiguous_buffers(Scs
 
 	for (endaddr = virt_to_phys(cmd->SCp.ptr + cmd->SCp.this_residual - 1) + 1;
 	     cmd->SCp.buffers_residual &&
-	     virt_to_phys(page_address(cmd->SCp.buffer[1].page) +
-			  cmd->SCp.buffer[1].offset) == endaddr;) {
+	     virt_to_phys(sg_virt(&cmd->SCp.buffer[1])) == endaddr;) {
 		MER_PRINTK("VTOP(%p) == %08lx -> merging\n",
-			   page_address(cmd->SCp.buffer[1].page), endaddr);
+			   page_address(sg_page(&cmd->SCp.buffer[1])), endaddr);
 #if (NDEBUG & NDEBUG_MERGING)
 		++cnt;
 #endif
--- a/drivers/scsi/sun3x_esp.c
+++ b/drivers/scsi/sun3x_esp.c
@@ -332,8 +332,8 @@ static void dma_mmu_get_scsi_sgl (struct
     struct scatterlist *sg = sp->SCp.buffer;
 
     while (sz >= 0) {
-	    sg[sz].dma_address = dvma_map((unsigned long)page_address(sg[sz].page) +
-					   sg[sz].offset, sg[sz].length);
+	    sg[sz].dma_address = dvma_map((unsigned long)sg_virt(&sg[sz]),
+					  sg[sz].length);
 	    sz--;
     }
     sp->SCp.ptr=(char *)((unsigned long)sp->SCp.buffer->dma_address);
--- a/net/ieee80211/ieee80211_crypt_tkip.c
+++ b/net/ieee80211/ieee80211_crypt_tkip.c
@@ -24,7 +24,7 @@
 #include <net/ieee80211.h>
 
 #include <linux/crypto.h>
-#include <asm/scatterlist.h>
+#include <linux/scatterlist.h>
 #include <linux/crc32.h>
 
 MODULE_AUTHOR("Jouni Malinen");
--- a/net/ieee80211/ieee80211_crypt_wep.c
+++ b/net/ieee80211/ieee80211_crypt_wep.c
@@ -21,7 +21,7 @@
 #include <net/ieee80211.h>
 
 #include <linux/crypto.h>
-#include <asm/scatterlist.h>
+#include <linux/scatterlist.h>
 #include <linux/crc32.h>
 
 MODULE_AUTHOR("Jouni Malinen");
--- a/net/mac80211/wep.c
+++ b/net/mac80211/wep.c
@@ -16,7 +16,7 @@
 #include <linux/crypto.h>
 #include <linux/err.h>
 #include <linux/mm.h>
-#include <asm/scatterlist.h>
+#include <linux/scatterlist.h>
 
 #include <net/mac80211.h>
 #include "ieee80211_i.h"

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
