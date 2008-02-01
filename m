Return-Path: <linux-kernel-owner+w=401wt.eu-S1753125AbYBARkD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125AbYBARkD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 12:40:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753698AbYBARjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 12:39:51 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753580AbYBARju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 12:39:50 -0500
Date: Fri, 01 Feb 2008 12:39:27 -0500 (EST)
Message-Id: <20080201.123927.71085228.k-ueda@ct.jp.nec.com>
To: petkovbb@gmail.com, petkovbb@googlemail.com
Cc: jens.axboe@oracle.com, nai.xia@gmail.com, rdreier@cisco.com,
       bzolnier@gmail.com, flo@rfc822.org, linux-kernel@vger.kernel.org,
       j-nomura@ce.jp.nec.com, linux-ide@vger.kernel.org, k-ueda@ct.jp.nec.com
Subject: Re: kernel BUG at ide-cd.c:1726 in 2.6.24-03863-g0ba6c33 &&
 -g8561b089
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
In-Reply-To: <20080201075117.GC4500@gollum.tnic>
References: <20080131213740.GA4500@gollum.tnic>
	<20080131.173556.38717303.k-ueda@ct.jp.nec.com>
	<20080201075117.GC4500@gollum.tnic>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

On Fri, 1 Feb 2008 08:51:17 +0100, Borislav Petkov wrote:
> > > > The below fix should be enough. It's perfectly legal to have leftover
> > > > byte counts when the drive signals completion, happens all the time for
> > > > eg user issued commands where you don't know an exact byte count.
> > > 
> > > Actually, this behavior has been the case even before
> > > the __blk_end_request() changes.
> > > I did test plain 2.6.24 with the following
> > > 
> > > 
> > > --- linux-2.6/drivers/ide/ide-cd.c	2008-01-31 22:18:59.000000000 +0100
> > > +++ linux-2.6/drivers/ide/ide-cd.c-new	2008-01-31 22:18:50.000000000 +0100
> > > @@ -1711,8 +1711,12 @@ static ide_startstop_t cdrom_newpc_intr(
> > >  	/*
> > >  	 * If DRQ is clear, the command has completed.
> > >  	 */
> > > -	if ((stat & DRQ_STAT) == 0)
> > > +	if ((stat & DRQ_STAT) == 0) {
> > > +		blk_dump_rq_flags(rq, "ide-cd: rq still having bio");
> > > +		printk("backup: data_len=%u  bi_size=%u\n",
> > > +				rq->data_len, rq->bio->bi_size);
> > >  		goto end_request;
> > > +	}
> > >  
> > >  	/*
> > >  	 * check which way to transfer data
> > > 
> > > 
> > > to see whether we've been getting residual byte counts:
> > > 
> > > Jan 31 22:10:06 gollum kernel: [   26.702877] ide-cd: rq still having bio: dev hdc: type=2, flags=114c8
> > > Jan 31 22:10:06 gollum kernel: [   26.702945]
> > > Jan 31 22:10:06 gollum kernel: [   26.702946] sector 2673511, nr/cnr 0/0
> > > Jan 31 22:10:06 gollum kernel: [   26.703052] bio dfa8ec40, biotail dfa8ec40, buffer 00000000, data 00000000, len 158
> > > Jan 31 22:10:06 gollum kernel: [   26.703122] cdb: 12 00 00 00 fe 00 00 00 00 00 00 00 00 00 00 00
> > > Jan 31 22:10:06 gollum kernel: [   26.703877] backup: data_len=158  bi_size=158
> > > 
> > > ... so we've been simply silently ignoring this until now so
> > > i guess we don't need to BUG() for something that's totally benign.
> 
> Hi Kiyoshi,
>  
> > end_that_request_last() is not called when __blk_end_reuqest()
> > returns 1.  Then, the issuer isn't waken up.
> > So I think the BUG() or error messages should be there.
> 
> you mean, end_that_request_last() isn't called when __end_that_request_first()
> returns an error and this is the case only for fs and pc requests.
> Otherwise it _is_ called, thus simulating somewhat the previous behavior.
> However, we never BUG()'ged on residual byte counts before and
> this driver has been in the kernel tree for ages, so what puzzles
> me now is how is BUG()'ing here better than before and shouldn't we
> simply issue a warning instead of killing the interrupt handler...

The Jens' patch passes the residual byte counts to __blk_end_request(),
so __end_that_reqeust_first() should never return 1 and we should never
BUG() on the residual byte counts, unless inconsistency happens such as
the size of remaining bios is bigger than the residual byte counts.

So if __blk_end_request() returns 1 even with the Jens' patch,
it means that the block layer or the driver really have a bug.
And then, the request and the bios could leak or the issuer
would wait forever because end_that_request_last() isn't called.

The previous behavior might ignore such inconsistency and leak only
the bios because it was calling end_that_request_last() anyway.
I would like to BUG() in such cases personally, but I don't object
strongly if you prefer not to BUG().

Thanks,
Kiyoshi Ueda
