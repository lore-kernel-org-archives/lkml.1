Return-Path: <linux-kernel-owner+w=401wt.eu-S1759708AbYFZSlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759708AbYFZSlh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 14:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753117AbYFZSl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 14:41:28 -0400
Received: from brick.kernel.dk ([87.55.233.238]:26500 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896AbYFZSl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 14:41:28 -0400
Date: Thu, 26 Jun 2008 20:41:25 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Oops when using growisofs
Message-ID: <20080626184124.GJ20851@kernel.dk>
References: <200806221818.24372.mb@bu3sch.de> <200806262021.32140.mb@bu3sch.de> <20080626183610.GI20851@kernel.dk> <200806262039.04678.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806262039.04678.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26 2008, Michael Buesch wrote:
> On Thursday 26 June 2008 20:36:11 Jens Axboe wrote:
> > Something like this, totally untested...
> > 
> > diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
> > index 68e7f19..5c1e663 100644
> > --- a/drivers/ide/ide-cd.c
> > +++ b/drivers/ide/ide-cd.c
> > @@ -1308,13 +1308,29 @@ static int cdrom_read_capacity(ide_drive_t *drive, unsigned long *capacity,
> >  	req.cmd_flags |= REQ_QUIET;
> >  
> >  	stat = ide_cd_queue_pc(drive, &req);
> > -	if (stat == 0) {
> > -		*capacity = 1 + be32_to_cpu(capbuf.lba);
> > -		*sectors_per_frame =
> > -			be32_to_cpu(capbuf.blocklen) >> SECTOR_BITS;
> > +	if (stat)
> > +		return stat;
> > +
> > +	/*
> > +	 * Sanity check the given block size
> > +	 */
> > +	switch (capbuf.blocklen) {
> > +	case 512:
> > +	case 1024:
> > +	case 2048:
> > +	case 4096:
> > +		break;
> > +	default:
> > +		printk(KERN_ERR "ide-cd: weird block size %u\n",
> > +							capbuf.blocklen);
> > +		printk(KERN_ERR "ide-cd: default to 2kb block size\n");
> 
> KERN_WARNING

It's pretty serious, so...

> > +		capbuf.blocklen = 2048;
> > +		break;
> >  	}
> >  
> > -	return stat;
> > +	*capacity = 1 + be32_to_cpu(capbuf.lba);
> > +	*sectors_per_frame = be32_to_cpu(capbuf.blocklen) >> SECTOR_BITS;
> > +	return 0;
> >  }
> >  
> >  static int cdrom_read_tocentry(ide_drive_t *drive, int trackno, int msf_flag,
> > 
> 
> I'll test this. Thanks a lot. :)
> However I cannot reproduce the bug. So I cannot tell whether it fixes it.

The patch wont hurt, probably we should just add it just in case.

-- 
Jens Axboe

