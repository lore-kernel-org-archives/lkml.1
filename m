Return-Path: <linux-kernel-owner+w=401wt.eu-S1753640AbYGTVgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640AbYGTVgY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 17:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750994AbYGTVgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 17:36:16 -0400
Received: from gate.crashing.org ([63.228.1.57]:52152 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbYGTVgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 17:36:16 -0400
Subject: Re: dma_alloc_coherent() on PPC32: physical addresses above 2G
	possible?
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <488385A7.4010509@s5r6.in-berlin.de>
References: <488385A7.4010509@s5r6.in-berlin.de>
Content-Type: text/plain
Date: Mon, 21 Jul 2008 07:35:55 +1000
Message-Id: <1216589755.11027.46.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-07-20 at 20:36 +0200, Stefan Richter wrote:
> Hi all,
> 
> I have to implement a workaround for a PCI device which gets into 
> trouble if descriptors are located at 32bit addresses, while 31bit 
> addresses are fine.  I would like to avoid this workaround on machines 
> on which dma_alloc_coherent() won't ever go at memory above 2 GB.
> 
> Is defined(CONFIG_PPC32) a safe test for this?  I'm under the impression 
> that defined(CONFIG_X86_32) is safe.

CONFIG_PPC32 -may- be safe today... the  current implementation
for DMA coherent machines seem to have been copied from x86 or so :-) It
sets GFP_DMA if the coherent_dma_mask < 32 bits, but we don't have
separate ZONE_NORMAL and ZONE_DMA anyway, so that is irrelevant. In any
case, it won't give you memory in highmem, so you should be safe.

In the  non-DMA coherent case, make sure you don't pass __GFP_HIGHMEM.

There's some work in progress to support swiotlb and more advanced DMA
mapping ops for PPC32 (using function pointers like PPC64), so things
will probably change. However, the need for 31 bits DMA seem to be
common enough that we should probably do something specific about it,
for example, ensure that lowmem is never > 2G (shouldn't be a big deal)
and thus make dma masks < 32 bits always clear __GFP_HIGHMEM from the
allocation mask.

Ben.


