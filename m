Return-Path: <linux-kernel-owner+w=401wt.eu-S1752604AbYKRDQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604AbYKRDQ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 22:16:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751760AbYKRDQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 22:16:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34588 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751754AbYKRDQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 22:16:18 -0500
Date: Mon, 17 Nov 2008 19:15:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Leon Woestenberg" <leon.woestenberg@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Tejun Heo <tj@kernel.org>
Subject: Re: pci_map_sg() does not coalesce adjacent physical memory? x86
Message-Id: <20081117191532.c1c849f5.akpm@linux-foundation.org>
In-Reply-To: <c384c5ea0811171354u5d6f5be6v857f92b1e75769c7@mail.gmail.com>
References: <c384c5ea0811171354u5d6f5be6v857f92b1e75769c7@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc's added)

On Mon, 17 Nov 2008 22:54:33 +0100 "Leon Woestenberg" <leon.woestenberg@gmail.com> wrote:

> Hello,
> 
> pci_map_sg() does not coalesce the scattergather list for me on x86.

In which kernel version(s)?

> Is this expected? Documentation mentions that coalescing is typically
> done by pci_map_sg().
> 
> Manually traversing scatterlists that describe large user space
> allocations I found that on my system 25% reduction of list length can
> be achieved.
> 
> 
> static int sgm_map_to_table(struct sg_mapping_t *sgm)
> {
>         int i, j = 0;
>         dma_addr_t addr = sg_dma_address(&sgm->sgl[0]);
>         unsigned int len = sg_dma_len(&sgm->sgl[0]);
>         dma_addr_t cont_addr = addr;
>         unsigned int cont_len = len;
>         for (i = 0; i < sgm->mapped_pages - 1; i++) {
>                 dma_addr_t next = sg_dma_address(&sgm->sgl[i + 1]);
>                 len = sg_dma_len(&sgm->sgl[i]);
>                 printk(KERN_DEBUG "%04d: addr=0x%08x length=0x%08x\n",
> i, addr, len);
>                 /* page i + 1 is non-contiguous with page i? */
>                 if (next != addr + len) {
>                         /* TODO create entry here (we could overwrite i) */
>                         printk(KERN_DEBUG "%4d: cont_addr=0x%08x
> cont_len=0x%08x\n",
>                                 j++, cont_addr, cont_len);
>                         cont_addr = next;
>                         cont_len = 0;
>                 }
>                 /* add page i + 1 to current contiguous block */
>                 cont_len += len;
>                 /* goto page i + 1 */
>                 addr = next;
>         }
>         /* TODO create entry here  (we could overwrite i) */
>         printk(KERN_DEBUG "%04d: addr=0x%08x length=0x%08x\n", i, addr, len);
>         printk(KERN_DEBUG "%4d: cont_addr=0x%08x length=0x%08x\n",
> j++, cont_addr, cont_len);
> }
> 

