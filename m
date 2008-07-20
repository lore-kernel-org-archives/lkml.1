Return-Path: <linux-kernel-owner+w=401wt.eu-S1754208AbYGTUMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208AbYGTUMT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 16:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbYGTUML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 16:12:11 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:40549 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbYGTUMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 16:12:10 -0400
Message-ID: <48839BF4.6010603@s5r6.in-berlin.de>
Date: Sun, 20 Jul 2008 22:11:32 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: dma_alloc_coherent() on PPC32: physical addresses above 2G possible?
References: <488385A7.4010509@s5r6.in-berlin.de>	<20080720114358.6c88e048@infradead.org>	<4883913F.9040706@s5r6.in-berlin.de> <20080720123900.02677e6e@infradead.org>
In-Reply-To: <20080720123900.02677e6e@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Sun, 20 Jul 2008 21:25:51 +0200
> Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>> 	if (dev->needs_dma_mask_workaround)
>> 		pci_set_consistent_dma_mask(pdev, DMA_31BIT_MASK);
>> 	allocate_something_special;
>> 	if (dev->needs_dma_mask_workaround)
>> 		pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
...
> something like this.
> But realistically, how many consistent/coherent allocations do you have?
> some ring buffers and other one time stuff surely... but not after that?

It's for DMA programs (i.e. lists of descriptors), not for the data DMA
buffers themselves.  FireWire controllers have several DMA contexts for
isochronous and asynchronous reception and transmission, and some
others.  Only context programs for isochronous reception need the
workaround.

We are dynamically appending new descriptors during runtime.  I.e. the
affected allocations happen during setup of the DMA context and
sometimes while the DMA context is active.  Particularly, in
drivers/firewire/fw-ohci.c:
	ohci_allocate_iso_context
		context_init
			context_add_buffer  <--
and
	ohci_queue_iso
		ohci_queue_iso_receive_dualbuffer
			context_get_descriptors
				context_add_buffer  <--

The other unaffected context types use context_add_buffer too.
-- 
Stefan Richter
-=====-==--- -=== =-=--
http://arcgraph.de/sr/
