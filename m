Return-Path: <linux-kernel-owner+w=401wt.eu-S1756769AbZAPGtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769AbZAPGtz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 01:49:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753476AbZAPGtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 01:49:43 -0500
Received: from brick.kernel.dk ([93.163.65.50]:26354 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753226AbZAPGtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 01:49:42 -0500
Date: Fri, 16 Jan 2009 07:48:18 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Grant Grundler <grundler@google.com>,
       Greg Freemyer <greg.freemyer@gmail.com>, Tejun Heo <htejun@gmail.com>,
       Michael Tokarev <mjt@tls.msk.ru>, Kay Sievers <kay.sievers@vrfy.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] block: export SSD/non-rotational queue flag through sysfs
Message-ID: <20090116064818.GS30821@kernel.dk>
References: <4964866D.8010503@msgid.tls.msk.ru> <1231342473.3282.19.camel@localhost.localdomain> <496ECBA0.60209@gmail.com> <87f94c370901150707h10506e99reaa40c23e32ab18c@mail.gmail.com> <1232035561.5966.48.camel@localhost.localdomain> <da824cf30901151055o2385ef74x918e8390e576d807@mail.gmail.com> <1232046039.5966.54.camel@localhost.localdomain> <da824cf30901151445q6b54c0b1nbf24f03849e1a5b3@mail.gmail.com> <1232061429.5966.87.camel@localhost.localdomain> <Pine.LNX.4.64.0901152341500.15035@blonde.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0901152341500.15035@blonde.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15 2009, Hugh Dickins wrote:
> On Thu, 15 Jan 2009, James Bottomley wrote:
> > 
> > OK, so they could be calculated on the fly in the elevators, I suppose.
> > But what would the value be?  Right now we use the nonrotational flag to
> > basically not bother with plugging (no point if no seek penalty) on
> > certain events where we'd previously have waited for other I/O to join.
> > But that's really a seek penalty parameter rather than the idea of read
> > or write costing (although the elevators usually track these dynamically
> > anyway ... as part of the latency calculations but not explicitly).
> 
> ... not bother with plugging (no point if no seek penalty) ...
> 
> I thought there was considerable advantage to plugging writes
> (in case they turn out to be adjacent) on current and older
> generations of non-rotational storage?

Don't confuse plugging and merging, although one does help the other.

We can essentially divide the current SSD market into two categories -
queuing and non-queuing. Which also happens to just about the same as
saying Intel and non-Intel, at least that has been the case since Sep
'08 and until present time. On the queuing devices, plugging does more
harm than good. The IO access time is so fast, that delaying for merging
hurts your performance.

For non-queuing devices, I think our current check is a bit too drastic.
We probably want to change that to

int dont_plug(q)
{
        return blk_queue_nonrot(q) && blk_queue_tagged(q);
}

Which is identical to what CFQ tests for idling to avoid read/write
overlaps which also completely kills performance on the current SSD
drives (except for Intel, which again shines).

-- 
Jens Axboe

