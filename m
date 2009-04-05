Return-Path: <linux-kernel-owner+w=401wt.eu-S1757313AbZDETiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313AbZDETiP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 15:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757269AbZDEThw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 15:37:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44340 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757248AbZDEThu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 15:37:50 -0400
Date: Sun, 5 Apr 2009 12:34:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Arjan van de Ven <arjan@infradead.org>
cc: Theodore Tso <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [GIT PULL] Ext3 latency fixes
In-Reply-To: <20090405115629.521057fc@infradead.org>
Message-ID: <alpine.LFD.2.00.0904051227120.4023@localhost.localdomain>
References: <alpine.LFD.2.00.0904031150190.4015@localhost.localdomain> <alpine.LFD.2.00.0904031329410.7007@localhost.localdomain> <20090404135719.GA9812@mit.edu> <20090404151649.GE5178@kernel.dk> <alpine.LFD.2.00.0904040854470.3915@localhost.localdomain>
 <20090404173412.GF5178@kernel.dk> <alpine.LFD.2.00.0904041039230.3915@localhost.localdomain> <20090404180108.GH5178@kernel.dk> <20090404232222.GA7480@mit.edu> <20090404163349.20df1208@infradead.org> <20090405001005.GA7553@mit.edu>
 <alpine.LFD.2.00.0904050927580.4023@localhost.localdomain> <20090405115629.521057fc@infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 5 Apr 2009, Arjan van de Ven wrote:
>
> > See get_request():
> 
> our default number of requests is so low that we very regularly hit the
> limit. In addition to setting kjournald to higher priority, I tend to
> set the number of requests to 4096 or so to improve interactive
> performance on my own systems. That way at least the elevator has a
> chance to see the requests ;-)

That's insane. Long queues make the problem harder to hit, yes. But it 
also tends to make the problem them a million times worse when you _do_ 
hit it.

I would suggest looking instead at trying to have separate allocation 
pools for bulk and "sync" IO. Instead of having just one rq->rq_pool, we 
could easily have a rq->rq_bulk_pool and rq->rq_sync_pool.

We might even _save_ memory by having two pools simply because that may 
make it much less important to have a big pool. Most subsystems don't 
really need that many requests in flight anyway, and the advantage to the 
elevator of huge pools is rather dubious.

So you obviously need more requests than the hardware can have in flight 
(since you want to be able to feed the hardware new requests and overlap 
the refill with the ones executing), but 4096 sounds excessive if you're 
doing something like SATA that can only have 32 actual outstanding 
requests at the hardware.

But yes, if a synchronous request gets blocked just because we've already 
used all the requests, latency will be suffer. 

			Linus
