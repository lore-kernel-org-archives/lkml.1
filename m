Return-Path: <linux-kernel-owner+w=401wt.eu-S1754154AbZKIHXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbZKIHXK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 02:23:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754031AbZKIHXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 02:23:09 -0500
Received: from ms13.sony.co.jp ([211.125.136.230]:41910 "EHLO ms13.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753997AbZKIHXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 02:23:08 -0500
X-Greylist: delayed 2469 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Nov 2009 02:23:08 EST
Date: Mon, 09 Nov 2009 15:40:42 +0900
From: Akira Tsukamoto <akirat@rd.scei.sony.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Cbe-oss-dev] [PATCH] block/ps3: Fix slow VRAM IO
Cc: Geoff Levand <geoffrey.levand@am.sony.com>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       linux-kernel@vger.kernel.org,
       Cell Broadband Engine OSS Development 
	<cbe-oss-dev@ozlabs.org>,
       Jim Paris <jim@jtan.com>, Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <20091103002322.1f04adbe.akpm@linux-foundation.org>
References: <4ADCC4E3.8060104@am.sony.com> <20091103002322.1f04adbe.akpm@linux-foundation.org>
Message-Id: <20091109154036.08C0.4D252088@rd.scei.sony.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.51.07 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for the review!

> > The current PS3 VRAM driver uses msleep() to wait for completion
> > of RSX DMA transfers between system memory and VRAM.  Depending
> > on the system timing, the processing delay and overhead of this
> > msleep() call can significantly impact VRAM driver IO.
> > 
> > To avoid the condition, add a short duration (200 usec max)
> > udelay() polling loop before entering the msleep() polling
> > loop.
> > 
> 
> When raising a performance-based patch, please always try to include
> before-and-after performance measurements in the changelog.  People
> want to know the magnitude of the improvement.

No problem we will add the difference of improvement in the changelog.
This is the results. Pretty impressive.
Before
  Reading:  33MB/s 
  Writing:  16MB/s
After
  Reading: 370MB/s
  Writing: 238MB/s

> > +		if (!notify[3])
> > +			return 0;
> > +		udelay(10);
> > +	}
> 
> You might as well do a udelay(1) here.  The additional cost will be
> negligible, and it will reduce latency.

Are you mentioning adding udelay(1) in the between udelay polling 
and msleep polling? Or are you mentioning to change udelay(10) to udelay(1)
inside the udelay polling?

The former is no problem, but the later has impact on performance of PS3 
system.
Because Cell/B.E.(consists of PPE and SPEs cores) and GPU are connected with 
ring bus called EIB and every issuing notify[3] to check VRAM-DMA results 
will generate data transfer to the bus. 
There are only one EIB bus in PS3 and other devices connected on the bus
such as SPEs will be affected if the bus is occupied by many notify[3] and
as a result it will decrease the over all system performance.

The udelay(10) was the most reasonable distance not to overcrowd the bus 
and not to wait too long for checking DMA on VRAM.
We have tried udelay(5) but did not improve the VRAM IO speed.

> > +	timeout = jiffies + msecs_to_jiffies(timeout_ms);
> 
> The maximum latency is now timout_ms + 200usec.
> 
> That's OK with the current constants, but if someone later changes a
> constant, the error could become significant.

Yes, I think so too. Probably reconstructing the design entirely based on 
usec instead of msec might be ideal but adding 200usec loops fixes the
current slow VRAM driver, so I thought it is acceptable work around.

> Perhaps that isn't worth bothering about though.
> 
> >  	do {
> >  		if (!notify[3])

-- 
Akira Tsukamoto
Sony Computer Entertainment Inc. 
Architecture Lab.
Japan

