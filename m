Return-Path: <linux-kernel-owner+w=401wt.eu-S1754524AbZHTOMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbZHTOMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 10:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754379AbZHTOMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 10:12:41 -0400
Received: from fogou.chygwyn.com ([195.171.2.24]:54851 "EHLO fogou.chygwyn.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754205AbZHTOMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 10:12:40 -0400
X-Greylist: delayed 4396 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Aug 2009 10:12:40 EDT
Subject: Re: [PATCH 0/6] Lazy workqueues
From: Steven Whitehouse <steve@chygwyn.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       jeff@garzik.org, benh@kernel.crashing.org, htejun@gmail.com,
       bzolnier@gmail.com, alan@lxorguk.ukuu.org.uk,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <20090820122212.GC6069@nowhere>
References: <1250763604-24355-1-git-send-email-jens.axboe@oracle.com>
	 <20090820122212.GC6069@nowhere>
Content-Type: text/plain
Organization: ChyGwyn Limited (Registered in England and Wales, No.
 03887683) Registered Office: Digital Technium, Singleton Park, Swansea. SA2
 8PP
Date: Thu, 20 Aug 2009 13:59:10 +0100
Message-Id: <1250773150.3298.266.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 2009-08-20 at 14:22 +0200, Frederic Weisbecker wrote:
> On Thu, Aug 20, 2009 at 12:19:58PM +0200, Jens Axboe wrote:
> > (sorry for the resend, but apparently the directory had some patches
> >  in it already. plus, stupid git send-email doesn't default to
> >  no chain replies, really annoying)
> > 
> > Hi,
> > 
> > After yesterdays rant on having too many kernel threads and checking
> > how many I actually have running on this system (531!), I decided to 
> > try and do something about it.
> > 
> > My goal was to retain the workqueue interface instead of coming up with
> > a new scheme that required conversion (or converting to slow_work which,
> > btw, is an awful name :-). I also wanted to retain the affinity
> > guarantees of workqueues as much as possible.
> > 
> > So this is a first step in that direction, it's probably full of races
> > and holes, but should get the idea across. It adds a
> > create_lazy_workqueue() helper, similar to the other variants that we
> > currently have. A lazy workqueue works like a normal workqueue, except
> > that it only (by default) starts a core thread instead of threads for
> > all online CPUs. When work is queued on a lazy workqueue for a CPU
> > that doesn't have a thread running, it will be placed on the core CPUs
> > list and that will then create and move the work to the right target.
> > Should task creation fail, the queued work will be executed on the
> > core CPU instead. Once a lazy workqueue thread has been idle for a
> > certain amount of time, it will again exit.
> > 
> > The patch boots here and I exercised the rpciod workqueue and
> > verified that it gets created, runs on the right CPU, and exits a while
> > later. So core functionality should be there, even if it has holes.
> > 
> > With this patchset, I am now down to 280 kernel threads on one of my test
> > boxes. Still too many, but it's a start and a net reduction of 251
> > threads here, or 47%!
> > 
> > The code can also be pulled from:
> > 
> >   git://git.kernel.dk/linux-2.6-block.git workqueue
> > 
> > -- 
> > Jens Axboe
> 
> 
> That looks like a nice idea that may indeed solve the problem of thread
> proliferation with per cpu workqueue.
> 
> Now I think there is another problem that taint the workqueues from the
> beginning which is the deadlocks induced by one work that waits another
> one in the same workqueue. And since the workqueues are executing the jobs
> by serializing, the effect is deadlocks.
> 
In GFS2 we've also got an additional issue. We cannot create threads at
the point of use (or let pending work block on thread creation) because
it implies a GFP_KERNEL memory allocation which could call back into the
fs. This is a particular issue with journal recovery (which uses
slow_work now, older versions used a private thread) and the code which
deals with inodes which have been unlinked remotely.

In addition to that the glock workqueue which we are using would be much
better turned into a tasklet, or similar. The reason why we cannot do
this is that submission of block I/O is only possible from process
context. At some stage it might be possible to partially solve the
problem by separating the parts of the state machine which submit I/O
from those which don't, but I'm not convinced that effort it worth it.

There is also the issue of ordering of I/O requests. The glocks are (for
those which submit I/O) in a 1:1 relationship with inodes or resource
groups and thus indexed by disk block number. I have considered in the
past, creating a workqueue with an elevator based work submission
interface. This would greatly improve the I/O patterns created by
multiple submissions of glock work items. In particular it would make a
big difference when the glock shrinker marks dirty glocks for removal
from the glock cache (under memory pressure) or when processing large
numbers of remote callbacks.

I've not yet come to any conclusion as to whether the "elevator
workqueue" is a good idea or not, any suggestions of a better solution
are very welcome,

Steve.


