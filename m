Return-Path: <linux-kernel-owner+w=401wt.eu-S1754548AbYJJHdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbYJJHdm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 03:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266AbYJJHdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 03:33:33 -0400
Received: from sh.osrg.net ([192.16.179.4]:50616 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585AbYJJHdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 03:33:32 -0400
Date: Fri, 10 Oct 2008 16:32:07 +0900
To: yinghai@kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, grundler@parisc-linux.org, matthew@wil.cx,
       jbarnes@virtuousgeek.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: print out DMA mask info
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <48EEF713.6050502@kernel.org>
References: <86802c440810092156i18bb7699vb8e90d52accad781@mail.gmail.com>
	<20081010150815B.fujita.tomonori@lab.ntt.co.jp>
	<48EEF713.6050502@kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081010163145W.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 09 Oct 2008 23:32:51 -0700
Yinghai Lu <yinghai@kernel.org> wrote:

> in ehci_pci_setup() 
> 
>         switch (pdev->vendor) {
>         case PCI_VENDOR_ID_NVIDIA:
>                 /* NVidia reports that certain chips don't handle
>                  * QH, ITD, or SITD addresses above 2GB.  (But TD,
>                  * data buffer, and periodic schedule are normal.)
>                  */
>                 switch (pdev->device) {
>                 case 0x003c:    /* MCP04 */
>                 case 0x005b:    /* CK804 */
>                 case 0x00d8:    /* CK8 */
>                 case 0x00e8:    /* CK8S */
>                         if (pci_set_consistent_dma_mask(pdev,
>                                                 DMA_31BIT_MASK) < 0)
>                                 ehci_warn(ehci, "can't enable NVidia "
>                                         "workaround for >2GB RAM\n");
>                         break;
>                 }
>                 break;
>         }
> 
> so that is strange silicon bug for old ck804 and before. dma_mask could be 32bit. but consistent_dma_mask is 31bit
> mcp55 is ok.

Hmm, looks broken hardware...


> >> qlogic qla2xxx  and emulex lpfc dma mask and consistent_dma_mask is different...
> >> could have some story for them
> > 
> > Check out qla2xxx again. I think that it uses dma_set_mask() to set
> > dma_mask. qla2xxx uses the same value for both dma_mask and
> > consistent_dma_mask.
> > 
> > lpfc had better set 64bit to consistent_dma_mask but as I said in the
> > previous mail, not setting consistent_dma_mask doesn't cause any
> > problem. It means that some IOMMUs (uses consistent_dma_mask properly)
> > allocates an address < 4GB in alloc_coherent() and some IOMMUs alloc
> > address > 4GB. lpfc can handle both anyway.
> > 
> > 
> >> at least gart iommu is honoring the consistent dma mask.
> >> by calling dma_alloc_coherent_mask(dev, flag)
> > 
> > Well, that's because I wrote gart's alloc_coherent and introduced
> > dma_alloc_coherent_mask. ;)
> 
> oh. it is in tip

Yeah, it's in tip. But the current gart code uses coherent_dma_mask
properly (GART in tip works in the same way as the current
GART). IIRC, other X86 hardware IOMMUs (VT-d, Calgary, AMD) uses
dma_mask in dma_alloc_coherent (AMD in tip uses coherent_dma_mask).



> >> if device could use 64 bit coherent dma mask, that is driver problem...
> > 
> > Can you be more specific? As I wrote above, if 64bit-dma-capable
> > devices don't set consistent_dma_mask, we don't have any problem.
> 
> then can we remove consistent_dma_mask? just use dma_mask instead for all.

I don't think we can. One architecture needs it. The above usb
chip seems to need it.
