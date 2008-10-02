Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbYJBXgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbYJBXgB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 19:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755991AbYJBXef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 19:34:35 -0400
Received: from ipmail04.adl2.internode.on.net ([203.16.214.57]:25443 "EHLO
	ipmail04.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755974AbYJBXee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 19:34:34 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgkDAN/25Eh5LF82iGdsb2JhbACTWgEBARUiqVSBag
X-IronPort-AV: E=Sophos;i="4.33,353,1220193000"; 
   d="scan'208";a="219295595"
Date: Fri, 3 Oct 2008 09:34:26 +1000
From: Dave Chinner <david@fromorbit.com>
To: Bodo Eggert <7eggert@gmx.de>
Cc: Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority
Message-ID: <20081002233426.GG30001@disturbed>
Mail-Followup-To: Bodo Eggert <7eggert@gmx.de>,
	Jens Axboe <jens.axboe@oracle.com>,
	Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arjan van de Ven <arjan@infradead.org>,
	linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <bimJN-4cO-5@gated-at.bofh.it> <biosl-6bq-9@gated-at.bofh.it> <biqkw-aK-3@gated-at.bofh.it> <birgx-1pQ-9@gated-at.bofh.it> <bisPe-3xx-9@gated-at.bofh.it> <bisYW-3HQ-13@gated-at.bofh.it> <E1KlQ9s-0003Oh-Cz@be1.7eggert.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1KlQ9s-0003Oh-Cz@be1.7eggert.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2008 at 05:32:04PM +0200, Bodo Eggert wrote:
> Jens Axboe <jens.axboe@oracle.com> wrote:
> > On Thu, Oct 02 2008, Dave Chinner wrote:
> >> On Thu, Oct 02, 2008 at 09:55:11AM +0200, Jens Axboe wrote:
> 
> >> > Good point. I think we should mark the IO as sync, and maintain the same
> >> > priority level. Any IO that ends up being waited on is sync by
> >> > definition, we just need to expand the coverage a bit.
> >> 
> >> That's what XFS has always done - mark the journal I/O as sync.
> >> Still, once you load up the elevator, the sync I/O can still get
> >> delayed for hundreds of milliseconds before dispatch, which was
> >> why I started looking at boosting the priority of the log I/O.
> >> It proved to be much more effective at getting the log I/O
> >> dispatched than the existing "mark it sync" technique....
> > 
> > Sure, just marking it as sync is not a magic bullet. It'll be in the
> > first priority for that class, but it'll share bandwidth with other
> > processes. So if you have lots of IO going on, it can take hundreds of
> > miliseconds before being dispatched.
> 
> Sounds like you need a priority class besides sync and async.

There's BIO_META now as well, which I was testing at the same time
as RT priority. Marking all the metadata I/O as BIO_META did help,
but once again I never got to determining if that was a result of
the different tagging or the priority increase.

However, given that only CFQ understand BIO_META, I suspect that
changing the way XFS uses BIO_SYNC to be a combination of BIO_META
and BIO_SYNC would cause significant regressions on other
schedulers.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
