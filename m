Return-Path: <linux-kernel-owner+w=401wt.eu-S1753244AbYICK0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbYICK0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 06:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbYICK0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 06:26:07 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:46896 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111AbYICK0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 06:26:06 -0400
Date: Wed, 3 Sep 2008 12:26:01 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
       torvalds@osdl.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [2/2] Don't complain about disabled irqs when the system has paniced
Message-ID: <20080903102600.GP20055@kernel.dk>
References: <20080902349.573187695@firstfloor.org> <200809031937.46328.nickpiggin@yahoo.com.au> <20080903094815.GQ18288@one.firstfloor.org> <200809032017.42237.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809032017.42237.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03 2008, Nick Piggin wrote:
> > > For call_function_single, queueing could really help with high interrupt
> > > loads like the block completion migration that Jens has been looking at.
> >
> > But does it or not?
> 
> Well yes. It was basically impossible to implement without this IIRC,
> due to performance problems. And that code itself also showed some
> improvements in cases. I think it may need more tuning and testing.

The old code was useless for this, far too slow. With the new code I've
been able to demonstrate VERY good benefits from migrating interrupts,
both in synthetic cache locality benchmarks but also from something as
general as the compilebench test app (where reductions in system time
are as huge as 20-40%!). I hope to be able to share these results soon.
I have a rough profile from last week on XFS.

http://brick.kernel.dk/lock_rq0

vs

http://brick.kernel.dk/lock_rq1

rq0 is normal interrupt handling, rq1 is with rq_affinity set to 1 for
that block device queue. With that set, request completions are migrated
to the CPU that submitted them.

That is the whole reason why I got into generalizing the IPI function
call handling.

-- 
Jens Axboe

