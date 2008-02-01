Return-Path: <linux-kernel-owner+w=401wt.eu-S1759698AbYBAHxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759698AbYBAHxW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 02:53:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217AbYBAHw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 02:52:58 -0500
Received: from wx-out-0506.google.com ([66.249.82.228]:44400 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762702AbYBAHw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 02:52:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent:from;
        b=FslVhcVLaLdIfgRsk7Zub+GphRYUOEBILM43gPURytWpDDkDTSJoNfZVWN9TnEw8oWEVflmJTxxWbKnnGBwLL0959H+8PQfIjKsz51p/4rnmH6vOpmRRi2Jw7iNsIqDPBdT4EGPWvUSJMLiHe3pj8GYRQSTsRVbtYuwx2yERaLw=
Date: Fri, 1 Feb 2008 08:51:17 +0100
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: jens.axboe@oracle.com, nai.xia@gmail.com, rdreier@cisco.com,
       bzolnier@gmail.com, flo@rfc822.org, linux-kernel@vger.kernel.org,
       j-nomura@ce.jp.nec.com, linux-ide@vger.kernel.org
Subject: Re: kernel BUG at ide-cd.c:1726 in 2.6.24-03863-g0ba6c33 &&
	-g8561b089
Message-ID: <20080201075117.GC4500@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
	jens.axboe@oracle.com, nai.xia@gmail.com, rdreier@cisco.com,
	bzolnier@gmail.com, flo@rfc822.org, linux-kernel@vger.kernel.org,
	j-nomura@ce.jp.nec.com, linux-ide@vger.kernel.org
References: <ab418ea90801302349u945788jeed1f42021801dbf@mail.gmail.com> <20080131130558.GV15220@kernel.dk> <20080131213740.GA4500@gollum.tnic> <20080131.173556.38717303.k-ueda@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080131.173556.38717303.k-ueda@ct.jp.nec.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2008 at 05:35:56PM -0500, Kiyoshi Ueda wrote:
> Hi Boris,
> 
> Thank you for the confirmation of original behavior.
> 
> On Thu, 31 Jan 2008 22:37:40 +0100, Borislav Petkov wrote:
> > On Thu, Jan 31, 2008 at 02:05:58PM +0100, Jens Axboe wrote:
> > > On Thu, Jan 31 2008, Nai Xia wrote:
> > > > My dmesg relevant info is quite similar:
> > > > 
> > > > [    6.875041] Freeing unused kernel memory: 320k freed
> > > > [    8.143120] ide-cd: rq still having bio: dev hdc: type=2, flags=114c8
> > > > [    8.144439]
> > > > [    8.144439] sector 10824201199534213, nr/cnr 0/0
> > > > [    8.144439] bio cf029280, biotail cf029280, buffer 00000000, data
> > > > 00000000, len 158
> > > > [    8.144439] cdb: 12 00 00 00 fe 00 00 00 00 00 00 00 00 00 00 00
> > > > [    8.144439] backup: data_len=158  bi_size=158
> > > > [    8.160756] ide-cd: rq still having bio: dev hdc: type=2, flags=114c8
> > > > [    8.160756]
> > > > [    8.160756] sector 2669858, nr/cnr 0/0
> > > > [    8.160756] bio cf029300, biotail cf029300, buffer 00000000, data
> > > > 00000000, len 158
> > > > [    8.160756] cdb: 12 01 00 00 fe 00 00 00 00 00 00 00 00 00 00 00
> > > > [    8.160756] backup: data_len=158  bi_size=158
> > > > [   14.851101] eth0: link up
> > > > [   27.121883] eth0: no IPv6 routers present
> > > > 
> > > > 
> > > > And by the way, Kiyoshi,
> > > > This can be reproduced in a typical setup vmware workstation 6.02 with
> > > > a vritual IDE cdrom,
> > > > in case you wanna catch that with your own eyes. :-)
> > > > Thanks for your trying hard to correct this annoying bug.
> > > 
> > > The below fix should be enough. It's perfectly legal to have leftover
> > > byte counts when the drive signals completion, happens all the time for
> > > eg user issued commands where you don't know an exact byte count.
> > 
> > Actually, this behavior has been the case even before the __blk_end_request()
> > changes. I did test plain 2.6.24 with the following
> > 
> > 
> > --- linux-2.6/drivers/ide/ide-cd.c	2008-01-31 22:18:59.000000000 +0100
> > +++ linux-2.6/drivers/ide/ide-cd.c-new	2008-01-31 22:18:50.000000000 +0100
> > @@ -1711,8 +1711,12 @@ static ide_startstop_t cdrom_newpc_intr(
> >  	/*
> >  	 * If DRQ is clear, the command has completed.
> >  	 */
> > -	if ((stat & DRQ_STAT) == 0)
> > +	if ((stat & DRQ_STAT) == 0) {
> > +		blk_dump_rq_flags(rq, "ide-cd: rq still having bio");
> > +		printk("backup: data_len=%u  bi_size=%u\n",
> > +				rq->data_len, rq->bio->bi_size);
> >  		goto end_request;
> > +	}
> >  
> >  	/*
> >  	 * check which way to transfer data
> > 
> > 
> > to see whether we've been getting residual byte counts:
> > 
> > Jan 31 22:10:06 gollum kernel: [   26.702877] ide-cd: rq still having bio: dev hdc: type=2, flags=114c8
> > Jan 31 22:10:06 gollum kernel: [   26.702945]
> > Jan 31 22:10:06 gollum kernel: [   26.702946] sector 2673511, nr/cnr 0/0
> > Jan 31 22:10:06 gollum kernel: [   26.703052] bio dfa8ec40, biotail dfa8ec40, buffer 00000000, data 00000000, len 158
> > Jan 31 22:10:06 gollum kernel: [   26.703122] cdb: 12 00 00 00 fe 00 00 00 00 00 00 00 00 00 00 00
> > Jan 31 22:10:06 gollum kernel: [   26.703877] backup: data_len=158  bi_size=158
> > 
> > ... so we've been simply silently ignoring this until now so i guess we don't
> > need to BUG() for something that's totally benign.

Hi Kiyoshi,
 
> end_that_request_last() is not called when __blk_end_reuqest()
> returns 1.  Then, the issuer isn't waken up.
> So I think the BUG() or error messages should be there.

you mean, end_that_request_last() isn't called when __end_that_request_first()
returns an error and this is the case only for fs and pc requests. Otherwise it
_is_ called, thus simulating somewhat the previous behavior. However, we never BUG()'ged
on residual byte counts before and this driver has been in the kernel tree for
ages, so what puzzles me now is how is BUG()'ing here better than before and
shouldn't we simply issue a warning instead of killing the interrupt handler...

..or am i missing something?

-- 
Regards/Gruﬂ,
    Boris.
