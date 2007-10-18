Return-Path: <linux-kernel-owner+w=401wt.eu-S1764210AbXJRMDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764210AbXJRMDW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 08:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761811AbXJRMDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 08:03:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58423
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1761765AbXJRMDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 08:03:14 -0400
Date: Thu, 18 Oct 2007 05:03:27 -0700 (PDT)
Message-Id: <20071018.050327.59654383.davem@davemloft.net>
To: jens.axboe@oracle.com
Cc: bhalevy@panasas.com, torvalds@linux-foundation.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [bug] block subsystem related crash with latest -git
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071018105516.GT5063@kernel.dk>
References: <20071017182206.GS15552@kernel.dk>
	<47173B00.3070303@panasas.com>
	<20071018105516.GT5063@kernel.dk>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Axboe <jens.axboe@oracle.com>
Date: Thu, 18 Oct 2007 12:55:17 +0200

> Things have progressed a lot since, see my recent posting based on
> Davem's proposal. Will post another patch soonish, that is also
> tested.

One core issue here is that we need to decide whether this thing to be
iterated like an array or like a linked list.  It's trying to be both.

If we decide upon a looping construct for consumers and stick to it,
we'll be in much better shape than we are now and bugs will be eaiser
to spot.  It would be so much simpler to audit if all we saw in the
consumers were things like:

	while (sg) {
		do_stuff(sg);
		sg = sg_next(sg);
	}

I would suggest that we just get it over with and convert the whole
tree now rather than trying to do this kind of thing in stages.
Because then we can say that ever scatterlist creator has to set
the "end" bit and therefore you use well established patterns
for scatterlist iteration such as "traverse sg_next() until NULL"
as shown above.

I also noticed that there is the issue of on-stack and embedded
scatterlist users.  We'll need some sort of "DECLARE_SCATTERLIST"
and a "scatterlist_init()" thing so that we can keep DEBUG_SG
working even in those cases.  But for all I know Jens could be
working on that already :-)

The only other real option if we don't convert the whole tree now to
the "end" marker stuff, is to enforce that every scatterlist iterator
only traverse the number of entries there were told are in the one
given to them.
