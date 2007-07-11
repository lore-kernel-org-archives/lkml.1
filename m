Return-Path: <linux-kernel-owner+w=401wt.eu-S1760871AbXGKQnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760871AbXGKQnt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 12:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751769AbXGKQnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 12:43:41 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:54278 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbXGKQnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 12:43:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZKgQ6FFFWlcenwXYgbCe+op0WNxXM0dPQ7aUU9eAZzZs9lbmX+YhyKI5OS+R5HkYuiucYR/jVMtQXOfnriOzUJRR9H41wdlfABhvEghokgx+an8PxihNURVN4OmzuuOVi7pTVng+2mE2YIGlB6AMTQ5Z5UDQ2E5IGRjmWT8ZL1o=
Message-ID: <e9c3a7c20707110943w5539167ei41f6d1928d1b33a6@mail.gmail.com>
Date: Wed, 11 Jul 2007 09:43:39 -0700
From: "Dan Williams" <dan.j.williams@gmail.com>
To: "Peter Pearse" <peter.pearse@arm.com>
Subject: Re: [RFC][PATCH] DMA: Expand dmaengine implementation for more DMACs
Cc: linux-kernel@vger.kernel.org, shannon.nelson@intel.com
In-Reply-To: <000501c7bd82$9f2fb310$821ba8c0@Emea.Arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Ace9gp7Xn5S76TvjSiiYft+C95Y48g==>
	 <000501c7bd82$9f2fb310$821ba8c0@Emea.Arm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/3/07, Peter Pearse <peter.pearse@arm.com> wrote:
> Hi,
>
> The existing DMAC used by the dmaengine API (Intel IOAT) assumes all
> possible clients can use any available DMA channel.
>
> Some other DMACs restrict particular peripherals to particular DMA channels.
>
> The patch below (against v2.6.22-rc7) extends the dmaengine implementation
> to allow such DMACs to differentiate between clients.
>
Hi Peter,

Have a look at:
http://marc.info/?l=linux-raid&m=118290909528910&w=2
http://marc.info/?l=linux-raid&m=118290909523734&w=2

It seems your requirement could be satisfied by a natural extension of
the 'dma_cap_mask' implementation.  'dma_cap_mask' allows clients to
only be notified of channels that meet a certain capability profile.

However since your driver is pretty much guaranteed to be the only
dmaengine driver in the system you can safely do something like the
following in your client callback:

static enum dma_state_client
my_dma_client_callback(struct dma_client *client,
			struct dma_chan *chan, enum dma_state state)
{
	struct dma_device *dma_dev;
	struct my_platform_specific_dma *plat_dma_dev;
	
	dma_dev = chan->device;
	plat_dma_dev = container_of(dma_dev, struct my_platform_specific_dma, dma_dev);

	if (!plat_dma_dev->platform_specific_capability)
		return DMA_DUP;

	. . .
}

> Regards
>
> Peter Pearse
>

--
Dan
