Return-Path: <linux-kernel-owner+w=401wt.eu-S1762453AbYGBIAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762453AbYGBIAh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 04:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbYGBH77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 03:59:59 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:59319 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492AbYGBH76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 03:59:58 -0400
Date: Wed, 2 Jul 2008 09:59:40 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: "Dan Williams" <dan.j.williams@intel.com>
Cc: "Pierre Ossman" <drzeus-list@drzeus.cx>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, kernel@avr32linux.org,
       shannon.nelson@intel.com, "David Brownell" <david-b@pacbell.net>
Subject: Re: [PATCH v4 2/6] dmaengine: Add dma_chan_is_in_use() function
Message-ID: <20080702095940.699fe704@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <e9c3a7c20807011900x7b2ac3dx7536e0450202e3c0@mail.gmail.com>
References: <1214486603-23655-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1214486603-23655-2-git-send-email-haavard.skinnemoen@atmel.com>
	<1214486603-23655-3-git-send-email-haavard.skinnemoen@atmel.com>
	<e9c3a7c20807011831n74eb69b8r3095b62515fe5c9@mail.gmail.com>
	<e9c3a7c20807011900x7b2ac3dx7536e0450202e3c0@mail.gmail.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Jul 2008 07:59:45.0961 (UTC) FILETIME=[97D41190:01C8DC19]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Dan Williams" <dan.j.williams@intel.com> wrote:
> Actually we will probably need something like the following.
> ->client_count is protected by the dma_list_mutex.  
> 
> diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
> index 99c22b4..10de69e 100644
> --- a/drivers/dma/dmaengine.c
> +++ b/drivers/dma/dmaengine.c
> @@ -183,9 +183,10 @@ static void dma_client_chan_alloc(struct
> dma_client *client)
>  				/* we are done once this client rejects
>  				 * an available resource
>  				 */
> -				if (ack == DMA_ACK)
> +				if (ack == DMA_ACK) {
>  					dma_chan_get(chan);
> -				else if (ack == DMA_NAK)
> +					chan->client_count++;
> +				} else if (ack == DMA_NAK)
>  					return;
>  			}

This looks good to me. I can use client_count to determine if dwc->dws
is actually valid so that channels that were initially allocated for a
slave but NAK'ed or DUP'ed can be reclaimed for other purposes.

It still doesn't solve the issue with memory wastage, but we probably
shouldn't expect to keep a lot of unused channels around anyway.

Thanks!

Haavard
