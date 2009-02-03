Return-Path: <linux-kernel-owner+w=401wt.eu-S1758596AbZBCAqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758596AbZBCAqt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 19:46:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbZBCAqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 19:46:40 -0500
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:34650 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752770AbZBCAqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 19:46:40 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgMFAMcfh0lMQWt2/2dsb2JhbACBbssxhBQG
Date: Mon, 2 Feb 2009 19:46:32 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca
Subject: Re: [RFC PATCH] block: Fix bio merge induced high I/O latency
Message-ID: <20090203004632.GA17778@Krystal>
References: <20090117004439.GA11492@Krystal> <20090117162657.GA31965@Krystal> <20090117190437.GZ30821@kernel.dk> <20090118211234.GA4913@Krystal> <20090119182654.GT30821@kernel.dk> <20090120021055.GA6990@Krystal> <20090120073709.GC30821@kernel.dk> <20090120122855.GF30821@kernel.dk> <20090202020811.GA19565@Krystal> <20090202112600.GE30821@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090202112600.GE30821@kernel.dk>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:13:34 up 33 days, 11 min,  8 users,  load average: 0.74, 0.43,
	0.30
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jens Axboe (jens.axboe@oracle.com) wrote:
> It's also working around the real problem for this specific issue, which
> is that you just don't want to have sync apps blocked waiting for async
> writeout in the first place.
> 

Maybe I could help to identify criterion for such sync requests which
are treated as async. From a newcomer's look at the situation, I would
assume that :

- Small I/O requests
- I/O requests caused by major page faults, except those caused by
  access to mmapped files which result in large consecutive file
  reads/writes.

Should never *ever* fall into the async I/O request path. Am I correct ?
If yes, then I could trigger some tracing test cases and identify the
faulty scenarios with LTTng. Maybe the solution does not sit only within
the block I/O layer :

I guess we would also have to find out what is considered a "large" and
a "small" I/O request. I think using open() flags to specify if
I/O is expected to be synchronous or asynchronous for a particular file
would be a good start (AFAIK, only O_DIRECT seems to be close to this,
but it also has the side-effect of not using any kernel buffering, which
I am not sure is wanted in every case). If this implies adding new
flags to open(), then supporting older apps could be done by heuristics
on the size of the requests. New applications which have very specific
needs (e.g. large synchronous I/O) could be tuned with the new flags.
Any small request coming from the page fault handler would be treated as
synchronous. Requests coming from the page fault handler on a
particular mmapped file would behave following the sync/async flags of
the associated open(). If not flag is specified, the heuristic would
apply to the resulting merged requests from the page fault handler.
Therefore, large consecutive reads of mmapped files would fall in the
"async" category by default. mmap of shared libraries and memory mapping
done by exec() should clearly specify the "sync" flag, because those
accesses *will* cause delays when the application needs to be executed.

Hopefully what I am saying here makes sense. If you have links to some
background information to point me to so I get a better understanding of
how async vs sync requests are handled by the CFQ, I would greatly
appreciate.

Best regards,

Mathieu




-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
