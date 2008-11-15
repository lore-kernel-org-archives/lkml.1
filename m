Return-Path: <linux-kernel-owner+w=401wt.eu-S1755344AbYKOGRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbYKOGRY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 01:17:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbYKOGRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 01:17:13 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36721 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751985AbYKOGRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 01:17:12 -0500
Date: Fri, 14 Nov 2008 22:17:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       maciej.sosnowski@intel.com, hskinnemoen@atmel.com,
       g.liakhovetski@gmx.de, nicolas.ferre@atmel.com
Subject: Re: [PATCH 08/13] dmatest: convert to dma_request_channel
Message-Id: <20081114221704.fe9ea599.akpm@linux-foundation.org>
In-Reply-To: <20081114213458.32354.58258.stgit@dwillia2-linux.ch.intel.com>
References: <20081114213300.32354.1154.stgit@dwillia2-linux.ch.intel.com>
	<20081114213458.32354.58258.stgit@dwillia2-linux.ch.intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2008 14:34:58 -0700 Dan Williams <dan.j.williams@intel.com> wrote:

>  static int __init dmatest_init(void)
>  {
> -	dma_cap_set(DMA_MEMCPY, dmatest_client.cap_mask);
> -	dma_async_client_register(&dmatest_client);
> -	dma_async_client_chan_request(&dmatest_client);
> +	dma_cap_mask_t mask;
> +	struct dma_chan *chan;
> +
> +	dma_cap_zero(mask);
> +	dma_cap_set(DMA_MEMCPY, mask);
> +	for (;;) {
> +		chan = dma_request_channel(mask, filter, NULL);
> +		if (chan) {
> +			if (dmatest_add_channel(chan) == 0)
> +				continue;

hrm.  I trust this loop can't lock up the box.

> +			else
> +				dma_release_channel(chan);
> +		} else
> +			break; /* no more channels available */
> +		if (max_channels && nr_channels >= max_channels)
> +			break; /* we have all we need */
> +	}
