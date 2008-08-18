Return-Path: <linux-kernel-owner+w=401wt.eu-S1754002AbYHRXHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbYHRXHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 19:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751758AbYHRXHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 19:07:24 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:40739 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751704AbYHRXHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 19:07:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=V7MTtGmn19T3Tvp3KY61Ux03L5QVQIRlrGdJTzAXD8VCn+GHAhYRcRj9zUId2Tc0BSmON2CZGKxbnRTrOn3QCG72lh1CVg10d7yOuxzyev96dVgsvwojnJv+CPVRvO55KYmrkZ0+kd4NsfksDORv31/UzUFeKuo7QHea+ukc7L8=  ;
X-YMail-OSG: c8fDx60VM1nvIIlICBnn0nHqWsazxdKX16sWaO_tUcnxO6goK41hER7TaN4ywaWjVF67bxQnylJLjRZcwucYjuBKCU0.uuntx1MrV708hc9QAcJewd3KV.VsvXmrMAz.q8g-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Subject: [patch 2.6.27-rc3] at91_mci: don't use coherent dma buffers
Date: Mon, 18 Aug 2008 16:07:21 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>, Andrew Victor <linux@maxim.org.za>,
       Nicolas Ferre <nicolas.ferre@atmel.com>,
       Russell King <rmk@arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808181607.21516.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

At91_mci is abusing dma_free_coherent(), which may not be called
with IRQs disabled.  I saw "mkfs.ext3" on an MMC card objecting
voluminously as each write completed:

 WARNING: at arch/arm/mm/consistent.c:368 dma_free_coherent+0x2c/0x224()
 [<c002726c>] (dump_stack+0x0/0x14) from [<c00387d4>] (warn_on_slowpath+0x4c/0x68)
 [<c0038788>] (warn_on_slowpath+0x0/0x68) from [<c0028768>] (dma_free_coherent+0x2c/0x224)
  r6:00008008 r5:ffc06000 r4:00000000
 [<c002873c>] (dma_free_coherent+0x0/0x224) from [<c01918ac>] (at91_mci_irq+0x374/0x420)
 [<c0191538>] (at91_mci_irq+0x0/0x420) from [<c0065d9c>] (handle_IRQ_event+0x2c/0x6c)
 ...

This bug has been around for a LONG time.  The MM warning is
from late 2005, but the driver merged a year later ... so I'm
puzzled why nobody noticed this before now.

The fix involves noting that this buffer shouldn't be DMA-coherent;
it's just used for normal DMA writes.  So replace it with standard
kmalloc() buffering and DMA mapping calls.

This is the quickie fix.  A better one would not rely on allocating
large bounce buffers.  (Note that dma_alloc_coherent could have failed
too, but that case was ignored... kmalloc is a bit more likely to
fail though.)

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

---
 drivers/mmc/host/at91_mci.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/drivers/mmc/host/at91_mci.c
+++ b/drivers/mmc/host/at91_mci.c
@@ -621,12 +621,21 @@ static void at91_mci_send_command(struct
 				if (cpu_is_at91sam9260 () || cpu_is_at91sam9263())
 					if (host->total_length < 12)
 						host->total_length = 12;
-				host->buffer = dma_alloc_coherent(NULL,
-						host->total_length,
-						&host->physical_address, GFP_KERNEL);
+
+				host->buffer = kmalloc(host->total_length, GFP_KERNEL);
+				if (!host->buffer) {
+					pr_debug("Can't alloc tx buffer\n");
+					cmd->error = -ENOMEM;
+					mmc_request_done(host->mmc, host->request);
+					return;
+				}
 
 				at91_mci_sg_to_dma(host, data);
 
+				host->physical_address = dma_map_single(NULL,
+						host->buffer, host->total_length,
+						DMA_TO_DEVICE);
+
 				pr_debug("Transmitting %d bytes\n", host->total_length);
 
 				at91_mci_write(host, ATMEL_PDC_TPR, host->physical_address);
@@ -694,7 +703,10 @@ static void at91_mci_completed_command(s
 	cmd->resp[3] = at91_mci_read(host, AT91_MCI_RSPR(3));
 
 	if (host->buffer) {
-		dma_free_coherent(NULL, host->total_length, host->buffer, host->physical_address);
+		dma_unmap_single(NULL,
+				host->physical_address, host->total_length,
+				DMA_TO_DEVICE);
+		kfree(host->buffer);
 		host->buffer = NULL;
 	}
 
