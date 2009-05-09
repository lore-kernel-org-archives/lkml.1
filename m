Return-Path: <linux-kernel-owner+w=401wt.eu-S1754916AbZEIKXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916AbZEIKXT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 06:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbZEIKXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 06:23:05 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:39287 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbZEIKXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 06:23:03 -0400
Date: Sat, 9 May 2009 12:25:14 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: petkovbb@gmail.com, Borislav Petkov <petkovbb@googlemail.com>,
       bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/14] ide-tape: fix potential fs requests bug
Message-ID: <20090509102514.GA23517@uranus.ravnborg.org>
References: <1241855134-4984-1-git-send-email-petkovbb@gmail.com> <1241855134-4984-2-git-send-email-petkovbb@gmail.com> <20090509080245.GB22617@uranus.ravnborg.org> <20090509085008.GA5261@liondog.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090509085008.GA5261@liondog.tnic>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 09, 2009 at 10:50:08AM +0200, Borislav Petkov wrote:
> On Sat, May 09, 2009 at 10:02:45AM +0200, Sam Ravnborg wrote:
> > On Sat, May 09, 2009 at 09:45:21AM +0200, Borislav Petkov wrote:
> > > ide-tape had a potential bug for fs requests when preparing the command
> > > packet: it was writing the transfer length as a number of fixed blocks.
> > > However, the block layer implies 512 byte blocks and ide-tape can have
> > > other block sizes so account for that too.
> > > 
> > > ide-floppy does this calculation properly with the block size factor
> > > (floppy->bs_factor).
> > > 
> > > Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> > > ---
> > >  drivers/ide/ide-tape.c |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
> > > index e166045..fc79cf4 100644
> > > --- a/drivers/ide/ide-tape.c
> > > +++ b/drivers/ide/ide-tape.c
> > > @@ -586,7 +586,7 @@ static void ide_tape_create_rw_cmd(idetape_tape_t *tape,
> > >  				   struct ide_atapi_pc *pc, struct request *rq,
> > >  				   u8 opcode)
> > >  {
> > > -	unsigned int length = blk_rq_sectors(rq);
> > > +	unsigned int length = blk_rq_sectors(rq) / (tape->blk_size >> 9);
> > 
> > If tape->blk_size equals 256 or less then we get a divide-by-zero.
> 
> Yes, there is a far-fetched, potential possibility for that but here's
> what the QIC 157D (http://www.qic.org/html/standards/15x.x/qic157d.pdf)
> spec for streaming tapes says on block sizes:
> 
> "The Block Length specifies the current length in bytes of each logical
> block described by the block descriptor for the current medium. For QIC
> Streaming Tape Devices, two block sizes supported may be of either 512
> or 1024 bytes per block."
> 
> Also, the driver catches invalid block sizes in
> idetape_get_mode_sense_results() so I guess we should be fine.

OK - but If I am wondering maybe the next reader will
think the same
A small comment:
/* idetape_get_mode_sense_results() prevent sizes less than 1 << 9 */
Seems to be reasonable.

	Sam
