Return-Path: <linux-kernel-owner+w=401wt.eu-S1760036AbYBRNWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760036AbYBRNWy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 08:22:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751186AbYBRNWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 08:22:46 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:58797 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750995AbYBRNWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 08:22:45 -0500
Date: Mon, 18 Feb 2008 14:22:39 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: "Dan Williams" <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, "Shannon Nelson" <shannon.nelson@intel.com>,
       "David Brownell" <david-b@pacbell.net>, kernel@avr32linux.org,
       "Francis Moreau" <francis.moro@gmail.com>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "Vladimir A. Barinov" <vbarinov@ru.mvista.com>,
       "Pierre Ossman" <drzeus-list@drzeus.cx>
Subject: Re: [RFC v3 4/7] dmaengine: Add slave DMA interface
Message-ID: <20080218142239.43809da7@dhcp-252-066.norway.atmel.com>
In-Reply-To: <e9c3a7c20802161206n6fdece7dk3c442144458ad472@mail.gmail.com>
References: <1202834638-9009-1-git-send-email-hskinnemoen@atmel.com>
	<1202834638-9009-2-git-send-email-hskinnemoen@atmel.com>
	<1202834638-9009-3-git-send-email-hskinnemoen@atmel.com>
	<1202834638-9009-4-git-send-email-hskinnemoen@atmel.com>
	<e9c3a7c20802131107x4c9e6859p3bc6527b19c416cb@mail.gmail.com>
	<20080213202402.22818482@siona>
	<20080215105302.1e4251a3@dhcp-252-066.norway.atmel.com>
	<e9c3a7c20802161206n6fdece7dk3c442144458ad472@mail.gmail.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Feb 2008 13:06:54 -0700
"Dan Williams" <dan.j.williams@intel.com> wrote:

> I like the direction of the patch, i.e. splitting out separate
> functionality into separate structs.  However, I do not want to break
> the model of clients sourcing the operations and drivers sinking them
> which dma_slave_descriptor appears to do.  How about adding a
> scatterlist pointer and an 'unmap_type' to the common descriptor?
> Where unmap_type selects between,  page, single, sg, or no-unmap.
> Drivers already know the length and direction.

But there are currently no operations available for submitting
scatterlists as a single descriptor -- the client iterates over the
scatterlist and submits one descriptor for each entry. So there's no
way you can associated a scatterlist with a single descriptor. You can
perhaps attach it to the last one, but that may get you into trouble if
the transfer is terminated early for some reason.

I don't think the pure source/sink model is very realistic -- clients
can't just submit DMA transfers and then forget about them. They must
at the very least check the status and take appropriate action if there
was an error. They must also notify the driver that the descriptor can
be reused (although I guess if a client doesn't care about the result
it can do this immediately after submission, but I really think clients
_should_ care about the result.)

And since they need to do some sort of cleanup anyway, they might as
well unmap the buffers (or call some dma_memcpy_finish() type of
function that does it for them.)

The clients certainly know the length and direction too, but they don't
necessarily know the physical address since the mapping is done by a
"middle layer". I guess that's the main problem with the model I'm
proposing.

How about we add a kind of "address cookie" struct like this (feel free
to suggest better names):

struct dma_buf_addr {
	void *cpu_addr;
	dma_addr_t dma_addr;
};

The client initializes the cpu_addr part and passes the struct to
dma_async_memcpy_buf_to_buf() or whatever, the middle layer sets the
dma_addr after mapping the buffer (or page), and the client passes the
same struct to dma_finish_memcpy_buf_to_buf(). Which will then be able
to unmap both buffers appropriately.

This will also eliminate the hack in crypto/async_tx/async_xor.c and
make HIGHMEM64G work again.

Scatterlists currently don't have any middle-layer support, so we can
ignore them for now and let the client take the full responsibility of
mapping and unmapping the buffers. If we were to add some middle-layer
functions for dealing with scatterlists, I don't think they would need
any special treatment -- the dma address is kept in the struct
scatterlist array passed by the client, so it would work pretty much
the same way without any special treatment.

Alternatively, we could convert the whole API to use scatterlists. But
that's probably overdoing it.

Btw, this discussion is a bit off-topic for the patch in question, but
it's an issue that needs to be resolved.

Haavard
