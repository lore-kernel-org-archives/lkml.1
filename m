Return-Path: <linux-kernel-owner+w=401wt.eu-S1756496AbXD1RRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496AbXD1RRh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 13:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756497AbXD1RRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 13:17:37 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:37689 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756496AbXD1RRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:17:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer;
        b=uMEpvFqOLYkUVRD2caL8cEoftlDejfn5u1sBWhLpllL6CVnYdeJS3g0N4RaRupW9XExl3V3BHi9/DRQceSBaxp8p0jKcE8xUTFjILEF3Xwzv8WwGQZq7ErUXj9HXlnPfD+ICxIJ93i9BE0bTdKKksqZjrnVdczUS9y+m+4hvA1g=
Subject: [PATCH] Re: More than 2Gb problem (dvb related) ?
From: Jon Burgess <jburgess777@googlemail.com>
To: linux-dvb@linuxtv.org, v4l-dvb-maintainer@linuxtv.org
Cc: Markus Rechberger <mrechberger@gmail.com>,
       Gregoire Favre <Gregoire.Favre@gmail.com>, linux-kernel@vger.kernel.org,
       Lee Revell <rlrevell@joe-job.com>
In-Reply-To: <75b66ecd0704271506x595dfb6bqe0ef4fd153818501@mail.gmail.com>
References: <20070427111047.GB10284@gmail.com>
	 <d9def9db0704271346i1556c59dgad222d5de7d919f6@mail.gmail.com>
	 <1177711220.26292.20.camel@localhost.localdomain>
	 <75b66ecd0704271506x595dfb6bqe0ef4fd153818501@mail.gmail.com>
Content-Type: multipart/mixed; boundary="=-1Uh6ORzNGQ+bY5sZUrAC"
Date: Sat, 28 Apr 2007 18:17:32 +0100
Message-Id: <1177780652.7152.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1Uh6ORzNGQ+bY5sZUrAC
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, 2007-04-27 at 18:06 -0400, Lee Revell wrote:
> On 4/27/07, Jon Burgess <jburgess777@googlemail.com> wrote:
> > Interesting - I see similar symptoms after upgrading my PC:
> > * old PC was AMD Athlon 64 3000 w/ 2GB of RAM which had no issues
> > * new PC is a Intel Core 2 Duo w/ 4GB of RAM and fails in the way you
> > describe.
> 
> Driver using an incorrect DMA mask?
> 
> Lee

It appears the problem is that the driver is using streamed PCI and
needs to explicitly sync the data otherwise it breaks when the SWIOTLB
is in use. A call to pci_unmap_sg() was missing too.

This patch is against the current v4l-dvb HG tree.

I've only tested the change with a budget-ci card.

	Jon

Signed-off-by: Jon Burgess <jburgess777@googlemail.com>

--=-1Uh6ORzNGQ+bY5sZUrAC
Content-Disposition: attachment; filename=dvb-dma-sync.patch
Content-Type: text/x-patch; name=dvb-dma-sync.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

diff -r a8b2a0738f4e linux/drivers/media/common/saa7146_core.c
--- a/linux/drivers/media/common/saa7146_core.c	Thu Apr 19 17:07:37 2007 -0300
+++ b/linux/drivers/media/common/saa7146_core.c	Sat Apr 28 17:44:38 2007 +0100
@@ -152,6 +152,7 @@ char *saa7146_vmalloc_build_pgtable(stru
 		return NULL;
 	}
 
+	pt->nents = pages;
 	slen = pci_map_sg(pci,pt->slist,pages,PCI_DMA_FROMDEVICE);
 	if (0 != saa7146_pgtable_build_single(pci, pt, pt->slist, slen)) {
 		return NULL;
@@ -165,6 +166,7 @@ void saa7146_pgtable_free(struct pci_dev
 	if (NULL == pt->cpu)
 		return;
 	pci_free_consistent(pci, pt->size, pt->cpu, pt->dma);
+	pci_unmap_sg(pci, pt->slist, pt->nents, PCI_DMA_FROMDEVICE);
 	pt->cpu = NULL;
 	kfree(pt->slist);
 	pt->slist = NULL;
diff -r a8b2a0738f4e linux/drivers/media/dvb/ttpci/av7110.c
--- a/linux/drivers/media/dvb/ttpci/av7110.c	Thu Apr 19 17:07:37 2007 -0300
+++ b/linux/drivers/media/dvb/ttpci/av7110.c	Sat Apr 28 17:10:38 2007 +0100
@@ -1246,6 +1246,9 @@ static void vpeirq(unsigned long data)
 	if (!budget->feeding1 || (newdma == olddma))
 		return;
 
+	/* Ensure streamed PCI data is synced to CPU */
+	pci_dma_sync_sg_for_cpu(budget->dev->pci, budget->pt.slist, budget->pt.nents, PCI_DMA_FROMDEVICE);
+	
 #if 0 /* keep */
 	/* track rps1 activity */
 	printk("vpeirq: %02x Event Counter 1 0x%04x\n",
diff -r a8b2a0738f4e linux/drivers/media/dvb/ttpci/budget-core.c
--- a/linux/drivers/media/dvb/ttpci/budget-core.c	Thu Apr 19 17:07:37 2007 -0300
+++ b/linux/drivers/media/dvb/ttpci/budget-core.c	Sat Apr 28 17:09:13 2007 +0100
@@ -184,6 +184,9 @@ static void vpeirq(unsigned long data)
 	if (budget->feeding == 0 || newdma == olddma)
 		return;
 
+	/* Ensure streamed PCI data is synced to CPU */
+	pci_dma_sync_sg_for_cpu(budget->dev->pci, budget->pt.slist, budget->pt.nents, PCI_DMA_FROMDEVICE);
+	
 	if (newdma > olddma) {	/* no wraparound, dump olddma..newdma */
 		count = newdma - olddma;
 		dvb_dmx_swfilter_packets(&budget->demux, mem + olddma, count / 188);
diff -r a8b2a0738f4e linux/include/media/saa7146.h
--- a/linux/include/media/saa7146.h	Thu Apr 19 17:07:37 2007 -0300
+++ b/linux/include/media/saa7146.h	Sat Apr 28 17:27:36 2007 +0100
@@ -70,6 +70,7 @@ struct saa7146_pgtable {
 	unsigned long	offset;
 	/* used for custom pagetables (used for example by budget dvb cards) */
 	struct scatterlist *slist;
+	int             nents;
 };
 
 struct saa7146_pci_extension_data {

--=-1Uh6ORzNGQ+bY5sZUrAC--

