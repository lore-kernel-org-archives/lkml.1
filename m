Return-Path: <linux-kernel-owner+w=401wt.eu-S1756559AbZCNTua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559AbZCNTua (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 15:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754515AbZCNTuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 15:50:19 -0400
Received: from mail-fx0-f176.google.com ([209.85.220.176]:60490 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419AbZCNTuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 15:50:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=V/oGn0Zj2nZrkiLMgaUauy6dc+SoYvnpyydKFTD2dzd8AMtEOEVTPMZRKUXL/6bX+o
         pHv293IrLC+arhtX+6XGeVNCX75OSS28GTK9Q1NBcUJILHvmxe8dRDAAjvP66DjG/yJy
         U52793KatlKQd/im1E7SPXHDfe3yfuSeBFi2s=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 11/14] block: implement and use [__]blk_end_request_all()
Date: Sat, 14 Mar 2009 20:23:14 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc7-next-20090311; KDE/4.2.0; i686; ; )
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org,
       Russell King <rmk@arm.linux.org.uk>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Mike Miller <mike.miller@hp.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Jeff Garzik <jgarzik@pobox.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Alex Dubov <oakad@yahoo.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>
References: <1236920578-2179-1-git-send-email-tj@kernel.org> <200903132021.55921.bzolnier@gmail.com> <49BB0ECB.6090003@kernel.org>
In-Reply-To: <49BB0ECB.6090003@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903142023.14747.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 March 2009, Tejun Heo wrote:
> Hello, Bartlomiej.  :-)

Hi!

> Bartlomiej Zolnierkiewicz wrote:

[...]

> >> diff --git a/drivers/ide/ide-pm.c b/drivers/ide/ide-pm.c
> >> index 60538d9..d3d2d29 100644
> >> --- a/drivers/ide/ide-pm.c
> >> +++ b/drivers/ide/ide-pm.c
> >> @@ -194,8 +194,7 @@ void ide_complete_pm_request(ide_drive_t *drive, struct request *rq)
> >>  
> >>  	drive->hwif->rq = NULL;
> >>  
> >> -	if (blk_end_request(rq, 0, 0))
> >> -		BUG();
> >> +	blk_end_request_all(rq, 0);
> > 
> > 0 => ide_rq_bytes() _not_ blk_rq_bytes()
> 
> Can you elaborate a bit?  Isn't the request supposed to always
> completely finish here?  If the request isn't zero-length, completion
> with 0 byte length doesn't make any sense.

Arghh, just ignore me on this one -- my brain must have already started
switching into the power saving...

[ This is blk_end_request() not ide_end_request() call so "0 == 0". ]

> > Please convert ide_complete_pm_request() to use blk_rq_bytes() in
> > the separate pre-patch first.
> 
> Alright, will do.

No need to, please just put the comment about 0 => blk_rq_bytes()
conversion so people will know that this is an intended change when
reviewing the patch.

> > More generic comment follows -> this patch is guaranteed to clash
> > with at least linux-next/pata-2.6 tree so why not introduce block
> > layer helpers now, then push all driver updates through respective
> > driver maintainers and deal with end_request() later (after all
> > driver updates are in-tree)?
> 
> Most of the lld changes being trivial, I was hoping to push things
> through blk tree, but IDE seems to be the most intertwined with the
> block layer and it's likely to see quite some amount of not-so-trivial
> changes to subtle paths.  How about pushing !IDE parts into blk tree
> and pulling blk into pata-2.6, make IDE related changes there and
> pulling back into blk tree so that further progresses can be made?

There is a "tiny" problem with this -- pata-2.6 is a quilt tree based on
Linus' tree and it is not going to change for now (for various reasons).

Thanks,
Bart
