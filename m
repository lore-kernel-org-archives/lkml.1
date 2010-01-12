Return-Path: <linux-kernel-owner+w=401wt.eu-S1753526Ab0ALIC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab0ALIC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 03:02:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753092Ab0ALICZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 03:02:25 -0500
Received: from mail.gmx.net ([213.165.64.20]:46134 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751495Ab0ALICY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 03:02:24 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX19whQBxkDNwFczlM7K8c7iieKsagGMi+ZOY8opdA9
	Ad+z0kI5R3kYK0
Date: Tue, 12 Jan 2010 09:02:26 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Dan Williams <dan.j.williams@intel.com>
cc: linux-kernel@vger.kernel.org,
       Maciej Sosnowski <maciej.sosnowski@intel.com>
Subject: Re: dmaengine: query current transfer status
In-Reply-To: <e9c3a7c21001111423i42b68f1bq661af793dec05f91@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1001120854470.4895@axis700.grange>
References: <Pine.LNX.4.64.1001111550270.6492@axis700.grange>
 <e9c3a7c21001111423i42b68f1bq661af793dec05f91@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jan 2010, Dan Williams wrote:

> On Mon, Jan 11, 2010 at 7:59 AM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > Hi
> >
> > I'm using the dmaengine API with an ASoC driver (soon to be submitted),
> > and I have to provide a callback to ALSA to query the progress of the
> > current transfer (the .pointer() method from struct snd_pcm_ops).
> > Currently I only can provide this information with a period size
> > precision. Wouldn't it make sense to add an optional hook to dmaengine for
> > that? I certainly could add this as a platform-specific extension to the
> > specific dmaengine driver, I'm using (shdma), but that'd be ugly. Ideas?
> > Specific proposals for the prototype? I could cook up a patch if there are
> > no principal objections against this.
> 
> No principal objections, but we already have a method for querying the
> status of a transaction ->device_is_tx_complete().  I'd rather change
> the semantics of this method to return the inflight state of the
> operation in addition to the channel's progress.

Yes, I was thinking about reusing it too, slthough, this would require 
modifying all existing dmaengine implementations and users of 
->device_is_tx_complete(), dma_async_is_tx_complete(), and 
dma_async_memcpy_complete() methods. Not implssible but a bit cumbersome 
in a single patch.

> Perhaps pass in a
> pointer to a new dma_tx_info (name?) struct

Yeah, I would suggest struct dma_tx_status, but that could be confusing 
with enum dma_status.

> that gets filled in with
> the cookie information in addition to the current position of the
> operation in question.
> 
> Something like:
> 
> struct dma_tx_info {
>      dma_cookie_t last;
>      dma_cookie_t used;
>      unsigned long pos;

dma_addr_t?

> }
> 
> enum dma_status (*device_is_tx_complete)(struct dma_chan *chan,
> dma_cookie_t cookie, struct dma_tx_info *info)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
