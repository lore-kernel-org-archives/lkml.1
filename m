Return-Path: <linux-kernel-owner+w=401wt.eu-S1753815AbYIPVbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815AbYIPVbL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 17:31:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbYIPVa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 17:30:58 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:39095 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbYIPVa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 17:30:57 -0400
Message-ID: <48D02589.8070601@freescale.com>
Date: Tue, 16 Sep 2008 16:30:49 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Dan Williams <dan.j.williams@intel.com>
Subject: dmaengine.c: question about device_alloc_chan_resources
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan, Haavard, et al,

I am making some fixes to the Freescale DMA driver (drivers/dma/fsldma.c), and
I've come across a situation I don't understand.  Specifically, I have an issue
with the return values from fsl_dma_alloc_chan_resources(), which is fsldma's
device_alloc_chan_resources() function.

fsldma calls dma_async_device_register() for each DMA controller it finds.  The
problem is that when I use the dmatest driver, this results in
device_alloc_chan_resources() being called multiple times for the same DMA
channel.  When this happens, fsl_dma_alloc_chan_resources() must return -1
otherwise fsldma will hang during unload if the dmatest driver is also loaded.
The hang occurs in dma_async_device_unregister(), when it calls
wait_for_completion().

Here's what happens:

1) fsldma finds one DMA controller with four DMA channels.  It creates all the
channel objects and then calls dma_async_device_register().

2) Via dma_clients_notify_available(), dmatest is notified that there's a new
DMA resource.  It stores those four channels in its dmatest_channels object.

3) fsldma fins another DMA controller with four DMA channels.  Again, it creates
all the channel objects and then calls dma_async_device_register().

4) dma_clients_notify_available() is called again.  This time, however, it tells
dmatest about *eight* channels, not just the four additional ones.  It does this
because fsl_dma_alloc_chan_resources() returns 1 every time it's called.

The result is that the some DMA channel will appear twice in dmatest's channel
list.  For example, I added a bunch of printks to dma_test_add_channnel:

dmatest: Started 1 threads using dma2chan1
dmatest_add_channel:372 chan=df1f2a50
dmatest_add_channel:382 dtc->chan=df1f2898
dmatest_add_channel:382 dtc->chan=df1f2a50
dmatest_add_channel:382 dtc->chan=df1f2898
dmatest_add_channel:382 dtc->chan=df1f2a50

As you can see, df1f2898 appears twice, as does df1f2a50.

So my fix was to add this code to fsl_dma_alloc_chan_resources():

	/* Has this channel already been allocated? */
	if (fsl_chan->desc_pool)
		return -ENOMEM;

This fixes the hang, but I have a suspicion that it's still wrong.  When I look
at the other DMA device drivers, they don't do this.  For instance,
ioat_dma_alloc_chan_resources() does this:

	/* have we already been set up? */
	if (!list_empty(&ioat_chan->free_desc))
		return ioat_chan->desccount;

In other words, it returns the resources that have been allocated already.  But
if I do that, my driver hangs during an unload (if dmatest is loaded).

I think what's happening is that fsldma is the only DMA driver that calls
dma_async_device_register() more than once, and so it's exposing a bug in
dmaengine.c.  Can anyone confirm that?

-- 
Timur Tabi
Linux kernel developer at Freescale
