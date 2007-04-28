Return-Path: <linux-kernel-owner+w=401wt.eu-S1756127AbXD1UPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127AbXD1UPg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 16:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756120AbXD1UPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 16:15:36 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:38494 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031201AbXD1UOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 16:14:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer;
        b=DpEaflowf6BZFKzGFwuThQWKNNDyrD9VfzQ8o2f2zcBg7NVq8LzhsaihTGFojSlAFSxSz4OPqZas+HZhoIAqPNyXQRXdmf8YwAnHjzVm7CWf2LzQbxZI2K5kpCvui3kWRXkrzq17ptILy2PxNsZFrcVzibLGKochNurkRNBL508=
Subject: Re: [PATCH] Re: More than 2Gb problem (dvb related) ?
From: Jon Burgess <jburgess777@googlemail.com>
To: linux-dvb@linuxtv.org
Cc: v4l-dvb-maintainer@linuxtv.org, Markus Rechberger <mrechberger@gmail.com>,
       Gregoire Favre <Gregoire.Favre@gmail.com>, linux-kernel@vger.kernel.org,
       Lee Revell <rlrevell@joe-job.com>
In-Reply-To: <1177780652.7152.14.camel@localhost.localdomain>
References: <20070427111047.GB10284@gmail.com>
	 <d9def9db0704271346i1556c59dgad222d5de7d919f6@mail.gmail.com>
	 <1177711220.26292.20.camel@localhost.localdomain>
	 <75b66ecd0704271506x595dfb6bqe0ef4fd153818501@mail.gmail.com>
	 <1177780652.7152.14.camel@localhost.localdomain>
Content-Type: multipart/mixed; boundary="=-vN+Tpocaz9tTLPC7lTmt"
Date: Sat, 28 Apr 2007 21:14:37 +0100
Message-Id: <1177791277.5170.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-vN+Tpocaz9tTLPC7lTmt
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Sat, 2007-04-28 at 18:17 +0100, Jon Burgess wrote:
> On Fri, 2007-04-27 at 18:06 -0400, Lee Revell wrote:
> > On 4/27/07, Jon Burgess <jburgess777@googlemail.com> wrote:
> > > Interesting - I see similar symptoms after upgrading my PC:
> > > * old PC was AMD Athlon 64 3000 w/ 2GB of RAM which had no issues
> > > * new PC is a Intel Core 2 Duo w/ 4GB of RAM and fails in the way you
> > > describe.
> > 
> > Driver using an incorrect DMA mask?
> > 
> > Lee
> 
> It appears the problem is that the driver is using streamed PCI and
> needs to explicitly sync the data otherwise it breaks when the SWIOTLB
> is in use. A call to pci_unmap_sg() was missing too.
> 
> This patch is against the current v4l-dvb HG tree.
> 
> I've only tested the change with a budget-ci card.
> 
> 	Jon
> 
> Signed-off-by: Jon Burgess <jburgess777@googlemail.com>

While the above patch works, it seems the underlying causes is that
vmalloc_32() is providing memory above 4Gb on x86-64 which is not what
the driver expects. This same issue came up a few weeks ago with regards
to DRM on radeon http://lkml.org/lkml/2007/4/1/257

Andi Kleen included a patch to ensure vmalloc_32() returns memory <4Gb
in a patch which is currently in -mm
 http://kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc7/2.6.21-rc7-mm2/broken-out/x86_64-mm-vmalloc-32.patch

With this patch applied the current driver appears to work OK. 

Attached is a smaller patch against v4l-dvb which just adds the missing
pci_unmap_sg() call.

	Jon

Signed-off-by: Jon Burgess <jburgess777@googlemail.com>

--=-vN+Tpocaz9tTLPC7lTmt
Content-Disposition: attachment; filename=dvb-pci-unmap-sg.patch
Content-Type: text/x-patch; name=dvb-pci-unmap-sg.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

diff -r a8b2a0738f4e linux/drivers/media/common/saa7146_core.c
--- a/linux/drivers/media/common/saa7146_core.c	Thu Apr 19 17:07:37 2007 -0300
+++ b/linux/drivers/media/common/saa7146_core.c	Sat Apr 28 20:55:30 2007 +0100
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
diff -r a8b2a0738f4e linux/include/media/saa7146.h
--- a/linux/include/media/saa7146.h	Thu Apr 19 17:07:37 2007 -0300
+++ b/linux/include/media/saa7146.h	Sat Apr 28 18:06:47 2007 +0100
@@ -70,6 +70,7 @@ struct saa7146_pgtable {
 	unsigned long	offset;
 	/* used for custom pagetables (used for example by budget dvb cards) */
 	struct scatterlist *slist;
+	int             nents;
 };
 
 struct saa7146_pci_extension_data {

--=-vN+Tpocaz9tTLPC7lTmt--

