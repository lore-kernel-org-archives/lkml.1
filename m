Return-Path: <linux-kernel-owner+w=401wt.eu-S1764721AbYAaPEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764721AbYAaPEh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 10:04:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752365AbYAaPE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 10:04:27 -0500
Received: from brick.kernel.dk ([87.55.233.238]:18883 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753245AbYAaPE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 10:04:26 -0500
Date: Thu, 31 Jan 2008 16:04:18 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Florian Lohoff <flo@rfc822.org>
Cc: Nai Xia <nai.xia@gmail.com>, Roland Dreier <rdreier@cisco.com>,
       Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, bzolnier@gmail.com,
       bbpetkov@yahoo.de, linux-kernel@vger.kernel.org, j-nomura@ce.jp.nec.com,
       linux-ide@vger.kernel.org
Subject: Re: kernel BUG at ide-cd.c:1726 in 2.6.24-03863-g0ba6c33 && -g8561b089
Message-ID: <20080131150418.GD15220@kernel.dk>
References: <20080129.151353.48534987.k-ueda@ct.jp.nec.com> <adar6g0e0g2.fsf@cisco.com> <20080129.182356.70224412.k-ueda@ct.jp.nec.com> <20080130.202659.104027826.k-ueda@ct.jp.nec.com> <adamyqmafl3.fsf@cisco.com> <ab418ea90801302349u945788jeed1f42021801dbf@mail.gmail.com> <20080131130558.GV15220@kernel.dk> <20080131145341.GA32687@paradigm.rfc822.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080131145341.GA32687@paradigm.rfc822.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31 2008, Florian Lohoff wrote:
> On Thu, Jan 31, 2008 at 02:05:58PM +0100, Jens Axboe wrote:
> > The below fix should be enough. It's perfectly legal to have leftover
> > byte counts when the drive signals completion, happens all the time for
> > eg user issued commands where you don't know an exact byte count.
> > 
> > diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
> > index 74c6087..bee05a3 100644
> > --- a/drivers/ide/ide-cd.c
> > +++ b/drivers/ide/ide-cd.c
> > @@ -1722,7 +1722,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
> >  	 */
> >  	if ((stat & DRQ_STAT) == 0) {
> >  		spin_lock_irqsave(&ide_lock, flags);
> > -		if (__blk_end_request(rq, 0, 0))
> > +		if (__blk_end_request(rq, 0, rq->data_len))
> >  			BUG();
> >  		HWGROUP(drive)->rq = NULL;
> >  		spin_unlock_irqrestore(&ide_lock, flags);
> > 
> 
> Fixes the crash on boot for me ...

Great, thanks for confirming that. I'll make sure the patch goes
upstream today, if Linus is available.

-- 
Jens Axboe

