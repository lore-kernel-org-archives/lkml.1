Return-Path: <linux-kernel-owner+w=401wt.eu-S1757874AbXFISM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757874AbXFISM3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 14:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753964AbXFISMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 14:12:21 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38173 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752458AbXFISMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 14:12:20 -0400
Date: Sat, 9 Jun 2007 11:12:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Tejun Heo <htejun@gmail.com>, Gregor Jasny <gjasny@googlemail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Re: Linux v2.6.22-rc3
In-Reply-To: <20070607224746.GA23290@havoc.gtf.org>
Message-ID: <alpine.LFD.0.98.0706091054360.20321@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0705252008210.26602@woody.linux-foundation.org>
 <9d2cd630705270801m2826be60p3f802c502b26c531@mail.gmail.com>
 <466196AD.3090502@garzik.org> <9d2cd630706031046n2bd77585o7c0df1c5fea5167f@mail.gmail.com>
 <46667466.4010500@gmail.com> <9d2cd630706062322v2d73b32dp1da56f97e2069fff@mail.gmail.com>
 <4667B347.9040900@gmail.com> <alpine.LFD.0.98.0706071352440.4205@woody.linux-foundation.org>
 <20070607224746.GA23290@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 7 Jun 2007, Jeff Garzik wrote:
>
> Ack'ing the sata_promise change was easy, but with this one it would
> be nice to wait a bit before changing the core probe code that [now]
> every ATA setup goes through, based on a single bug report.

So what's the resolution? Right now this is apparently the reasong for 
two of our current regressions, and we need to solve it.

"Just wait" is not an option. The options are:
 - fix things
 - revert everything that caused the regressions

and quite frankly, I don't think the second alternative is palatable to 
anybody, including you.

> The values assist in detecting ghost devices (same device appearing
> on both master and slave) and TF register malfunctions, and I would
> appreciate not breaking _that_ so late in 2.6.22-rc for a single
> report.  Thankfully we have -some- ghost device prevention code
> elsewhere, but this is part of it.

Apparently this isn't even true. As far as I can tell, the old code used 
to wait for lbal to be 1, but if it never became one, it would just 
silently time out and not *do* anything about it. Later commands would 
"just work", and the device would go its merry ways.

IOW, the new code is *crap*. The old code was arguably not wonderful 
either, but because of its nature, the old code not working didn't 
actually matter all that much.

So the biggest change (and the one that broke peoples machines) is that 
the code that you claim matters, *never* apparently did matter, and now 
that we've made it matter (by returning an error, and aborting the SRST 
sequence as a failure), people are complaining.

I really think we should apply Tejun's patch. Add a delay there, by all 
means if you are nervous: but no, it shouldn't be 150ms. This is the 
_post_ reset handling, we've already done the 150ms wait for the reset!

In fact, if you look at ata_bus_post_reset(), you'll notice that for 
port0, we just do the "ata_wait_ready()" call. Tejun's patch just made us 
do the same (logical) thing for port1 too!  If you think it breaks due to 
ome timeout issue, then the port0 thing was already broken.

(And maybe we could make the 

	ap->ops->dev_select(ap, 1);
	rc = ata_wait_ready(ap, deadline);

instead be a

	ata_dev_select(ap, 1, 1, 1);

and you'd wait even more? But that's actually a bigger change than Tejun's 
thing, and it uses "ata_wait_idle()" rather than "ata_wait_ready()", and 
doesn't return any status.. I dunno. But right now, we have several known 
broken things, that apparently weren't broken before!)

		Linus
