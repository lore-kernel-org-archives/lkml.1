Return-Path: <linux-kernel-owner+w=401wt.eu-S1755433AbZDVTkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433AbZDVTkd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 15:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbZDVTkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 15:40:22 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:56053 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbZDVTkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 15:40:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=dS00yIZLYBBN/DWj28k+yD0p4VoOg+lJPzVlQ7Mulxx0DI0q3iPmM4vSlTw29PLBef
         pdDhXdoi6XKAdYcgcCTKwRtSNnCdtkgmukoVnm/YZb9EY0y9H3q4RhHax683kF8222rM
         23U+oKjxJoVEgbSSqjppi5syb5tFHbNACDco0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Joe Perches <joe@perches.com>
Subject: Re: [git pull] IDE fixes
Date: Wed, 22 Apr 2009 21:43:46 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-next-20090403; KDE/4.2.1; i686; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200904222048.15556.bzolnier@gmail.com> <1240427207.21848.81.camel@localhost>
In-Reply-To: <1240427207.21848.81.camel@localhost>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904222143.47220.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 April 2009 21:06:47 Joe Perches wrote:
> On Wed, 2009-04-22 at 20:48 +0200, Bartlomiej Zolnierkiewicz wrote:
> > diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
> > index 3aec19d..3d4e099 100644
> > --- a/drivers/ide/ide-cd.c
> > +++ b/drivers/ide/ide-cd.c
> > @@ -609,7 +609,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
> >  	struct request *rq = hwif->rq;
> >  	ide_expiry_t *expiry = NULL;
> >  	int dma_error = 0, dma, thislen, uptodate = 0;
> > -	int write = (rq_data_dir(rq) == WRITE) ? 1 : 0, rc, nsectors;
> > +	int write = (rq_data_dir(rq) == WRITE) ? 1 : 0, rc = 0, nsectors;
> >  	int sense = blk_sense_request(rq);
> >  	unsigned int timeout;
> >  	u16 len;
> 
> I think ide is the only subsystem to use the
> initialization style of "?:," with additional
> declarations.

Well, nothing wrong with it per se.

> Would it be better to use a more standard style?
> 
> maybe:
> 	int dma_error = 0, dma, thislen, uptodate = 0, rc = 0, nsectors;
> 	int write = ((rq_data_dir(rq) == WRITE) ? 1 : 0;

Personally I would prefer:

	int write = !!(rq_data_dir(rq) == WRITE);

However the old code is also fine with me.

> > diff --git a/drivers/ide/palm_bk3710.c b/drivers/ide/palm_bk3710.c
> > index c7acca0..d1513b4 100644
> > --- a/drivers/ide/palm_bk3710.c
> > +++ b/drivers/ide/palm_bk3710.c
> []
> > @@ -75,13 +67,19 @@ struct palm_bk3710_udmatiming {
> >  
> >  static unsigned ideclk_period; /* in nanoseconds */
> >  
> > +struct palm_bk3710_udmatiming {
> > +	unsigned int rptime;	/* tRP -- Ready to pause time (nsec) */
> > +	unsigned int cycletime;	/* tCYCTYP2/2 -- avg Cycle Time (nsec) */
> > +				/* tENV is always a minimum of 20 nsec */
> > +};
> > +
> >  static const struct palm_bk3710_udmatiming palm_bk3710_udmatimings[6] = {
> > -	{160, 240},		/* UDMA Mode 0 */
> > -	{125, 160},		/* UDMA Mode 1 */
> > -	{100, 120},		/* UDMA Mode 2 */
> > -	{100, 90},		/* UDMA Mode 3 */
> > -	{100, 60},		/* UDMA Mode 4 */
> > -	{85,  40},		/* UDMA Mode 5 */
> > +	{160, 240 / 2,},	/* UDMA Mode 0 */
> > +	{125, 160 / 2,},	/* UDMA Mode 1 */
> > +	{100, 120 / 2,},	/* UDMA Mode 2 */
> > +	{100, 90 / 2,},		/* UDMA Mode 3 */
> > +	{100, 60 / 2,},		/* UDMA Mode 4 */
> > +	{85,  40 / 2,},		/* UDMA Mode 5 */
> >  };
> >  
> >  static void palm_bk3710_setudmamode(void __iomem *base, unsigned int dev,
> 
> Odd looking commas.
> 
> Maybe:
> 
> 	{.rptime = 160, .cycletime = 240 / 2 },	/* UDMA Mode 0 */
> etc.

I really don't consider this an improvement from readability perspective
and I also don't like the added code duplication...

IMO we should just remove extra commas and add some whitespaces.

I have also more general (process oriented) comment:

All patches have been posted to linux-kernel or linux-ide for review before
and it is _much_ more efficient to raise issues (including CodingStyle ones)
during "review phase" instead of during "push to Linus" phase.

Thanks,
Bart
