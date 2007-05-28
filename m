Return-Path: <linux-kernel-owner+w=401wt.eu-S1758723AbXE1O4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723AbXE1O4Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 10:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753176AbXE1O4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 10:56:14 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:35987
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbXE1O4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 10:56:13 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Maximilian Engelhardt <maxi@daemonizer.de>,
       Gary Zambrano <zambrano@broadcom.com>
Subject: Re: b44: regression in 2.6.22 (resend)
Date: Mon, 28 May 2007 16:55:14 +0200
User-Agent: KMail/1.9.6
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-wireless" <linux-wireless@vger.kernel.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Jeff Garzik <jgarzik@pobox.com>, netdev@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <20070525172431.60affaca@freepuppy> <200705281249.56106.mb@bu3sch.de> <200705281612.15649.maxi@daemonizer.de>
In-Reply-To: <200705281612.15649.maxi@daemonizer.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705281655.15105.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 May 2007 16:12:12 Maximilian Engelhardt wrote:
> On Monday 28 May 2007, Michael Buesch wrote:
> > Can you also test the following patch?
> > I think there's a bug in b44 that is doesn't properly discard
> > shared IRQs, so it might possibly generate a NAPI storm, dunno.
> > Worth a try.
> >
> > Index: linux-2.6.22-rc3/drivers/net/b44.c
> > ===================================================================
> > --- linux-2.6.22-rc3.orig/drivers/net/b44.c	2007-05-27 23:01:44.000000000
> > +0200 +++ linux-2.6.22-rc3/drivers/net/b44.c	2007-05-28 12:48:27.000000000
> > +0200 @@ -911,6 +911,8 @@ static irqreturn_t b44_interrupt(int irq
> >  	spin_lock(&bp->lock);
> >
> >  	istat = br32(bp, B44_ISTAT);
> > +	if (istat == 0xFFFFFFFF)
> > +		goto out; /* Shared IRQ not for us */
> >  	imask = br32(bp, B44_IMASK);
> >
> >  	/* The interrupt mask register controls which interrupt bits
> > @@ -942,6 +944,7 @@ irq_ack:
> >  		bw32(bp, B44_ISTAT, istat);
> >  		br32(bp, B44_ISTAT);
> >  	}
> > +out:
> >  	spin_unlock(&bp->lock);
> >  	return IRQ_RETVAL(handled);
> >  }
> 
> I did try this patch on a affected kernel, but I didn't notice any big 
> difference. Perhaps the kernel is a bit less slow during the test, but It's 
> hard to tell.

Ok, but anyway. I think this is a bug and needs to be fixed this way. Gary?

-- 
Greetings Michael.
