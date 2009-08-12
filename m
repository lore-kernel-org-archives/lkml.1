Return-Path: <linux-kernel-owner+w=401wt.eu-S1754809AbZHLSkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbZHLSkf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 14:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbZHLSke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 14:40:34 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:48829 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbZHLSkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 14:40:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XimcdSMO/HD7BTRpgkoOyyC+4+sWq6AGxOGBAkw/5bTkN2zSlpZgIjD5lh+ZmmQkB0
         vZkOpVazHS5mctEGJyihb87dJ5TxmZAIpxyM24xoLHmEWkBigcyn4i6m5EXbJM8U3ikl
         wF/EcYd7dORQoZF2ya25ZQjLVSuzzMA4l+Llc=
Subject: Re: Patch "page-allocator: preserve PFN ordering when __GFP_COLD
 is set" fails on my system
From: Arnaud Faucher <arnaud.faucher@gmail.com>
To: Juergen Beisert <jbe@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-hotplug@vger.kernel.org
In-Reply-To: <200908121735.44439.jbe@pengutronix.de>
References: <200908111830.03224.jbe@pengutronix.de>
	 <200908121311.35321.jbe@pengutronix.de> <20090812135036.GE19269@csn.ul.ie>
	 <200908121735.44439.jbe@pengutronix.de>
Content-Type: text/plain
Date: Wed, 12 Aug 2009 14:40:30 -0400
Message-Id: <1250102430.4912.4.camel@green>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a rather similar problem on a driver that I try to keep
up-to-date with recent kernel versions
(http://code.ximeta.com/trac-ndas/ticket/1110#comment:30). The NDAS
hardware is an ethernet-enabled disk controller on one chip, kind of a
cheap iSCSI.

In my case there is no oops: the symptoms are that the read blocks seem
to be swapped or full of garbage.

After investigation in the NDAS code, the bug triggers when the driver
tries to merge adjacent requests before sending them to the controller.
I had to disable this merge in order to restore normal behavior, at the
expense of a reduced efficiency.

> On Mittwoch, 12. August 2009, Mel Gorman wrote:
> > On Wed, Aug 12, 2009 at 01:11:34PM +0200, Juergen Beisert wrote:
> > > On Mittwoch, 12. August 2009, Mel Gorman wrote:
> > > > > > I get the following Ooops message when "udevadm" is running on an
> > > > > > ARM S3C2440 CPU based system:
> > > >
> > > > This is extremely odd. All that patch is doing is changing what order
> > > > pages are returned in to the caller when __GFP_COLD is specified. 
> > > > valid memory. Does reverting the patch really make the problem go away?
> > >
> > > At least I can work with the system if I remove this patch. Theres is no
> > > oops, so udev creates all the required devnodes and the system comes up
> > > into the login prompt.
> >
> > One reason I can think of that the patch would make a different to booting
> > is that there is a buffer overrun somewhere. When the pages in one order,
> > the buffer overrun is into pages that are not being used so it's not
> > spotted. In the other order, the overrun causes damage. The patch only
> > alters the order of pages in a linked list and ordinarily that shouldn't
> > make any functional difference.
> >
[...]
> After this oops, system startup continues. Then the next oops occurs:
> 
> This one is new, since I try to mount the connected SD card.
> 

Mel's buffer overrun theory seems to apply in the NDAS driver case,
where the original requests adjacency test seems faulty.

May it also be the cause of the SD mounting crash ?



