Return-Path: <linux-kernel-owner+w=401wt.eu-S1161605AbXD3AXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161605AbXD3AXj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 20:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161624AbXD3AXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 20:23:39 -0400
Received: from mail.gmx.net ([213.165.64.20]:46494 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1161605AbXD3AXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 20:23:37 -0400
X-Authenticated: #476490
X-Provags-ID: V01U2FsdGVkX1943Wwd0jN4vaBYOKKPu+Y6CVOegJAvHodK+xX+1A
	gSvfBW1QV/hWMV
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-dvb@linuxtv.org
Organization: ESCAPE GmbH EDV-Loesungen
To: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Re: [PATCH] Re: More than 2Gb problem (dvb related) ?
Date: Mon, 30 Apr 2007 02:22:36 +0200
User-Agent: KMail/1.9.4
Cc: Jon Burgess <jburgess777@googlemail.com>, linux-kernel@vger.kernel.org,
       v4l-dvb-maintainer@linuxtv.org, Lee Revell <rlrevell@joe-job.com>,
       Gregoire Favre <Gregoire.Favre@gmail.com>
References: <20070427111047.GB10284@gmail.com> <1177780652.7152.14.camel@localhost.localdomain> <1177791277.5170.11.camel@localhost.localdomain>
In-Reply-To: <1177791277.5170.11.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_MbTNG/A636/kEwY"
Message-Id: <200704300222.36934@orion.escape-edv.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_MbTNG/A636/kEwY
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Jon Burgess wrote:
> On Sat, 2007-04-28 at 18:17 +0100, Jon Burgess wrote:
> > On Fri, 2007-04-27 at 18:06 -0400, Lee Revell wrote:
> > > On 4/27/07, Jon Burgess <jburgess777@googlemail.com> wrote:
> > > > Interesting - I see similar symptoms after upgrading my PC:
> > > > * old PC was AMD Athlon 64 3000 w/ 2GB of RAM which had no issues
> > > > * new PC is a Intel Core 2 Duo w/ 4GB of RAM and fails in the way you
> > > > describe.
> > > 
> > > Driver using an incorrect DMA mask?
> > > 
> > > Lee
> > 
> > It appears the problem is that the driver is using streamed PCI and
> > needs to explicitly sync the data otherwise it breaks when the SWIOTLB
> > is in use. A call to pci_unmap_sg() was missing too.
> > 
> > This patch is against the current v4l-dvb HG tree.
> > 
> > I've only tested the change with a budget-ci card.
> > 
> > 	Jon
> > 
> > Signed-off-by: Jon Burgess <jburgess777@googlemail.com>
> 
> While the above patch works, it seems the underlying causes is that
> vmalloc_32() is providing memory above 4Gb on x86-64 which is not what
> the driver expects. This same issue came up a few weeks ago with regards
> to DRM on radeon http://lkml.org/lkml/2007/4/1/257
> 
> Andi Kleen included a patch to ensure vmalloc_32() returns memory <4Gb
> in a patch which is currently in -mm
>  http://kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc7/2.6.21-rc7-mm2/broken-out/x86_64-mm-vmalloc-32.patch
> 
> With this patch applied the current driver appears to work OK. 
> 
> Attached is a smaller patch against v4l-dvb which just adds the missing
> pci_unmap_sg() call.

Imo your patch is correct and should be applied.
Any objections?

After digging through the code, kernel DMA docs and the saa7146
datasheet, I think that we should remove the scatter-gatter voodoo
from the budget and av7110 driver. ;-)

What about the attached patch?
- easy to understand and maintain
- saves 1 page of memory (page table of the SAA7146 MMU)
- saves PCI bandwidth (SAA7146 does not read page table anymore)

Comments?

CU
Oliver

-- 
--------------------------------------------------------
VDR Remote Plugin 0.3.9 available at
http://www.escape-edv.de/endriss/vdr/
-------------------------------------------------------

--Boundary-00=_MbTNG/A636/kEwY
Content-Type: text/x-diff;
  charset="us-ascii";
  name="budget_dmabuf_simple.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="budget_dmabuf_simple.diff"

diff -r e9e1b86b7892 linux/drivers/media/dvb/ttpci/budget-core.c
--- a/linux/drivers/media/dvb/ttpci/budget-core.c	Mon Apr 23 07:41:13 2007 +0200
+++ b/linux/drivers/media/dvb/ttpci/budget-core.c	Mon Apr 30 01:29:42 2007 +0200
@@ -74,6 +74,7 @@ static int start_ts_capture(struct budge
 static int start_ts_capture(struct budget *budget)
 {
 	struct saa7146_dev *dev = budget->dev;
+	u32 dma_base = (u32) budget->dma;
 
 	dprintk(2, "budget: %p\n", budget);
 
@@ -137,16 +138,16 @@ static int start_ts_capture(struct budge
 	saa7146_write(dev, MC2, (MASK_08 | MASK_24));
 	mdelay(10);
 
-	saa7146_write(dev, BASE_ODD3, 0);
+	saa7146_write(dev, BASE_ODD3, dma_base);
 	if (budget->buffer_size > budget->buffer_height * budget->buffer_width) {
 		// using odd/even buffers
-		saa7146_write(dev, BASE_EVEN3, budget->buffer_height * budget->buffer_width);
+		saa7146_write(dev, BASE_EVEN3, dma_base + budget->buffer_height * budget->buffer_width);
 	} else {
 		// using a single buffer
-		saa7146_write(dev, BASE_EVEN3, 0);
-	}
-	saa7146_write(dev, PROT_ADDR3, budget->buffer_size);
-	saa7146_write(dev, BASE_PAGE3, budget->pt.dma | ME1 | 0x90);
+		saa7146_write(dev, BASE_EVEN3, dma_base);
+	}
+	saa7146_write(dev, PROT_ADDR3, dma_base + budget->buffer_size);
+	saa7146_write(dev, BASE_PAGE3, 0x90);
 
 	saa7146_write(dev, PITCH3, budget->buffer_width);
 	saa7146_write(dev, NUM_LINE_BYTE3,
@@ -190,9 +191,9 @@ static void vpeirq(unsigned long data)
 static void vpeirq(unsigned long data)
 {
 	struct budget *budget = (struct budget *) data;
-	u8 *mem = (u8 *) (budget->grabbing);
+	u8 *mem = budget->grabbing;
 	u32 olddma = budget->ttbp;
-	u32 newdma = saa7146_read(budget->dev, PCI_VDP3);
+	u32 newdma = saa7146_read(budget->dev, PCI_VDP3) - (u32) budget->dma;
 	u32 count;
 
 	/* nearest lower position divisible by 188 */
@@ -510,8 +511,9 @@ int ttpci_budget_init(struct budget *bud
 
 	ttpci_eeprom_parse_mac(&budget->i2c_adap, budget->dvb_adapter.proposed_mac);
 
-	if (NULL ==
-	    (budget->grabbing = saa7146_vmalloc_build_pgtable(dev->pci, budget->buffer_size, &budget->pt))) {
+	budget->grabbing = pci_alloc_consistent(dev->pci, budget->buffer_size,
+						&budget->dma);
+	if (NULL == budget->grabbing) {
 		ret = -ENOMEM;
 		goto err;
 	}
@@ -526,13 +528,15 @@ int ttpci_budget_init(struct budget *bud
 	if (bi->type != BUDGET_FS_ACTIVY)
 		saa7146_setgpio(dev, 2, SAA7146_GPIO_OUTHI);
 
-	if (budget_register(budget) == 0) {
+	if (budget_register(budget) == 0)
 		return 0;
-	}
+
 err:
 	i2c_del_adapter(&budget->i2c_adap);
 
-	vfree(budget->grabbing);
+	if (budget->grabbing)	
+		pci_free_consistent(dev->pci, budget->buffer_size,
+				    budget->grabbing, budget->dma);
 
 	dvb_unregister_adapter(&budget->dvb_adapter);
 
@@ -561,9 +565,8 @@ int ttpci_budget_deinit(struct budget *b
 
 	tasklet_kill(&budget->vpe_tasklet);
 
-	saa7146_pgtable_free(dev->pci, &budget->pt);
-
-	vfree(budget->grabbing);
+	pci_free_consistent(dev->pci, budget->buffer_size,
+			    budget->grabbing, budget->dma);
 
 	return 0;
 }
diff -r e9e1b86b7892 linux/drivers/media/dvb/ttpci/budget.h
--- a/linux/drivers/media/dvb/ttpci/budget.h	Mon Apr 23 07:41:13 2007 +0200
+++ b/linux/drivers/media/dvb/ttpci/budget.h	Mon Apr 30 01:32:53 2007 +0200
@@ -48,9 +48,6 @@ struct budget {
 	struct i2c_adapter i2c_adap;
 	struct budget_info *card;
 
-	unsigned char *grabbing;
-	struct saa7146_pgtable pt;
-
 	struct tasklet_struct fidb_tasklet;
 	struct tasklet_struct vpe_tasklet;
 
@@ -63,6 +60,8 @@ struct budget {
 	int ci_present;
 	int video_port;
 
+	void *grabbing;
+	dma_addr_t dma;
 	u32 buffer_width;
 	u32 buffer_height;
 	u32 buffer_size;

--Boundary-00=_MbTNG/A636/kEwY--

