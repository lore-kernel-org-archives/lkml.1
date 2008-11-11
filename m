Return-Path: <linux-kernel-owner+w=401wt.eu-S1754895AbYKKSNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbYKKSNq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 13:13:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbYKKSNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 13:13:38 -0500
Received: from mail.gmx.net ([213.165.64.20]:54167 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752060AbYKKSNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 13:13:37 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+kZBwEBS6kjAgDNa9LkdmwQZBOLroCYWi/RjuueZ
	6QbGNm+PB1PWx1
Date: Tue, 11 Nov 2008 19:13:48 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Dan Williams <dan.j.williams@intel.com>
cc: linux-kernel@vger.kernel.org, maciej.sosnowski@intel.com,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: Re: [PATCH 2/4 v1] i.MX31: Image Processing Unit DMA and IRQ drivers
In-Reply-To: <e9c3a7c20811110737m4b17e0fcp45bcec86f937b9ea@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0811111856500.8435@axis700.grange>
References: <Pine.LNX.4.64.0811071454000.4513@axis700.grange> 
 <Pine.LNX.4.64.0811071512500.4513@axis700.grange> 
 <Pine.LNX.4.64.0811111029120.4565@axis700.grange>
 <e9c3a7c20811110737m4b17e0fcp45bcec86f937b9ea@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

On Tue, 11 Nov 2008, Dan Williams wrote:

> On Tue, Nov 11, 2008 at 2:36 AM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > I still have no solution to this ->client_count problem. Is this a bug and
> > there should be a way to release a channel (including decrementint the
> > client_count) without unregistering the client, or am I missing something?
> >
> 
> Hi Guennadi,
> 
> I am currently working on improving this situation:
> 
> http://marc.info/?l=linux-kernel&m=122463374500746&w=2
> 
> Please have a look.

Thanks for the pointer, I looked at it.

1. ASYNC_TX_ACK: one either sets this flag immediately on a descriptor in 
flags for ->device_prep_dma_memcpy() (like in 
dma_async_memcpy_buf_to_buf()), which would mean "may be recycled 
automatically" or you don't set it, then the descriptor is kept, until you 
call async_tx_ack() on it. Are you going to preserve the async_tx_ack() 
implementation? In this case dma-device drivers have to scan their 
descriptors to do garbage-collection?... Wouldn't it be better to 
introduce an explicit call to free a descriptor, like in this my patch: 
http://marc.info/?l=linux-arm-kernel&m=122607472721145&w=2 (see the last 
hank for include/linux/dmaengine.h)?

2. channel client-count: am I right, that with the current implementation 
one cannot free a channel in a way, that its client_count got decremented, 
and the ->device_free_chan_resources() method be called for it? Is this 
going to be addressed too or I am missing something and channel freeing 
has to be done differently?

3. you write

> 3b/ Remove the client registration infrastructure

which means, there should be an interface to free a channel explicitly? 
because until now unregistering the client was the only way (that I found) 
to free channels...

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
