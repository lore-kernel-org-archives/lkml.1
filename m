Return-Path: <linux-kernel-owner+w=401wt.eu-S1756782AbYBDPcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782AbYBDPcV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 10:32:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752438AbYBDPcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 10:32:07 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:63311 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753784AbYBDPcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 10:32:05 -0500
Date: Mon, 4 Feb 2008 16:32:00 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: "Dan Williams" <dan.j.williams@intel.com>
Cc: "David Brownell" <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       "Shannon Nelson" <shannon.nelson@intel.com>, kernel@avr32linux.org,
       "Francis Moreau" <francis.moro@gmail.com>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "Vladimir A. Barinov" <vbarinov@ru.mvista.com>,
       "Pierre Ossman" <drzeus-list@drzeus.cx>
Subject: Re: [RFC v2 0/5] dmaengine: Slave DMA interface and example users
Message-ID: <20080204163200.550481a7@dhcp-252-066.norway.atmel.com>
In-Reply-To: <e9c3a7c20801300939w7b73f5a6ld73bde8c3fada569@mail.gmail.com>
References: <1201630213-31900-1-git-send-email-hskinnemoen@atmel.com>
	<20080129215453.1e3758ab@siona>
	<200801292256.14553.david-b@pacbell.net>
	<20080130095641.39eaad13@dhcp-252-066.norway.atmel.com>
	<e9c3a7c20801300939w7b73f5a6ld73bde8c3fada569@mail.gmail.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2008 10:39:47 -0700
"Dan Williams" <dan.j.williams@intel.com> wrote:

> Agreed, the issue is how to do this without requiring an
> interrupt+callback sequence for each transaction or requiring the
> client to carry per transaction unmap-data.  For example NET_DMA never
> sees a dma_addr_t and assumes that all it needs to care about is the
> last transaction in a sequence.  Since it is alive for the duration of
> a transaction, we could put unmap data in dma_async_tx_descriptor
> along with an unmap function pointer since dma_unmap* routines have an
> equal number of parameters.  But I just got through making this
> structure smaller so maybe there is a better way.

I have to say I'm not crazy about the idea of adding more callbacks to
the descriptor...

The client must somehow know when the transfer is complete -- after
all, it has to call async_tx_ack() at some point. So additional
callbacks shouldn't be needed.

How about adding more variants of the "ack" function -- one for each
kind of transfer? For example, after an async_memcpy() transaction is
complete, the client must call async_memcpy_ack(), which could be an
inline function containing something along the lines of

static inline void async_memcpy_ack(struct dma_async_tx_descriptor *tx)
{
	struct dma_device *dma = tx->chan->device;

	dma_unmap_page(dma->dev, tx->src_phys, tx->len, DMA_TO_DEVICE);
	dma_unmap_page(dma->dev, tx->dst_phys, tx->len, DMA_FROM_DEVICE);
	async_tx_ack(tx);
}

which would evaluate to just async_tx_ack(tx) in most cases, since
dma_unmap_page() usually doesn't actually do anything.

This requires three additional fields in the dma_async_tx_descriptor
structure, but in many cases the driver needs these fields in its own
private descriptor wrapper anyway.

Haavard
