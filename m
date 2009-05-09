Return-Path: <linux-kernel-owner+w=401wt.eu-S1753713AbZEIIub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713AbZEIIub (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 04:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970AbZEIIuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 04:50:15 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:52783 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbZEIIuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 04:50:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-type:content-disposition
         :in-reply-to:user-agent;
        b=fyhjdpJsgdI9+Zi8Sax0Ye0GbrQiHQxTE/WDB2kj9z9u3dkQYej9rF7+Ok1lIWLtoS
         NaxGEimZ6FHZuVJEA2SQjRrUcyBunv4SWri6PuyDlPmAtTui1E2ssZlbLcFX9PLKs06d
         WQ8Pgic+0Tu/UZmeRDm3cnyoRfhk0/ASNNffs=
Date: Sat, 9 May 2009 10:50:08 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Borislav Petkov <petkovbb@googlemail.com>, bzolnier@gmail.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/14] ide-tape: fix potential fs requests bug
Message-ID: <20090509085008.GA5261@liondog.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, Sam Ravnborg <sam@ravnborg.org>,
	Borislav Petkov <petkovbb@googlemail.com>, bzolnier@gmail.com,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1241855134-4984-1-git-send-email-petkovbb@gmail.com> <1241855134-4984-2-git-send-email-petkovbb@gmail.com> <20090509080245.GB22617@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090509080245.GB22617@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 09, 2009 at 10:02:45AM +0200, Sam Ravnborg wrote:
> On Sat, May 09, 2009 at 09:45:21AM +0200, Borislav Petkov wrote:
> > ide-tape had a potential bug for fs requests when preparing the command
> > packet: it was writing the transfer length as a number of fixed blocks.
> > However, the block layer implies 512 byte blocks and ide-tape can have
> > other block sizes so account for that too.
> > 
> > ide-floppy does this calculation properly with the block size factor
> > (floppy->bs_factor).
> > 
> > Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> > ---
> >  drivers/ide/ide-tape.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
> > index e166045..fc79cf4 100644
> > --- a/drivers/ide/ide-tape.c
> > +++ b/drivers/ide/ide-tape.c
> > @@ -586,7 +586,7 @@ static void ide_tape_create_rw_cmd(idetape_tape_t *tape,
> >  				   struct ide_atapi_pc *pc, struct request *rq,
> >  				   u8 opcode)
> >  {
> > -	unsigned int length = blk_rq_sectors(rq);
> > +	unsigned int length = blk_rq_sectors(rq) / (tape->blk_size >> 9);
> 
> If tape->blk_size equals 256 or less then we get a divide-by-zero.

Yes, there is a far-fetched, potential possibility for that but here's
what the QIC 157D (http://www.qic.org/html/standards/15x.x/qic157d.pdf)
spec for streaming tapes says on block sizes:

"The Block Length specifies the current length in bytes of each logical
block described by the block descriptor for the current medium. For QIC
Streaming Tape Devices, two block sizes supported may be of either 512
or 1024 bytes per block."

Also, the driver catches invalid block sizes in
idetape_get_mode_sense_results() so I guess we should be fine.

Thanks.

-- 
Regards/Gruss,
    Boris.
