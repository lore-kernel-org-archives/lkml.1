Return-Path: <linux-kernel-owner+w=401wt.eu-S1756464AbZERQAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464AbZERQAz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 12:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbZERQAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 12:00:48 -0400
Received: from mx1.auerswald.de ([212.185.163.234]:11696 "EHLO
	mail.auerswald.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752116AbZERQAr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 12:00:47 -0400
From: Wolfgang =?iso-8859-1?q?M=FCes?= <wolfgang.mues@auerswald.de>
Organization: Auerswald GmbH & Co. KG
To: "Matt Fleming" <matt@console-pimps.org>
Subject: Re: [PATCH] mmc_spi: do propper retry managment in the block layer - rewritten
Date: Mon, 18 May 2009 18:00:40 +0200
User-Agent: KMail/1.9.10
Cc: "Pierre Ossman" <drzeus@drzeus.cx>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
References: <20090518152001.GA29472@console-pimps.org>
In-Reply-To: <20090518152001.GA29472@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905181800.41014.wolfgang.mues@auerswald.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt,

Am Montag, 18. Mai 2009 schrieb Matt Fleming:
> On Mon, May 18, 2009 at 02:21:38PM +0100, Wolfgang Mües wrote:
> > From: Wolfgang Muees <wolfgang.mues@auerswald.de>
> >
> > o This patch adds a propper retry managment for reading
> >   and writing data blocks for mmc and mmc_spi. Blocks are
> >   retransmitted if the cause of failure might be a transmission
> >   fault. After a permanent failure, we try to read all other
> >   pending sectors, but terminate on write.
> >   This patch was tested with induced transmission errors
> >   by ESD pulses (and survived).
> >
> > Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>
>
> When you say "proper retry management", what problem are you having
> with the current code?

a) Writes were not retried at all, so every transmission error created a data 
loss.
b) There was no clear distinction between errors which comes from transmission 
faults and errors which are by nature non-recoverable.
c) After one error, the remaining sectors were read one by one. This is 
unneccessary time-consuming.

Cause a) was my initial problem with this code. This was not production 
quality.  

> > -		/*
> > -		 * After a read error, we redo the request one sector at a time
> > -		 * in order to accurately determine which sectors can be read
> > -		 * successfully.
> > +		/* After an transmission error, we switch to single block
> > +		 * transfer until the problem is solved or we fail.
> >  		 */
>
> Why did you change this comment? They seem to say roughly the same
> things to me, only the first one is more descriptive. I think you
> really need to combine the two,

Because it would not be true.

In case of an error (both read or write), there is only a temporary switch to
one-sector-at-a-time. This is unlike the old code.

> > @@ -262,10 +262,12 @@ static int mmc_blk_issue_rq(struct mmc_q
> >  		if (brq.data.blocks > 1) {
> >  			/* SPI multiblock writes terminate using a special
> >  			 * token, not a STOP_TRANSMISSION request.
> > +			 * Here, this request is set for ALL types of
> > +			 * hosts, so that we can use it in the lower
> > +			 * layers if the data transfer stage has failed
> > +			 * and the card is not able to accept the token.
> >  			 */
> > -			if (!mmc_host_is_spi(card->host)
> > -					|| rq_data_dir(req) == READ)
> > -				brq.mrq.stop = &brq.stop;
> > +			brq.mrq.stop = &brq.stop;
> >  			readcmd = MMC_READ_MULTIPLE_BLOCK;
> >  			writecmd = MMC_WRITE_MULTIPLE_BLOCK;
> >  		} else {
>
> Hmm.. is it OK to abuse the STOP_TRANSMISSION request like this? Does
> SPI multiblock write still terminate with this patch?

IMHO, this is the right thing to do. If you have a transmission error 
while SPI multiblock write, the card will miss the stop token. So the
card is in multiblock write mode and has to be stopped. You cannot
retry the stop token. Every card I have tested accepted the STOP_TRANSMISSION 
request. So it is better to try a STOP_TRANSMISSION, because this will 
recover communication with the card. If a particular card will not respond to 
the STOP_TRANSMISSION, the situation is not worse as before...

The STOP_TRANSMISSION request is only send to the card if the card
has not responded to the stop token (see the change in mmc_spi.c).
The default non-error behaviour has not changed.

> > +#if 0
> > +		printk(KERN_INFO "%s transfer sector %d count %d\n",
> > +			(rq_data_dir(req) == READ) ? "Read" : "Write",
> > +			(int)req->sector, (int)brq.data.blocks);
> > +#endif
>
> This should probably be using pr_debug(). That way you can remove the
> #if 0.

I do not know pr_debug(). I will have to learn.

> Again, does this still work for SPI? Have you tested it?

Yes and Yes. SPI is my primary target. This is Patch #11 I have submitted to 
the spi/mmc framework.

best regards
 
i. A. Wolfgang Mües
-- 
Auerswald GmbH & Co. KG
Hardware Development
Telefon: +49 (0)5306 9219 0
Telefax: +49 (0)5306 9219 94 
E-Mail: Wolfgang.Mues@Auerswald.de
Web: http://www.auerswald.de
 
--------------------------------------------------------------
Auerswald GmbH & Co. KG, Vor den Grashöfen 1, 38162 Cremlingen
Registriert beim AG Braunschweig HRA 13289
p.h.G Auerswald Geschäftsführungsges. mbH
Registriert beim AG Braunschweig HRB 7463
Geschäftsführer: Dipl-Ing. Gerhard Auerswald
