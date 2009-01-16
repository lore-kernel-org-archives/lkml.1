Return-Path: <linux-kernel-owner+w=401wt.eu-S1761119AbZAPAgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761119AbZAPAgb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 19:36:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbZAPAgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 19:36:21 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:35842 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752228AbZAPAgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 19:36:20 -0500
Subject: Re: [PATCH] block: export SSD/non-rotational queue flag through
	sysfs
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Grant Grundler <grundler@google.com>, Jens Axboe <jens.axboe@oracle.com>,
       Greg Freemyer <greg.freemyer@gmail.com>, Tejun Heo <htejun@gmail.com>,
       Michael Tokarev <mjt@tls.msk.ru>, Kay Sievers <kay.sievers@vrfy.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.64.0901152341500.15035@blonde.anvils>
References: <200901051952.58029.bzolnier@gmail.com>
	 <ac3eb2510901051347r6593d0fmd64702b1689716c1@mail.gmail.com>
	 <20090106073515.GY32491@kernel.dk> <4964866D.8010503@msgid.tls.msk.ru>
	 <1231342473.3282.19.camel@localhost.localdomain> <496ECBA0.60209@gmail.com>
	 <87f94c370901150707h10506e99reaa40c23e32ab18c@mail.gmail.com>
	 <1232035561.5966.48.camel@localhost.localdomain>
	 <da824cf30901151055o2385ef74x918e8390e576d807@mail.gmail.com>
	 <1232046039.5966.54.camel@localhost.localdomain>
	 <da824cf30901151445q6b54c0b1nbf24f03849e1a5b3@mail.gmail.com>
	 <1232061429.5966.87.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0901152341500.15035@blonde.anvils>
Content-Type: text/plain
Date: Thu, 15 Jan 2009 19:36:14 -0500
Message-Id: <1232066174.5966.92.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-15 at 23:50 +0000, Hugh Dickins wrote:
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

Heh, you get as many answers to that one as their are SSD manufacturers.
However, the consensus seems to be that all MLC and SLC flash has a RAID
like architecture internally, thus it can actually be *faster* if you
send multiple commands (each area of the RAID processes independently).
Of course, you have to be *able* to send multiple commands, so the
device must implement TCQ/NCQ, but if it does, it's actually beneficial
*not* to wait even if the requests are adjacent.

However, the reason the nonrotational flag is set from user space is
precisely so if we do find an SSD that has this property, we can just
not set the nonrotational queue flag.

James


