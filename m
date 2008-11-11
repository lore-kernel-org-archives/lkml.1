Return-Path: <linux-kernel-owner+w=401wt.eu-S1755835AbYKKJge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835AbYKKJge (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 04:36:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbYKKJgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 04:36:21 -0500
Received: from mail.gmx.net ([213.165.64.20]:50369 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755490AbYKKJgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 04:36:19 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX198eP0O5Kl8gAMCDfg4+HXtR4mWW4iNoB4RrHT+7P
	ScuyyCLK9nKzgl
Date: Tue, 11 Nov 2008 10:36:24 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
cc: maciej.sosnowski@intel.com, dan.j.williams@intel.com,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: Re: [PATCH 2/4 v1] i.MX31: Image Processing Unit DMA and IRQ drivers
In-Reply-To: <Pine.LNX.4.64.0811071512500.4513@axis700.grange>
Message-ID: <Pine.LNX.4.64.0811111029120.4565@axis700.grange>
References: <Pine.LNX.4.64.0811071454000.4513@axis700.grange>
 <Pine.LNX.4.64.0811071512500.4513@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(moved to LKML and added Haavard as the author of dw_dmac and DMA_SLAVE 
support to cc:)

On Fri, 7 Nov 2008, Guennadi Liakhovetski wrote:

> Now to the problems I encountered with the dmaengine framework. Basically 
> I was unable to find out how I can release specific transfer-descriptors 
> without using ->device_terminate_all(), and channels without unregistering 
> the client.
> 
> I did see the DMA_CTRL_ACK flag, but it looks like it is used 
> inconsistently in various drivers. In the header it is described as
> 
>  * @DMA_CTRL_ACK - the descriptor cannot be reused until the client
>  * 	acknowledges receipt, i.e. has has a chance to establish any
>  * 	dependency chains
> 
> but I haven't found any way to actually "acknowledge receipt" of the 
> descriptor. There are two macros in dmaengine.h: async_tx_ack() and 
> async_tx_test_ack() but their implementation doesn't look right: 
> async_tx_ack() does just
> 
> 	tx->flags |= DMA_CTRL_ACK;
> 
> and async_tx_test_ack()
> 
> 	return (tx->flags & DMA_CTRL_ACK) == DMA_CTRL_ACK;
> 
> So, instead of using this flag to say "do not release until acked" it now 
> means "acked, can be released?" In ipu_idmac.c I have to be able to 
> release specific transfer-descriptors, so, I added a .tx_free() pointer to 
> struct dma_async_tx_descriptor.
> 
> As for releasing channels - there is a dma_chan_cleanup() function, which 
> calls the .device_free_chan_resources() method in struct dma_device and 
> decremts channel's refcount, but this doesn't seem to lead to the 
> chan->client_count counter being decremented, i.e., 
> dma_clients_notify_removed() never gets called as it, probably, should be. 
> I have no solution to this problem, so, releasing specific channels in 
> ipu_idmac.c currently doesn't work.

I still have no solution to this ->client_count problem. Is this a bug and 
there should be a way to release a channel (including decrementint the 
client_count) without unregistering the client, or am I missing something?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
