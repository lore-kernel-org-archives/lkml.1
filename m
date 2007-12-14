Return-Path: <linux-kernel-owner+w=401wt.eu-S1763434AbXLND1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763434AbXLND1G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 22:27:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbXLND0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 22:26:55 -0500
Received: from lixom.net ([66.141.50.11]:45668 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821AbXLND0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 22:26:55 -0500
Date: Thu, 13 Dec 2007 21:32:21 -0600
From: Olof Johansson <olof@lixom.net>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Shannon Nelson <shannon.nelson@intel.com>,
       Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH v2] dmaengine: Simple DMA memcpy test client
Message-ID: <20071214033221.GA23365@lixom.net>
References: <1195832076-13022-1-git-send-email-hskinnemoen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1195832076-13022-1-git-send-email-hskinnemoen@atmel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2007 at 04:34:36PM +0100, Haavard Skinnemoen wrote:
> This client tests DMA memcpy using various lengths and various offsets
> into the source and destination buffers. It will initialize both
> buffers with a know pattern and verify that the DMA engine copies the
> requested region and nothing more.
> 
> Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>

Hi,

First of all: Thanks for sharing this, it's quite useful! I've been
playing around with this a bit today, and I've been seeing some odd
behaviour.

It seems that once a channel is allocated to dmatest, it will never be
freed, i.e. the drivers device_free_chan_resources will never be called
on it. Looking at the dma stack, I'm not sure just where it's expected
to happen. Once the channel is allocated, the dma_chan_get/put calls all
just modify the per-cpu variables, and nothing will ever boil down to a
call to kref_put() of the refcount until the _driver_ is deregistered.
Not even deregistering the client seems to do it.

Or am I missing something here? Shannon? Dan?

I happened to catch it due to a BUG_ON() in my device_alloc_chan_resources
that checked to make sure it wasn't allocated twice without a free
inbetween. It hit on the second load of the dmatest module, since they
were never freed on unload.


-Olof
