Return-Path: <linux-kernel-owner+w=401wt.eu-S1755450AbYAFSpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbYAFSpY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 13:45:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbYAFSpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 13:45:12 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60584 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751249AbYAFSpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 13:45:10 -0500
Date: Sun, 6 Jan 2008 10:44:35 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Peter Osterlund <petero2@telia.com>, Matthew Wilcox <matthew@wil.cx>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
In-Reply-To: <alpine.LFD.1.00.0801060954010.2811@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.00.0801061034410.2811@woody.linux-foundation.org>
References: <20080102162534.GA4041@elte.hu>  <1199292381.3258.32.camel@localhost.localdomain>  <alpine.LFD.1.00.0801021113150.32517@woody.linux-foundation.org>  <20080102194030.GC11638@parisc-linux.org>  <1199304735.3258.53.camel@localhost.localdomain> 
 <alpine.LFD.1.00.0801021227140.32517@woody.linux-foundation.org>  <1199316785.3258.85.camel@localhost.localdomain>  <alpine.LFD.1.00.0801021756310.3010@woody.linux-foundation.org>  <m3ir27oe7f.fsf@telia.com>  <alpine.LFD.1.00.0801051900500.2811@woody.linux-foundation.org>
 <1199630574.5205.14.camel@localhost.localdomain> <alpine.LFD.1.00.0801060954010.2811@woody.linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 6 Jan 2008, Linus Torvalds wrote:
> 
> That said:
> 
> > pktcdvd shouldn't be mucking with the size of the underlying CD/DVD ...
> 
> I'm not sure if it should be mucking with the size or not, but it 
> definitely shouldn't be mucking with the block-size, because that can 
> indeed cause huge problems. 

Hmm. Looking closer, it's probably ok in that case, because it does do a 
"bd_claim()" to make sure that it has exclusive access, so while there may 
be other openers around, at least those other openers won't be filesystem 
mounts or anything that opened with O_EXCL.

So changing the blocksize is probably ok in this case.

That still leaves the question whether pktcdvd *should* muck with the base 
device at all, and I'm not at all sure about that.  But I'm no longer sure 
that the pktcdvd code is necessarily *clearly* broken, now it's more of a 
"should it really do that?" thing.

So I still suspect that this:

> -	set_capacity(pd->disk, lba << 2);
> -	set_capacity(pd->bdev->bd_disk, lba << 2);
> -	bd_set_size(pd->bdev, (loff_t)lba << 11);
> +	set_capacity(pd->disk, get_capacity(pd->bdev->bd_disk));

is likely a good thing to do (in conjunction with my patch that made 
i_size be "reliable" after an open), but there may be some reason why 
pktcdvd really wants to control the size rather than be on the receiving 
end of the size.

Peter, this is your decision. Apparently my one-liner fixes the immediate 
bug (but it's not really a regression either - I think the i_size issue 
has been there since pretty much day #1), and what pktcdvd does is 
somewhat less critical an issue?

			Linus
