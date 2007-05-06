Return-Path: <linux-kernel-owner+w=401wt.eu-S1753564AbXEFUng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564AbXEFUng (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 16:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbXEFUng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 16:43:36 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:34984 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753564AbXEFUng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 16:43:36 -0400
Date: Sun, 6 May 2007 22:44:29 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Dan Kruchinin <dubalom@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-mm1
Message-ID: <20070506204429.GB10396@uranus.ravnborg.org>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org> <463D11A8.3090708@simon.arlott.org.uk> <a8f16e2b0705052130g37307df1vb7bd8a178d3130a@mail.gmail.com> <a8f16e2b0705052133pf8db82eoaae32281bedeafd6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8f16e2b0705052133pf8db82eoaae32281bedeafd6@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 06, 2007 at 08:33:48AM +0400, Dan Kruchinin wrote:
> > 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm1/
> 
> I have the following message after kernel compilation:
> 
> ---
> ...
> WARNING: init/built-in.o - Section mismatch: reference to .init.text:
> from .text between 'rest_init' (at offset 0x11e) and 'try_name'

Covered in another mail.

> ...
> ...
> WARNING: drivers/dma/async_tx.o - Section mismatch: reference to
> .init.data: from .data after 'channel_table' (at offset 0x20)
> WARNING: drivers/dma/async_tx.o - Section mismatch: reference to
> .init.data: from .data after 'channel_table' (at offset 0x24)
> WARNING: drivers/dma/async_tx.o - Section mismatch: reference to
> .init.data: from .data after 'channel_table' (at offset 0x28)
> WARNING: drivers/dma/async_tx.o - Section mismatch: reference to
> .init.data: from .data after 'channel_table' (at offset 0x2c)
> WARNING: drivers/dma/async_tx.o - Section mismatch: reference to
> .init.data: from .data after 'channel_table' (at offset 0x30)
> WARNING: drivers/dma/async_tx.o - Section mismatch: reference to
> .init.data: from .data after 'channel_table' (at offset 0x34)
> WARNING: drivers/dma/async_tx.o - Section mismatch: reference to
> .init.data: from .data after 'channel_table' (at offset 0x38)
> WARNING: drivers/dma/async_tx.o - Section mismatch: reference to
> .init.data: from .data after 'channel_table' (at offset 0x3c)
> WARNING: drivers/dma/async_tx.o - Section mismatch: reference to
> .init.data: from .data after 'channel_table' (at offset 0x40)
> WARNING: drivers/dma/async_tx.o - Section mismatch: reference to
> .init.data: from .data after 'channel_table' (at offset 0x44)

We have following code:
/* guarantee that calls that happen before init will not find a channel */
static struct chan_ref_percpu __initdata null_chan_ref[NR_CPUS];

static struct chan_ref_percpu *channel_table[] = {
	DMA_TX_ARRAY_INIT(null_chan_ref)
};

The DMA_TX_ARRAY_INIT is some macro obscufation that serves no
real use and just hide a few assignements.
What happens here is that we assign channel_table a value
that are used as cover-up until the real assignment happens
in the init function.
So the only real way to fix this seems to remove the otherwise correct
__initdata mark on null_chan_ref.
Thats one pointer wasted pr. cpu (in total NR_CPUS).

	Sam
