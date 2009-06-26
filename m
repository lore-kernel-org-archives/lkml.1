Return-Path: <linux-kernel-owner+w=401wt.eu-S1753552AbZFZRoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbZFZRoZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 13:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbZFZRoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 13:44:17 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:46482 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbZFZRoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 13:44:17 -0400
Date: Fri, 26 Jun 2009 11:44:18 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Grant Grundler <grundler@parisc-linux.org>
Cc: Alexander Beregalov <a.beregalov@gmail.com>, linux-parisc@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31-rc1: parisc: multiple PCI BAR collisions
Message-ID: <20090626174418.GX19977@parisc-linux.org>
References: <a4423d670906260158q15080049ue516c3d454f4afbf@mail.gmail.com> <20090626170304.GA20871@lackof.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090626170304.GA20871@lackof.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 26, 2009 at 11:03:04AM -0600, Grant Grundler wrote:
> On Fri, Jun 26, 2009 at 12:58:22PM +0400, Alexander Beregalov wrote:
> > Hi
> > 
> > Hardware is HP j6000.
> > It cannot initialize many PCI devices (sym53c8xx, tulip, STI,
> > usb(onci)) and cannot boot (no root device).
> > Messages like this:
> > sym53c8xx 0:0:0f.0: device not available because of BAR 1 [0xf4005000
> > - 0xf40053ff] collisions.
> 
> I'm pretty sure this is a problem of the root bus resources not getting
> setup correctly. I'm not clear on what's wrong. jejb and willy are looking
> at it now as well.

This patch fixes it for me.

----

Fix PCI resource allocation on non-PAT SBA machines

We weren't marking the resources as memory resources, so they weren't
being found by pci_claim_resource().

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Reviewed-by: Grant Grundler <grundler@parisc-linux.org>

diff --git a/drivers/parisc/sba_iommu.c b/drivers/parisc/sba_iommu.c
index d46dd57..123d8fe 100644
--- a/drivers/parisc/sba_iommu.c
+++ b/drivers/parisc/sba_iommu.c
@@ -2057,6 +2057,7 @@ void sba_directed_lmmio(struct parisc_device *pci_hba, struct resource *r)
 		r->start = (base & ~1UL) | PCI_F_EXTEND;
 		size = ~ READ_REG32(reg + LMMIO_DIRECT0_MASK);
 		r->end = r->start + size;
+		r->flags = IORESOURCE_MEM;
 	}
 }
 
@@ -2093,4 +2094,5 @@ void sba_distributed_lmmio(struct parisc_device *pci_hba, struct resource *r )
 	size = (~READ_REG32(sba->sba_hpa + LMMIO_DIST_MASK)) / ROPES_PER_IOC;
 	r->start += rope * (size + 1);	/* adjust base for this rope */
 	r->end = r->start + size;
+	r->flags = IORESOURCE_MEM;
 }

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
