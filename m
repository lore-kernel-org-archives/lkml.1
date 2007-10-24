Return-Path: <linux-kernel-owner+w=401wt.eu-S1761323AbXJXSRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761323AbXJXSRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 14:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757007AbXJXSRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 14:17:04 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:59446 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759026AbXJXSRB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 14:17:01 -0400
Date: Wed, 24 Oct 2007 20:16:16 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: "Dan Williams" <dan.j.williams@intel.com>
Cc: "Shannon Nelson" <shannon.nelson@intel.com>, linux-kernel@vger.kernel.org,
       "David Brownell" <david-b@pacbell.net>, kernel@avr32linux.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] DMA: Correct invalid assumptions in the Kconfig text
Message-ID: <20071024201616.02f87b20@siona>
In-Reply-To: <e9c3a7c20710240855j7bf1f0a6qa1d11af3a12910e5@mail.gmail.com>
References: <1193218705-16685-1-git-send-email-hskinnemoen@atmel.com>
	<e9c3a7c20710240855j7bf1f0a6qa1d11af3a12910e5@mail.gmail.com>
Organization: Atmel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007 08:55:58 -0700
"Dan Williams" <dan.j.williams@intel.com> wrote:
> > Don't get me wrong; I think Intel deserves lots of respect for
> > creating this framework. But this is also why I got a bit
> > disappointed when I discovered that it seems to be less generic
> > than I initially hoped.
> >
> 
> Patches welcome :-)

Sure, that's the plan, and this patch is a start, isn't it? I just
wanted to make sure that the generic-sounding DMA Engine API would
allow more "traditional" DMA controller functionality in addition to
all the high-end RAID and networking stuff.

> Part of the problem of supporting slave/device DMA along side generic
> memcpy/xor/memset acceleration is that it adds a number of caveats and
> restrictions to the interface.  One idea is to create another client
> layer, similar to async_tx, that can handle the architecture specific
> address, bus, and device pairing restrictions.  In other words make
> device-dma a superset of the generic offload capabilities and move it
> to its own channel management layer.

Yes, I've been thinking along those lines, and
Documentation/crypto/async-tx-api.txt seems to suggest something like
that for platform-specific extensions. More specifically, I'm thinking
about adding a few new structs which wrap around some of the existing
ones, like struct dma_async_tx_descriptor, adding new ops and data
members. So it will be sort of a generic, optional extension of the API.

If that works out well, we may also consider moving some of the
async_tx-specific fields into an extended struct of its own. But that
will be more of an optimization or cleanup. I don't want to hurt any
existing users.

Then we're going to need some new hooks for creating those extended
descriptors. This can be done either by adding more hooks in struct
dma_device or by creating another "subclass".

Yes, I'm mostly handwaving at this point, but I intend to follow up
with actual code soon. Unless someone else beats me to it, of course.

> > I'm not going to suggest any changes to the actual framework for
> > 2.6.24, but I think the _intention_ of the framework needs to be
> > clarified.
> >
> 
> Should this patch wait until the framework has been extended?

IMO, no. The first step I'm planning to do is to get the driver working
within the existing framework, i.e. as a pure memcpy offload
engine, and verify that it can indeed improve networking performance.
This would imply that the framework itself isn't Intel-specific even
though all the existing drivers are for Intel hardware. And I don't
think the proposed text makes any new promises that weren't there
before.

And I think it's important to clarify that what is meant to live under
drivers/dma isn't just RAID and networking acceleration engines -- it
is realy meant to be a generic DMA engine framework. If this isn't
true, I might as well stop writing the driver based on this framework
and instead focus on creating a new one.

But I'm pretty optimistic about being able to extend the API in a way
that will not hurt existing functionality and still provide what we
need to support embedded DMA controllers. In fact, it looks a lot
easier to do with the current incarnation of the API than it did
earlier.

> Otherwise, Acked-by: Dan Williams <dan.j.williams@intel.com>

Thanks. Are one of you going to pick it up as well?

Håvard
