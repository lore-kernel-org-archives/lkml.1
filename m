Return-Path: <linux-kernel-owner+w=401wt.eu-S1752496AbZH0MiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496AbZH0MiB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 08:38:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752438AbZH0MiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 08:38:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:42206 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752230AbZH0Mh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 08:37:59 -0400
Message-ID: <4A967DD7.20603@kernel.org>
Date: Thu, 27 Aug 2009 21:36:39 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk, jeff@garzik.org, dhowells@redhat.com
Subject: Re: [PATCH 0/3] Convert libata pio task to slow-work
References: <1251364122-9592-1-git-send-email-jens.axboe@oracle.com>
In-Reply-To: <1251364122-9592-1-git-send-email-jens.axboe@oracle.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 27 Aug 2009 12:36:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jens.

Jens Axboe wrote:
> Hi,
> 
> This patchset adds support for slow-work for delayed slow work and
> for cancelling slow work. Note that these patches are totally
> untested!

As what I'm currently working on is likely to collide with these
changes, here is a short summary of what's been going on.

/* excerpted from internal weekly work report and edited */

The principle is the same as I described before.  It hooks into the
scheduler using an alias scheduler class of sched_fair and gets
notifications of workqueue threads going into sleep, waking up and
getting preempted from which worker pool is managed automatically for
full concurrency with the least number of concurrent threads.

There's a global workqueue per-cpu and each actual workqueue is front
to the global one adding necessary attributes and/or defining a
flushing domain.  Each global workqueue can have multiple workers
(upto 128 in the current incarnation) and creates and kicks new ones
as necessary to keep the cpu occupied.

The diffcult part was teaching workqueue how to handle multiple
workers yet maintaining its exclusion properties, flushing rules and
forward progress guarantees - a single work can't be running
concurrently on the same cpu but can across different cpus,
flush_work() deals with single cpu flushing but others deal with all
the cpus and so on.  Because each work struct can't be accessed once
the work actually begins running, keeping track of things become
somewhat difficult as multiple workers now process works from a single
queue.  Anyways, after much head scratching, I think most problems
have been nailed down although I wouldn't know for sure till I get it
actually working.

There's slight more book keeping to do on each work-processing
iteration but overall I think it will be a win considering that it can
remove unnecessary task switchings, usage of different stacks (cache
foot-print) and cross-cpu work bouncing (for currently single threaded
workqueues).  If it really works as expected, it should be able to
replace async, [very]_slow_work and remove most of private workqueues
while losing no concurrency or forward-progress guarantees, which
would be pretty decent.

/**/

I finished first draft implementation and review pass yesterday and it
seems like there shouldn't be any major problem now but I haven't even
tried to compile it yet, so I'm not yet entirely sure how it would
eventually turn out and if I hit some major roadblock I might just
drop it.

It would be nice if merging of this series and the lazy work can be
held a bit but there's no harm in merging either.  If the concurrency
managed workqueue turns out to be a good idea, we can replace it then.

Thanks a lot.

-- 
tejun
