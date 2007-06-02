Return-Path: <linux-kernel-owner+w=401wt.eu-S1761341AbXFBPlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761341AbXFBPlg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 11:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760330AbXFBPl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 11:41:28 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:46496 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760029AbXFBPl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 11:41:28 -0400
Date: Sat, 2 Jun 2007 08:40:04 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Eric Dumazet <dada1@cosmosbay.com>,
       linux-kernel@vger.kernel.org, cotte@de.ibm.com, hugh@veritas.com,
       neilb@suse.de, zanussi@us.ibm.com, hch@infradead.org
Subject: Re: [PATCH] sendfile removal
In-Reply-To: <20070602150104.GH32105@kernel.dk>
Message-ID: <alpine.LFD.0.98.0706020836360.23741@woody.linux-foundation.org>
References: <20070531103316.GO32105@kernel.dk> <20070531124753.a99f713c.dada1@cosmosbay.com>
 <20070531105321.GQ32105@kernel.dk> <465F9BEF.20504@zytor.com>
 <20070601054120.GI32105@kernel.dk> <465FB3AD.5030807@zytor.com>
 <465FC92C.50608@cosmosbay.com> <466040C1.6030004@zytor.com>
 <alpine.LFD.0.98.0706010904110.3957@woody.linux-foundation.org>
 <20070602150104.GH32105@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 2 Jun 2007, Jens Axboe wrote:
>
> splice() WILL return EAGAIN, but in that case it should have triggered
> the read-ahead and thus started some IO.

That's not enough.

If the IO has already been started, splice needs to wait.

> For the from-file case, see __generic_file_splice_read(). splice does:
> 
>        if (!PageUptodate(page)) {
>                /*
>                 * If in nonblock mode then dont block on
>                 * waiting
>                 * for an in-flight io page
>                 */
>                if (flags & SPLICE_F_NONBLOCK) {
>                        if (TestSetPageLocked(page))
>                                break;
>                } else
>                        lock_page(page);

Yeah, that's just wrong.

Your suggested:

>       if ((flags & SPLICE_F_NONBLOCK) && spd.nr_pages) {
>               if (TestSetPageLocked(page))
>                       break;
>       } else
>               lock_page(page);
> 
> should do that - always block for the first page and potentially return
> a partial results for the remaining pages that read-ahead kicked into
> gear.

would work, but I suspect that for a server, returning EAGAIN once is 
actually the best option - if it has a select() loop, and something else 
is running, the "return EAGAIN once" actually makes tons of sense (it 
would basically boil down to the kernel effectively saying "ok, try 
anything else you might have pending in your queues first, if you get back 
to me, I'll block then").

		Linus
