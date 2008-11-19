Return-Path: <linux-kernel-owner+w=401wt.eu-S1752552AbYKSFU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbYKSFU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 00:20:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750747AbYKSFUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 00:20:12 -0500
Received: from sh.osrg.net ([192.16.179.4]:37936 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707AbYKSFUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 00:20:11 -0500
Date: Wed, 19 Nov 2008 14:19:25 +0900
To: akpm@linux-foundation.org
Cc: leon.woestenberg@gmail.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com,
       tj@kernel.org
Subject: Re: pci_map_sg() does not coalesce adjacent physical memory? x86
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081117191532.c1c849f5.akpm@linux-foundation.org>
References: <c384c5ea0811171354u5d6f5be6v857f92b1e75769c7@mail.gmail.com>
	<20081117191532.c1c849f5.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081119142016E.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2008 19:15:32 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> (cc's added)
> 
> On Mon, 17 Nov 2008 22:54:33 +0100 "Leon Woestenberg" <leon.woestenberg@gmail.com> wrote:
> 
> > Hello,
> > 
> > pci_map_sg() does not coalesce the scattergather list for me on x86.
> 
> In which kernel version(s)?
> 
> > Is this expected? Documentation mentions that coalescing is typically
> > done by pci_map_sg().

Hm, what document did you read? We might need to fix it.

pci_map_sg() is not a typical place to coalesce the entries of the sg
list are physically adjacent. The block layer is the typical place.

The dma operations are free to coalesce the entries that physically
and virtually adjacent but there are not many that does.

For example, by default, on x86, only AMD GART (x86_64) dma operation
coalesces such entries.


> > Manually traversing scatterlists that describe large user space
> > allocations I found that on my system 25% reduction of list length can
> > be achieved.
> > 
> > 
> > static int sgm_map_to_table(struct sg_mapping_t *sgm)
> > {
> >         int i, j = 0;
> >         dma_addr_t addr = sg_dma_address(&sgm->sgl[0]);
> >         unsigned int len = sg_dma_len(&sgm->sgl[0]);
> >         dma_addr_t cont_addr = addr;
> >         unsigned int cont_len = len;
> >         for (i = 0; i < sgm->mapped_pages - 1; i++) {
> >                 dma_addr_t next = sg_dma_address(&sgm->sgl[i + 1]);
> >                 len = sg_dma_len(&sgm->sgl[i]);
> >                 printk(KERN_DEBUG "%04d: addr=0x%08x length=0x%08x\n",
> > i, addr, len);
> >                 /* page i + 1 is non-contiguous with page i? */
> >                 if (next != addr + len) {
> >                         /* TODO create entry here (we could overwrite i) */
> >                         printk(KERN_DEBUG "%4d: cont_addr=0x%08x
> > cont_len=0x%08x\n",
> >                                 j++, cont_addr, cont_len);
> >                         cont_addr = next;
> >                         cont_len = 0;
> >                 }
> >                 /* add page i + 1 to current contiguous block */
> >                 cont_len += len;
> >                 /* goto page i + 1 */
> >                 addr = next;
> >         }
> >         /* TODO create entry here  (we could overwrite i) */
> >         printk(KERN_DEBUG "%04d: addr=0x%08x length=0x%08x\n", i, addr, len);
> >         printk(KERN_DEBUG "%4d: cont_addr=0x%08x length=0x%08x\n",
> > j++, cont_addr, cont_len);
> > }

What's kinda of your driver? If it's a SCSI (or block) driver, you
don't need this trick.

I don't think that inventing a homegrown function to coalesce sg
entries in a driver is a good idea. If you really need this, it's
would be better to have a generic function to coalesce sg entries and
modify the block layer to use it (and your driver can use it too).
