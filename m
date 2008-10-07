Return-Path: <linux-kernel-owner+w=401wt.eu-S1756505AbYJGWWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505AbYJGWWe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 18:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754059AbYJGWWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 18:22:25 -0400
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:42936 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753808AbYJGWWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 18:22:25 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAMx760h5LGor/2dsb2JhbAC/T4Fq
X-IronPort-AV: E=Sophos;i="4.33,375,1220193000"; 
   d="scan'208";a="224313888"
Date: Wed, 8 Oct 2008 09:22:19 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Aaron Carroll <aaronc@gelato.unsw.edu.au>, Bodo Eggert <7eggert@gmx.de>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority
Message-ID: <20081007222219.GW30001@disturbed>
Mail-Followup-To: Jens Axboe <jens.axboe@oracle.com>,
	Aaron Carroll <aaronc@gelato.unsw.edu.au>,
	Bodo Eggert <7eggert@gmx.de>, Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arjan van de Ven <arjan@infradead.org>,
	linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <biosl-6bq-9@gated-at.bofh.it> <biqkw-aK-3@gated-at.bofh.it> <birgx-1pQ-9@gated-at.bofh.it> <bisPe-3xx-9@gated-at.bofh.it> <bisYW-3HQ-13@gated-at.bofh.it> <E1KlQ9s-0003Oh-Cz@be1.7eggert.dyndns.org> <20081002233426.GG30001@disturbed> <48E71EFC.7040403@gelato.unsw.edu.au> <20081006031829.GQ30001@disturbed> <20081007180652.GA19428@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081007180652.GA19428@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 08:06:53PM +0200, Jens Axboe wrote:
> On Mon, Oct 06 2008, Dave Chinner wrote:
> > On Sat, Oct 04, 2008 at 05:45:00PM +1000, Aaron Carroll wrote:
> > > Dave Chinner wrote:
> > >> On Thu, Oct 02, 2008 at 05:32:04PM +0200, Bodo Eggert wrote:
> > >>> Sounds like you need a priority class besides sync and async.
> > >>
> > >> There's BIO_META now as well, which I was testing at the same time
> > >> as RT priority. Marking all the metadata I/O as BIO_META did help,
> > >> but once again I never got to determining if that was a result of
> > >> the different tagging or the priority increase.
> > >
> > > What exactly do you want META to mean?  Strict prioritisation over
> > > all other non-META requests, or just more frequent and/or larger
> > > dispatches?  Should META requests be sorted?
> > 
> > The real question is "what was it supposed to mean"? AFAICT, it was
> > added to a couple of filesystems to be used to tag superblock read
> > I/O. Why - I don't know - there's a distinct lack of documentation
> > surrounding these bio flags. :/
> 
> It was added to be able to differentiate between data and meta data IO
> when using blktrace, that is all.

Ok.

> > Realistically, I'm not sure that having a separate queue for
> > BIO_META will buy us anything, given that noop is quite often the
> > fastest scheduler for XFS because it enables interleaved metadata
> > I/O to be merged with data I/O. Like I said, I was not able to spend
> > the time to determine exactly how BIO_META affected I/O patterns, so
> > I can't really comment on whether it is really necessary or not.
> 
> There's no seperate queue for meta data IO anywhere. CFQ will give
> _slight_ preference to meta data IO as a side effect, preferring the
> meta IO for otherwise same IO in what to serve next in the same queue.
> And it will not allow preemption of a meta data IO for a data IO.
> 
> So using meta should not yield any important boosts by itself.

Which means that performance increase I saw on CFQ was a result of
removing the BIO_SYNC tagging "optimisation" XFS uses for metadata,
not from adding BIO_META.....

Could you please document what these tags actually mean and do
so that other people don't get as confused as me about this
stuff....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
