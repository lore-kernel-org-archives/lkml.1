Return-Path: <linux-kernel-owner+w=401wt.eu-S1752618AbZK1Wu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618AbZK1Wu3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 17:50:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbZK1Wu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 17:50:29 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:51739 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbZK1Wu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 17:50:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=biCc39S3jV1LNyS3S7OfeprDKn9SGvSp+vgHgye1M3UNp/rOTVhcLZGMa6tdp8eNop
         l/iPYfKOznYQO67Lao9W2gw8f5zBk2jOPKUYhFJn0Ok5pi8A2TWE4vd4pDOjFMzYXTt+
         KB07C+Pbt1dxl45yA7Stvezn9ggRr54t50rG8=
From: Siarhei Siamashka <siarhei.siamashka@gmail.com>
To: cbe-oss-dev@lists.ozlabs.org
Subject: Re: [Cbe-oss-dev] [PATCH] block/ps3: Fix slow VRAM IO
Date: Sun, 29 Nov 2009 00:50:30 +0200
User-Agent: KMail/1.9.10
Cc: Akira Tsukamoto <akirat@rd.scei.sony.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jim Paris <jim@jtan.com>, Jens Axboe <jens.axboe@oracle.com>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Cell Broadband Engine OSS Development 
	<cbe-oss-dev@ozlabs.org>
References: <4ADCC4E3.8060104@am.sony.com> <20091103002322.1f04adbe.akpm@linux-foundation.org> <20091109154036.08C0.4D252088@rd.scei.sony.co.jp>
In-Reply-To: <20091109154036.08C0.4D252088@rd.scei.sony.co.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911290050.30885.siarhei.siamashka@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 November 2009, Akira Tsukamoto wrote:
> Thank you for the review!
>
> > > The current PS3 VRAM driver uses msleep() to wait for completion
> > > of RSX DMA transfers between system memory and VRAM.  Depending
> > > on the system timing, the processing delay and overhead of this
> > > msleep() call can significantly impact VRAM driver IO.
> > >
> > > To avoid the condition, add a short duration (200 usec max)
> > > udelay() polling loop before entering the msleep() polling
> > > loop.
> >
> > When raising a performance-based patch, please always try to include
> > before-and-after performance measurements in the changelog.  People
> > want to know the magnitude of the improvement.
>
> No problem we will add the difference of improvement in the changelog.
> This is the results. Pretty impressive.
> Before
>   Reading:  33MB/s
>   Writing:  16MB/s
> After
>   Reading: 370MB/s
>   Writing: 238MB/s
>
> > > +		if (!notify[3])
> > > +			return 0;
> > > +		udelay(10);
> > > +	}
> >
> > You might as well do a udelay(1) here.  The additional cost will be
> > negligible, and it will reduce latency.
>
> Are you mentioning adding udelay(1) in the between udelay polling
> and msleep polling? Or are you mentioning to change udelay(10) to udelay(1)
> inside the udelay polling?
>
> The former is no problem, but the later has impact on performance of PS3
> system.
> Because Cell/B.E.(consists of PPE and SPEs cores) and GPU are connected
> with ring bus called EIB and every issuing notify[3] to check VRAM-DMA
> results will generate data transfer to the bus.
> There are only one EIB bus in PS3 and other devices connected on the bus
> such as SPEs will be affected if the bus is occupied by many notify[3] and
> as a result it will decrease the over all system performance.
>
> The udelay(10) was the most reasonable distance not to overcrowd the bus
> and not to wait too long for checking DMA on VRAM.
> We have tried udelay(5) but did not improve the VRAM IO speed.
>
> > > +	timeout = jiffies + msecs_to_jiffies(timeout_ms);
> >
> > The maximum latency is now timout_ms + 200usec.
> >
> > That's OK with the current constants, but if someone later changes a
> > constant, the error could become significant.
>
> Yes, I think so too. Probably reconstructing the design entirely based on
> usec instead of msec might be ideal but adding 200usec loops fixes the
> current slow VRAM driver, so I thought it is acceptable work around.

Thanks for the detailed explanations. I wonder if it makes sense to change
200usec magic number to something more flexible. If I understand it correctly,
200usec is just about twice the time that is needed to transfer 256KiB sized
ps3vram internal cache page from or to VRAM via DMA with otherwise idle EIB
bus. I guess it is done so that msleep is only ever reachable when EIB bus is
heavily overloaded. Reaching msleep in the code means getting all the same
33MB/s or 16MB/s for ps3vram performance.

If somebody tries to play with tweaking ps3vram constants like 
CACHE_PAGE_SIZE, the magic 200usec delay may need to be changed
to something more appropriate, but right now it is not very obvious
from the patch description or comments in the code.

So probably some constant, based on DMA throughput and cache page size
would be better here?

-- 
Best regards,
Siarhei Siamashka
