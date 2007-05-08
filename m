Return-Path: <linux-kernel-owner+w=401wt.eu-S966459AbXEHKht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966459AbXEHKht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 06:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966405AbXEHKhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 06:37:47 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:46775 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966352AbXEHKhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 06:37:46 -0400
Date: Tue, 8 May 2007 12:35:24 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Rene Herman <rene.herman@gmail.com>
Cc: Andrew Morton <akpm@osdl.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: New Mitsumi legacy CD-ROM driver
Message-ID: <20070508103524.GH4163@kernel.dk>
References: <464045F0.3040906@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464045F0.3040906@gmail.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08 2007, Rene Herman wrote:
> Good day.
> 
> This is (the start of) a new driver for the legacy Mitsumi CD-ROM (LU-00xS 
> and FX-001x) drives that used to be supported by drivers/cdrom/mcd(x).c, a 
> driver that hasn't worked for a long time.
> 
> It's being tested on my LU-005S and is being submitted to -mm in the hope 
> of maybe finding a few more testers and also in the hope of provoking a 
> review. I'm co-authoring this with Pekka Enberg but certainly for me it's 
> the first ever contact with anything having anything to do with block.
> 
> A few specific points/questions:
> 
> * This driver's core transfer function is doing:
> 
>   rq_for_each_bio(bio, req)
>       bio_for_each_segment(bvec, bio, segno) {
>           buffer = bvec_kmap_irq(bvec, &flags);
>           ioread8_rep(ioaddr, buffer, bvec->bv_len);
>           bvec_kunmap_irq(buffer, &flags);
>       }
> 			
> I've been slightly worried about struct bio having a bi_sector field. If 
> we're not guaranteed that bio[n].bi_sector == bio[n-1].bi_sector + 1 during 
> the rq_for_each_bio() loop we can't read from I/O into bio's directly but 
> will need to use a temporary buffer and transfer into the bio's later. Is 
> this guaranteed?

bio[n - 1].bi_sector + bio_sectors(bio[n - 1]) == bio[n].bi_sector

IOW, the bio's in the chain on the request are contig in the lba space.

> * This driver purports to support highmem. Given the number of machines out 
> there that have both a Mitsumi legacy CD-ROM drive and enough physical 
> memory installed to want highmem support this may come across as being 
> overly... optimistic but is there much point to not supporting it? I 
> believe we do always need the full rq_for_each_bio/bio_for_each_segment 
> loop meaning that only the bvec_k{,un}map_irq could go, right?

Yeah, I think it's pointless to support highmem. And as long as you
don't call blk_queue_bounce_limit() to actively enable highmem, you are
not going to receive a bio/request with highmem pages. The block layer
wil bounce any highmem pages before it reaches you. So for a driver like
this, I would recommend just forgetting the mapping aspect.

I don't have time to review your driver right now, but I will applaud
your effort to write a maintenable mitsumi driver! Basically all the old
cdrom drivers are utter crap, so they are destined for removal.

-- 
Jens Axboe

