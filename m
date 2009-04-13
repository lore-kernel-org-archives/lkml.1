Return-Path: <linux-kernel-owner+w=401wt.eu-S1752775AbZDMORQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbZDMORQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 10:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751550AbZDMORA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 10:17:00 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42705 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750802AbZDMOQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 10:16:59 -0400
Subject: Re: [PATCHSET pata-2.6] ide: rq->buffer, data, special and
	misc	cleanups
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, bharrosh@panasas.com,
       tj@kernel.org, petkovbb@gmail.com, bzolnier@gmail.com,
       linux-kernel@vger.kernel.org, axboe@kernel.dk,
       linux-ide@vger.kernel.org
In-Reply-To: <49E2F84C.6080804@garzik.org>
References: <49D214E7.2040908@panasas.com>
	 <20090413163957P.fujita.tomonori@lab.ntt.co.jp>
	 <49E2EFBE.5000709@garzik.org>
	 <20090413172143B.fujita.tomonori@lab.ntt.co.jp>
	 <49E2F84C.6080804@garzik.org>
Content-Type: text/plain
Date: Mon, 13 Apr 2009 14:16:58 +0000
Message-Id: <1239632218.3278.14.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-13 at 04:31 -0400, Jeff Garzik wrote:
> >> What is the multi-device problem with bio?
> > 
> > Well, if it works nicely, I guess that we don't have something like
> > drivers/dm/{dm-bio-record.h, dm-bio-list.h}, btrfs_multi_bio struct,
> > or md's own page carrier?
> 
> It was an honest question.  I am seeking information, not denying your 
> argument.

I think it wasn't quite designed like that.  The original designed
carrier of pages was the bio_vec array.   The bio was designed to carry
the bio_vec into the top end of block.  bio_vec is incredibly
lightweight (it's more like a scatterlist), but bio is a lot heavier and
now has a lot of quirky initialisers (like call backs and merge counts)
that need to be set correctly, making it a more difficult think to use
generically.   bio is really designed to be the merge unit for requests
not a generic carrier of pages.

The final irony is that most of the page list mappings we do want to go
straight to requests, making the bio complexity even more superfluous.

> What, specifically, is this multi-device problem with bio, please?

The multi device problem is that it's very hard to split a bio up again
once we've assembled it, so if you get a single bio whose I/O crosses
multiple devices in md or dm, there's a lot of work that has to go on
behind the scenes to get the split to happen because we need one bio per
underlying device that we send I/O to.

James


