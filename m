Return-Path: <linux-kernel-owner+w=401wt.eu-S1759370AbYGBBbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759370AbYGBBbi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 21:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755851AbYGBBb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 21:31:27 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:34082 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765AbYGBBb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 21:31:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=QVWIiSqAxbfzqFjEepbEVkQ9iZAaNtpRywJdDcPKcc2UI+C1ZsFsELpHDx5v7CyIsB
         d3BIt1dVulpbWQW+6kycZMRJv54JxBBWBjpl80I8fPA7F09HBuKbGiopB2bu8JP3SS/3
         65qiR3hLUOYgcOO05GHj+/1Huzs9z4LLLaB2s=
Message-ID: <e9c3a7c20807011831n74eb69b8r3095b62515fe5c9@mail.gmail.com>
Date: Tue, 1 Jul 2008 18:31:25 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>
Subject: Re: [PATCH v4 2/6] dmaengine: Add dma_chan_is_in_use() function
Cc: "Pierre Ossman" <drzeus-list@drzeus.cx>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, kernel@avr32linux.org,
       shannon.nelson@intel.com, "David Brownell" <david-b@pacbell.net>
In-Reply-To: <1214486603-23655-3-git-send-email-haavard.skinnemoen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1214486603-23655-1-git-send-email-haavard.skinnemoen@atmel.com>
	 <1214486603-23655-2-git-send-email-haavard.skinnemoen@atmel.com>
	 <1214486603-23655-3-git-send-email-haavard.skinnemoen@atmel.com>
X-Google-Sender-Auth: 678ac2996f8408d0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 6:23 AM, Haavard Skinnemoen
<haavard.skinnemoen@atmel.com> wrote:
> This moves the code checking if a DMA channel is in use from
> show_in_use() into an inline helper function, dma_is_in_use(). DMA
> controllers can use this in order to give clients exclusive access to
> channels (usually necessary when setting up slave DMA.)
>
> I have to admit that I don't really understand the channel refcounting
> logic at all... dma_chan_get() simply increments a per-cpu value. How
> can we be sure that whatever CPU calls dma_chan_is_in_use() sees the
> same value?

As Chris noted in the comments at the top of dmaengine.c this is an
implementation Rusty's 'bigref'.  It seeks to avoid the
cache-line-bouncing overhead of maintaining a single global refcount
in hot paths like tcp_v{4,6}_rcv().  When the channel is being
removed, a rare event, we transition to the accurate, yet slow, global
method.

Your observation is correct, dma_chan_is_in_use() may lie in the case
when the current cpu is not using the channel.  For this particular
test I think you can look to see if this channel's resources are
already allocated.  If they are then some other client got a hold of
this channel before the current attempt.  Hmm... that would also
require that we free the channel's resources in the case where the
client replies with DMA_NAK, probably something we should do anyways.

Thoughts?

--
Dan
