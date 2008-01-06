Return-Path: <linux-kernel-owner+w=401wt.eu-S1755277AbYAFSzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbYAFSzT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 13:55:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbYAFSzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 13:55:08 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:34236 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751692AbYAFSzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 13:55:06 -0500
Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Osterlund <petero2@telia.com>, Matthew Wilcox <matthew@wil.cx>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Al Viro <viro@ZenIV.linux.org.uk>
In-Reply-To: <alpine.LFD.1.00.0801061034410.2811@woody.linux-foundation.org>
References: <20080102162534.GA4041@elte.hu>
	 <1199292381.3258.32.camel@localhost.localdomain>
	 <alpine.LFD.1.00.0801021113150.32517@woody.linux-foundation.org>
	 <20080102194030.GC11638@parisc-linux.org>
	 <1199304735.3258.53.camel@localhost.localdomain>
	 <alpine.LFD.1.00.0801021227140.32517@woody.linux-foundation.org>
	 <1199316785.3258.85.camel@localhost.localdomain>
	 <alpine.LFD.1.00.0801021756310.3010@woody.linux-foundation.org>
	 <m3ir27oe7f.fsf@telia.com>
	 <alpine.LFD.1.00.0801051900500.2811@woody.linux-foundation.org>
	 <1199630574.5205.14.camel@localhost.localdomain>
	 <alpine.LFD.1.00.0801060954010.2811@woody.linux-foundation.org>
	 <alpine.LFD.1.00.0801061034410.2811@woody.linux-foundation.org>
Content-Type: text/plain
Date: Sun, 06 Jan 2008 12:54:56 -0600
Message-Id: <1199645697.5205.80.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-01-06 at 10:44 -0800, Linus Torvalds wrote:
> 
> On Sun, 6 Jan 2008, Linus Torvalds wrote:
> > 
> > That said:
> > 
> > > pktcdvd shouldn't be mucking with the size of the underlying CD/DVD ...
> > 
> > I'm not sure if it should be mucking with the size or not, but it 
> > definitely shouldn't be mucking with the block-size, because that can 
> > indeed cause huge problems. 
> 
> Hmm. Looking closer, it's probably ok in that case, because it does do a 
> "bd_claim()" to make sure that it has exclusive access, so while there may 
> be other openers around, at least those other openers won't be filesystem 
> mounts or anything that opened with O_EXCL.
> 
> So changing the blocksize is probably ok in this case.
> 
> That still leaves the question whether pktcdvd *should* muck with the base 
> device at all, and I'm not at all sure about that.  But I'm no longer sure 
> that the pktcdvd code is necessarily *clearly* broken, now it's more of a 
> "should it really do that?" thing.
> 
> So I still suspect that this:
> 
> > -	set_capacity(pd->disk, lba << 2);
> > -	set_capacity(pd->bdev->bd_disk, lba << 2);
> > -	bd_set_size(pd->bdev, (loff_t)lba << 11);
> > +	set_capacity(pd->disk, get_capacity(pd->bdev->bd_disk));
> 
> is likely a good thing to do (in conjunction with my patch that made 
> i_size be "reliable" after an open), but there may be some reason why 
> pktcdvd really wants to control the size rather than be on the receiving 
> end of the size.
> 
> Peter, this is your decision. Apparently my one-liner fixes the immediate 
> bug (but it's not really a regression either - I think the i_size issue 
> has been there since pretty much day #1), and what pktcdvd does is 
> somewhat less critical an issue?

I think perhaps the true bug lies in the way we handle layered devices
like this.  pktcdvd holds the underlying device open, so its refcount
never drops to zero.  This is what causes the gendisk/block layer never
to update the sizes, and what lead to pktcdvd doing it instead.

However, what perhaps really needs to happen is that pktcdvd needs to
take over the media change events as well.  That way it could see the
disk change and invalidate and reread its own setting of the block size
(and possibly re set the size of the underlying device).

I agree, though, this isn't a regression.  It's probably obscure enough
in reproduction to warrant not holding up 2.6.24 --- especially as I
think the true fix will do small perturbations to a lot of subsystems.
If this were a product and I were the release manager, I'd be updating
the release notes with a note about having to break pktcdvd binding
across media changes to work around this bug and a promise to fix it in
the next release.

James


