Return-Path: <linux-kernel-owner+w=401wt.eu-S1754986AbZFPI4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986AbZFPI4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 04:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754426AbZFPI4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 04:56:06 -0400
Received: from sh.osrg.net ([192.16.179.4]:57131 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753040AbZFPI4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 04:56:04 -0400
Date: Tue, 16 Jun 2009 17:55:59 +0900
To: malcolm.blaney@maptek.com.au
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org
Subject: Re: is_device_dma_capable
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <2e115de50906160123n20791768sd154621b0d95ca50@mail.gmail.com>
References: <2e115de50906160024r7c3140d6sc8744e4362d36ef8@mail.gmail.com>
	<20090616171029H.fujita.tomonori@lab.ntt.co.jp>
	<2e115de50906160123n20791768sd154621b0d95ca50@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090616175549Y.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 16 Jun 2009 17:56:00 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jun 2009 17:53:03 +0930
Malcom Blaney <malcolm.blaney@maptek.com.au> wrote:

> Hi Fujita,
> 
> 2009/6/16 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>:
> > You use X86_32, right?
> 
> I have CONFIG_X86_32=y in my config file.
> 
> >
> > In 2.6.25, X86_32 and X86_64 had the own dma_alloc_coherent
> > implementations; X86_32 accepted a device having dma_mask that is not
> > initialized however X86_64 didn't, I think.
> >
> > When we merged them, we chose to prohibit a device having dma_mask
> > that is not initialized. I'm not sure the DMA docs say this but IMO
> > it's good to require drivers to set up dma_mask (and
> > coherent_dma_mask) properly if the drivers want DMA.
> >
> 
> If you could point me in the direction of how to set these values
> correctly, I would appreciate it.

You hit the problem that a device that parport_pc_probe_port creates
but doesn't set up the dma_mask properly, right (I'm not familiar with
the driver at all so I might misunderstand something)?

If so, I guess that the following patch works (only compile tested).


diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
index 151bf5b..1af57b7 100644
--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -2271,6 +2271,9 @@ struct parport *parport_pc_probe_port(unsigned long int base,
 		if (IS_ERR(pdev))
 			return NULL;
 		dev = &pdev->dev;
+
+		dev->coherent_dma_mask = DMA_BIT_MASK(24);
+		dev->dma_mask = &dev->coherent_dma_mask;
 	}
 
 	ops = kmalloc(sizeof(struct parport_operations), GFP_KERNEL);
