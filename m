Return-Path: <linux-kernel-owner+w=401wt.eu-S1757876AbZCSGSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876AbZCSGSu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 02:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754698AbZCSGSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 02:18:40 -0400
Received: from mail.renesas.com ([202.234.163.13]:38767 "EHLO
	mail04.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753543AbZCSGSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 02:18:39 -0400
X-AuditID: ac140387-0000000b000005fd-9c-49c1e3b56a61
Date: Thu, 19 Mar 2009 15:18:29 +0900
From: Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
Subject: Re: [PATCH] dmaengine: sh: Add support DMA-Engine driver for DMA of
	SuperH
In-reply-to: <e9c3a7c20903161546i5de80305r1b0df1605c7718d8@mail.gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux-sh <linux-sh@vger.kernel.org>, linux-kernel@vger.kernel.org,
       maciej.sosnowski@intel.com, Paul Mundt <lethal@linux-sh.org>
Message-id: <49C1E3B5.9050008@renesas.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=ISO-8859-1
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
References: <49B8AF67.8080309@renesas.com>
 <e9c3a7c20903161546i5de80305r1b0df1605c7718d8@mail.gmail.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Dan.

Thank you for your comments.

2009/3/17 Dan Williams <dan.j.williams@intel.com>:
 > On Wed, Mar 11, 2009 at 11:44 PM, Nobuhiro Iwamatsu
 > <iwamatsu.nobuhiro@renesas.com> wrote:
 >> This supports DMA-Engine driver for DMA of SuperH.
 >> This supported all DMA channels, and it was tested in SH7722/SH7780.
 >> This can not use with SH DMA API and can control this in Kconfig.
 >>
 >> Signed-off-by: Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
 >> Cc: Paul Mundt <lethal@linux-sh.org>
 >> Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
 >> Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>
 >> Cc: Dan Williams <dan.j.williams@intel.com>
 >> ---
 >>  arch/sh/drivers/dma/Kconfig  |   12 +-
 >>  arch/sh/drivers/dma/Makefile |    3 +-
 >>  arch/sh/include/asm/dma-sh.h |   11 +
 >>  drivers/dma/Kconfig          |    9 +
 >>  drivers/dma/Makefile         |    2 +
 >>  drivers/dma/shdma.c          |  743 ++++++++++++++++++++++++++++++++++++++++++
 >>  drivers/dma/shdma.h          |   65 ++++
 >>  7 files changed, 840 insertions(+), 5 deletions(-)
 >>  create mode 100644 drivers/dma/shdma.c
 >>  create mode 100644 drivers/dma/shdma.h
 >
 > Hi,
 >
 > I have not finished a full review but one problem jumps out, the use
 > of spin_lock_irqsave to protect against channel/descriptor
 > manipulations.  The highest level of protection that net_dma and
 > async_tx assume is spin_lock_bh.  It seems like the pieces of
 > sh_dmae_interrupt() that touch the descriptor can be moved to the
 > tasklet, then the locks can be downgraded.

Because a dmaengine core is not equivalent to the interrupt that is
severer than spin_lock_bh, is this to rearrange it in tasklet?

 >
 > Your other patch, to set the alignment in dmatest, makes me wonder if
 > this engine can handle unaligned accesses?  If it can not then set the
 > DMA_PRIVATE capability bit at device registration time to prevent
 > net_dma and other "public" clients from using these channels.  Public
 > clients assume that there are no alignment constraints.
 >

I thought to add it because the patch wanted to measure the
transaction speed with the thing which
was not considered to be aligned address / data size.
Depending on a device using DMA, there is the thing forcing aligning
it of forwarded data.
DMAC of SH has a register appointing transfer data size.
I control it by the following functions.

+struct sh_dmae_chan {
+	dma_cookie_t completed_cookie;	/* The maximum cookie completed */
+	spinlock_t desc_lock;			/* Descriptor operation lock */
+	struct list_head ld_queue;		/* Link descriptors queue */
+	struct dma_chan common;			/* DMA common channel */
+	struct device *dev;				/* Channel device */
+	struct resource reg;			/* Resource for register */
+	struct tasklet_struct tasklet;
+	int id;	/* Raw id of this channel */
+	char dev_id[16];	/* unique name per DMAC of channel */
+
+	/* Set chcr */
+	int (*set_chcr)(struct sh_dmae_chan *sh_chan, u32 regs);

This set up call from a device using dmaengine, and data appoint aligning it.

Best regards,
  Nobuhiro
-- 
Nobuhiro Iwamatsu

