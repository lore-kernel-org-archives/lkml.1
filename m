Return-Path: <linux-kernel-owner+w=401wt.eu-S1758012AbZBSAah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012AbZBSAah (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 19:30:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755608AbZBSAaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 19:30:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43529 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754623AbZBSAaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 19:30:08 -0500
Date: Wed, 18 Feb 2009 16:30:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: Bo.Yang@lsi.com, James.Bottomley@HansenPartnership.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Winston.Austria@lsi.com
Subject: Re: [PATCH 5/9] scsi: megaraid_sas - Add memory support required by
 0x73 controller
Message-Id: <20090218163002.5d1be3ce.akpm@linux-foundation.org>
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C33A07FBD2@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C33A07FB75@cosmail02.lsi.com>
	<4B6A08C587958942AA3002690DD4F8C33A07FBD2@cosmail02.lsi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Feb 2009 08:37:00 -0800
"Yang, Bo" <Bo.Yang@lsi.com> wrote:

> Add memory support required by 0x73 controller
> 
> ...
> 
> +static int
> +megasas_skinny_mem_alloc(struct megasas_instance *instance)
> +{
> +       u8              i = 0, mem_alloc_done = 0;
> +       u32             *virt, ind, num_bk = 0;
> +       dma_addr_t      paddr;
> +       u32              mem_alloc_size = MEGASAS_SKINNY_SZ_MEM_BK * 256;
> +       u32             *mem_tb = instance->skinny_mm_tb;
> +
> +       instance->skinny_mm_tb = pci_alloc_consistent(instance->pdev,
> +                                MEGASAS_SKINNY_MAX_NUM_MEM_BK*sizeof(u32),
> +                                &instance->skinny_mm_tb_h);
> +
> +       memset(instance->skinny_mm_tb, 0,
> +               MEGASAS_SKINNY_MAX_NUM_MEM_BK * sizeof(u32));

This will crash the kernel if pci_alloc_consistent() failed.

> +       instance->skinny_mm_alloc_ind = 0;
> +
> +       while (!mem_alloc_done) {
> +
> +                       virt = pci_alloc_consistent(instance->pdev,
> +                                                        mem_alloc_size,
> +                                                        &paddr);

This code would be less of a mess if this block wasn't using 16-column
indenting.

Also, the entire patch appears to be using spacespacespacespace for
indenting.  Kernel code should use hard tabs.


> +                       if (virt) {
> +                               num_bk = (mem_alloc_size/
> +                                               MEGASAS_SKINNY_SZ_MEM_BK);
> +
> +                               for (ind = 0; ind < num_bk; ind++) {
> +                                       if (instance->skinny_mm_alloc_ind <
> +                                               MEGASAS_SKINNY_MAX_NUM_MEM_BK) {
> +                                               *mem_tb = (u32)(paddr+
> +                                               (MEGASAS_SKINNY_SZ_MEM_BK*ind));
> +                                               mem_tb++;
> +                                               instance->skinny_mm_alloc_ind++;

geeze that is hard to read.

> +                                       } else {
> +                                               mem_alloc_done = 1;
> +                                       }
> +                               }
> +
> +                               instance->skinny_mm_bk[i].vir   = virt;
> +                               instance->skinny_mm_bk[i].paddr = paddr;
> +                               instance->skinny_mm_bk[i].sz = mem_alloc_size;
> +                       } else {
> +                               if (mem_alloc_size > MEGASAS_SKINNY_SZ_MEM_BK)
> +                                       mem_alloc_size = mem_alloc_size / 2;
> +                       }
> +       }

The problem with this sort of decreasing-allocation-size loop is that
the earlier, large-sized allocations will generate large stack traces
from within the page allocator if they fail.

Normally we would just suppress those expected-to-happen failures with
__GFP_NOWARN.  But thanks to pci_alloc_consistent() interface
deficiencies, this cannot be done here.

> +       if (instance->skinny_mm_alloc_ind == 0)
> +               return -1;
> +
> +       return 0;
> +}
> +

