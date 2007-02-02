Return-Path: <linux-kernel-owner+w=401wt.eu-S964845AbXBBEKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964845AbXBBEKj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 23:10:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933242AbXBBEKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 23:10:38 -0500
Received: from smtp.osdl.org ([65.172.181.24]:59825 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933017AbXBBEKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 23:10:37 -0500
Date: Thu, 1 Feb 2007 20:07:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Luca Tettamanti <kronos.it@gmail.com>,
       Peter Osterlund <petero2@telia.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [2.6.20-rc6] pktcdvd doesn't work
Message-Id: <20070201200712.3b48311a.akpm@osdl.org>
In-Reply-To: <20070202023343.GY3754@stusta.de>
References: <20070130195319.GA10994@dreamland.darkstar.lan>
	<20070131233044.GX3754@stusta.de>
	<20070201230752.GA17679@dreamland.darkstar.lan>
	<20070201182147.2835668e.akpm@osdl.org>
	<20070202023343.GY3754@stusta.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Feb 2007 03:33:43 +0100 Adrian Bunk <bunk@stusta.de> wrote:

> On Thu, Feb 01, 2007 at 06:21:47PM -0800, Andrew Morton wrote:
> > On Fri, 2 Feb 2007 00:07:52 +0100 Luca Tettamanti <kronos.it@gmail.com> wrote:
> > 
> > > Il Thu, Feb 01, 2007 at 12:30:44AM +0100, Adrian Bunk ha scritto: 
> > > > On Tue, Jan 30, 2007 at 08:53:19PM +0100, Luca Tettamanti wrote:
> > > > > Hi,
> > > > > pktcdvd on kernel 2.6.20-rc6 is not working as expected. Any file that
> > > > > is written to the device is lost after umount.
> > > > > I rarely use pktcdvd but at some point it used to work on my system.
> > > > > 
> > > > > This is what I'm doing:
> > > > > 
> > > > > root@dreamland:/tmp# cdrwtool -d /dev/scd0 -q
> > > > > using device /dev/scd0
> > > > > 1029KB internal buffer
> > > > > setting write speed to 12x
> > > > > Settings for /dev/scd0:
> > > > >         Fixed packets, size 32
> > > > >         Mode-2 disc
> > > > >...
> > > > 
> > > > Does 2.6.20-rc7 work?
> > > > If no, does it work after applying the attached patch?
> > > > If no, does 2.6.19.2 work?
> > > 
> > > Git current + the following patch works.
> > > 
> > > > diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
> > > > index 6246219..7c95c76 100644
> > > > --- a/drivers/block/pktcdvd.c
> > > > +++ b/drivers/block/pktcdvd.c
> > > > @@ -765,34 +765,47 @@ static inline struct bio *pkt_get_list_first(struct bio **list_head, struct bio
> > > >   */
> > > >  static int pkt_generic_packet(struct pktcdvd_device *pd, struct packet_command *cgc)
> > > >  {
> > > > -	request_queue_t *q = bdev_get_queue(pd->bdev);
> > > > +	char sense[SCSI_SENSE_BUFFERSIZE];
> > 
> > Where did this patch come from?
> 
> It's a revert of the commits 3b00315799d78f76531b71435fbc2643cd71ae4c 
> and 406c9b605cbc45151c03ac9a3f95e9acf050808c
> 

Oh.  That's

 [SCSI] untangle scsi_prep_fn
and	
 [PATCH] Fix BUG at drivers/scsi/scsi_lib.c:1118 caused by "pktsetup dvd /dev

so this is a post-2.6.18 regression, yes?

do we know why this is happening?
