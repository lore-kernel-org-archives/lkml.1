Return-Path: <linux-kernel-owner+w=401wt.eu-S1755533AbXJ0Ntu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbXJ0Ntu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 09:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbXJ0Ntn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 09:49:43 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:65284 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752333AbXJ0Ntm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 09:49:42 -0400
Date: Sat, 27 Oct 2007 15:49:47 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Shannon Nelson <shannon.nelson@intel.com>
Subject: Re: [PATCH] DMA: Fix broken device refcounting
Message-ID: <20071027154947.6836a3d9@siona>
In-Reply-To: <1193416577.9353.5.camel@dwillia2-linux.ch.intel.com>
References: <1193415162504-git-send-email-hskinnemoen@atmel.com>
	<1193416577.9353.5.camel@dwillia2-linux.ch.intel.com>
Organization: Atmel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007 09:36:17 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> @@ -221,7 +220,6 @@ void dma_chan_cleanup(struct kref *kref)
>  {
>  	struct dma_chan *chan = container_of(kref, struct dma_chan, refcount);
>	chan->device->device_free_chan_resources(chan);
> -	kref_put(&chan->device->refcount, dma_async_device_cleanup);
>  }
>  EXPORT_SYMBOL(dma_chan_cleanup);

While I can't see any problems with the rest of the patch, I think this
part is wrong for the same reasons removing the kref_put() from the
class device cleanup function is. I don't see any constraint that
guarantees that dma_chan_cleanup() will always be called before
dma_dev_release(), which means that "chan" may have been freed before
this function gets a chance to run. Please correct me if I'm wrong.

Håvard
