Return-Path: <linux-kernel-owner+w=401wt.eu-S1755887AbYIQWhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887AbYIQWhF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 18:37:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752991AbYIQWgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 18:36:55 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:42983 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbYIQWgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 18:36:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=u2GM5NakhqdKdedHyeJyAX+lz/reXhi3HDqEuFclSbdMxxAQMfqJJ2of1WoDyaH9WH
         mksxkDz6zL5F3U44rJ3oYcg+QXADpZFEhXMqDaEFD+9b8IBO1NoR2u4FMn21yOj6rL4A
         n1JnbfwcI9T9MdPicOkqux1OsvRpJdgQCqCkQ=
Message-ID: <e9c3a7c20809171536i189e3816x8572055d932c3c4c@mail.gmail.com>
Date: Wed, 17 Sep 2008 15:36:53 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Timur Tabi" <timur@freescale.com>
Subject: Re: dmaengine.c: question about device_alloc_chan_resources
Cc: lkml <linux-kernel@vger.kernel.org>,
       "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>
In-Reply-To: <48D02589.8070601@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48D02589.8070601@freescale.com>
X-Google-Sender-Auth: 0b5c24c3c519243f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2008 at 2:30 PM, Timur Tabi <timur@freescale.com> wrote:
> Dan, Haavard, et al,
>
> I am making some fixes to the Freescale DMA driver (drivers/dma/fsldma.c), and
> I've come across a situation I don't understand.  Specifically, I have an issue
> with the return values from fsl_dma_alloc_chan_resources(), which is fsldma's
> device_alloc_chan_resources() function.
>
> fsldma calls dma_async_device_register() for each DMA controller it finds.  The
> problem is that when I use the dmatest driver, this results in
> device_alloc_chan_resources() being called multiple times for the same DMA
> channel.  When this happens, fsl_dma_alloc_chan_resources() must return -1
> otherwise fsldma will hang during unload if the dmatest driver is also loaded.
> The hang occurs in dma_async_device_unregister(), when it calls
> wait_for_completion().
>
> Here's what happens:
>
> 1) fsldma finds one DMA controller with four DMA channels.  It creates all the
> channel objects and then calls dma_async_device_register().
>
> 2) Via dma_clients_notify_available(), dmatest is notified that there's a new
> DMA resource.  It stores those four channels in its dmatest_channels object.
>
> 3) fsldma fins another DMA controller with four DMA channels.  Again, it creates
> all the channel objects and then calls dma_async_device_register().
>
> 4) dma_clients_notify_available() is called again.  This time, however, it tells
> dmatest about *eight* channels, not just the four additional ones.  It does this
> because fsl_dma_alloc_chan_resources() returns 1 every time it's called.
>
> The result is that the some DMA channel will appear twice in dmatest's channel
> list.  For example, I added a bunch of printks to dma_test_add_channnel:
>

I believe the problem is that dmatest is telling the core to take
multiple references on a channel.  Take a look at
net/core/dev.c:netdev_dma_event and
crypto:asynx_tx/async_tx.c:dma_channel_add_remove both of those check
to see if they already have a refence to the channel.

> dmatest: Started 1 threads using dma2chan1
> dmatest_add_channel:372 chan=df1f2a50
> dmatest_add_channel:382 dtc->chan=df1f2898
> dmatest_add_channel:382 dtc->chan=df1f2a50

^...right here we should be returning DMA_DUP rather than DMA_ACK.

> dmatest_add_channel:382 dtc->chan=df1f2898

--
Dan
